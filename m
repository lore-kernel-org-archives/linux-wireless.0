Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42688 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1ISKvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 06:51:37 -0400
Received: by wwf22 with SMTP id 22so7795450wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 03:51:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: implement set_bitrate_mask callback
Date: Mon, 19 Sep 2011 13:51:42 +0300
Message-Id: <1316429502-2560-1-git-send-email-eliad@wizery.com> (sfid-20110919_125147_683311_9B04A095)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Save the configured bitrate, and use the min allowed rate
as the basic rate (e.g. when scanning).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   19 ++++----
 drivers/net/wireless/wl12xx/init.c   |   17 ++++---
 drivers/net/wireless/wl12xx/main.c   |   77 ++++++++++++++++++++++++----------
 drivers/net/wireless/wl12xx/scan.c   |   23 +++++++----
 drivers/net/wireless/wl12xx/tx.c     |   23 +++-------
 drivers/net/wireless/wl12xx/tx.h     |    5 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 7 files changed, 101 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 084262f..27d0cf0 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1106,6 +1106,7 @@ int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 {
 	struct sk_buff *skb;
 	int ret;
+	u32 rate;
 
 	skb = ieee80211_probereq_get(wl->hw, wl->vif, ssid, ssid_len,
 				     ie, ie_len);
@@ -1116,14 +1117,13 @@ int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 
 	wl1271_dump(DEBUG_SCAN, "PROBE REQ: ", skb->data, skb->len);
 
+	rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
 	if (band == IEEE80211_BAND_2GHZ)
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
-					      skb->data, skb->len, 0,
-					      wl->conf.tx.basic_rate);
+					      skb->data, skb->len, 0, rate);
 	else
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
-					      skb->data, skb->len, 0,
-					      wl->conf.tx.basic_rate_5);
+					      skb->data, skb->len, 0, rate);
 
 out:
 	dev_kfree_skb(skb);
@@ -1134,6 +1134,7 @@ struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 					      struct sk_buff *skb)
 {
 	int ret;
+	u32 rate;
 
 	if (!skb)
 		skb = ieee80211_ap_probereq_get(wl->hw, wl->vif);
@@ -1142,14 +1143,13 @@ struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 
 	wl1271_dump(DEBUG_SCAN, "AP PROBE REQ: ", skb->data, skb->len);
 
+	rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[wl->band]);
 	if (wl->band == IEEE80211_BAND_2GHZ)
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
-					      skb->data, skb->len, 0,
-					      wl->conf.tx.basic_rate);
+					      skb->data, skb->len, 0, rate);
 	else
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
-					      skb->data, skb->len, 0,
-					      wl->conf.tx.basic_rate_5);
+					      skb->data, skb->len, 0, rate);
 
 	if (ret < 0)
 		wl1271_error("Unable to set ap probe request template.");
@@ -1442,7 +1442,8 @@ int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 		sta_rates |= sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET;
 
 	cmd->supported_rates =
-		cpu_to_le32(wl1271_tx_enabled_rates_get(wl, sta_rates));
+		cpu_to_le32(wl1271_tx_enabled_rates_get(wl, sta_rates,
+							wl->band));
 
 	wl1271_debug(DEBUG_CMD, "new peer rates=0x%x queues=0x%x",
 		     cmd->supported_rates, sta->uapsd_queues);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 09515f5..04db64c 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -103,6 +103,7 @@ static int wl1271_ap_init_deauth_template(struct wl1271 *wl)
 {
 	struct wl12xx_disconn_template *tmpl;
 	int ret;
+	u32 rate;
 
 	tmpl = kzalloc(sizeof(*tmpl), GFP_KERNEL);
 	if (!tmpl) {
@@ -113,9 +114,9 @@ static int wl1271_ap_init_deauth_template(struct wl1271 *wl)
 	tmpl->header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					     IEEE80211_STYPE_DEAUTH);
 
+	rate = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_DEAUTH_AP,
-				      tmpl, sizeof(*tmpl), 0,
-				      wl1271_tx_min_rate_get(wl));
+				      tmpl, sizeof(*tmpl), 0, rate);
 
 out:
 	kfree(tmpl);
