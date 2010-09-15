Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:39184 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab0IOSbk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 14:31:40 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 04/04] wl1271: 11n Support, 11n Kconfig Configurable
Date: Wed, 15 Sep 2010 20:31:12 +0200
Message-Id: <1284575472-19888-5-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
References: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to configurable 11n

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/Kconfig       |    7 +++++++
 drivers/net/wireless/wl12xx/Makefile      |    4 ++++
 drivers/net/wireless/wl12xx/wl1271_main.c |    2 ++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 4a8bb25..1d5e5fd 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -52,6 +52,13 @@ config WL1271
 	  If you choose to build a module, it'll be called wl1271. Say N if
 	  unsure.
 
+config WL1271_80211_HT
+        bool "TI wl1271 802.11 HT support (EXPERIMENTAL)"
+        depends on WL1271 && EXPERIMENTAL
+        default y
+        ---help---
+          This will enable 802.11 HT support for TI wl1271 chipset.
+
 config WL1271_SPI
 	tristate "TI wl1271 SPI support"
 	depends on WL1271 && SPI_MASTER
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index 078b439..e0db9db 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -16,3 +16,7 @@ wl1271-$(CONFIG_NL80211_TESTMODE)	+= wl1271_testmode.o
 obj-$(CONFIG_WL1271)	+= wl1271.o
 obj-$(CONFIG_WL1271_SPI)	+= wl1271_spi.o
 obj-$(CONFIG_WL1271_SDIO)	+= wl1271_sdio.o
+
+ifeq ($(CONFIG_WL1271_80211_HT),y)
+EXTRA_CFLAGS += -DCONFIG_WL1271_HT
+endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index e89e574..8f2cea9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2087,7 +2087,9 @@ static struct ieee80211_supported_band wl1271_band_2ghz = {
 	.n_channels = ARRAY_SIZE(wl1271_channels),
 	.bitrates = wl1271_rates,
 	.n_bitrates = ARRAY_SIZE(wl1271_rates),
+#ifdef CONFIG_WL1271_HT
 	.ht_cap	= WL12xx_HT_CAP,
+#endif
 };
 
 /* 5 GHz data rates for WL1273 */
-- 
1.6.0.4

