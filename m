Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54982 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1JJIMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:43 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so5615227wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:43 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/29] wl12xx: move bitrate_masks into wlvif
Date: Mon, 10 Oct 2011 10:12:53 +0200
Message-Id: <1318234397-21081-6-git-send-email-eliad@wizery.com> (sfid-20111010_101247_190003_6707C6C1)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move bitrate_masks into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   13 ++++++++-----
 drivers/net/wireless/wl12xx/cmd.h    |    3 ++-
 drivers/net/wireless/wl12xx/main.c   |   16 ++++++++--------
 drivers/net/wireless/wl12xx/scan.c   |   21 +++++++++++----------
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +--
 5 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 102a8a5..ff653e8 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1111,15 +1111,16 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_build_probe_req(struct wl1271 *wl,
+int wl1271_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			       const u8 *ssid, size_t ssid_len,
 			       const u8 *ie, size_t ie_len, u8 band)
 {
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct sk_buff *skb;
 	int ret;
 	u32 rate;
 
-	skb = ieee80211_probereq_get(wl->hw, wl->vif, ssid, ssid_len,
+	skb = ieee80211_probereq_get(wl->hw, vif, ssid, ssid_len,
 				     ie, ie_len);
 	if (!skb) {
 		ret = -ENOMEM;
@@ -1128,7 +1129,7 @@ int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 
 	wl1271_dump(DEBUG_SCAN, "PROBE REQ: ", skb->data, skb->len);
 
-	rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
+	rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
 	if (band == IEEE80211_BAND_2GHZ)
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
 					      skb->data, skb->len, 0, rate);
@@ -1142,19 +1143,21 @@ out:
 }
 
 struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
+					      struct wl12xx_vif *wlvif,
 					      struct sk_buff *skb)
 {
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	int ret;
 	u32 rate;
 
 	if (!skb)
-		skb = ieee80211_ap_probereq_get(wl->hw, wl->vif);
+		skb = ieee80211_ap_probereq_get(wl->hw, vif);
 	if (!skb)
 		goto out;
 
 	wl1271_dump(DEBUG_SCAN, "AP PROBE REQ: ", skb->data, skb->len);
 
-	rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[wl->band]);
+	rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[wl->band]);
 	if (wl->band == IEEE80211_BAND_2GHZ)
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
 					      skb->data, skb->len, 0, rate);
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index d2670d3..8182cf1 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -59,10 +59,11 @@ int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 int wl12xx_cmd_build_null_data(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_cmd_build_ps_poll(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			     u16 aid);
-int wl1271_cmd_build_probe_req(struct wl1271 *wl,
+int wl1271_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			       const u8 *ssid, size_t ssid_len,
 			       const u8 *ie, size_t ie_len, u8 band);
 struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
+					      struct wl12xx_vif *wlvif,
 					      struct sk_buff *skb);
 int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			     __be32 ip_addr);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index e53829a..acfc497 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1906,7 +1906,7 @@ static u8 wl12xx_get_role_type(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	return WL12XX_INVALID_ROLE_TYPE;
 }
 
-static int wl12xx_init_vif_data(struct ieee80211_vif *vif)
+static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 
@@ -1949,6 +1949,8 @@ static int wl12xx_init_vif_data(struct ieee80211_vif *vif)
 		wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
 	}
 