@@ -126,6 +127,7 @@ static int wl1271_ap_init_null_template(struct wl1271 *wl)
 {
 	struct ieee80211_hdr_3addr *nullfunc;
 	int ret;
+	u32 rate;
 
 	nullfunc = kzalloc(sizeof(*nullfunc), GFP_KERNEL);
 	if (!nullfunc) {
@@ -142,9 +144,9 @@ static int wl1271_ap_init_null_template(struct wl1271 *wl)
 	memcpy(nullfunc->addr2, wl->mac_addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, wl->mac_addr, ETH_ALEN);
 
+	rate = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, nullfunc,
-				      sizeof(*nullfunc), 0,
-				      wl1271_tx_min_rate_get(wl));
+				      sizeof(*nullfunc), 0, rate);
 
 out:
 	kfree(nullfunc);
@@ -155,6 +157,7 @@ static int wl1271_ap_init_qos_null_template(struct wl1271 *wl)
 {
 	struct ieee80211_qos_hdr *qosnull;
 	int ret;
+	u32 rate;
 
 	qosnull = kzalloc(sizeof(*qosnull), GFP_KERNEL);
 	if (!qosnull) {
@@ -171,9 +174,9 @@ static int wl1271_ap_init_qos_null_template(struct wl1271 *wl)
 	memcpy(qosnull->addr2, wl->mac_addr, ETH_ALEN);
 	memcpy(qosnull->addr3, wl->mac_addr, ETH_ALEN);
 
+	rate = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, qosnull,
-				      sizeof(*qosnull), 0,
-				      wl1271_tx_min_rate_get(wl));
+				      sizeof(*qosnull), 0, rate);
 
 out:
 	kfree(qosnull);
@@ -498,7 +501,7 @@ int wl1271_init_ap_rates(struct wl1271 *wl)
 		return ret;
 
 	/* use the min basic rate for AP broadcast/multicast */
-	rc.enabled_rates = wl1271_tx_min_rate_get(wl);
+	rc.enabled_rates = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 	rc.short_retry_limit = 10;
 	rc.long_retry_limit = 10;
 	rc.aflags = 0;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 680f558..96718c4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2099,6 +2099,8 @@ deinit:
 	wl->time_offset = 0;
 	wl->session_counter = 0;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
+	wl->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
+	wl->bitrate_masks[IEEE80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
 	wl->vif = NULL;
 	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl1271_free_ap_keys(wl);
@@ -2237,14 +2239,8 @@ out:
 
 static void wl1271_set_band_rate(struct wl1271 *wl)
 {
-	if (wl->band == IEEE80211_BAND_2GHZ) {
-		wl->basic_rate_set = wl->conf.tx.basic_rate;
-		wl->rate_set = wl->conf.tx.basic_rate;
-	} else {
-		wl->basic_rate_set = wl->conf.tx.basic_rate_5;
-		wl->rate_set = wl->conf.tx.basic_rate_5;
-	}
-
+	wl->basic_rate_set = wl->bitrate_masks[wl->band];
+	wl->rate_set = wl->basic_rate_set;
 }
 
 static bool wl12xx_is_roc(struct wl1271 *wl)
@@ -2273,7 +2269,7 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, bool idle)
 			if (ret < 0)
 				goto out;
 		}
-		wl->rate_set = wl1271_tx_min_rate_get(wl);
+		wl->rate_set = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 		ret = wl1271_acx_sta_rate_policies(wl);
 		if (ret < 0)
 			goto out;
@@ -2368,7 +2364,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 				wl1271_set_band_rate(wl);
 
-			wl->basic_rate = wl1271_tx_min_rate_get(wl);
+			wl->basic_rate =
+				wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				wl1271_warning("rate policy for channel "
@@ -3125,6 +3122,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 
 	if ((changed & BSS_CHANGED_BEACON)) {
 		struct ieee80211_hdr *hdr;
+		u32 min_rate;
 		int ieoffset = offsetof(struct ieee80211_mgmt,
 					u.beacon.variable);
 		struct sk_buff *beacon = ieee80211_beacon_get(wl->hw, vif);
@@ -3140,12 +3138,13 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 			dev_kfree_skb(beacon);
 			goto out;
 		}
+		min_rate = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 		tmpl_id = is_ap ? CMD_TEMPL_AP_BEACON :
 				  CMD_TEMPL_BEACON;
 		ret = wl1271_cmd_template_set(wl, tmpl_id,
 					      beacon->data,
 					      beacon->len, 0,
-					      wl1271_tx_min_rate_get(wl));
+					      min_rate);
 		if (ret < 0) {
 			dev_kfree_skb(beacon);
 			goto out;
@@ -3161,7 +3160,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 					      tmpl_id,
 					      beacon->data,
 					      beacon->len, 0,
-					      wl1271_tx_min_rate_get(wl));
+					      min_rate);
 		dev_kfree_skb(beacon);
 		if (ret < 0)
 			goto out;
