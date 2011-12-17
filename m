Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1532 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760992Ab1LQChh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:37 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 30/30] brcm80211: fmac: add Kconfig option for SDIO bus
 support
Date: Fri, 16 Dec 2011 18:37:20 -0800
Message-ID: <1324089440-8957-31-git-send-email-frankyl@broadcom.com> (sfid-20111217_035946_329584_A6C2D755)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a Kconfig option for SDIO bus support and abstracts
a build subset correspondingly. It's the final patch of fullmac bus
interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/Kconfig           |   18 ++++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/Makefile |   22 +++++++++++-----------
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index 8f54c2e..cd6375d 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -17,16 +17,26 @@ config BRCMSMAC
 
 config BRCMFMAC
 	tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
-	depends on MMC
 	depends on CFG80211
 	select BRCMUTIL
-	select FW_LOADER
 	---help---
 	  This module adds support for embedded wireless adapters based on
-	  Broadcom IEEE802.11n FullMAC chipsets.  This driver uses the kernel's
-	  wireless extensions subsystem.  If you choose to build a module,
+	  Broadcom IEEE802.11n FullMAC chipsets. It has to work with at least
+	  one of the bus interface support. If you choose to build a module,
 	  it'll be called brcmfmac.ko.
 
+config BRCMFMAC_SDIO
+	bool "SDIO bus interface support for FullMAC"
+	depends on MMC
+	depends on BRCMFMAC
+	select FW_LOADER
+	default y
+	---help---
+	  This option enables the SDIO bus interface support for Broadcom
+	  FullMAC WLAN driver.
+	  Say Y if you want to use brcmfmac for a compatible SDIO interface
+	  wireless card.
+
 config BRCMDBG
 	bool "Broadcom driver debug functions"
 	depends on BRCMSMAC || BRCMFMAC
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index d58aa1b..9ca9ea1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -19,16 +19,16 @@ ccflags-y += \
 	-Idrivers/net/wireless/brcm80211/brcmfmac	\
 	-Idrivers/net/wireless/brcm80211/include
 
-DHDOFILES = \
-	wl_cfg80211.o \
-	dhd_cdc.o \
-	dhd_common.o \
-	dhd_sdio.o	\
-	dhd_linux.o \
-	bcmsdh.o \
-	bcmsdh_sdmmc.o \
-	sdio_chip.o
-
 obj-$(CONFIG_BRCMFMAC) += brcmfmac.o
-brcmfmac-objs += $(DHDOFILES)
+brcmfmac-objs += \
+		wl_cfg80211.o \
+		dhd_cdc.o \
+		dhd_common.o \
+		dhd_linux.o
+brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
+		dhd_sdio.o \
+		bcmsdh.o \
+		bcmsdh_sdmmc.o \
+		sdio_chip.o
+
 ccflags-y += -D__CHECK_ENDIAN__
-- 
1.7.5.4