+	wlvif->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
+	wlvif->bitrate_masks[IEEE80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
 	wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
@@ -2058,7 +2060,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ret = wl12xx_init_vif_data(vif);
+	ret = wl12xx_init_vif_data(wl, vif);
 	if (ret < 0)
 		goto out;
 
@@ -2178,8 +2180,6 @@ deinit:
 	wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
 
 	wl12xx_tx_reset_wlvif(wl, wlvif);
-	wl->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
-	wl->bitrate_masks[IEEE80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
 	wl1271_free_ap_keys(wl, wlvif);
 	memset(wlvif->ap.sta_hlid_map, 0, sizeof(wlvif->ap.sta_hlid_map));
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
@@ -2293,7 +2293,7 @@ out:
 
 static void wl1271_set_band_rate(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
-	wlvif->basic_rate_set = wl->bitrate_masks[wl->band];
+	wlvif->basic_rate_set = wlvif->bitrate_masks[wl->band];
 	wlvif->rate_set = wlvif->basic_rate_set;
 }
 
@@ -3578,6 +3578,7 @@ sta_not_found:
 			 */
 			dev_kfree_skb(wlvif->probereq);
 			wlvif->probereq = wl1271_cmd_build_ap_probe_req(wl,
+									wlvif,
 									NULL);
 			ieoffset = offsetof(struct ieee80211_mgmt,
 					    u.probe_req.variable);
@@ -4202,6 +4203,7 @@ static int wl12xx_set_bitrate_mask(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   const struct cfg80211_bitrate_mask *mask)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271 *wl = hw->priv;
 	int i;
 
@@ -4212,7 +4214,7 @@ static int wl12xx_set_bitrate_mask(struct ieee80211_hw *hw,
 	mutex_lock(&wl->mutex);
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
-		wl->bitrate_masks[i] =
+		wlvif->bitrate_masks[i] =
 			wl1271_tx_enabled_rates_get(wl,
 						    mask->control[i].legacy,
 						    i);
@@ -4931,8 +4933,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 
 	/* Apply default driver configuration. */
 	wl1271_conf_init(wl);
-	wl->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
-	wl->bitrate_masks[IEEE80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
 
 	order = get_order(WL1271_AGGR_BUFFER_SIZE);
 	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 9372136..e1a8ce0 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -66,7 +66,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
 		/* restore hardware connection monitoring template */
-		wl1271_cmd_build_ap_probe_req(wl, wlvif->probereq);
+		wl1271_cmd_build_ap_probe_req(wl, wlvif, wlvif->probereq);
 	}
 
 	/* return to ROC if needed */
@@ -218,9 +218,9 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 
 	memcpy(cmd->addr, vif->addr, ETH_ALEN);
 
-	ret = wl1271_cmd_build_probe_req(wl, wl->scan.ssid, wl->scan.ssid_len,
-					 wl->scan.req->ie, wl->scan.req->ie_len,
-					 band);
+	ret = wl1271_cmd_build_probe_req(wl, wlvif, wl->scan.ssid,
+					 wl->scan.ssid_len, wl->scan.req->ie,
+					 wl->scan.req->ie_len, band);
 	if (ret < 0) {
 		wl1271_error("PROBE request template failed");
 		goto out;
@@ -251,6 +251,7 @@ out:
 
 void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret = 0;
 	enum ieee80211_band band;
 	u32 rate;
@@ -261,7 +262,7 @@ void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif)
 
 	case WL1271_SCAN_STATE_2GHZ_ACTIVE:
 		band = IEEE80211_BAND_2GHZ;
-		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
+		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
 		ret = wl1271_scan_send(wl, vif, band, false, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_2GHZ_PASSIVE;
@@ -272,7 +273,7 @@ void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif)
 
 	case WL1271_SCAN_STATE_2GHZ_PASSIVE:
 		band = IEEE80211_BAND_2GHZ;
-		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
+		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
 		ret = wl1271_scan_send(wl, vif, band, true, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			if (wl->enable_11a)
@@ -286,7 +287,7 @@ void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif)
 
 	case WL1271_SCAN_STATE_5GHZ_ACTIVE:
 		band = IEEE80211_BAND_5GHZ;
-		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
+		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
 		ret = wl1271_scan_send(wl, vif, band, false, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_5GHZ_PASSIVE;
@@ -297,7 +298,7 @@ void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif)
 
 	case WL1271_SCAN_STATE_5GHZ_PASSIVE:
 		band = IEEE80211_BAND_5GHZ;
-		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
+		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
 		ret = wl1271_scan_send(wl, vif, band, true, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_DONE;
@@ -642,7 +643,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	}
 
 	if (!force_passive && cfg->active[0]) {
-		ret = wl1271_cmd_build_probe_req(wl, req->ssids[0].ssid,
+		ret = wl1271_cmd_build_probe_req(wl, wlvif, req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[IEEE80211_BAND_2GHZ],
 						 ies->len[IEEE80211_BAND_2GHZ],
@@ -654,7 +655,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	}
 
 	if (!force_passive && cfg->active[1]) {
-		ret = wl1271_cmd_build_probe_req(wl,  req->ssids[0].ssid,
+		ret = wl1271_cmd_build_probe_req(wl, wlvif, req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[IEEE80211_BAND_5GHZ],
 						 ies->len[IEEE80211_BAND_5GHZ],
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 4802f68..33ccdf8 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -484,8 +484,6 @@ struct wl1271 {
 
 	bool sched_scanning;
 
-	u32 bitrate_masks[IEEE80211_NUM_BANDS];
-
 	/* The current band */
 	enum ieee80211_band band;
 
@@ -600,6 +598,7 @@ struct wl12xx_vif {
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 
+	u32 bitrate_masks[IEEE80211_NUM_BANDS];
 	u32 basic_rate_set;
 
 	/*
-- 
1.7.6.401.g6a319

