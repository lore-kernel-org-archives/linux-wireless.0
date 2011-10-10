Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1JJINM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:12 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:12 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 21/29] wl12xx: add band field to wlvif
Date: Mon, 10 Oct 2011 10:13:09 +0200
Message-Id: <1318234397-21081-22-git-send-email-eliad@wizery.com> (sfid-20111010_101337_910153_D45E6CD5)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add band field into the per-interface data.

mac80211 configures some values (e.g. band, channel)
globally, while we configure them per-interface.

In order to make it easier to keep track of the
configured value for each value while keeping sync
with mac80211, save these values both globally
and per-vif.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   32 +++++++++++++++++---------------
 drivers/net/wireless/wl12xx/cmd.h    |    5 +++--
 drivers/net/wireless/wl12xx/event.c  |    2 +-
 drivers/net/wireless/wl12xx/main.c   |   32 ++++++++++++++++++++------------
 drivers/net/wireless/wl12xx/ps.c     |    2 +-
 drivers/net/wireless/wl12xx/scan.c   |    2 +-
 drivers/net/wireless/wl12xx/tx.c     |    5 +++--
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
 8 files changed, 49 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index ff653e8..6cf8cdc 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -481,7 +481,7 @@ int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	wl1271_debug(DEBUG_CMD, "cmd role start dev %d", wlvif->dev_role_id);
 
 	cmd->role_id = wlvif->dev_role_id;
-	if (wl->band == IEEE80211_BAND_5GHZ)
+	if (wlvif->band == IEEE80211_BAND_5GHZ)
 		cmd->band = WL12XX_BAND_5GHZ;
 	cmd->channel = wl->channel;
 
@@ -571,7 +571,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	wl1271_debug(DEBUG_CMD, "cmd role start sta %d", wlvif->role_id);
 
 	cmd->role_id = wlvif->role_id;
-	if (wl->band == IEEE80211_BAND_5GHZ)
+	if (wlvif->band == IEEE80211_BAND_5GHZ)
 		cmd->band = WL12XX_BAND_5GHZ;
 	cmd->channel = wl->channel;
 	cmd->sta.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
@@ -704,7 +704,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	cmd->ap.local_rates = cpu_to_le32(0xffffffff);
 
-	switch (wl->band) {
+	switch (wlvif->band) {
 	case IEEE80211_BAND_2GHZ:
 		cmd->band = RADIO_BAND_2_4GHZ;
 		break;
@@ -712,7 +712,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		cmd->band = RADIO_BAND_5GHZ;
 		break;
 	default:
-		wl1271_warning("ap start - unknown band: %d", (int)wl->band);
+		wl1271_warning("ap start - unknown band: %d", (int)wlvif->band);
 		cmd->band = RADIO_BAND_2_4GHZ;
 		break;
 	}
@@ -785,7 +785,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	wl1271_debug(DEBUG_CMD, "cmd role start ibss %d", wlvif->role_id);
 
 	cmd->role_id = wlvif->role_id;
-	if (wl->band == IEEE80211_BAND_5GHZ)
+	if (wlvif->band == IEEE80211_BAND_5GHZ)
 		cmd->band = WL12XX_BAND_5GHZ;
 	cmd->channel = wl->channel;
 	cmd->ibss.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
@@ -1157,8 +1157,8 @@ struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 
 	wl1271_dump(DEBUG_SCAN, "AP PROBE REQ: ", skb->data, skb->len);
 
-	rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[wl->band]);
-	if (wl->band == IEEE80211_BAND_2GHZ)
+	rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[wlvif->band]);
+	if (wlvif->band == IEEE80211_BAND_2GHZ)
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
 					      skb->data, skb->len, 0, rate);
 	else
@@ -1428,7 +1428,8 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
+int wl12xx_cmd_add_peer(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			struct ieee80211_sta *sta, u8 hlid)
 {
 	struct wl12xx_cmd_add_peer *cmd;
 	int i, ret;
@@ -1455,13 +1456,13 @@ int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 		else
 			cmd->psd_type[i] = WL1271_PSD_LEGACY;
 
-	sta_rates = sta->supp_rates[wl->band];
+	sta_rates = sta->supp_rates[wlvif->band];
 	if (sta->ht_cap.ht_supported)
 		sta_rates |= sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET;
 
 	cmd->supported_rates =
 		cpu_to_le32(wl1271_tx_enabled_rates_get(wl, sta_rates,
-							wl->band));
+							wlvif->band));
 
 	wl1271_debug(DEBUG_CMD, "new peer rates=0x%x queues=0x%x",
 		     cmd->supported_rates, sta->uapsd_queues);
@@ -1601,7 +1602,8 @@ out:
 	return ret;
 }
 
