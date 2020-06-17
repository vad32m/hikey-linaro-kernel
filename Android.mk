LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_ARCH),arm64)
    KERNEL_CROSS_COMPILE := aarch64-linux-android-
else
    $(error TARGET_ARCH=$(TARGET_ARCH) but only arm64 is supported)
endif

KBUILD_FLAGS := -j4

KERNEL_DEFCONFIG := hikey960_defconfig

KERNEL_SRC      := $(LOCAL_PATH)
KERNEL_BUILD    := $(PRODUCT_OUT)/obj/KERNEL

KERNEL_OUT := $(KERNEL_BUILD)/arch/$(TARGET_ARCH)/boot
KERNEL_IMG := $(KERNEL_OUT)/Image.gz
KERNEL_DTB := $(KERNEL_OUT)/dts/hisilicon/hi3660-hikey960.dtb

.PHONY: kernel-config kernel-build

kernel-build: kernel-config
	@echo Building kernel
	$(MAKE) -C $(KERNEL_BUILD) ARCH=$(TARGET_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) $(KBUILD_FLAGS)

kernel-config:
	$(MAKE) -C $(KERNEL_SRC) O=$$(readlink -f $(KERNEL_BUILD)) ARCH=$(TARGET_ARCH) $(KERNEL_DEFCONFIG)


$(TARGET_PREBUILT_KERNEL): kernel-build
	cp $(KERNEL_IMG) $@

$(TARGET_PREBUILT_DTB): kernel-build
	cp $(KERNEL_DTB) $@
