Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:54200 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533Ab0JFSGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:33 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v2 03/03] wl1271: 11n Support, functionality and configuration ability
Date: Wed,  6 Oct 2010 20:08:11 +0200
Message-Id: <1286388491-28752-5-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
References: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 11n ability in scan, connection and using MCS rates.
The configuration is temporary due to the code incomplete and
still in testing process. That plans to be remove in the future.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/Kconfig       |   10 ++++
 drivers/net/wireless/wl12xx/Makefile      |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   65 +++++++++++++++++++++--------
 drivers/net/wireless/wl12xx/wl1271_rx.c   |    4 ++
 drivers/net/wireless/wl12xx/wl1271_tx.c   |    9 ++++
 5 files changed, 72 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 4a8bb25..7ecb94d 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -52,6 +52,16 @@ config WL1271
 	  If you choose to build a module, it'll be called wl1271. Say N if
 	  unsure.
 
+config WL1271_HT
+        bool "TI wl1271 802.11 HT support (EXPERIMENTAL)"
+        depends on WL1271 && EXPERIMENTAL
+        default n
+        ---help---
+          This will enable 802.11 HT support for TI wl1271 chipset.
+
+	  That configuration is temporary due to the code incomplete and
+	  still in testing process.
+
 config WL1271_SPI
 	tristate "TI wl1271 SPI support"
 	depends on WL1271 && SPI_MASTER
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index 0d334d6..92465c8 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_WL1271_SDIO)	+= wl1271_sdio.o
 
 # small builtin driver bit
 obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
+
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index bef2c24..7dd1257 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -841,10 +841,21 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	/* peek into the rates configured in the STA entry */
 	spin_lock_irqsave(&wl->wl_lock, flags);
-	if (sta && sta->supp_rates[conf->channel->band] != wl->sta_rate_set) {
+	if (sta &&
+	    (sta->supp_rates[conf->channel->band] !=
+	    (wl->sta_rate_set & HW_BG_RATES_MASK))) {
 		wl->sta_rate_set = sta->supp_rates[conf->channel->band];
 		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
 	}
+
+	if (sta &&
+	    sta->ht_cap.ht_supported &&
+	    ((wl->sta_rate_set >> HW_HT_RATES_OFFSET) !=
+	      sta->ht_cap.mcs.rx_mask[0])) {
+		wl->sta_rate_set |=
+		(sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
+		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
+	}
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	/* queue the packet */
@@ -1697,6 +1708,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 {
 	enum wl1271_cmd_ps_mode mode;
 	struct wl1271 *wl = hw->priv;
+	struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
 	bool do_join = false;
 	bool set_assoc = false;
 	int ret;
@@ -1915,6 +1927,21 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (sta) {
+		if (changed & BSS_CHANGED_HT) {
+			ret = wl1271_acx_set_ht_capabilities(wl,
+							     &sta->ht_cap,
+							     true);
+			ret = wl1271_acx_set_ht_information(wl,
+						bss_conf->ht_operation_mode);
+			}
+		else
+			if (changed & BSS_CHANGED_ASSOC)
+				ret = wl1271_acx_set_ht_capabilities(wl,
+								&sta->ht_cap,
+								false);
+	}
+
 	if (changed & BSS_CHANGED_ARP_FILTER) {
 		__be32 addr = bss_conf->arp_addr_list[0];
 		WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
@@ -2095,14 +2122,14 @@ static struct ieee80211_channel wl1271_channels[] = {
 /* mapping to indexes for wl1271_rates */
 static const u8 wl1271_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS7 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS6 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS5 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS4 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS3 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS2 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS1 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS0 */
+	7,                            /* CONF_HW_RXTX_RATE_MCS7 */
+	6,                            /* CONF_HW_RXTX_RATE_MCS6 */
+	5,                            /* CONF_HW_RXTX_RATE_MCS5 */
+	4,                            /* CONF_HW_RXTX_RATE_MCS4 */
+	3,                            /* CONF_HW_RXTX_RATE_MCS3 */
+	2,                            /* CONF_HW_RXTX_RATE_MCS2 */
+	1,                            /* CONF_HW_RXTX_RATE_MCS1 */
+	0,                            /* CONF_HW_RXTX_RATE_MCS0 */
 
 	11,                            /* CONF_HW_RXTX_RATE_54   */
 	10,                            /* CONF_HW_RXTX_RATE_48   */
@@ -2141,6 +2168,9 @@ static struct ieee80211_supported_band wl1271_band_2ghz = {
 	.n_channels = ARRAY_SIZE(wl1271_channels),
 	.bitrates = wl1271_rates,
 	.n_bitrates = ARRAY_SIZE(wl1271_rates),
+#ifdef CONFIG_WL1271_HT
+	.ht_cap	= WL12xx_HT_CAP,
+#endif
 };
 
 /* 5 GHz data rates for WL1273 */
@@ -2223,14 +2253,14 @@ static struct ieee80211_channel wl1271_channels_5ghz[] = {
 /* mapping to indexes for wl1271_rates_5ghz */
 static const u8 wl1271_rate_to_idx_5ghz[] = {
 	/* MCS rates are used only with 11n */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS7 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS6 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS5 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS4 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS3 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS2 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS1 */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS0 */
+	7,                            /* CONF_HW_RXTX_RATE_MCS7 */
+	6,                            /* CONF_HW_RXTX_RATE_MCS6 */
+	5,                            /* CONF_HW_RXTX_RATE_MCS5 */
+	4,                            /* CONF_HW_RXTX_RATE_MCS4 */
+	3,                            /* CONF_HW_RXTX_RATE_MCS3 */
+	2,                            /* CONF_HW_RXTX_RATE_MCS2 */
+	1,                            /* CONF_HW_RXTX_RATE_MCS1 */
+	0,                            /* CONF_HW_RXTX_RATE_MCS0 */
 
 	7,                             /* CONF_HW_RXTX_RATE_54   */
 	6,                             /* CONF_HW_RXTX_RATE_48   */
@@ -2255,6 +2285,7 @@ static struct ieee80211_supported_band wl1271_band_5ghz = {
 	.n_channels = ARRAY_SIZE(wl1271_channels_5ghz),
 	.bitrates = wl1271_rates_5ghz,
 	.n_bitrates = ARRAY_SIZE(wl1271_rates_5ghz),
+	.ht_cap	= WL12xx_HT_CAP,
 };
 
 static const u8 *wl1271_band_rate_to_idx[] = {
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 94da5dd..109a470 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -53,6 +53,10 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	status->band = wl->band;
 	status->rate_idx = wl1271_rate_to_idx(wl, desc->rate);
 
+	/* 11n support */
+	if (desc->rate <= CONF_HW_RXTX_RATE_MCS0)
+		status->flag |= RX_FLAG_HT;
+
 	status->signal = desc->rssi;
 
 	/*
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 1b8295c..af54fef 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -236,6 +236,15 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
 		rate_set >>= 1;
 	}
 
+	/* MCS rates indication are on bits 16 - 23 */
+	rate_set >>= HW_HT_RATES_OFFSET - band->n_bitrates;
+
+	for (bit = 0; bit < 8; bit++) {
+		if (rate_set & 0x1)
+			enabled_rates |= (CONF_HW_BIT_RATE_MCS_0 << bit);
+		rate_set >>= 1;
+	}
+
 	return enabled_rates;
 }
 
-- 
1.6.0.4

