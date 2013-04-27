Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:50835 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3D0T2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 15:28:12 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 14/14] cw1200: v6: Kbuild integration and MAINTAINERS entry
Date: Sat, 27 Apr 2013 15:27:27 -0400
Message-Id: <1367090847-11937-15-git-send-email-pizza@shaftnet.org> (sfid-20130427_212936_483822_1272130C)
In-Reply-To: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
References: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 MAINTAINERS                          |  5 ++++
 drivers/net/wireless/Kconfig         |  1 +
 drivers/net/wireless/Makefile        |  3 +++
 drivers/net/wireless/cw1200/Kconfig  | 46 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/cw1200/Makefile | 25 ++++++++++++++++++++
 5 files changed, 80 insertions(+)
 create mode 100644 drivers/net/wireless/cw1200/Kconfig
 create mode 100644 drivers/net/wireless/cw1200/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 8bdd7a7..c791d9e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2266,6 +2266,11 @@ M:	Jaya Kumar <jayakumar.alsa@gmail.com>
 S:	Maintained
 F:	sound/pci/cs5535audio/
 
+CW1200 WLAN driver
+M:     Solomon Peachy <pizza@shaftnet.org>
+S:     Maintained
+F:     drivers/net/wireless/cw1200/
+
 CX18 VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
 L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index f8f0156..200020e 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -280,5 +280,6 @@ source "drivers/net/wireless/rtlwifi/Kconfig"
 source "drivers/net/wireless/ti/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/mwifiex/Kconfig"
+source "drivers/net/wireless/cw1200/Kconfig"
 
 endif # WLAN
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 67156ef..56532fa 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -57,3 +57,6 @@ obj-$(CONFIG_MWIFIEX)	+= mwifiex/
 
 obj-$(CONFIG_BRCMFMAC)	+= brcm80211/
 obj-$(CONFIG_BRCMSMAC)	+= brcm80211/
+
+obj-$(CONFIG_CW1200)	+= cw1200/
+
diff --git a/drivers/net/wireless/cw1200/Kconfig b/drivers/net/wireless/cw1200/Kconfig
new file mode 100644
index 0000000..de57443
--- /dev/null
+++ b/drivers/net/wireless/cw1200/Kconfig
@@ -0,0 +1,46 @@
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
+config CW1200_WLAN_SAGRAD
+       tristate "Support Sagrad SG901-1091/1098 modules"
+       depends on CW1200_WLAN_SDIO
+       help
+	 This provides the platform data glue to support the
+	 Sagrad SG901-1091/1098 modules in their standard SDIO EVK.
+	 It also includes example SPI platform data.
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
index 0000000..a92a87d
--- /dev/null
+++ b/drivers/net/wireless/cw1200/Makefile
@@ -0,0 +1,25 @@
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
+# CFLAGS_sta.o += -DDEBUG
+
+cw1200_wlan_sdio-y := cw1200_sdio.o
+cw1200_wlan_spi-y := cw1200_spi.o
+cw1200_wlan_sagrad-y := cw1200_sagrad.o
+
+obj-$(CONFIG_CW1200) += cw1200_core.o
+obj-$(CONFIG_CW1200_WLAN_SDIO) += cw1200_wlan_sdio.o
+obj-$(CONFIG_CW1200_WLAN_SPI) += cw1200_wlan_spi.o
+obj-$(CONFIG_CW1200_WLAN_SAGRAD) += cw1200_wlan_sagrad.o
+
-- 
1.8.1.4

