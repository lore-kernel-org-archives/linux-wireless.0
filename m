Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:53624 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3ALOHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:07:03 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 14/15] cw1200: v3: Kbuild integration
Date: Sat, 12 Jan 2013 09:06:14 -0500
Message-Id: <1357999575-12838-15-git-send-email-pizza@shaftnet.org> (sfid-20130112_152321_389889_7756C6AD)
In-Reply-To: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
References: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/staging/cw1200/Kconfig  | 78 +++++++++++++++++++++++++++++++++++++++++
 drivers/staging/cw1200/Makefile | 23 ++++++++++++
 2 files changed, 101 insertions(+)
 create mode 100644 drivers/staging/cw1200/Kconfig
 create mode 100644 drivers/staging/cw1200/Makefile

diff --git a/drivers/staging/cw1200/Kconfig b/drivers/staging/cw1200/Kconfig
new file mode 100644
index 0000000..6d59094
--- /dev/null
+++ b/drivers/staging/cw1200/Kconfig
@@ -0,0 +1,78 @@
+config CW1200
+       tristate "CW1200 WLAN support"
+       depends on MAC80211 && CFG80211
+       help
+         This is driver for the ST-E CW1100 & CW1200 WLAN chipsets.
+         This option just enables the driver core, see below for 
+	 specific bus support.
+
+if CW1200
+
+config CW1200_WLAN_SDIO
+       tristate "Support SDIO platforms"
+       depends on CW1200 && MMC
+       help
+         This enables support for the CW1200 via an SDIO bus.
+
+config CW1200_WLAN_SPI
+       tristate "Support SPI platforms"
+       select CW1200_USE_GPIO_IRQ
+       depends on CW1200 && SPI
+       help
+         This enables support for the CW1200 via a SPI bus.
+
+config CW1200_NON_POWER_OF_TWO_BLOCKSIZES
+      bool "Platform supports non-power-of-two SDIO transfer"
+      depends on CW1200_SDIO
+      help
+        Say N here only if you are running the driver on a platform
+        which does not have support for non-power-of-two SDIO transfer.
+        If unsure, say Y.
+
+config CW1200_USE_GPIO_IRQ
+      bool "Use GPIO interrupt"
+      depends on CW1200_SDIO
+      help
+        Say Y here if you want to include GPIO IRQ support instead of 
+	SDIO IRQ.  Note that you will be limited to 1-bit SDIO operation.
+        If unsure, say N.
+
+config CW1200_POLL_IRQ
+       bool "Poll for data to work around irq delivery bugs"
+       help
+         You should say Y if your board has problems with IRQ delibery.
+	 Otherwise say N.
+
+config CW1200_5GHZ_SUPPORT
+      bool "5GHz band support"
+      depends on CW1200
+      help
+        Say Y if your device supports 5GHz band. Should be disabled for
+        CW1100 silicon.
+        If unsure, say N.
+
+config CW1200_PM
+      bool "Enable CW1200 advanced power management"
+      depends on CW1200 && PM
+
+menu "Driver debug features"
+      depends on CW1200
+
+config CW1200_DEBUGFS
+      bool "Expose driver internals to DebugFS (DEVELOPMENT)"
+
+config CW1200_ETF
+       bool "Enable CW1200 Engineering Test Framework hooks"
+       depends on CW1200_DEBUGFS
+       help 
+       	 If you don't know what this is, just say N.
+
+config CW1200_ITP
+       bool "Enable ITP access"
+       depends on CW1200_DEBUGFS
+	 help 
+	 If you don't know what this is, just say N.
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

