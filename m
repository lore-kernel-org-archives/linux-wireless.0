Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22491 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0BVGlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:21 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 06/22] wl1271: Divided driver to two separate modules
Date: Mon, 22 Feb 2010 08:38:26 +0200
Message-Id: <1266820722-20202-7-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Divided wl1271 driver to wl1271 "core" and wl1271_spi modules in preparation
of integration of the SDIO implementation.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/Kconfig       |   12 ++++++++++++
 drivers/net/wireless/wl12xx/Makefile      |    5 +++--
 drivers/net/wireless/wl12xx/wl1271_main.c |    8 ++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 785e024..9c6fdcc 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -51,3 +51,15 @@ config WL1271
 
 	  If you choose to build a module, it'll be called wl1271. Say N if
 	  unsure.
+
+config WL1271_SPI
+	tristate "TI wl1251 SPI support"
+	depends on WL1271 && SPI_MASTER
+	---help---
+	  This module adds support for the SPI interface of adapters using
+	  TI wl1271 chipset.  Select this if your platform is using
+	  the SPI bus.
+
+	  If you choose to build a module, it'll be called wl1251_spi.
+	  Say N if unsure.
+
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index f47ec94..473a1e2 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -7,10 +7,11 @@ obj-$(CONFIG_WL1251)	+= wl1251.o
 obj-$(CONFIG_WL1251_SPI)	+= wl1251_spi.o
 obj-$(CONFIG_WL1251_SDIO)	+= wl1251_sdio.o
 
-wl1271-objs		= wl1271_main.o  wl1271_spi.o wl1271_cmd.o  \
+wl1271-objs		= wl1271_main.o  wl1271_cmd.o wl1271_io.o \
 			  wl1271_event.o wl1271_tx.o  wl1271_rx.o   \
 			  wl1271_ps.o    wl1271_acx.o wl1271_boot.o \
-			  wl1271_init.o  wl1271_debugfs.o wl1271_io.o
+			  wl1271_init.o  wl1271_debugfs.o
 
 wl1271-$(CONFIG_NL80211_TESTMODE)	+= wl1271_testmode.o
 obj-$(CONFIG_WL1271)	+= wl1271.o
+obj-$(CONFIG_WL1271_SPI)	+= wl1271_spi.o
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 54bc1e9..ea49ced 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1948,6 +1948,7 @@ int wl1271_register_hw(struct wl1271 *wl)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wl1271_register_hw);
 
 int wl1271_init_ieee80211(struct wl1271 *wl)
 {
@@ -1976,6 +1977,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wl1271_init_ieee80211);
 
 #define WL1271_DEFAULT_CHANNEL 0
 
@@ -2030,6 +2032,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 
 	return hw;
 }
+EXPORT_SYMBOL_GPL(wl1271_alloc_hw);
 
 int wl1271_free_hw(struct wl1271 *wl)
 {
@@ -2050,3 +2053,8 @@ int wl1271_free_hw(struct wl1271 *wl)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wl1271_free_hw);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-- 
1.6.3.3