@@ -3182,8 +3181,10 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 	if ((changed & BSS_CHANGED_BASIC_RATES)) {
 		u32 rates = bss_conf->basic_rates;
 
-		wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl, rates);
-		wl->basic_rate = wl1271_tx_min_rate_get(wl);
+		wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl, rates,
+								 wl->band);
+		wl->basic_rate = wl1271_tx_min_rate_get(wl,
+							wl->basic_rate_set);
 
 		ret = wl1271_init_ap_rates(wl);
 		if (ret < 0) {
@@ -3365,12 +3366,15 @@ sta_not_found:
 			 * to use with control frames.
 			 */
 			rates = bss_conf->basic_rates;
-			wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl,
-									 rates);
-			wl->basic_rate = wl1271_tx_min_rate_get(wl);
+			wl->basic_rate_set =
+				wl1271_tx_enabled_rates_get(wl, rates,
+							    wl->band);
+			wl->basic_rate =
+				wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 			if (sta_rate_set)
 				wl->rate_set = wl1271_tx_enabled_rates_get(wl,
-								sta_rate_set);
+								sta_rate_set,
+								wl->band);
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				goto out;
@@ -3417,7 +3421,8 @@ sta_not_found:
 
 			/* revert back to minimum rates for the current band */
 			wl1271_set_band_rate(wl);
-			wl->basic_rate = wl1271_tx_min_rate_get(wl);
+			wl->basic_rate =
+				wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				goto out;
@@ -3468,9 +3473,11 @@ sta_not_found:
 
 		if (bss_conf->ibss_joined) {
 			u32 rates = bss_conf->basic_rates;
-			wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl,
-									 rates);
-			wl->basic_rate = wl1271_tx_min_rate_get(wl);
+			wl->basic_rate_set =
+				wl1271_tx_enabled_rates_get(wl, rates,
+							    wl->band);
+			wl->basic_rate =
+				wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 
 			/* by default, use 11b rates */
 			wl->rate_set = CONF_TX_IBSS_DEFAULT_RATES;
@@ -3992,6 +3999,29 @@ out:
 	return ret;
 }
 
+static int wl12xx_set_bitrate_mask(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   const struct cfg80211_bitrate_mask *mask)
+{
+	struct wl1271 *wl = hw->priv;
+	int i;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 set_bitrate_mask 0x%x 0x%x",
+		mask->control[NL80211_BAND_2GHZ].legacy,
+		mask->control[NL80211_BAND_5GHZ].legacy);
+
+	mutex_lock(&wl->mutex);
+
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+		wl->bitrate_masks[i] =
+			wl1271_tx_enabled_rates_get(wl,
+						    mask->control[i].legacy,
+						    i);
+	mutex_unlock(&wl->mutex);
+
+	return 0;
+}
+
 static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
@@ -4267,6 +4297,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.sta_remove = wl1271_op_sta_remove,
 	.ampdu_action = wl1271_op_ampdu_action,
 	.tx_frames_pending = wl1271_tx_frames_pending,
+	.set_bitrate_mask = wl12xx_set_bitrate_mask,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
@@ -4687,6 +4718,8 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 
 	/* Apply default driver configuration. */
 	wl1271_conf_init(wl);
