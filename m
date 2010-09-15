Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33746 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab0IOSbj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 14:31:39 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 03/04] wl1271: 11n Support, Scan, Connection, MCS rates
Date: Wed, 15 Sep 2010 20:31:11 +0200
Message-Id: <1284575472-19888-4-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
References: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

11n support add to scan, connection via MCS rates

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   63 +++++++++++++++++++++--------
 drivers/net/wireless/wl12xx/wl1271_rx.c   |    4 ++
 drivers/net/wireless/wl12xx/wl1271_tx.c   |    9 ++++
 3 files changed, 59 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index ae69397..e89e574 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -782,10 +782,21 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
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
@@ -1622,6 +1633,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 {
 	enum wl1271_cmd_ps_mode mode;
 	struct wl1271 *wl = hw->priv;
+	struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
 	bool do_join = false;
 	bool set_assoc = false;
 	int ret;
@@ -1837,6 +1849,21 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
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
@@ -2014,14 +2041,14 @@ static struct ieee80211_channel wl1271_channels[] = {
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
@@ -2060,6 +2087,7 @@ static struct ieee80211_supported_band wl1271_band_2ghz = {
 	.n_channels = ARRAY_SIZE(wl1271_channels),
 	.bitrates = wl1271_rates,
 	.n_bitrates = ARRAY_SIZE(wl1271_rates),
+	.ht_cap	= WL12xx_HT_CAP,
 };
 
 /* 5 GHz data rates for WL1273 */
@@ -2139,14 +2167,14 @@ static struct ieee80211_channel wl1271_channels_5ghz[] = {
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
@@ -2171,6 +2199,7 @@ static struct ieee80211_supported_band wl1271_band_5ghz = {
 	.n_channels = ARRAY_SIZE(wl1271_channels_5ghz),
 	.bitrates = wl1271_rates_5ghz,
 	.n_bitrates = ARRAY_SIZE(wl1271_rates_5ghz),
+	.ht_cap	= WL12xx_HT_CAP,
 };
 
 static const u8 *wl1271_band_rate_to_idx[] = {
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 019aa79..e752215 100644
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
index dc0b46c..3dd9766 100644
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

