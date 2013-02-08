Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:63327 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947067Ab3BHUcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 15:32:53 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 13/14] cw1200: v4: Kbuild integration
Date: Fri,  8 Feb 2013 15:32:06 -0500
Message-Id: <1360355527-12159-14-git-send-email-pizza@shaftnet.org> (sfid-20130208_215345_105313_47125C15)
In-Reply-To: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/Kconfig  | 38 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/cw1200/Makefile | 22 +++++++++++++++++++++
 2 files changed, 60 insertions(+)
 create mode 100644 drivers/net/wireless/cw1200/Kconfig
 create mode 100644 drivers/net/wireless/cw1200/Makefile

diff --git a/drivers/net/wireless/cw1200/Kconfig b/drivers/net/wireless/cw1200/Kconfig
new file mode 100644
index 0000000..14d056e
--- /dev/null
+++ b/drivers/net/wireless/cw1200/Kconfig
@@ -0,0 +1,38 @@
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
+       depends on CW1200 && SPI
+       help
+         This enables support for the CW1200 via a SPI bus.
+
+menu "Driver debug features"
+      depends on CW1200 && DEBUGFS
+
+config CW1200_ETF
+       bool "Enable CW1200 Engineering Test Framework hooks"
+       help 
+       	 If you don't know what this is, just say N.
+
+config CW1200_ITP
+       bool "Enable ITP access"
+	 help 
+	 If you don't know what this is, just say N.
+
+endmenu
+
+endif
diff --git a/drivers/net/wireless/cw1200/Makefile b/drivers/net/wireless/cw1200/Makefile
new file mode 100644
index 0000000..1c7c707
--- /dev/null
+++ b/drivers/net/wireless/cw1200/Makefile
@@ -0,0 +1,22 @@
+cw1200_core-y := \
+		fwio.o \
+		txrx.o \
+		main.o \
+		queue.o \
+		hwio.o \
+		bh.o \
+		wsm.o \
+		sta.o \
+		scan.o \
+		pm.o \
+		debug.o
+cw1200_core-$(CONFIG_CW1200_ITP)	+= itp.o
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
1.8.1.2

