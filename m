Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:34300 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2LVPpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 10:45:52 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 16/17] cw1200:  Integration into the kernel build system
Date: Sat, 22 Dec 2012 10:45:19 -0500
Message-Id: <1356191120-5280-17-git-send-email-pizza@shaftnet.org> (sfid-20121222_164608_117682_BDA1247A)
In-Reply-To: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
References: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm leaving it under staging/ for now, unless I'm told otherwise.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/staging/cw1200/Kconfig  | 116 ++++++++++++++++++++++++++++++++++++++++
 drivers/staging/cw1200/Makefile |  23 ++++++++
 2 files changed, 139 insertions(+)
 create mode 100644 drivers/staging/cw1200/Kconfig
 create mode 100644 drivers/staging/cw1200/Makefile

diff --git a/drivers/staging/cw1200/Kconfig b/drivers/staging/cw1200/Kconfig
new file mode 100644
index 0000000..07bebb0
--- /dev/null
+++ b/drivers/staging/cw1200/Kconfig
@@ -0,0 +1,116 @@
+config CW1200
+       tristate "CW1200 WLAN support"
+       select MAC80211
+       select CFG80211
+       help
+
+         This is an experimental driver for the cw1100/1200 WLAN chipset.
+         This option just enables the driver core, see below for specific
+         platform support.
+
+if CW1200
+
+config CW1200_WLAN_SDIO
+       tristate "Support SDIO platforms"
+       depends on CW1200 && MMC
+
+config CW1200_WLAN_SPI
+       tristate "Support SPI platforms"
+       select CW1200_USE_GPIO_IRQ
+       depends on CW1200 && SPI
+
+config CW1200_NON_POWER_OF_TWO_BLOCKSIZES
+      bool "Platform supports non-power-of-two SDIO transfer"
+      depends on CW1200_SDIO
+      help
+        Say N here only if you are running the driver on a platform
+        which does not have support for non-power-of-two SDIO transfer.
+        If unsure, say Y.
+
+config CW1200_SDIO_CMD53_WORKAROUND
+	bool "Workaround for 512-byte CMD53 transfers"
+	depends on CW1200_SDIO
+	help
+	  Say Y here if you are using a kernel older than 3.2-rc2 or
+	  did not apply 300-cw1200_sdio_quirk.diff to the kernel tree.
+	  If unsure, say Y.
+
+config CW1200_USE_GPIO_IRQ
+      bool "Use GPIO interrupt"
+      depends on CW1200_SDIO
+      help
+        Say Y here if you want to include GPIO IRQ support instead of 
+	SDIO IRQ.  Note that you will be limited to 1-bit SDIO operation.
+        If unsure, say N.
+
+config CW1200_5GHZ_SUPPORT
+      bool "5GHz band support"
+      depends on CW1200
+      help
+        Say Y if your device supports 5GHz band. Should be disabled for
+        CW1100 silicon.
+        If unsure, say N.
+
+config CW1200_WAPI_SUPPORT
+      bool "WAPI support"
+      depends on CW1200
+      help
+        Say Y if your compat-wireless support WAPI.
+        If unsure, say N.
+
+config CW1200_PM
+      bool "Enable CW1200 advanced power management"
+      depends on CW1200 && PM
+
+config CW1200_USE_STE_EXTENSIONS
+      bool "STE extensions"
+      depends on CW1200
+      help
+        Say Y if you want to include STE extensions.
+        If unsure, say N.
+
+menu "Driver debug features"
+      depends on CW1200
+
+config CW1200_DEBUGFS
+      bool "Expose driver internals to DebugFS (DEVELOPMENT)"
+
+config CW1200_BH_DEBUG
+      bool "Enable low-level device communication logs (DEVELOPMENT)"
+
+config CW1200_WSM_DEBUG
+      bool "Enable WSM API debug messages (DEVELOPMENT)"
+
+config CW1200_WSM_DUMPS
+      bool "Verbose WSM API logging (DEVELOPMENT)"
+
+config CW1200_WSM_DUMPS_SHORT
+      bool "Dump only first x bytes (default 20) (DEVELOPMENT)"
+
+config CW1200_TXRX_DEBUG
+      bool "Enable TX/RX debug messages (DEVELOPMENT)"
+
+config CW1200_TX_POLICY_DEBUG
+      bool "Enable TX policy debug (DEVELOPMENT)"
+
+config CW1200_STA_DEBUG
+      bool "Enable STA/AP debug (DEVELOPMENT)"
+
+config CW1200_ETF
+       bool "Enable CW1200 Engineering Test Framework hooks"
+
+config CW1200_POLL_IRQ
+       bool "Poll for data to work around irq delivery bugs"
+       help
+         You should say Y if you have an iMX51-based board with a Freescale
+	 Kernel, and possibly others.  Otherwise say N.
+
+config CW1200_ITP
+      bool "Enable ITP DebugFS"
+      help
+        Say Y if you want to include ITP code.
+        If unsure, say N.
+
+endmenu
+
+endif
diff --git a/drivers/staging/cw1200/Makefile b/drivers/staging/cw1200/Makefile
new file mode 100644
index 0000000..2d5e8ad
--- /dev/null
+++ b/drivers/staging/cw1200/Makefile
@@ -0,0 +1,23 @@
+cw1200_core-y := \
+		fwio.o \
+		txrx.o \
+		main.o \
+		queue.o \
+		hwio.o \
+		bh.o \
+		wsm.o \
+		sta.o \
+		ap.o \
+		scan.o
+cw1200_core-$(CONFIG_CW1200_DEBUGFS)	+= debug.o
+cw1200_core-$(CONFIG_CW1200_ITP)	+= itp.o
+cw1200_core-$(CONFIG_CW1200_PM)		+= pm.o
+
+cw1200_wlan_sdio-y := cw1200_sdio.o
+cw1200_wlan_spi-y := cw1200_spi.o
+
+obj-$(CONFIG_CW1200) += cw1200_core.o
+obj-$(CONFIG_CW1200_WLAN_SDIO) += cw1200_wlan_sdio.o
+obj-$(CONFIG_CW1200_WLAN_SPI) += cw1200_wlan_spi.o
+
+
-- 
1.7.11.7