-static int wl12xx_cmd_roc(struct wl1271 *wl, u8 role_id)
+static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			  u8 role_id)
 {
 	struct wl12xx_cmd_roc *cmd;
 	int ret = 0;
@@ -1619,7 +1621,7 @@ static int wl12xx_cmd_roc(struct wl1271 *wl, u8 role_id)
 
 	cmd->role_id = role_id;
 	cmd->channel = wl->channel;
-	switch (wl->band) {
+	switch (wlvif->band) {
 	case IEEE80211_BAND_2GHZ:
 		cmd->band = RADIO_BAND_2_4GHZ;
 		break;
@@ -1627,7 +1629,7 @@ static int wl12xx_cmd_roc(struct wl1271 *wl, u8 role_id)
 		cmd->band = RADIO_BAND_5GHZ;
 		break;
 	default:
-		wl1271_error("roc - unknown band: %d", (int)wl->band);
+		wl1271_error("roc - unknown band: %d", (int)wlvif->band);
 		ret = -EINVAL;
 		goto out_free;
 	}
@@ -1674,14 +1676,14 @@ out:
 	return ret;
 }
 
-int wl12xx_roc(struct wl1271 *wl, u8 role_id)
+int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id)
 {
 	int ret = 0;
 
 	if (WARN_ON(test_bit(role_id, wl->roc_map)))
 		return 0;
 
-	ret = wl12xx_cmd_roc(wl, role_id);
+	ret = wl12xx_cmd_roc(wl, wlvif, role_id);
 	if (ret < 0)
 		goto out;
 
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 8182cf1..968d5bd 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -80,9 +80,10 @@ int wl1271_cmd_set_ap_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			  u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
 			  u16 tx_seq_16);
 int wl12xx_cmd_set_peer_state(struct wl1271 *wl, u8 hlid);
-int wl12xx_roc(struct wl1271 *wl, u8 role_id);
+int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id);
 int wl12xx_croc(struct wl1271 *wl, u8 role_id);
-int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid);
+int wl12xx_cmd_add_peer(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			struct ieee80211_sta *sta, u8 hlid);
 int wl12xx_cmd_remove_peer(struct wl1271 *wl, u8 hlid);
 int wl12xx_cmd_config_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_start_fwlog(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index a47312d..fd2e7b2 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -145,7 +145,7 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 		 * BET has only a minor effect in 5GHz and masks
 		 * channel switch IEs, so we only enable BET on 2.4GHz
 		*/
-		if (wl->band == IEEE80211_BAND_2GHZ)
+		if (wlvif->band == IEEE80211_BAND_2GHZ)
 			/* enable beacon early termination */
 			ret = wl1271_acx_bet_enable(wl, wlvif, true);
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 90f04f1..0974ed6 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1968,6 +1968,12 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->beacon_int = WL1271_DEFAULT_BEACON_INT;
 
+	/*
+	 * mac80211 configures some values globally, while we treat them
+	 * per-interface. thus, on init, we have to copy them from wl
+	 */
+	wlvif->band = wl->band;
+
 	INIT_WORK(&wlvif->rx_streaming_enable_work,
 		  wl1271_rx_streaming_enable_work);
 	INIT_WORK(&wlvif->rx_streaming_disable_work,
@@ -2327,7 +2333,7 @@ out:
 
 static void wl1271_set_band_rate(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
-	wlvif->basic_rate_set = wlvif->bitrate_masks[wl->band];
+	wlvif->basic_rate_set = wlvif->bitrate_masks[wlvif->band];
 	wlvif->rate_set = wlvif->basic_rate_set;
 }
 
@@ -2380,7 +2386,7 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (ret < 0)
 			goto out;
 
-		ret = wl12xx_roc(wl, wlvif->dev_role_id);
+		ret = wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
 		if (ret < 0)
 			goto out;
 		clear_bit(WL1271_FLAG_IDLE, &wl->flags);
@@ -2441,11 +2447,12 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	/* if the channel changes while joined, join again */
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
-	    ((wl->band != conf->channel->band) ||
+	    ((wlvif->band != conf->channel->band) ||
 	     (wl->channel != channel))) {
 		/* send all pending packets */
 		wl1271_tx_work_locked(wl);
 		wl->band = conf->channel->band;
+		wlvif->band = conf->channel->band;
 		wl->channel = channel;
 
 		if (!is_ap) {
@@ -2492,7 +2499,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 					if (ret < 0)
 						goto out_sleep;
 
-					ret = wl12xx_roc(wl,
+					ret = wl12xx_roc(wl, wlvif,
 							 wlvif->dev_role_id);
 					if (ret < 0)
 						wl1271_warning("roc failed %d",
@@ -3410,7 +3417,7 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 		u32 rates = bss_conf->basic_rates;
 
 		wlvif->basic_rate_set = wl1271_tx_enabled_rates_get(wl, rates,
-								 wl->band);
+								 wlvif->band);
 		wlvif->basic_rate = wl1271_tx_min_rate_get(wl,
 							wlvif->basic_rate_set);
 
@@ -3506,7 +3513,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 					       &wlvif->flags)) {
 				wl1271_unjoin(wl, wlvif);
 				wl12xx_cmd_role_start_dev(wl, wlvif);
-				wl12xx_roc(wl, wlvif->dev_role_id);
+				wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
 			}
 		}
 	}
@@ -3585,7 +3592,7 @@ sta_not_found:
 			rates = bss_conf->basic_rates;
 			wlvif->basic_rate_set =
 				wl1271_tx_enabled_rates_get(wl, rates,
-							    wl->band);
+							    wlvif->band);
 			wlvif->basic_rate =
 				wl1271_tx_min_rate_get(wl,
 						       wlvif->basic_rate_set);