+	wl->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
+	wl->bitrate_masks[IEEE80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
 
 	order = get_order(WL1271_AGGR_BUFFER_SIZE);
 	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index eeccc9f..4b4d373 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -28,6 +28,7 @@
 #include "scan.h"
 #include "acx.h"
 #include "ps.h"
+#include "tx.h"
 
 void wl1271_scan_complete_work(struct work_struct *work)
 {
@@ -236,14 +237,17 @@ out:
 void wl1271_scan_stm(struct wl1271 *wl)
 {
 	int ret = 0;
+	enum ieee80211_band band;
+	u32 rate;
 
 	switch (wl->scan.state) {
 	case WL1271_SCAN_STATE_IDLE:
 		break;
 
 	case WL1271_SCAN_STATE_2GHZ_ACTIVE:
-		ret = wl1271_scan_send(wl, IEEE80211_BAND_2GHZ, false,
-				       wl->conf.tx.basic_rate);
+		band = IEEE80211_BAND_2GHZ;
+		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
+		ret = wl1271_scan_send(wl, band, false, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_2GHZ_PASSIVE;
 			wl1271_scan_stm(wl);
@@ -252,8 +256,9 @@ void wl1271_scan_stm(struct wl1271 *wl)
 		break;
 
 	case WL1271_SCAN_STATE_2GHZ_PASSIVE:
-		ret = wl1271_scan_send(wl, IEEE80211_BAND_2GHZ, true,
-				       wl->conf.tx.basic_rate);
+		band = IEEE80211_BAND_2GHZ;
+		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
+		ret = wl1271_scan_send(wl, band, true, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			if (wl->enable_11a)
 				wl->scan.state = WL1271_SCAN_STATE_5GHZ_ACTIVE;
@@ -265,8 +270,9 @@ void wl1271_scan_stm(struct wl1271 *wl)
 		break;
 
 	case WL1271_SCAN_STATE_5GHZ_ACTIVE:
-		ret = wl1271_scan_send(wl, IEEE80211_BAND_5GHZ, false,
-				       wl->conf.tx.basic_rate_5);
+		band = IEEE80211_BAND_5GHZ;
+		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
+		ret = wl1271_scan_send(wl, band, false, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_5GHZ_PASSIVE;
 			wl1271_scan_stm(wl);
@@ -275,8 +281,9 @@ void wl1271_scan_stm(struct wl1271 *wl)
 		break;
 
 	case WL1271_SCAN_STATE_5GHZ_PASSIVE:
-		ret = wl1271_scan_send(wl, IEEE80211_BAND_5GHZ, true,
-				       wl->conf.tx.basic_rate_5);
+		band = IEEE80211_BAND_5GHZ;
+		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
+		ret = wl1271_scan_send(wl, band, true, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_DONE;
 			wl1271_scan_stm(wl);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 9d4157c..33f058d 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -447,13 +447,14 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	return total_len;
 }
 
-u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
+u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
+				enum ieee80211_band rate_band)
 {
 	struct ieee80211_supported_band *band;
 	u32 enabled_rates = 0;
 	int bit;
 
-	band = wl->hw->wiphy->bands[wl->band];
+	band = wl->hw->wiphy->bands[rate_band];
 	for (bit = 0; bit < band->n_bitrates; bit++) {
 		if (rate_set & 0x1)
 			enabled_rates |= band->bitrates[bit].hw_value;
@@ -986,20 +987,10 @@ void wl1271_tx_flush(struct wl1271 *wl)
 	wl1271_warning("Unable to flush all TX buffers, timed out.");
 }
 
-u32 wl1271_tx_min_rate_get(struct wl1271 *wl)
+u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set)
 {
-	int i;
-	u32 rate = 0;
-
-	if (!wl->basic_rate_set) {
-		WARN_ON(1);
-		wl->basic_rate_set = wl->conf.tx.basic_rate;
-	}
-
-	for (i = 0; !rate; i++) {
-		if ((wl->basic_rate_set >> i) & 0x1)
-			rate = 1 << i;
-	}
+	if (WARN_ON(!rate_set))
+		return 0;
 
-	return rate;
+	return BIT(__ffs(rate_set));
 }
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index d6fdbf9..dc4f09a 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -209,8 +209,9 @@ void wl1271_tx_complete(struct wl1271 *wl);
 void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues);
 void wl1271_tx_flush(struct wl1271 *wl);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
-u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set);
-u32 wl1271_tx_min_rate_get(struct wl1271 *wl);
+u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
+				enum ieee80211_band rate_band);
+u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set);
 u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct sk_buff *skb);
 void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid);
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 3ceb20c..45f03f5 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -526,6 +526,7 @@ struct wl1271 {
 	u32 basic_rate_set;
 	u32 basic_rate;
 	u32 rate_set;
+	u32 bitrate_masks[IEEE80211_NUM_BANDS];
 
 	/* The current band */
 	enum ieee80211_band band;
-- 
1.7.6.401.g6a319

