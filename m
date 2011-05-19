Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:44444 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932079Ab1ESGgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 02:36:07 -0400
Received: by ewy22 with SMTP id 22so688099ewy.7
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 23:35:22 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: remove deprecated CONFIG_WL12XX_HT flag
Date: Thu, 19 May 2011 09:35:00 +0300
Message-Id: <1305786900-16380-1-git-send-email-coelho@ti.com> (sfid-20110519_083611_451833_60A2660B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver now support HT properly, so we can always have HT enabled.

Remove the WL12XX_HT configuration.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/Kconfig |   10 ----------
 drivers/net/wireless/wl12xx/main.c  |    6 ------
 drivers/net/wireless/wl12xx/rx.c    |    2 --
 drivers/net/wireless/wl12xx/tx.c    |    2 --
 4 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 35ce7b0..9baea0d 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -20,16 +20,6 @@ config WL12XX
 	  If you choose to build a module, it will be called wl12xx. Say N if
 	  unsure.
 
-config WL12XX_HT
-        bool "TI wl12xx 802.11 HT support (EXPERIMENTAL)"
-        depends on WL12XX && EXPERIMENTAL
-        default n
-        ---help---
-          This will enable 802.11 HT support in the wl12xx module.
-
-	  That configuration is temporary due to the code incomplete and
-	  still in testing process.
-
 config WL12XX_SPI
 	tristate "TI wl12xx SPI support"
 	depends on WL12XX && SPI_MASTER
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bc00e52..947e5fd 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3510,7 +3510,6 @@ static const u8 wl1271_rate_to_idx_2ghz[] = {
 /* 11n STA capabilities */
 #define HW_RX_HIGHEST_RATE	72
 
-#ifdef CONFIG_WL12XX_HT
 #define WL12XX_HT_CAP { \
 	.cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 | \
 	       (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT), \
@@ -3523,11 +3522,6 @@ static const u8 wl1271_rate_to_idx_2ghz[] = {
 		.tx_params = IEEE80211_HT_MCS_TX_DEFINED, \
 		}, \
 }
-#else
-#define WL12XX_HT_CAP { \
-	.ht_supported = false, \
-}
-#endif
 
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_supported_band wl1271_band_2ghz = {
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 7009103..95a24f1 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -57,11 +57,9 @@ static void wl1271_rx_status(struct wl1271 *wl,
 
 	status->rate_idx = wl1271_rate_to_idx(desc->rate, status->band);
 
-#ifdef CONFIG_WL12XX_HT
 	/* 11n support */
 	if (desc->rate <= CONF_HW_RXTX_RATE_MCS0)
 		status->flag |= RX_FLAG_HT;
-#endif
 
 	status->signal = desc->rssi;
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index ca3ab1c..351d62c 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -425,7 +425,6 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
 		rate_set >>= 1;
 	}
 
-#ifdef CONFIG_WL12XX_HT
 	/* MCS rates indication are on bits 16 - 23 */
 	rate_set >>= HW_HT_RATES_OFFSET - band->n_bitrates;
 
@@ -434,7 +433,6 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
 			enabled_rates |= (CONF_HW_BIT_RATE_MCS_0 << bit);
 		rate_set >>= 1;
 	}
-#endif
 
 	return enabled_rates;
 }
-- 
1.7.1