@@ -3593,7 +3600,7 @@ sta_not_found:
 				wlvif->rate_set =
 					wl1271_tx_enabled_rates_get(wl,
 								sta_rate_set,
-								wl->band);
+								wlvif->band);
 			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 			if (ret < 0)
 				goto out;
@@ -3684,7 +3691,8 @@ sta_not_found:
 				wl1271_unjoin(wl, wlvif);
 				if (!(conf_flags & IEEE80211_CONF_IDLE)) {
 					wl12xx_cmd_role_start_dev(wl, wlvif);
-					wl12xx_roc(wl, wlvif->dev_role_id);
+					wl12xx_roc(wl, wlvif,
+						   wlvif->dev_role_id);
 				}
 			}
 		}
@@ -3698,7 +3706,7 @@ sta_not_found:
 			u32 rates = bss_conf->basic_rates;
 			wlvif->basic_rate_set =
 				wl1271_tx_enabled_rates_get(wl, rates,
-							    wl->band);
+							    wlvif->band);
 			wlvif->basic_rate =
 				wl1271_tx_min_rate_get(wl,
 						       wlvif->basic_rate_set);
@@ -3752,7 +3760,7 @@ sta_not_found:
 
 		/* ROC until connected (after EAPOL exchange) */
 		if (!is_ibss) {
-			ret = wl12xx_roc(wl, wlvif->role_id);
+			ret = wl12xx_roc(wl, wlvif, wlvif->role_id);
 			if (ret < 0)
 				goto out;
 
@@ -4058,7 +4066,7 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out_free_sta;
 
-	ret = wl12xx_cmd_add_peer(wl, sta, hlid);
+	ret = wl12xx_cmd_add_peer(wl, wlvif, sta, hlid);
 	if (ret < 0)
 		goto out_sleep;
 
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 8cd81ce..8153408 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -178,7 +178,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		wl1271_debug(DEBUG_PSM, "leaving psm");
 
 		/* disable beacon early termination */
-		if (wl->band == IEEE80211_BAND_2GHZ) {
+		if (wlvif->band == IEEE80211_BAND_2GHZ) {
 			ret = wl1271_acx_bet_enable(wl, wlvif, false);
 			if (ret < 0)
 				return ret;
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 765f08b..2711438 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -77,7 +77,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	    !test_bit(wlvif->dev_role_id, wl->roc_map)) {
 		/* restore remain on channel */
 		wl12xx_cmd_role_start_dev(wl, wlvif);
-		wl12xx_roc(wl, wlvif->dev_role_id);
+		wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
 	}
 	wl1271_ps_elp_sleep(wl);
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 9589446..be06abf 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -102,7 +102,7 @@ static int wl1271_tx_update_filters(struct wl1271 *wl,
 	if (ret < 0)
 		goto out;
 
-	ret = wl12xx_roc(wl, wlvif->dev_role_id);
+	ret = wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
 	if (ret < 0)
 		goto out;
 out:
@@ -809,7 +809,8 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	if (result->status == TX_SUCCESS) {
 		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 			info->flags |= IEEE80211_TX_STAT_ACK;
-		rate = wl1271_rate_to_idx(result->rate_class_index, wl->band);
+		rate = wl1271_rate_to_idx(result->rate_class_index,
+					  wlvif->band);
 		retries = result->ack_failures;
 	} else if (result->status == TX_RETRY_EXCEEDED) {
 		wl->stats.excessive_retries++;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b76713d..20188ea 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -589,6 +589,9 @@ struct wl12xx_vif {
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 
+	/* The current band */
+	enum ieee80211_band band;
+
 	u32 bitrate_masks[IEEE80211_NUM_BANDS];
 	u32 basic_rate_set;
 
-- 
1.7.6.401.g6a319

