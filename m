Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DC61D5ABA
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 02:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784772817; cv=none; b=hHIsHwSl0eW5hRCGzBXZ7rm3Sqneyo9w5nquvslT2d9H36blt4gmTI9ILZaRHxP7WpXrPBQ2ZYAkISrTr9mprzKqVZGY8abgdwCppzhczJyB5QJx/9TvbSbFzhUXB1J/u/o7oSLO9Lmz8bdn4khYjfkCxJFdgNsLerE9/QsTnsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784772817; c=relaxed/simple;
	bh=L5HOlVvLRdBzYzPvL3rrPSH+TscvX61iiHIQrvilbAw=;
	h=In-Reply-To:Content-Type:To:Cc:Date:Mime-Version:From:Subject:
	 Message-Id:References; b=sTrTXPTBu7ZCWUr4jZhohMi5jCe8gXBG98/qg+dlU8vZlETpcGJl5kRPm2lFCvHzUZF619Oj4QhSMPCMV58a4Nmtx2llx5SIwcP3b629SdDy4Z2tAfAodhCIqmIdXxAGXRbnPLwvAbEcrDP/NeA38msZV3uW1uxhcv/6xfwHzds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=i4iPgRYJ; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="i4iPgRYJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1784772799;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=L4vagEndn1IyeeDUqfWTZSR3NzYSHQbgr0h6/J9mSuk=;
 b=i4iPgRYJFwkt7hbSY0HwpY0UmXCzQiAFu9aEqpNE2gP6JvZavEh2RcFtuDIIachRyNPRM2
 aKNNXPxfcv1PNjxUJWPqtRq2clOfzEiv9sADe1ElroxA8HH6RBmZfRSPUFEUIEi+5ggnE7
 HpfdtBJI9S7r70OO4g6Qqiszb0J5992P/FFbJIyNfHBsq7hSH9tvpyOg5Fz6MgsxMvKjxi
 t0jOyDDRelqvQXl+MfJ7ufsGpT3ee3KJu2HUcWGxuyQWVMrLToRf4lqab6hp+pmQNUkdZE
 XPpHrkj5KdVLFSvkZ2Pc7ROS8qulaWaX+aWVhS1P/ctJyrhOJ6g5/+RiY4gDrQ==
In-Reply-To: <cover.1784724170.git.yanli.yang@bedmex.com>
Content-Type: text/plain; charset=UTF-8
To: <linux-wireless@vger.kernel.org>
Cc: "Johannes Berg" <johannes@sipsolutions.net>, 
	"Zhirun Liu" <zhirunliu@aicsemi.com>, "Dijia Xu" <dijiaxu@aicsemi.com>, 
	"Chunqiu Liu" <chunqiuliu@aicsemi.com>, 
	"Liheng Wei" <liheng.wei@bedmex.com>
Date: Thu, 23 Jul 2026 10:13:09 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Yanli Yang" <yanli.yang@bedmex.com>
Subject: [RFC PATCH wireless-next v2 1/4] wifi: aic: add SDIO BSP and build configuration
X-Mailer: git-send-email 2.34.1
Message-Id: <38b783b43d20c972d638ad8de17c46cf3b079113.1784724170.git.yanli.yang@bedmex.com>
Received: from bmxpxe-virtual-desktop.. ([36.141.79.164]) by smtp.feishu.cn with ESMTPS; Thu, 23 Jul 2026 10:13:16 +0800
X-Lms-Return-Path: <lba+26a6178bd+162da7+vger.kernel.org+yanli.yang@bedmex.com>
References: <cover.1784724170.git.yanli.yang@bedmex.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yanli Yang <yanli.yang@bedmex.com>

From: Zhirun Liu <zhirunliu@aicsemi.com>

Add the vendor, BSP and FullMAC build descriptions together with
the shared SDIO BSP, firmware loader and BSP chipset support. Keep parent
wireless build integration in the final patch.

Signed-off-by: Zhirun Liu <zhirunliu@aicsemi.com>
Signed-off-by: Yanli Yang <yanli.yang@bedmex.com>
---
 drivers/net/wireless/aic/Kconfig              |  135 ++
 drivers/net/wireless/aic/Makefile             |   17 +
 drivers/net/wireless/aic/aic8800_bsp/Kconfig  |   97 +
 drivers/net/wireless/aic/aic8800_bsp/Makefile |   42 +
 .../aic/aic8800_bsp/aic8800d80_compat.c       |  290 +++
 .../aic/aic8800_bsp/aic8800d80_compat.h       |   11 +
 .../aic/aic8800_bsp/aic8800dc_compat.c        | 1342 +++++++++++
 .../aic/aic8800_bsp/aic8800dc_compat.h        |   40 +
 .../wireless/aic/aic8800_bsp/aic_bsp_driver.c | 1679 ++++++++++++++
 .../wireless/aic/aic8800_bsp/aic_bsp_driver.h |  624 +++++
 .../wireless/aic/aic8800_bsp/aic_bsp_export.h |   70 +
 .../wireless/aic/aic8800_bsp/aic_bsp_main.c   |  556 +++++
 .../aic/aic8800_bsp/aic_chip_8800d80.c        |  116 +
 .../aic/aic8800_bsp/aic_chip_8800dc.c         |  133 ++
 .../wireless/aic/aic8800_bsp/aic_chip_8801.c  |  117 +
 .../wireless/aic/aic8800_bsp/aic_chip_ops.c   |   77 +
 .../wireless/aic/aic8800_bsp/aic_chip_ops.h   |   71 +
 .../net/wireless/aic/aic8800_bsp/aicsdio.c    | 2020 +++++++++++++++++
 .../net/wireless/aic/aic8800_bsp/aicsdio.h    |  176 ++
 .../wireless/aic/aic8800_bsp/aicsdio_txrxif.c |  465 ++++
 .../wireless/aic/aic8800_bsp/aicsdio_txrxif.h |  180 ++
 .../aic/aic8800_bsp/aicwf_txq_prealloc.c      |   72 +
 .../aic/aic8800_bsp/aicwf_txq_prealloc.h      |    8 +
 drivers/net/wireless/aic/aic8800_bsp/md5.c    |  165 ++
 drivers/net/wireless/aic/aic8800_bsp/md5.h    |   77 +
 .../aic/aic8800_bsp/rwnx_version_gen.h        |    5 +
 drivers/net/wireless/aic/aic8800_fdrv/Kconfig |  539 +++++
 .../net/wireless/aic/aic8800_fdrv/Makefile    |  117 +
 28 files changed, 9241 insertions(+)
 create mode 100644 drivers/net/wireless/aic/Kconfig
 create mode 100644 drivers/net/wireless/aic/Makefile
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/Kconfig
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/Makefile
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic8800d80_compat.=
c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic8800d80_compat.=
h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic8800dc_compat.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic8800dc_compat.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_bsp_export.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_bsp_main.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_chip_8800d80.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_chip_8800dc.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_chip_8801.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_chip_ops.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_chip_ops.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicsdio.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicsdio.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicsdio_txrxif.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicsdio_txrxif.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicwf_txq_prealloc=
.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicwf_txq_prealloc=
.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/md5.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/md5.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/rwnx_version_gen.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/Kconfig
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/Makefile

diff --git a/drivers/net/wireless/aic/Kconfig b/drivers/net/wireless/aic/Kc=
onfig
new file mode 100644
index 0000000000000..ed62a5f2d9333
--- /dev/null
+++ b/drivers/net/wireless/aic/Kconfig
@@ -0,0 +1,135 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config WLAN_VENDOR_AIC
+	bool "AIC devices"
+	default y
+	help
+	  Say Y to expose drivers for wireless devices based on AIC
+	  chipsets. The individual bus and WLAN drivers remain separately
+	  selectable below this vendor menu. Saying N hides those driver
+	  questions without changing any unrelated wireless drivers.
+
+if WLAN_VENDOR_AIC
+
+menuconfig AIC8800_BSP_SUPPORT
+	tristate "AIC8800 SDIO bus support"
+	depends on MMC
+	help
+	  Enable the AIC8800 bus support package. It provides the SDIO
+	  transport, chip operations and firmware download infrastructure
+	  shared by the AIC8800 FullMAC WLAN driver.
+	  Firmware files are loaded from the aic8800/ subdirectory of the
+	  kernel firmware search path, normally /lib/firmware/aic8800/.
+
+	  If unsure, say N.
+
+if AIC8800_BSP_SUPPORT
+
+# The current driver only implements an SDIO transport. Keep this internal
+# symbol for the existing Makefile and C preprocessor conditionals.
+config AIC8800_SDIO_SUPPORT
+	def_bool y
+
+menu "AIC8800 common firmware and transport options"
+
+config AIC8800_SDIO_PWRCTRL
+	bool "SDIO power control"
+	default y
+	help
+	  Allow the driver to control the SDIO interface power state while
+	  bringing the AIC device up and down. The BSP coordinates this
+	  state with firmware download and the WLAN function. This is the
+	  normal setting for supported AIC8800 SDIO modules.
+
+	  If unsure, say Y.
+
+config AIC8800_GPIO_WAKEUP
+	bool "GPIO wakeup support"
+	default y
+	help
+	  Enable a dedicated GPIO signal for device-to-host wakeup. The
+	  signal lets the device wake the host without polling the SDIO
+	  bus. Board wiring and firmware must both provide the wake signal.
+	  Disable this when the board has no dedicated wake GPIO.
+
+	  If unsure, say Y.
+
+config AIC8800_OOB
+	bool "Out-of-band interrupt support"
+	depends on AIC8800_GPIO_WAKEUP
+	help
+	  Use a dedicated GPIO interrupt instead of the in-band SDIO
+	  interrupt. The GPIO must be described by the platform and wired
+	  to the AIC device interrupt output. This mode is only suitable
+	  for boards whose firmware and hardware use out-of-band signaling.
+
+config AIC8800_PREALLOC_TXQ
+	bool "Preallocate TX queues"
+	default y
+	help
+	  Preallocate transmit queue buffers during driver initialization.
+	  This avoids data-path allocations after the interface starts and
+	  can reduce latency under memory pressure. It also reserves the
+	  queue memory for the lifetime of the driver.
+
+	  If unsure, say Y.
+
+config AIC8800_DPD
+	bool "DPD calibration support"
+	default y
+	help
+	  Enable Digital Pre-Distortion calibration support for radio
+	  transmit-path linearization. The driver loads or generates DPD
+	  data expected by supported firmware. Keep this enabled for boards
+	  whose supplied firmware requires DPD calibration data.
+
+	  If unsure, say Y.
+
+config AIC8800_FORCE_DPD_CALIB
+	bool "Force DPD calibration"
+	depends on AIC8800_DPD
+	default y
+	help
+	  Force DPD calibration instead of using existing calibration data.
+	  This makes initialization regenerate the result even when stored
+	  calibration data is available. It increases startup work but can
+	  be useful while validating a new board or radio configuration.
+
+config AIC8800_RESV_MEM_SUPPORT
+	bool "Reserved memory support"
+	default y
+	help
+	  Enable the driver's reserved-memory allocation path for transport
+	  buffers. Platforms may use this to avoid allocating large buffers
+	  during device initialization. The reserved area must be supplied
+	  by the platform integration when this option is selected.
+
+	  If unsure, say Y.
+
+config AIC8800_SDIO_BT
+	bool "Bluetooth over SDIO support"
+	depends on BROKEN
+	help
+	  Enable the downstream Bluetooth transport sharing the Wi-Fi SDIO
+	  interface. The retained implementation uses interfaces that are
+	  not available to a current mainline kernel. It remains disabled
+	  until it is converted to the upstream Bluetooth HCI interfaces.
+
+config AIC8800_VRF_DCDC_MODE
+	bool "VRF DCDC mode"
+	default y
+	help
+	  Configure the chipset's VRF rail to use its internal DC-DC mode.
+	  This affects radio power delivery and must agree with the module
+	  and board power design. The standard supported configuration uses
+	  the internal converter. Check the board design before changing it.
+
+	  If unsure, say Y.
+
+endmenu
+
+source "drivers/net/wireless/aic/aic8800_bsp/Kconfig"
+source "drivers/net/wireless/aic/aic8800_fdrv/Kconfig"
+
+endif # AIC8800_BSP_SUPPORT
+endif # WLAN_VENDOR_AIC
diff --git a/drivers/net/wireless/aic/Makefile b/drivers/net/wireless/aic/M=
akefile
new file mode 100644
index 0000000000000..247f7fbbc83b4
--- /dev/null
+++ b/drivers/net/wireless/aic/Makefile
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_AIC8800_WLAN_SUPPORT) +=3D aic8800_fdrv/
+obj-$(CONFIG_AIC8800_BSP_SUPPORT) +=3D aic8800_bsp/
+
+ccflags-$(CONFIG_AIC8800_SDIO_SUPPORT)       +=3D -DAICWF_SDIO_SUPPORT
+ccflags-$(CONFIG_AIC8800_SDIO_PWRCTRL)       +=3D -DCONFIG_SDIO_PWRCTRL
+ccflags-$(CONFIG_AIC8800_GPIO_WAKEUP)        +=3D -DCONFIG_GPIO_WAKEUP
+ccflags-$(CONFIG_AIC8800_OOB)                +=3D -DCONFIG_OOB
+ccflags-$(CONFIG_AIC8800_PREALLOC_TXQ)       +=3D -DCONFIG_PREALLOC_TXQ
+ccflags-$(CONFIG_AIC8800_PREALLOC_RX_SKB)    +=3D -DCONFIG_PREALLOC_RX_SKB
+ccflags-$(CONFIG_AIC8800_DPD)                +=3D -DCONFIG_DPD
+ccflags-$(CONFIG_AIC8800_FORCE_DPD_CALIB)    +=3D -DCONFIG_FORCE_DPD_CALIB
+ccflags-$(CONFIG_AIC8800_RESV_MEM_SUPPORT)   +=3D -DCONFIG_RESV_MEM_SUPPOR=
T
+ccflags-$(CONFIG_AIC8800_SDIO_BT)            +=3D -DCONFIG_SDIO_BT
+ccflags-$(CONFIG_AIC8800_FDRV_NO_REG_SDIO)   +=3D -DCONFIG_FDRV_NO_REG_SDI=
O
+ccflags-$(CONFIG_AIC8800_VRF_DCDC_MODE)      +=3D -DCONFIG_VRF_DCDC_MODE
diff --git a/drivers/net/wireless/aic/aic8800_bsp/Kconfig b/drivers/net/wir=
eless/aic/aic8800_bsp/Kconfig
new file mode 100644
index 0000000000000..858685c9cf8ca
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/Kconfig
@@ -0,0 +1,97 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+menu "AIC8800 BSP options"
+
+config AIC8800_BSP_M2D_OTA_AUTO
+	bool "M2D OTA auto support"
+	default n
+	help
+	  Enable automatic M2D (Module-to-Device) over-the-air firmware
+	  update support. When enabled, the driver will automatically
+	  handle firmware download and update from the host to the device
+	  over the SDIO interface.
+
+	  If unsure, say N.
+
+config AIC8800_BSP_M2D_OTA_LZMA
+	bool "M2D OTA LZMA support"
+	depends on AIC8800_BSP_M2D_OTA_AUTO
+	default n
+	help
+	  Enable LZMA compression support for M2D over-the-air firmware
+	  updates. This reduces the size of firmware images transferred
+	  over the SDIO bus at the cost of additional CPU time for
+	  decompression.
+
+	  If unsure, say N.
+
+config AIC8800_BSP_LINK_DET_5G
+	bool "5G link detect"
+	default y
+	help
+	  Enable 5 GHz band link detection support. When enabled, the
+	  driver performs additional link quality monitoring on the 5 GHz
+	  band to detect and recover from link degradation.
+
+	  If unsure, say Y.
+
+config AIC8800_BSP_AMSDU_RX
+	bool "AMSDU receive"
+	default n
+	help
+	  Enable A-MSDU (Aggregate MAC Service Data Unit) receive support
+	  at the BSP layer. This allows the SDIO transport layer to handle
+	  aggregated frames, improving receive throughput for large data
+	  transfers.
+
+	  If unsure, say N.
+
+config AIC8800_BSP_IRQ_FALL
+	bool "Falling edge IRQ"
+	depends on AIC8800_GPIO_WAKEUP
+	default n
+	help
+	  Use falling edge trigger for SDIO interrupts instead of the
+	  default rising edge. Some platform designs require falling edge
+	  IRQ configuration due to hardware signal inversion.
+
+	  Only enable this if your hardware design requires it.
+
+	  If unsure, say N.
+
+config AIC8800_BSP_CUSTOM_PWF
+	bool "Custom power waveform"
+	depends on AIC8800_BSP_PLATFORM_EXTERNAL && BROKEN
+	default n
+	help
+	  Enable custom power waveform configuration for the AIC8800
+	  chipset. This allows fine-tuning of power delivery parameters
+	  for specific hardware designs that require non-standard power
+	  profiles.
+
+	  If unsure, say N.
+
+config AIC8800_BSP_TEDIOUS_PRT
+	bool "Verbose print log"
+	default n
+	help
+	  Enable verbose debug logging in the BSP layer. When enabled,
+	  detailed SDIO bus transactions, firmware loading progress, and
+	  chip operation traces are printed to the kernel log.
+
+	  This is intended for development and debugging only.
+
+	  If unsure, say N.
+
+config AIC8800_BSP_PLATFORM_EXTERNAL
+	bool "External platform"
+	default n
+	help
+	  Enable support for external (non-integrated) platform
+	  configurations. This option enables code paths required when
+	  the AIC8800 chipset is used on a development board or external
+	  adapter rather than an integrated system-on-module design.
+
+	  If unsure, say N.
+
+endmenu
diff --git a/drivers/net/wireless/aic/aic8800_bsp/Makefile b/drivers/net/wi=
reless/aic/aic8800_bsp/Makefile
new file mode 100644
index 0000000000000..3d915020d742a
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/Makefile
@@ -0,0 +1,42 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_AIC8800_BSP_SUPPORT) +=3D aic8800_bsp.o
+
+aic8800_bsp-y :=3D \
+	aic_chip_8801.o \
+	aic_chip_8800dc.o \
+	aic_chip_8800d80.o \
+	aic_chip_ops.o \
+	aic8800dc_compat.o \
+	aic8800d80_compat.o \
+	aic_bsp_main.o \
+	aic_bsp_driver.o \
+	aicsdio.o \
+	aicsdio_txrxif.o \
+	md5.o
+
+aic8800_bsp-$(CONFIG_AIC8800_PREALLOC_TXQ) +=3D aicwf_txq_prealloc.o
+
+ccflags-y +=3D -I$(src)/../aic8800_fdrv
+
+ccflags-$(CONFIG_AIC8800_SDIO_SUPPORT) +=3D -DAICWF_SDIO_SUPPORT
+ccflags-$(CONFIG_AIC8800_SDIO_PWRCTRL) +=3D -DCONFIG_SDIO_PWRCTRL
+
+ccflags-$(CONFIG_AIC8800_GPIO_WAKEUP) +=3D -DCONFIG_GPIO_WAKEUP
+ccflags-$(CONFIG_AIC8800_BSP_M2D_OTA_AUTO) +=3D -DCONFIG_M2D_OTA_AUTO_SUPP=
ORT
+ccflags-$(CONFIG_AIC8800_BSP_M2D_OTA_LZMA) +=3D -DCONFIG_M2D_OTA_LZMA_SUPP=
ORT
+ccflags-$(CONFIG_AIC8800_BSP_LINK_DET_5G) +=3D -DCONFIG_LINK_DET_5G
+
+ccflags-$(CONFIG_AIC8800_FDRV_NO_REG_SDIO) +=3D -DCONFIG_FDRV_NO_REG_SDIO
+ccflags-$(CONFIG_AIC8800_VRF_DCDC_MODE) +=3D -DCONFIG_VRF_DCDC_MODE
+ccflags-$(CONFIG_AIC8800_OOB) +=3D -DCONFIG_OOB
+ccflags-$(CONFIG_AIC8800_PREALLOC_TXQ) +=3D -DCONFIG_PREALLOC_TXQ
+ccflags-$(CONFIG_AIC8800_DPD) +=3D -DCONFIG_DPD
+ccflags-$(CONFIG_AIC8800_FORCE_DPD_CALIB) +=3D -DCONFIG_FORCE_DPD_CALIB
+ccflags-$(CONFIG_AIC8800_RESV_MEM_SUPPORT) +=3D -DCONFIG_RESV_MEM_SUPPORT
+ccflags-$(CONFIG_AIC8800_BSP_AMSDU_RX) +=3D -DCONFIG_AMSDU_RX
+ccflags-$(CONFIG_AIC8800_BSP_IRQ_FALL) +=3D -DCONFIG_IRQ_FALL
+ccflags-$(CONFIG_AIC8800_SDIO_BT) +=3D -DCONFIG_SDIO_BT
+ccflags-$(CONFIG_AIC8800_BSP_PLATFORM_EXTERNAL) +=3D -DCONFIG_PLATFORM_EXT=
ERNAL
+ccflags-$(CONFIG_AIC8800_BSP_CUSTOM_PWF) +=3D -DCONFIG_CUSTOM_PWF
+ccflags-$(CONFIG_AIC8800_BSP_TEDIOUS_PRT) +=3D -DCONFIG_TEDIOUS_PRT
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic8800d80_compat.c b/dri=
vers/net/wireless/aic/aic8800_bsp/aic8800d80_compat.c
new file mode 100644
index 0000000000000..0c3ed50dc7862
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic8800d80_compat.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief 8800d80 chip config
+ *
+ *************************************************************************=
*****
+ */
+
+#include "aic8800d80_compat.h"
+#include "aic_bsp_driver.h"
+
+extern struct aicbsp_info_t aicbsp_info;
+
+typedef u32 (*array2_tbl_t)[2];
+
+#define AIC_PATCH_MAGIG_NUM   0x48435450 // "PTCH"
+#define AIC_PATCH_MAGIG_NUM_2 0x50544348 // "HCTP"
+#define AIC_PATCH_BLOCK_MAX   4
+
+struct aic_patch_t {
+	u32 magic_num;
+	u32 pair_start;
+	u32 magic_num_2;
+	u32 pair_count;
+	u32 block_dst[AIC_PATCH_BLOCK_MAX];
+	u32 block_src[AIC_PATCH_BLOCK_MAX];
+	u32 block_size[AIC_PATCH_BLOCK_MAX]; // word count
+};
+
+//#define AIC_PATCH_OFST(mem) ((size_t)&((struct aic_patch_t *)0)->(mem))
+#define AIC_PATCH_OFST(mem) offsetof(struct aic_patch_t, mem)
+#define AIC_PATCH_ADDR(mem) ((u32)(aic_patch_str_base + AIC_PATCH_OFST(mem=
)))
+
+static u32 aicbsp_syscfg_tbl_8800d80[][2] =3D {};
+
+int aicbsp_system_config_8800d80(struct aic_sdio_dev *sdiodev)
+{
+	int syscfg_num =3D sizeof(aicbsp_syscfg_tbl_8800d80) / sizeof(u32) / 2;
+	int ret, cnt;
+
+	for (cnt =3D 0; cnt < syscfg_num; cnt++) {
+		ret =3D rwnx_send_dbg_mem_write_req(sdiodev,
+						  aicbsp_syscfg_tbl_8800d80[cnt][0],
+						  aicbsp_syscfg_tbl_8800d80[cnt][1]);
+		if (ret) {
+			pr_err("%x write fail: %d\n", aicbsp_syscfg_tbl_8800d80[cnt][0],
+			       ret);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static u32 adaptivity_patch_tbl_8800d80[][2] =3D {
+	{0x000C, 0x0000320A}, // linkloss_thd
+	{0x009C, 0x00000000}, // ac_param_conf
+	{0x0168, 0x00010000}, // tx_adaptivity_en
+};
+
+#define USER_CHAN_MAX_TXPWR_EN_FLAG (0x01U << 1)
+#define USER_TX_USE_ANA_F_FLAG      (0x01U << 2)
+
+#define CFG_USER_CHAN_MAX_TXPWR_EN 1
+#define CFG_USER_TX_USE_ANA_F      0
+
+#define CFG_USER_EXT_FLAGS_EN                                             =
     \
+	(CFG_USER_CHAN_MAX_TXPWR_EN || CFG_USER_TX_USE_ANA_F)
+
+static u32 patch_tbl_8800d80[][2] =3D {
+#ifdef AIC8800_USE_5G
+	{0x00b4, 0xf3010001},
+#else
+	{0x00b4, 0xf3010000},
+#endif
+#if defined(CONFIG_AMSDU_RX)
+	{0x170, 0x0100000a},
+#endif
+#ifdef CONFIG_IRQ_FALL
+	{0x00000170, 0x0000010a}, // irqf
+#endif
+
+#if CFG_USER_EXT_FLAGS_EN
+	{0x0188, 0x00000001
+#if CFG_USER_CHAN_MAX_TXPWR_EN
+				 | USER_CHAN_MAX_TXPWR_EN_FLAG
+#endif
+#if CFG_USER_TX_USE_ANA_F
+				 | USER_TX_USE_ANA_F_FLAG
+#endif
+	}, // user_ext_flags
+#endif
+};
+
+#ifdef CONFIG_OOB
+// for 8800d40/d80     map data1 isr to gpiob1
+static u32 gpio_cfg_tbl_8800d40d80[][2] =3D {
+	{0x40504084, 0x00000006}, {0x40500040, 0x00000000},
+	{0x40100030, 0x00000001}, {0x40241020, 0x00000001},
+	{0x40240030, 0x00000004}, {0x40240020, 0x03020700},
+};
+#endif
+
+int aicwifi_sys_config_8800d80(struct aic_sdio_dev *sdiodev)
+{
+#ifdef CONFIG_OOB
+	int ret, cnt;
+	int gpiocfg_num =3D sizeof(gpio_cfg_tbl_8800d40d80) / sizeof(u32) / 2;
+
+	for (cnt =3D 0; cnt < gpiocfg_num; cnt++) {
+		ret =3D rwnx_send_dbg_mem_write_req(sdiodev,
+						  gpio_cfg_tbl_8800d40d80[cnt][0],
+						  gpio_cfg_tbl_8800d40d80[cnt][1]);
+		if (ret) {
+			pr_err("%x write fail: %d\n", gpio_cfg_tbl_8800d40d80[cnt][0], ret);
+			return ret;
+		}
+	}
+#endif
+
+	return 0;
+}
+
+#define NEW_PATCH_BUFFER_MAP 1
+
+int aicwifi_patch_config_8800d80(struct aic_sdio_dev *sdiodev)
+{
+	const u32 rd_patch_addr =3D RAM_FMAC_FW_ADDR + 0x0198;
+	u32 aic_patch_addr;
+	u32 config_base, aic_patch_str_base;
+#if (NEW_PATCH_BUFFER_MAP)
+	u32 patch_buff_addr, patch_buff_base, rd_version_addr, rd_version_val;
+#endif
+	u32 start_addr =3D 0x0016F800;
+	u32 patch_addr =3D start_addr;
+	u32 patch_cnt =3D sizeof(patch_tbl_8800d80) / sizeof(u32) / 2;
+	struct dbg_mem_read_cfm rd_patch_addr_cfm;
+	int ret =3D 0;
+	int cnt =3D 0;
+	// adap test
+	int adap_patch_cnt =3D 0;
+
+	if (aicbsp_info.adap_test) { //(adap_test) {
+		pr_info("%s for adaptivity test \r\n", __func__);
+		adap_patch_cnt =3D sizeof(adaptivity_patch_tbl_8800d80) / sizeof(u32) / =
2;
+	}
+
+	aic_patch_addr =3D rd_patch_addr + 8;
+
+	ret =3D
+		rwnx_send_dbg_mem_read_req(sdiodev, rd_patch_addr, &rd_patch_addr_cfm);
+	if (ret) {
+		pr_info("patch rd fail\n");
+		return ret;
+	}
+
+	config_base =3D rd_patch_addr_cfm.memdata;
+
+	ret =3D
+		rwnx_send_dbg_mem_read_req(sdiodev, aic_patch_addr, &rd_patch_addr_cfm);
+	if (ret) {
+		pr_info("patch str rd fail\n");
+		return ret;
+	}
+	aic_patch_str_base =3D rd_patch_addr_cfm.memdata;
+
+#if (NEW_PATCH_BUFFER_MAP)
+	rd_version_addr =3D RAM_FMAC_FW_ADDR + 0x01C;
+	ret =3D rwnx_send_dbg_mem_read_req(sdiodev, rd_version_addr,
+					 &rd_patch_addr_cfm);
+	if (ret) {
+		pr_err("version val[0x%x] rd fail: %d\n", rd_version_addr, ret);
+		return ret;
+	}
+	rd_version_val =3D rd_patch_addr_cfm.memdata;
+	pr_info("AICWF rd_version_val=3D%08X\n", rd_version_val);
+	sdiodev->fw_version_uint =3D rd_version_val;
+	if (rd_version_val > 0x06090100) {
+		patch_buff_addr =3D rd_patch_addr + 12;
+		ret =3D rwnx_send_dbg_mem_read_req(sdiodev, patch_buff_addr,
+						 &rd_patch_addr_cfm);
+		if (ret) {
+			pr_err("patch buf rd fail\n");
+			return ret;
+		}
+		patch_buff_base =3D rd_patch_addr_cfm.memdata;
+		start_addr =3D patch_buff_base;
+		patch_addr =3D start_addr;
+	}
+#endif
+
+	ret =3D rwnx_send_dbg_mem_write_req(sdiodev, AIC_PATCH_ADDR(magic_num),
+					  AIC_PATCH_MAGIG_NUM);
+	if (ret) {
+		pr_err("0x%x write fail\n", AIC_PATCH_ADDR(magic_num));
+		return ret;
+	}
+
+	ret =3D rwnx_send_dbg_mem_write_req(sdiodev, AIC_PATCH_ADDR(magic_num_2),
+					  AIC_PATCH_MAGIG_NUM_2);
+	if (ret) {
+		pr_err("0x%x write fail\n", AIC_PATCH_ADDR(magic_num_2));
+		return ret;
+	}
+
+	ret =3D rwnx_send_dbg_mem_write_req(sdiodev, AIC_PATCH_ADDR(pair_start),
+					  patch_addr);
+	if (ret) {
+		pr_err("0x%x write fail\n", AIC_PATCH_ADDR(pair_start));
+		return ret;
+	}
+
+	ret =3D rwnx_send_dbg_mem_write_req(sdiodev, AIC_PATCH_ADDR(pair_count),
+					  patch_cnt + adap_patch_cnt);
+	if (ret) {
+		pr_err("0x%x write fail\n", AIC_PATCH_ADDR(pair_count));
+		return ret;
+	}
+
+	for (cnt =3D 0; cnt < patch_cnt; cnt++) {
+		ret =3D rwnx_send_dbg_mem_write_req(sdiodev, start_addr + 8 * cnt,
+						  patch_tbl_8800d80[cnt][0] +
+						  config_base);
+		if (ret) {
+			pr_err("%x write fail\n", start_addr + 8 * cnt);
+			return ret;
+		}
+		ret =3D rwnx_send_dbg_mem_write_req(sdiodev, start_addr + 8 * cnt + 4,
+						  patch_tbl_8800d80[cnt][1]);
+		if (ret) {
+			pr_err("%x write fail\n", start_addr + 8 * cnt + 4);
+			return ret;
+		}
+	}
+
+	if (aicbsp_info.adap_test) {
+		int tmp_cnt =3D patch_cnt + adap_patch_cnt;
+
+		for (cnt =3D patch_cnt; cnt < tmp_cnt; cnt++) {
+			int tbl_idx =3D cnt - patch_cnt;
+
+			ret =3D rwnx_send_dbg_mem_write_req(sdiodev, start_addr + 8 * cnt,
+							  adaptivity_patch_tbl_8800d80[tbl_idx][0]
+							  + config_base);
+			if (ret) {
+				pr_err("%x write fail\n", start_addr + 8 * cnt);
+				return ret;
+			}
+			ret =3D rwnx_send_dbg_mem_write_req(sdiodev, start_addr + 8 * cnt + 4,
+							  adaptivity_patch_tbl_8800d80[tbl_idx][1]);
+			if (ret) {
+				pr_err("%x write fail\n", start_addr + 8 * cnt + 4);
+				return ret;
+			}
+		}
+	}
+
+	ret =3D
+		rwnx_send_dbg_mem_write_req(sdiodev, AIC_PATCH_ADDR(block_size[0]), 0);
+	if (ret) {
+		pr_err("block_size[0x%x] write fail: %d\n",
+		       AIC_PATCH_ADDR(block_size[0]), ret);
+		return ret;
+	}
+	ret =3D
+		rwnx_send_dbg_mem_write_req(sdiodev, AIC_PATCH_ADDR(block_size[1]), 0);
+	if (ret) {
+		pr_err("block_size[0x%x] write fail: %d\n",
+		       AIC_PATCH_ADDR(block_size[1]), ret);
+		return ret;
+	}
+	ret =3D
+		rwnx_send_dbg_mem_write_req(sdiodev, AIC_PATCH_ADDR(block_size[2]), 0);
+	if (ret) {
+		pr_err("block_size[0x%x] write fail: %d\n",
+		       AIC_PATCH_ADDR(block_size[2]), ret);
+		return ret;
+	}
+	ret =3D
+		rwnx_send_dbg_mem_write_req(sdiodev, AIC_PATCH_ADDR(block_size[3]), 0);
+	if (ret) {
+		pr_err("block_size[0x%x] write fail: %d\n",
+		       AIC_PATCH_ADDR(block_size[3]), ret);
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic8800d80_compat.h b/dri=
vers/net/wireless/aic/aic8800_bsp/aic8800d80_compat.h
new file mode 100644
index 0000000000000..a22e440b09a66
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic8800d80_compat.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _AIC8800D80_COMPAT_H_
+#define _AIC8800D80_COMPAT_H_
+
+#include "aicsdio.h"
+
+int aicbsp_system_config_8800d80(struct aic_sdio_dev *sdiodev);
+int aicwifi_sys_config_8800d80(struct aic_sdio_dev *sdiodev);
+int aicwifi_patch_config_8800d80(struct aic_sdio_dev *sdiodev);
+
+#endif
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic8800dc_compat.c b/driv=
ers/net/wireless/aic/aic8800_bsp/aic8800dc_compat.c
new file mode 100644
index 0000000000000..e3f05fc41376d
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic8800dc_compat.c
@@ -0,0 +1,1342 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief 8800dc chip config
+ *
+ *************************************************************************=
*****
+ */
+
+#include "aic8800dc_compat.h"
+#include "aic_bsp_driver.h"
+#include <linux/version.h>
+
+u8 chip_sub_id;
+u8 chip_mcu_id;
+
+static u32 syscfg_tbl_8800dc[][2] =3D {
+	{0x40500010, 0x00000004}, {0x40500010, 0x00000006}, // 160m clk
+};
+
+static u32 syscfg_tbl_8800dc_sdio_u01[][2] =3D {
+	{0x40030000, 0x00036724}, // loop forever after assert_err
+	{0x0011E800, 0xE7FE4070}, {0x40030084, 0x0011E800},
+	{0x40030080, 0x00000001}, {0x4010001C, 0x00000000},
+};
+
+static u32 syscfg_tbl_8800dc_sdio_u02[][2] =3D {
+	{0x40030000, 0x00036DA4}, // loop forever after assert_err
+	{0x0011E800, 0xE7FE4070}, {0x40030084, 0x0011E800},
+	{0x40030080, 0x00000001}, {0x4010001C, 0x00000000},
+};
+
+#ifdef CONFIG_OOB
+static u32 oobcfg_tbl_8800dc_sdio_u02[][2] =3D {
+	{0x40504044, 0x2}, // oob_enable
+	{0x40500060, 0x03020700}, {0x40500040, 0},        {0x40100030, 1},
+	{0x40241020, 1},          {0x402400f0, 0x340022},
+};
+#endif // CONFIG_OOB
+
+static u32 syscfg_tbl_masked_8800dc[][3] =3D {
+// #ifdef CONFIG_PMIC_SETTING
+#if defined(CONFIG_VRF_DCDC_MODE)
+	{0x7000216C, (0x3 << 2), (0x1 << 2)}, // pmic_pmu_init
+	{0x700021BC, (0x3 << 2), (0x1 << 2)},
+	{0x70002118, ((0x7 << 4) | (0x1 << 7)), ((0x2 << 4) | (0x1 << 7))},
+	{0x70002104, ((0x3F << 0) | (0x1 << 6)), ((0x2 << 0) | (0x1 << 6))},
+	{0x7000210C, ((0x3F << 0) | (0x1 << 6)), ((0x2 << 0) | (0x1 << 6))},
+	{0x70002170, (0xF << 0), (0x1 << 0)},
+	{0x70002190, (0x3F << 0), (24 << 0)},
+	{0x700021CC, ((0x7 << 4) | (0x1 << 7)), ((0x0 << 4) | (0x0 << 7))},
+	{0x700010A0, (0x1 << 11), (0x1 << 11)},
+	{0x70001034, ((0x1 << 20) | (0x7 << 26)), ((0x0 << 20) | (0x2 << 26))},
+	{0x70001038, (0x1 << 8), (0x1 << 8)},
+	{0x70001094, (0x3 << 2), (0x0 << 2)},
+	{0x700021D0, ((0x1 << 5) | (0x1 << 6)), ((0x1 << 5) | (0x1 << 6))},
+	{0x70001000, ((0x1 << 0) | (0x1 << 20) | (0x1 << 22)),
+	 ((0x1 << 0) | (0x1 << 20) | (0x0 << 22))},
+	{0x70001028, (0xf << 2), (0x1 << 2)},
+#else
+	{0x7000216C, (0x3 << 2), (0x1 << 2)}, // pmic_pmu_init
+	{0x700021BC, (0x3 << 2), (0x1 << 2)},
+	{0x70002118, ((0x7 << 4) | (0x1 << 7)), ((0x2 << 4) | (0x1 << 7))},
+	{0x70002104, ((0x3F << 0) | (0x1 << 6)), ((0x2 << 0) | (0x1 << 6))},
+	{0x7000210C, ((0x3F << 0) | (0x1 << 6)), ((0x2 << 0) | (0x1 << 6))},
+	{0x70002170, (0xF << 0), (0x1 << 0)},
+	{0x70002190, (0x3F << 0), (24 << 0)},
+	{0x700021CC, ((0x7 << 4) | (0x1 << 7)), ((0x0 << 4) | (0x0 << 7))},
+	{0x700010A0, (0x1 << 11), (0x1 << 11)},
+	{0x70001034, ((0x1 << 20) | (0x7 << 26)), ((0x0 << 20) | (0x2 << 26))},
+	{0x70001038, (0x1 << 8), (0x1 << 8)},
+	{0x70001094, (0x3 << 2), (0x0 << 2)},
+	{0x700021D0, ((0x1 << 5) | (0x1 << 6)), ((0x1 << 5) | (0x1 << 6))},
+	{0x70001000, ((0x1 << 0) | (0x1 << 20) | (0x1 << 22)),
+	 ((0x0 << 0) | (0x1 << 20) | (0x0 << 22))},
+	{0x70001028, (0xf << 2), (0x1 << 2)},
+#endif
+	// #endif /* CONFIG_PMIC_SETTING */
+	{0x00000000, 0x00000000, 0x00000000}, // last one
+};
+
+static u32 syscfg_tbl_masked_8800dc_h[][3] =3D {
+	{0x7000216C, ((0x3 << 2) | (0x3 << 4)),
+	 ((0x2 << 2) | (0x2 << 4))}, // pmic_pmu_init
+	{0x70002138, (0xFF << 0), (0xFF << 0)},
+	{0x7000213C, (0xFF << 0), (0xFF << 0)},
+	{0x70002144, (0xFF << 0), (0xFF << 0)},
+	{0x700021BC, (0x3 << 2), (0x1 << 2)},
+	{0x70002118, ((0x7 << 4) | (0x1 << 7)), ((0x2 << 4) | (0x1 << 7))},
+	{0x70002104, ((0x3F << 0) | (0x1 << 6)), ((0x2 << 0) | (0x1 << 6))},
+	{0x7000210C, ((0x3F << 0) | (0x1 << 6)), ((0x2 << 0) | (0x1 << 6))},
+	{0x70002170, (0xF << 0), (0x1 << 0)},
+	{0x70002190, (0x3F << 0), (24 << 0)},
+	{0x700021CC, ((0x7 << 4) | (0x1 << 7)), ((0x0 << 4) | (0x0 << 7))},
+	{0x700010A0, (0x1 << 11), (0x1 << 11)},
+	//{0x70001034, ((0x1 << 20) | (0x7 << 26)), ((0x0 << 20) | (0x2 << 26))},
+	{0x70001038, (0x1 << 8), (0x1 << 8)},
+	{0x70001094, (0x3 << 2), (0x0 << 2)},
+	{0x700021D0, ((0x1 << 5) | (0x1 << 6)), ((0x1 << 5) | (0x1 << 6))},
+#if defined(CONFIG_VRF_DCDC_MODE)
+	{0x70001000, ((0x1 << 0) | (0x1 << 20) | (0x1 << 22)),
+	 ((0x1 << 0) | (0x1 << 20) | (0x0 << 22))},
+#else
+	{0x70001000, ((0x1 << 0) | (0x1 << 20) | (0x1 << 22)),
+	 ((0x0 << 0) | (0x1 << 20) | (0x0 << 22))},
+#endif
+	{0x70001028, (0xf << 2), (0x1 << 2)},
+
+	{0x00000000, 0x00000000, 0x00000000}, // last one
+};
+
+static u32 syscfg_tbl_masked_8800dc_u01[][3] =3D {
+	// #ifdef CONFIG_PMIC_SETTING
+	{0x70001000, (0x1 << 16), (0x1 << 16)}, // for low temperature
+	{0x70001028, (0x1 << 6), (0x1 << 6)},
+	{0x70001000, (0x1 << 16), (0x0 << 16)},
+	// #endif /* CONFIG_PMIC_SETTING */
+};
+
+static u32 patch_tbl_wifisetting_8800dc_u01[][2] =3D {{0x010c, 0x01001E01}=
};
+
+static u32 patch_tbl_wifisetting_8800dc_u02[][2] =3D {
+#if defined(CONFIG_SDIO_PWRCTRL)
+	{0x0124, 0x01011E01}
+#else
+	{0x0124, 0x01001E01}
+#endif
+};
+
+static u32 ldpc_cfg_ram[] =3D {
+	0x00767679, 0x1DF8F870, 0x1DF8F870, 0x1DF8F870, 0x1DF8F870, 0x006E6E72,
+	0x1DF8F869, 0x1DF8F869, 0x1DF8F869, 0x1DF8F869, 0x0076767B, 0x1DF8F870,
+	0x1DF8F870, 0x1DF8F870, 0x1DF8F870, 0x007E7E85, 0x1DF4F876, 0x1DF4F876,
+	0x1DF4F876, 0x1DF8F876, 0x0081818A, 0x1DF8F87B, 0x1DF8F87B, 0x1DF8F87B,
+	0x1DF8F87B, 0x0081818D, 0x1DF8F87B, 0x1DF8F87B, 0x1DF8F87B, 0x1DF8F87B,
+	0x0081818A, 0x1DF8F87B, 0x1DF8F87C, 0x1DF8F87B, 0x1DF8F87B, 0x007E7E40,
+	0x1DF8F87B, 0x1DF8F87B, 0x1DF8F87B, 0x1DF8F87B, 0x008B8B92, 0x1DF8F887,
+	0x1DF8F889, 0x1DF8F887, 0x1DF8F887, 0x00515155, 0x1DF8F84C, 0x1DF8F84C,
+	0x1DF8F889, 0x1DF8F889, 0x00515154, 0x1DF8F84C, 0x1DF8F84C, 0x1DF8F888,
+	0x1DF8F888, 0x004F4F53, 0x1DF8F84A, 0x1DF8F84A, 0x1DF8F84A, 0x1DF8F84A,
+	0x004F4F53, 0x1DF8F84A, 0x1DF8F84A, 0x1DF8F84A, 0x1DF8F84A, 0x004F4F53,
+	0x1DF8F84A, 0x1DF8F84A, 0x1DF8F84A, 0x1DF8F84A, 0x004E4E53, 0x1DF8F849,
+	0x1DF8F848, 0x1DF8F848, 0x1DF8F848, 0x004D4D52, 0x1DF8F847, 0x1DF8F847,
+	0x1DF8F847, 0x1DF8F847, 0x004F4F55, 0x1DF8F84B, 0x1DF8F84A, 0x1DF8F84A,
+	0x1DF8F84A, 0x004E4E53, 0x1DF8F849, 0x1DF8F848, 0x1DF8F848, 0x1DF8F848,
+	0x0049494D, 0x1DF8F844, 0x1DF8F844, 0x1DF8F844, 0x1DF8F844, 0x0051518F,
+	0x1DF8F849, 0x1DF8F848, 0x1DF8F848, 0x1DF8F848, 0x00424277, 0x1DF8F83F,
+	0x1DF8F83C, 0x1DF8F83C, 0x1DF8F83C, 0x00424275, 0x1DF8F89E, 0x1DF8F83C,
+	0x1DF8F83C, 0x1DF8F83C, 0x0055555C, 0x1DF8F84C, 0x1DF8F84C, 0x1DF8F84C,
+	0x1DF8F84C, 0x0053535C, 0x1DF8F84C, 0x1DF8F84B, 0x1DF8F84B, 0x1DF8F84B,
+	0x00F8F89E, 0x1DF8F88C, 0x1DF8F84A, 0x1DF8F84A, 0x1DF8F84A, 0x00898940,
+	0x18F8F846, 0x18CFF845, 0x18CFF844, 0x18CFF844, 0x0056565F, 0x1DF8F84F,
+	0x1DF8F84F, 0x1DF8F84F, 0x1DF8F84F, 0x0055555E, 0x1DF8F84E, 0x1DF8F84E,
+	0x1DF8F84E, 0x1DF8F84E, 0x0056565F, 0x1DF8F84F, 0x1DF8F84F, 0x1DF8F84F,
+	0x1DF8F84F, 0x00555561, 0x1DF8F850, 0x1DF8F84E, 0x1DF8F84E, 0x1DF8F84E,
+	0x0053535F, 0x1DF8F84D, 0x1DF8F84C, 0x1DF8F84C, 0x1DF8F84C, 0x0055555F,
+	0x1DF8F84F, 0x1DF8F84E, 0x1DF8F84E, 0x1DF8F84E, 0x005555AA, 0x1DF8F854,
+	0x1DF8F84E, 0x1DF8F84E, 0x1DF8F84E, 0x005959A6, 0x1DF8F84D, 0x1DF8F84C,
+	0x1DF8F84C, 0x1DF8F84C, 0x004F4F9B, 0x1DF8F84E, 0x1DF8F846, 0x1DF8F846,
+	0x1DF8F846, 0x00F8F8A5, 0x1DF8F894, 0x1DF8F84C, 0x1DF8F84C, 0x1DF8F84C,
+	0x009898A4, 0x1DF8F84D, 0x1DF8F84C, 0x1DF8F84C, 0x1DF8F84C, 0x00464686,
+	0x1DF8F8B3, 0x1DF8F83D, 0x1DF8F83D, 0x1DF8F83D, 0x008E8E40, 0x1AF8F848,
+	0x1ADFF848, 0x1ADFF846, 0x1ADFF846, 0x007F7F40, 0x18D2D275, 0x18D2D23A,
+	0x18D2D23A, 0x18D2D239, 0x00454540, 0x0F868664, 0x0F86863E, 0x0F86863D,
+	0x0F86863D, 0x005C5C64, 0x1DF8F856, 0x1DF8F855, 0x1DF8F855, 0x1DF8F855,
+	0x005B5B68, 0x1DF8F858, 0x1DF8F855, 0x1DF8F855, 0x1DF8F855, 0x005A5A64,
+	0x1DF8F855, 0x1DF8F854, 0x1DF8F854, 0x1DF8F854, 0x005A5AB5, 0x1DF8F85B,
+	0x1DF8F855, 0x1DF8F854, 0x1DF8F854, 0x00F8F8B0, 0x1DF8F8A3, 0x1DF8F852,
+	0x1DF8F852, 0x1DF8F852, 0x00A4A4AE, 0x1DF8F854, 0x1DF8F852, 0x1DF8F852,
+	0x1DF8F852, 0x009A9A40, 0x1DF8F84E, 0x1DF8F84D, 0x1DF8F84C, 0x1DF8F84C,
+	0x009C9C40, 0x1DF8F895, 0x1DF8F849, 0x1DF8F84A, 0x1DF8F84A, 0x00494940,
+	0x1197976F, 0x11979742, 0x11979741, 0x11979741, 0x006E6E74, 0x1DF8F869,
+	0x1DF8F869, 0x1DF8F869, 0x1DF8F869, 0x006E6E40, 0x1ADEF869, 0x1ADEF869,
+	0x1ADEF869, 0x1ADEF869, 0x00757540, 0x0D78F86E, 0x0D78F86E, 0x0D78F86E,
+	0x0D79F86E, 0x00787885, 0x1DF8F873, 0x1DF8F873, 0x1DF8F873, 0x1DF8F873,
+	0x00787840, 0x1DF8F873, 0x1DF8F873, 0x1DF8F873, 0x1DF8F873, 0x00787840,
+	0x0E81F873, 0x0E81F873, 0x0E81F873, 0x0E82F873, 0x00404040, 0x0E82F873,
+	0x0E82F873, 0x0E82F873, 0x0E82F873, 0x00818140, 0x1092F87E, 0x1092F87E,
+	0x1092F87E, 0x1092F87E, 0x00404040, 0x1092F87E, 0x1092F87E, 0x1092F87E,
+	0x1092F87E, 0x00737340, 0x14B2B26B, 0x14B2B235, 0x14B2B235, 0x14B2B235,
+	0x00404040, 0x0E828260, 0x0E82823D, 0x0E82823C, 0x0E82823C, 0x00404040,
+	0x0F8B8B66, 0x0F8B8B3F, 0x0F8B8B3D, 0x0F8B8B3D, 0x00404040, 0x0B68683D,
+	0x0B68681E, 0x0B68681E, 0x0B68681E, 0x00222240, 0x06434318, 0x06434329,
+	0x06434318, 0x06434318, 0x00404040, 0x129D9D72, 0x129D9D43, 0x129D9D41,
+	0x129D9D41, 0x00404040, 0x0D757542, 0x0D757520, 0x0D757520, 0x0D757520,
+	0x00232340, 0x084C4C19, 0x084C4C2C, 0x084C4C19, 0x084C4C19
+};
+
+static u32 agc_cfg_ram[] =3D {
+	0x20000000, 0x0400000E, 0x3000200E, 0x5B000000, 0x0400004B, 0x3000008E,
+	0x32000000, 0x0400007B, 0x40000000, 0xF8000026, 0x04000011, 0x4819008E,
+	0x9C000020, 0x08000191, 0x38008000, 0x0A000000, 0x08104411, 0x38018000,
+	0x0C004641, 0x08D00014, 0x30000000, 0x01000000, 0x04000017, 0x30000000,
+	0x3C000000, 0x0400001A, 0x38020000, 0x40000001, 0x0800001D, 0x3808008E,
+	0x14000050, 0x08000020, 0x4000008E, 0xA400007B, 0x00000101, 0x3000339F,
+	0x41000700, 0x04104420, 0x90000000, 0x49000000, 0xF00E842F, 0xEC0E842C,
+	0xEC0E842C, 0x04000032, 0x30000000, 0x48000101, 0x04000032, 0x30000000,
+	0x48000202, 0x04000032, 0x30000000, 0x46000000, 0x04000011, 0x58010006,
+	0x3D040472, 0xDC204439, 0x081DD4D2, 0x480A0006, 0xDC2044DC, 0x081DD43C,
+	0x38050004, 0x0EF1F1C3, 0x342044DC, 0x30000000, 0x01000000, 0x04000042,
+	0x30000000, 0x33000000, 0x04104445, 0x38008000, 0x2200109C, 0x08104448,
+	0x38008000, 0x23D4509C, 0x08104417, 0x9000A000, 0x32000000, 0x18000063,
+	0x14000060, 0x1C000051, 0x10000057, 0x38028000, 0x0C000001, 0x08D04466,
+	0x3000200F, 0x00000000, 0x00000000, 0x38030000, 0x0C002601, 0x08D0445A,
+	0x30000000, 0x3D020230, 0x0400005D, 0x30000000, 0x3E000100, 0x04000066,
+	0x38028000, 0x0C001601, 0x34204466, 0x38028000, 0x0C000A01, 0x34204466,
+	0x38008004, 0xFF000000, 0x0800007B, 0x3800802F, 0x26000000, 0x0800006C,
+	0x380404AF, 0x1F191010, 0x0800006F, 0x20000CAF, 0x04000071, 0x60000CAF,
+	0x18700079, 0x14000077, 0x10000075, 0x28140CAF, 0x09B00084, 0x280A0CAF,
+	0x09B00084, 0x28060CAF, 0x09B00084, 0x28048086, 0x0800007D, 0x38000086,
+	0x22800000, 0x04000080, 0x30000000, 0x0EF1F101, 0x36004883, 0x28020000,
+	0x08000085, 0x3802008E, 0x3D040431, 0x08000088, 0x3805008E, 0x1F241821,
+	0x0800008B, 0x3000008E, 0xA0163021, 0x0400008E, 0x3000008E, 0x0EF10012,
+	0x34000091, 0x300000CC, 0x50000000, 0x04000094, 0x380095FE, 0x32010000,
+	0x04000097, 0x50001FFE, 0x5A010000, 0x6DC9989B, 0xFC19D4B9, 0x30000186,
+	0x3D840373, 0x0400009E, 0x3000008E, 0x0A000000, 0x040000A1, 0x3000008E,
+	0x22C00000, 0x040000A4, 0x9000028E, 0x32010001, 0x8E4000AA, 0xC80000B0,
+	0x00000000, 0x00000000, 0x3000008E, 0x32010001, 0x040000CB, 0x3000008E,
+	0x29000000, 0x94045011, 0x300019B6, 0x32010000, 0x040000B3, 0x300019B6,
+	0x3D040431, 0x040000B6, 0x300019B6, 0x22800000, 0x04000097, 0x30000186,
+	0x3D840473, 0x040000BC, 0x3000008E, 0x29030000, 0x040000BF, 0x9AEE028E,
+	0x32010100, 0x7C0000C5, 0xCC0000B0, 0x080000B0, 0x00000000, 0x3000008E,
+	0x32010100, 0x040000C8, 0x3000028E, 0x29000000, 0x94045011, 0x5000038E,
+	0x29000000, 0x94045011, 0xC0000035, 0x38010006, 0x3D040472, 0x080000D2,
+	0x30000004, 0x0EF1F141, 0x340000D5, 0x28040004, 0x080000D7, 0x2808000E,
+	0x080000D9, 0x3000018E, 0x0EF10052, 0x340000DC, 0x3000038E, 0x29000000,
+	0x94045011, 0x38020000, 0x32000000, 0x080000E2, 0x60000000, 0xD80000E6,
+	0xD40000E9, 0x040000EC, 0x30000000, 0x0EF1F121, 0x360048EF, 0x30000000,
+	0x0C002421, 0x360048EF, 0x30000000, 0x0C000021, 0x360048EF, 0x28020000,
+	0x0800007B, 0x50001EFE, 0x5A010000, 0x6DC998F5, 0xFC19D4F8, 0x3000028E,
+	0x32000040, 0x040000FB, 0x3AEE028E, 0x32000080, 0x040000FB, 0x30000000,
+	0x0EF1F101, 0x360048FE, 0x28020000, 0x08000100, 0x3802008E, 0x3D040431,
+	0x08000103, 0x3805008E, 0x1F241821, 0x08000106, 0x3000008E, 0xA0163021,
+	0x04000109, 0x3000008E, 0x0EF10012, 0x3400010C, 0x300014F6, 0x32010000,
+	0x04000114, 0x20000000, 0x04000111, 0x300000EC, 0x50000000, 0x040000F1,
+	0x300014F6, 0x32030000, 0x04000117, 0x30001086, 0x3D840473, 0x0400011A,
+	0x5000108E, 0x22C00000, 0x8E47C0CB, 0xCB30011E, 0x300019B6, 0x32040000,
+	0x04000121, 0x300019B6, 0x3D040431, 0x04000124, 0x300019B6, 0x22800000,
+	0x04000111, 0x00000000, 0x00000000, 0x00000000, 0x30000186, 0x3D840473,
+	0x0400012D, 0x5000038E, 0x29000000, 0x94045011, 0xC0000131, 0x380C800E,
+	0xFF000000, 0x08000134, 0x30000004, 0x0FF1F103, 0x34000137, 0x28020000,
+	0x08000139, 0x3000038E, 0x29000000, 0x94045011, 0x00000000, 0x00000000,
+	0x00000000, 0x58010006, 0x3D040472, 0xDC204543, 0x081DD4D2, 0x480A0006,
+	0xDC2044DC, 0x081DD546, 0x38050004, 0x0EF1F141, 0x342044DC, 0x2802800E,
+	0x080000DC, 0x48000035, 0x0400014A, 0x7896638F, 0x4100000F, 0x8C00014F,
+	0x080450C4, 0x90104574, 0x88C8620F, 0xC000015A, 0x90104574, 0x08104554,
+	0x94104557, 0x3000628F, 0x29000000, 0x9404517A, 0x3000638F, 0x29000000,
+	0x0410457A, 0x3800E005, 0x3D010131, 0x0810455D, 0xA832600F, 0x90104574,
+	0x08000154, 0x94104557, 0xC6104567, 0xC4185563, 0x5802E00F, 0x0FEEEA07,
+	0x80000174, 0x3420456B, 0x5802E00F, 0x0EEEEA07, 0x80000174, 0x3420456B,
+	0x30004000, 0x33000001, 0x0400016E, 0x38034005, 0x3D030373, 0x08000171,
+	0x30006007, 0x33000000, 0x04000174, 0x3000608F, 0x29000000, 0x94045177,
+	0x4000608F, 0xA010457D, 0x0410457A, 0x3000608F, 0x64000101, 0x04104411,
+	0x3000608F, 0x64000101, 0x04104580, 0x3000618F, 0x42000001, 0x04000183,
+	0x38028000, 0x32000000, 0x08104586, 0x280A618F, 0x08000188, 0x480A618F,
+	0xBC00018B, 0x0800018E, 0x3000618F, 0x34000001, 0x04000005, 0x3000618F,
+	0x34000000, 0x04000008, 0x3000008F, 0x0EEAED0F, 0x36000194, 0x38038000,
+	0x34000000, 0x08000197, 0x38028005, 0x29010002, 0x0800019A, 0x3000028F,
+	0x2200209C, 0x0400019D, 0x3000028F, 0x23D4509C, 0x040001A0, 0x2814028F,
+	0x080001A2, 0x3000028F, 0x43010201, 0x040001A5, 0x3000128F, 0x32000100,
+	0x040001A8, 0x5AEE138F, 0x4100000F, 0x7C0001AC, 0x080000F9, 0x592C138F,
+	0x29000000, 0x8C0001B0, 0x080000F9, 0x2000138F, 0x94045011, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000};
+
+static u32 txgain_map[96] =3D {
+#ifdef CONFIG_FPGA_VERIFICATION
+	0x20c0c971, 0x20c0c980, 0x20c0c992, 0x20c0c9a6, 0x20c0c9bf, 0x20c0caa5,
+	0x20c0cabd, 0x20c0cba0, 0x20c0cbb6, 0x20c0cbea, 0x20c0ccc5, 0x20c0cdac,
+	0x20c0cdd0, 0x20c0ceb2, 0x20c0ceff, 0x20c0cfff, 0x20c0c922, 0x20c0c922,
+	0x20c0c922, 0x20c0c922, 0x20c0c922, 0x20c0c922, 0x20c0c922, 0x20c0c927,
+	0x20c0c92c, 0x20c0c931, 0x20c0c937, 0x20c0c93f, 0x20c0c946, 0x20c0c94f,
+	0x20c0c959, 0x20c0c964, 0x20c0cbee, 0x20c0cce0, 0x20c0ccff, 0x20c0cde2,
+	0x20c0cdfe, 0x20c0cede, 0x20c0cefc, 0x20c0cfd9, 0x20c0cff8, 0x20c0cfff,
+	0x20c0cfff, 0x20c0cfff, 0x20c0cfff, 0x20c0cfff, 0x20c0cfff, 0x20c0cfff,
+	0x20c0c97c, 0x20c0c97c, 0x20c0c97c, 0x20c0c97c, 0x20c0c97c, 0x20c0c97c,
+	0x20c0c97c, 0x20c0c98c, 0x20c0ca79, 0x20c0ca89, 0x20c0cb74, 0x20c0cb84,
+	0x20c0cb94, 0x20c0cba8, 0x20c0cbbb, 0x20c0cbd2, 0x20c0cbee, 0x20c0cce0,
+	0x20c0ccff, 0x20c0cde2, 0x20c0cdfe, 0x20c0cede, 0x20c0cefc, 0x20c0cfd9,
+	0x20c0cff8, 0x20c0cfff, 0x20c0cfff, 0x20c0cfff, 0x20c0cfff, 0x20c0cfff,
+	0x20c0cfff, 0x20c0cfff, 0x20c0c97c, 0x20c0c97c, 0x20c0c97c, 0x20c0c97c,
+	0x20c0c97c, 0x20c0c97c, 0x20c0c97c, 0x20c0c98c, 0x20c0ca79, 0x20c0ca89,
+	0x20c0cb74, 0x20c0cb84, 0x20c0cb94, 0x20c0cba8, 0x20c0cbbb, 0x20c0cbd2,
+#else
+	// 11b
+	0x00ffd780,
+	0x00ffd872,
+	0x00ffd880,
+	0x00ffd972,
+	0x00ffd980,
+	0x00ffda75,
+	0x00ffda86,
+	0x00ffdb77,
+	0x00ffdb86,
+	0x00ffdc78,
+	0x00ffdc89,
+	0x00ffdd79,
+	0x00ffdd89,
+	0x00ffde83,
+	0x00ffdf79,
+	0x00ffdf8b,
+	0x00ffd072,
+	0x00ffd072,
+	0x00ffd080,
+	0x00ffd172,
+	0x00ffd180,
+	0x00ffd272,
+	0x00ffd280,
+	0x00ffd36d,
+	0x00ffd379,
+	0x00ffd46d,
+	0x00ffd479,
+	0x00ffd572,
+	0x00ffd580,
+	0x00ffd672,
+	0x00ffd680,
+	0x00ffd772,
+	// high
+	0x00ffc87d,
+	0x00ffc88b,
+	0x00ffc979,
+	0x00ffc989,
+	0x00ffcc4b,
+	0x00ffcc54,
+	0x00ffcc5e,
+	0x00ffcc69,
+	0x00ffcc78,
+	0x00ffcc85,
+	0x00ffcd70,
+	0x00ffcd80,
+	0x00ffce70,
+	0x00ffce80,
+	0x00ffcf7d,
+	0x00ffcf90,
+	0x00ffc080,
+	0x00ffc090,
+	0x00ffc180,
+	0x00ffc190,
+	0x00ffc27b,
+	0x00ffc28b,
+	0x00ffc37b,
+	0x00ffc390,
+	0x00ffc485,
+	0x00ffc495,
+	0x00ffc579,
+	0x00ffc589,
+	0x00ffc679,
+	0x00ffc689,
+	0x00ffc780,
+	0x00ffc790,
+	// low
+	0x00ffc87d,
+	0x00ffc88b,
+	0x00ffc979,
+	0x00ffc989,
+	0x00ffcc4b,
+	0x00ffcc54,
+	0x00ffcc5e,
+	0x00ffcc69,
+	0x00ffcc78,
+	0x00ffcc85,
+	0x00ffcd70,
+	0x00ffcd80,
+	0x00ffcd90,
+	0x00ffce80,
+	0x00ffce93,
+	0x00ffcf90,
+	0x00ffc080,
+	0x00ffc090,
+	0x00ffc180,
+	0x00ffc190,
+	0x00ffc27b,
+	0x00ffc28b,
+	0x00ffc37b,
+	0x00ffc390,
+	0x00ffc485,
+	0x00ffc495,
+	0x00ffc579,
+	0x00ffc589,
+	0x00ffc679,
+	0x00ffc689,
+	0x00ffc780,
+	0x00ffc790,
+#endif
+};
+
+static const u32 txgain_map_h[96] =3D {
+	// 11b
+	0xffd888, // 11
+	0xffd979, // 12
+	0xffd988, // 13
+	0xffda79, // 14
+	0xffda88, // 15
+	0xffdb79, // 16
+	0xffdb88, // 17
+	0xffdc72, // 18
+	0xffdc80, // 19
+	0xffdd80, // 20
+	0xffde66, // 21
+	0xffde72, // 22
+	0xffde80, // 23
+	0xffdf79, // 24
+	0xffdf88, // 25
+	0xffdf98, // 26
+	0xffd079, //-5
+	0xffd088, //-4
+	0xffd179, //-3
+	0xffd188, //-2
+	0xffd288, //-1
+	0xffd36c, // 0
+	0xffd379, // 1
+	0xffd388, // 2
+	0xffd479, // 3
+	0xffd488, // 4
+	0xffd579, // 5
+	0xffd588, // 6
+	0xffd679, // 7
+	0xffd688, // 8
+	0xffd779, // 9
+	0xffd879, // 10
+	// high
+	0xffc879, // 8
+	0xffc96b, // 9
+	0xffc979, // 10
+	0xffcc45, // 11
+	0xffcc4d, // 12
+	0xffcc56, // 13
+	0xffcc60, // 14
+	0xffcc6b, // 15
+	0xffcc79, // 16
+	0xffcd72, // 17
+	0xffce60, // 18
+	0xffce72, // 19
+	0xffcf72, // 20
+	0xffcf80, // 21
+	0xffcf90, // 22
+	0xffcf90, // 23
+	0xffc079, //-8
+	0xffc16b, //-7
+	0xffc179, //-6
+	0xffc26b, //-5
+	0xffc279, //-4
+	0xffc36b, //-3
+	0xffc379, //-2
+	0xffc46b, //-1
+	0xffc479, // 0
+	0xffc56b, // 1
+	0xffc579, // 2
+	0xffc66b, // 3
+	0xffc679, // 4
+	0xffc76b, // 5
+	0xffc779, // 6
+	0xffc86b, // 7
+	// low
+	0xffc879, // 8
+	0xffc96b, // 9
+	0xffc979, // 10
+	0xffcc45, // 11
+	0xffcc4d, // 12
+	0xffcc56, // 13
+	0xffcc60, // 14
+	0xffcc6b, // 15
+	0xffcc79, // 16
+	0xffcd72, // 17
+	0xffce60, // 18
+	0xffce72, // 19
+	0xffcf72, // 20
+	0xffcf80, // 21
+	0xffcf90, // 22
+	0xffcf90, // 23
+	0xffc079, //-8
+	0xffc16b, //-7
+	0xffc179, //-6
+	0xffc26b, //-5
+	0xffc279, //-4
+	0xffc36b, //-3
+	0xffc379, //-2
+	0xffc46b, //-1
+	0xffc479, // 0
+	0xffc56b, // 1
+	0xffc579, // 2
+	0xffc66b, // 3
+	0xffc679, // 4
+	0xffc76b, // 5
+	0xffc779, // 6
+	0xffc86b, // 7
+};
+
+static u32 jump_tbl[][2] =3D {
+#ifndef CONFIG_FOR_IPCOM
+	{296, 0x180001}, {137, 0x180011}, {303, 0x1810f9},
+	{168, 0x18186d}, {308, 0x181bbd}, {288, 0x1820c1},
+#else
+	{308, 0x181001}, {288, 0x181031}, {296, 0x18120d}, {137, 0x18121d},
+	{303, 0x182305}, {168, 0x182a79}, {258, 0x182ae1},
+#endif
+};
+
+static u32 patch_tbl_func[][2] =3D {
+#ifndef CONFIG_FOR_IPCOM
+	{0x00110054, 0x0018186D}, // same as jump_tbl idx 168
+	{0x0011005C, 0x0018186D}, // same as jump_tbl idx 168
+#else
+	{0x00110054, 0x00182A79}, // same as jump_tbl idx 168
+	{0x0011005C, 0x00182A79}, // same as jump_tbl idx 168
+	{0x001118D4, 0x00000011},
+#endif
+};
+
+static u32 patch_tbl_rf_func[][2] =3D {
+	{0x00110bf0, 0x00180001},
+};
+
+// adap test
+static u32 adaptivity_patch_tbl_8800dc[][2] =3D {
+	{0x000C, 0x0000320A}, // linkloss_thd
+	{0x009C, 0x00000000}, // ac_param_conf
+	{0x0128, 0xF6140001}, // tx_adaptivity_en
+};
+
+static u8 chip_id;
+#define CHIP_ID_H_MASK 0xC0
+#define IS_CHIP_ID_H() ((chip_id & CHIP_ID_H_MASK) =3D=3D CHIP_ID_H_MASK)
+
+// Crystal provided by CPU (start)
+int set_bbpll_config(struct aic_sdio_dev *rwnx_hw)
+{
+	int ret =3D 0;
+	struct dbg_mem_read_cfm rd_mem_addr_cfm;
+
+	// Read crystal provided by CPU or not.
+	ret =3D rwnx_send_dbg_mem_read_req(rwnx_hw, 0x40500148, &rd_mem_addr_cfm)=
;
+	if (ret) {
+		AICWFDBG(LOGERROR, "%x rd fail: %d\n", 0x40500148, ret);
+		return -1;
+	}
+
+	AICWFDBG(LOGDEBUG, "%s rd_mem_addr_cfm.memdata:%x \r\n", __func__,
+		 rd_mem_addr_cfm.memdata);
+
+	if (!(rd_mem_addr_cfm.memdata & 0x01)) {
+		AICWFDBG(LOGINFO, "%s Crystal not provided by CPU \r\n", __func__);
+		return 0;
+	}
+	AICWFDBG(LOGINFO, "%s Crystal provided by CPU \r\n", __func__);
+	// Read 0x40505010 value to check bbpll set or not.
+	ret =3D rwnx_send_dbg_mem_read_req(rwnx_hw, 0x40505010, &rd_mem_addr_cfm)=
;
+	if (ret < 0) {
+		AICWFDBG(LOGERROR, "%s error ret_val:%d\r\n", __func__, ret);
+		return -1;
+	}
+
+	if ((rd_mem_addr_cfm.memdata >> 29) =3D=3D 3) {
+		AICWFDBG(LOGERROR, "%s Not need to set \r\n", __func__);
+		return 0;
+	}
+	rd_mem_addr_cfm.memdata |=3D ((0x1 << 29) | (0x1 << 30));
+	rd_mem_addr_cfm.memdata &=3D (~(0x1 << 31));
+	rwnx_send_dbg_mem_write_req(rwnx_hw, 0x40505010,
+				    rd_mem_addr_cfm.memdata);
+	return 0;
+}
+
+void system_config_8800dc(struct aic_sdio_dev *rwnx_hw)
+{
+	int syscfg_num;
+	array3_tbl_t p_syscfg_msk_tbl;
+	int ret, cnt;
+	const u32 mem_addr =3D 0x40500000;
+	struct dbg_mem_read_cfm rd_mem_addr_cfm;
+#ifdef CONFIG_OOB
+	int oobcfg_num;
+#endif
+
+	ret =3D rwnx_send_dbg_mem_read_req(rwnx_hw, mem_addr, &rd_mem_addr_cfm);
+	if (ret) {
+		AICWFDBG(LOGERROR, "%x rd fail: %d\n", mem_addr, ret);
+		return;
+	}
+	chip_id =3D (u8)(rd_mem_addr_cfm.memdata >> 16);
+	// printk("%x=3D%x\n", rd_mem_addr_cfm.memaddr, rd_mem_addr_cfm.memdata);
+	if (((rd_mem_addr_cfm.memdata >> 25) & 0x01UL) =3D=3D 0x00UL)
+		chip_mcu_id =3D 1;
+
+	ret =3D rwnx_send_dbg_mem_read_req(rwnx_hw, 0x00000020, &rd_mem_addr_cfm)=
;
+	if (ret) {
+		AICWFDBG(LOGERROR, "[0x00000020] rd fail: %d\n", ret);
+		return;
+	}
+	chip_sub_id =3D (u8)(rd_mem_addr_cfm.memdata);
+	AICWFDBG(LOGINFO, "chip_id=3D%x, chip_sub_id=3D%x!!\n", chip_id, chip_sub=
_id);
+
+	// Crystal provided by CPU (start)
+	ret =3D set_bbpll_config(rwnx_hw);
+	if (ret) {
+		AICWFDBG(LOGERROR, "set_bbpll_config fail: %d\n", ret);
+		return;
+	}
+	// Crystal provided by CPU (end)
+
+	ret =3D rwnx_send_dbg_mem_read_req(rwnx_hw, 0x40500010, &rd_mem_addr_cfm)=
;
+	AICWFDBG(LOGDEBUG, "[0x40500010]=3D%x\n", rd_mem_addr_cfm.memdata);
+	if (ret) {
+		AICWFDBG(LOGERROR, "[0x40500010] rd fail: %d\n", ret);
+		return;
+	}
+
+	syscfg_num =3D sizeof(syscfg_tbl_8800dc) / sizeof(uint32_t) / 2;
+
+	for (cnt =3D 0; cnt < syscfg_num; cnt++) {
+		ret =3D rwnx_send_dbg_mem_write_req(rwnx_hw, syscfg_tbl_8800dc[cnt][0],
+						  syscfg_tbl_8800dc[cnt][1]);
+		if (ret) {
+			AICWFDBG(LOGERROR, "%x write fail: %d\n", syscfg_tbl_8800dc[cnt][0],
+				 ret);
+			return;
+		}
+	}
+
+	u32 tmp_mem_addr =3D 0;
+	u32 mem_mask =3D 0;
+	u32 mem_data =3D 0;
+
+	if (chip_mcu_id =3D=3D 0) {
+		if (chip_sub_id =3D=3D 0) {
+			syscfg_num =3D sizeof(syscfg_tbl_8800dc_sdio_u01) / sizeof(u32) / 2;
+			for (cnt =3D 0; cnt < syscfg_num; cnt++) {
+				tmp_mem_addr =3D syscfg_tbl_8800dc_sdio_u01[cnt][0];
+				mem_data =3D syscfg_tbl_8800dc_sdio_u01[cnt][1];
+				ret =3D rwnx_send_dbg_mem_write_req(rwnx_hw,
+								  tmp_mem_addr,
+								  mem_data);
+				if (ret) {
+					AICWFDBG(LOGERROR, "%x write fail: %d\n",
+						 syscfg_tbl_8800dc_sdio_u01[cnt][0], ret);
+					return;
+				}
+			}
+		} else if ((chip_sub_id =3D=3D 1) || (chip_sub_id =3D=3D 2)) {
+			syscfg_num =3D sizeof(syscfg_tbl_8800dc_sdio_u02) / sizeof(u32) / 2;
+			for (cnt =3D 0; cnt < syscfg_num; cnt++) {
+				tmp_mem_addr =3D syscfg_tbl_8800dc_sdio_u02[cnt][0];
+				mem_data =3D syscfg_tbl_8800dc_sdio_u02[cnt][1];
+				ret =3D rwnx_send_dbg_mem_write_req(rwnx_hw,
+								  tmp_mem_addr,
+								  mem_data);
+				if (ret) {
+					AICWFDBG(LOGERROR, "%x write fail: %d\n",
+						 syscfg_tbl_8800dc_sdio_u02[cnt][0], ret);
+					return;
+				}
+			}
+		}
+	}
+#ifdef CONFIG_OOB
+	if (chip_sub_id =3D=3D 1 || chip_sub_id =3D=3D 2) {
+		oobcfg_num =3D sizeof(oobcfg_tbl_8800dc_sdio_u02) / sizeof(u32) / 2;
+		for (cnt =3D 0; cnt < oobcfg_num; cnt++) {
+			tmp_mem_addr =3D oobcfg_tbl_8800dc_sdio_u02[cnt][0];
+			mem_data =3D oobcfg_tbl_8800dc_sdio_u02[cnt][1];
+			ret =3D rwnx_send_dbg_mem_write_req(rwnx_hw,
+							  tmp_mem_addr,
+							  mem_data);
+			if (ret) {
+				AICWFDBG(LOGERROR, "%x write fail: %d\n",
+					 oobcfg_tbl_8800dc_sdio_u02[cnt][0], ret);
+				return;
+			}
+		}
+	}
+#endif
+	if (IS_CHIP_ID_H()) {
+		syscfg_num =3D sizeof(syscfg_tbl_masked_8800dc_h) / sizeof(u32) / 3;
+		p_syscfg_msk_tbl =3D syscfg_tbl_masked_8800dc_h;
+	} else {
+		syscfg_num =3D sizeof(syscfg_tbl_masked_8800dc) / sizeof(u32) / 3;
+		p_syscfg_msk_tbl =3D syscfg_tbl_masked_8800dc;
+	}
+
+	for (cnt =3D 0; cnt < syscfg_num; cnt++) {
+		if (p_syscfg_msk_tbl[cnt][0] =3D=3D 0x00000000) {
+			break;
+		} else if (p_syscfg_msk_tbl[cnt][0] =3D=3D 0x70001000) {
+			if (chip_mcu_id =3D=3D 0) {
+				p_syscfg_msk_tbl[cnt][1] |=3D ((0x1 << 8) | (0x1 << 15)); // mask
+				p_syscfg_msk_tbl[cnt][2] |=3D ((0x1 << 8) | (0x1 << 15));
+			}
+		}
+
+		ret =3D rwnx_send_dbg_mem_mask_write_req(rwnx_hw, p_syscfg_msk_tbl[cnt][=
0],
+						       p_syscfg_msk_tbl[cnt][1],
+						       p_syscfg_msk_tbl[cnt][2]);
+		if (ret) {
+			AICWFDBG(LOGERROR, "%x mask write fail: %d\n",
+				 p_syscfg_msk_tbl[cnt][0], ret);
+			return;
+		}
+	}
+
+	if (chip_sub_id =3D=3D 0) {
+		syscfg_num =3D sizeof(syscfg_tbl_masked_8800dc_u01) / sizeof(u32) / 3;
+		for (cnt =3D 0; cnt < syscfg_num; cnt++) {
+			tmp_mem_addr =3D syscfg_tbl_masked_8800dc_u01[cnt][0];
+			mem_mask =3D syscfg_tbl_masked_8800dc_u01[cnt][1];
+			mem_data =3D syscfg_tbl_masked_8800dc_u01[cnt][2];
+			ret =3D rwnx_send_dbg_mem_mask_write_req(rwnx_hw,
+							       tmp_mem_addr,
+							       mem_mask,
+							       mem_data);
+			if (ret) {
+				AICWFDBG(LOGERROR, "%x mask write fail: %d\n",
+					 syscfg_tbl_masked_8800dc_u01[cnt][0], ret);
+				return;
+			}
+		}
+	}
+}
+
+extern struct aicbsp_info_t aicbsp_info;
+
+void aicwf_patch_config_8800dc(struct aic_sdio_dev *rwnx_hw)
+{
+	int ret =3D 0;
+	int cnt =3D 0;
+	u32 mem_addr =3D 0;
+	u32 mem_data =3D 0;
+
+	if (testmode =3D=3D 0) {
+		const u32 cfg_base =3D 0x10164;
+		struct dbg_mem_read_cfm cfm;
+		int i;
+		u32 wifisetting_cfg_addr;
+		u32 ldpc_cfg_addr;
+		u32 agc_cfg_addr;
+		u32 txgain_cfg_addr;
+		u32 jump_tbl_addr =3D 0;
+
+		u32 patch_tbl_wifisetting_num; // =3D
+		// sizeof(patch_tbl_wifisetting_8800dc_u02)/sizeof(u32)/2;
+		u32 ldpc_cfg_size =3D sizeof(ldpc_cfg_ram);
+		u32 agc_cfg_size =3D sizeof(agc_cfg_ram);
+		u32 txgain_cfg_size, *txgain_cfg_array;
+		u32 jump_tbl_size =3D 0;
+		u32 patch_tbl_func_num =3D 0;
+
+		// adap test
+		int adap_patch_num =3D 0;
+		// adap test
+
+		array2_tbl_t jump_tbl_base =3D NULL;
+		array2_tbl_t patch_tbl_func_base =3D NULL;
+		array2_tbl_t patch_tbl_wifisetting_8800dc_base =3D NULL;
+
+		if (chip_sub_id =3D=3D 0) {
+			jump_tbl_base =3D jump_tbl;
+			jump_tbl_size =3D sizeof(jump_tbl) / 2;
+			patch_tbl_func_base =3D patch_tbl_func;
+			patch_tbl_func_num =3D sizeof(patch_tbl_func) / sizeof(u32) / 2;
+			patch_tbl_wifisetting_num =3D
+				sizeof(patch_tbl_wifisetting_8800dc_u01) / sizeof(u32) / 2;
+			patch_tbl_wifisetting_8800dc_base =3D
+				patch_tbl_wifisetting_8800dc_u01;
+		} else if ((chip_sub_id =3D=3D 1) || (chip_sub_id =3D=3D 2)) {
+			patch_tbl_wifisetting_num =3D
+				sizeof(patch_tbl_wifisetting_8800dc_u02) / sizeof(u32) / 2;
+			patch_tbl_wifisetting_8800dc_base =3D
+				patch_tbl_wifisetting_8800dc_u02;
+		} else {
+			pr_info("unsupported id: %d", chip_sub_id);
+			return;
+		}
+
+		ret =3D rwnx_send_dbg_mem_read_req(rwnx_hw, cfg_base, &cfm);
+		if (ret) {
+			AICWFDBG(LOGERROR, "setting base[0x%x] rd fail: %d\n", cfg_base,
+				 ret);
+		}
+		wifisetting_cfg_addr =3D cfm.memdata;
+
+		if (chip_sub_id =3D=3D 0) {
+			ret =3D rwnx_send_dbg_mem_read_req(rwnx_hw, cfg_base + 4, &cfm);
+			if (ret) {
+				AICWFDBG(LOGERROR, "setting base[0x%x] rd fail: %d\n",
+					 cfg_base + 4, ret);
+			}
+			jump_tbl_addr =3D cfm.memdata;
+		}
+
+		ret =3D rwnx_send_dbg_mem_read_req(rwnx_hw, cfg_base + 8, &cfm);
+		if (ret) {
+			AICWFDBG(LOGERROR, "setting base[0x%x] rd fail: %d\n", cfg_base + 8,
+				 ret);
+		}
+		ldpc_cfg_addr =3D cfm.memdata;
+
+		ret =3D rwnx_send_dbg_mem_read_req(rwnx_hw, cfg_base + 0xc, &cfm);
+		if (ret) {
+			AICWFDBG(LOGERROR, "setting base[0x%x] rd fail: %d\n",
+				 cfg_base + 0xc, ret);
+		}
+		agc_cfg_addr =3D cfm.memdata;
+
+		ret =3D rwnx_send_dbg_mem_read_req(rwnx_hw, cfg_base + 0x10, &cfm);
+		if (ret) {
+			AICWFDBG(LOGERROR, "setting base[0x%x] rd fail: %d\n",
+				 cfg_base + 0x10, ret);
+		}
+		txgain_cfg_addr =3D cfm.memdata;
+
+		AICWFDBG(LOGINFO,
+			 "wifisetting_cfg_addr=3D%x, ldpc_cfg_addr=3D%x, agc_cfg_addr=3D%x, txg=
ain_cfg_addr=3D%x\n",
+			 wifisetting_cfg_addr, ldpc_cfg_addr, agc_cfg_addr,
+			 txgain_cfg_addr);
+
+		for (cnt =3D 0; cnt < patch_tbl_wifisetting_num; cnt++) {
+			mem_addr =3D wifisetting_cfg_addr +
+				patch_tbl_wifisetting_8800dc_base[cnt][0];
+			mem_data =3D patch_tbl_wifisetting_8800dc_base[cnt][1];
+			ret =3D rwnx_send_dbg_mem_write_req(rwnx_hw, mem_addr, mem_data);
+			if (ret) {
+				AICWFDBG(LOGERROR, "wifisetting %x write fail\n",
+					 patch_tbl_wifisetting_8800dc_base[cnt][0]);
+			}
+		}
+
+		// adap test
+		if (aicbsp_info.adap_test) {
+			AICWFDBG(LOGINFO, "%s for adaptivity test \r\n", __func__);
+			adap_patch_num =3D
+				sizeof(adaptivity_patch_tbl_8800dc) / sizeof(u32) / 2;
+			for (cnt =3D 0; cnt < adap_patch_num; cnt++) {
+				mem_addr =3D wifisetting_cfg_addr +
+					adaptivity_patch_tbl_8800dc[cnt][0];
+				mem_data =3D adaptivity_patch_tbl_8800dc[cnt][1];
+				ret =3D rwnx_send_dbg_mem_write_req(rwnx_hw, mem_addr, mem_data);
+				if (ret) {
+					AICWFDBG(LOGERROR, "%x write fail\n",
+						 wifisetting_cfg_addr +
+						 adaptivity_patch_tbl_8800dc[cnt][0]);
+				}
+			}
+		}
+		// adap test
+
+		if (ldpc_cfg_size > 512) { // > 0.5KB data
+			for (i =3D 0; i < (ldpc_cfg_size - 512);
+				 i +=3D 512) { // each time write 0.5KB
+				ret =3D rwnx_send_dbg_mem_block_write_req(rwnx_hw, ldpc_cfg_addr + i,
+									512, ldpc_cfg_ram + i / 4);
+				if (ret) {
+					AICWFDBG(LOGERROR, "ldpc upload fail: %x, err:%d\r\n",
+						 ldpc_cfg_addr + i, ret);
+					break;
+				}
+			}
+		}
+
+		if (!ret && i < ldpc_cfg_size) { // < 0.5KB data
+			ret =3D rwnx_send_dbg_mem_block_write_req(rwnx_hw, ldpc_cfg_addr + i,
+								ldpc_cfg_size - i,
+								ldpc_cfg_ram + i / 4);
+			if (ret) {
+				AICWFDBG(LOGERROR, "ldpc upload fail: %x, err:%d\r\n",
+					 ldpc_cfg_addr + i, ret);
+			}
+		}
+
+		if (agc_cfg_size > 512) { // > 0.5KB data
+			for (i =3D 0; i < (agc_cfg_size - 512);
+				 i +=3D 512) { // each time write 0.5KB
+				ret =3D rwnx_send_dbg_mem_block_write_req(rwnx_hw, agc_cfg_addr + i,
+									512, agc_cfg_ram + i / 4);
+				if (ret) {
+					AICWFDBG(LOGERROR, "agc upload fail: %x, err:%d\r\n",
+						 agc_cfg_addr + i, ret);
+					break;
+				}
+			}
+		}
+
+		if (!ret && i < agc_cfg_size) { // < 0.5KB data
+			ret =3D rwnx_send_dbg_mem_block_write_req(rwnx_hw, agc_cfg_addr + i,
+								agc_cfg_size - i,
+								agc_cfg_ram + i / 4);
+			if (ret) {
+				AICWFDBG(LOGERROR, "agc upload fail: %x, err:%d\r\n",
+					 agc_cfg_addr + i, ret);
+			}
+		}
+
+#if !defined(CONFIG_FPGA_VERIFICATION)
+		if ((IS_CHIP_ID_H())) {
+			txgain_cfg_size =3D sizeof(txgain_map_h);
+			txgain_cfg_array =3D (u32 *)txgain_map_h;
+		} else {
+			txgain_cfg_size =3D sizeof(txgain_map);
+			txgain_cfg_array =3D (u32 *)txgain_map;
+		}
+		ret =3D rwnx_send_dbg_mem_block_write_req(rwnx_hw, txgain_cfg_addr,
+							txgain_cfg_size, txgain_cfg_array);
+		if (ret) {
+			AICWFDBG(LOGERROR, "txgain upload fail: %x, err:%d\r\n",
+				 txgain_cfg_addr, ret);
+		}
+
+		if (chip_sub_id =3D=3D 0) {
+			for (cnt =3D 0; cnt < jump_tbl_size / 4; cnt +=3D 1) {
+				AICWFDBG(LOGDEBUG, "%x =3D %x\n",
+					 jump_tbl_base[cnt][0] * 4 + jump_tbl_addr,
+						 jump_tbl_base[cnt][1]);
+				ret =3D rwnx_send_dbg_mem_write_req(rwnx_hw,
+								  jump_tbl_base[cnt][0] *
+								  4 + jump_tbl_addr,
+								  jump_tbl_base[cnt][1]);
+				if (ret) {
+					AICWFDBG(LOGERROR, "%x write fail\n",
+						 jump_tbl_addr + 8 * cnt);
+				}
+			}
+			for (cnt =3D 0; cnt < patch_tbl_func_num; cnt++) {
+				mem_addr =3D patch_tbl_func_base[cnt][0];
+				mem_data =3D patch_tbl_func_base[cnt][1];
+				ret =3D rwnx_send_dbg_mem_write_req(rwnx_hw, mem_addr, mem_data);
+				if (ret) {
+					AICWFDBG(LOGERROR, "patch_tbl_func %x write fail\n",
+						 patch_tbl_func_base[cnt][0]);
+				}
+			}
+		} else if (chip_sub_id =3D=3D 1) {
+			ret =3D aicwf_patch_table_load(rwnx_hw,
+						     RWNX_MAC_PATCH_TABLE_8800DC_U02);
+			if (ret)
+				pr_warn("patch_tbl upload fail: err:%d\r\n", ret);
+		} else if (chip_sub_id =3D=3D 2) {
+			ret =3D aicwf_patch_table_load(rwnx_hw,
+						     RWNX_MAC_PATCH_TABLE_8800DC_H_U02);
+			if (ret)
+				pr_warn("patch_tbl upload fail: err:%d\r\n", ret);
+		} else {
+			pr_info("unsupported id: %d\n", chip_sub_id);
+		}
+
+#endif
+	} else {
+		if (chip_sub_id =3D=3D 0) {
+			u32 patch_tbl_rf_func_num =3D
+				sizeof(patch_tbl_rf_func) / sizeof(u32) / 2;
+			for (cnt =3D 0; cnt < patch_tbl_rf_func_num; cnt++) {
+				mem_addr =3D patch_tbl_rf_func[cnt][0];
+				mem_data =3D patch_tbl_rf_func[cnt][1];
+				ret =3D rwnx_send_dbg_mem_write_req(rwnx_hw, mem_addr, mem_data);
+				if (ret) {
+					AICWFDBG(LOGERROR, "patch_tbl_rf_func %x write fail\n",
+						 patch_tbl_rf_func[cnt][0]);
+				}
+			}
+		}
+	}
+}
+
+int rwnx_plat_patch_load_8800dc(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	AICWFDBG(LOGINFO, "testmode=3D%d\n", testmode);
+	if (chip_sub_id =3D=3D 0) {
+		if (testmode =3D=3D FW_NORMAL_MODE) {
+			AICWFDBG(LOGINFO, "rwnx_plat_patch_loading\n");
+			ret =3D aicwf_plat_patch_load_8800dc(sdiodev);
+			if (ret) {
+				AICWFDBG(LOGINFO, "load patch bin fail: %d\n", ret);
+				return ret;
+			}
+		} else if (testmode =3D=3D FW_RFTEST_MODE) {
+			ret =3D aicwf_plat_rftest_load_8800dc(sdiodev);
+			if (ret) {
+				AICWFDBG(LOGINFO, "load rftest bin fail: %d\n", ret);
+				return ret;
+			}
+		}
+	} else if (chip_sub_id >=3D 1) {
+		if (testmode =3D=3D FW_NORMAL_MODE) {
+			AICWFDBG(LOGINFO, "rwnx_plat_patch_loading\n");
+			ret =3D aicwf_plat_patch_load_8800dc(sdiodev);
+			if (ret) {
+				AICWFDBG(LOGINFO, "load patch bin fail: %d\n", ret);
+				return ret;
+			}
+#ifdef CONFIG_DPD
+#ifdef CONFIG_FORCE_DPD_CALIB
+			if (1) {
+				AICWFDBG(LOGINFO, "dpd calib & write\n");
+				ret =3D aicwf_dpd_calib_8800dc(sdiodev, &dpd_res);
+				if (ret) {
+					AICWFDBG(LOGINFO, "dpd calib fail: %d\n", ret);
+					return ret;
+				}
+			}
+#else
+			if (is_file_exist(FW_DPDRESULT_NAME_8800DC) =3D=3D 1) {
+				AICWFDBG(LOGINFO, "dpd bin load\n");
+				ret =3D aicwf_dpd_result_load_8800dc(sdiodev, &dpd_res);
+				if (ret) {
+					AICWFDBG(LOGINFO, "load dpd bin fail: %d\n", ret);
+					return ret;
+				}
+				ret =3D aicwf_dpd_result_apply_8800dc(sdiodev, &dpd_res);
+				if (ret) {
+					AICWFDBG(LOGINFO, "apply dpd bin fail: %d\n", ret);
+					return ret;
+				}
+			}
+#endif
+			else
+#endif
+			{
+				ret =3D aicwf_misc_ram_init_8800dc(sdiodev);
+				if (ret) {
+					AICWFDBG(LOGINFO, "misc ram init fail: %d\n", ret);
+					return ret;
+				}
+			}
+		} else if (testmode =3D=3D FW_RFTEST_MODE) {
+#ifdef CONFIG_DPD
+#ifdef CONFIG_FORCE_DPD_CALIB
+			if (1) {
+				AICWFDBG(LOGINFO, "patch load\n");
+				ret =3D aicwf_plat_patch_load_8800dc(sdiodev);
+				if (ret) {
+					AICWFDBG(LOGINFO, "load patch bin fail: %d\n", ret);
+					return ret;
+				}
+				AICWFDBG(LOGINFO, "dpd calib & write\n");
+				ret =3D aicwf_dpd_calib_8800dc(sdiodev, &dpd_res);
+				if (ret) {
+					AICWFDBG(LOGINFO, "dpd calib fail: %d\n", ret);
+					return ret;
+				}
+			}
+#endif
+#endif
+			ret =3D aicwf_plat_rftest_load_8800dc(sdiodev);
+			if (ret) {
+				AICWFDBG(LOGINFO, "load rftest bin fail: %d\n", ret);
+				return ret;
+			}
+		} else if (testmode =3D=3D FW_DPDCALIB_MODE) {
+#if (defined(CONFIG_DPD) && !defined(CONFIG_FORCE_DPD_CALIB))
+			if (is_file_exist(FW_DPDRESULT_NAME_8800DC) =3D=3D 0) {
+				AICWFDBG(LOGINFO, "patch load\n");
+				ret =3D aicwf_plat_patch_load_8800dc(sdiodev);
+				if (ret) {
+					AICWFDBG(LOGINFO, "load patch bin fail: %d\n", ret);
+					return ret;
+				}
+				AICWFDBG(LOGINFO, "dpd calib & write\n");
+				ret =3D aicwf_dpd_calib_8800dc(sdiodev, &dpd_res);
+				if (ret) {
+					AICWFDBG(LOGINFO, "dpd calib fail: %d\n", ret);
+					return ret;
+				}
+				ret =3D aicwf_dpd_result_write_8800dc((void *)&dpd_res,
+								    DPD_RESULT_SIZE_8800DC);
+				if (ret) {
+					AICWFDBG(LOGINFO, "file write fail: %d\n", ret);
+					return ret;
+				}
+			}
+#endif
+			return 1; // exit calib mode
+		}
+	}
+
+	return ret;
+}
+
+int aicwf_misc_ram_init_8800dc(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+	u32 cfg_base =3D 0x10164;
+	struct dbg_mem_read_cfm cfm;
+	u32 misc_ram_addr;
+	u32 misc_ram_size =3D 12;
+	int i;
+
+	if (testmode =3D=3D FW_RFTEST_MODE)
+		cfg_base =3D RAM_LMAC_FW_ADDR + 0x0164;
+	// init misc ram
+	ret =3D rwnx_send_dbg_mem_read_req(sdiodev, cfg_base + 0x14, &cfm);
+	if (ret) {
+		AICWFDBG(LOGERROR, "rf misc ram[0x%x] rd fail: %d\n", cfg_base + 0x14,
+			 ret);
+		return ret;
+	}
+	misc_ram_addr =3D cfm.memdata;
+	AICWFDBG(LOGERROR, "misc_ram_addr=3D%x\n", misc_ram_addr);
+	for (i =3D 0; i < (misc_ram_size / 4); i++) {
+		ret =3D rwnx_send_dbg_mem_write_req(sdiodev, misc_ram_addr + i * 4, 0);
+		if (ret) {
+			AICWFDBG(LOGERROR, "rf misc ram[0x%x] wr fail: %d\n",
+				 misc_ram_addr + i * 4, ret);
+			return ret;
+		}
+	}
+	return ret;
+}
+
+int start_from_bootrom_8800DC(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+	u32 rd_addr;
+	u32 fw_addr;
+	u32 boot_type;
+	struct dbg_mem_read_cfm rd_cfm;
+
+	/* memory access */
+	if (testmode =3D=3D 1) {
+		rd_addr =3D RAM_LMAC_FW_ADDR;
+		fw_addr =3D RAM_LMAC_FW_ADDR;
+	} else {
+		rd_addr =3D RAM_FMAC_FW_ADDR;
+		fw_addr =3D RAM_FMAC_FW_ADDR;
+	}
+
+	AICWFDBG(LOGINFO, "Read FW mem: %08x\n", rd_addr);
+	ret =3D rwnx_send_dbg_mem_read_req(sdiodev, rd_addr, &rd_cfm);
+	if (ret)
+		return -1;
+	AICWFDBG(LOGINFO, "cfm: [%08x] =3D %08x\n", rd_cfm.memaddr, rd_cfm.memdat=
a);
+
+	if (testmode =3D=3D 0)
+		boot_type =3D HOST_START_APP_DUMMY;
+	else
+		boot_type =3D HOST_START_APP_AUTO;
+	/* fw start */
+	AICWFDBG(LOGINFO, "Start app: %08x, %d\n", fw_addr, boot_type);
+	ret =3D rwnx_send_dbg_start_app_req(sdiodev, fw_addr, boot_type, NULL);
+	if (ret)
+		return -1;
+	return 0;
+}
+
+#ifdef CONFIG_DPD
+int aicwf_dpd_calib_8800dc(struct aic_sdio_dev *sdiodev,
+			   struct rf_misc_ram_lite_t *dpd_res)
+{
+	int ret =3D 0;
+	u32 fw_addr, boot_type;
+	int valid_flag;
+
+	ret =3D aicwf_misc_ram_valid_check_8800dc(sdiodev, &valid_flag);
+	if (ret) {
+		AICWFDBG(LOGINFO, "misc ram check fail: %d\n", ret);
+		return ret;
+	}
+	if (valid_flag) {
+		AICWFDBG(LOGINFO, "misc ram valid, skip calib process\n");
+		return ret;
+	}
+	ret =3D aicwf_plat_calib_load_8800dc(sdiodev);
+	if (ret) {
+		AICWFDBG(LOGINFO, "load calib bin fail: %d\n", ret);
+		return ret;
+	}
+	/* fw start */
+	fw_addr =3D 0x00130009;
+	boot_type =3D HOST_START_APP_FNCALL;
+	AICWFDBG(LOGINFO, "Start app: %08x, %d\n", fw_addr, boot_type);
+	ret =3D rwnx_send_dbg_start_app_req(sdiodev, fw_addr, boot_type, NULL);
+	if (ret) {
+		AICWFDBG(LOGINFO, "start app fail: %d\n", ret);
+		return ret;
+	}
+	{ // read dpd res
+		const u32 cfg_base =3D 0x10164;
+		struct dbg_mem_read_cfm cfm;
+		u32 misc_ram_addr;
+		u32 ram_base_addr, ram_word_cnt;
+		int i;
+
+		ret =3D rwnx_send_dbg_mem_read_req(sdiodev, cfg_base + 0x14, &cfm);
+		if (ret) {
+			AICWFDBG(LOGERROR, "rf misc ram[0x%x] rd fail: %d\n",
+				 cfg_base + 0x14, ret);
+			return ret;
+		}
+		misc_ram_addr =3D cfm.memdata;
+		// bit_mask
+		ram_base_addr =3D misc_ram_addr + offsetof(struct rf_misc_ram_t, bit_mas=
k);
+		ram_word_cnt =3D (MEMBER_SIZE(struct rf_misc_ram_t, bit_mask) +
+						MEMBER_SIZE(struct rf_misc_ram_t, reserved)) /
+					   4;
+		for (i =3D 0; i < ram_word_cnt; i++) {
+			ret =3D rwnx_send_dbg_mem_read_req(sdiodev, ram_base_addr + i * 4,
+							 &cfm);
+			if (ret) {
+				AICWFDBG(LOGERROR, "bit_mask[0x%x] rd fail: %d\n",
+					 ram_base_addr + i * 4, ret);
+				return ret;
+			}
+			dpd_res->bit_mask[i] =3D cfm.memdata;
+		}
+		// dpd_high
+		ram_base_addr =3D misc_ram_addr + offsetof(struct rf_misc_ram_t, dpd_hig=
h);
+		ram_word_cnt =3D MEMBER_SIZE(struct rf_misc_ram_t, dpd_high) / 4;
+		for (i =3D 0; i < ram_word_cnt; i++) {
+			ret =3D rwnx_send_dbg_mem_read_req(sdiodev, ram_base_addr + i * 4,
+							 &cfm);
+			if (ret) {
+				AICWFDBG(LOGERROR, "bit_mask[0x%x] rd fail: %d\n",
+					 ram_base_addr + i * 4, ret);
+				return ret;
+			}
+			dpd_res->dpd_high[i] =3D cfm.memdata;
+		}
+		// loft_res
+		ram_base_addr =3D misc_ram_addr + offsetof(struct rf_misc_ram_t, loft_re=
s);
+		ram_word_cnt =3D MEMBER_SIZE(struct rf_misc_ram_t, loft_res) / 4;
+		for (i =3D 0; i < ram_word_cnt; i++) {
+			ret =3D rwnx_send_dbg_mem_read_req(sdiodev, ram_base_addr + i * 4,
+							 &cfm);
+			if (ret) {
+				AICWFDBG(LOGERROR, "bit_mask[0x%x] rd fail: %d\n",
+					 ram_base_addr + i * 4, ret);
+				return ret;
+			}
+			dpd_res->loft_res[i] =3D cfm.memdata;
+		}
+	}
+	return ret;
+}
+
+int aicwf_dpd_result_apply_8800dc(struct aic_sdio_dev *sdiodev,
+				  struct rf_misc_ram_lite_t *dpd_res)
+{
+	int ret =3D 0;
+	u32 cfg_base =3D 0x10164;
+	struct dbg_mem_read_cfm cfm;
+	u32 misc_ram_addr;
+	u32 ram_base_addr, ram_byte_cnt;
+
+	AICWFDBG(LOGINFO, "bit_mask[1]=3D%x\n", dpd_res->bit_mask[1]);
+	if (dpd_res->bit_mask[1] =3D=3D 0) {
+		AICWFDBG(LOGERROR, "void dpd_res, bypass it.\n");
+		return 0;
+	}
+	if (testmode =3D=3D FW_RFTEST_MODE)
+		cfg_base =3D RAM_LMAC_FW_ADDR + 0x0164;
+	ret =3D rwnx_send_dbg_mem_read_req(sdiodev, cfg_base + 0x14, &cfm);
+	if (ret) {
+		AICWFDBG(LOGERROR, "rf misc ram[0x%x] rd fail: %d\n", cfg_base + 0x14,
+			 ret);
+		return ret;
+	}
+	misc_ram_addr =3D cfm.memdata;
+	AICWFDBG(LOGINFO, "misc_ram_addr: %x\n", misc_ram_addr);
+	/* Copy dpd_res on the Embedded side */
+	// bit_mask
+	AICWFDBG(LOGINFO, "bit_mask[0]=3D%x\n", dpd_res->bit_mask[0]);
+	ram_base_addr =3D misc_ram_addr + offsetof(struct rf_misc_ram_t, bit_mask=
);
+	ram_byte_cnt =3D MEMBER_SIZE(struct rf_misc_ram_t, bit_mask) +
+				   MEMBER_SIZE(struct rf_misc_ram_t, reserved);
+	ret =3D rwnx_send_dbg_mem_block_write_req(sdiodev, ram_base_addr, ram_byt=
e_cnt,
+						(u32 *)&dpd_res->bit_mask[0]);
+	if (ret) {
+		AICWFDBG(LOGERROR, "bit_mask wr fail: %x, ret:%d\r\n", ram_base_addr,
+			 ret);
+		return ret;
+	}
+	// dpd_high
+	AICWFDBG(LOGINFO, "dpd_high[0]=3D%x\n", dpd_res->dpd_high[0]);
+	ram_base_addr =3D misc_ram_addr + offsetof(struct rf_misc_ram_t, dpd_high=
);
+	ram_byte_cnt =3D MEMBER_SIZE(struct rf_misc_ram_t, dpd_high);
+	ret =3D rwnx_send_dbg_mem_block_write_req(sdiodev, ram_base_addr, ram_byt=
e_cnt,
+						(u32 *)&dpd_res->dpd_high[0]);
+	if (ret) {
+		AICWFDBG(LOGERROR, "dpd_high wr fail: %x, ret:%d\r\n", ram_base_addr,
+			 ret);
+		return ret;
+	}
+	// loft_res
+	AICWFDBG(LOGINFO, "loft_res[0]=3D%x\n", dpd_res->loft_res[0]);
+	ram_base_addr =3D misc_ram_addr + offsetof(struct rf_misc_ram_t, loft_res=
);
+	ram_byte_cnt =3D MEMBER_SIZE(struct rf_misc_ram_t, loft_res);
+	ret =3D rwnx_send_dbg_mem_block_write_req(sdiodev, ram_base_addr, ram_byt=
e_cnt,
+						(u32 *)&dpd_res->loft_res[0]);
+	if (ret) {
+		AICWFDBG(LOGERROR, "loft_res wr fail: %x, ret:%d\r\n", ram_base_addr,
+			 ret);
+		return ret;
+	}
+	return ret;
+}
+
+#ifndef CONFIG_FORCE_DPD_CALIB
+int aicwf_dpd_result_load_8800dc(struct aic_sdio_dev *sdiodev,
+				 struct rf_misc_ram_lite_t *dpd_res)
+{
+	int ret =3D 0;
+	int size;
+	u32 *dst =3D NULL;
+	char *filename =3D FW_DPDRESULT_NAME_8800DC;
+	struct device *dev =3D sdiodev->dev;
+
+	AICWFDBG(LOGINFO, "%s: dpd_res file path:%s \r\n", __func__, filename);
+	/* load file */
+	size =3D rwnx_load_firmware(&dst, filename, dev);
+	if (size <=3D 0) {
+		AICWFDBG(LOGERROR, "wrong size of dpd_res file\n");
+		if (dst) {
+			vfree(dst);
+			dst =3D NULL;
+		}
+		return -1;
+	}
+	AICWFDBG(LOGINFO, "### Load file done: %s, size=3D%d, dst[0]=3D%x\n", fil=
ename,
+		 size, dst[0]);
+	memcpy((u8 *)dpd_res, (u8 *)dst, sizeof(struct rf_misc_ram_lite_t));
+	if (dst) {
+		vfree(dst);
+		dst =3D NULL;
+	}
+	return ret;
+}
+
+#endif /* !CONFIG_FORCE_DPD_CALIB */
+#endif
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic8800dc_compat.h b/driv=
ers/net/wireless/aic/aic8800_bsp/aic8800dc_compat.h
new file mode 100644
index 0000000000000..3db89a92dfe01
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic8800dc_compat.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _AIC8800DC_COMPAT_H_
+#define _AIC8800DC_COMPAT_H_
+
+#include "aicsdio.h"
+typedef u32 (*array2_tbl_t)[2];
+typedef u32 (*array3_tbl_t)[3];
+
+typedef u8 u8_l;
+typedef s8 s8_l;
+typedef u16 u16_l;
+typedef s16 s16_l;
+typedef u32 u32_l;
+typedef s32 s32_l;
+typedef u64 u64_l;
+
+extern u8 chip_sub_id;
+extern u8 chip_mcu_id;
+#define FW_PATH_MAX_LEN 200
+
+void aicwf_patch_config_8800dc(struct aic_sdio_dev *rwnx_hw);
+void system_config_8800dc(struct aic_sdio_dev *rwnx_hw);
+int rwnx_plat_patch_load_8800dc(struct aic_sdio_dev *sdiodev);
+int aicwf_misc_ram_init_8800dc(struct aic_sdio_dev *sdiodev);
+int start_from_bootrom_8800DC(struct aic_sdio_dev *sdiodev);
+
+#ifdef CONFIG_DPD
+int aicwf_dpd_calib_8800dc(struct aic_sdio_dev *sdiodev,
+			   struct rf_misc_ram_lite_t *dpd_res);
+int aicwf_dpd_result_apply_8800dc(struct aic_sdio_dev *sdiodev,
+				  struct rf_misc_ram_lite_t *dpd_res);
+#ifndef CONFIG_FORCE_DPD_CALIB
+int aicwf_dpd_result_load_8800dc(struct aic_sdio_dev *sdiodev,
+				 struct rf_misc_ram_lite_t *dpd_res);
+#endif /* !CONFIG_FORCE_DPD_CALIB */
+#endif
+
+int set_bbpll_config(struct aic_sdio_dev *rwnx_hw);
+
+#endif
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.c b/driver=
s/net/wireless/aic/aic8800_bsp/aic_bsp_driver.c
new file mode 100644
index 0000000000000..d08ba0586c94a
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.c
@@ -0,0 +1,1679 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief bsp sdio declarations
+ *
+ *************************************************************************=
*****
+ */
+
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/sprintf.h>
+#include <linux/string.h>
+#include <linux/version.h>
+#include <linux/vmalloc.h>
+
+#include "aic8800d80_compat.h"
+#include "aic8800dc_compat.h"
+#include "aic_bsp_driver.h"
+#include "aicsdio.h"
+#include "aicsdio_txrxif.h"
+#include "md5.h"
+#include "aic_chip_ops.h"
+#include <linux/fs.h>
+
+int cur_mode;
+
+static void cmd_dump(const struct rwnx_cmd *cmd)
+{
+	if (!cmd) {
+		pr_err("aicbsp %s cmd is null\n", __func__);
+		return;
+	}
+	pr_crit("aicbsp tkn[%d]  flags:%04x  result:%3d  cmd:%4d - reqcfm(%4d)\n"=
,
+		cmd->tkn, cmd->flags, cmd->result, cmd->id, cmd->reqid);
+}
+
+static void cmd_complete(struct rwnx_cmd_mgr *cmd_mgr, struct rwnx_cmd *cm=
d)
+{
+	lockdep_assert_held(&cmd_mgr->lock);
+
+	list_del(&cmd->list);
+	cmd_mgr->queue_sz--;
+
+	cmd->flags |=3D RWNX_CMD_FLAG_DONE;
+	if (cmd->flags & RWNX_CMD_FLAG_NONBLOCK) {
+		kfree(cmd);
+	} else {
+		if (RWNX_CMD_WAIT_COMPLETE(cmd->flags)) {
+			cmd->result =3D 0;
+			complete(&cmd->complete);
+		}
+	}
+}
+
+static int cmd_mgr_queue(struct rwnx_cmd_mgr *cmd_mgr, struct rwnx_cmd *cm=
d)
+{
+	bool defer_push =3D false;
+	int err =3D 0;
+
+	spin_lock_bh(&cmd_mgr->lock);
+
+	if (cmd_mgr->state =3D=3D RWNX_CMD_MGR_STATE_CRASHED) {
+		pr_crit("aicbsp cmd queue crashed\n");
+		cmd->result =3D -EPIPE;
+		spin_unlock_bh(&cmd_mgr->lock);
+		return -EPIPE;
+	}
+
+	if (!list_empty(&cmd_mgr->cmds)) {
+		struct rwnx_cmd *last;
+
+		if (cmd_mgr->queue_sz =3D=3D cmd_mgr->max_queue_sz) {
+			pr_crit("aicbsp Too many cmds (%d) already queued\n",
+				cmd_mgr->max_queue_sz);
+			cmd->result =3D -ENOMEM;
+			spin_unlock_bh(&cmd_mgr->lock);
+			return -ENOMEM;
+		}
+		last =3D list_entry(cmd_mgr->cmds.prev, struct rwnx_cmd, list);
+		if (last->flags & (RWNX_CMD_FLAG_WAIT_ACK | RWNX_CMD_FLAG_WAIT_PUSH)) {
+			cmd->flags |=3D RWNX_CMD_FLAG_WAIT_PUSH;
+			defer_push =3D true;
+		}
+	}
+
+	if (cmd->flags & RWNX_CMD_FLAG_REQ_CFM)
+		cmd->flags |=3D RWNX_CMD_FLAG_WAIT_CFM;
+
+	cmd->tkn =3D cmd_mgr->next_tkn++;
+	cmd->result =3D -EINTR;
+
+	if (!(cmd->flags & RWNX_CMD_FLAG_NONBLOCK))
+		init_completion(&cmd->complete);
+
+	list_add_tail(&cmd->list, &cmd_mgr->cmds);
+	cmd_mgr->queue_sz++;
+	spin_unlock_bh(&cmd_mgr->lock);
+
+	if (!defer_push) {
+		rwnx_set_cmd_tx((void *)(cmd_mgr->sdiodev), cmd->a2e_msg,
+				sizeof(struct lmac_msg) + cmd->a2e_msg->param_len);
+		kfree(cmd->a2e_msg);
+	} else {
+		pr_err("aicbsp ERR: never defer push!!!!");
+		return 0;
+	}
+
+	if (!(cmd->flags & RWNX_CMD_FLAG_NONBLOCK)) {
+		unsigned long tout =3D
+			msecs_to_jiffies(RWNX_80211_CMD_TIMEOUT_MS * cmd_mgr->queue_sz);
+		if (!wait_for_completion_timeout(&cmd->complete, tout)) {
+			pr_crit("aicbsp cmd timed-out\n");
+			cmd_dump(cmd);
+			spin_lock_bh(&cmd_mgr->lock);
+			cmd_mgr->state =3D RWNX_CMD_MGR_STATE_CRASHED;
+			if (!(cmd->flags & RWNX_CMD_FLAG_DONE)) {
+				cmd->result =3D -ETIMEDOUT;
+				cmd_complete(cmd_mgr, cmd);
+			}
+			spin_unlock_bh(&cmd_mgr->lock);
+			err =3D -ETIMEDOUT;
+		} else {
+			kfree(cmd);
+		}
+	} else {
+		cmd->result =3D 0;
+	}
+
+	return err;
+}
+
+static int cmd_mgr_run_callback(struct rwnx_cmd_mgr *cmd_mgr,
+				struct rwnx_cmd *cmd,
+				struct rwnx_cmd_e2amsg *msg, msg_cb_fct cb)
+{
+	int res;
+
+	if (!cb)
+		return 0;
+	spin_lock(&cmd_mgr->cb_lock);
+	res =3D cb(cmd, msg);
+	spin_unlock(&cmd_mgr->cb_lock);
+
+	return res;
+}
+
+static int cmd_mgr_msgind(struct rwnx_cmd_mgr *cmd_mgr,
+			  struct rwnx_cmd_e2amsg *msg, msg_cb_fct cb)
+{
+	struct rwnx_cmd *cmd;
+	bool found =3D false;
+
+	// printk("aicbsp cmd->id=3D%x\n", msg->id);
+	spin_lock(&cmd_mgr->lock);
+	list_for_each_entry(cmd, &cmd_mgr->cmds, list) {
+		if (cmd->reqid =3D=3D msg->id && (cmd->flags & RWNX_CMD_FLAG_WAIT_CFM)) =
{
+			if (!cmd_mgr_run_callback(cmd_mgr, cmd, msg, cb)) {
+				found =3D true;
+				cmd->flags &=3D ~RWNX_CMD_FLAG_WAIT_CFM;
+
+				if (WARN(msg->param_len > RWNX_CMD_E2AMSG_LEN_MAX,
+					 "Unexpect E2A msg len %d > %d\n", msg->param_len,
+						 RWNX_CMD_E2AMSG_LEN_MAX)) {
+					msg->param_len =3D RWNX_CMD_E2AMSG_LEN_MAX;
+				}
+
+				if (cmd->e2a_msg && msg->param_len)
+					memcpy(cmd->e2a_msg, &msg->param, msg->param_len);
+
+				if (RWNX_CMD_WAIT_COMPLETE(cmd->flags))
+					cmd_complete(cmd_mgr, cmd);
+
+				break;
+			}
+		}
+	}
+	spin_unlock(&cmd_mgr->lock);
+
+	if (!found)
+		cmd_mgr_run_callback(cmd_mgr, NULL, msg, cb);
+
+	return 0;
+}
+
+static void cmd_mgr_print(struct rwnx_cmd_mgr *cmd_mgr)
+{
+	struct rwnx_cmd *cur;
+
+	if (!cmd_mgr) {
+		pr_err("aicbsp %s cmd_mgr is null\n", __func__);
+		return;
+	}
+
+	spin_lock_bh(&cmd_mgr->lock);
+	list_for_each_entry(cur, &cmd_mgr->cmds, list) {
+		cmd_dump(cur);
+	}
+	spin_unlock_bh(&cmd_mgr->lock);
+}
+
+static void cmd_mgr_drain(struct rwnx_cmd_mgr *cmd_mgr)
+{
+	struct rwnx_cmd *cur, *nxt;
+
+	if (!cmd_mgr) {
+		pr_err("aicbsp %s cmd_mgr is null\n", __func__);
+		return;
+	}
+
+	spin_lock_bh(&cmd_mgr->lock);
+	list_for_each_entry_safe(cur, nxt, &cmd_mgr->cmds, list) {
+		list_del(&cur->list);
+		cmd_mgr->queue_sz--;
+		if (!(cur->flags & RWNX_CMD_FLAG_NONBLOCK))
+			complete(&cur->complete);
+	}
+	spin_unlock_bh(&cmd_mgr->lock);
+}
+
+void rwnx_cmd_mgr_init(struct rwnx_cmd_mgr *cmd_mgr)
+{
+	cmd_mgr->max_queue_sz =3D RWNX_CMD_MAX_QUEUED;
+	INIT_LIST_HEAD(&cmd_mgr->cmds);
+	cmd_mgr->state =3D RWNX_CMD_MGR_STATE_INITED;
+	spin_lock_init(&cmd_mgr->lock);
+	spin_lock_init(&cmd_mgr->cb_lock);
+	cmd_mgr->queue =3D &cmd_mgr_queue;
+	cmd_mgr->print =3D &cmd_mgr_print;
+	cmd_mgr->drain =3D &cmd_mgr_drain;
+	cmd_mgr->llind =3D NULL;
+	cmd_mgr->msgind =3D &cmd_mgr_msgind;
+}
+
+void rwnx_cmd_mgr_deinit(struct rwnx_cmd_mgr *cmd_mgr)
+{
+	if (!cmd_mgr) {
+		pr_err("aicbsp %s cmd_mgr is null\n", __func__);
+		return;
+	}
+	cmd_mgr->print(cmd_mgr);
+	cmd_mgr->drain(cmd_mgr);
+	cmd_mgr->print(cmd_mgr);
+	memset(cmd_mgr, 0, sizeof(*cmd_mgr));
+}
+
+void rwnx_set_cmd_tx(void *dev, struct lmac_msg *msg, uint len)
+{
+	struct aic_sdio_dev *sdiodev =3D (struct aic_sdio_dev *)dev;
+	struct aicwf_bus *bus =3D sdiodev->bus_if;
+	u8 *buffer =3D bus->cmd_buf;
+	u16 index =3D 0;
+
+	memset(buffer, 0, CMD_BUF_MAX);
+	buffer[0] =3D (len + 4) & 0x00ff;
+	buffer[1] =3D ((len + 4) >> 8) & 0x0f;
+	buffer[2] =3D 0x11;
+	if (sdiodev->chip_ops->use_hdr_checksum)
+		buffer[3] =3D crc8_ponl_107(&buffer[0], 3); // crc8
+	else
+		buffer[3] =3D 0x0;
+
+	index +=3D 4;
+	// there is a dummy word
+	index +=3D 4;
+
+	// make sure little endian
+	put_u16(&buffer[index], msg->id);
+	index +=3D 2;
+	put_u16(&buffer[index], msg->dest_id);
+	index +=3D 2;
+	put_u16(&buffer[index], msg->src_id);
+	index +=3D 2;
+	put_u16(&buffer[index], msg->param_len);
+	index +=3D 2;
+	memcpy(&buffer[index], (u8 *)msg->param, msg->param_len);
+
+	aicwf_bus_txmsg(bus, buffer, len + 8);
+}
+
+static inline void *rwnx_msg_zalloc(lmac_msg_id_t const id,
+				    lmac_task_id_t const dest_id,
+									lmac_task_id_t const src_id,
+									uint16_t const param_len)
+{
+	struct lmac_msg *msg;
+	gfp_t flags;
+
+	if (in_softirq())
+		flags =3D GFP_ATOMIC;
+	else
+		flags =3D GFP_KERNEL;
+
+	msg =3D
+		kzalloc(sizeof(struct lmac_msg) + param_len, flags);
+	if (!msg) {
+		pr_crit("aicbsp %s: msg allocation failed\n", __func__);
+		return NULL;
+	}
+	msg->id =3D id;
+	msg->dest_id =3D dest_id;
+	msg->src_id =3D src_id;
+	msg->param_len =3D param_len;
+
+	return msg->param;
+}
+
+static void rwnx_msg_free(struct lmac_msg *msg, const void *msg_params)
+{
+	kfree(msg);
+}
+
+static int rwnx_send_msg(struct aic_sdio_dev *sdiodev, const void *msg_par=
ams,
+			 int reqcfm, lmac_msg_id_t reqid, void *cfm)
+{
+	struct lmac_msg *msg;
+	struct rwnx_cmd *cmd;
+	bool nonblock;
+	int ret =3D 0;
+
+	msg =3D container_of((void *)msg_params, struct lmac_msg, param);
+	if (sdiodev->bus_if->state =3D=3D BUS_DOWN_ST) {
+		rwnx_msg_free(msg, msg_params);
+		pr_info("aicbsp bus is down\n");
+		return 0;
+	}
+
+	nonblock =3D 0;
+	cmd =3D kzalloc_obj(*cmd, nonblock ? GFP_ATOMIC : GFP_KERNEL);
+	cmd->result =3D -EINTR;
+	cmd->id =3D msg->id;
+	cmd->reqid =3D reqid;
+	cmd->a2e_msg =3D msg;
+	cmd->e2a_msg =3D cfm;
+	if (nonblock)
+		cmd->flags =3D RWNX_CMD_FLAG_NONBLOCK;
+	if (reqcfm)
+		cmd->flags |=3D RWNX_CMD_FLAG_REQ_CFM;
+
+	if (reqcfm) {
+		cmd->flags &=3D ~RWNX_CMD_FLAG_WAIT_ACK; // we don't need ack any more
+		ret =3D sdiodev->cmd_mgr.queue(&sdiodev->cmd_mgr, cmd);
+	} else {
+		rwnx_set_cmd_tx((void *)(sdiodev), cmd->a2e_msg,
+				sizeof(struct lmac_msg) + cmd->a2e_msg->param_len);
+	}
+
+	if (!reqcfm)
+		kfree(cmd);
+
+	return ret;
+}
+
+int rwnx_send_dbg_mem_block_write_req(struct aic_sdio_dev *sdiodev,
+				      u32 mem_addr, u32 mem_size, u32 *mem_data)
+{
+	struct dbg_mem_block_write_req *mem_blk_write_req;
+
+	/* Build the DBG_MEM_BLOCK_WRITE_REQ message */
+	mem_blk_write_req =3D
+		rwnx_msg_zalloc(DBG_MEM_BLOCK_WRITE_REQ, TASK_DBG, DRV_TASK_ID,
+				sizeof(struct dbg_mem_block_write_req));
+	if (!mem_blk_write_req)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_MEM_BLOCK_WRITE_REQ message */
+	mem_blk_write_req->memaddr =3D mem_addr;
+	mem_blk_write_req->memsize =3D mem_size;
+	memcpy(mem_blk_write_req->memdata, mem_data, mem_size);
+
+	/* Send the DBG_MEM_BLOCK_WRITE_REQ message to LMAC FW */
+	return rwnx_send_msg(sdiodev, mem_blk_write_req, 1, DBG_MEM_BLOCK_WRITE_C=
FM,
+						 NULL);
+}
+
+int rwnx_send_dbg_mem_read_req(struct aic_sdio_dev *sdiodev, u32 mem_addr,
+			       struct dbg_mem_read_cfm *cfm)
+{
+	struct dbg_mem_read_req *mem_read_req;
+
+	/* Build the DBG_MEM_READ_REQ message */
+	mem_read_req =3D rwnx_msg_zalloc(DBG_MEM_READ_REQ, TASK_DBG, DRV_TASK_ID,
+				       sizeof(struct dbg_mem_read_req));
+	if (!mem_read_req)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_MEM_READ_REQ message */
+	mem_read_req->memaddr =3D mem_addr;
+
+	/* Send the DBG_MEM_READ_REQ message to LMAC FW */
+	return rwnx_send_msg(sdiodev, mem_read_req, 1, DBG_MEM_READ_CFM, cfm);
+}
+
+int rwnx_send_dbg_mem_write_req(struct aic_sdio_dev *sdiodev, u32 mem_addr=
,
+				u32 mem_data)
+{
+	struct dbg_mem_write_req *mem_write_req;
+
+	/* Build the DBG_MEM_WRITE_REQ message */
+	mem_write_req =3D rwnx_msg_zalloc(DBG_MEM_WRITE_REQ, TASK_DBG, DRV_TASK_I=
D,
+					sizeof(struct dbg_mem_write_req));
+	if (!mem_write_req)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_MEM_WRITE_REQ message */
+	mem_write_req->memaddr =3D mem_addr;
+	mem_write_req->memdata =3D mem_data;
+
+	/* Send the DBG_MEM_WRITE_REQ message to LMAC FW */
+	return rwnx_send_msg(sdiodev, mem_write_req, 1, DBG_MEM_WRITE_CFM, NULL);
+}
+
+int rwnx_send_dbg_mem_mask_write_req(struct aic_sdio_dev *sdiodev, u32 mem=
_addr,
+				     u32 mem_mask, u32 mem_data)
+{
+	struct dbg_mem_mask_write_req *mem_mask_write_req;
+
+	/* Build the DBG_MEM_MASK_WRITE_REQ message */
+	mem_mask_write_req =3D
+		rwnx_msg_zalloc(DBG_MEM_MASK_WRITE_REQ, TASK_DBG, DRV_TASK_ID,
+				sizeof(struct dbg_mem_mask_write_req));
+	if (!mem_mask_write_req)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_MEM_MASK_WRITE_REQ message */
+	mem_mask_write_req->memaddr =3D mem_addr;
+	mem_mask_write_req->memmask =3D mem_mask;
+	mem_mask_write_req->memdata =3D mem_data;
+
+	/* Send the DBG_MEM_MASK_WRITE_REQ message to LMAC FW */
+	return rwnx_send_msg(sdiodev, mem_mask_write_req, 1, DBG_MEM_MASK_WRITE_C=
FM,
+						 NULL);
+}
+
+int rwnx_send_dbg_start_app_req(struct aic_sdio_dev *sdiodev, u32 boot_add=
r,
+				u32 boot_type,
+				struct dbg_start_app_cfm *start_app_cfm)
+{
+	struct dbg_start_app_req *start_app_req;
+
+	/* Build the DBG_START_APP_REQ message */
+	start_app_req =3D rwnx_msg_zalloc(DBG_START_APP_REQ, TASK_DBG, DRV_TASK_I=
D,
+					sizeof(struct dbg_start_app_req));
+	if (!start_app_req) {
+		pr_err("aicbsp start app nomen\n");
+		return -ENOMEM;
+	}
+
+	/* Set parameters for the DBG_START_APP_REQ message */
+	start_app_req->bootaddr =3D boot_addr;
+	start_app_req->boottype =3D boot_type;
+
+	/* Send the DBG_START_APP_REQ message to LMAC FW */
+	return rwnx_send_msg(sdiodev, start_app_req, 1, DBG_START_APP_CFM,
+						 start_app_cfm);
+}
+
+static msg_cb_fct dbg_hdlrs[MSG_I(DBG_MAX)] =3D {};
+
+static msg_cb_fct *msg_hdlrs[] =3D {
+	[TASK_DBG] =3D dbg_hdlrs,
+};
+
+void rwnx_rx_handle_msg(struct aic_sdio_dev *sdiodev, struct ipc_e2a_msg *=
msg)
+{
+	sdiodev->cmd_mgr.msgind(&sdiodev->cmd_mgr, msg,
+							msg_hdlrs[MSG_T(msg->id)][MSG_I(msg->id)]);
+}
+
+static inline void print_md5(const u8 *x)
+{
+	pr_info("aicbsp file md5:%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x=
%02x%02x%02x%02x\r\n",
+		x[0], x[1], x[2], x[3], x[4], x[5], x[6], x[7],
+		x[8], x[9], x[10], x[11], x[12], x[13], x[14], x[15]);
+}
+
+static int aicbsp_request_firmware(const struct firmware **fw,
+				   const char *name, struct device *dev)
+{
+	char *fw_name;
+	int ret;
+
+	if (!name || !name[0])
+		return -EINVAL;
+
+	fw_name =3D kasprintf(GFP_KERNEL, AIC8800_FW_DIR "%s", name);
+	if (!fw_name)
+		return -ENOMEM;
+
+	ret =3D request_firmware(fw, fw_name, dev);
+	kfree(fw_name);
+
+	return ret;
+}
+
+int rwnx_load_firmware(u32 **fw_buf, const char *name, struct device *devi=
ce)
+{
+	const struct firmware *fw =3D NULL;
+	u32 *dst =3D NULL;
+	void *buffer =3D NULL;
+#ifdef CONFIG_TEDIOUS_PRT
+	struct MD5_CTX md5;
+	unsigned char decrypt[16];
+#endif
+	int size =3D 0;
+	int ret =3D 0;
+
+	pr_info("aicbsp %s: request firmware =3D %s\n", __func__, name);
+
+	ret =3D aicbsp_request_firmware(&fw, name, device);
+
+	if (ret < 0) {
+		pr_err("aicbsp Load %s fail\n", name);
+		return ret;
+	}
+
+	size =3D fw->size;
+	dst =3D (u32 *)fw->data;
+
+	if (size <=3D 0) {
+		pr_err("aicbsp wrong size of firmware file\n");
+		release_firmware(fw);
+		return -1;
+	}
+
+	buffer =3D vmalloc(size);
+	if (!buffer) {
+		release_firmware(fw);
+		return -ENOMEM;
+	}
+	memset(buffer, 0, size);
+	memcpy(buffer, dst, size);
+
+	*fw_buf =3D buffer;
+
+#ifdef CONFIG_TEDIOUS_PRT
+	md5_init(&md5);
+	md5_update(&md5, (unsigned char *)buffer, size);
+	md5_final(&md5, decrypt);
+	print_md5(decrypt);
+#endif
+
+	release_firmware(fw);
+
+	return size;
+}
+
+extern int testmode;
+
+#ifdef CONFIG_M2D_OTA_AUTO_SUPPORT
+int rwnx_plat_m2d_flash_ota(struct aic_sdio_dev *sdiodev,
+			    char *filename)
+{
+	struct device *dev =3D sdiodev->dev;
+	unsigned int i =3D 0;
+	int size;
+	u32 *dst =3D NULL;
+	int err =3D 0;
+	int ret;
+	u8 bond_id;
+	const u32 mem_addr =3D 0x40500000;
+	struct dbg_mem_read_cfm rd_mem_addr_cfm;
+
+	ret =3D rwnx_send_dbg_mem_read_req(sdiodev, mem_addr, &rd_mem_addr_cfm);
+	if (ret) {
+		pr_err("aicbsp m2d %x rd fail: %d\n", mem_addr, ret);
+		return ret;
+	}
+	bond_id =3D (u8)(rd_mem_addr_cfm.memdata >> 24);
+	pr_info("aicbsp %x=3D%x\n", rd_mem_addr_cfm.memaddr, rd_mem_addr_cfm.memd=
ata);
+	if (bond_id & (1 << 1)) {
+		// flash is invalid
+		pr_err("aicbsp m2d flash is invalid\n");
+		return -1;
+	}
+
+	/* load aic firmware */
+	size =3D rwnx_load_firmware(&dst, filename, dev);
+	if (size <=3D 0) {
+		pr_err("aicbsp wrong size of m2d file\n");
+		vfree(dst);
+		dst =3D NULL;
+		return -1;
+	}
+
+	/* Copy the file on the Embedded side */
+	pr_info("aicbsp ### Upload m2d %s flash, size=3D%d\n", filename, size);
+
+	/*send info first */
+	err =3D rwnx_send_dbg_mem_block_write_req(sdiodev, AIC_M2D_OTA_INFO_ADDR,=
 4,
+						(u32 *)&size);
+
+	/*send data first */
+	if (size > 1024) {                              // > 1KB data
+		for (i =3D 0; i < (size - 1024); i +=3D 1024) { // each time write 1KB
+			err =3D rwnx_send_dbg_mem_block_write_req(sdiodev,
+								AIC_M2D_OTA_DATA_ADDR,
+								1024, dst + i / 4);
+			if (err) {
+				pr_err("aicbsp m2d upload fail: %x, err:%d\r\n",
+				       AIC_M2D_OTA_DATA_ADDR, err);
+				break;
+			}
+		}
+	}
+
+	if (!err && i < size) { // <1KB data
+		err =3D rwnx_send_dbg_mem_block_write_req(sdiodev, AIC_M2D_OTA_DATA_ADDR=
,
+							size - i, dst + i / 4);
+		if (err) {
+			pr_err("aicbsp m2d upload fail: %x, err:%d\r\n", AIC_M2D_OTA_DATA_ADDR,
+			       err);
+		}
+	}
+
+	if (dst) {
+		vfree(dst);
+		dst =3D NULL;
+	}
+	testmode =3D FW_NORMAL_MODE;
+	aicbsp_info.cpmode =3D testmode;
+
+	pr_info("aicbsp m2d flash update complete\n\n");
+
+	return err;
+}
+
+int rwnx_plat_m2d_flash_ota_check(struct aic_sdio_dev *sdiodev, char *file=
name)
+{
+	struct device *dev =3D sdiodev->dev;
+	unsigned int i =3D 0, j =3D 0;
+	int size;
+	u32 *dst =3D NULL;
+	int err =3D 0;
+	int ret =3D 0;
+	u8 bond_id;
+	const u32 mem_addr =3D 0x40500000;
+	const u32 mem_addr_code_start =3D AIC_M2D_OTA_CODE_START_ADDR;
+	const u32 mem_addr_sdk_ver =3D AIC_M2D_OTA_VER_ADDR;
+	const u32 driver_code_start_idx =3D
+		(AIC_M2D_OTA_CODE_START_ADDR - AIC_M2D_OTA_FLASH_ADDR) / 4;
+	const u32 driver_sdk_ver_idx =3D
+		(AIC_M2D_OTA_VER_ADDR - AIC_M2D_OTA_FLASH_ADDR) / 4;
+	u32 driver_sdk_ver_addr_idx =3D 0;
+	u32 code_start_addr =3D 0xffffffff;
+	u32 sdk_ver_addr =3D 0xffffffff;
+	u32 drv_code_start_addr =3D 0xffffffff;
+	u32 drv_sdk_ver_addr =3D 0xffffffff;
+	struct dbg_mem_read_cfm rd_mem_addr_cfm;
+	char m2d_sdk_ver[64];
+	char flash_sdk_ver[64];
+	u32 flash_ver[16];
+	u32 ota_ver[16];
+
+	ret =3D rwnx_send_dbg_mem_read_req(sdiodev, mem_addr, &rd_mem_addr_cfm);
+	if (ret) {
+		pr_err("aicbsp m2d %x rd fail: %d\n", mem_addr, ret);
+		return ret;
+	}
+	bond_id =3D (u8)(rd_mem_addr_cfm.memdata >> 24);
+	pr_info("aicbsp %x=3D%x\n", rd_mem_addr_cfm.memaddr, rd_mem_addr_cfm.memd=
ata);
+	if (bond_id & (1 << 1)) {
+		// flash is invalid
+		pr_err("aicbsp m2d flash is invalid\n");
+		return -1;
+	}
+	ret =3D rwnx_send_dbg_mem_read_req(sdiodev, mem_addr_code_start,
+					 &rd_mem_addr_cfm);
+	if (ret) {
+		pr_err("mem_addr_code_start %x rd fail: %d\n", mem_addr_code_start,
+		       ret);
+		return ret;
+	}
+	code_start_addr =3D rd_mem_addr_cfm.memdata;
+
+#if !defined(CONFIG_M2D_OTA_LZMA_SUPPORT)
+	ret =3D
+		rwnx_send_dbg_mem_read_req(sdiodev, mem_addr_sdk_ver, &rd_mem_addr_cfm);
+	if (ret) {
+		pr_err("aicbsp mem_addr_sdk_ver %x rd fail: %d\n", mem_addr_code_start, =
ret);
+		return ret;
+	}
+	sdk_ver_addr =3D rd_mem_addr_cfm.memdata;
+#else
+	sdk_ver_addr =3D mem_addr_sdk_ver;
+#endif
+	pr_info("aicbsp code_start_addr: 0x%x,	sdk_ver_addr: 0x%x\n", code_start_=
addr,
+		sdk_ver_addr);
+
+	/* load aic firmware */
+	size =3D rwnx_load_firmware(&dst, filename, dev);
+	if (size <=3D 0) {
+		pr_err("aicbsp wrong size of m2d file\n");
+		vfree(dst);
+		dst =3D NULL;
+		return -1;
+	}
+	if (code_start_addr =3D=3D 0xffffffff && sdk_ver_addr =3D=3D 0xffffffff) =
{
+		pr_warn("aicbsp ########m2d flash old version , must be upgrade\n");
+		drv_code_start_addr =3D dst[driver_code_start_idx];
+		drv_sdk_ver_addr =3D dst[driver_sdk_ver_idx];
+
+		pr_info("aicbsp drv_code_start_addr: 0x%x,	drv_sdk_ver_addr: 0x%x\n",
+			drv_code_start_addr, drv_sdk_ver_addr);
+
+		if (drv_sdk_ver_addr =3D=3D 0xffffffff) {
+			pr_err("aicbsp ########driver m2d_ota.bin is old ,not need upgrade\n");
+			return -1;
+		}
+
+	} else {
+		for (i =3D 0; i < 16; i++) {
+			ret =3D rwnx_send_dbg_mem_read_req(sdiodev, (sdk_ver_addr + i * 4),
+							 &rd_mem_addr_cfm);
+			if (ret) {
+				pr_err("aicbsp mem_addr_sdk_ver %x rd fail: %d\n",
+				       mem_addr_code_start, ret);
+				return ret;
+			}
+			flash_ver[i] =3D rd_mem_addr_cfm.memdata;
+		}
+		memcpy((u8 *)flash_sdk_ver, (u8 *)flash_ver, 64);
+		memcpy((u8 *)saved_sdk_ver, (u8 *)flash_sdk_ver, 64);
+		pr_info("aicbsp flash SDK Version: %s\r\n\r\n", flash_sdk_ver);
+
+		drv_code_start_addr =3D dst[driver_code_start_idx];
+		drv_sdk_ver_addr =3D dst[driver_sdk_ver_idx];
+
+		pr_info("aicbsp drv_code_start_addr: 0x%x,	drv_sdk_ver_addr: 0x%x\n",
+			drv_code_start_addr, drv_sdk_ver_addr);
+
+		if (drv_sdk_ver_addr =3D=3D 0xffffffff) {
+			pr_err("aicbsp ########driver m2d_ota.bin is old ,not need upgrade\n");
+			return -1;
+		}
+#if !defined(CONFIG_M2D_OTA_LZMA_SUPPORT)
+		driver_sdk_ver_addr_idx =3D (drv_sdk_ver_addr - drv_code_start_addr) / 4=
;
+#else
+		driver_sdk_ver_addr_idx =3D driver_sdk_ver_idx;
+#endif
+		pr_info("aicbsp driver_sdk_ver_addr_idx %d\n", driver_sdk_ver_addr_idx);
+
+		if (driver_sdk_ver_addr_idx) {
+			for (j =3D 0; j < 16; j++)
+				ota_ver[j] =3D dst[driver_sdk_ver_addr_idx + j];
+
+			memcpy((u8 *)m2d_sdk_ver, (u8 *)ota_ver, 64);
+			pr_info("aicbsp m2d_ota SDK Version: %s\r\n\r\n", m2d_sdk_ver);
+		} else {
+			return -1;
+		}
+
+		if (!strcmp(m2d_sdk_ver, flash_sdk_ver)) {
+			pr_err("aicbsp ######## m2d %s flash is not need upgrade\r\n", filename=
);
+			return -1;
+		}
+	}
+
+	/* Copy the file on the Embedded side */
+	pr_info("aicbsp ### Upload m2d %s flash, size=3D%d\n", filename, size);
+
+	/*send info first */
+	err =3D rwnx_send_dbg_mem_block_write_req(sdiodev, AIC_M2D_OTA_INFO_ADDR,=
 4,
+						(u32 *)&size);
+
+	/*send data first */
+	if (size > 1024) {                              // > 1KB data
+		for (i =3D 0; i < (size - 1024); i +=3D 1024) { // each time write 1KB
+			err =3D rwnx_send_dbg_mem_block_write_req(sdiodev, AIC_M2D_OTA_DATA_ADD=
R,
+								1024, dst + i / 4);
+			if (err) {
+				pr_err("aicbsp m2d upload fail: %x, err:%d\r\n",
+				       AIC_M2D_OTA_DATA_ADDR, err);
+				break;
+			}
+		}
+	}
+
+	if (!err && i < size) {
+		err =3D rwnx_send_dbg_mem_block_write_req(sdiodev, AIC_M2D_OTA_DATA_ADDR=
,
+							size - i, dst + i / 4);
+		if (err) {
+			pr_err("aicbsp m2d upload fail: %x, err:%d\r\n", AIC_M2D_OTA_DATA_ADDR,
+			       err);
+		}
+	}
+
+	if (dst) {
+		vfree(dst);
+		dst =3D NULL;
+	}
+	testmode =3D FW_NORMAL_MODE;
+
+	pr_info("aicbsp m2d flash update complete\n\n");
+
+	return err;
+}
+#endif // CONFIG_M2D_OTA_AUTO_SUPPORT
+
+int aicwf_patch_table_load(struct aic_sdio_dev *rwnx_hw, char *filename)
+{
+	struct device *dev =3D rwnx_hw->dev;
+	int err =3D 0;
+	unsigned int i =3D 0, size;
+	u32 *dst =3D NULL;
+	u8 *describle;
+	u32 fmacfw_patch_tbl_8800dc_u02_describe_size =3D 124;
+	u32 fmacfw_patch_tbl_8800dc_u02_describe_base; // read from patch_tbl
+
+	/* Copy the file on the Embedded side */
+	pr_info("aicbsp ### Upload %s\n", filename);
+
+	size =3D rwnx_load_firmware(&dst, filename, dev);
+	if (!dst) {
+		pr_err("aicbsp No such file or directory\n");
+		return -1;
+	}
+	if (size <=3D 0) {
+		pr_err("aicbsp wrong size of firmware file\n");
+		dst =3D NULL;
+		err =3D -1;
+	}
+
+	pr_info("aicbsp tbl size =3D %d\n", size);
+
+	fmacfw_patch_tbl_8800dc_u02_describe_base =3D dst[0];
+	AICWFDBG(LOGINFO, "FMACFW_PATCH_TBL_8800DC_U02_DESCRIBE_BASE =3D %x\n",
+		 fmacfw_patch_tbl_8800dc_u02_describe_base);
+
+	if (!err && i < size) {
+		err =3D rwnx_send_dbg_mem_block_write_req(rwnx_hw,
+							fmacfw_patch_tbl_8800dc_u02_describe_base,
+			fmacfw_patch_tbl_8800dc_u02_describe_size + 4, dst);
+		if (err)
+			pr_err("aicbsp write describe information fail\n");
+
+		describle =3D
+			kzalloc(fmacfw_patch_tbl_8800dc_u02_describe_size, GFP_KERNEL);
+		memcpy(describle, &dst[1], fmacfw_patch_tbl_8800dc_u02_describe_size);
+		pr_info("aicbsp %s", describle);
+		kfree(describle);
+		describle =3D NULL;
+	}
+
+	if (!err && i < size) {
+		for (i =3D (128 / 4); i < (size / 4); i +=3D 2) {
+			pr_info("aicbsp patch_tbl:  %x  %x\n", dst[i], dst[i + 1]);
+			err =3D rwnx_send_dbg_mem_write_req(rwnx_hw, dst[i], dst[i + 1]);
+		}
+		if (err)
+			pr_err("aicbsp bin upload fail: %x, err:%d\r\n", dst[i], err);
+	}
+
+	if (dst) {
+		vfree(dst);
+		dst =3D NULL;
+	}
+
+	return err;
+}
+
+int aicwf_plat_patch_load_8800dc(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+#if !defined(CONFIG_FPGA_VERIFICATION)
+	if (chip_sub_id =3D=3D 0) {
+		pr_info("aicbsp u01 is loaing ###############\n");
+		ret =3D rwnx_plat_bin_fw_upload(sdiodev, ROM_FMAC_PATCH_ADDR,
+					      RWNX_MAC_PATCH_NAME2_8800DC);
+	} else if (chip_sub_id =3D=3D 1) {
+		pr_info("aicbsp u02 is loaing ###############\n");
+		ret =3D rwnx_plat_bin_fw_upload(sdiodev, ROM_FMAC_PATCH_ADDR,
+					      RWNX_MAC_PATCH_NAME2_8800DC_U02);
+	} else if (chip_sub_id =3D=3D 2) {
+		pr_info("aicbsp h_u02 is loaing ###############\n");
+		ret =3D rwnx_plat_bin_fw_upload(sdiodev, ROM_FMAC_PATCH_ADDR,
+					      RWNX_MAC_PATCH_NAME2_8800DC_H_U02);
+	} else {
+		pr_info("aicbsp unsupported id: %d\n", chip_sub_id);
+	}
+#endif
+	return ret;
+}
+
+int aicwf_plat_rftest_load_8800dc(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+
+	ret =3D rwnx_plat_bin_fw_upload(sdiodev, RAM_LMAC_FW_ADDR,
+				      RWNX_MAC_FW_RF_BASE_NAME_8800DC);
+	if (ret) {
+		AICWFDBG(LOGINFO, "load rftest bin fail: %d\n", ret);
+		return ret;
+	}
+	return ret;
+}
+
+#ifdef CONFIG_DPD
+int aicwf_misc_ram_valid_check_8800dc(struct aic_sdio_dev *sdiodev,
+				      int *valid_out)
+{
+	int ret =3D 0;
+	u32 cfg_base =3D 0x10164;
+	struct dbg_mem_read_cfm cfm;
+	u32 misc_ram_addr;
+	u32 ram_base_addr, ram_word_cnt;
+	u32 bit_mask[4];
+	int i;
+
+	if (valid_out)
+		*valid_out =3D 0;
+
+	if (testmode =3D=3D FW_RFTEST_MODE) {
+		u32 vect1 =3D 0;
+		u32 vect2 =3D 0;
+
+		cfg_base =3D RAM_LMAC_FW_ADDR + 0x0004;
+		ret =3D rwnx_send_dbg_mem_read_req(sdiodev, cfg_base, &cfm);
+		if (ret) {
+			AICWFDBG(LOGERROR, "cfg_base:%x vcet1 rd fail: %d\n", cfg_base,
+				 ret);
+			return ret;
+		}
+		vect1 =3D cfm.memdata;
+		if ((vect1 & 0xFFFF0000) !=3D (RAM_LMAC_FW_ADDR & 0xFFFF0000)) {
+			AICWFDBG(LOGERROR, "vect1 invalid: %x\n", vect1);
+			return ret;
+		}
+		cfg_base =3D RAM_LMAC_FW_ADDR + 0x0008;
+		ret =3D rwnx_send_dbg_mem_read_req(sdiodev, cfg_base, &cfm);
+		if (ret) {
+			AICWFDBG(LOGERROR, "cfg_base:%x vcet2 rd fail: %d\n", cfg_base,
+				 ret);
+			return ret;
+		}
+		vect2 =3D cfm.memdata;
+		if ((vect2 & 0xFFFF0000) !=3D (RAM_LMAC_FW_ADDR & 0xFFFF0000)) {
+			AICWFDBG(LOGERROR, "vect2 invalid: %x\n", vect2);
+			return ret;
+		}
+
+		cfg_base =3D RAM_LMAC_FW_ADDR + 0x0164;
+	}
+	// init misc ram
+	ret =3D rwnx_send_dbg_mem_read_req(sdiodev, cfg_base + 0x14, &cfm);
+	if (ret) {
+		AICWFDBG(LOGERROR, "rf misc ram[0x%x] rd fail: %d\n", cfg_base + 0x14,
+			 ret);
+		return ret;
+	}
+	misc_ram_addr =3D cfm.memdata;
+	AICWFDBG(LOGERROR, "misc_ram_addr=3D%x\n", misc_ram_addr);
+	// bit_mask
+	ram_base_addr =3D misc_ram_addr + offsetof(struct rf_misc_ram_t, bit_mask=
);
+	ram_word_cnt =3D (MEMBER_SIZE(struct rf_misc_ram_t, bit_mask) +
+					MEMBER_SIZE(struct rf_misc_ram_t, reserved)) /
+				   4;
+	for (i =3D 0; i < ram_word_cnt; i++) {
+		ret =3D rwnx_send_dbg_mem_read_req(sdiodev, ram_base_addr + i * 4, &cfm)=
;
+		if (ret) {
+			AICWFDBG(LOGERROR, "bit_mask[0x%x] rd fail: %d\n",
+				 ram_base_addr + i * 4, ret);
+			return ret;
+		}
+		bit_mask[i] =3D cfm.memdata;
+	}
+	AICWFDBG(LOGTRACE, "bit_mask:%x,%x,%x,%x\n", bit_mask[0], bit_mask[1],
+		 bit_mask[2], bit_mask[3]);
+	if (bit_mask[0] =3D=3D 0 && ((bit_mask[1] & 0xFFF00000) =3D=3D 0x80000000=
) &&
+	    bit_mask[2] =3D=3D 0 && ((bit_mask[3] & 0xFFFFFF00) =3D=3D 0x00000000=
)) {
+		if (valid_out)
+			*valid_out =3D 1;
+	}
+	return ret;
+}
+
+int aicwf_plat_calib_load_8800dc(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+
+	if (chip_sub_id =3D=3D 1) {
+		ret =3D rwnx_plat_bin_fw_upload(sdiodev, ROM_FMAC_CALIB_ADDR,
+					      RWNX_MAC_CALIB_NAME_8800DC_U02);
+		if (ret) {
+			AICWFDBG(LOGINFO, "load rftest bin fail: %d\n", ret);
+			return ret;
+		}
+	} else if (chip_sub_id =3D=3D 2) {
+		ret =3D rwnx_plat_bin_fw_upload(sdiodev, ROM_FMAC_CALIB_ADDR,
+					      RWNX_MAC_CALIB_NAME_8800DC_H_U02);
+		if (ret) {
+			AICWFDBG(LOGINFO, "load rftest bin fail: %d\n", ret);
+			return ret;
+		}
+	}
+	return ret;
+}
+
+#endif
+
+#ifdef CONFIG_DPD
+/**
+ * var dpd_res - DPD calibration result shared with the WLAN driver
+ */
+struct rf_misc_ram_lite_t dpd_res =3D {
+	{0},
+};
+EXPORT_SYMBOL_GPL(dpd_res);
+#endif
+
+int rwnx_plat_bin_fw_upload(struct aic_sdio_dev *sdiodev, u32 fw_addr,
+			    const char *filename)
+{
+	struct device *dev =3D sdiodev->dev;
+	unsigned int i =3D 0;
+	int size;
+	u32 *dst =3D NULL;
+	int err =3D 0;
+
+	pr_info("aicbsp %s\n", __func__);
+
+	/* load aic firmware */
+	size =3D rwnx_load_firmware(&dst, filename, dev);
+	if (size <=3D 0) {
+		pr_err("aicbsp wrong size of firmware file\n");
+		vfree(dst);
+		dst =3D NULL;
+		return -1;
+	}
+
+	/* Copy the file on the Embedded side */
+	if (size > 1024) {                              // > 1KB data
+		for (i =3D 0; i < (size - 1024); i +=3D 1024) { // each time write 1KB
+			err =3D rwnx_send_dbg_mem_block_write_req(sdiodev, fw_addr + i, 1024,
+								dst + i / 4);
+			if (err) {
+				pr_err("aicbsp bin upload fail: %x, err:%d\r\n", fw_addr + i, err);
+				break;
+			}
+		}
+	}
+
+	if (!err && i < size) { // <1KB data
+		err =3D rwnx_send_dbg_mem_block_write_req(sdiodev, fw_addr + i, size - i=
,
+							dst + i / 4);
+		if (err)
+			pr_err("aicbsp bin upload fail: %x, err:%d\r\n", fw_addr + i, err);
+	}
+
+	if (dst) {
+		vfree(dst);
+		dst =3D NULL;
+	}
+
+	return err;
+}
+
+int aicbt_patch_table_free(struct aicbt_patch_table **head)
+{
+	struct aicbt_patch_table *p =3D *head, *n =3D NULL;
+
+	while (p) {
+		n =3D p->next;
+		vfree(p->name);
+		vfree(p->data);
+		vfree(p);
+		p =3D n;
+	}
+	*head =3D NULL;
+	return 0;
+}
+
+struct aicbt_patch_table *aicbt_patch_table_alloc(const char *filename)
+{
+	u8 *rawdata =3D NULL, *p;
+	int size;
+	struct aicbt_patch_table *head =3D NULL, *new =3D NULL, *cur =3D NULL;
+
+	/* load aic firmware */
+	size =3D rwnx_load_firmware((u32 **)&rawdata, filename, NULL);
+	if (size <=3D 0) {
+		pr_err("aicbsp wrong size of firmware file\n");
+		goto err;
+	}
+
+	p =3D rawdata;
+	if (memcmp(p, AICBT_PT_TAG,
+		   sizeof(AICBT_PT_TAG) < 16 ? sizeof(AICBT_PT_TAG) : 16)) {
+		pr_err("aicbsp TAG err\n");
+		goto err;
+	}
+	p +=3D 16;
+
+	while (p - rawdata < size) {
+		new =3D vmalloc(sizeof(*new));
+		memset(new, 0, sizeof(struct aicbt_patch_table));
+		if (!head) {
+			head =3D new;
+			cur =3D new;
+		} else {
+			cur->next =3D new;
+			cur =3D cur->next;
+		}
+
+		cur->name =3D vmalloc(sizeof(char) * 16);
+		memset(cur->name, 0, sizeof(char) * 16);
+		memcpy(cur->name, p, 16);
+		p +=3D 16;
+
+		cur->type =3D *(uint32_t *)p;
+		p +=3D 4;
+
+		cur->len =3D *(uint32_t *)p;
+		p +=3D 4;
+
+		if (cur->type >=3D 1000) { // Temp Workaround
+			cur->len =3D 0;
+		} else {
+			if (cur->len > 0) {
+				cur->data =3D vmalloc(sizeof(uint8_t) * cur->len * 8);
+				memset(cur->data, 0, sizeof(uint8_t) * cur->len * 8);
+				memcpy(cur->data, p, cur->len * 8);
+				p +=3D cur->len * 8;
+			}
+		}
+	}
+	vfree(rawdata);
+	return head;
+
+err:
+	aicbt_patch_table_free(&head);
+	if (rawdata)
+		vfree(rawdata);
+	return NULL;
+}
+
+int aicbt_patch_info_unpack(struct aicbt_patch_info_t *patch_info,
+			    struct aicbt_patch_table *head_t)
+{
+	u8 *patch_info_array =3D (u8 *)patch_info;
+
+	if (head_t->type =3D=3D AICBT_PT_INF) {
+		patch_info->info_len =3D head_t->len;
+		if (patch_info->info_len =3D=3D 0)
+			return 0;
+
+		memcpy(patch_info_array + sizeof(patch_info->info_len),
+		       head_t->data,
+		       patch_info->info_len * sizeof(uint32_t) * 2);
+		AICWFDBG(LOGDEBUG, "%s adid_addrinf:%x addr_adid:%x \r\n", __func__,
+			 ((struct aicbt_patch_info_t *)patch_info_array)->adid_addrinf,
+			 ((struct aicbt_patch_info_t *)patch_info_array)->addr_adid);
+	}
+	return 0;
+}
+
+int aicbt_patch_trap_data_load(struct aic_sdio_dev *sdiodev,
+			       struct aicbt_patch_table *head)
+{
+	struct aicbt_patch_info_t patch_info =3D {
+		.info_len =3D 0,
+		.adid_addrinf =3D 0,
+		.addr_adid =3D 0,
+		.patch_addrinf =3D 0,
+		.addr_patch =3D 0,
+		.reset_addr =3D 0,
+		.reset_val =3D 0,
+		.adid_flag_addr =3D 0,
+		.adid_flag =3D 0,
+	};
+
+	int ret;
+
+	if (!head)
+		return -1;
+
+	ret =3D aic_chip_set_patch_info(sdiodev, &patch_info, &aicbsp_info, head)=
;
+	if (ret) {
+		pr_err("aicbsp chip set patch info fail\n");
+		return ret;
+	}
+
+	if (rwnx_plat_bin_fw_upload(sdiodev, patch_info.addr_adid,
+				    aicbsp_firmware_list[aicbsp_info.cpmode].bt_adid))
+		return -1;
+	if (rwnx_plat_bin_fw_upload(sdiodev, patch_info.addr_patch,
+				    aicbsp_firmware_list[aicbsp_info.cpmode].bt_patch))
+		return -1;
+	return 0;
+}
+
+static struct aicbt_info_t aicbt_info[] =3D {
+	{
+		.btmode =3D AICBT_BTMODE_DEFAULT,
+		.btport =3D AICBT_BTPORT_DEFAULT,
+		.uart_baud =3D AICBT_UART_BAUD_DEFAULT,
+		.uart_flowctrl =3D AICBT_UART_FC_DEFAULT,
+		.lpm_enable =3D AICBT_LPM_ENABLE_DEFAULT,
+		.txpwr_lvl =3D AICBT_TXPWR_LVL_DEFAULT,
+	}, // PRODUCT_ID_AIC8801
+	{
+		.btmode =3D AICBT_BTMODE_BT_WIFI_COMBO,
+		.btport =3D AICBT_BTPORT_DEFAULT,
+		.uart_baud =3D AICBT_UART_BAUD_DEFAULT,
+		.uart_flowctrl =3D AICBT_UART_FC_DEFAULT,
+		.lpm_enable =3D AICBT_LPM_ENABLE_DEFAULT,
+		.txpwr_lvl =3D AICBT_TXPWR_LVL_DEFAULT_8800dc,
+	}, // PRODUCT_ID_AIC8800DC
+	{
+		.btmode =3D AICBT_BTMODE_BT_WIFI_COMBO,
+		.btport =3D AICBT_BTPORT_DEFAULT,
+		.uart_baud =3D AICBT_UART_BAUD_DEFAULT,
+		.uart_flowctrl =3D AICBT_UART_FC_DEFAULT,
+		.lpm_enable =3D AICBT_LPM_ENABLE_DEFAULT,
+		.txpwr_lvl =3D AICBT_TXPWR_LVL_DEFAULT_8800dc,
+	}, // PRODUCT_ID_AIC8800DW
+	{
+		.btmode =3D AICBT_BTMODE_DEFAULT_8800d80,
+		.btport =3D AICBT_BTPORT_DEFAULT,
+		.uart_baud =3D AICBT_UART_BAUD_DEFAULT,
+		.uart_flowctrl =3D AICBT_UART_FC_DEFAULT,
+		.lpm_enable =3D AICBT_LPM_ENABLE_DEFAULT,
+		.txpwr_lvl =3D AICBT_TXPWR_LVL_DEFAULT_8800d80,
+	} // PRODUCT_ID_AIC8800D80
+};
+
+int aicbt_patch_table_load(struct aic_sdio_dev *sdiodev,
+			   struct aicbt_patch_table *head)
+{
+	struct aicbt_patch_table *p;
+	int ret =3D 0, i;
+	u32 *data =3D NULL;
+
+	if (!head)
+		return -1;
+
+	for (p =3D head; p; p =3D p->next) {
+		data =3D p->data;
+		if (p->type =3D=3D AICBT_PT_BTMODE) {
+			*(data + 1) =3D aicbsp_info.hwinfo < 0;
+			*(data + 3) =3D aicbsp_info.hwinfo;
+			*(data + 5) =3D (sdiodev->chipid =3D=3D PRODUCT_ID_AIC8800DC
+							   ? aicbsp_info.cpmode
+							   : 0); // 0;//aicbsp_info.cpmode;
+
+			*(data + 7) =3D aicbt_info[sdiodev->chipid].btmode;
+			*(data + 9) =3D aicbt_info[sdiodev->chipid].btport;
+			*(data + 11) =3D aicbt_info[sdiodev->chipid].uart_baud;
+			*(data + 13) =3D aicbt_info[sdiodev->chipid].uart_flowctrl;
+			*(data + 15) =3D aicbt_info[sdiodev->chipid].lpm_enable;
+			*(data + 17) =3D aicbt_info[sdiodev->chipid].txpwr_lvl;
+
+			pr_info("aicbsp %s bt btmode[%d]:%d \r\n", __func__, sdiodev->chipid,
+				aicbt_info[sdiodev->chipid].btmode);
+			pr_info("aicbsp %s bt uart_baud[%d]:%d \r\n", __func__, sdiodev->chipid=
,
+				aicbt_info[sdiodev->chipid].uart_baud);
+			pr_info("aicbsp %s bt uart_flowctrl[%d]:%d \r\n", __func__, sdiodev->ch=
ipid,
+				aicbt_info[sdiodev->chipid].uart_flowctrl);
+			pr_info("aicbsp %s bt lpm_enable[%d]:%d \r\n", __func__, sdiodev->chipi=
d,
+				aicbt_info[sdiodev->chipid].lpm_enable);
+			pr_info("aicbsp %s bt tx_pwr[%d]:%d \r\n", __func__, sdiodev->chipid,
+				aicbt_info[sdiodev->chipid].txpwr_lvl);
+		}
+
+		if (p->type =3D=3D AICBT_PT_VER) {
+			pr_info("aicbsp bt patch version: %s\n", (char *)p->data);
+			continue;
+		}
+
+		for (i =3D 0; i < p->len; i++) {
+			ret =3D rwnx_send_dbg_mem_write_req(sdiodev, *data, *(data + 1));
+			if (ret !=3D 0)
+				return ret;
+			data +=3D 2;
+		}
+		if (p->type =3D=3D AICBT_PT_PWRON)
+			usleep_range(50, 100);
+	}
+
+	return 0;
+}
+
+int aicbt_init(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+	struct aicbt_patch_table *head =3D
+		aicbt_patch_table_alloc(aicbsp_firmware_list[aicbsp_info.cpmode].bt_tabl=
e);
+	if (!head) {
+		pr_err("aicbsp aicbt_patch_table_alloc fail\n");
+		return -1;
+	}
+
+	if (aicbt_patch_trap_data_load(sdiodev, head)) {
+		pr_err("aicbsp aicbt_patch_trap_data_load fail\n");
+		ret =3D -1;
+		goto err;
+	}
+
+	if (aicbt_patch_table_load(sdiodev, head)) {
+		pr_err("aicbsp aicbt_patch_table_load fail\n");
+		ret =3D -1;
+		goto err;
+	}
+
+err:
+	aicbt_patch_table_free(&head);
+	return ret;
+}
+
+int aicwifi_start_from_bootrom(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+
+	/* memory access */
+	const u32 fw_addr =3D RAM_FMAC_FW_ADDR;
+	struct dbg_start_app_cfm start_app_cfm;
+
+	/* fw start */
+	ret =3D rwnx_send_dbg_start_app_req(sdiodev, fw_addr, HOST_START_APP_AUTO=
,
+					  &start_app_cfm);
+	if (ret)
+		return -1;
+	aicbsp_info.hwinfo_r =3D start_app_cfm.bootstatus & 0xFF;
+
+	return 0;
+}
+
+static u32 adaptivity_patch_tbl[][2] =3D {
+	{0x0004, 0x0000320A}, // linkloss_thd
+	{0x0094, 0x00000000}, // ac_param_conf
+	{0x00F8, 0x00010138}, // tx_adaptivity_en
+};
+
+static u32 patch_tbl[][2] =3D {
+#if !defined(CONFIG_LINK_DET_5G)
+	{0x0104, 0x00000000}, // link_det_5g
+#endif
+};
+
+static u32 syscfg_tbl_masked[][3] =3D {
+	{0x40506024, 0x000000FF, 0x000000DF}, // for clk gate lp_level
+};
+
+static u32 rf_tbl_masked[][3] =3D {
+	{0x40344058, 0x00800000, 0x00000000}, // pll trx
+};
+
+int aicwifi_sys_config(struct aic_sdio_dev *sdiodev)
+{
+	int ret, cnt;
+	int syscfg_num =3D sizeof(syscfg_tbl_masked) / sizeof(u32) / 3;
+
+	for (cnt =3D 0; cnt < syscfg_num; cnt++) {
+		ret =3D rwnx_send_dbg_mem_mask_write_req(sdiodev, syscfg_tbl_masked[cnt]=
[0],
+						       syscfg_tbl_masked[cnt][1],
+						       syscfg_tbl_masked[cnt][2]);
+		if (ret) {
+			pr_err("aicbsp %x mask write fail: %d\n", syscfg_tbl_masked[cnt][0], re=
t);
+			return ret;
+		}
+	}
+
+	ret =3D rwnx_send_dbg_mem_mask_write_req(sdiodev, rf_tbl_masked[0][0], rf=
_tbl_masked[0][1],
+					       rf_tbl_masked[0][2]);
+	if (ret) {
+		pr_err("aicbsp rf config %x write fail: %d\n", rf_tbl_masked[0][0], ret)=
;
+		return ret;
+	}
+
+	return 0;
+}
+
+int aicwifi_patch_config(struct aic_sdio_dev *sdiodev)
+{
+	const u32 rd_patch_addr =3D RAM_FMAC_FW_ADDR + 0x0180;
+	u32 config_base;
+	u32 start_addr =3D 0x1e6000;
+	u32 patch_addr =3D start_addr;
+	u32 patch_num =3D sizeof(patch_tbl) / 4;
+	struct dbg_mem_read_cfm rd_patch_addr_cfm;
+	u32 patch_addr_reg =3D 0x1e5318;
+	u32 patch_num_reg =3D 0x1e531c;
+	int ret =3D 0;
+	u16 cnt =3D 0;
+	int tmp_cnt =3D 0;
+	int adap_patch_num =3D 0;
+
+	if (aicbsp_info.cpmode =3D=3D AICBSP_CPMODE_TEST) {
+		patch_addr_reg =3D 0x1e5304;
+		patch_num_reg =3D 0x1e5308;
+	}
+
+	ret =3D
+		rwnx_send_dbg_mem_read_req(sdiodev, rd_patch_addr, &rd_patch_addr_cfm);
+	if (ret) {
+		pr_err("aicbsp patch rd fail\n");
+		return ret;
+	}
+
+	config_base =3D rd_patch_addr_cfm.memdata;
+
+	ret =3D rwnx_send_dbg_mem_write_req(sdiodev, patch_addr_reg, patch_addr);
+	if (ret) {
+		pr_err("aicbsp 0x%x write fail\n", patch_addr_reg);
+		return ret;
+	}
+
+	if (aicbsp_info.adap_test) {
+		pr_err("aicbsp %s for adaptivity test \r\n", __func__);
+		adap_patch_num =3D sizeof(adaptivity_patch_tbl) / 4;
+		ret =3D rwnx_send_dbg_mem_write_req(sdiodev, patch_num_reg,
+						  patch_num + adap_patch_num);
+	} else {
+		ret =3D rwnx_send_dbg_mem_write_req(sdiodev, patch_num_reg, patch_num);
+	}
+	if (ret) {
+		pr_err("aicbsp 0x%x write fail\n", patch_num_reg);
+		return ret;
+	}
+
+	for (cnt =3D 0; cnt < patch_num / 2; cnt +=3D 1) {
+		ret =3D rwnx_send_dbg_mem_write_req(sdiodev, start_addr + 8 * cnt,
+						  patch_tbl[cnt][0] + config_base);
+		if (ret) {
+			pr_err("aicbsp %x write fail\n", start_addr + 8 * cnt);
+			return ret;
+		}
+
+		ret =3D rwnx_send_dbg_mem_write_req(sdiodev, start_addr + 8 * cnt + 4,
+						  patch_tbl[cnt][1]);
+		if (ret) {
+			pr_err("aicbsp %x write fail\n", start_addr + 8 * cnt + 4);
+			return ret;
+		}
+	}
+
+	tmp_cnt =3D cnt;
+
+	if (aicbsp_info.adap_test) { //(adap_test){
+		for (cnt =3D 0; cnt < adap_patch_num / 2; cnt +=3D 1) {
+			ret =3D rwnx_send_dbg_mem_write_req(sdiodev,
+							  start_addr + 8 * (cnt + tmp_cnt),
+							  adaptivity_patch_tbl[cnt][0]
+							  + config_base);
+			if (ret)
+				pr_err("aicbsp %x write fail\n", start_addr + 8 * cnt);
+
+			ret =3D rwnx_send_dbg_mem_write_req(sdiodev, start_addr +
+							  8 * (cnt + tmp_cnt) + 4,
+							  adaptivity_patch_tbl[cnt][1]);
+			if (ret)
+				pr_err("aicbsp %x write fail\n", start_addr + 8 * cnt + 4);
+		}
+	}
+
+	return 0;
+}
+
+int aicwifi_init(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+
+	ret =3D aic_chip_wifi_init(sdiodev, testmode);
+	if (ret) {
+		pr_err("aicbsp wifi init fail\n");
+		return ret;
+	}
+
+#ifdef CONFIG_GPIO_WAKEUP
+	if (aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.wakeup_reg, 4)) {
+		sdio_err("reg:%d write failed!\n", sdiodev->sdio_reg.wakeup_reg);
+		return -1;
+	}
+#endif
+	return 0;
+}
+
+static u32 aicbsp_syscfg_tbl[][2] =3D {
+	{0x40500014, 0x00000101}, // 1)
+	{0x40500018, 0x00000109}, // 2)
+	{0x40500004, 0x00000010}, // 3) the order should not be changed
+
+	// def CONFIG_PMIC_SETTING
+	// U02 bootrom only
+	{0x40040000, 0x00001AC8}, // 1) fix panic
+	{0x40040084, 0x00011580},
+	{0x40040080, 0x00000001},
+	{0x40100058, 0x00000000},
+
+	{0x50000000, 0x03220204}, // 2) pmic interface init
+	{0x50019150, 0x00000002}, // 3) for 26m xtal, set div1
+	{0x50017008, 0x00000000}, // 4) stop wdg
+};
+
+int aicbsp_system_config(struct aic_sdio_dev *sdiodev)
+{
+	int syscfg_num =3D sizeof(aicbsp_syscfg_tbl) / sizeof(u32) / 2;
+	int ret, cnt;
+
+	for (cnt =3D 0; cnt < syscfg_num; cnt++) {
+		ret =3D rwnx_send_dbg_mem_write_req(sdiodev, aicbsp_syscfg_tbl[cnt][0],
+						  aicbsp_syscfg_tbl[cnt][1]);
+		if (ret) {
+			sdio_err("%x write fail: %d\n", aicbsp_syscfg_tbl[cnt][0], ret);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+int aicbsp_platform_init(struct aic_sdio_dev *sdiodev)
+{
+	rwnx_cmd_mgr_init(&sdiodev->cmd_mgr);
+	sdiodev->cmd_mgr.sdiodev =3D (void *)sdiodev;
+
+	return 0;
+}
+
+void aicbsp_platform_deinit(struct aic_sdio_dev *sdiodev)
+{
+	(void)sdiodev;
+}
+
+int aicbsp_driver_fw_init(struct aic_sdio_dev *sdiodev)
+{
+	u32 btenable =3D 0;
+	int ret =3D 0;
+
+	testmode =3D aicbsp_info.cpmode;
+	cur_mode =3D aicbsp_info.cpmode;
+
+	ret =3D aic_chip_driver_fw_init(sdiodev, &btenable, &aicbsp_info, &aicbsp=
_firmware_list);
+	if (ret) {
+		pr_err("aicbsp chip driver fw init fail\n");
+		return -1;
+	}
+
+	AICWFDBG(LOGINFO, "aicbsp: %s, chip rev: %d\n", __func__,
+		 aicbsp_info.chip_rev);
+
+	if (testmode !=3D 4) {
+		if (btenable =3D=3D 1) {
+			if (aicbt_init(sdiodev))
+				return -1;
+		}
+	}
+
+	ret =3D aicwifi_init(sdiodev);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/**
+ * aicbsp_get_feature - Read BSP settings required by the WLAN driver
+ * @feature: Location in which to return the current BSP settings
+ *
+ * Return: 0 on success, or a negative error code if the SDIO device is ab=
sent.
+ */
+int aicbsp_get_feature(struct aicbsp_feature_t *feature)
+{
+	if (!aicbsp_sdiodev) {
+		sdio_err("%s, aicbsp_sdiodev is null\n", __func__);
+		return -1;
+	}
+
+	feature->sdio_clock =3D aicbsp_sdiodev->chip_ops->sdio_clock;
+
+	feature->sdio_phase =3D FEATURE_SDIO_PHASE;
+	feature->cpmode =3D aicbsp_info.cpmode;
+	feature->adapt =3D aicbsp_info.adap_test;
+	feature->hwinfo =3D aicbsp_info.hwinfo;
+	feature->fwlog_en =3D aicbsp_info.fwlog_en;
+	feature->irqf =3D aicbsp_info.irqf;
+	sdio_dbg("%s, set FEATURE_SDIO_CLOCK %d MHz\n", __func__,
+		 feature->sdio_clock / 1000000);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aicbsp_get_feature);
+
+#ifdef CONFIG_RESV_MEM_SUPPORT
+static struct skb_buff_pool resv_skb[] =3D {
+	{AIC_RESV_MEM_TXDATA, 1536 * 64, "resv_mem_txdata", 0, NULL},
+};
+
+int aicbsp_resv_mem_init(void)
+{
+	int i =3D 0;
+
+	pr_info("aicbsp %s\n", __func__);
+	for (i =3D 0; i < ARRAY_SIZE(resv_skb); i++)
+		resv_skb[i].skb =3D dev_alloc_skb(resv_skb[i].size);
+	return 0;
+}
+
+int aicbsp_resv_mem_deinit(void)
+{
+	int i =3D 0;
+
+	pr_info("aicbsp %s\n", __func__);
+	for (i =3D 0; i < ARRAY_SIZE(resv_skb); i++) {
+		if (resv_skb[i].used =3D=3D 0 && resv_skb[i].skb)
+			dev_kfree_skb(resv_skb[i].skb);
+	}
+	return 0;
+}
+
+/**
+ * aicbsp_resv_mem_alloc_skb - Acquire a reserved socket buffer
+ * @length: Minimum required buffer size
+ * @id: Reserved-buffer pool identifier
+ *
+ * Return: The reserved buffer, or %NULL if it is too small, already in us=
e,
+ * or cannot be allocated.
+ */
+struct sk_buff *aicbsp_resv_mem_alloc_skb(unsigned int length, uint32_t id=
)
+{
+	if (resv_skb[id].size < length) {
+		pr_err("aicbsp: %s, no enough mem\n", __func__);
+		goto fail;
+	}
+
+	if (resv_skb[id].used) {
+		pr_err("aicbsp: %s, mem in use\n", __func__);
+		goto fail;
+	}
+
+	if (!resv_skb[id].skb) {
+		//pr_err("aicbsp: %s, skb not initialazed\n", __func__);
+		resv_skb[id].skb =3D
+			dev_alloc_skb(resv_skb[id].size);
+		if (!resv_skb[id].skb) {
+			pr_err("aicbsp: %s, mem reinitial still fail\n", __func__);
+			goto fail;
+		}
+	}
+
+	pr_info("aicbsp: %s, alloc %s succuss, id: %d, size: %d\n", __func__,
+		resv_skb[id].name, resv_skb[id].id, resv_skb[id].size);
+
+	resv_skb[id].used =3D 1;
+	return resv_skb[id].skb;
+
+fail:
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(aicbsp_resv_mem_alloc_skb);
+
+/**
+ * aicbsp_resv_mem_kfree_skb - Release a reserved socket buffer for reuse
+ * @skb: Reserved buffer returned by aicbsp_resv_mem_alloc_skb()
+ * @id: Reserved-buffer pool identifier
+ */
+void aicbsp_resv_mem_kfree_skb(struct sk_buff *skb, uint32_t id)
+{
+	resv_skb[id].used =3D 0;
+	pr_info("aicbsp: %s, free %s succuss, id: %d, size: %d\n", __func__,
+		resv_skb[id].name, resv_skb[id].id, resv_skb[id].size);
+}
+EXPORT_SYMBOL_GPL(aicbsp_resv_mem_kfree_skb);
+
+#else
+
+int aicbsp_resv_mem_init(void)
+{
+	return 0;
+}
+
+int aicbsp_resv_mem_deinit(void)
+{
+	return 0;
+}
+
+#endif
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.h b/driver=
s/net/wireless/aic/aic8800_bsp/aic_bsp_driver.h
new file mode 100644
index 0000000000000..5e24322ad67cb
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.h
@@ -0,0 +1,624 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _AIC_BSP_DRIVER_H
+#define _AIC_BSP_DRIVER_H
+
+#include "aic_bsp_export.h"
+#include <linux/completion.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+
+#define AIC8800_FW_DIR "aic8800/"
+
+#define RWNX_80211_CMD_TIMEOUT_MS 6000
+
+#define RWNX_CMD_FLAG_NONBLOCK  BIT(0)
+#define RWNX_CMD_FLAG_REQ_CFM   BIT(1)
+#define RWNX_CMD_FLAG_WAIT_PUSH BIT(2)
+#define RWNX_CMD_FLAG_WAIT_ACK  BIT(3)
+#define RWNX_CMD_FLAG_WAIT_CFM  BIT(4)
+#define RWNX_CMD_FLAG_DONE      BIT(5)
+/* ATM IPC design makes it possible to get the CFM before the ACK,
+ * otherwise this could have simply been a state enum
+ */
+#define RWNX_CMD_WAIT_COMPLETE(flags)                                     =
     \
+	(!((flags) & (RWNX_CMD_FLAG_WAIT_ACK | RWNX_CMD_FLAG_WAIT_CFM)))
+
+#define RWNX_CMD_MAX_QUEUED 8
+
+#define IPC_E2A_MSG_PARAM_SIZE 256
+
+#define RWNX_FN_ENTRY_STR ">>> %s()\n", __func__
+
+/* message levels */
+#define LOGERROR 0x0001
+#define LOGINFO  0x0002
+#define LOGTRACE 0x0004
+#define LOGDEBUG 0x0008
+#define LOGDATA  0x0010
+
+extern int testmode;
+extern int cur_mode;
+extern int adap_test;
+extern struct aic_sdio_dev *aicbsp_sdiodev;
+extern int aicwf_dbg_level_bsp;
+#ifdef CONFIG_M2D_OTA_AUTO_SUPPORT
+extern char saved_sdk_ver[64];
+#endif
+
+#define AICWF_LOG "AICBSP("
+
+#define AICWFDBG(level, args, arg...)                                     =
     \
+	do {                                                                     =
  \
+		if (aicwf_dbg_level_bsp & (level)) {                                    =
 \
+			pr_debug(AICWF_LOG #level ")\t" args, ##arg);                        \
+		}                                                                      \
+	} while (0)
+
+#define RWNX_DBG(fmt, ...)                                                =
     \
+	do {                                                                     =
  \
+		if (aicwf_dbg_level_bsp & LOGTRACE) {                                  \
+			pr_debug(AICWF_LOG "LOGTRACE)\t" fmt, ##__VA_ARGS__);                \
+		}                                                                      \
+	} while (0)
+
+/// Message structure for MSGs from Emb to App
+struct ipc_e2a_msg {
+	u16 id; ///< Message id.
+	u16 dummy_dest_id;
+	u16 dummy_src_id;
+	u16 param_len;                     ///< Parameter embedded struct length.
+	u32 pattern;                       ///< Used to stamp a valid MSG buffer
+	u32 param[IPC_E2A_MSG_PARAM_SIZE]; ///< Parameter embedded struct. Must b=
e
+									   ///< word-aligned.
+};
+
+typedef u16 lmac_msg_id_t;
+typedef u16 lmac_task_id_t;
+
+struct lmac_msg {
+	lmac_msg_id_t id;       ///< Message id.
+	lmac_task_id_t dest_id; ///< Destination kernel identifier.
+	lmac_task_id_t src_id;  ///< Source kernel identifier.
+	u16 param_len;          ///< Parameter embedded struct length.
+	u32 param[]; ///< Parameter embedded struct. Must be word-aligned.
+};
+
+#define rwnx_cmd_e2amsg         ipc_e2a_msg
+#define rwnx_cmd_a2emsg         lmac_msg
+#define RWNX_CMD_A2EMSG_LEN(m)  (sizeof(struct lmac_msg) + (m)->param_len)
+#define RWNX_CMD_E2AMSG_LEN_MAX (IPC_E2A_MSG_PARAM_SIZE * 4)
+
+static inline void put_u16(u8 *buf, u16 data)
+{
+	buf[0] =3D (u8)(data & 0x00ff);
+	buf[1] =3D (u8)((data >> 8) & 0x00ff);
+}
+
+enum rwnx_cmd_mgr_state {
+	RWNX_CMD_MGR_STATE_DEINIT,
+	RWNX_CMD_MGR_STATE_INITED,
+	RWNX_CMD_MGR_STATE_CRASHED,
+};
+
+struct rwnx_cmd {
+	struct list_head list;
+	lmac_msg_id_t id;
+	lmac_msg_id_t reqid;
+	struct rwnx_cmd_a2emsg *a2e_msg;
+	char *e2a_msg;
+	u32 tkn;
+	u16 flags;
+	struct completion complete;
+	u32 result;
+};
+
+struct aic_sdio_dev;
+struct rwnx_cmd;
+typedef int (*msg_cb_fct)(struct rwnx_cmd *cmd, struct rwnx_cmd_e2amsg *ms=
g);
+
+struct rwnx_cmd_mgr {
+	enum rwnx_cmd_mgr_state state;
+	/* lock for cmd mgr */
+	spinlock_t lock;
+	u32 next_tkn;
+	u32 queue_sz;
+	u32 max_queue_sz;
+	/* lock for cb */
+	spinlock_t cb_lock;
+	void *sdiodev;
+
+	struct list_head cmds;
+
+	int (*queue)(struct rwnx_cmd_mgr *cmd_mgr, struct rwnx_cmd *cmd);
+	int (*llind)(struct rwnx_cmd_mgr *cmd_mgr, struct rwnx_cmd *cmd);
+	int (*msgind)(struct rwnx_cmd_mgr *cmd_mgr,
+		      struct rwnx_cmd_e2amsg *cmd_e2amsg,
+		      msg_cb_fct cb_fct);
+	void (*print)(struct rwnx_cmd_mgr *cmd_mgr);
+	void (*drain)(struct rwnx_cmd_mgr *cmd_mgr);
+
+	struct work_struct cmd_work;
+	struct workqueue_struct *cmd_wq;
+};
+
+void rwnx_cmd_mgr_init(struct rwnx_cmd_mgr *cmd_mgr);
+void rwnx_cmd_mgr_deinit(struct rwnx_cmd_mgr *cmd_mgr);
+int cmd_mgr_queue_force_defer(struct rwnx_cmd_mgr *cmd_mgr,
+			      struct rwnx_cmd *cmd);
+void rwnx_set_cmd_tx(void *dev, struct lmac_msg *msg, uint len);
+
+enum {
+	TASK_NONE =3D (u8)-1,
+
+	// MAC Management task.
+	TASK_MM =3D 0,
+	// DEBUG task
+	TASK_DBG,
+	/// SCAN task
+	TASK_SCAN,
+	/// TDLS task
+	TASK_TDLS,
+	/// SCANU task
+	TASK_SCANU,
+	/// ME task
+	TASK_ME,
+	/// SM task
+	TASK_SM,
+	/// APM task
+	TASK_APM,
+	/// BAM task
+	TASK_BAM,
+	/// MESH task
+	TASK_MESH,
+	/// RXU task
+	TASK_RXU,
+	// This is used to define the last task that is running on the EMB proces=
sor
+	TASK_LAST_EMB =3D TASK_RXU,
+
+	// nX API task
+	TASK_API,
+	TASK_MAX,
+};
+
+#define LMAC_FIRST_MSG(task) ((lmac_msg_id_t)((task) << 10))
+#define DRV_TASK_ID          100
+#define MSG_I(msg)           ((msg) & ((1 << 10) - 1))
+#define MSG_T(msg)           ((lmac_task_id_t)((msg) >> 10))
+
+enum dbg_msg_tag {
+	/// Memory read request
+	DBG_MEM_READ_REQ =3D LMAC_FIRST_MSG(TASK_DBG),
+	/// Memory read confirm
+	DBG_MEM_READ_CFM,
+	/// Memory write request
+	DBG_MEM_WRITE_REQ,
+	/// Memory write confirm
+	DBG_MEM_WRITE_CFM,
+	/// Module filter request
+	DBG_SET_MOD_FILTER_REQ,
+	/// Module filter confirm
+	DBG_SET_MOD_FILTER_CFM,
+	/// Severity filter request
+	DBG_SET_SEV_FILTER_REQ,
+	/// Severity filter confirm
+	DBG_SET_SEV_FILTER_CFM,
+	/// LMAC/MAC HW fatal error indication
+	DBG_ERROR_IND,
+	/// Request to get system statistics
+	DBG_GET_SYS_STAT_REQ,
+	/// COnfirmation of system statistics
+	DBG_GET_SYS_STAT_CFM,
+	/// Memory block write request
+	DBG_MEM_BLOCK_WRITE_REQ,
+	/// Memory block write confirm
+	DBG_MEM_BLOCK_WRITE_CFM,
+	/// Start app request
+	DBG_START_APP_REQ,
+	/// Start app confirm
+	DBG_START_APP_CFM,
+	/// Start npc request
+	DBG_START_NPC_REQ,
+	/// Start npc confirm
+	DBG_START_NPC_CFM,
+	/// Memory mask write request
+	DBG_MEM_MASK_WRITE_REQ,
+	/// Memory mask write confirm
+	DBG_MEM_MASK_WRITE_CFM,
+
+	DBG_RFTEST_CMD_REQ,
+	DBG_RFTEST_CMD_CFM,
+	DBG_BINDING_REQ,
+	DBG_BINDING_CFM,
+	DBG_BINDING_IND,
+
+	DBG_CUSTOM_MSG_REQ,
+	DBG_CUSTOM_MSG_CFM,
+	DBG_CUSTOM_MSG_IND,
+
+	DBG_GPIO_WRITE_REQ,
+	DBG_GPIO_WRITE_CFM,
+
+	/// Max number of Debug messages
+	DBG_MAX,
+};
+
+#if !defined(CONFIG_M2D_OTA_LZMA_SUPPORT)
+#define FW_M2D_OTA_NAME "m2d_ota.bin"
+#else
+#define FW_M2D_OTA_NAME "m2d_ota_lzma.bin"
+#endif
+
+enum {
+	HOST_START_APP_AUTO =3D 1,
+	HOST_START_APP_CUSTOM,
+	HOST_START_APP_FNCALL =3D 4,
+	HOST_START_APP_DUMMY =3D 5,
+};
+
+struct dbg_mem_block_write_req {
+	u32 memaddr;
+	u32 memsize;
+	u32 memdata[1024 / sizeof(u32)];
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_BLOCK_WRITE_CF=
M
+/// message.
+struct dbg_mem_block_write_cfm {
+	u32 wstatus;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_WRITE_REQ mess=
age.
+struct dbg_mem_write_req {
+	u32 memaddr;
+	u32 memdata;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_WRITE_CFM mess=
age.
+struct dbg_mem_write_cfm {
+	u32 memaddr;
+	u32 memdata;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_READ_REQ messa=
ge.
+struct dbg_mem_read_req {
+	u32 memaddr;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_READ_CFM messa=
ge.
+struct dbg_mem_read_cfm {
+	u32 memaddr;
+	u32 memdata;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_MASK_WRITE_REQ
+/// message.
+struct dbg_mem_mask_write_req {
+	u32 memaddr;
+	u32 memmask;
+	u32 memdata;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_MASK_WRITE_CFM
+/// message.
+struct dbg_mem_mask_write_cfm {
+	u32 memaddr;
+	u32 memdata;
+};
+
+/// Structure containing the parameters of the @ref DBG_START_APP_REQ mess=
age.
+struct dbg_start_app_req {
+	u32 bootaddr;
+	u32 boottype;
+};
+
+/// Structure containing the parameters of the @ref DBG_START_APP_CFM mess=
age.
+struct dbg_start_app_cfm {
+	u32 bootstatus;
+};
+
+int aicwf_plat_patch_load_8800dc(struct aic_sdio_dev *sdiodev);
+int aicwf_plat_rftest_load_8800dc(struct aic_sdio_dev *sdiodev);
+#ifdef CONFIG_DPD
+int aicwf_misc_ram_valid_check_8800dc(struct aic_sdio_dev *sdiodev,
+				      int *valid_out);
+int aicwf_plat_calib_load_8800dc(struct aic_sdio_dev *sdiodev);
+#endif
+
+int rwnx_load_firmware(u32 **fw_buf, const char *name, struct device *devi=
ce);
+int aicwf_patch_table_load(struct aic_sdio_dev *rwnx_hw, char *filename);
+
+int rwnx_send_dbg_mem_read_req(struct aic_sdio_dev *sdiodev, u32 mem_addr,
+			       struct dbg_mem_read_cfm *cfm);
+int rwnx_send_dbg_mem_block_write_req(struct aic_sdio_dev *sdiodev,
+				      u32 mem_addr, u32 mem_size,
+				      u32 *mem_data);
+int rwnx_send_dbg_mem_write_req(struct aic_sdio_dev *sdiodev, u32 mem_addr=
,
+				u32 mem_data);
+int rwnx_send_dbg_mem_mask_write_req(struct aic_sdio_dev *sdiodev, u32 mem=
_addr,
+				     u32 mem_mask, u32 mem_data);
+int rwnx_send_dbg_start_app_req(struct aic_sdio_dev *sdiodev, u32 boot_add=
r,
+				u32 boot_type,
+				struct dbg_start_app_cfm *start_app_cfm);
+
+int rwnx_plat_bin_fw_upload(struct aic_sdio_dev *sdiodev, u32 fw_addr,
+			    const char *filename);
+#ifdef CONFIG_M2D_OTA_AUTO_SUPPORT
+int rwnx_plat_m2d_flash_ota(struct aic_sdio_dev *sdiodev, char *filename);
+int rwnx_plat_m2d_flash_ota_check(struct aic_sdio_dev *sdiodev,
+				  char *filename);
+#endif
+
+void rwnx_rx_handle_msg(struct aic_sdio_dev *sdiodev, struct ipc_e2a_msg *=
msg);
+int aicbsp_platform_init(struct aic_sdio_dev *sdiodev);
+void aicbsp_platform_deinit(struct aic_sdio_dev *sdiodev);
+int aicbsp_driver_fw_init(struct aic_sdio_dev *sdiodev);
+#if (defined(CONFIG_DPD) && !defined(CONFIG_FORCE_DPD_CALIB))
+#endif
+int aicbsp_resv_mem_init(void);
+int aicbsp_resv_mem_deinit(void);
+
+#define RAM_FMAC_FW_ADDR                    0x00120000
+#define RAM_FMAC_FW_PATCH_ADDR              0x00190000
+#define FW_RAM_ADID_BASE_ADDR               0x00161928
+#define FW_RAM_ADID_BASE_ADDR_U03           0x00161928
+#define FW_RAM_PATCH_BASE_ADDR              0x00100000
+#define RAM_8800DC_U01_ADID_ADDR            0x00101788
+#define RAM_8800DC_U02_ADID_ADDR            0x001017d8
+#define RAM_8800DC_FW_PATCH_ADDR            0x00184000
+#define FW_RESET_START_ADDR                 0x40500128
+#define FW_RESET_START_VAL                  0x40
+#define FW_ADID_FLAG_ADDR                   0x40500150
+#define FW_ADID_FLAG_VAL                    0x01
+#define FW_RAM_ADID_BASE_ADDR_8800D80       0x002017E0
+#define FW_RAM_PATCH_BASE_ADDR_8800D80      0x0020B2B0
+#define FW_RAM_ADID_BASE_ADDR_8800D80_U02   0x00201940
+#define FW_RAM_PATCH_BASE_ADDR_8800D80_U02  0x0020b43c
+
+#define AICBT_PT_TAG "AICBT_PT_TAG"
+
+/*************************************************************************=
****
+ * Addresses within RWNX_ADDR_CPU
+ *************************************************************************=
****/
+#define RAM_LMAC_FW_ADDR 0x00150000
+
+#define ROM_FMAC_FW_ADDR    0x00010000
+#define ROM_FMAC_PATCH_ADDR 0x00180000
+
+#define RAM_FMAC_FW_PATCH_NAME			"fmacfw_patch.bin"
+#define RWNX_MAC_CALIB_BASE_NAME_8800DC         "fmacfw_calib_8800dc"
+#define RWNX_MAC_CALIB_NAME_8800DC_U02          RWNX_MAC_CALIB_BASE_NAME_8=
800DC "_u02.bin"
+#ifdef CONFIG_SDIO_BT
+#define RWNX_MAC_CALIB_NAME_8800DC_H_U02                                  =
     \
+	RWNX_MAC_CALIB_BASE_NAME_8800DC "_hbt_u02.bin"
+#else
+#define RWNX_MAC_CALIB_NAME_8800DC_H_U02                                  =
     \
+	RWNX_MAC_CALIB_BASE_NAME_8800DC "_h_u02.bin"
+#endif
+
+#ifdef CONFIG_DPD
+#define ROM_FMAC_CALIB_ADDR 0x00130000
+#ifndef CONFIG_FORCE_DPD_CALIB
+#define FW_DPDRESULT_NAME_8800DC "aic_dpdresult_lite_8800dc.bin"
+#endif
+#endif
+
+#define RWNX_MAC_FW_RF_BASE_NAME_8800DC "lmacfw_rf_8800dc.bin"
+
+#ifdef CONFIG_FOR_IPCOM
+#define RWNX_MAC_PATCH_BASE_NAME_8800DC "fmacfw_patch_8800dc_ipc"
+#define RWNX_MAC_PATCH_NAME2_8800DC     RWNX_MAC_PATCH_BASE_NAME_8800DC ".=
bin"
+#else
+#define RWNX_MAC_PATCH_BASE_NAME_8800DC "fmacfw_patch_8800dc"
+#define RWNX_MAC_PATCH_NAME2_8800DC     RWNX_MAC_PATCH_BASE_NAME_8800DC ".=
bin"
+#define RWNX_MAC_PATCH_NAME2_8800DC_U02                                   =
     \
+	RWNX_MAC_PATCH_BASE_NAME_8800DC "_u02.bin"
+#ifdef CONFIG_SDIO_BT
+#define RWNX_MAC_PATCH_NAME2_8800DC_H_U02                                 =
     \
+	RWNX_MAC_PATCH_BASE_NAME_8800DC "_hbt_u02.bin"
+#else
+#define RWNX_MAC_PATCH_NAME2_8800DC_H_U02                                 =
     \
+	RWNX_MAC_PATCH_BASE_NAME_8800DC "_h_u02.bin"
+#endif
+#endif
+
+#define RWNX_MAC_PATCH_TABLE_NAME_8800DC "fmacfw_patch_tbl_8800dc"
+#define RWNX_MAC_PATCH_TABLE_8800DC      RWNX_MAC_PATCH_TABLE_NAME_8800DC =
".bin"
+#define RWNX_MAC_PATCH_TABLE_8800DC_U02                                   =
     \
+	RWNX_MAC_PATCH_TABLE_NAME_8800DC "_u02.bin"
+#ifdef CONFIG_SDIO_BT
+#define RWNX_MAC_PATCH_TABLE_8800DC_H_U02                                 =
     \
+	RWNX_MAC_PATCH_TABLE_NAME_8800DC "_hbt_u02.bin"
+#else
+#define RWNX_MAC_PATCH_TABLE_8800DC_H_U02                                 =
     \
+	RWNX_MAC_PATCH_TABLE_NAME_8800DC "_h_u02.bin"
+#endif
+
+#define RWNX_MAC_RF_PATCH_BASE_NAME_8800DC "fmacfw_rf_patch_8800dc"
+#define RWNX_MAC_RF_PATCH_NAME_8800DC      RWNX_MAC_RF_PATCH_BASE_NAME_880=
0DC ".bin"
+#define FW_USERCONFIG_NAME_8800DC          "aic_userconfig_8800dc.txt"
+
+enum {
+	FW_NORMAL_MODE =3D 0,
+	FW_RFTEST_MODE =3D 1,
+	FW_BLE_SCAN_WAKEUP_MODE =3D 2,
+	FW_M2D_OTA_MODE =3D 3,
+	FW_DPDCALIB_MODE =3D 4,
+	FW_BLE_SCAN_AD_FILTER_MODE =3D 5,
+};
+
+enum aicbt_patch_table_type {
+	AICBT_PT_INF =3D 0x00,
+	AICBT_PT_TRAP =3D 0x1,
+	AICBT_PT_B4,
+	AICBT_PT_BTMODE,
+	AICBT_PT_PWRON,
+	AICBT_PT_AF,
+	AICBT_PT_VER,
+};
+
+enum aicbt_btport_type {
+	AICBT_BTPORT_NULL,
+	AICBT_BTPORT_MB,
+	AICBT_BTPORT_UART,
+};
+
+/*  btmode
+ * used for force bt mode,if not AICBSP_MODE_NULL
+ * efuse valid and vendor_info will be invalid, even has beed set valid
+ */
+enum aicbt_btmode_type {
+	AICBT_BTMODE_BT_ONLY_SW =3D 0x0,   // bt only mode with switch
+	AICBT_BTMODE_BT_WIFI_COMBO,      // wifi/bt combo mode
+	AICBT_BTMODE_BT_ONLY,            // bt only mode without switch
+	AICBT_BTMODE_BT_ONLY_TEST,       // bt only test mode
+	AICBT_BTMODE_BT_WIFI_COMBO_TEST, // wifi/bt combo test mode
+	AICBT_BTMODE_BT_ONLY_COANT,      // bt only mode with no external switch
+	AICBT_MODE_NULL =3D 0xFF,          // invalid value
+};
+
+/*  uart_baud
+ * used for config uart baud when btport set to uart,
+ * otherwise meaningless
+ */
+enum aicbt_uart_baud_type {
+	AICBT_UART_BAUD_115200 =3D 115200,
+	AICBT_UART_BAUD_921600 =3D 921600,
+	AICBT_UART_BAUD_1_5M =3D 1500000,
+	AICBT_UART_BAUD_3_25M =3D 3250000,
+};
+
+enum aicbt_uart_flowctrl_type {
+	AICBT_UART_FLOWCTRL_DISABLE =3D 0x0, // uart without flow ctrl
+	AICBT_UART_FLOWCTRL_ENABLE,        // uart with flow ctrl
+};
+
+enum aicbsp_cpmode_type {
+	AICBSP_CPMODE_WORK,
+	AICBSP_CPMODE_TEST,
+	AICBSP_CPMODE_MAX,
+};
+
+enum chip_rev {
+	CHIP_REV_U01 =3D 1,
+	CHIP_REV_U02 =3D 3,
+	CHIP_REV_U03 =3D 7,
+	CHIP_REV_U04 =3D 7,
+};
+
+#define AIC_M2D_OTA_INFO_ADDR 0x88000020
+#define AIC_M2D_OTA_DATA_ADDR 0x88000040
+#if !defined(CONFIG_M2D_OTA_LZMA_SUPPORT)
+#define AIC_M2D_OTA_FLASH_ADDR      0x08004000
+#define AIC_M2D_OTA_CODE_START_ADDR (AIC_M2D_OTA_FLASH_ADDR + 0x0188)
+#define AIC_M2D_OTA_VER_ADDR        (AIC_M2D_OTA_FLASH_ADDR + 0x018C)
+#else
+#define AIC_M2D_OTA_FLASH_ADDR      0x08005000
+#define AIC_M2D_OTA_CODE_START_ADDR (AIC_M2D_OTA_FLASH_ADDR + 0x1188)
+#define AIC_M2D_OTA_VER_ADDR        (AIC_M2D_OTA_FLASH_ADDR + 0x0010)
+#endif
+/// aic bt tx pwr lvl :lsb->msb: first byte, min pwr lvl; second byte, max=
 pwr
+/// lvl; pwr lvl:20(min), 30 , 40 , 50 , 60(max)
+#define AICBT_TXPWR_LVL         0x00006020
+#define AICBT_TXPWR_LVL_8800dc  0x00006f2f
+#define AICBT_TXPWR_LVL_8800d80 0x00006f2f
+
+#define AICBSP_HWINFO_DEFAULT   (-1)
+#define AICBSP_CPMODE_DEFAULT   AICBSP_CPMODE_WORK
+#define AICBSP_FWLOG_EN_DEFAULT 0
+
+#define AICBT_BTMODE_DEFAULT_8800d80 AICBT_BTMODE_BT_ONLY_COANT
+#define AICBT_BTMODE_DEFAULT         AICBT_BTMODE_BT_ONLY_SW
+#ifdef CONFIG_SDIO_BT
+#define AICBT_BTPORT_DEFAULT AICBT_BTPORT_MB
+#else
+#define AICBT_BTPORT_DEFAULT AICBT_BTPORT_UART
+#endif
+#define AICBT_UART_BAUD_DEFAULT         AICBT_UART_BAUD_1_5M
+#define AICBT_UART_FC_DEFAULT           AICBT_UART_FLOWCTRL_ENABLE
+#define AICBT_LPM_ENABLE_DEFAULT        1
+#define AICBT_TXPWR_LVL_DEFAULT         AICBT_TXPWR_LVL
+#define AICBT_TXPWR_LVL_DEFAULT_8800dc  AICBT_TXPWR_LVL_8800dc
+#define AICBT_TXPWR_LVL_DEFAULT_8800d80 AICBT_TXPWR_LVL_8800d80
+
+#define FEATURE_SDIO_CLOCK    50000000  // 0: default, other: target clock=
 rate
+#define FEATURE_SDIO_CLOCK_V3 150000000 // 0: default, other: target clock=
 rate
+#define FEATURE_SDIO_PHASE    2         // 0: default, 2: 180=C2=B0
+
+struct aicbt_patch_table {
+	char *name;
+	u32 type;
+	u32 *data;
+	u32 len;
+	struct aicbt_patch_table *next;
+};
+
+struct aicbt_info_t {
+	u32 btmode;
+	u32 btport;
+	u32 uart_baud;
+	u32 uart_flowctrl;
+	u32 lpm_enable;
+	u32 txpwr_lvl;
+};
+
+struct aicbt_patch_info_t {
+	u32 info_len;
+	u32 adid_addrinf;
+	u32 addr_adid;
+	u32 patch_addrinf;
+	u32 addr_patch;
+	u32 reset_addr;
+	u32 reset_val;
+	u32 adid_flag_addr;
+	u32 adid_flag;
+};
+
+struct aicbsp_firmware {
+	const char *desc;
+	const char *bt_adid;
+	const char *bt_patch;
+	const char *bt_table;
+	const char *wl_fw;
+};
+
+struct aicbsp_info_t {
+	int hwinfo;
+	int hwinfo_r;
+	u32 cpmode;
+	u32 adap_test;
+	u32 chip_rev;
+	bool fwlog_en;
+	u8 irqf;
+};
+
+extern int adap_test;
+
+extern struct aicbsp_info_t aicbsp_info;
+extern struct mutex aicbsp_power_lock;
+extern const struct aicbsp_firmware *aicbsp_firmware_list;
+extern const struct aicbsp_firmware fw_u02[];
+extern const struct aicbsp_firmware fw_u03[];
+extern const struct aicbsp_firmware fw_8800dc_u01[];
+extern const struct aicbsp_firmware fw_8800dc_u02[];
+extern const struct aicbsp_firmware fw_8800dc_h_u02[];
+extern const struct aicbsp_firmware fw_8800d80_u01[];
+extern const struct aicbsp_firmware fw_8800d80_u02[];
+extern const struct aicbsp_firmware fw_8800d80_h_u02[];
+
+int aicbsp_system_config(struct aic_sdio_dev *sdiodev);
+int aicwifi_patch_config(struct aic_sdio_dev *sdiodev);
+int aicwifi_sys_config(struct aic_sdio_dev *sdiodev);
+int aicbt_patch_table_free(struct aicbt_patch_table **head);
+struct aicbt_patch_table *aicbt_patch_table_alloc(const char *filename);
+int aicbt_patch_info_unpack(struct aicbt_patch_info_t *patch_info,
+			    struct aicbt_patch_table *head_t);
+int aicbt_patch_trap_data_load(struct aic_sdio_dev *sdiodev,
+			       struct aicbt_patch_table *head);
+int aicbt_patch_table_load(struct aic_sdio_dev *sdiodev,
+			   struct aicbt_patch_table *head);
+int aicbt_init(struct aic_sdio_dev *sdiodev);
+int aicwifi_init(struct aic_sdio_dev *sdiodev);
+int aicwifi_start_from_bootrom(struct aic_sdio_dev *sdiodev);
+
+#endif
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_export.h b/driver=
s/net/wireless/aic/aic8800_bsp/aic_bsp_export.h
new file mode 100644
index 0000000000000..5d2a5c38c95e6
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_export.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __AIC_BSP_EXPORT_H
+#define __AIC_BSP_EXPORT_H
+
+#include <linux/types.h>
+
+enum aicbsp_subsys {
+	AIC_BLUETOOTH,
+	AIC_WIFI,
+};
+
+enum aicbsp_pwr_state {
+	AIC_PWR_OFF,
+	AIC_PWR_ON,
+};
+
+enum skb_buff_id {
+	AIC_RESV_MEM_TXDATA,
+};
+
+struct skb_buff_pool {
+	u32 id;
+	u32 size;
+	const char *name;
+	u8 used;
+	struct sk_buff *skb;
+};
+
+struct aicbsp_feature_t {
+	int hwinfo;
+	u32 sdio_clock;
+	u8 sdio_phase;
+	bool fwlog_en;
+	u8 irqf;
+	u8 cpmode;
+	int adapt;
+};
+
+#ifdef CONFIG_DPD
+struct rf_misc_ram_t {
+	u32 bit_mask[3];
+	u32 reserved;
+	u32 dpd_high[96];
+	u32 dpd_11b[96];
+	u32 dpd_low[96];
+	u32 idac_11b[48];
+	u32 idac_high[48];
+	u32 idac_low[48];
+	u32 loft_res[18];
+	u32 rx_iqim_res[16];
+};
+
+struct rf_misc_ram_lite_t {
+	u32 bit_mask[4];
+	u32 dpd_high[96];
+	u32 loft_res[18];
+};
+
+#define MEMBER_SIZE(type, member) sizeof_field(type, member)
+#define DPD_RESULT_SIZE_8800DC    sizeof(struct rf_misc_ram_lite_t)
+
+extern struct rf_misc_ram_lite_t dpd_res;
+#endif
+
+int aicbsp_set_subsys(int, int);
+int aicbsp_get_feature(struct aicbsp_feature_t *feature);
+struct sk_buff *aicbsp_resv_mem_alloc_skb(unsigned int length, uint32_t id=
);
+void aicbsp_resv_mem_kfree_skb(struct sk_buff *skb, uint32_t id);
+
+#endif
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_main.c b/drivers/=
net/wireless/aic/aic8800_bsp/aic_bsp_main.c
new file mode 100644
index 0000000000000..7b89d7996a9dc
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_main.c
@@ -0,0 +1,556 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief bsp sdio main function
+ *
+ *************************************************************************=
*****
+ */
+
+#include "aic_bsp_driver.h"
+#include "aicwf_txq_prealloc.h"
+#include "rwnx_version_gen.h"
+#include <linux/errno.h>
+#include <linux/inetdevice.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+
+#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
+#include <linux/of_platform.h>
+
+#define DRV_DESCRIPTION "AIC BSP"
+#define DRV_COPYRIGHT   "Copyright(c) 2015-2020 AICSemi"
+#define DRV_AUTHOR      "AICSemi"
+#define DRV_VERS_MOD    "1.0"
+
+int aicwf_dbg_level_bsp =3D LOGERROR; // | LOGINFO | LOGDEBUG | LOGTRACE;
+module_param(aicwf_dbg_level_bsp, int, 0660);
+
+static struct platform_device *aicbsp_pdev;
+
+const struct aicbsp_firmware *aicbsp_firmware_list =3D fw_u02;
+
+const struct aicbsp_firmware fw_u02[] =3D {
+	[AICBSP_CPMODE_WORK] =3D {.desc =3D "normal work mode(sdio u02)",
+							.bt_adid =3D "fw_adid.bin",
+							.bt_patch =3D "fw_patch.bin",
+							.bt_table =3D "fw_patch_table.bin",
+#ifdef CONFIG_SDIO_BT
+							.wl_fw =3D "fmacfwbt.bin"
+#else
+							.wl_fw =3D "fmacfw.bin"
+#endif
+	},
+	[AICBSP_CPMODE_TEST] =3D {.desc =3D "rf test mode(sdio u02)",
+							.bt_adid =3D "fw_adid.bin",
+							.bt_patch =3D "fw_patch.bin",
+							.bt_table =3D "fw_patch_table.bin",
+							.wl_fw =3D "fmacfw_rf.bin"},
+};
+
+const struct aicbsp_firmware fw_u03[] =3D {
+	[AICBSP_CPMODE_WORK] =3D {.desc =3D "normal work mode(sdio u03/u04)",
+							.bt_adid =3D "fw_adid_u03.bin",
+							.bt_patch =3D "fw_patch_u03.bin",
+							.bt_table =3D "fw_patch_table_u03.bin",
+#ifdef CONFIG_SDIO_BT
+							.wl_fw =3D "fmacfwbt.bin"
+#else
+							.wl_fw =3D "fmacfw.bin"
+#endif
+	},
+
+	[AICBSP_CPMODE_TEST] =3D {.desc =3D "rf test mode(sdio u03/u04)",
+							.bt_adid =3D "fw_adid_u03.bin",
+							.bt_patch =3D "fw_patch_u03.bin",
+							.bt_table =3D "fw_patch_table_u03.bin",
+							.wl_fw =3D "fmacfw_rf.bin"},
+};
+
+const struct aicbsp_firmware fw_8800dc_u01[] =3D {
+	[AICBSP_CPMODE_WORK] =3D {.desc =3D "normal work mode(sdio u01)",
+							.bt_adid =3D "fw_adid_8800dc.bin",
+							.bt_patch =3D "fw_patch_8800dc.bin",
+							.bt_table =3D "fw_patch_table_8800dc.bin",
+							.wl_fw =3D "fmacfw_8800dc.bin"},
+
+	[AICBSP_CPMODE_TEST] =3D {.desc =3D "rf test mode(sdio u01)",
+							.bt_adid =3D "fw_adid_8800dc.bin",
+							.bt_patch =3D "fw_patch_8800dc.bin",
+							.bt_table =3D "fw_patch_table_8800dc.bin",
+							.wl_fw =3D "fmacfw_rf_8800dc.bin"},
+};
+
+const struct aicbsp_firmware fw_8800dc_u02[] =3D {
+	[AICBSP_CPMODE_WORK] =3D {.desc =3D "normal work mode(8800dc sdio u02)",
+							.bt_adid =3D "fw_adid_8800dc_u02.bin",
+							.bt_patch =3D "fw_patch_8800dc_u02.bin",
+							.bt_table =3D "fw_patch_table_8800dc_u02.bin",
+							.wl_fw =3D "fmacfw_patch_8800dc_u02.bin"},
+
+	[AICBSP_CPMODE_TEST] =3D {
+			.desc =3D "rf test mode(8800dc sdio u02)",
+			.bt_adid =3D "fw_adid_8800dc_u02.bin",
+			.bt_patch =3D "fw_patch_8800dc_u02.bin",
+			.bt_table =3D "fw_patch_table_8800dc_u02.bin",
+			.wl_fw =3D "lmacfw_rf_8800dc.bin" // u01,u02 lmacfw load same bin
+		},
+};
+
+const struct aicbsp_firmware fw_8800dc_h_u02[] =3D {
+	[AICBSP_CPMODE_WORK] =3D {.desc =3D "normal work mode(8800dc_h sdio u02)"=
,
+				.bt_adid =3D "fw_adid_8800dc_u02h.bin",
+				.bt_patch =3D "fw_patch_8800dc_u02h.bin",
+				.bt_table =3D "fw_patch_table_8800dc_u02h.bin",
+				.wl_fw =3D "fmacfw_patch_8800dc_h_u02.bin"},
+
+	[AICBSP_CPMODE_TEST] =3D {
+			.desc =3D "rf test mode(8800dc_h sdio u02)",
+			.bt_adid =3D "fw_adid_8800dc_u02h.bin",
+			.bt_patch =3D "fw_patch_8800dc_u02h.bin",
+			.bt_table =3D "fw_patch_table_8800dc_u02h.bin",
+			.wl_fw =3D "lmacfw_rf_8800dc.bin" // u01,u02 lmacfw load same bin
+		},
+};
+
+const struct aicbsp_firmware fw_8800d80_u01[] =3D {
+	[AICBSP_CPMODE_WORK] =3D {.desc =3D "normal work mode(8800d80 sdio u01)",
+							.bt_adid =3D "fw_adid_8800d80.bin",
+							.bt_patch =3D "fw_patch_8800d80.bin",
+							.bt_table =3D "fw_patch_table_8800d80.bin",
+							.wl_fw =3D "fmacfw_8800d80.bin"},
+
+	[AICBSP_CPMODE_TEST] =3D {.desc =3D "rf test mode(8800d80 sdio u01)",
+							.bt_adid =3D "fw_adid_8800d80.bin",
+							.bt_patch =3D "fw_patch_8800d80.bin",
+							.bt_table =3D "fw_patch_table_8800d80.bin",
+							.wl_fw =3D "lmacfw_rf_8800d80.bin"},
+};
+
+const struct aicbsp_firmware fw_8800d80_u02[] =3D {
+	[AICBSP_CPMODE_WORK] =3D {.desc =3D "normal work mode(8800d80 sdio u02)",
+				.bt_adid =3D "fw_adid_8800d80_u02.bin",
+				.bt_patch =3D "fw_patch_8800d80_u02.bin",
+				.bt_table =3D "fw_patch_table_8800d80_u02.bin",
+#ifdef CONFIG_SDIO_BT
+				.wl_fw =3D "fmacfwbt_8800d80_u02.bin"
+#else
+				.wl_fw =3D "fmacfw_8800d80_u02.bin"
+#endif
+	},
+
+	[AICBSP_CPMODE_TEST] =3D {.desc =3D "rf test mode(8800d80 sdio u02)",
+				.bt_adid =3D "fw_adid_8800d80_u02.bin",
+				.bt_patch =3D "fw_patch_8800d80_u02.bin",
+				.bt_table =3D "fw_patch_table_8800d80_u02.bin",
+				.wl_fw =3D "lmacfw_rf_8800d80_u02.bin"},
+};
+
+const struct aicbsp_firmware fw_8800d80_h_u02[] =3D {
+	[AICBSP_CPMODE_WORK] =3D {.desc =3D "normal work mode(8800d80 sdio h_u02)=
",
+				.bt_adid =3D "fw_adid_8800d80_u02.bin",
+				.bt_patch =3D "fw_patch_8800d80_u02.bin",
+				.bt_table =3D "fw_patch_table_8800d80_u02.bin",
+#ifdef CONFIG_SDIO_BT
+				.wl_fw =3D "fmacfwbt_8800d80_h_u02.bin"
+#else
+				.wl_fw =3D "fmacfw_8800d80_h_u02.bin"
+#endif
+	},
+
+	[AICBSP_CPMODE_TEST] =3D {.desc =3D "rf test mode(8800d80 sdio u02)",
+				.bt_adid =3D "fw_adid_8800d80_u02.bin",
+				.bt_patch =3D "fw_patch_8800d80_u02.bin",
+				.bt_table =3D "fw_patch_table_8800d80_u02.bin",
+				.wl_fw =3D "lmacfw_rf_8800d80_u02.bin"},
+};
+
+struct aicbsp_info_t aicbsp_info =3D {
+	.hwinfo_r =3D AICBSP_HWINFO_DEFAULT,
+	.hwinfo =3D AICBSP_HWINFO_DEFAULT,
+	.cpmode =3D AICBSP_CPMODE_DEFAULT,
+	.fwlog_en =3D AICBSP_FWLOG_EN_DEFAULT,
+	.adap_test =3D 0,
+#ifdef CONFIG_IRQ_FALL
+	.irqf =3D 1,
+#else
+	.irqf =3D 0,
+#endif
+};
+
+/* mutex for aicbsp power */
+struct mutex aicbsp_power_lock;
+
+static struct platform_driver aicbsp_driver =3D {
+	.driver =3D {
+			.owner =3D THIS_MODULE,
+			.name =3D "aic_bsp",
+		},
+};
+
+static ssize_t cpmode_show(struct device *dev, struct device_attribute *at=
tr,
+			   char *buf)
+{
+	ssize_t count =3D 0;
+	u8 i =3D 0;
+
+	count +=3D sprintf(&buf[count], "Support mode value:\n");
+
+	for (i =3D 0; i < AICBSP_CPMODE_MAX; i++) {
+		if (aicbsp_firmware_list[i].desc)
+			count +=3D sprintf(&buf[count], " %2d: %s\n", i,
+							 aicbsp_firmware_list[i].desc);
+	}
+
+	count +=3D sprintf(&buf[count], "Current: %d, firmware info:\n",
+					 aicbsp_info.cpmode);
+	count +=3D sprintf(&buf[count], "  BT ADID : %s\n",
+					 aicbsp_firmware_list[aicbsp_info.cpmode].bt_adid);
+	count +=3D sprintf(&buf[count], "  BT PATCH: %s\n",
+					 aicbsp_firmware_list[aicbsp_info.cpmode].bt_patch);
+	count +=3D sprintf(&buf[count], "  BT TABLE: %s\n",
+					 aicbsp_firmware_list[aicbsp_info.cpmode].bt_table);
+	/* mod cpmode display */
+	// count +=3D sprintf(&buf[count], "  WIFI FW : %s\n",
+	// aicbsp_firmware_list[aicbsp_info.cpmode].wl_fw);
+	count +=3D sprintf(&buf[count], "  WIFI FW : %s\n",
+					 aicbsp_firmware_list[cur_mode].wl_fw);
+	return count;
+}
+
+static ssize_t cpmode_store(struct device *dev, struct device_attribute *a=
ttr,
+			    const char *buf, size_t count)
+{
+	unsigned long val;
+	int err =3D kstrtoul(buf, 0, &val);
+
+	if (err)
+		return err;
+
+	if (val >=3D AICBSP_CPMODE_MAX) {
+		pr_err("mode value must less than %d\n", AICBSP_CPMODE_MAX);
+		return -EINVAL;
+	}
+
+	aicbsp_info.cpmode =3D val;
+	pr_info("%s, set mode to: %lu[%s] done\n", __func__, val,
+		aicbsp_firmware_list[val].desc);
+
+	return count;
+}
+
+static ssize_t hwinfo_show(struct device *dev, struct device_attribute *at=
tr,
+			   char *buf)
+{
+	ssize_t count =3D 0;
+
+	count +=3D sprintf(&buf[count], "chip hw rev: ");
+	if (aicbsp_info.hwinfo_r < 0)
+		count +=3D sprintf(&buf[count], "-1(not avalible)\n");
+	else
+		count +=3D sprintf(&buf[count], "0x%02X\n", aicbsp_info.chip_rev);
+
+	count +=3D sprintf(&buf[count], "hwinfo read: ");
+	if (aicbsp_info.hwinfo_r < 0)
+		count +=3D
+			sprintf(&buf[count], "%d(not avalible), ", aicbsp_info.hwinfo_r);
+	else
+		count +=3D sprintf(&buf[count], "0x%02X, ", aicbsp_info.hwinfo_r);
+
+	if (aicbsp_info.hwinfo < 0)
+		count +=3D
+			sprintf(&buf[count], "set: %d(not avalible)\n", aicbsp_info.hwinfo);
+	else
+		count +=3D sprintf(&buf[count], "set: 0x%02X\n", aicbsp_info.hwinfo);
+
+	return count;
+}
+
+static ssize_t hwinfo_store(struct device *dev, struct device_attribute *a=
ttr,
+			    const char *buf, size_t count)
+{
+	long val;
+	int err =3D kstrtol(buf, 0, &val);
+
+	if (err) {
+		pr_err("invalid input\n");
+		return err;
+	}
+
+	if ((val =3D=3D -1) || (val >=3D 0 && val <=3D 0xFF)) {
+		aicbsp_info.hwinfo =3D val;
+	} else {
+		pr_err("invalid values\n");
+		return -EINVAL;
+	}
+	return count;
+}
+
+static ssize_t fwdebug_show(struct device *dev, struct device_attribute *a=
ttr,
+			    char *buf)
+{
+	ssize_t count =3D 0;
+
+	count +=3D sprintf(&buf[count], "fw log status: %s\n",
+					 aicbsp_info.fwlog_en ? "on" : "off");
+
+	return count;
+}
+
+static ssize_t fwdebug_store(struct device *dev, struct device_attribute *=
attr,
+			     const char *buf, size_t count)
+{
+	long val;
+	int err =3D kstrtol(buf, 0, &val);
+
+	if (err) {
+		pr_err("invalid input\n");
+		return err;
+	}
+
+	if (val > 1 || val < 0) {
+		pr_err("must be 0 or 1\n");
+		return -EINVAL;
+	}
+
+	aicbsp_info.fwlog_en =3D val;
+	return count;
+}
+
+static ssize_t adapt_show(struct device *dev, struct device_attribute *att=
r,
+			  char *buf)
+{
+	ssize_t count =3D 0;
+
+	count +=3D sprintf(&buf[count], "adapt status: %s\n",
+					 aicbsp_info.adap_test ? "on" : "off");
+
+	return count;
+}
+
+static ssize_t adapt_store(struct device *dev, struct device_attribute *at=
tr,
+			   const char *buf, size_t count)
+{
+	long val;
+	int err =3D kstrtol(buf, 0, &val);
+
+	if (err) {
+		pr_err("invalid input\n");
+		return err;
+	}
+
+	if (val > 1 || val < 0) {
+		pr_err("must be 0 or 1\n");
+		return err;
+	}
+
+	aicbsp_info.adap_test =3D val;
+	return count;
+}
+
+static DEVICE_ATTR_RW(cpmode);
+
+static DEVICE_ATTR_RW(hwinfo);
+
+static DEVICE_ATTR_RW(fwdebug);
+
+static DEVICE_ATTR_RW(adapt);
+
+static struct attribute *aicbsp_attributes[] =3D {
+	&dev_attr_cpmode.attr,
+	&dev_attr_hwinfo.attr,
+	&dev_attr_fwdebug.attr,
+	&dev_attr_adapt.attr,
+	NULL,
+};
+
+static struct attribute_group aicbsp_attribute_group =3D {
+	.name =3D "aicbsp_info",
+	.attrs =3D aicbsp_attributes,
+};
+
+int testmode =3D AICBSP_CPMODE_DEFAULT;
+int adap_test;
+module_param(testmode, int, 0660);
+module_param(adap_test, int, 0660);
+
+#if defined CONFIG_PLATFORM_EXTERNAL && defined CONFIG_CUSTOM_PWF
+int gpio_pwr;
+bool gpio_pwr_assert;
+
+void nxp_pwr_ctrl(int value)
+{
+	pr_info("aic_bsp: %s: %d\n", __func__, value);
+	gpio_set_value(gpio_pwr, value);
+}
+
+static int aicbsp_pwr_node(void)
+{
+	struct device_node *np;
+	int err;
+
+	np =3D of_find_compatible_node(NULL, NULL, "aic,wifi-power");
+	if (!np) {
+		pr_err("aic_bsp: %s np not found\n", __func__);
+		return -ENODEV;
+	}
+
+	gpio_pwr =3D of_get_named_gpio(np, "wifi-power", 0);
+	if (!gpio_is_valid(gpio_pwr)) {
+		pr_err("aic_bsp: %s is invalid\n", __func__);
+		return -ENODEV;
+	}
+
+	err =3D gpio_request(gpio_pwr, "wifi-power");
+	if (err < 0) {
+		pr_err("aic_bsp: %s can't request gpio_pwr gpio %d\n", __func__,
+		       gpio_pwr);
+		return -ENODEV;
+	}
+
+	err =3D gpio_direction_output(gpio_pwr, 1);
+	if (err < 0) {
+		pr_err("aic_bsp: %s can't request output direction gpio_pwr gpio %d\n",
+		       __func__, gpio_pwr);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+#endif
+
+static int __init aicbsp_init(void)
+{
+	int ret;
+
+	pr_info("AIC_BSP RELEASE VERSION:%s\r\n", RELEASE_VERSION);
+
+	aicbsp_info.cpmode =3D testmode;
+
+	aicbsp_resv_mem_init();
+	ret =3D platform_driver_register(&aicbsp_driver);
+	if (ret) {
+		pr_err("register platform driver failed: %d\n", ret);
+		return ret;
+	}
+
+	aicbsp_pdev =3D platform_device_alloc("aic-bsp", -1);
+	ret =3D platform_device_add(aicbsp_pdev);
+	if (ret) {
+		pr_err("register platform device failed: %d\n", ret);
+		return ret;
+	}
+
+	ret =3D sysfs_create_group(&aicbsp_pdev->dev.kobj, &aicbsp_attribute_grou=
p);
+	if (ret) {
+		pr_err("register sysfs create group failed!\n");
+		return ret;
+	}
+
+	mutex_init(&aicbsp_power_lock);
+
+#if defined CONFIG_PLATFORM_EXTERNAL && defined CONFIG_CUSTOM_PWF
+	ret =3D aicbsp_pwr_node();
+	if (ret) {
+		pr_err("aic_bsp: aicbsp_pwr_node fail\n");
+		return ret;
+	}
+#endif
+	return 0;
+}
+
+void aicbsp_sdio_exit(void);
+
+static void __exit aicbsp_exit(void)
+{
+#if defined CONFIG_PLATFORM_EXTERNAL && defined CONFIG_CUSTOM_PWF
+	gpio_free(gpio_pwr);
+#endif
+
+	sysfs_remove_group(&aicbsp_pdev->dev.kobj, &aicbsp_attribute_group);
+	platform_device_del(aicbsp_pdev);
+	platform_driver_unregister(&aicbsp_driver);
+	mutex_destroy(&aicbsp_power_lock);
+	aicbsp_resv_mem_deinit();
+#ifdef CONFIG_PREALLOC_TXQ
+	aicwf_prealloc_txq_free();
+#endif
+}
+
+module_init(aicbsp_init);
+module_exit(aicbsp_exit);
+
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_adid.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_table.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_adid_u03.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_u03.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_table_u03.bin");
+
+#ifdef CONFIG_SDIO_BT
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfwbt.bin");
+#else
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfw.bin");
+#endif
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfw_rf.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR RAM_FMAC_FW_PATCH_NAME);
+
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_adid_8800dc.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_8800dc.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_table_8800dc.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfw_8800dc.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfw_rf_8800dc.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_adid_8800dc_u02.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_8800dc_u02.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_table_8800dc_u02.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfw_patch_8800dc_u02.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "lmacfw_rf_8800dc.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_adid_8800dc_u02h.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_8800dc_u02h.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_table_8800dc_u02h.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfw_patch_8800dc_h_u02.bin");
+
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_MAC_PATCH_NAME2_8800DC);
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_MAC_PATCH_NAME2_8800DC_U02);
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_MAC_PATCH_NAME2_8800DC_H_U02);
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_MAC_PATCH_TABLE_8800DC_U02);
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_MAC_PATCH_TABLE_8800DC_H_U02);
+#ifdef CONFIG_DPD
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_MAC_CALIB_NAME_8800DC_U02);
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_MAC_CALIB_NAME_8800DC_H_U02);
+#ifndef CONFIG_FORCE_DPD_CALIB
+MODULE_FIRMWARE(AIC8800_FW_DIR FW_DPDRESULT_NAME_8800DC);
+#endif
+#endif
+
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_adid_8800d80.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_8800d80.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_table_8800d80.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfw_8800d80.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "lmacfw_rf_8800d80.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_adid_8800d80_u02.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_8800d80_u02.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fw_patch_table_8800d80_u02.bin");
+#ifdef CONFIG_SDIO_BT
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfwbt_8800d80_u02.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfwbt_8800d80_h_u02.bin");
+#else
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfw_8800d80_u02.bin");
+MODULE_FIRMWARE(AIC8800_FW_DIR "fmacfw_8800d80_h_u02.bin");
+#endif
+MODULE_FIRMWARE(AIC8800_FW_DIR "lmacfw_rf_8800d80_u02.bin");
+
+#ifdef CONFIG_M2D_OTA_AUTO_SUPPORT
+MODULE_FIRMWARE(AIC8800_FW_DIR FW_M2D_OTA_NAME);
+#endif
+
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+MODULE_VERSION(DRV_VERS_MOD);
+MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic_chip_8800d80.c b/driv=
ers/net/wireless/aic/aic8800_bsp/aic_chip_8800d80.c
new file mode 100644
index 0000000000000..d25afbc6cee7e
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic_chip_8800d80.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 AIC semiconductor.
+ *
+ * @file aic_chip_8800d80.c
+ * @brief Chip operations for AIC8800D80
+ */
+
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/ieee80211.h>
+#include "aic_chip_ops.h"
+
+#include "aic8800d80_compat.h"
+#include "aic_bsp_driver.h"
+
+static int aic8800d80_wifi_init(struct aic_sdio_dev *sdiodev, int testmode=
)
+{
+	const char *fw_path =3D aicbsp_firmware_list[aicbsp_info.cpmode].wl_fw;
+
+	if (rwnx_plat_bin_fw_upload(sdiodev, RAM_FMAC_FW_ADDR,
+				    fw_path)) {
+		pr_err("aicbsp 8800d80 download wifi fw fail\n");
+		return -1;
+	}
+
+	if (aicwifi_patch_config_8800d80(sdiodev)) {
+		pr_err("aicbsp aicwifi_patch_config_8800d80 fail\n");
+		return -1;
+	}
+
+	if (aicwifi_sys_config_8800d80(sdiodev)) {
+		pr_err("aicbsp aicwifi_patch_config_8800d80 fail\n");
+		return -1;
+	}
+
+	if (aicwifi_start_from_bootrom(sdiodev)) {
+		pr_err("aicbsp 8800d80 wifi start fail\n");
+		return -1;
+	}
+	return 0;
+}
+
+static int aic8800d80_set_patch_info(struct aic_sdio_dev *sdiodev,
+				     struct aicbt_patch_info_t *patch_info,
+				     struct aicbsp_info_t *aicbsp_info,
+				     struct aicbt_patch_table *head)
+{
+	if (aicbsp_info->chip_rev =3D=3D CHIP_REV_U01) {
+		patch_info->addr_adid =3D FW_RAM_ADID_BASE_ADDR_8800D80;
+		patch_info->addr_patch =3D FW_RAM_PATCH_BASE_ADDR_8800D80;
+	} else if (aicbsp_info->chip_rev =3D=3D CHIP_REV_U02 ||
+				aicbsp_info->chip_rev =3D=3D CHIP_REV_U03) {
+		patch_info->addr_adid =3D FW_RAM_ADID_BASE_ADDR_8800D80_U02;
+		patch_info->addr_patch =3D FW_RAM_PATCH_BASE_ADDR_8800D80_U02;
+	}
+	aicbt_patch_info_unpack(patch_info, head);
+	if (patch_info->info_len =3D=3D 0) {
+		pr_err("aicbsp %s, aicbt_patch_info_unpack fail\n", __func__);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int aic8800d80_driver_fw_init(struct aic_sdio_dev *sdiodev, u32 *bt=
enable,
+				     struct aicbsp_info_t *aicbsp_info,
+				     const struct aicbsp_firmware **aicbsp_firmware_list)
+{
+	u32 mem_addr;
+	struct dbg_mem_read_cfm rd_mem_addr_cfm;
+	u8 is_chip_id_h =3D 0;
+
+	mem_addr =3D 0x40500000;
+
+	if (rwnx_send_dbg_mem_read_req(sdiodev, mem_addr, &rd_mem_addr_cfm))
+		return -1;
+
+	aicbsp_info->chip_rev =3D (u8)((rd_mem_addr_cfm.memdata >> 16) & 0x3F);
+	is_chip_id_h =3D (u8)(((rd_mem_addr_cfm.memdata >> 16) & 0xC0) =3D=3D 0xC=
0);
+	*btenable =3D 1;
+	if (is_chip_id_h) {
+		AICWFDBG(LOGINFO, "IS_CHIP_ID_H\n");
+		*aicbsp_firmware_list =3D fw_8800d80_h_u02;
+	} else {
+		if (aicbsp_info->chip_rev =3D=3D CHIP_REV_U01)
+			*aicbsp_firmware_list =3D fw_8800d80_u01;
+		if (aicbsp_info->chip_rev =3D=3D CHIP_REV_U02 ||
+		    aicbsp_info->chip_rev =3D=3D CHIP_REV_U03)
+			*aicbsp_firmware_list =3D fw_8800d80_u02;
+	}
+	if (aicbsp_system_config_8800d80(sdiodev))
+		return -1;
+
+	return 0;
+}
+
+/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Ops instances =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D */
+
+const struct aic_chip_ops aic_chip_aic8800d80_ops =3D {
+	.name						=3D "AIC8800D80",
+	.use_func_msg				=3D false,
+	.use_sdiov3_func			=3D true,
+	.need_flowctrl_mask			=3D false,
+	.wakeup_reg_val				=3D 0x11,
+	.use_flowctrl_msg			=3D true,
+	.use_hdr_checksum			=3D true,
+	.need_fix_hdr_len			=3D false,
+	.need_func0_intr			=3D true,
+	.use_func2					=3D false,
+	.sdio_clock					=3D FEATURE_SDIO_CLOCK_V3,
+	.wifi_init					=3D aic8800d80_wifi_init,
+	.set_patch_info				=3D aic8800d80_set_patch_info,
+	.driver_fw_init				=3D aic8800d80_driver_fw_init,
+
+};
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic_chip_8800dc.c b/drive=
rs/net/wireless/aic/aic8800_bsp/aic_chip_8800dc.c
new file mode 100644
index 0000000000000..b3841261312f9
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic_chip_8800dc.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 AIC semiconductor.
+ *
+ * @file aic_chip_8800dc.c
+ * @brief Chip operations for AIC8801 / AIC8800DC / AIC8800DW
+ */
+
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/ieee80211.h>
+#include "aic_chip_ops.h"
+
+#include "aic8800dc_compat.h"
+#include "aic_bsp_driver.h"
+
+static int aic8800dc_wifi_init(struct aic_sdio_dev *sdiodev, int testmode)
+{
+	int ret;
+
+	pr_info("aicbsp ############ %s begin\n", __func__);
+
+	system_config_8800dc(sdiodev);
+	pr_info("aicbsp ############ system_config_8800dc done\n");
+
+	ret =3D rwnx_plat_patch_load_8800dc(sdiodev);
+	if (ret) {
+		pr_err("aicbsp patch load return %d\n", ret);
+		return ret;
+	}
+	pr_info("aicbsp ############ rwnx_plat_patch_load done\n");
+
+	// rwnx_plat_userconfig_load(sdiodev);
+
+	aicwf_patch_config_8800dc(sdiodev);
+	pr_info("aicbsp ############ aicwf_patch_config_8800dc done\n");
+
+	start_from_bootrom_8800DC(sdiodev);
+
+	return 0;
+}
+
+static int aic8800dc_set_patch_info(struct aic_sdio_dev *sdiodev,
+				    struct aicbt_patch_info_t *patch_info,
+				    struct aicbsp_info_t *aicbsp_info,
+				    struct aicbt_patch_table *head)
+{
+	if (aicbsp_info->chip_rev =3D=3D CHIP_REV_U01)
+		patch_info->addr_adid =3D RAM_8800DC_U01_ADID_ADDR;
+	else if (aicbsp_info->chip_rev =3D=3D CHIP_REV_U02)
+		patch_info->addr_adid =3D RAM_8800DC_U02_ADID_ADDR;
+	patch_info->addr_patch =3D RAM_8800DC_FW_PATCH_ADDR;
+	aicbt_patch_info_unpack(patch_info, head);
+	if (patch_info->reset_addr =3D=3D 0) {
+		patch_info->reset_addr =3D FW_RESET_START_ADDR;
+		patch_info->reset_val =3D FW_RESET_START_VAL;
+		patch_info->adid_flag_addr =3D FW_ADID_FLAG_ADDR;
+		patch_info->adid_flag =3D FW_ADID_FLAG_VAL;
+		if (rwnx_send_dbg_mem_write_req(sdiodev, patch_info->reset_addr,
+						patch_info->reset_val))
+			return -1;
+		if (rwnx_send_dbg_mem_write_req(sdiodev, patch_info->adid_flag_addr,
+						patch_info->adid_flag))
+			return -1;
+	}
+
+	return 0;
+}
+
+static int aic8800dc_driver_fw_init(struct aic_sdio_dev *sdiodev, u32 *bte=
nable,
+				    struct aicbsp_info_t *aicbsp_info,
+				    const struct aicbsp_firmware **aicbsp_firmware_list)
+{
+	u32 mem_addr;
+	struct dbg_mem_read_cfm rd_mem_addr_cfm;
+	u8 is_chip_id_h =3D 0;
+
+	mem_addr =3D 0x40500000;
+
+	if (rwnx_send_dbg_mem_read_req(sdiodev, mem_addr, &rd_mem_addr_cfm))
+		return -1;
+
+	aicbsp_info->chip_rev =3D (u8)((rd_mem_addr_cfm.memdata >> 16) & 0x3F);
+	is_chip_id_h =3D (u8)(((rd_mem_addr_cfm.memdata >> 16) & 0xC0) =3D=3D 0xC=
0);
+
+	*btenable =3D ((rd_mem_addr_cfm.memdata >> 26) & 0x1);
+	AICWFDBG(LOGINFO, "btenable =3D %d\n", *btenable);
+
+	if (*btenable =3D=3D 0) {
+		sdiodev->chipid =3D PRODUCT_ID_AIC8800DW;
+		AICWFDBG(LOGINFO, "AIC8800DC change to AIC8800DW\n");
+	}
+
+	if (aicbsp_info->chip_rev !=3D CHIP_REV_U01 &&
+	    aicbsp_info->chip_rev !=3D CHIP_REV_U02 &&
+		aicbsp_info->chip_rev !=3D CHIP_REV_U03 &&
+		aicbsp_info->chip_rev !=3D CHIP_REV_U04) {
+		pr_err("aicbsp: %s, unsupport chip rev: %d\n", __func__,
+		       aicbsp_info->chip_rev);
+		return -1;
+	}
+	if (is_chip_id_h) {
+		AICWFDBG(LOGINFO, "IS_CHIP_ID_H\n");
+		*aicbsp_firmware_list =3D fw_8800dc_h_u02;
+	} else {
+		if (aicbsp_info->chip_rev =3D=3D CHIP_REV_U01)
+			*aicbsp_firmware_list =3D fw_8800dc_u01;
+		else
+			*aicbsp_firmware_list =3D fw_8800dc_u02;
+	}
+
+	return 0;
+}
+
+/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Ops instances =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D */
+
+const struct aic_chip_ops aic_chip_aic8800dc_ops =3D {
+	.name						=3D "AIC8800DC",
+	.use_func_msg				=3D true,
+	.use_sdiov3_func			=3D false,
+	.need_flowctrl_mask			=3D true,
+	.wakeup_reg_val				=3D 1,
+	.use_flowctrl_msg			=3D false,
+	.use_hdr_checksum			=3D false,
+	.need_fix_hdr_len			=3D true,
+	.need_func0_intr			=3D false,
+	.use_func2					=3D true,
+	.sdio_clock					=3D FEATURE_SDIO_CLOCK,
+	.wifi_init					=3D aic8800dc_wifi_init,
+	.set_patch_info				=3D aic8800dc_set_patch_info,
+	.driver_fw_init				=3D aic8800dc_driver_fw_init,
+
+};
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic_chip_8801.c b/drivers=
/net/wireless/aic/aic8800_bsp/aic_chip_8801.c
new file mode 100644
index 0000000000000..f28979e25a28c
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic_chip_8801.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 AIC semiconductor.
+ *
+ * @file aic_chip_8801.c
+ * @brief Chip operations for AIC8801 / AIC8800DC / AIC8800DW
+ */
+
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/ieee80211.h>
+#include "aic_chip_ops.h"
+#include "aic_bsp_driver.h"
+
+#include "aic8800dc_compat.h"
+#include "aic8800d80_compat.h"
+
+static int aic8801_wifi_init(struct aic_sdio_dev *sdiodev, int testmode)
+{
+#ifdef CONFIG_M2D_OTA_AUTO_SUPPORT
+	if (testmode =3D=3D FW_M2D_OTA_MODE)
+		rwnx_plat_m2d_flash_ota(sdiodev, FW_M2D_OTA_NAME);
+	else if (testmode =3D=3D FW_NORMAL_MODE)
+		rwnx_plat_m2d_flash_ota_check(sdiodev, FW_M2D_OTA_NAME);
+#endif
+	const char *fw_path =3D aicbsp_firmware_list[aicbsp_info.cpmode].wl_fw;
+
+	if (rwnx_plat_bin_fw_upload(sdiodev, RAM_FMAC_FW_ADDR,
+				    fw_path)) {
+		pr_err("aicbsp download wifi fw fail\n");
+		return -1;
+	}
+	if (testmode =3D=3D FW_NORMAL_MODE) {
+		if (rwnx_plat_bin_fw_upload(sdiodev, RAM_FMAC_FW_PATCH_ADDR,
+					    RAM_FMAC_FW_PATCH_NAME)) {
+			pr_err("aicbsp download wifi fw patch fail\n");
+			return -1;
+		}
+	}
+
+	if (aicwifi_patch_config(sdiodev)) {
+		pr_err("aicbsp aicwifi_patch_config fail\n");
+		return -1;
+	}
+
+	if (aicwifi_sys_config(sdiodev)) {
+		pr_err("aicbsp aicwifi_sys_config fail\n");
+		return -1;
+	}
+
+	if (aicwifi_start_from_bootrom(sdiodev)) {
+		pr_err("aicbsp wifi start fail\n");
+		return -1;
+	}
+	return 0;
+}
+
+static int aic8801_set_patch_info(struct aic_sdio_dev *sdiodev,
+				  struct aicbt_patch_info_t *patch_info,
+				  struct aicbsp_info_t *aicbsp_info,
+				  struct aicbt_patch_table *head)
+{
+	patch_info->addr_adid =3D FW_RAM_ADID_BASE_ADDR;
+	patch_info->addr_patch =3D FW_RAM_PATCH_BASE_ADDR;
+	return 0;
+}
+
+static int aic8801_driver_fw_init(struct aic_sdio_dev *sdiodev, u32 *btena=
ble,
+				  struct aicbsp_info_t *aicbsp_info,
+				  const struct aicbsp_firmware **aicbsp_firmware_list)
+{
+	u32 mem_addr;
+	struct dbg_mem_read_cfm rd_mem_addr_cfm;
+
+	mem_addr =3D 0x40500000;
+
+	if (rwnx_send_dbg_mem_read_req(sdiodev, mem_addr, &rd_mem_addr_cfm))
+		return -1;
+
+	aicbsp_info->chip_rev =3D (u8)(rd_mem_addr_cfm.memdata >> 16);
+	*btenable =3D 1;
+
+	if (aicbsp_info->chip_rev !=3D CHIP_REV_U02 &&
+	    aicbsp_info->chip_rev !=3D CHIP_REV_U03 &&
+		aicbsp_info->chip_rev !=3D CHIP_REV_U04) {
+		pr_err("aicbsp: %s, unsupport chip rev: %d\n", __func__,
+		       aicbsp_info->chip_rev);
+		return -1;
+	}
+
+	if (aicbsp_info->chip_rev !=3D CHIP_REV_U02)
+		*aicbsp_firmware_list =3D fw_u03;
+
+	if (aicbsp_system_config(sdiodev))
+		return -1;
+
+	return 0;
+}
+
+/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Ops instances =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D */
+
+const struct aic_chip_ops aic_chip_aic8801_ops =3D {
+	.name						=3D "AIC8801",
+	.use_func_msg				=3D false,
+	.use_sdiov3_func			=3D false,
+	.need_flowctrl_mask			=3D true,
+	.wakeup_reg_val				=3D 1,
+	.use_flowctrl_msg			=3D true,
+	.use_hdr_checksum			=3D false,
+	.need_fix_hdr_len			=3D true,
+	.need_func0_intr			=3D false,
+	.use_func2					=3D true,
+	.sdio_clock					=3D FEATURE_SDIO_CLOCK,
+	.wifi_init					=3D aic8801_wifi_init,
+	.set_patch_info				=3D aic8801_set_patch_info,
+	.driver_fw_init				=3D aic8801_driver_fw_init,
+};
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic_chip_ops.c b/drivers/=
net/wireless/aic/aic8800_bsp/aic_chip_ops.c
new file mode 100644
index 0000000000000..9bbdff4521767
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic_chip_ops.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 AIC semiconductor.
+ *
+ * @file aic_chip_ops.c
+ * @brief Wrapper function implementations for chip-specific operations.
+ */
+
+#include <linux/errno.h>
+#include <linux/types.h>
+#include "aic_chip_ops.h"
+#include "aicsdio.h"
+
+int aicwf_sdio_chipmatch(u16 vid, u16 did, u16 *chipid)
+{
+	if (vid =3D=3D SDIO_VENDOR_ID_AIC8801 && did =3D=3D SDIO_DEVICE_ID_AIC880=
1) {
+		*chipid =3D PRODUCT_ID_AIC8801;
+		AICWFDBG(LOGINFO, "%s USE AIC8801\r\n", __func__);
+		return 0;
+	} else if (vid =3D=3D SDIO_VENDOR_ID_AIC8800DC &&
+		   did =3D=3D SDIO_DEVICE_ID_AIC8800DC) {
+		*chipid =3D PRODUCT_ID_AIC8800DC;
+		AICWFDBG(LOGINFO, "%s USE AIC8800DC\r\n", __func__);
+		return 0;
+	} else if (vid =3D=3D SDIO_VENDOR_ID_AIC8800D80 &&
+		   did =3D=3D SDIO_DEVICE_ID_AIC8800D80) {
+		*chipid =3D PRODUCT_ID_AIC8800D80;
+		AICWFDBG(LOGINFO, "%s USE AIC8800D80\r\n", __func__);
+		return 0;
+	}
+	return -ENODEV;
+}
+
+/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Chip ops wrappers =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D */
+int aic_chip_wifi_init(struct aic_sdio_dev *sdiodev, int testmode)
+{
+	if (sdiodev->chip_ops && sdiodev->chip_ops->wifi_init)
+		return sdiodev->chip_ops->wifi_init(sdiodev, testmode);
+	return 0;
+}
+
+int aic_chip_set_patch_info(struct aic_sdio_dev *sdiodev,
+			    struct aicbt_patch_info_t *patch_info,
+			    struct aicbsp_info_t *aicbsp_info,
+			    struct aicbt_patch_table *head)
+{
+	if (sdiodev->chip_ops && sdiodev->chip_ops->set_patch_info)
+		return sdiodev->chip_ops->set_patch_info(sdiodev, patch_info,
+							 aicbsp_info, head);
+	return 0;
+}
+
+int aic_chip_driver_fw_init(struct aic_sdio_dev *sdiodev, u32 *btenable,
+			    struct aicbsp_info_t *aicbsp_info,
+			    const struct aicbsp_firmware **aicbsp_firmware_list)
+{
+	if (sdiodev->chip_ops && sdiodev->chip_ops->driver_fw_init)
+		return sdiodev->chip_ops->driver_fw_init(sdiodev, btenable,
+							 aicbsp_info,
+							 aicbsp_firmware_list);
+	return 0;
+}
+
+const struct aic_chip_ops *aic_chip_ops_select(u16 chipid)
+{
+	switch (chipid) {
+	case PRODUCT_ID_AIC8801:
+		return &aic_chip_aic8801_ops;
+	case PRODUCT_ID_AIC8800DC:
+	case PRODUCT_ID_AIC8800DW:
+		return &aic_chip_aic8800dc_ops;
+	case PRODUCT_ID_AIC8800D80:
+		return &aic_chip_aic8800d80_ops;
+	default:
+		return NULL;
+	}
+}
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic_chip_ops.h b/drivers/=
net/wireless/aic/aic8800_bsp/aic_chip_ops.h
new file mode 100644
index 0000000000000..2a4e81196da7e
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic_chip_ops.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2024 AIC semiconductor.
+ *
+ * @file aic_chip_ops.h
+ * @brief Chip-specific operation interfaces for AIC8800 series.
+ */
+#ifndef _AIC_BSP_CHIP_OPS_H_
+#define _AIC_BSP_CHIP_OPS_H_
+
+#include <linux/types.h>
+
+struct aic_sdio_dev;
+struct aicbsp_info_t;
+struct aicbt_patch_info_t;
+struct aicbt_patch_table;
+struct aicbsp_firmware;
+
+/* Match SDIO vendor/device IDs to a chip product ID */
+int aicwf_sdio_chipmatch(u16 vendor, u16 device, u16 *chipid);
+
+/*
+ * struct aic_chip_ops - Chip-specific operations
+ *
+ * Each chip variant provides an instance of this struct.
+ * Selected at probe time based on chipid, then used to
+ * eliminate chipid-based if-else branching throughout the driver.
+ */
+struct aic_chip_ops {
+	const char *name;
+	const bool use_func_msg;
+	const bool use_sdiov3_func;
+	const bool need_flowctrl_mask;
+	const u8 wakeup_reg_val;
+	const bool use_flowctrl_msg;
+	const bool use_hdr_checksum;
+	const bool need_fix_hdr_len;
+	const bool need_func0_intr;
+	const bool use_func2;
+	const u32  sdio_clock;
+
+	int (*wifi_init)(struct aic_sdio_dev *sdiodev, int testmode);
+
+	int (*set_patch_info)(struct aic_sdio_dev *sdiodev,
+			      struct aicbt_patch_info_t *patch_info,
+			      struct aicbsp_info_t *aicbsp_info,
+			      struct aicbt_patch_table *head);
+
+	int (*driver_fw_init)(struct aic_sdio_dev *sdiodev, u32 *btenable,
+			      struct aicbsp_info_t *aicbsp_info,
+			      const struct aicbsp_firmware **aicbsp_firmware_list);
+};
+
+extern const struct aic_chip_ops aic_chip_aic8801_ops;
+extern const struct aic_chip_ops aic_chip_aic8800dc_ops;
+extern const struct aic_chip_ops aic_chip_aic8800d80_ops;
+
+/* Select the appropriate chip ops based on chip product ID */
+const struct aic_chip_ops *aic_chip_ops_select(u16 chipid);
+
+/* Wrapper function declarations (implemented in aic_chip_ops.c) */
+int aic_chip_wifi_init(struct aic_sdio_dev *sdiodev, int testmode);
+int aic_chip_set_patch_info(struct aic_sdio_dev *sdiodev,
+			    struct aicbt_patch_info_t *patch_info,
+			    struct aicbsp_info_t *aicbsp_info,
+			    struct aicbt_patch_table *head);
+int aic_chip_driver_fw_init(struct aic_sdio_dev *sdiodev, u32 *btenable,
+			    struct aicbsp_info_t *aicbsp_info,
+			    const struct aicbsp_firmware **aicbsp_firmware_list);
+
+#endif /* _AIC_BSP_CHIP_OPS_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aicsdio.c b/drivers/net/w=
ireless/aic/aic8800_bsp/aicsdio.c
new file mode 100644
index 0000000000000..46f0a42a11228
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aicsdio.c
@@ -0,0 +1,2020 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief bsp sdio config
+ *
+ *************************************************************************=
*****
+ */
+#include "aicsdio.h"
+#include "aic_bsp_driver.h"
+#include "aicsdio_txrxif.h"
+#include "aic_bsp_export.h"
+#include "aic_chip_ops.h"
+
+#include <linux/completion.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/kthread.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sdio.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/semaphore.h>
+#include <linux/version.h>
+#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
+#include <linux/of_platform.h>
+
+static int aicbsp_platform_power_on(void);
+static void aicbsp_platform_power_off(void);
+
+struct aic_sdio_dev *aicbsp_sdiodev;
+static struct completion *aicbsp_notify_completion;
+static struct completion *aicbsp_probe_completion;
+
+static const struct sdio_device_id aicbsp_sdmmc_ids[];
+static int bsp_init;
+static int bsp_func_init;
+
+#ifdef CONFIG_M2D_OTA_AUTO_SUPPORT
+char saved_sdk_ver[64];
+module_param_string(saved_sdk_ver, saved_sdk_ver, 64, 0660);
+#endif
+
+extern int testmode;
+
+static int aicbsp_dummy_probe(struct sdio_func *func,
+			      const struct sdio_device_id *id)
+{
+	if (func && func->num !=3D 2)
+		return 0;
+
+	if (aicbsp_notify_completion)
+		complete(aicbsp_notify_completion);
+	return 0;
+}
+
+static void aicbsp_dummy_remove(struct sdio_func *func)
+{
+}
+
+static struct sdio_driver aicbsp_dummy_sdmmc_driver =3D {
+	.probe =3D aicbsp_dummy_probe,
+	.remove =3D aicbsp_dummy_remove,
+	.name =3D "aicbsp_dummy_sdmmc",
+	.id_table =3D aicbsp_sdmmc_ids,
+};
+
+static int aicbsp_reg_sdio_notify(void *semaphore)
+{
+	aicbsp_notify_completion =3D semaphore;
+	return sdio_register_driver(&aicbsp_dummy_sdmmc_driver);
+}
+
+static void aicbsp_unreg_sdio_notify(void)
+{
+	mdelay(15);
+	sdio_unregister_driver(&aicbsp_dummy_sdmmc_driver);
+}
+
+static const char *aicbsp_subsys_name(int subsys)
+{
+	switch (subsys) {
+	case AIC_BLUETOOTH:
+		return "AIC_BLUETOOTH";
+	case AIC_WIFI:
+		return "AIC_WIFI";
+	default:
+		return "unknown subsys";
+	}
+}
+
+/**
+ * aicbsp_set_subsys - Change the power request of an AIC subsystem
+ * @subsys: Subsystem identifier from &enum aicbsp_subsys
+ * @state: Requested power state from &enum aicbsp_pwr_state
+ *
+ * Return: The resulting aggregate power state, or a negative error code.
+ */
+int aicbsp_set_subsys(int subsys, int state)
+{
+	static int pre_power_map;
+	int cur_power_map;
+	int pre_power_state;
+	int cur_power_state;
+
+	mutex_lock(&aicbsp_power_lock);
+	cur_power_map =3D pre_power_map;
+	if (state)
+		cur_power_map |=3D (1 << subsys);
+	else
+		cur_power_map &=3D ~(1 << subsys);
+
+	pre_power_state =3D pre_power_map > 0;
+	cur_power_state =3D cur_power_map > 0;
+
+	sdio_dbg("%s, subsys: %s, state to: %d\n", __func__,
+		 aicbsp_subsys_name(subsys), state);
+
+	if (cur_power_state !=3D pre_power_state) {
+		sdio_dbg("%s, power state change to %d dure to %s\n", __func__,
+			 cur_power_state, aicbsp_subsys_name(subsys));
+		if (cur_power_state) {
+			if (aicbsp_platform_power_on() < 0)
+				goto err0;
+			if (aicbsp_sdio_init())
+				goto err1;
+			if (aicbsp_driver_fw_init(aicbsp_sdiodev))
+				goto err2;
+#ifndef CONFIG_FDRV_NO_REG_SDIO
+			aicbsp_sdio_release(aicbsp_sdiodev);
+#endif
+		} else {
+			aicbsp_sdio_exit();
+			aicbsp_platform_power_off();
+		}
+	} else {
+		sdio_dbg("%s, power state no need to change, current: %d\n", __func__,
+			 cur_power_state);
+	}
+	pre_power_map =3D cur_power_map;
+	mutex_unlock(&aicbsp_power_lock);
+
+	return cur_power_state;
+
+err2:
+	aicbsp_sdio_release(aicbsp_sdiodev);
+	aicbsp_sdio_exit();
+
+err1:
+	aicbsp_platform_power_off();
+
+err0:
+	sdio_dbg("%s, fail to set %s power state to %d\n", __func__,
+		 aicbsp_subsys_name(subsys), state);
+	mutex_unlock(&aicbsp_power_lock);
+	return -1;
+}
+EXPORT_SYMBOL_GPL(aicbsp_set_subsys);
+
+void *aicbsp_get_drvdata(void *args)
+{
+	(void)args;
+	if (aicbsp_sdiodev)
+		return aicbsp_sdiodev->bus_if;
+	return dev_get_drvdata((const struct device *)args);
+}
+
+#if defined CONFIG_PLATFORM_EXTERNAL && defined CONFIG_CUSTOM_PWF
+extern void nxp_pwr_ctrl(int value);
+struct mmc_host *g_host;
+#endif
+
+static int aicbsp_sdio_probe(struct sdio_func *func,
+			     const struct sdio_device_id *id)
+{
+	struct mmc_host *host;
+	struct aic_sdio_dev *sdiodev;
+	struct aicwf_bus *bus_if;
+	int err =3D -ENODEV;
+	u16 chipid;
+
+	bsp_init =3D 1;
+	bsp_func_init =3D 1;
+
+	if (!func) {
+		sdio_err("%s func is null\n", __func__);
+		return err;
+	}
+
+	if (!aicbsp_probe_completion) {
+		sdio_err("%s bsp_probe_semaphore is null\n", __func__);
+		return err;
+	}
+
+	sdio_dbg("%s:%d vid:0x%04X  did:0x%04X\n", __func__, func->num,
+		 func->vendor, func->device);
+
+	if (func->num !=3D 2) {
+		sdio_dbg("%s func num !=3D 2\n", __func__);
+		return err;
+	}
+
+	host =3D func->card->host;
+	host->caps |=3D MMC_CAP_NONREMOVABLE;
+
+	func =3D func->card->sdio_func[1 - 1]; // replace 2 with 1
+
+	sdio_dbg("%s after replace:%d\n", __func__, func->num);
+
+	bus_if =3D
+		kzalloc_obj(*bus_if, GFP_KERNEL);
+	if (!bus_if) {
+		sdio_err("alloc bus fail\n");
+		return -ENOMEM;
+	}
+
+	sdiodev =3D
+		kzalloc_obj(*sdiodev, GFP_KERNEL);
+	if (!sdiodev) {
+		sdio_err("alloc sdiodev fail\n");
+		kfree(bus_if);
+		return -ENOMEM;
+	}
+	aicbsp_sdiodev =3D sdiodev;
+
+	err =3D aicwf_sdio_chipmatch(func->vendor, func->device, &chipid);
+	sdiodev->chipid =3D chipid;
+	sdiodev->chip_ops =3D aic_chip_ops_select(sdiodev->chipid);
+
+	sdiodev->func =3D func;
+	if (sdiodev->chip_ops->use_func_msg)
+		sdiodev->func_msg =3D func->card->sdio_func[1];
+	sdiodev->bus_if =3D bus_if;
+	bus_if->bus_priv.sdio =3D sdiodev;
+
+	if (sdiodev->chip_ops->use_func_msg) {
+		dev_set_drvdata(&sdiodev->func_msg->dev, bus_if);
+		pr_info("aicbsp the device is PRODUCT_ID_AIC8800DC\n");
+	}
+	dev_set_drvdata(&func->dev, bus_if);
+	sdiodev->dev =3D &func->dev;
+
+	if (!sdiodev->chip_ops->use_sdiov3_func)
+		err =3D aicwf_sdio_func_init(sdiodev);
+	else
+		err =3D aicwf_sdiov3_func_init(sdiodev);
+
+	if (err < 0) {
+		sdio_err("sdio func init fail\n");
+		goto fail;
+	}
+
+	if (!aicwf_sdio_bus_init(sdiodev)) {
+		sdio_err("sdio bus init err\r\n");
+		goto fail;
+	}
+
+#if defined CONFIG_PLATFORM_EXTERNAL && defined CONFIG_CUSTOM_PWF
+	g_host =3D host;
+#endif
+
+	aicbsp_platform_init(sdiodev);
+
+	complete(aicbsp_probe_completion);
+
+	return 0;
+fail:
+	aicwf_sdio_func_deinit(sdiodev);
+	dev_set_drvdata(&func->dev, NULL);
+	kfree(sdiodev);
+	kfree(bus_if);
+	return err;
+}
+
+static void aicbsp_sdio_remove(struct sdio_func *func)
+{
+	struct mmc_host *host;
+	struct aicwf_bus *bus_if =3D NULL;
+	struct aic_sdio_dev *sdiodev =3D NULL;
+
+	pr_info("aicbsp %s\n", __func__);
+
+	if (!aicbsp_sdiodev) {
+		AICWFDBG(LOGERROR, "%s: allready unregister\n", __func__);
+		goto done;
+	}
+	if (!func) {
+		AICWFDBG(LOGERROR, "%s, sdio func is null\n", __func__);
+		goto done;
+	}
+
+	host =3D func->card->host;
+	host->caps &=3D ~MMC_CAP_NONREMOVABLE;
+
+	bus_if =3D aicbsp_get_drvdata(&func->dev);
+
+	if (!bus_if) {
+		AICWFDBG(LOGERROR, "%s bus_if is NULL \r\n", __func__);
+		goto done;
+	}
+
+	sdiodev =3D bus_if->bus_priv.sdio;
+	if (!sdiodev) {
+		AICWFDBG(LOGERROR, "%s sdiodev is NULL \r\n", __func__);
+		goto done;
+	}
+
+	aicwf_sdio_release(sdiodev);
+	aicwf_sdio_func_deinit(sdiodev);
+
+	if (bsp_init !=3D 0 && bsp_func_init !=3D 0) {
+		dev_set_drvdata(&sdiodev->func->dev, NULL);
+		kfree(sdiodev);
+	}
+
+done:
+	if (bsp_init !=3D 0 && bsp_func_init !=3D 0 && bus_if)
+		kfree(bus_if);
+	aicbsp_sdiodev =3D NULL;
+	aicbsp_probe_completion =3D NULL;
+}
+
+static int aicbsp_sdio_suspend(struct device *dev)
+{
+	struct sdio_func *func =3D dev_to_sdio_func(dev);
+	int err;
+	mmc_pm_flag_t sdio_flags;
+
+	//sdio_dbg("%s, func->num =3D %d\n", __func__, func->num);
+	if (func->num !=3D 2)
+		return 0;
+
+	sdio_flags =3D sdio_get_host_pm_caps(func);
+	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
+		sdio_dbg("%s: can't keep power while host is suspended\n", __func__);
+		return -EINVAL;
+	}
+
+	/* keep power while host suspended */
+	err =3D sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+	if (err) {
+		sdio_dbg("%s: error while trying to keep power\n", __func__);
+		return err;
+	}
+
+	return 0;
+}
+
+static int aicbsp_sdio_resume(struct device *dev)
+{
+	return 0;
+}
+
+static const struct sdio_device_id aicbsp_sdmmc_ids[] =3D {
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_AIC8801,
+		      SDIO_DEVICE_ID_AIC8801_FUNC2) },
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_AIC8800DC,
+		      SDIO_DEVICE_ID_AIC8800DC) },
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_AIC8800D80,
+		      SDIO_DEVICE_ID_AIC8800D80_FUNC2) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(sdio, aicbsp_sdmmc_ids);
+
+static const struct dev_pm_ops aicbsp_sdio_pm_ops =3D {
+	SET_SYSTEM_SLEEP_PM_OPS(aicbsp_sdio_suspend, aicbsp_sdio_resume)};
+
+static struct sdio_driver aicbsp_sdio_driver =3D {
+	.probe =3D aicbsp_sdio_probe,
+	.remove =3D aicbsp_sdio_remove,
+	.name =3D AICBSP_SDIO_NAME,
+	.id_table =3D aicbsp_sdmmc_ids,
+	.drv =3D {
+			.pm =3D &aicbsp_sdio_pm_ops,
+		},
+};
+
+static int aicbsp_platform_power_on(void)
+{
+	int ret =3D 0;
+	struct completion aic_chipup_comp;
+
+#if defined CONFIG_PLATFORM_EXTERNAL && defined CONFIG_CUSTOM_PWF
+	if (g_host) {
+		nxp_pwr_ctrl(0);
+		mdelay(10);
+		nxp_pwr_ctrl(1);
+		mdelay(50);
+		sdio_dbg("mmc detect change\n");
+		mmc_detect_change(g_host, 0);
+	}
+#endif
+
+	init_completion(&aic_chipup_comp);
+	ret =3D aicbsp_reg_sdio_notify(&aic_chipup_comp);
+	if (ret) {
+		sdio_dbg("%s aicbsp_reg_sdio_notify fail(%d)\n", __func__, ret);
+		return ret;
+	}
+
+	if (wait_for_completion_timeout(&aic_chipup_comp, msecs_to_jiffies(2000))=
) {
+		aicbsp_unreg_sdio_notify();
+		return 0;
+	}
+
+	aicbsp_unreg_sdio_notify();
+
+	return -1;
+}
+
+static void aicbsp_platform_power_off(void)
+{
+// TODO wifi disable and sdio card detection
+
+#if defined CONFIG_PLATFORM_EXTERNAL && defined CONFIG_CUSTOM_PWF
+	nxp_pwr_ctrl(0);
+#endif
+}
+
+int aicbsp_sdio_init(void)
+{
+	struct completion aic_chipup_comp;
+
+	init_completion(&aic_chipup_comp);
+	aicbsp_probe_completion =3D &aic_chipup_comp;
+
+	if (sdio_register_driver(&aicbsp_sdio_driver))
+		return -1;
+
+	if (wait_for_completion_timeout(aicbsp_probe_completion, msecs_to_jiffies=
(2000)) =3D=3D 0) {
+		pr_err("aicbsp %s aicbsp_sdio_probe fail\r\n", __func__);
+		return -1;
+	}
+
+	return 0;
+}
+
+void aicbsp_sdio_exit(void)
+{
+	sdio_unregister_driver(&aicbsp_sdio_driver);
+}
+
+void aicbsp_sdio_release(struct aic_sdio_dev *sdiodev)
+{
+	if (!sdiodev->func) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return;
+	}
+
+	sdiodev->bus_if->state =3D BUS_DOWN_ST;
+	sdio_claim_host(sdiodev->func);
+	sdio_release_irq(sdiodev->func);
+	sdio_release_host(sdiodev->func);
+	if (sdiodev->chip_ops->use_func_msg) {
+		sdio_claim_host(sdiodev->func_msg);
+		sdio_release_irq(sdiodev->func_msg);
+		sdio_release_host(sdiodev->func_msg);
+	}
+}
+
+int aicwf_sdio_readb(struct aic_sdio_dev *sdiodev, uint regaddr, u8 *val)
+{
+	int ret;
+
+	if (!sdiodev->func) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return 0;
+	}
+
+	sdio_claim_host(sdiodev->func);
+	*val =3D sdio_readb(sdiodev->func, regaddr, &ret);
+	sdio_release_host(sdiodev->func);
+	return ret;
+}
+
+int aicwf_sdio_readb_func2(struct aic_sdio_dev *sdiodev, uint regaddr, u8 =
*val)
+{
+	int ret;
+
+	if (!sdiodev->func_msg) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return 0;
+	}
+
+	sdio_claim_host(sdiodev->func_msg);
+	*val =3D sdio_readb(sdiodev->func_msg, regaddr, &ret);
+	sdio_release_host(sdiodev->func_msg);
+	return ret;
+}
+
+int aicwf_sdio_writeb(struct aic_sdio_dev *sdiodev, uint regaddr, u8 val)
+{
+	int ret;
+
+	if (!sdiodev->func) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return 0;
+	}
+
+	sdio_claim_host(sdiodev->func);
+	sdio_writeb(sdiodev->func, val, regaddr, &ret);
+	sdio_release_host(sdiodev->func);
+	return ret;
+}
+
+int aicwf_sdio_writeb_func2(struct aic_sdio_dev *sdiodev, uint regaddr, u8=
 val)
+{
+	int ret;
+
+	if (!sdiodev->func_msg) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return 0;
+	}
+	sdio_claim_host(sdiodev->func_msg);
+	sdio_writeb(sdiodev->func_msg, val, regaddr, &ret);
+	sdio_release_host(sdiodev->func_msg);
+	return ret;
+}
+
+int aicwf_sdio_flow_ctrl(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D -1;
+	u8 fc_reg =3D 0;
+	u32 count =3D 0;
+
+	while (true) {
+		ret =3D
+			aicwf_sdio_readb(sdiodev, sdiodev->sdio_reg.flow_ctrl_reg, &fc_reg);
+		if (ret)
+			return -1;
+
+		if (sdiodev->chip_ops->need_flowctrl_mask)
+			fc_reg &=3D SDIOWIFI_FLOWCTRL_MASK_REG;
+
+		if (fc_reg !=3D 0) {
+			ret =3D fc_reg;
+			return ret;
+		}
+		if (count >=3D FLOW_CTRL_RETRY_COUNT) {
+			ret =3D -fc_reg;
+			break;
+		}
+		count++;
+		if (count < 30)
+			usleep_range(30, 50);
+		else if (count < 40)
+			mdelay(1);
+		else
+			mdelay(10);
+	}
+
+	return ret;
+}
+
+int aicwf_sdio_send_msg(struct aic_sdio_dev *sdiodev, u8 *buf, uint count)
+{
+	int ret =3D 0;
+
+	if (!sdiodev->func_msg) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return 0;
+	}
+	sdio_claim_host(sdiodev->func_msg);
+	ret =3D sdio_writesb(sdiodev->func_msg, 7, buf, count);
+	sdio_release_host(sdiodev->func_msg);
+
+	return ret;
+}
+
+int aicwf_sdio_send_pkt(struct aic_sdio_dev *sdiodev, u8 *buf, uint count)
+{
+	int ret =3D 0;
+
+	if (!sdiodev->func) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return 0;
+	}
+
+	sdio_claim_host(sdiodev->func);
+	ret =3D
+		sdio_writesb(sdiodev->func, sdiodev->sdio_reg.wr_fifo_addr, buf, count);
+	sdio_release_host(sdiodev->func);
+
+	return ret;
+}
+
+int aicwf_sdio_recv_pkt(struct aic_sdio_dev *sdiodev, struct sk_buff *skbb=
uf,
+			u32 size, u8 msg)
+{
+	int ret;
+
+	if (!skbbuf || !size)
+		return -EINVAL;
+
+	if (!msg) {
+		if (!sdiodev->func) {
+			pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+			return 0;
+		}
+		sdio_claim_host(sdiodev->func);
+		ret =3D sdio_readsb(sdiodev->func, skbbuf->data,
+				  sdiodev->sdio_reg.rd_fifo_addr, size);
+		sdio_release_host(sdiodev->func);
+	} else {
+		if (!sdiodev->func_msg) {
+			pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+			return 0;
+		}
+		sdio_claim_host(sdiodev->func_msg);
+		ret =3D sdio_readsb(sdiodev->func_msg, skbbuf->data,
+				  sdiodev->sdio_reg.rd_fifo_addr, size);
+		sdio_release_host(sdiodev->func_msg);
+	}
+
+	if (ret < 0)
+		return ret;
+
+	skbbuf->len =3D size;
+
+	return ret;
+}
+
+#if defined(CONFIG_SDIO_PWRCTRL)
+int aicwf_sdio_wakeup(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+	int read_retry;
+	int write_retry =3D 20;
+	int wakeup_reg_val =3D 0;
+
+	wakeup_reg_val =3D sdiodev->chip_ops->wakeup_reg_val;
+
+	if (sdiodev->state =3D=3D SDIO_SLEEP_ST) {
+		down(&sdiodev->pwrctl_wakeup_sema);
+		while (write_retry) {
+			ret =3D aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.wakeup_reg,
+						wakeup_reg_val);
+			if (ret) {
+				txrx_err("sdio wakeup fail\n");
+				ret =3D -1;
+			} else {
+				read_retry =3D 10;
+				while (read_retry) {
+					u8 val;
+
+					ret =3D aicwf_sdio_readb(sdiodev, sdiodev->sdio_reg.sleep_reg,
+							       &val);
+					if (ret =3D=3D 0 && val & 0x10)
+						break;
+
+					read_retry--;
+					usleep_range(30, 50);
+				}
+				if (read_retry !=3D 0)
+					break;
+			}
+			sdio_dbg("write retry:  %d\n", write_retry);
+			write_retry--;
+			usleep_range(30, 50);
+		}
+		up(&sdiodev->pwrctl_wakeup_sema);
+	}
+
+	sdiodev->state =3D SDIO_ACTIVE_ST;
+	aicwf_sdio_pwrctl_timer(sdiodev, sdiodev->active_duration);
+
+	return ret;
+}
+
+int aicwf_sdio_sleep_allow(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+	struct aicwf_bus *bus_if =3D sdiodev->bus_if;
+
+	if (bus_if->state =3D=3D BUS_DOWN_ST) {
+		ret =3D aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.sleep_reg, 0x10);
+		if (ret)
+			sdio_err("Write sleep fail!\n");
+
+		aicwf_sdio_pwrctl_timer(sdiodev, 0);
+		return ret;
+	}
+
+	if (sdiodev->state =3D=3D SDIO_ACTIVE_ST) {
+		{
+			sdio_dbg("s\n");
+			ret =3D aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.sleep_reg, 0x10);
+			if (ret)
+				sdio_err("Write sleep fail!\n");
+		}
+		sdiodev->state =3D SDIO_SLEEP_ST;
+		aicwf_sdio_pwrctl_timer(sdiodev, 0);
+	} else {
+		aicwf_sdio_pwrctl_timer(sdiodev, sdiodev->active_duration);
+	}
+
+	return ret;
+}
+
+int aicwf_sdio_pwr_stctl(struct aic_sdio_dev *sdiodev, uint target)
+{
+	int ret =3D 0;
+
+	if (sdiodev->bus_if->state =3D=3D BUS_DOWN_ST)
+		return -1;
+
+	if (sdiodev->state =3D=3D target) {
+		if (target =3D=3D SDIO_ACTIVE_ST)
+			aicwf_sdio_pwrctl_timer(sdiodev, sdiodev->active_duration);
+
+		return ret;
+	}
+
+	switch (target) {
+	case SDIO_ACTIVE_ST:
+		aicwf_sdio_wakeup(sdiodev);
+		break;
+	case SDIO_SLEEP_ST:
+		aicwf_sdio_sleep_allow(sdiodev);
+		break;
+	}
+
+	return ret;
+}
+#endif
+
+int aicwf_sdio_txpkt(struct aic_sdio_dev *sdiodev, struct sk_buff *pkt)
+{
+	int ret =3D 0;
+	u32 len =3D 0;
+	struct aicwf_bus *bus_if =3D dev_get_drvdata(sdiodev->dev);
+
+	if (bus_if->state =3D=3D BUS_DOWN_ST) {
+		sdio_dbg("tx bus is down!\n");
+		return -EINVAL;
+	}
+
+	len =3D pkt->len;
+	len =3D (len + SDIOWIFI_FUNC_BLOCKSIZE - 1) / SDIOWIFI_FUNC_BLOCKSIZE *
+		  SDIOWIFI_FUNC_BLOCKSIZE;
+	ret =3D aicwf_sdio_send_pkt(sdiodev, pkt->data, len);
+	if (ret)
+		sdio_err("aicwf_sdio_send_pkt fail%d\n", ret);
+
+	return ret;
+}
+
+static int aicwf_sdio_intr_get_len_bytemode(struct aic_sdio_dev *sdiodev,
+					    u8 *byte_len)
+{
+	int ret =3D 0;
+
+	if (!byte_len)
+		return -EBADE;
+
+	if (sdiodev->bus_if->state =3D=3D BUS_DOWN_ST) {
+		*byte_len =3D 0;
+	} else {
+		ret =3D aicwf_sdio_readb(sdiodev, sdiodev->sdio_reg.bytemode_len_reg,
+				       byte_len);
+		sdiodev->rx_priv->data_len =3D (*byte_len) * 4;
+	}
+
+	return ret;
+}
+
+static void aicwf_sdio_bus_stop(struct device *dev)
+{
+	struct aicwf_bus *bus_if =3D aicbsp_get_drvdata(dev);
+	struct aic_sdio_dev *sdiodev =3D bus_if->bus_priv.sdio;
+	int ret;
+
+#if defined(CONFIG_SDIO_PWRCTRL)
+	aicwf_sdio_pwrctl_timer(sdiodev, 0);
+	if (sdiodev->pwrctl_tsk) {
+		complete_all(&sdiodev->pwrctrl_trgg);
+		kthread_stop(sdiodev->pwrctl_tsk);
+		sdiodev->pwrctl_tsk =3D NULL;
+	}
+#endif
+	bus_if->state =3D BUS_DOWN_ST;
+	ret =3D down_interruptible(&sdiodev->tx_priv->txctl_sema);
+	if (ret)
+		sdio_err("down txctl_sema fail\n");
+
+#if defined(CONFIG_SDIO_PWRCTRL)
+	aicwf_sdio_pwr_stctl(sdiodev, SDIO_SLEEP_ST);
+#endif
+	if (!ret)
+		up(&sdiodev->tx_priv->txctl_sema);
+	aicwf_frame_queue_flush(&sdiodev->tx_priv->txq);
+}
+
+struct sk_buff *aicwf_sdio_readframes(struct aic_sdio_dev *sdiodev, u8 msg=
)
+{
+	int ret =3D 0;
+	u32 size =3D 0;
+	struct sk_buff *skb =3D NULL;
+	struct aicwf_bus *bus_if =3D dev_get_drvdata(sdiodev->dev);
+
+	if (bus_if->state =3D=3D BUS_DOWN_ST) {
+		sdio_dbg("bus down\n");
+		return NULL;
+	}
+
+	size =3D sdiodev->rx_priv->data_len;
+	skb =3D __dev_alloc_skb(size, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	ret =3D aicwf_sdio_recv_pkt(sdiodev, skb, size, msg);
+	if (ret) {
+		dev_kfree_skb(skb);
+		skb =3D NULL;
+	}
+
+	return skb;
+}
+
+static int aicwf_sdio_tx_msg(struct aic_sdio_dev *sdiodev)
+{
+	int err =3D 0;
+	u16 len;
+	u8 *payload =3D sdiodev->tx_priv->cmd_buf;
+	u16 payload_len =3D sdiodev->tx_priv->cmd_len;
+	u8 adjust_str[4] =3D {0, 0, 0, 0};
+	int adjust_len =3D 0;
+	int buffer_cnt =3D 0;
+	u8 retry =3D 0;
+
+	len =3D payload_len;
+	if ((len % TX_ALIGNMENT) !=3D 0) {
+		adjust_len =3D roundup(len, TX_ALIGNMENT);
+		memcpy(payload + payload_len, adjust_str, (adjust_len - len));
+		payload_len +=3D (adjust_len - len);
+	}
+	len =3D payload_len;
+
+	// link tail is necessary
+	if ((len % SDIOWIFI_FUNC_BLOCKSIZE) !=3D 0) {
+		memset(payload + payload_len, 0, TAIL_LEN);
+		payload_len +=3D TAIL_LEN;
+		len =3D (payload_len / SDIOWIFI_FUNC_BLOCKSIZE + 1) *
+			  SDIOWIFI_FUNC_BLOCKSIZE;
+	} else {
+		len =3D payload_len;
+	}
+
+	if (sdiodev->chip_ops->use_flowctrl_msg) {
+		buffer_cnt =3D aicwf_sdio_flow_ctrl(sdiodev);
+		while ((buffer_cnt <=3D 0 ||
+			(buffer_cnt > 0 && len > (buffer_cnt * BUFFER_SIZE))) &&
+			   retry < 10) {
+			retry++;
+			buffer_cnt =3D aicwf_sdio_flow_ctrl(sdiodev);
+			pr_info("aicbsp buffer_cnt =3D %d\n", buffer_cnt);
+		}
+	}
+	down(&sdiodev->tx_priv->cmd_txsema);
+
+	if (sdiodev->chip_ops->use_flowctrl_msg) {
+		if (buffer_cnt > 0 && len < (buffer_cnt * BUFFER_SIZE)) {
+			err =3D aicwf_sdio_send_pkt(sdiodev, payload, len);
+			if (err)
+				sdio_err("aicwf_sdio_send_pkt fail%d\n", err);
+
+		} else {
+			sdio_err("tx msg fc retry fail:%d, %d\n", buffer_cnt, len);
+			up(&sdiodev->tx_priv->cmd_txsema);
+			return -1;
+		}
+	} else {
+		err =3D aicwf_sdio_send_msg(sdiodev, payload, len);
+		if (err)
+			sdio_err("aicwf_sdio_send_pkt fail%d\n", err);
+	}
+
+	sdiodev->tx_priv->cmd_txstate =3D false;
+	if (!err)
+		sdiodev->tx_priv->cmd_tx_succ =3D true;
+	else
+		sdiodev->tx_priv->cmd_tx_succ =3D false;
+
+	up(&sdiodev->tx_priv->cmd_txsema);
+
+	return err;
+}
+
+static void aicwf_sdio_tx_process(struct aic_sdio_dev *sdiodev)
+{
+	if (sdiodev->bus_if->state =3D=3D BUS_DOWN_ST) {
+		sdio_err("Bus is down\n");
+		return;
+	}
+
+#if defined(CONFIG_SDIO_PWRCTRL)
+	aicwf_sdio_pwr_stctl(sdiodev, SDIO_ACTIVE_ST);
+#endif
+
+	// config
+	sdio_info("send cmd\n");
+	if (sdiodev->tx_priv->cmd_txstate) {
+		if (down_interruptible(&sdiodev->tx_priv->txctl_sema)) {
+			txrx_err("txctl down bus->txctl_sema fail\n");
+			return;
+		}
+		if (sdiodev->state !=3D SDIO_ACTIVE_ST) {
+			txrx_err("state err\n");
+			up(&sdiodev->tx_priv->txctl_sema);
+			txrx_err("txctl up bus->txctl_sema fail\n");
+			return;
+		}
+
+		if (aicwf_sdio_tx_msg(sdiodev))
+			sdio_err("failed to send command\n");
+		up(&sdiodev->tx_priv->txctl_sema);
+		/* to prevent race conditions with wake-up operations */
+		if (waitqueue_active(&sdiodev->tx_priv->cmd_txdone_wait))
+			wake_up(&sdiodev->tx_priv->cmd_txdone_wait);
+	}
+
+	// data
+	sdio_info("send data\n");
+	if (down_interruptible(&sdiodev->tx_priv->txctl_sema)) {
+		txrx_err("txdata down bus->txctl_sema\n");
+		return;
+	}
+
+	if (sdiodev->state !=3D SDIO_ACTIVE_ST) {
+		txrx_err("sdio state err\n");
+		up(&sdiodev->tx_priv->txctl_sema);
+		return;
+	}
+
+	if (!aicwf_is_framequeue_empty(&sdiodev->tx_priv->txq))
+		sdiodev->tx_priv->fw_avail_bufcnt =3D aicwf_sdio_flow_ctrl(sdiodev);
+	while (!aicwf_is_framequeue_empty(&sdiodev->tx_priv->txq)) {
+		aicwf_sdio_send(sdiodev->tx_priv);
+		if (sdiodev->tx_priv->cmd_txstate)
+			break;
+	}
+
+	up(&sdiodev->tx_priv->txctl_sema);
+}
+
+static int aicwf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
+{
+	uint prio;
+	int ret =3D -EBADE;
+	struct aicwf_bus *bus_if =3D dev_get_drvdata(dev);
+	struct aic_sdio_dev *sdiodev =3D bus_if->bus_priv.sdio;
+
+	prio =3D (pkt->priority & 0x7);
+	spin_lock_bh(&sdiodev->tx_priv->txqlock);
+	if (!aicwf_frame_enq(sdiodev->dev, &sdiodev->tx_priv->txq, pkt, prio)) {
+		spin_unlock_bh(&sdiodev->tx_priv->txqlock);
+		return -ENOSR;
+	}
+	ret =3D 0;
+
+	if (bus_if->state !=3D BUS_UP_ST) {
+		sdio_err("bus_if stopped\n");
+		spin_unlock_bh(&sdiodev->tx_priv->txqlock);
+		return -1;
+	}
+
+	atomic_inc(&sdiodev->tx_priv->tx_pktcnt);
+	spin_unlock_bh(&sdiodev->tx_priv->txqlock);
+	complete(&bus_if->bustx_trgg);
+
+	return ret;
+}
+
+static int aicwf_sdio_bus_txmsg(struct device *dev, u8 *msg, uint msglen)
+{
+	int ret =3D -1;
+	struct aicwf_bus *bus_if =3D dev_get_drvdata(dev);
+	struct aic_sdio_dev *sdiodev =3D bus_if->bus_priv.sdio;
+
+	down(&sdiodev->tx_priv->cmd_txsema);
+	sdiodev->tx_priv->cmd_txstate =3D true;
+	sdiodev->tx_priv->cmd_tx_succ =3D false;
+	sdiodev->tx_priv->cmd_buf =3D msg;
+	sdiodev->tx_priv->cmd_len =3D msglen;
+	up(&sdiodev->tx_priv->cmd_txsema);
+
+	if (bus_if->state !=3D BUS_UP_ST) {
+		sdio_err("bus has stop\n");
+		return -1;
+	}
+
+	complete(&bus_if->bustx_trgg);
+
+	if (sdiodev->tx_priv->cmd_txstate) {
+		int timeout =3D msecs_to_jiffies(CMD_TX_TIMEOUT);
+
+		ret =3D wait_event_timeout(sdiodev->tx_priv->cmd_txdone_wait,
+					 !(sdiodev->tx_priv->cmd_txstate), timeout);
+	}
+
+	if (!sdiodev->tx_priv->cmd_txstate && sdiodev->tx_priv->cmd_tx_succ) {
+		ret =3D 0;
+	} else {
+		sdio_err("send failed:%d, %d,%x\n", sdiodev->tx_priv->cmd_txstate,
+			 sdiodev->tx_priv->cmd_tx_succ, ret);
+		ret =3D -EIO;
+	}
+
+	return ret;
+}
+
+int aicwf_sdio_send(struct aicwf_tx_priv *tx_priv)
+{
+	struct sk_buff *pkt;
+	struct aic_sdio_dev *sdiodev =3D tx_priv->sdiodev;
+	u16 aggr_len =3D 0;
+	int retry_times =3D 0;
+	int max_retry_times =3D 5;
+
+	aggr_len =3D (tx_priv->tail - tx_priv->head);
+	if (((atomic_read(&tx_priv->aggr_count) =3D=3D 0) && aggr_len !=3D 0) ||
+	    ((atomic_read(&tx_priv->aggr_count) !=3D 0) && aggr_len =3D=3D 0)) {
+		if (aggr_len > 0)
+			aicwf_sdio_aggrbuf_reset(tx_priv);
+		goto done;
+	}
+
+	if (tx_priv->fw_avail_bufcnt <=3D 0) { // flow control failed
+		tx_priv->fw_avail_bufcnt =3D aicwf_sdio_flow_ctrl(sdiodev);
+		while (tx_priv->fw_avail_bufcnt <=3D 0 && retry_times < max_retry_times)=
 {
+			retry_times++;
+			tx_priv->fw_avail_bufcnt =3D aicwf_sdio_flow_ctrl(sdiodev);
+		}
+		if (tx_priv->fw_avail_bufcnt <=3D 0) {
+			sdio_err("fc retry %d fail\n", tx_priv->fw_avail_bufcnt);
+			goto done;
+		}
+	}
+
+	if (atomic_read(&tx_priv->aggr_count) =3D=3D tx_priv->fw_avail_bufcnt) {
+		if (atomic_read(&tx_priv->aggr_count) > 0) {
+			tx_priv->fw_avail_bufcnt -=3D atomic_read(&tx_priv->aggr_count);
+			aicwf_sdio_aggr_send(tx_priv); // send and check the next pkt;
+		}
+	} else {
+		spin_lock_bh(&sdiodev->tx_priv->txqlock);
+		pkt =3D aicwf_frame_dequeue(&sdiodev->tx_priv->txq);
+		if (!pkt) {
+			sdio_err("txq no pkt\n");
+			spin_unlock_bh(&sdiodev->tx_priv->txqlock);
+			goto done;
+		}
+		atomic_dec(&sdiodev->tx_priv->tx_pktcnt);
+		spin_unlock_bh(&sdiodev->tx_priv->txqlock);
+
+		if (!tx_priv || !tx_priv->tail || !pkt)
+			txrx_err("null error\n");
+		if (aicwf_sdio_aggr(tx_priv, pkt)) {
+			aicwf_sdio_aggrbuf_reset(tx_priv);
+			sdio_err("add aggr pkts failed!\n");
+			goto done;
+		}
+
+		// when aggr finish or there is cmd to send, just send this aggr pkt to
+		// fw
+		if ((int)atomic_read(&sdiodev->tx_priv->tx_pktcnt) =3D=3D 0 ||
+		    sdiodev->tx_priv->cmd_txstate) { // no more pkt send it!
+			tx_priv->fw_avail_bufcnt -=3D atomic_read(&tx_priv->aggr_count);
+			aicwf_sdio_aggr_send(tx_priv);
+		} else {
+			goto done;
+		}
+	}
+
+done:
+	return 0;
+}
+
+int aicwf_sdio_aggr(struct aicwf_tx_priv *tx_priv, struct sk_buff *pkt)
+{
+	// struct rwnx_txhdr *txhdr =3D (struct rwnx_txhdr *)pkt->data;
+	u8 *start_ptr =3D tx_priv->tail;
+	u8 sdio_header[4];
+	u8 adjust_str[4] =3D {0, 0, 0, 0};
+	u16 curr_len =3D 0;
+	int allign_len =3D 0;
+
+	sdio_header[2] =3D 0x01; // data
+	if (aicbsp_sdiodev->chip_ops->use_hdr_checksum)
+		sdio_header[3] =3D crc8_ponl_107(&sdio_header[0], 3); // crc8
+	else
+		sdio_header[3] =3D 0; // reserved
+
+	memcpy(tx_priv->tail, (u8 *)&sdio_header, sizeof(sdio_header));
+	tx_priv->tail +=3D sizeof(sdio_header);
+
+	// word alignment
+	curr_len =3D tx_priv->tail - tx_priv->head;
+	if (curr_len & (TX_ALIGNMENT - 1)) {
+		allign_len =3D roundup(curr_len, TX_ALIGNMENT) - curr_len;
+		memcpy(tx_priv->tail, adjust_str, allign_len);
+		tx_priv->tail +=3D allign_len;
+	}
+
+	if (aicbsp_sdiodev->chip_ops->need_fix_hdr_len) {
+		start_ptr[0] =3D ((tx_priv->tail - start_ptr - 4) & 0xff);
+		start_ptr[1] =3D (((tx_priv->tail - start_ptr - 4) >> 8) & 0x0f);
+	}
+
+	tx_priv->aggr_buf->dev =3D pkt->dev;
+
+	consume_skb(pkt);
+	atomic_inc(&tx_priv->aggr_count);
+	return 0;
+}
+
+void aicwf_sdio_aggr_send(struct aicwf_tx_priv *tx_priv)
+{
+	struct sk_buff *tx_buf =3D tx_priv->aggr_buf;
+	int ret =3D 0;
+	int curr_len =3D 0;
+
+	// link tail is necessary
+	curr_len =3D tx_priv->tail - tx_priv->head;
+	if ((curr_len % TXPKT_BLOCKSIZE) !=3D 0) {
+		memset(tx_priv->tail, 0, TAIL_LEN);
+		tx_priv->tail +=3D TAIL_LEN;
+	}
+
+	tx_buf->len =3D tx_priv->tail - tx_priv->head;
+	ret =3D aicwf_sdio_txpkt(tx_priv->sdiodev, tx_buf);
+	if (ret < 0)
+		sdio_err("fail to send aggr pkt!\n");
+
+	aicwf_sdio_aggrbuf_reset(tx_priv);
+}
+
+void aicwf_sdio_aggrbuf_reset(struct aicwf_tx_priv *tx_priv)
+{
+	struct sk_buff *aggr_buf =3D tx_priv->aggr_buf;
+
+	tx_priv->tail =3D tx_priv->head;
+	aggr_buf->len =3D 0;
+	atomic_set(&tx_priv->aggr_count, 0);
+}
+
+static int aicwf_sdio_bus_start(struct device *dev)
+{
+	struct aicwf_bus *bus_if =3D dev_get_drvdata(dev);
+	struct aic_sdio_dev *sdiodev =3D bus_if->bus_priv.sdio;
+	int ret =3D 0;
+
+	if (!sdiodev->func) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return 0;
+	}
+
+	if (sdiodev->chip_ops->use_func_msg) {
+		sdio_claim_host(sdiodev->func);
+
+		// since we have func2 we don't register irq handler
+		sdio_claim_irq(sdiodev->func, NULL);
+		sdio_claim_irq(sdiodev->func_msg, NULL);
+
+		sdiodev->func->irq_handler =3D
+			(sdio_irq_handler_t *)aicwf_sdio_hal_irqhandler;
+		sdiodev->func_msg->irq_handler =3D
+			(sdio_irq_handler_t *)aicwf_sdio_hal_irqhandler_func2;
+		sdio_release_host(sdiodev->func);
+
+		// enable sdio interrupt
+		ret =3D
+			aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.intr_config_reg, 0x07);
+
+		if (ret !=3D 0)
+			sdio_err("intr register failed:%d\n", ret);
+
+		// enable sdio interrupt
+		ret =3D aicwf_sdio_writeb_func2(sdiodev,
+					      sdiodev->sdio_reg.intr_config_reg, 0x07);
+
+		if (ret !=3D 0)
+			sdio_err("func2 intr register failed:%d\n", ret);
+	} else {
+		sdio_claim_host(sdiodev->func);
+		sdio_claim_irq(sdiodev->func, aicwf_sdio_hal_irqhandler);
+
+		if (sdiodev->chip_ops->need_func0_intr) {
+			sdio_f0_writeb(sdiodev->func, 0x07, 0x04, &ret);
+			if (ret)
+				sdio_err("set func0 int en fail %d\n", ret);
+		}
+		sdio_release_host(sdiodev->func);
+		// enable sdio interrupt
+		ret =3D
+			aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.intr_config_reg, 0x07);
+		if (ret !=3D 0)
+			sdio_err("intr register failed:%d\n", ret);
+	}
+
+	bus_if->state =3D BUS_UP_ST;
+	return ret;
+}
+
+int aicwf_sdio_bustx_thread(void *data)
+{
+	struct aicwf_bus *bus =3D (struct aicwf_bus *)data;
+	struct aic_sdio_dev *sdiodev =3D bus->bus_priv.sdio;
+
+	while (1) {
+		if (kthread_should_stop()) {
+			sdio_dbg("sdio bustx thread stop\n");
+			break;
+		}
+		if (!wait_for_completion_interruptible(&bus->bustx_trgg)) {
+			if ((int)(atomic_read(&sdiodev->tx_priv->tx_pktcnt) > 0) ||
+			    sdiodev->tx_priv->cmd_txstate)
+				aicwf_sdio_tx_process(sdiodev);
+		}
+	}
+
+	return 0;
+}
+
+int aicwf_sdio_busrx_thread(void *data)
+{
+	struct aicwf_rx_priv *rx_priv =3D (struct aicwf_rx_priv *)data;
+	struct aicwf_bus *bus_if =3D rx_priv->sdiodev->bus_if;
+
+	while (1) {
+		if (kthread_should_stop()) {
+			sdio_dbg("sdio busrx thread stop\n");
+			break;
+		}
+		if (!wait_for_completion_interruptible(&bus_if->busrx_trgg))
+			aicwf_process_rxframes(rx_priv);
+	}
+
+	return 0;
+}
+
+#if defined(CONFIG_SDIO_PWRCTRL)
+static void aicwf_sdio_bus_pwrctl(struct timer_list *t)
+{
+	//struct aic_sdio_dev *sdiodev =3D from_timer(sdiodev, t, timer);
+	struct aic_sdio_dev *sdiodev =3D timer_container_of(sdiodev, t, timer);
+
+	if (sdiodev->bus_if->state =3D=3D BUS_DOWN_ST) {
+		sdio_info("bus down\n");
+		return;
+	}
+
+	if (sdiodev->pwrctl_tsk)
+		complete(&sdiodev->pwrctrl_trgg);
+}
+#endif
+
+static void aicwf_sdio_enq_rxpkt(struct aic_sdio_dev *sdiodev,
+				 struct sk_buff *pkt)
+{
+	struct aicwf_rx_priv *rx_priv =3D sdiodev->rx_priv;
+	unsigned long flags =3D 0;
+
+	spin_lock_irqsave(&rx_priv->rxqlock, flags);
+	if (!aicwf_rxframe_enqueue(sdiodev->dev, &rx_priv->rxq, pkt)) {
+		spin_unlock_irqrestore(&rx_priv->rxqlock, flags);
+		aicwf_dev_skb_free(pkt);
+		return;
+	}
+	spin_unlock_irqrestore(&rx_priv->rxqlock, flags);
+
+	atomic_inc(&rx_priv->rx_cnt);
+}
+
+#define SDIO_OTHER_INTERRUPT (0x1ul << 7)
+
+void aicwf_sdio_hal_irqhandler(struct sdio_func *func)
+{
+	struct aicwf_bus *bus_if =3D NULL;
+	struct aic_sdio_dev *sdiodev =3D NULL;
+	u8 intstatus =3D 0;
+	u8 byte_len =3D 0;
+	struct sk_buff *pkt =3D NULL;
+	int ret;
+
+	if (!func) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return;
+	}
+	bus_if =3D dev_get_drvdata(&func->dev);
+	sdiodev =3D bus_if->bus_priv.sdio;
+
+	if (aicbsp_sdiodev->sdio_hal_irqhandler) {
+		aicbsp_sdiodev->sdio_hal_irqhandler(func);
+		return;
+	}
+
+	if (!bus_if || bus_if->state =3D=3D BUS_DOWN_ST) {
+		sdio_err("bus err\n");
+		return;
+	}
+
+	if (aicbsp_sdiodev->chip_ops->use_func2) {
+		ret =3D aicwf_sdio_readb(sdiodev, sdiodev->sdio_reg.block_cnt_reg,
+				       &intstatus);
+
+		while (intstatus) {
+			sdiodev->rx_priv->data_len =3D intstatus * SDIOWIFI_FUNC_BLOCKSIZE;
+			if (intstatus > 0) {
+				if (intstatus < 64) {
+					pkt =3D aicwf_sdio_readframes(sdiodev, 0);
+				} else {
+					// byte_len must<=3D 128
+					aicwf_sdio_intr_get_len_bytemode(sdiodev, &byte_len);
+					sdio_info("byte mode len=3D%d\r\n", byte_len);
+					pkt =3D aicwf_sdio_readframes(sdiodev, 0);
+				}
+			} else {
+				sdio_err("Interrupt but no data\n");
+			}
+
+			if (pkt)
+				aicwf_sdio_enq_rxpkt(sdiodev, pkt);
+
+			ret =3D aicwf_sdio_readb(sdiodev, sdiodev->sdio_reg.block_cnt_reg,
+					       &intstatus);
+		}
+	} else {
+		do {
+			ret =3D aicwf_sdio_readb(sdiodev,
+					       sdiodev->sdio_reg.misc_int_status_reg,
+					       &intstatus);
+			if (!ret)
+				break;
+			sdio_err("ret=3D%d, intstatus=3D%x\r\n", ret, intstatus);
+		} while (1);
+		if (intstatus & SDIO_OTHER_INTERRUPT) {
+			u8 int_pending;
+
+			ret =3D aicwf_sdio_readb(sdiodev, sdiodev->sdio_reg.sleep_reg,
+					       &int_pending);
+			if (ret < 0)
+				sdio_err("reg:%d read failed!\n", sdiodev->sdio_reg.sleep_reg);
+			int_pending &=3D ~0x01; // dev to host soft irq
+			ret =3D aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.sleep_reg,
+						int_pending);
+			if (ret < 0)
+				sdio_err("reg:%d write failed!\n", sdiodev->sdio_reg.sleep_reg);
+		}
+
+		if (intstatus > 0) {
+			u8 intmaskf2 =3D intstatus | (0x1UL << 3);
+
+			if (intmaskf2 > 120U) {      // func2
+				if (intmaskf2 =3D=3D 127U) { // byte mode
+					// byte_len must<=3D 128
+					aicwf_sdio_intr_get_len_bytemode(sdiodev, &byte_len);
+					sdio_info("byte mode len=3D%d\r\n", byte_len);
+					pkt =3D aicwf_sdio_readframes(sdiodev, 1);
+				} else { // block mode
+					sdiodev->rx_priv->data_len =3D
+						(intstatus & 0x7U) * SDIOWIFI_FUNC_BLOCKSIZE;
+					pkt =3D aicwf_sdio_readframes(sdiodev, 1);
+				}
+			} else {                     // func1
+				if (intstatus =3D=3D 120U) { // byte mode
+					// byte_len must<=3D 128
+					aicwf_sdio_intr_get_len_bytemode(sdiodev, &byte_len);
+					sdio_info("byte mode len=3D%d\r\n", byte_len);
+					pkt =3D aicwf_sdio_readframes(sdiodev, 0);
+				} else { // block mode
+					sdiodev->rx_priv->data_len =3D
+						(intstatus & 0x7FU) * SDIOWIFI_FUNC_BLOCKSIZE;
+					pkt =3D aicwf_sdio_readframes(sdiodev, 0);
+				}
+			}
+		} else {
+			sdio_err("Interrupt but no data\n");
+		}
+
+		if (pkt)
+			aicwf_sdio_enq_rxpkt(sdiodev, pkt);
+	}
+
+	complete(&bus_if->busrx_trgg);
+}
+
+void aicwf_sdio_hal_irqhandler_func2(struct sdio_func *func)
+{
+	struct aicwf_bus *bus_if =3D dev_get_drvdata(&func->dev);
+	struct aic_sdio_dev *sdiodev =3D bus_if->bus_priv.sdio;
+	u8 intstatus =3D 0;
+	u8 byte_len =3D 0;
+#ifdef CONFIG_PREALLOC_RX_SKB
+	struct rx_buff *pkt =3D NULL;
+#else
+	struct sk_buff *pkt =3D NULL;
+#endif
+	int ret;
+
+	if (!bus_if || bus_if->state =3D=3D BUS_DOWN_ST) {
+		sdio_err("bus err\n");
+		return;
+	}
+
+#ifdef CONFIG_PREALLOC_RX_SKB
+	if (list_empty(&aic_rx_buff_list.rxbuff_list)) {
+		pr_warn("aicbsp %s %d, rxbuff list is empty\n", __func__, __LINE__);
+		return;
+	}
+#endif
+
+	ret =3D aicwf_sdio_readb_func2(sdiodev, sdiodev->sdio_reg.block_cnt_reg,
+				     &intstatus);
+	if (ret) {
+		sdio_err("failed to read interrupt status: %d\n", ret);
+		return;
+	}
+
+	while (intstatus) {
+		sdiodev->rx_priv->data_len =3D intstatus * SDIOWIFI_FUNC_BLOCKSIZE;
+		if (intstatus > 0) {
+			if (intstatus < 64) {
+				pkt =3D aicwf_sdio_readframes(sdiodev, 1);
+			} else {
+				sdio_info("byte mode len=3D%d\r\n", byte_len);
+				// byte_len must<=3D 128
+				aicwf_sdio_intr_get_len_bytemode(sdiodev, &byte_len);
+				pkt =3D aicwf_sdio_readframes(sdiodev, 1);
+			}
+		} else {
+			sdio_err("Interrupt but no data\n");
+		}
+
+		if (pkt)
+			aicwf_sdio_enq_rxpkt(sdiodev, pkt);
+
+		ret =3D aicwf_sdio_readb_func2(sdiodev, sdiodev->sdio_reg.block_cnt_reg,
+					     &intstatus);
+		if (ret) {
+			sdio_err("failed to read interrupt status: %d\n", ret);
+			break;
+		}
+	}
+
+	complete(&bus_if->busrx_trgg);
+}
+
+#if defined(CONFIG_SDIO_PWRCTRL)
+void aicwf_sdio_pwrctl_timer(struct aic_sdio_dev *sdiodev, uint duration)
+{
+	uint timeout;
+
+	if (sdiodev->bus_if->state =3D=3D BUS_DOWN_ST && duration)
+		return;
+
+	spin_lock_bh(&sdiodev->pwrctl_lock);
+	if (!duration) {
+		if (timer_pending(&sdiodev->timer))
+			//del_timer_sync(&sdiodev->timer);
+			timer_delete_sync(&sdiodev->timer);
+	} else {
+		sdiodev->active_duration =3D duration;
+		timeout =3D msecs_to_jiffies(sdiodev->active_duration);
+		mod_timer(&sdiodev->timer, jiffies + timeout);
+	}
+	spin_unlock_bh(&sdiodev->pwrctl_lock);
+}
+#endif
+
+/* Forward declarations for new bus_ops callbacks */
+static int aicwf_bsp_bus_read_reg(struct device *dev, u32 regaddr, u8 *val=
);
+static int aicwf_bsp_bus_write_reg(struct device *dev, u32 regaddr, u8 val=
);
+static int aicwf_bsp_bus_send_pkt(struct device *dev, u8 *buf, uint count)=
;
+static int aicwf_bsp_bus_recv_pkt(struct device *dev, u8 *buf, u32 size);
+static int aicwf_bsp_bus_enable_irq(struct device *dev);
+static void aicwf_bsp_bus_disable_irq(struct device *dev);
+static bool aicwf_bsp_bus_flow_ctrl(struct device *dev);
+static int aicwf_bsp_bus_sleep_allow(struct device *dev);
+static int aicwf_bsp_bus_wakeup(struct device *dev);
+static const void *aicwf_bsp_bus_get_hw_props(struct device *dev);
+
+static struct aicwf_bus_ops aicwf_sdio_bus_ops =3D {
+	.start          =3D aicwf_sdio_bus_start,
+	.stop           =3D aicwf_sdio_bus_stop,
+	.txdata         =3D aicwf_sdio_bus_txdata,
+	.txmsg          =3D aicwf_sdio_bus_txmsg,
+	.read_reg       =3D aicwf_bsp_bus_read_reg,
+	.write_reg      =3D aicwf_bsp_bus_write_reg,
+	.send_pkt       =3D aicwf_bsp_bus_send_pkt,
+	.recv_pkt       =3D aicwf_bsp_bus_recv_pkt,
+	.enable_irq     =3D aicwf_bsp_bus_enable_irq,
+	.disable_irq    =3D aicwf_bsp_bus_disable_irq,
+	.flow_ctrl      =3D aicwf_bsp_bus_flow_ctrl,
+	.sleep_allow    =3D aicwf_bsp_bus_sleep_allow,
+	.wakeup         =3D aicwf_bsp_bus_wakeup,
+	.get_hw_props   =3D aicwf_bsp_bus_get_hw_props,
+};
+
+void aicwf_sdio_release_func2(struct aic_sdio_dev *sdiodev)
+{
+	int ret =3D 0;
+
+	if (!sdiodev->func_msg) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return;
+	}
+	sdio_claim_host(sdiodev->func_msg);
+	// disable sdio interrupt
+	ret =3D aicwf_sdio_writeb_func2(sdiodev, sdiodev->sdio_reg.intr_config_re=
g,
+				      0x0);
+	if (ret < 0)
+		sdio_err("reg:%d write failed!\n", sdiodev->sdio_reg.intr_config_reg);
+
+	sdio_release_irq(sdiodev->func_msg);
+	sdio_release_host(sdiodev->func_msg);
+}
+
+void aicwf_sdio_release(struct aic_sdio_dev *sdiodev)
+{
+	struct aicwf_bus *bus_if =3D NULL;
+
+	if (bsp_init =3D=3D 0) {
+		pr_err("aicbsp already sdio_release\n");
+		return;
+	}
+
+	bsp_init =3D 0;
+
+	if (!sdiodev->func) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return;
+	}
+
+	bus_if =3D aicbsp_get_drvdata(sdiodev->dev);
+	if (bus_if)
+		bus_if->state =3D BUS_DOWN_ST;
+
+	if (aicbsp_sdiodev->chip_ops->use_func_msg)
+		aicwf_sdio_release_func2(sdiodev);
+
+	if (sdiodev->dev)
+		aicwf_bus_deinit(sdiodev->dev);
+
+	if (sdiodev->tx_priv)
+		aicwf_tx_deinit(sdiodev->tx_priv);
+
+	if (sdiodev->rx_priv)
+		aicwf_rx_deinit(sdiodev->rx_priv);
+
+	if (sdiodev->cmd_mgr.state =3D=3D RWNX_CMD_MGR_STATE_INITED)
+		rwnx_cmd_mgr_deinit(&sdiodev->cmd_mgr);
+}
+
+void aicwf_sdio_reg_init(struct aic_sdio_dev *sdiodev)
+{
+	if (aicbsp_sdiodev->chip_ops->use_func2) {
+		sdiodev->sdio_reg.bytemode_len_reg =3D SDIOWIFI_BYTEMODE_LEN_REG;
+		sdiodev->sdio_reg.intr_config_reg =3D SDIOWIFI_INTR_CONFIG_REG;
+		sdiodev->sdio_reg.sleep_reg =3D SDIOWIFI_SLEEP_REG;
+		sdiodev->sdio_reg.wakeup_reg =3D SDIOWIFI_WAKEUP_REG;
+		sdiodev->sdio_reg.flow_ctrl_reg =3D SDIOWIFI_FLOW_CTRL_REG;
+		sdiodev->sdio_reg.register_block =3D SDIOWIFI_REGISTER_BLOCK;
+		sdiodev->sdio_reg.bytemode_enable_reg =3D SDIOWIFI_BYTEMODE_ENABLE_REG;
+		sdiodev->sdio_reg.block_cnt_reg =3D SDIOWIFI_BLOCK_CNT_REG;
+		sdiodev->sdio_reg.rd_fifo_addr =3D SDIOWIFI_RD_FIFO_ADDR;
+		sdiodev->sdio_reg.wr_fifo_addr =3D SDIOWIFI_WR_FIFO_ADDR;
+	} else {
+		sdiodev->sdio_reg.bytemode_len_reg =3D SDIOWIFI_BYTEMODE_LEN_REG_V3;
+		sdiodev->sdio_reg.intr_config_reg =3D SDIOWIFI_INTR_ENABLE_REG_V3;
+		sdiodev->sdio_reg.sleep_reg =3D SDIOWIFI_INTR_PENDING_REG_V3;
+		sdiodev->sdio_reg.wakeup_reg =3D SDIOWIFI_INTR_TO_DEVICE_REG_V3;
+		sdiodev->sdio_reg.flow_ctrl_reg =3D SDIOWIFI_FLOW_CTRL_Q1_REG_V3;
+		sdiodev->sdio_reg.bytemode_enable_reg =3D SDIOWIFI_BYTEMODE_ENABLE_REG_V=
3;
+		sdiodev->sdio_reg.misc_int_status_reg =3D SDIOWIFI_MISC_INT_STATUS_REG_V=
3;
+		sdiodev->sdio_reg.rd_fifo_addr =3D SDIOWIFI_RD_FIFO_ADDR_V3;
+		sdiodev->sdio_reg.wr_fifo_addr =3D SDIOWIFI_WR_FIFO_ADDR_V3;
+	}
+}
+
+int aicwf_sdio_func_init(struct aic_sdio_dev *sdiodev)
+{
+	struct mmc_host *host;
+	u8 block_bit0 =3D 0x1;
+	u8 byte_mode_disable =3D 0x1; // 1: no byte mode
+	int ret =3D 0;
+	struct aicbsp_feature_t feature;
+
+	aicbsp_get_feature(&feature);
+	aicwf_sdio_reg_init(sdiodev);
+
+	if (!sdiodev->func) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return 0;
+	}
+
+	host =3D sdiodev->func->card->host;
+
+	sdio_claim_host(sdiodev->func);
+
+	ret =3D sdio_set_block_size(sdiodev->func, SDIOWIFI_FUNC_BLOCKSIZE);
+	if (ret < 0) {
+		sdio_err("set blocksize fail %d\n", ret);
+		sdio_release_host(sdiodev->func);
+		return ret;
+	}
+	ret =3D sdio_enable_func(sdiodev->func);
+	if (ret < 0) {
+		sdio_err("enable func fail %d.\n", ret);
+		sdio_release_host(sdiodev->func);
+		return ret;
+	}
+	usleep_range(20, 40);
+	// SDIO CLOCK SETTING
+	if (feature.sdio_clock > 0) {
+		host->ios.clock =3D feature.sdio_clock;
+		host->ops->set_ios(host, &host->ios);
+		sdio_dbg("Set SDIO Clock %d MHz\n", host->ios.clock / 1000000);
+	}
+	sdio_release_host(sdiodev->func);
+
+	if (aicbsp_sdiodev->chip_ops->use_func_msg) {
+		sdio_claim_host(sdiodev->func_msg);
+
+		// set sdio blocksize
+		ret =3D sdio_set_block_size(sdiodev->func_msg, SDIOWIFI_FUNC_BLOCKSIZE);
+		if (ret < 0) {
+			AICWFDBG(LOGERROR, "set func2 blocksize fail %d\n", ret);
+			sdio_release_host(sdiodev->func_msg);
+			return ret;
+		}
+
+		// set sdio enable func
+		ret =3D sdio_enable_func(sdiodev->func_msg);
+		if (ret < 0)
+			AICWFDBG(LOGERROR, "enable func2 fail %d.\n", ret);
+
+		sdio_release_host(sdiodev->func_msg);
+
+		ret =3D aicwf_sdio_writeb_func2(sdiodev, sdiodev->sdio_reg.register_bloc=
k,
+					      block_bit0);
+		if (ret < 0) {
+			AICWFDBG(LOGERROR, "reg:%d write failed!\n",
+				 sdiodev->sdio_reg.register_block);
+			return ret;
+		}
+
+		// 1: no byte mode
+		ret =3D aicwf_sdio_writeb_func2(sdiodev,
+					      sdiodev->sdio_reg.bytemode_enable_reg,
+					      byte_mode_disable);
+		if (ret < 0) {
+			AICWFDBG(LOGERROR, "reg:%d write failed!\n",
+				 sdiodev->sdio_reg.bytemode_enable_reg);
+			return ret;
+		}
+	}
+
+	ret =3D aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.register_block,
+				block_bit0);
+	if (ret < 0) {
+		sdio_err("reg:%d write failed!\n", sdiodev->sdio_reg.register_block);
+		return ret;
+	}
+
+	// 1: no byte mode
+	ret =3D aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.bytemode_enable_reg,
+				byte_mode_disable);
+	if (ret < 0) {
+		sdio_err("reg:%d write failed!\n",
+			 sdiodev->sdio_reg.bytemode_enable_reg);
+		return ret;
+	}
+
+	return ret;
+}
+
+int aicwf_sdiov3_func_init(struct aic_sdio_dev *sdiodev)
+{
+	struct mmc_host *host;
+	u8 byte_mode_disable =3D 0x1; // 1: no byte mode
+	int ret =3D 0;
+	struct aicbsp_feature_t feature;
+	int val;
+
+	aicbsp_get_feature(&feature);
+	aicwf_sdio_reg_init(sdiodev);
+
+	if (!sdiodev->func) {
+		pr_warn("aicbsp %s, NULL sdio func\n", __func__);
+		return 0;
+	}
+
+	host =3D sdiodev->func->card->host;
+
+	sdio_claim_host(sdiodev->func);
+	sdiodev->func->card->quirks |=3D MMC_QUIRK_LENIENT_FN0;
+
+	ret =3D sdio_set_block_size(sdiodev->func, SDIOWIFI_FUNC_BLOCKSIZE);
+	if (ret < 0) {
+		sdio_err("set blocksize fail %d\n", ret);
+		sdio_release_host(sdiodev->func);
+		return ret;
+	}
+	ret =3D sdio_enable_func(sdiodev->func);
+	if (ret < 0) {
+		sdio_err("enable func fail %d.\n", ret);
+		sdio_release_host(sdiodev->func);
+		return ret;
+	}
+
+	sdio_f0_writeb(sdiodev->func, 0x7F, 0xF2, &ret);
+	if (ret) {
+		sdio_err("set fn0 0xF2 fail %d\n", ret);
+		sdio_release_host(sdiodev->func);
+		return ret;
+	}
+	// mod sdio phase
+	if (host->ios.timing =3D=3D MMC_TIMING_UHS_DDR50)
+		val =3D 0x20; // 0x21; //0x1D; //0x5;
+	else
+		val =3D 0x00; // 0x01; //0x19; //0x1;
+	val |=3D SDIOCLK_FREE_RUNNING_BIT;
+	sdio_f0_writeb(sdiodev->func, val, 0xF0, &ret);
+	if (ret) {
+		sdio_err("set iopad ctrl fail %d\n", ret);
+		sdio_release_host(sdiodev->func);
+		return ret;
+	}
+	sdio_f0_writeb(sdiodev->func, 0x00, 0xF8, &ret);
+	if (ret) {
+		sdio_err("set iopad delay2 fail %d\n", ret);
+		sdio_release_host(sdiodev->func);
+		return ret;
+	}
+	sdio_f0_writeb(sdiodev->func, 0x00, 0xF1, &ret);
+	if (ret) {
+		sdio_err("set iopad delay1 fail %d\n", ret);
+		sdio_release_host(sdiodev->func);
+		return ret;
+	}
+	usleep_range(1000, 2000);
+	sdio_dbg("Set SDIO Clock %d MHz\n", host->ios.clock / 1000000);
+	sdio_release_host(sdiodev->func);
+
+	// 1: no byte mode
+	ret =3D aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.bytemode_enable_reg,
+				byte_mode_disable);
+	if (ret < 0) {
+		sdio_err("reg:%d write failed!\n",
+			 sdiodev->sdio_reg.bytemode_enable_reg);
+		return ret;
+	}
+
+	return ret;
+}
+
+void aicwf_sdio_func_deinit(struct aic_sdio_dev *sdiodev)
+{
+	struct aicwf_bus *bus_if =3D NULL;
+
+	if (bsp_func_init =3D=3D 0) {
+		pr_err("aicbsp already func_deinit\n");
+		return;
+	}
+
+	bsp_func_init =3D 0;
+
+	if (!sdiodev->func) {
+		sdio_info("%s, NULL sdio func\n", __func__);
+		return;
+	}
+
+	bus_if =3D dev_get_drvdata(sdiodev->dev);
+	if (!bus_if) {
+		sdio_info("%s, bus_if is null\n", __func__);
+		return;
+	}
+
+	if (sdiodev->bus_if =3D=3D bus_if) {
+		sdio_dbg("%s bsp disable\n", __func__);
+		sdio_claim_host(sdiodev->func);
+		sdio_disable_func(sdiodev->func);
+		sdio_release_host(sdiodev->func);
+	}
+
+	if (aicbsp_sdiodev->chip_ops->use_func_msg) {
+		sdio_claim_host(sdiodev->func_msg);
+		sdio_disable_func(sdiodev->func_msg);
+		sdio_release_host(sdiodev->func_msg);
+	}
+}
+
+void *aicwf_sdio_bus_init(struct aic_sdio_dev *sdiodev)
+{
+	int ret;
+	struct aicwf_bus *bus_if;
+	struct aicwf_rx_priv *rx_priv;
+	struct aicwf_tx_priv *tx_priv;
+
+#if defined(CONFIG_SDIO_PWRCTRL)
+	spin_lock_init(&sdiodev->pwrctl_lock);
+	sema_init(&sdiodev->pwrctl_wakeup_sema, 1);
+#endif
+
+	bus_if =3D sdiodev->bus_if;
+	bus_if->dev =3D sdiodev->dev;
+	bus_if->ops =3D &aicwf_sdio_bus_ops;
+	bus_if->state =3D BUS_DOWN_ST;
+#if defined(CONFIG_SDIO_PWRCTRL)
+	sdiodev->state =3D SDIO_SLEEP_ST;
+	sdiodev->active_duration =3D SDIOWIFI_PWR_CTRL_INTERVAL;
+#else
+	sdiodev->state =3D SDIO_ACTIVE_ST;
+#endif
+
+	rx_priv =3D aicwf_rx_init(sdiodev);
+	if (!rx_priv) {
+		sdio_err("rx init fail\n");
+		goto fail;
+	}
+	sdiodev->rx_priv =3D rx_priv;
+
+	tx_priv =3D aicwf_tx_init(sdiodev);
+	if (!tx_priv) {
+		sdio_err("tx init fail\n");
+		goto fail;
+	}
+	sdiodev->tx_priv =3D tx_priv;
+	aicwf_frame_queue_init(&tx_priv->txq, 8, TXQLEN);
+	spin_lock_init(&tx_priv->txqlock);
+	sema_init(&tx_priv->txctl_sema, 1);
+	sema_init(&tx_priv->cmd_txsema, 1);
+	init_waitqueue_head(&tx_priv->cmd_txdone_wait);
+	atomic_set(&tx_priv->tx_pktcnt, 0);
+
+#if defined(CONFIG_SDIO_PWRCTRL)
+	timer_setup(&sdiodev->timer, aicwf_sdio_bus_pwrctl, 0);
+	init_completion(&sdiodev->pwrctrl_trgg);
+#endif
+	ret =3D aicwf_bus_init(0, sdiodev->dev);
+	if (ret < 0) {
+		sdio_err("bus init fail\n");
+		goto fail;
+	}
+
+	ret =3D aicwf_bus_start(bus_if);
+	if (ret !=3D 0) {
+		sdio_err("bus start fail\n");
+		goto fail;
+	}
+
+	return sdiodev;
+
+fail:
+	aicwf_sdio_release(sdiodev);
+	return NULL;
+}
+
+/**
+ * get_testmode - Get the firmware test mode selected by the BSP
+ *
+ * Return: Current firmware test mode.
+ */
+int get_testmode(void)
+{
+	return testmode;
+}
+EXPORT_SYMBOL_GPL(get_testmode);
+
+/**
+ * get_sdio_func - Get the active AIC SDIO function
+ *
+ * Return: Pointer to the active SDIO function.
+ */
+struct sdio_func *get_sdio_func(void)
+{
+	return aicbsp_sdiodev->func;
+}
+EXPORT_SYMBOL_GPL(get_sdio_func);
+
+/**
+ * set_irq_handler - Set the WLAN driver's SDIO interrupt callback
+ * @fn: Callback invoked for an SDIO interrupt
+ */
+void set_irq_handler(void *fn)
+{
+	aicbsp_sdiodev->sdio_hal_irqhandler =3D (sdio_irq_handler_t *)fn;
+}
+EXPORT_SYMBOL_GPL(set_irq_handler);
+
+u8 crc8_ponl_107(u8 *p_buffer, u16 cal_size)
+{
+	u8 i;
+	u8 crc =3D 0;
+
+	if (cal_size =3D=3D 0)
+		return crc;
+	while (cal_size--) {
+		for (i =3D 0x80; i > 0; i /=3D 2) {
+			if (crc & 0x80) {
+				crc *=3D 2;
+				crc ^=3D 0x07; // polynomial X8 + X2 + X + 1,(0x107)
+			} else {
+				crc *=3D 2;
+			}
+			if ((*p_buffer) & i)
+				crc ^=3D 0x07;
+		}
+		p_buffer++;
+	}
+	return crc;
+}
+
+/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ *  Bus abstraction layer =E2=80=93 BSP SDIO bus_ops callbacks
+ * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ */
+
+static inline struct aic_sdio_dev *aicwf_bsp_bus_to_sdiodev(struct device =
*dev)
+{
+	struct aicwf_bus *bus_if =3D dev_get_drvdata(dev);
+
+	return bus_if->bus_priv.sdio;
+}
+
+static int aicwf_bsp_bus_read_reg(struct device *dev, u32 regaddr, u8 *val=
)
+{
+	return aicwf_sdio_readb(aicwf_bsp_bus_to_sdiodev(dev), regaddr, val);
+}
+
+static int aicwf_bsp_bus_write_reg(struct device *dev, u32 regaddr, u8 val=
)
+{
+	return aicwf_sdio_writeb(aicwf_bsp_bus_to_sdiodev(dev), regaddr, val);
+}
+
+static int aicwf_bsp_bus_send_pkt(struct device *dev, u8 *buf, uint count)
+{
+	return aicwf_sdio_send_pkt(aicwf_bsp_bus_to_sdiodev(dev), buf, count);
+}
+
+static int aicwf_bsp_bus_recv_pkt(struct device *dev, u8 *buf, u32 size)
+{
+	struct aic_sdio_dev *sdiodev =3D aicwf_bsp_bus_to_sdiodev(dev);
+	int ret;
+
+	sdio_claim_host(sdiodev->func);
+	ret =3D sdio_readsb(sdiodev->func, buf,
+			  sdiodev->sdio_reg.rd_fifo_addr, size);
+	sdio_release_host(sdiodev->func);
+
+	return ret;
+}
+
+static int aicwf_bsp_bus_enable_irq(struct device *dev)
+{
+	struct aic_sdio_dev *sdiodev =3D aicwf_bsp_bus_to_sdiodev(dev);
+	int ret;
+
+	sdio_claim_host(sdiodev->func);
+	sdio_claim_irq(sdiodev->func, sdiodev->sdio_hal_irqhandler);
+	sdio_release_host(sdiodev->func);
+
+	ret =3D aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.intr_config_reg, 0x0=
7);
+	if (ret)
+		sdio_err("intr register failed:%d\n", ret);
+
+	return ret;
+}
+
+static void aicwf_bsp_bus_disable_irq(struct device *dev)
+{
+	struct aic_sdio_dev *sdiodev =3D aicwf_bsp_bus_to_sdiodev(dev);
+
+	sdio_claim_host(sdiodev->func);
+	aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.intr_config_reg, 0x0);
+	sdio_release_irq(sdiodev->func);
+	sdio_release_host(sdiodev->func);
+}
+
+static bool aicwf_bsp_bus_flow_ctrl(struct device *dev)
+{
+	int ret;
+
+	ret =3D aicwf_sdio_flow_ctrl(aicwf_bsp_bus_to_sdiodev(dev));
+	return (ret > 0);
+}
+
+#if defined(CONFIG_SDIO_PWRCTRL)
+static int aicwf_bsp_bus_sleep_allow(struct device *dev)
+{
+	return aicwf_sdio_sleep_allow(aicwf_bsp_bus_to_sdiodev(dev));
+}
+
+static int aicwf_bsp_bus_wakeup(struct device *dev)
+{
+	return aicwf_sdio_wakeup(aicwf_bsp_bus_to_sdiodev(dev));
+}
+#else
+static int aicwf_bsp_bus_sleep_allow(struct device *dev)
+{
+	return 0;
+}
+
+static int aicwf_bsp_bus_wakeup(struct device *dev)
+{
+	return 0;
+}
+#endif /* CONFIG_SDIO_PWRCTRL */
+
+static const void *aicwf_bsp_bus_get_hw_props(struct device *dev)
+{
+	return NULL; /* BSP layer does not expose chip HW props via bus_ops */
+}
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aicsdio.h b/drivers/net/w=
ireless/aic/aic8800_bsp/aicsdio.h
new file mode 100644
index 0000000000000..14915b1447b2a
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aicsdio.h
@@ -0,0 +1,176 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * aicwf_sdio.h
+ *
+ * SDIO function declarations
+ *
+ * Copyright (C) AICSemi 2018-2020
+ */
+
+#ifndef _AICWF_SDMMC_H_
+#define _AICWF_SDMMC_H_
+
+#ifdef AICWF_SDIO_SUPPORT
+#include "aic_bsp_driver.h"
+#include <linux/ieee80211.h>
+#include <linux/if_ether.h>
+#include <linux/semaphore.h>
+#include <linux/skbuff.h>
+
+#define AICBSP_SDIO_NAME        "aicbsp_sdio"
+#define SDIOWIFI_FUNC_BLOCKSIZE 512
+
+#define SDIO_VENDOR_ID_AIC           0x8800
+#define SDIO_DEVICE_ID_AIC           0x0001
+#define SDIOWIFI_BYTEMODE_LEN_REG    0x02
+#define SDIOWIFI_INTR_CONFIG_REG     0x04
+#define SDIOWIFI_SLEEP_REG           0x05
+#define SDIOWIFI_WAKEUP_REG          0x09
+#define SDIOWIFI_FLOW_CTRL_REG       0x0A
+#define SDIOWIFI_REGISTER_BLOCK      0x0B
+#define SDIOWIFI_BYTEMODE_ENABLE_REG 0x11
+#define SDIOWIFI_BLOCK_CNT_REG       0x12
+#define SDIOWIFI_FLOWCTRL_MASK_REG   0x7F
+#define SDIOWIFI_WR_FIFO_ADDR        0x07
+#define SDIOWIFI_RD_FIFO_ADDR        0x08
+
+#define SDIOWIFI_INTR_ENABLE_REG_V3      0x00
+#define SDIOWIFI_INTR_PENDING_REG_V3     0x01
+#define SDIOWIFI_INTR_TO_DEVICE_REG_V3   0x02
+#define SDIOWIFI_FLOW_CTRL_Q1_REG_V3     0x03
+#define SDIOWIFI_MISC_INT_STATUS_REG_V3  0x04
+#define SDIOWIFI_BYTEMODE_LEN_REG_V3     0x05
+#define SDIOWIFI_BYTEMODE_LEN_MSB_REG_V3 0x06
+#define SDIOWIFI_BYTEMODE_ENABLE_REG_V3  0x07
+#define SDIOWIFI_MISC_CTRL_REG_V3        0x08
+#define SDIOWIFI_FLOW_CTRL_Q2_REG_V3     0x09
+#define SDIOWIFI_CLK_TEST_RESULT_REG_V3  0x0A
+#define SDIOWIFI_RD_FIFO_ADDR_V3         0x0F
+#define SDIOWIFI_WR_FIFO_ADDR_V3         0x10
+
+#define SDIOCLK_FREE_RUNNING_BIT BIT(6)
+
+#define SDIOWIFI_PWR_CTRL_INTERVAL 30
+#define FLOW_CTRL_RETRY_COUNT      50
+#define BUFFER_SIZE                1536
+#define TAIL_LEN                   4
+#define TXQLEN                     (2048 * 4)
+
+#define SDIO_SLEEP_ST  0
+#define SDIO_ACTIVE_ST 1
+
+/* SDIO Device ID */
+#define SDIO_VENDOR_ID_AIC8801    0x5449
+#define SDIO_VENDOR_ID_AIC8800DC  0xc8a1
+#define SDIO_VENDOR_ID_AIC8800D80 0xc8a1
+
+#define SDIO_DEVICE_ID_AIC8801    0x0145
+#define SDIO_DEVICE_ID_AIC8800DC  0xc08d
+#define SDIO_DEVICE_ID_AIC8800D80 0x0082
+#define SDIO_DEVICE_ID_AIC8801_FUNC2    0x0146
+#define SDIO_DEVICE_ID_AIC8800D80_FUNC2 0x0182
+
+enum sdio_type {
+	SDIO_TYPE_DATA =3D 0X00,
+	SDIO_TYPE_CFG =3D 0X10,
+	SDIO_TYPE_CFG_CMD_RSP =3D 0X11,
+	SDIO_TYPE_CFG_DATA_CFM =3D 0X12
+};
+
+enum AICWF_IC {
+	PRODUCT_ID_AIC8801 =3D 0,
+	PRODUCT_ID_AIC8800DC,
+	PRODUCT_ID_AIC8800DW,
+	PRODUCT_ID_AIC8800D80
+};
+
+struct aic_sdio_reg {
+	u8 bytemode_len_reg;
+	u8 intr_config_reg;
+	u8 sleep_reg;
+	u8 wakeup_reg;
+	u8 flow_ctrl_reg;
+	u8 flowctrl_mask_reg;
+	u8 register_block;
+	u8 bytemode_enable_reg;
+	u8 block_cnt_reg;
+	u8 misc_int_status_reg;
+	u8 rd_fifo_addr;
+	u8 wr_fifo_addr;
+};
+
+struct aic_sdio_dev {
+	struct rwnx_cmd_mgr cmd_mgr;
+	struct sdio_func *func;
+	struct sdio_func *func_msg;
+	struct device *dev;
+	struct aicwf_bus *bus_if;
+
+	struct aicwf_rx_priv *rx_priv;
+	struct aicwf_tx_priv *tx_priv;
+	u32 state;
+
+#if defined(CONFIG_SDIO_PWRCTRL)
+	// for sdio pwr ctrl
+	struct timer_list timer;
+	uint active_duration;
+	struct completion pwrctrl_trgg;
+	struct task_struct *pwrctl_tsk;
+	/* lock for pwrctl */
+	spinlock_t pwrctl_lock;
+	struct semaphore pwrctl_wakeup_sema;
+#endif
+	u16 chipid;
+	const struct aic_chip_ops *chip_ops;
+	u32 fw_version_uint;
+	struct aic_sdio_reg sdio_reg;
+	void (*sdio_hal_irqhandler)(struct sdio_func *func);
+};
+
+int aicwf_sdio_readb(struct aic_sdio_dev *sdiodev, uint regaddr, u8 *val);
+int aicwf_sdio_readb_func2(struct aic_sdio_dev *sdiodev, uint regaddr, u8 =
*val);
+int aicwf_sdio_writeb_func2(struct aic_sdio_dev *sdiodev, uint regaddr, u8=
 val);
+int aicwf_sdio_send_msg(struct aic_sdio_dev *sdiodev, u8 *buf, uint count)=
;
+struct sk_buff *aicwf_sdio_readframes(struct aic_sdio_dev *sdiodev, u8 msg=
);
+void aicwf_sdio_release_func2(struct aic_sdio_dev *sdiodev);
+int get_testmode(void);
+struct sdio_func *get_sdio_func(void);
+void set_irq_handler(void *fn);
+
+void *aicbsp_get_drvdata(void *args);
+int aicwf_sdio_writeb(struct aic_sdio_dev *sdiodev, uint regaddr, u8 val);
+void aicwf_sdio_hal_irqhandler(struct sdio_func *func);
+void aicwf_sdio_hal_irqhandler_func2(struct sdio_func *func);
+#if defined(CONFIG_SDIO_PWRCTRL)
+int aicwf_sdio_wakeup(struct aic_sdio_dev *sdiodev);
+int aicwf_sdio_sleep_allow(struct aic_sdio_dev *sdiodev);
+
+void aicwf_sdio_pwrctl_timer(struct aic_sdio_dev *sdiodev, uint duration);
+int aicwf_sdio_pwr_stctl(struct aic_sdio_dev *sdiodev, uint target);
+#endif
+void aicwf_sdio_reg_init(struct aic_sdio_dev *sdiodev);
+int aicwf_sdio_func_init(struct aic_sdio_dev *sdiodev);
+int aicwf_sdiov3_func_init(struct aic_sdio_dev *sdiodev);
+void aicwf_sdio_func_deinit(struct aic_sdio_dev *sdiodev);
+int aicwf_sdio_flow_ctrl(struct aic_sdio_dev *sdiodev);
+int aicwf_sdio_recv_pkt(struct aic_sdio_dev *sdiodev, struct sk_buff *skbb=
uf,
+			u32 size, u8 msg);
+int aicwf_sdio_send_pkt(struct aic_sdio_dev *sdiodev, u8 *buf, uint count)=
;
+void *aicwf_sdio_bus_init(struct aic_sdio_dev *sdiodev);
+void aicwf_sdio_release(struct aic_sdio_dev *sdiodev);
+void aicbsp_sdio_exit(void);
+int aicbsp_sdio_init(void);
+void aicbsp_sdio_release(struct aic_sdio_dev *sdiodev);
+int aicwf_sdio_txpkt(struct aic_sdio_dev *sdiodev, struct sk_buff *pkt);
+int aicwf_sdio_bustx_thread(void *data);
+int aicwf_sdio_busrx_thread(void *data);
+int aicwf_sdio_aggr(struct aicwf_tx_priv *tx_priv, struct sk_buff *pkt);
+int aicwf_sdio_send(struct aicwf_tx_priv *tx_priv);
+void aicwf_sdio_aggr_send(struct aicwf_tx_priv *tx_priv);
+void aicwf_sdio_aggrbuf_reset(struct aicwf_tx_priv *tx_priv);
+void aicwf_hostif_ready(void);
+int aicwf_process_rxframes(struct aicwf_rx_priv *rx_priv);
+u8 crc8_ponl_107(u8 *p_buffer, u16 cal_size);
+#endif /* AICWF_SDIO_SUPPORT */
+
+#endif /*_AICWF_SDMMC_H_*/
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aicsdio_txrxif.c b/driver=
s/net/wireless/aic/aic8800_bsp/aicsdio_txrxif.c
new file mode 100644
index 0000000000000..92911a6f83841
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aicsdio_txrxif.c
@@ -0,0 +1,465 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief bsp tx/rx interface
+ *
+ *************************************************************************=
*****
+ */
+
+#include "aicsdio_txrxif.h"
+#include "aic_bsp_driver.h"
+#include <linux/atomic.h>
+#include <linux/completion.h>
+#include <linux/debugfs.h>
+#include <linux/interrupt.h>
+#include <linux/kthread.h>
+#include <linux/netdevice.h>
+#include <linux/printk.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/vmalloc.h>
+
+int aicwf_bus_init(uint bus_hdrlen, struct device *dev)
+{
+	int ret =3D 0;
+	struct aicwf_bus *bus_if;
+
+	if (!dev) {
+		txrx_err("device not found\n");
+		return -1;
+	}
+	bus_if =3D dev_get_drvdata(dev);
+	bus_if->cmd_buf =3D kzalloc(CMD_BUF_MAX, GFP_KERNEL);
+	if (!bus_if->cmd_buf) {
+		ret =3D -ENOMEM;
+		txrx_err("proto_attach failed\n");
+		goto out;
+	}
+	memset(bus_if->cmd_buf, '\0', CMD_BUF_MAX);
+
+	init_completion(&bus_if->bustx_trgg);
+	init_completion(&bus_if->busrx_trgg);
+#ifdef AICWF_SDIO_SUPPORT
+	bus_if->bustx_thread =3D kthread_run(aicwf_sdio_bustx_thread, (void *)bus=
_if,
+					   "aicwf_bustx_thread");
+	bus_if->busrx_thread =3D kthread_run(aicwf_sdio_busrx_thread,
+					   (void *)bus_if->bus_priv.sdio->rx_priv,
+									   "aicwf_busrx_thread");
+#endif
+
+	if (IS_ERR(bus_if->bustx_thread)) {
+		bus_if->bustx_thread =3D NULL;
+		txrx_err("aicwf_bustx_thread run fail\n");
+		ret =3D -1;
+	}
+
+	if (IS_ERR(bus_if->busrx_thread)) {
+		bus_if->busrx_thread =3D NULL;
+		txrx_err("aicwf_bustx_thread run fail\n");
+		ret =3D -1;
+	}
+
+	if (ret < 0)
+		goto out;
+
+	return ret;
+
+out:
+	return ret;
+}
+
+void aicwf_bus_deinit(struct device *dev)
+{
+	struct aicwf_bus *bus_if;
+
+	if (!dev) {
+		txrx_err("device not found\n");
+		return;
+	}
+	bus_if =3D aicbsp_get_drvdata(dev);
+	aicwf_bus_stop(bus_if);
+
+	kfree(bus_if->cmd_buf);
+	if (bus_if->cmd_buf)
+		bus_if->cmd_buf =3D NULL;
+
+	if (bus_if->bustx_thread) {
+		complete_all(&bus_if->bustx_trgg);
+		kthread_stop(bus_if->bustx_thread);
+		bus_if->bustx_thread =3D NULL;
+	}
+}
+
+void aicwf_frame_tx(void *dev, struct sk_buff *skb)
+{
+	struct aic_sdio_dev *sdiodev =3D (struct aic_sdio_dev *)dev;
+
+	aicwf_bus_txdata(sdiodev->bus_if, skb);
+}
+
+struct aicwf_tx_priv *aicwf_tx_init(void *arg)
+{
+	struct aicwf_tx_priv *tx_priv;
+
+	tx_priv =3D kzalloc_obj(*tx_priv, GFP_KERNEL);
+	if (!tx_priv)
+		return NULL;
+
+	tx_priv->sdiodev =3D (struct aic_sdio_dev *)arg;
+
+	atomic_set(&tx_priv->aggr_count, 0);
+	tx_priv->aggr_buf =3D dev_alloc_skb(MAX_AGGR_TXPKT_LEN);
+	if (!tx_priv->aggr_buf) {
+		txrx_err("Alloc bus->txdata_buf failed!\n");
+		kfree(tx_priv);
+		return NULL;
+	}
+	tx_priv->head =3D tx_priv->aggr_buf->data;
+	tx_priv->tail =3D tx_priv->aggr_buf->data;
+
+	return tx_priv;
+}
+
+void aicwf_tx_deinit(struct aicwf_tx_priv *tx_priv)
+{
+	if (tx_priv && tx_priv->aggr_buf)
+		dev_kfree_skb(tx_priv->aggr_buf);
+
+	kfree(tx_priv);
+}
+
+static bool aicwf_another_ptk(struct sk_buff *skb)
+{
+	u16 aggr_len =3D 0;
+
+	if (!skb->data || skb->len =3D=3D 0)
+		return false;
+	aggr_len =3D (*skb->data | (*(skb->data + 1) << 8));
+	if (aggr_len =3D=3D 0)
+		return false;
+
+	return true;
+}
+
+int aicwf_process_rxframes(struct aicwf_rx_priv *rx_priv)
+{
+	int ret =3D 0;
+	unsigned long flags =3D 0;
+	struct sk_buff *skb =3D NULL;
+	u16 pkt_len =3D 0;
+	struct sk_buff *skb_inblock =3D NULL;
+	u16 aggr_len =3D 0, adjust_len =3D 0;
+	u8 *data =3D NULL;
+
+	while (1) {
+		spin_lock_irqsave(&rx_priv->rxqlock, flags);
+		if (aicwf_is_framequeue_empty(&rx_priv->rxq)) {
+			spin_unlock_irqrestore(&rx_priv->rxqlock, flags);
+			break;
+		}
+		skb =3D aicwf_frame_dequeue(&rx_priv->rxq);
+		spin_unlock_irqrestore(&rx_priv->rxqlock, flags);
+		if (!skb) {
+			txrx_err("skb_error\r\n");
+			break;
+		}
+		while (aicwf_another_ptk(skb)) {
+			data =3D skb->data;
+			pkt_len =3D (*skb->data | (*(skb->data + 1) << 8));
+
+			if ((skb->data[2] & SDIO_TYPE_CFG) !=3D
+				SDIO_TYPE_CFG) { // type : data
+				aggr_len =3D pkt_len + RX_HWHRD_LEN;
+
+				if (aggr_len & (RX_ALIGNMENT - 1))
+					adjust_len =3D roundup(aggr_len, RX_ALIGNMENT);
+				else
+					adjust_len =3D aggr_len;
+
+				skb_inblock =3D
+					__dev_alloc_skb(aggr_len + CCMP_OR_WEP_INFO,
+							GFP_KERNEL); // 8 is for ccmp mic or wep icv
+				if (!skb_inblock) {
+					txrx_err("no more space!\n");
+					aicwf_dev_skb_free(skb);
+					return -EBADE;
+				}
+
+				skb_put(skb_inblock, aggr_len);
+				memcpy(skb_inblock->data, data, aggr_len);
+				skb_pull(skb, adjust_len);
+			} else { //  type : config
+				aggr_len =3D pkt_len;
+
+				if (aggr_len & (RX_ALIGNMENT - 1))
+					adjust_len =3D roundup(aggr_len, RX_ALIGNMENT);
+				else
+					adjust_len =3D aggr_len;
+
+				skb_inblock =3D
+					__dev_alloc_skb(aggr_len + 4, GFP_KERNEL);
+				if (!skb_inblock) {
+					txrx_err("no more space!\n");
+					aicwf_dev_skb_free(skb);
+					return -EBADE;
+				}
+
+				skb_put(skb_inblock, aggr_len + 4);
+				memcpy(skb_inblock->data, data, aggr_len + 4);
+				if ((*(skb_inblock->data + 2) & 0x7f) =3D=3D SDIO_TYPE_CFG_CMD_RSP)
+					rwnx_rx_handle_msg(rx_priv->sdiodev,
+							   (struct ipc_e2a_msg *)(skb_inblock->data
+							   + 4));
+				skb_pull(skb, adjust_len + 4);
+			}
+		}
+
+		/* skb_inblock no used currently, just free it! */
+		dev_kfree_skb(skb_inblock);
+		dev_kfree_skb(skb);
+		atomic_dec(&rx_priv->rx_cnt);
+	}
+
+#if defined(CONFIG_SDIO_PWRCTRL)
+	aicwf_sdio_pwr_stctl(rx_priv->sdiodev, SDIO_ACTIVE_ST);
+#endif
+
+	return ret;
+}
+
+static struct recv_msdu *aicwf_rxframe_queue_init(struct list_head *q,
+						  int qsize)
+{
+	int i;
+	struct recv_msdu *req, *reqs;
+
+	reqs =3D vmalloc(qsize * sizeof(struct recv_msdu));
+	if (!reqs)
+		return NULL;
+
+	req =3D reqs;
+	for (i =3D 0; i < qsize; i++) {
+		INIT_LIST_HEAD(&req->rxframe_list);
+		list_add(&req->rxframe_list, q);
+		req->len =3D 0;
+		req++;
+	}
+
+	return reqs;
+}
+
+struct aicwf_rx_priv *aicwf_rx_init(void *arg)
+{
+	struct aicwf_rx_priv *rx_priv;
+
+	rx_priv =3D kzalloc_obj(*rx_priv, GFP_KERNEL);
+	if (!rx_priv)
+		return NULL;
+
+	rx_priv->sdiodev =3D (struct aic_sdio_dev *)arg;
+	aicwf_frame_queue_init(&rx_priv->rxq, 1, MAX_RXQLEN);
+	spin_lock_init(&rx_priv->rxqlock);
+	atomic_set(&rx_priv->rx_cnt, 0);
+
+	INIT_LIST_HEAD(&rx_priv->rxframes_freequeue);
+	spin_lock_init(&rx_priv->freeq_lock);
+	rx_priv->recv_frames =3D aicwf_rxframe_queue_init(&rx_priv->rxframes_free=
queue,
+							MAX_REORD_RXFRAME);
+	if (!rx_priv->recv_frames) {
+		txrx_err("no enough buffer for free recv frame queue!\n");
+		kfree(rx_priv);
+		return NULL;
+	}
+	spin_lock_init(&rx_priv->stas_reord_lock);
+	INIT_LIST_HEAD(&rx_priv->stas_reord_list);
+
+	return rx_priv;
+}
+
+static void aicwf_recvframe_queue_deinit(struct list_head *q)
+{
+	struct recv_msdu *req, *next;
+
+	list_for_each_entry_safe(req, next, q, rxframe_list) {
+		list_del_init(&req->rxframe_list);
+	}
+}
+
+void aicwf_rx_deinit(struct aicwf_rx_priv *rx_priv)
+{
+	if (rx_priv->sdiodev->bus_if->busrx_thread) {
+		complete_all(&rx_priv->sdiodev->bus_if->busrx_trgg);
+		kthread_stop(rx_priv->sdiodev->bus_if->busrx_thread);
+		rx_priv->sdiodev->bus_if->busrx_thread =3D NULL;
+	}
+
+	aicwf_frame_queue_flush(&rx_priv->rxq);
+	aicwf_recvframe_queue_deinit(&rx_priv->rxframes_freequeue);
+	if (rx_priv->recv_frames)
+		vfree(rx_priv->recv_frames);
+
+	kfree(rx_priv);
+}
+
+bool aicwf_rxframe_enqueue(struct device *dev, struct frame_queue *q,
+			   struct sk_buff *pkt)
+{
+	return aicwf_frame_enq(dev, q, pkt, 0);
+}
+
+void aicwf_dev_skb_free(struct sk_buff *skb)
+{
+	if (!skb)
+		return;
+
+	dev_kfree_skb_any(skb);
+}
+
+static struct sk_buff *aicwf_frame_queue_penq(struct frame_queue *pq, int =
prio,
+					      struct sk_buff *p)
+{
+	struct sk_buff_head *q;
+
+	if (pq->queuelist[prio].qlen >=3D pq->qmax)
+		return NULL;
+
+	q =3D &pq->queuelist[prio];
+	__skb_queue_tail(q, p);
+	pq->qcnt++;
+	if (pq->hi_prio < prio)
+		pq->hi_prio =3D (u16)prio;
+
+	return p;
+}
+
+void aicwf_frame_queue_flush(struct frame_queue *pq)
+{
+	int prio;
+	struct sk_buff_head *q;
+	struct sk_buff *p, *next;
+
+	for (prio =3D 0; prio < pq->num_prio; prio++) {
+		q =3D &pq->queuelist[prio];
+		skb_queue_walk_safe(q, p, next)
+		{
+			skb_unlink(p, q);
+			aicwf_dev_skb_free(p);
+			pq->qcnt--;
+		}
+	}
+}
+
+void aicwf_frame_queue_init(struct frame_queue *pq, int num_prio, int max_=
len)
+{
+	int prio;
+
+	memset(pq, 0,
+	       offsetof(struct frame_queue, queuelist) +
+			   (sizeof(struct sk_buff_head) * num_prio));
+	pq->num_prio =3D (u16)num_prio;
+	pq->qmax =3D (u16)max_len;
+
+	for (prio =3D 0; prio < num_prio; prio++)
+		skb_queue_head_init(&pq->queuelist[prio]);
+}
+
+struct sk_buff *aicwf_frame_queue_peek_tail(struct frame_queue *pq,
+					    int *prio_out)
+{
+	int prio;
+
+	if (pq->qcnt =3D=3D 0)
+		return NULL;
+
+	for (prio =3D 0; prio < pq->hi_prio; prio++)
+		if (!skb_queue_empty(&pq->queuelist[prio]))
+			break;
+
+	if (prio_out)
+		*prio_out =3D prio;
+
+	return skb_peek_tail(&pq->queuelist[prio]);
+}
+
+bool aicwf_is_framequeue_empty(struct frame_queue *pq)
+{
+	int prio, len =3D 0;
+
+	for (prio =3D 0; prio <=3D pq->hi_prio; prio++)
+		len +=3D pq->queuelist[prio].qlen;
+
+	if (len > 0)
+		return false;
+	else
+		return true;
+}
+
+struct sk_buff *aicwf_frame_dequeue(struct frame_queue *pq)
+{
+	struct sk_buff_head *q;
+	struct sk_buff *p;
+	int prio;
+
+	if (pq->qcnt =3D=3D 0)
+		return NULL;
+
+	while ((prio =3D pq->hi_prio) > 0 && skb_queue_empty(&pq->queuelist[prio]=
))
+		pq->hi_prio--;
+
+	q =3D &pq->queuelist[prio];
+	p =3D __skb_dequeue(q);
+	if (!p)
+		return NULL;
+
+	pq->qcnt--;
+
+	return p;
+}
+
+static struct sk_buff *aicwf_skb_dequeue_tail(struct frame_queue *pq, int =
prio)
+{
+	struct sk_buff_head *q =3D &pq->queuelist[prio];
+	struct sk_buff *p =3D skb_dequeue_tail(q);
+
+	if (!p)
+		return NULL;
+
+	pq->qcnt--;
+	return p;
+}
+
+bool aicwf_frame_enq(struct device *dev, struct frame_queue *q,
+		     struct sk_buff *pkt, int prio)
+{
+	struct sk_buff *p =3D NULL;
+	int prio_modified =3D -1;
+
+	if (q->queuelist[prio].qlen < q->qmax && q->qcnt < q->qmax) {
+		aicwf_frame_queue_penq(q, prio, pkt);
+		return true;
+	}
+	if (q->queuelist[prio].qlen >=3D q->qmax) {
+		prio_modified =3D prio;
+	} else if (q->qcnt >=3D q->qmax) {
+		p =3D aicwf_frame_queue_peek_tail(q, &prio_modified);
+		if (prio_modified > prio)
+			return false;
+	}
+
+	if (prio_modified >=3D 0) {
+		if (prio_modified =3D=3D prio)
+			return false;
+
+		p =3D aicwf_skb_dequeue_tail(q, prio_modified);
+		aicwf_dev_skb_free(p);
+
+		p =3D aicwf_frame_queue_penq(q, prio_modified, pkt);
+		if (!p)
+			txrx_err("failed\n");
+	}
+
+	return p;
+}
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aicsdio_txrxif.h b/driver=
s/net/wireless/aic/aic8800_bsp/aicsdio_txrxif.h
new file mode 100644
index 0000000000000..2ed64b3ae9949
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aicsdio_txrxif.h
@@ -0,0 +1,180 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * aicwf_txrxif.h
+ *
+ * bus function declarations
+ *
+ * Copyright (C) AICSemi 2018-2020
+ */
+
+#ifndef _AICWF_TXRXIF_H_
+#define _AICWF_TXRXIF_H_
+
+#include "aicsdio.h"
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include "aic_bus.h"
+
+#define CMD_BUF_MAX        1536
+#define TXPKT_BLOCKSIZE    512
+#define MAX_AGGR_TXPKT_LEN (1536 * 4)
+#define CMD_TX_TIMEOUT     5000
+#define TX_ALIGNMENT       4
+
+#define RX_HWHRD_LEN     60 // 58->60 word allined
+#define CCMP_OR_WEP_INFO 8
+#define MAX_RXQLEN       2000
+#define RX_ALIGNMENT     4
+
+#define DEBUG_ERROR_LEVEL 0
+#define DEBUG_DEBUG_LEVEL 1
+#define DEBUG_INFO_LEVEL  2
+
+#define DBG_LEVEL DEBUG_DEBUG_LEVEL
+
+#define txrx_err(fmt, ...)                                                =
     \
+	pr_err("aicbsp: txrx_err:<%s,%d>: " fmt, __func__, __LINE__, ##__VA_ARGS_=
_)
+#define sdio_err(fmt, ...)                                                =
     \
+	pr_err("aicbsp: sdio_err:<%s,%d>: " fmt, __func__, __LINE__, ##__VA_ARGS_=
_)
+#define usb_err(fmt, ...)                                                 =
     \
+	pr_err("aicbsp: usb_err:<%s,%d>: " fmt, __func__, __LINE__, ##__VA_ARGS__=
)
+#if DBG_LEVEL >=3D DEBUG_DEBUG_LEVEL
+#define sdio_dbg(fmt, ...) pr_debug("aicbsp: " fmt, ##__VA_ARGS__)
+#define usb_dbg(fmt, ...)  pr_debug("aicbsp: " fmt, ##__VA_ARGS__)
+#else
+#define sdio_dbg(fmt, ...)
+#define usb_dbg(fmt, ...)
+#endif
+#if DBG_LEVEL >=3D DEBUG_INFO_LEVEL
+#define sdio_info(fmt, ...) pr_info("aicbsp: " fmt, ##__VA_ARGS__)
+#define usb_info(fmt, ...)  pr_info("aicbsp: " fmt, ##__VA_ARGS__)
+#else
+#define sdio_info(fmt, ...)
+#define usb_info(fmt, ...)
+#endif
+
+/* aicwf_bus_state and aicwf_bus_ops are now defined in aic_bus.h */
+
+struct frame_queue {
+	u16 num_prio;
+	u16 hi_prio;
+	u16 qmax; /* max number of queued frames */
+	u16 qcnt;
+	struct sk_buff_head queuelist[8];
+};
+
+struct aicwf_tx_priv {
+#ifdef AICWF_SDIO_SUPPORT
+	struct aic_sdio_dev *sdiodev;
+	int fw_avail_bufcnt;
+	// for cmd tx
+	u8 *cmd_buf;
+	uint cmd_len;
+	bool cmd_txstate;
+	bool cmd_tx_succ;
+	struct semaphore cmd_txsema;
+	wait_queue_head_t cmd_txdone_wait;
+	// for data tx
+	atomic_t tx_pktcnt;
+
+	struct frame_queue txq;
+	/* lock for tx_priv */
+	spinlock_t txqlock;
+	struct semaphore txctl_sema;
+#endif
+	struct sk_buff *aggr_buf;
+	atomic_t aggr_count;
+	u8 *head;
+	u8 *tail;
+};
+
+#define MAX_REORD_RXFRAME     250
+#define REORDER_UPDATE_TIME   50
+#define AICWF_REORDER_WINSIZE 64
+#define SN_LESS(a, b)         ((((a) - (b)) & 0x800) !=3D 0)
+#define SN_EQUAL(a, b)        ((a) =3D=3D (b))
+
+struct reord_ctrl {
+	struct aicwf_rx_priv *rx_priv;
+	u8 enable;
+	u16 ind_sn;
+	u8 wsize_b;
+	/* lock for reord list */
+	spinlock_t reord_list_lock;
+	struct list_head reord_list;
+	struct timer_list reord_timer;
+	struct work_struct reord_timer_work;
+};
+
+struct reord_ctrl_info {
+	u8 mac_addr[6];
+	struct reord_ctrl preorder_ctrl[8];
+	struct list_head list;
+};
+
+struct recv_msdu {
+	struct sk_buff *pkt;
+	u8 tid;
+	u16 seq_num;
+	uint len;
+	u8 *rx_data;
+	// for pending rx reorder list
+	struct list_head reord_pending_list;
+	// for total frame list, when rxframe from busif, dequeue, when submit fr=
ame
+	// to net, enqueue
+	struct list_head rxframe_list;
+	struct reord_ctrl *preorder_ctrl;
+};
+
+struct aicwf_rx_priv {
+	struct aic_sdio_dev *sdiodev;
+	void *rwnx_vif;
+	atomic_t rx_cnt;
+	u32 data_len;
+	/* lock for rx priv */
+	spinlock_t rxqlock;
+	struct frame_queue rxq;
+
+	/* lock for freeq */
+	spinlock_t freeq_lock;
+	struct list_head rxframes_freequeue;
+	struct list_head stas_reord_list;
+	/* lock for reord */
+	spinlock_t stas_reord_lock;
+	struct recv_msdu *recv_frames;
+};
+
+/* Inline bus wrappers and aicwf_bus_init/deinit are now in aic_bus.h */
+
+static inline void aicwf_sched_timeout(u32 millisec)
+{
+	ulong timeout =3D 0, expires =3D 0;
+
+	expires =3D jiffies + msecs_to_jiffies(millisec);
+	timeout =3D millisec;
+
+	while (timeout) {
+		timeout =3D schedule_timeout(timeout);
+		if (time_after(jiffies, expires))
+			break;
+	}
+}
+
+void aicwf_tx_deinit(struct aicwf_tx_priv *tx_priv);
+void aicwf_rx_deinit(struct aicwf_rx_priv *rx_priv);
+struct aicwf_tx_priv *aicwf_tx_init(void *arg);
+struct aicwf_rx_priv *aicwf_rx_init(void *arg);
+void aicwf_frame_queue_init(struct frame_queue *pq, int num_prio, int max_=
len);
+void aicwf_frame_queue_flush(struct frame_queue *pq);
+bool aicwf_frame_enq(struct device *dev, struct frame_queue *q,
+		     struct sk_buff *pkt, int prio);
+bool aicwf_rxframe_enqueue(struct device *dev, struct frame_queue *q,
+			   struct sk_buff *pkt);
+bool aicwf_is_framequeue_empty(struct frame_queue *pq);
+void aicwf_frame_tx(void *dev, struct sk_buff *skb);
+void aicwf_dev_skb_free(struct sk_buff *skb);
+struct sk_buff *aicwf_frame_dequeue(struct frame_queue *pq);
+struct sk_buff *aicwf_frame_queue_peek_tail(struct frame_queue *pq,
+					    int *prio_out);
+
+#endif /* _AICWF_TXRXIF_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aicwf_txq_prealloc.c b/dr=
ivers/net/wireless/aic/aic8800_bsp/aicwf_txq_prealloc.c
new file mode 100644
index 0000000000000..0e0387f502e12
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aicwf_txq_prealloc.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief bsp txq prealloc mem
+ *
+ *************************************************************************=
*****
+ */
+#include "aic_bsp_driver.h"
+#include "aicsdio_txrxif.h"
+#include "aicwf_txq_prealloc.h"
+#include <linux/slab.h>
+
+struct prealloc_txq {
+	int prealloced;
+	void *txq;
+	size_t size;
+};
+
+static struct prealloc_txq prealloc_txq;
+#define MAX_TXQ_SIZE (100 * 1024)
+
+/**
+ * aicwf_prealloc_txq_alloc - Allocate or reuse the preallocated TX queue
+ * @size: Required queue size in bytes
+ *
+ * Return: Pointer to a zeroed queue buffer, or %NULL if allocation failed=
.
+ */
+void *aicwf_prealloc_txq_alloc(size_t size)
+{
+	WARN_ON_ONCE(size > MAX_TXQ_SIZE);
+
+	// check prealloc_txq.size
+	if ((int)prealloc_txq.size !=3D (int)size) {
+		AICWFDBG(LOGINFO, "%s size is diff will to be kzalloc \r\n", __func__);
+
+		if (prealloc_txq.txq) {
+			AICWFDBG(LOGINFO, "%s txq to kfree \r\n", __func__);
+			kfree(prealloc_txq.txq);
+			prealloc_txq.txq =3D NULL;
+		}
+
+		prealloc_txq.size =3D size;
+		prealloc_txq.prealloced =3D 0;
+	}
+	// check prealloc or not
+	if (!prealloc_txq.prealloced) {
+		prealloc_txq.txq =3D kzalloc(size, GFP_KERNEL);
+		if (!prealloc_txq.txq) {
+			AICWFDBG(LOGERROR, "%s txq kzalloc fail \r\n", __func__);
+		} else {
+			AICWFDBG(LOGINFO, "%s txq kzalloc successful \r\n", __func__);
+			prealloc_txq.prealloced =3D 1;
+		}
+	} else {
+		AICWFDBG(LOGINFO, "%s txq not need to kzalloc \r\n", __func__);
+	}
+
+	return prealloc_txq.txq;
+}
+
+void aicwf_prealloc_txq_free(void)
+{
+	if (prealloc_txq.txq) {
+		AICWFDBG(LOGINFO, "%s txq to kfree \r\n", __func__);
+		kfree(prealloc_txq.txq);
+		prealloc_txq.txq =3D NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(aicwf_prealloc_txq_alloc);
diff --git a/drivers/net/wireless/aic/aic8800_bsp/aicwf_txq_prealloc.h b/dr=
ivers/net/wireless/aic/aic8800_bsp/aicwf_txq_prealloc.h
new file mode 100644
index 0000000000000..680d37ffca931
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/aicwf_txq_prealloc.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _AICWF_TXQ_PREALLOC_H_
+#define _AICWF_TXQ_PREALLOC_H_
+
+void *aicwf_prealloc_txq_alloc(size_t size);
+void aicwf_prealloc_txq_free(void);
+
+#endif
diff --git a/drivers/net/wireless/aic/aic8800_bsp/md5.c b/drivers/net/wirel=
ess/aic/aic8800_bsp/md5.c
new file mode 100644
index 0000000000000..88b4adfd58be4
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/md5.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "md5.h"
+#include <linux/memory.h>
+
+static unsigned char PADDING[] =3D {0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,=
 0, 0, 0, 0,
+			   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
+
+void md5_init(struct MD5_CTX *context)
+{
+	context->count[0] =3D 0;
+	context->count[1] =3D 0;
+	context->state[0] =3D 0x67452301;
+	context->state[1] =3D 0xEFCDAB89;
+	context->state[2] =3D 0x98BADCFE;
+	context->state[3] =3D 0x10325476;
+}
+
+void md5_update(struct MD5_CTX *context, unsigned char *input, unsigned in=
t inputlen)
+{
+	unsigned int i =3D 0, index =3D 0, partlen =3D 0;
+
+	index =3D (context->count[0] >> 3) & 0x3F;
+	partlen =3D 64 - index;
+	context->count[0] +=3D inputlen << 3;
+	if (context->count[0] < (inputlen << 3))
+		context->count[1]++;
+	context->count[1] +=3D inputlen >> 29;
+
+	if (inputlen >=3D partlen) {
+		memcpy(&context->buffer[index], input, partlen);
+		md5_transform(context->state, context->buffer);
+		for (i =3D partlen; i + 64 <=3D inputlen; i +=3D 64)
+			md5_transform(context->state, &input[i]);
+		index =3D 0;
+	} else {
+		i =3D 0;
+	}
+	memcpy(&context->buffer[index], &input[i], inputlen - i);
+}
+
+void md5_final(struct MD5_CTX *context, unsigned char digest[16])
+{
+	unsigned int index =3D 0, padlen =3D 0;
+	unsigned char bits[8];
+
+	index =3D (context->count[0] >> 3) & 0x3F;
+	padlen =3D (index < 56) ? (56 - index) : (120 - index);
+	md5_encode(bits, context->count, 8);
+	md5_update(context, PADDING, padlen);
+	md5_update(context, bits, 8);
+	md5_encode(digest, context->state, 16);
+}
+
+void md5_encode(unsigned char *output, unsigned int *input, unsigned int l=
en)
+{
+	unsigned int i =3D 0, j =3D 0;
+
+	while (j < len) {
+		output[j] =3D input[i] & 0xFF;
+		output[j + 1] =3D (input[i] >> 8) & 0xFF;
+		output[j + 2] =3D (input[i] >> 16) & 0xFF;
+		output[j + 3] =3D (input[i] >> 24) & 0xFF;
+		i++;
+		j +=3D 4;
+	}
+}
+
+void md5_decode(unsigned int *output, unsigned char *input, unsigned int l=
en)
+{
+	unsigned int i =3D 0, j =3D 0;
+
+	while (j < len) {
+		output[i] =3D (input[j]) | (input[j + 1] << 8) | (input[j + 2] << 16) |
+					(input[j + 3] << 24);
+		i++;
+		j +=3D 4;
+	}
+}
+
+void md5_transform(unsigned int state[4], unsigned char block[64])
+{
+	unsigned int a =3D state[0];
+	unsigned int b =3D state[1];
+	unsigned int c =3D state[2];
+	unsigned int d =3D state[3];
+	unsigned int x[64];
+
+	md5_decode(x, block, 64);
+	FF(&a, b, c, d, x[0], 7, 0xd76aa478);   /* 1 */
+	FF(&d, a, b, c, x[1], 12, 0xe8c7b756);  /* 2 */
+	FF(&c, d, a, b, x[2], 17, 0x242070db);  /* 3 */
+	FF(&b, c, d, a, x[3], 22, 0xc1bdceee);  /* 4 */
+	FF(&a, b, c, d, x[4], 7, 0xf57c0faf);   /* 5 */
+	FF(&d, a, b, c, x[5], 12, 0x4787c62a);  /* 6 */
+	FF(&c, d, a, b, x[6], 17, 0xa8304613);  /* 7 */
+	FF(&b, c, d, a, x[7], 22, 0xfd469501);  /* 8 */
+	FF(&a, b, c, d, x[8], 7, 0x698098d8);   /* 9 */
+	FF(&d, a, b, c, x[9], 12, 0x8b44f7af);  /* 10 */
+	FF(&c, d, a, b, x[10], 17, 0xffff5bb1); /* 11 */
+	FF(&b, c, d, a, x[11], 22, 0x895cd7be); /* 12 */
+	FF(&a, b, c, d, x[12], 7, 0x6b901122);  /* 13 */
+	FF(&d, a, b, c, x[13], 12, 0xfd987193); /* 14 */
+	FF(&c, d, a, b, x[14], 17, 0xa679438e); /* 15 */
+	FF(&b, c, d, a, x[15], 22, 0x49b40821); /* 16 */
+
+	/* Round 2 */
+	GG(&a, b, c, d, x[1], 5, 0xf61e2562);   /* 17 */
+	GG(&d, a, b, c, x[6], 9, 0xc040b340);   /* 18 */
+	GG(&c, d, a, b, x[11], 14, 0x265e5a51); /* 19 */
+	GG(&b, c, d, a, x[0], 20, 0xe9b6c7aa);  /* 20 */
+	GG(&a, b, c, d, x[5], 5, 0xd62f105d);   /* 21 */
+	GG(&d, a, b, c, x[10], 9, 0x2441453);   /* 22 */
+	GG(&c, d, a, b, x[15], 14, 0xd8a1e681); /* 23 */
+	GG(&b, c, d, a, x[4], 20, 0xe7d3fbc8);  /* 24 */
+	GG(&a, b, c, d, x[9], 5, 0x21e1cde6);   /* 25 */
+	GG(&d, a, b, c, x[14], 9, 0xc33707d6);  /* 26 */
+	GG(&c, d, a, b, x[3], 14, 0xf4d50d87);  /* 27 */
+	GG(&b, c, d, a, x[8], 20, 0x455a14ed);  /* 28 */
+	GG(&a, b, c, d, x[13], 5, 0xa9e3e905);  /* 29 */
+	GG(&d, a, b, c, x[2], 9, 0xfcefa3f8);   /* 30 */
+	GG(&c, d, a, b, x[7], 14, 0x676f02d9);  /* 31 */
+	GG(&b, c, d, a, x[12], 20, 0x8d2a4c8a); /* 32 */
+
+	/* Round 3 */
+	HH(&a, b, c, d, x[5], 4, 0xfffa3942);   /* 33 */
+	HH(&d, a, b, c, x[8], 11, 0x8771f681);  /* 34 */
+	HH(&c, d, a, b, x[11], 16, 0x6d9d6122); /* 35 */
+	HH(&b, c, d, a, x[14], 23, 0xfde5380c); /* 36 */
+	HH(&a, b, c, d, x[1], 4, 0xa4beea44);   /* 37 */
+	HH(&d, a, b, c, x[4], 11, 0x4bdecfa9);  /* 38 */
+	HH(&c, d, a, b, x[7], 16, 0xf6bb4b60);  /* 39 */
+	HH(&b, c, d, a, x[10], 23, 0xbebfbc70); /* 40 */
+	HH(&a, b, c, d, x[13], 4, 0x289b7ec6);  /* 41 */
+	HH(&d, a, b, c, x[0], 11, 0xeaa127fa);  /* 42 */
+	HH(&c, d, a, b, x[3], 16, 0xd4ef3085);  /* 43 */
+	HH(&b, c, d, a, x[6], 23, 0x4881d05);   /* 44 */
+	HH(&a, b, c, d, x[9], 4, 0xd9d4d039);   /* 45 */
+	HH(&d, a, b, c, x[12], 11, 0xe6db99e5); /* 46 */
+	HH(&c, d, a, b, x[15], 16, 0x1fa27cf8); /* 47 */
+	HH(&b, c, d, a, x[2], 23, 0xc4ac5665);  /* 48 */
+
+	/* Round 4 */
+	II(&a, b, c, d, x[0], 6, 0xf4292244);   /* 49 */
+	II(&d, a, b, c, x[7], 10, 0x432aff97);  /* 50 */
+	II(&c, d, a, b, x[14], 15, 0xab9423a7); /* 51 */
+	II(&b, c, d, a, x[5], 21, 0xfc93a039);  /* 52 */
+	II(&a, b, c, d, x[12], 6, 0x655b59c3);  /* 53 */
+	II(&d, a, b, c, x[3], 10, 0x8f0ccc92);  /* 54 */
+	II(&c, d, a, b, x[10], 15, 0xffeff47d); /* 55 */
+	II(&b, c, d, a, x[1], 21, 0x85845dd1);  /* 56 */
+	II(&a, b, c, d, x[8], 6, 0x6fa87e4f);   /* 57 */
+	II(&d, a, b, c, x[15], 10, 0xfe2ce6e0); /* 58 */
+	II(&c, d, a, b, x[6], 15, 0xa3014314);  /* 59 */
+	II(&b, c, d, a, x[13], 21, 0x4e0811a1); /* 60 */
+	II(&a, b, c, d, x[4], 6, 0xf7537e82);   /* 61 */
+	II(&d, a, b, c, x[11], 10, 0xbd3af235); /* 62 */
+	II(&c, d, a, b, x[2], 15, 0x2ad7d2bb);  /* 63 */
+	II(&b, c, d, a, x[9], 21, 0xeb86d391);  /* 64 */
+	state[0] +=3D a;
+	state[1] +=3D b;
+	state[2] +=3D c;
+	state[3] +=3D d;
+}
diff --git a/drivers/net/wireless/aic/aic8800_bsp/md5.h b/drivers/net/wirel=
ess/aic/aic8800_bsp/md5.h
new file mode 100644
index 0000000000000..146c0f6d9430c
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/md5.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef MD5_H
+#define MD5_H
+
+#include <linux/types.h>
+
+struct MD5_CTX {
+	unsigned int count[2];
+	unsigned int state[4];
+	unsigned char buffer[64];
+};
+
+static inline u32 F(u32 x, u32 y, u32 z)
+{
+	return (x & y) | (~x & z);
+}
+
+static inline u32 G(u32 x, u32 y, u32 z)
+{
+	return (x & z) | (y & ~z);
+}
+
+static inline u32 H(u32 x, u32 y, u32 z)
+{
+	return x ^ y ^ z;
+}
+
+static inline u32 I(u32 x, u32 y, u32 z)
+{
+	return y ^ (x | ~z);
+}
+
+static inline u32 ROTATE_LEFT(u32 x, u32 n)
+{
+	return (x << n) | (x >> (32 - n));
+}
+
+static inline void FF(u32 *a, u32 b, u32 c, u32 d,
+		      u32 x, u32 s, u32 ac)
+{
+	*a +=3D F(b, c, d) + x + ac;
+	*a =3D ROTATE_LEFT(*a, s);
+	*a +=3D b;
+}
+
+static inline void GG(u32 *a, u32 b, u32 c, u32 d,
+		      u32 x, u32 s, u32 ac)
+{
+	*a +=3D G(b, c, d) + x + ac;
+	*a =3D ROTATE_LEFT(*a, s);
+	*a +=3D b;
+}
+
+static inline void HH(u32 *a, u32 b, u32 c, u32 d,
+		      u32 x, u32 s, u32 ac)
+{
+	*a +=3D H(b, c, d) + x + ac;
+	*a =3D ROTATE_LEFT(*a, s);
+	*a +=3D b;
+}
+
+static inline void II(u32 *a, u32 b, u32 c, u32 d,
+		      u32 x, u32 s, u32 ac)
+{
+	*a +=3D I(b, c, d) + x + ac;
+	*a =3D ROTATE_LEFT(*a, s);
+	*a +=3D b;
+}
+
+void md5_init(struct MD5_CTX *context);
+void md5_update(struct MD5_CTX *context, unsigned char *input, unsigned in=
t inputlen);
+void md5_final(struct MD5_CTX *context, unsigned char digest[16]);
+void md5_transform(unsigned int state[4], unsigned char block[64]);
+void md5_encode(unsigned char *output, unsigned int *input, unsigned int l=
en);
+void md5_decode(unsigned int *output, unsigned char *input, unsigned int l=
en);
+
+#endif
diff --git a/drivers/net/wireless/aic/aic8800_bsp/rwnx_version_gen.h b/driv=
ers/net/wireless/aic/aic8800_bsp/rwnx_version_gen.h
new file mode 100644
index 0000000000000..8768db424ce78
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_bsp/rwnx_version_gen.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#define RWNX_VERS_REV    "241c091M (master)"
+#define RWNX_VERS_MOD    "6.4.3.0"
+#define RWNX_VERS_BANNER "rwnx v6.4.3.0 - - 241c091M (master)"
+#define RELEASE_VERSION "2.0.14"
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/Kconfig b/drivers/net/wi=
reless/aic/aic8800_fdrv/Kconfig
new file mode 100644
index 0000000000000..037bb16a9dddd
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/Kconfig
@@ -0,0 +1,539 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+menuconfig AIC8800_WLAN_SUPPORT
+	tristate "AIC8800 FullMAC WLAN support"
+	depends on AIC8800_BSP_SUPPORT
+	depends on CFG80211
+	help
+	  Enable the AIC8800 FullMAC Wi-Fi driver.
+	  This layer registers the cfg80211 wireless device and handles
+	  station, AP, P2P, and management frame operation for AIC8800
+	  chipsets.
+
+	  If unsure, say N.
+
+if AIC8800_WLAN_SUPPORT
+
+config RWNX_FULLMAC
+	def_bool y
+
+menu "Firmware interface compatibility"
+
+config RWNX_TL4
+	bool "RWNX TL4 support"
+	depends on BROKEN
+	default n
+	help
+	  Enable support for the TL4 transport layout used by some older
+	  firmware builds. This option changes host and firmware message
+	  handling paths and should match the firmware image in use.
+
+	  If unsure, say N.
+
+config RWNX_OLD_IPC
+	bool "RWNX old IPC format"
+	depends on BROKEN
+	default n
+	help
+	  Enable compatibility with the older firmware IPC format.
+	  Select this only when the target firmware expects the legacy IPC
+	  message layout and cannot communicate with the default format.
+
+	  If unsure, say N.
+
+endmenu
+
+menu "Platform integration and legacy compatibility"
+
+config AIC8800_WPA3_FOR_OLD_KERNEL
+	bool "WPA3 compatibility for old kernels"
+	depends on BROKEN
+	help
+	  Enable downstream WPA3 compatibility code intended for kernels
+	  that predate the required cfg80211 interfaces. Current mainline
+	  already supplies the interfaces used by the normal driver path.
+	  The retained legacy implementation is therefore kept disabled.
+
+config AIC8800_VHT_FOR_OLD_KERNEL
+	bool "VHT compatibility for old kernels"
+	depends on BROKEN
+	help
+	  Enable the legacy VHT capability implementation. Keep this
+	  disabled on current mainline kernels. The normal cfg80211 path
+	  advertises VHT capabilities through the current kernel API. This
+	  option remains only for downstream source compatibility.
+
+config AIC8800_HE_FOR_OLD_KERNEL
+	bool "HE compatibility for old kernels"
+	depends on BROKEN
+	help
+	  Enable the legacy 802.11ax HE capability implementation. Keep
+	  this disabled on current mainline kernels. The default driver path
+	  uses the current cfg80211 HE capability representation. This code
+	  is retained only for old downstream kernel integrations.
+
+config AIC8800_WIFI_SUSPEND_FOR_LINUX
+	bool "Legacy procfs Wi-Fi suspend control"
+	depends on BROKEN
+	help
+	  Expose the downstream procfs control used by legacy user space
+	  to request Wi-Fi suspend. Normal systems should use cfg80211
+	  power management and system suspend instead. The legacy procfs
+	  ABI remains disabled because it is not an upstream interface.
+
+config AIC8800_GKI
+	bool "Android GKI compatibility"
+	depends on BROKEN
+	help
+	  Enable compatibility wrappers needed by Android Generic Kernel
+	  Image based platforms. These wrappers target downstream Android
+	  kernel interfaces rather than a current mainline kernel. The code
+	  is retained for reference but cannot be selected upstream.
+
+config AIC8800_GENL
+	bool "Generic netlink control interface"
+	default n
+	help
+	  Build the private AIC8800 generic-netlink command interface used
+	  for manufacturing and driver debugging. Commands require
+	  CAP_NET_ADMIN and this interface is not a stable userspace ABI.
+	  Normal systems should use cfg80211 and nl80211 instead.
+
+	  If unsure, say N.
+
+config AIC8800_USE_WIRELESS_EXT
+	bool "Legacy Wireless Extensions support"
+	depends on CFG80211_WEXT && BROKEN
+	help
+	  Build the AIC-specific Wireless Extensions compatibility layer.
+	  New user space should use nl80211 instead. The retained code uses
+	  downstream compatibility interfaces and is not enabled on current
+	  mainline kernels. This option remains for source history only.
+
+endmenu
+
+menu "Wireless and data path features"
+
+config RWNX_SPLIT_TX_BUF
+	bool "Split TX buffer for A-MSDU"
+	depends on BROKEN
+	default n
+	help
+	  Enable split TX buffer handling for A-MSDU capable firmware.
+	  This option should be enabled only when the firmware advertises
+	  matching aggregation support and expects split host buffers.
+
+	  If unsure, say N.
+
+config RWNX_AMSDUS_TX
+	bool "Enable A-MSDU TX"
+	default n
+	depends on RWNX_SPLIT_TX_BUF
+	help
+	  Enable transmit-side A-MSDU aggregation support in the FullMAC
+	  driver. This depends on split TX buffer support and matching
+	  firmware capabilities for aggregated frame transmission.
+
+	  If unsure, say N.
+
+config RWNX_BFMER
+	bool "VHT beamformer support"
+	default n
+	help
+	  Enable VHT beamformer support for chip and firmware builds that
+	  implement explicit transmit beamforming. This adds beamforming
+	  station bookkeeping and firmware command handling.
+
+	  If unsure, say N.
+
+config RWNX_MUMIMO_TX
+	bool "MU-MIMO TX support"
+	default n
+	depends on !RWNX_OLD_IPC
+	help
+	  Enable MU-MIMO transmit support for firmware builds that expose
+	  multi-user transmit scheduling. This option adds MU group state
+	  tracking and related firmware message handling.
+
+	  If unsure, say N.
+
+config AIC8800_RX_REORDER
+	bool "RX reorder support"
+	default y
+	help
+	  Enable receive reorder handling for aggregated 802.11 traffic.
+	  The driver keeps per-station reorder state so packets are passed
+	  to the network stack in sequence when block-ack is active.
+
+	  If unsure, say Y.
+
+config AIC8800_ARP_OFFLOAD
+	bool "ARP offload support"
+	default y
+	help
+	  Enable ARP offload support in the Wi-Fi firmware path.
+	  When supported by firmware, ARP handling may continue while the
+	  host is in a low-power state.
+
+	  If unsure, say Y.
+
+config AIC8800_RADAR_OR_IR_DETECT
+	bool "Radar/IR detect support"
+	default n
+	help
+	  Enable radar or interference detection event handling.
+	  This is used by DFS-capable firmware to report channel events
+	  that may require channel changes or regulatory action.
+
+	  If unsure, say N.
+
+config AIC8800_USE_5G
+	bool "Enable 5 GHz band"
+	default y
+	help
+	  Enable 5 GHz band support in the driver capability setup.
+	  Disable this only for hardware or regulatory configurations that
+	  must restrict operation to the 2.4 GHz band.
+
+	  If unsure, say Y.
+
+config AIC8800_CREATE_TRACE_POINTS
+	bool "Create trace points"
+	depends on EVENT_TRACING
+	default n
+	help
+	  Enable tracepoint definitions for selected AIC8800 driver paths.
+	  This is useful for driver development and timing analysis but is
+	  not required for normal runtime operation.
+
+	  If unsure, say N.
+
+config AIC8800_TXRX_THREAD_PRIO
+	bool "TX/RX thread priority"
+	default y
+	help
+	  Enable priority tuning for the driver transmit and receive
+	  worker threads. This can reduce latency under load on platforms
+	  where the SDIO transport shares CPU time with other work.
+	  The selected priority is applied when the transport threads start.
+	  Leave this enabled for the standard SDIO configuration.
+
+	  If unsure, say Y.
+
+config AIC8800_COEX
+	bool "Wi-Fi/Bluetooth coexistence"
+	default y
+	help
+	  Enable coexistence support for combo Wi-Fi and Bluetooth chips.
+	  The driver exchanges coexistence information with firmware so
+	  shared-radio operation can be coordinated. This requires
+	  coexistence support in the selected firmware image.
+	  Disable it only for Wi-Fi-only modules.
+
+	  If unsure, say Y.
+
+config AIC8800_RX_NETIF_RECV_SKB
+	bool "Use netif_receive_skb for RX"
+	default y
+	help
+	  Pass received packets to the networking stack with
+	  netif_receive_skb(). This is the normal receive path for this
+	  driver and should match the platform networking integration.
+
+	  If unsure, say Y.
+
+config AIC8800_SET_VENDOR_EXTENSION_IE
+	bool "Vendor extension IE support"
+	depends on BROKEN
+	default n
+	help
+	  Enable support for setting vendor extension information elements
+	  in management frames. This is intended for product-specific
+	  interoperability requirements and test configurations.
+
+	  If unsure, say N.
+
+config AIC8800_SUPPORT_REALTIME_CHANGE_MAC
+	bool "Runtime MAC address change"
+	default y
+	help
+	  Allow the driver to update the interface MAC address at runtime.
+	  This is used by platforms that need to apply a board-specific or
+	  user-provided MAC address after probe.
+
+	  If unsure, say Y.
+
+config AIC8800_USE_P2P0
+	bool "Use P2P0 interface"
+	default n
+	help
+	  Enable use of a dedicated P2P0 interface for Wi-Fi Direct.
+	  This should match the firmware and user space expectation for
+	  P2P device interface creation.
+
+	  If unsure, say N.
+
+config AIC8800_TX_NETIF_FLOWCTRL
+	bool "TX netdev flow control"
+	default n
+	help
+	  Enable netdev queue flow control from the transmit path.
+	  The driver may stop and wake netdev queues based on firmware and
+	  SDIO buffer pressure to avoid excessive packet buildup.
+
+	  If unsure, say N.
+
+config AIC8800_ONE_TXQ
+	bool "Single TX queue"
+	default n
+	help
+	  Use a single transmit queue model for platforms that cannot use
+	  the normal per-access-category queue layout. This may simplify
+	  integration at the cost of scheduling flexibility.
+
+	  If unsure, say N.
+
+config AIC8800_PREALLOC_RX_SKB
+	bool "Preallocate RX SKBs"
+	help
+	  Preallocate receive socket buffers during initialization. This
+	  may improve allocation latency at the cost of reserved memory.
+	  The buffers remain available to the SDIO receive path while the
+	  driver is active. Enable this only when that memory tradeoff fits.
+
+config AIC8800_FDRV_NO_REG_SDIO
+	bool "Avoid direct SDIO register access"
+	help
+	  Disable the FullMAC driver's direct SDIO register access path.
+	  Firmware-mediated access is used instead for affected operations.
+	  This is intended for platforms that restrict direct bus access.
+	  Enable it only when the platform integration requires that mode.
+
+config AIC8800_BR_SUPPORT
+	bool "Bridge support"
+	depends on BROKEN
+	default n
+	help
+	  Enable bridge helper code used by some downstream networking
+	  setups. This can adjust packet handling when the wireless
+	  interface is attached to a Linux bridge.
+
+	  If unsure, say N.
+
+config AIC8800_SCHED_SCAN
+	bool "Scheduled scan support"
+	default n
+	help
+	  Enable scheduled scan handling in the driver. When supported by
+	  firmware, cfg80211 can request periodic scans without waking
+	  user space for every scan cycle.
+
+	  If unsure, say N.
+
+config AIC8800_USE_CUSTOMER_MAC
+	bool "Use customer MAC address"
+	default n
+	help
+	  Enable product-specific MAC address selection logic.
+	  This option is intended for platforms that store the Wi-Fi MAC
+	  address outside the normal firmware or NVMEM path.
+
+	  If unsure, say N.
+
+endmenu
+
+menu "Performance, regulatory and power management"
+
+config AIC8800_FILTER_TCP_ACK
+	bool "Filter TCP ACK packets"
+	default y
+	help
+	  Enable TCP ACK filtering in the SDIO data path.
+	  This can reduce transmit traffic and improve throughput on some
+	  platforms by suppressing redundant pure ACK packets.
+
+	  If unsure, say Y.
+
+config AIC8800_TEMP_COMP
+	bool "Temperature compensation"
+	default y
+	help
+	  Enable temperature compensation support for RF calibration.
+	  The driver can request temperature data from firmware or chip
+	  logic and apply compensation where supported.
+
+	  If unsure, say Y.
+
+config AIC8800_AUTO_CUSTREG
+	bool "Automatic customer regulatory setup"
+	default y
+	help
+	  Enable automatic customer regulatory configuration handling.
+	  The driver may apply board or product regulatory parameters
+	  during initialization when firmware support is present.
+
+	  If unsure, say Y.
+
+config AIC8800_TEMP_CONTROL
+	bool "Temperature control"
+	default y
+	help
+	  Enable temperature control handling for supported chips.
+	  This allows the driver to exchange thermal control commands with
+	  firmware and react to temperature-related state changes.
+
+	  If unsure, say Y.
+
+config AIC8800_WOWLAN_PM
+	bool "WoWLAN power management"
+	default y
+	help
+	  Enable Wake-on-WLAN power management support.
+	  When firmware supports it, selected wireless events can wake the
+	  host from suspend while the device remains in a low-power mode.
+
+	  If unsure, say Y.
+
+config AIC8800_POWER_LIMIT
+	bool "Power limit support"
+	default y
+	help
+	  Enable power limit handling for supported board configurations.
+	  The driver can pass configured transmit power restrictions to
+	  firmware when product data requires it.
+
+	  If unsure, say Y.
+
+config AIC8800_REGION_PW
+	bool "Regional power support"
+	default y
+	help
+	  Enable regional transmit power handling.
+	  This option allows board or firmware data to select power tables
+	  that correspond to the configured regulatory region.
+
+	  If unsure, say Y.
+
+config AIC8800_MCC
+	bool "Multi-channel concurrency support"
+	default y
+	help
+	  Enable multi-channel concurrency support for station and P2P
+	  operation on different channels. This should match firmware
+	  capability and concurrent mode requirements.
+	  The firmware remains responsible for channel time scheduling.
+	  Disable this when using firmware without MCC support.
+
+	  If unsure, say Y.
+
+config AICWF_LATENCY_MODE
+	bool "Low latency mode"
+	default n
+	help
+	  Enable low latency tuning in the AIC8800 data path.
+	  This may reduce packet latency at the cost of higher CPU usage
+	  or lower batching efficiency on some systems.
+
+	  If unsure, say N.
+
+config AIC8800_AUTO_POWERSAVE
+	bool "Automatic power save"
+	default y
+	help
+	  Enable automatic power save handling in the SDIO and firmware
+	  path. The driver may enter low-power states when traffic is idle
+	  and wake the device when new work arrives.
+
+	  If unsure, say Y.
+
+config AIC8800_NO_WAKE_COUNT
+	bool "Disable wake count tracking"
+	depends on !AIC8800_AUTO_POWERSAVE
+	default n
+	help
+	  Disable the driver's wake count tracking logic.
+	  This is mutually exclusive with the automatic power save flow and
+	  is intended only for platforms with different wake accounting.
+	  Normal mainline systems should keep wake count tracking enabled.
+	  This option exists for firmware-specific power management flows.
+
+	  If unsure, say N.
+
+endmenu
+
+menu "Radar, monitoring and diagnostics"
+
+config RWNX_RADAR
+	bool "Radar event handling"
+	default y
+	help
+	  Enable radar event processing from firmware.
+	  This is used with DFS-capable firmware so the driver can report
+	  radar detection and channel availability events to cfg80211.
+
+	  If unsure, say Y.
+
+config RWNX_BCMC
+	bool "Broadcast/multicast station support"
+	default y
+	help
+	  Enable broadcast and multicast station bookkeeping in AP mode.
+	  The driver uses this state for buffered multicast traffic and
+	  firmware station table management.
+
+	  If unsure, say Y.
+
+config RWNX_MON_DATA
+	bool "Monitor data interface support"
+	default y
+	help
+	  Enable monitor plus data interface support.
+	  This allows monitor-mode receive paths to coexist with normal
+	  data interfaces when firmware and hardware support it.
+
+	  If unsure, say Y.
+
+config RWNX_SW_PROFILING
+	bool "Software profiling"
+	default n
+	help
+	  Enable driver software profiling hooks.
+	  This option is intended for development builds that need timing
+	  or performance instrumentation in the FullMAC driver.
+
+	  If unsure, say N.
+
+config RWNX_DBG
+	bool "Debug log support"
+	default y
+	help
+	  Enable debug logging support in the FullMAC driver.
+	  The resulting log output can help diagnose firmware and driver
+	  interactions during bring-up and validation.
+
+	  If unsure, say Y.
+
+config RWNX_DEBUGFS
+	bool "DebugFS support"
+	depends on DEBUG_FS && BROKEN
+	default n
+	help
+	  Enable debugfs entries for the AIC8800 FullMAC driver.
+	  These files expose runtime state for debugging and are not
+	  required for normal end-user operation. The retained implementation
+	  still needs conversion to current debugfs and cfg80211 interfaces.
+
+	  If unsure, say N.
+
+config RWNX_P2P_DEBUGFS
+	bool "P2P debugfs support"
+	depends on RWNX_DEBUGFS
+	help
+	  Enable debugfs controls for P2P notice-of-absence and OppPS
+	  settings. These entries are intended for driver development and
+	  expose firmware scheduling state. They are not needed for normal
+	  P2P operation and depend on the main driver debugfs support.
+
+endmenu
+
+endif # AIC8800_WLAN_SUPPORT
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/Makefile b/drivers/net/w=
ireless/aic/aic8800_fdrv/Makefile
new file mode 100644
index 0000000000000..6bfaaa574934e
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/Makefile
@@ -0,0 +1,117 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_AIC8800_WLAN_SUPPORT) +=3D aic8800_fdrv.o
+
+aic8800_fdrv-y :=3D \
+	rwnx_msg_tx.o          \
+	rwnx_msg_rx.o          \
+	rwnx_utils.o           \
+	rwnx_cmds.o            \
+	rwnx_irqs.o            \
+	rwnx_cfgfile.o         \
+	rwnx_strs.o            \
+	rwnx_rx.o              \
+	rwnx_tx.o              \
+	rwnx_txq.o             \
+	rwnx_main.o            \
+	rwnx_mod_params.o      \
+	rwnx_mesh.o            \
+	rwnx_platform.o        \
+	aicwf_chip_8801.o          \
+	aicwf_chip_8800dc.o          \
+	aicwf_chip_8800d80.o          \
+	aicwf_chip_ops.o            \
+	rwnx_v7.o              \
+	ipc_host.o             \
+	rwnx_tdls.o            \
+	aic_vendor.o	       \
+	md5.o                  \
+	aicwf_compat_8800dc.o  \
+	aicwf_compat_8800d80.o \
+	rwnx_wakelock.o		\
+	regdb.o				   \
+	aic_priv_cmd.o		\
+	aicwf_rx_prealloc.o
+
+aic8800_fdrv-$(CONFIG_AIC8800_GENL)             		+=3D aicwf_genl.o
+aic8800_fdrv-$(CONFIG_AIC8800_BR_SUPPORT)       		+=3D aic_br_ext.o
+aic8800_fdrv-$(CONFIG_RWNX_RADAR)       		+=3D rwnx_radar.o
+aic8800_fdrv-$(CONFIG_RWNX_DEBUGFS)         	+=3D rwnx_debugfs.o
+aic8800_fdrv-$(CONFIG_RWNX_DEBUGFS)         	+=3D rwnx_fw_trace.o
+aic8800_fdrv-$(CONFIG_NL80211_TESTMODE) 		+=3D rwnx_testmode.o
+aic8800_fdrv-$(CONFIG_RWNX_BFMER)       		+=3D rwnx_bfmer.o
+aic8800_fdrv-$(CONFIG_RWNX_MUMIMO_TX)   		+=3D rwnx_mu_group.o
+aic8800_fdrv-$(CONFIG_AIC8800_SDIO_SUPPORT)     		+=3D sdio_host.o
+aic8800_fdrv-$(CONFIG_AIC8800_SDIO_SUPPORT)     		+=3D aicwf_txrxif.o
+aic8800_fdrv-$(CONFIG_AIC8800_SDIO_SUPPORT)     		+=3D aicwf_sdio.o
+aic8800_fdrv-$(CONFIG_AIC8800_FILTER_TCP_ACK)   		+=3D aicwf_tcp_ack.o
+aic8800_fdrv-$(CONFIG_AIC8800_SDIO_BT)   			+=3D aic_btsdio.o
+aic8800_fdrv-$(CONFIG_AIC8800_GKI)     				+=3D rwnx_gki.o
+aic8800_fdrv-$(CONFIG_AIC8800_USE_WIRELESS_EXT)  	+=3D aicwf_wext_linux.o
+aic8800_fdrv-$(CONFIG_AIC8800_CREATE_TRACE_POINTS) 	+=3D rwnx_trace.o
+
+ccflags-y +=3D -I$(srctree)
+ccflags-y +=3D -I$(src)
+ccflags-y +=3D -I$(src)/../aic8800_bsp
+ccflags-y +=3D -DAIC_TRACE_INCLUDE_PATH=3D$(src)
+
+ccflags-$(CONFIG_RWNX_DEBUGFS) 					+=3D -DCONFIG_RWNX_DEBUGFS
+ccflags-$(CONFIG_RWNX_P2P_DEBUGFS) 				+=3D -DCONFIG_RWNX_P2P_DEBUGFS
+ccflags-$(CONFIG_RWNX_TL4) 						+=3D -DCONFIG_RWNX_TL4
+ccflags-$(CONFIG_RWNX_OLD_IPC) 					+=3D -DCONFIG_RWNX_OLD_IPC
+ccflags-$(CONFIG_AIC8800_BSP_PLATFORM_EXTERNAL) 			+=3D -DCONFIG_PLATFORM_=
EXTERNAL
+ccflags-$(CONFIG_AIC8800_VRF_DCDC_MODE) 				+=3D -DCONFIG_VRF_DCDC_MODE
+ccflags-$(CONFIG_AIC8800_HE_FOR_OLD_KERNEL) 			+=3D -DCONFIG_HE_FOR_OLD_KE=
RNEL
+ccflags-$(CONFIG_AIC8800_COEX) 							+=3D -DCONFIG_COEX
+ccflags-$(CONFIG_RWNX_FULLMAC) 					+=3D -DCONFIG_RWNX_FULLMAC
+ccflags-$(CONFIG_RWNX_RADAR) 					+=3D -DCONFIG_RWNX_RADAR
+ccflags-$(CONFIG_RWNX_MON_DATA) 				+=3D -DCONFIG_RWNX_MON_DATA
+ccflags-$(CONFIG_RWNX_BFMER) 					+=3D -DCONFIG_RWNX_BFMER
+ccflags-$(CONFIG_RWNX_SPLIT_TX_BUF) 			+=3D -DCONFIG_RWNX_SPLIT_TX_BUF
+ccflags-$(CONFIG_RWNX_AMSDUS_TX) 				+=3D -DCONFIG_RWNX_AMSDUS_TX
+ccflags-$(CONFIG_RWNX_DBG) 						+=3D -DCONFIG_RWNX_DBG
+ccflags-$(CONFIG_RWNX_SW_PROFILING) 			+=3D -DCONFIG_RWNX_SW_PROFILING
+ccflags-$(CONFIG_RWNX_MUMIMO_TX) 				+=3D -DCONFIG_RWNX_MUMIMO_TX
+ccflags-$(CONFIG_AIC8800_USE_5G) 						+=3D -DUSE_5G
+ccflags-$(CONFIG_AIC8800_CREATE_TRACE_POINTS) 			+=3D -DAIC8800_CREATE_TRA=
CE_POINTS
+ccflags-$(CONFIG_AIC8800_TXRX_THREAD_PRIO) 				+=3D -DCONFIG_TXRX_THREAD_P=
RIO
+ccflags-$(CONFIG_AIC8800_GPIO_WAKEUP) 					+=3D -DCONFIG_GPIO_WAKEUP
+ccflags-$(CONFIG_AIC8800_SET_VENDOR_EXTENSION_IE) 		+=3D -DCONFIG_SET_VEND=
OR_EXTENSION_IE
+ccflags-$(CONFIG_AIC8800_SUPPORT_REALTIME_CHANGE_MAC) 	+=3D -DCONFIG_SUPPO=
RT_REALTIME_CHANGE_MAC
+ccflags-$(CONFIG_AIC8800_WPA3_FOR_OLD_KERNEL) 			+=3D -DCONFIG_WPA3_FOR_OL=
D_KERNEL
+ccflags-$(CONFIG_AIC8800_VHT_FOR_OLD_KERNEL) 			+=3D -DCONFIG_VHT_FOR_OLD_=
KERNEL
+ccflags-$(CONFIG_AIC8800_PREALLOC_RX_SKB) 				+=3D -DCONFIG_PREALLOC_RX_SK=
B
+ccflags-$(CONFIG_AIC8800_WIFI_SUSPEND_FOR_LINUX) 		+=3D -DCONFIG_WIFI_SUSP=
END_FOR_LINUX
+ccflags-$(CONFIG_AIC8800_USE_P2P0) 						+=3D -DCONFIG_USE_P2P0
+ccflags-$(CONFIG_AIC8800_FDRV_NO_REG_SDIO) 				+=3D -DCONFIG_FDRV_NO_REG_S=
DIO
+ccflags-$(CONFIG_AIC8800_SCHED_SCAN) 					+=3D -DCONFIG_SCHED_SCAN
+ccflags-$(CONFIG_AIC8800_OOB) 							+=3D -DCONFIG_OOB
+ccflags-$(CONFIG_AIC8800_USE_CUSTOMER_MAC) 				+=3D -DCONFIG_USE_CUSTOMER_=
MAC
+ccflags-$(CONFIG_AIC8800_PREALLOC_TXQ) 					+=3D -DCONFIG_PREALLOC_TXQ
+ccflags-$(CONFIG_AIC8800_DPD) 							+=3D -DCONFIG_DPD
+ccflags-$(CONFIG_AIC8800_FORCE_DPD_CALIB) 			+=3D -DCONFIG_FORCE_DPD_CALIB
+ccflags-$(CONFIG_AIC8800_FILTER_TCP_ACK) 				+=3D -DCONFIG_FILTER_TCP_ACK
+ccflags-$(CONFIG_AIC8800_SDIO_BT) 						+=3D -DCONFIG_SDIO_BT
+ccflags-$(CONFIG_AIC8800_RESV_MEM_SUPPORT) 				+=3D -DCONFIG_RESV_MEM_SUPP=
ORT
+ccflags-$(CONFIG_AIC8800_GKI) 							+=3D -DCONFIG_GKI
+ccflags-$(CONFIG_AIC8800_TEMP_COMP) 					+=3D -DCONFIG_TEMP_COMP
+ccflags-$(CONFIG_AIC8800_AUTO_CUSTREG) 					+=3D -DCONFIG_AUTO_CUSTREG
+ccflags-$(CONFIG_AIC8800_TEMP_CONTROL) 					+=3D -DCONFIG_TEMP_CONTROL
+ccflags-$(CONFIG_AIC8800_WOWLAN_PM) 					+=3D -DCONFIG_WOWLAN_PM
+ccflags-$(CONFIG_AIC8800_GENL) 							+=3D -DCONFIG_GENL
+ccflags-$(CONFIG_AIC8800_POWER_LIMIT) 					+=3D -DCONFIG_POWER_LIMIT
+ccflags-$(CONFIG_AIC8800_REGION_PW) 					+=3D -DCONFIG_REGION_PW
+ccflags-$(CONFIG_AIC8800_MCC) 							+=3D -DCONFIG_MCC
+ccflags-$(CONFIG_AICWF_LATENCY_MODE) 			+=3D -DAICWF_LATENCY_MODE
+ccflags-$(CONFIG_AIC8800_USE_WIRELESS_EXT) 				+=3D -DCONFIG_USE_WIRELESS_=
EXT
+ccflags-$(CONFIG_AIC8800_AUTO_POWERSAVE) 				+=3D -DCONFIG_AUTO_POWERSAVE
+ccflags-$(CONFIG_AIC8800_NO_WAKE_COUNT) 				+=3D -DCONFIG_NO_WAKE_COUNT
+ccflags-$(CONFIG_AIC8800_SDIO_SUPPORT) 					+=3D -DAICWF_SDIO_SUPPORT
+ccflags-$(CONFIG_AIC8800_SDIO_PWRCTRL) 					+=3D -DCONFIG_SDIO_PWRCTRL
+ccflags-$(CONFIG_AIC8800_BR_SUPPORT) 					+=3D -DCONFIG_BR_SUPPORT
+ccflags-$(CONFIG_AIC8800_RX_REORDER) 					+=3D -DAICWF_RX_REORDER
+ccflags-$(CONFIG_AIC8800_ARP_OFFLOAD) 					+=3D -DAICWF_ARP_OFFLOAD
+ccflags-$(CONFIG_AIC8800_RADAR_OR_IR_DETECT) 				+=3D -DRADAR_OR_IR_DETECT
+ccflags-$(CONFIG_AIC8800_RX_NETIF_RECV_SKB) 			+=3D -DCONFIG_RX_NETIF_RECV=
_SKB
+ccflags-$(CONFIG_AIC8800_ONE_TXQ)  						+=3D -DCONFIG_ONE_TXQ
+ccflags-$(CONFIG_AIC8800_TX_NETIF_FLOWCTRL) 			+=3D -DCONFIG_TX_NETIF_FLOW=
CTRL
