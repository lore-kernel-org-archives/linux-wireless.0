Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52484 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab2KTLUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:20:15 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2346757eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:20:14 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 03/11] wlcore: implement .remain_on_channel() callback
Date: Tue, 20 Nov 2012 13:20:03 +0200
Message-Id: <1353410411-18833-4-git-send-email-eliad@wizery.com> (sfid-20121120_122022_867419_EFA5BBB3)
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

implement the reamin_on_channel() callback by starting
a dev role (already associated with the current vif)
on the requested channel/band.

This channel is usually different from the channel
of the sta role, so pass it to wl12xx_roc() as well,
and notify mac80211 (async) when the fw is ready
on the new channel.

Now, in case of offchannel tx, we should use the dev
role hlid, instead of the sta hlid.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: pass band as well (thanks Arik!)
    squash patch [6/15] into this one.

 drivers/net/wireless/ti/wlcore/cmd.c    |   41 +++-----
 drivers/net/wireless/ti/wlcore/cmd.h    |    6 +-
 drivers/net/wireless/ti/wlcore/event.c  |    7 ++
 drivers/net/wireless/ti/wlcore/main.c   |  154 +++++++++++++++++++++++++++----
 drivers/net/wireless/ti/wlcore/tx.c     |    8 ++
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +
 6 files changed, 173 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index eaef3f4..38fa8ff 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -345,7 +345,9 @@ static u8 wlcore_get_native_channel_type(u8 nl_channel_type)
 }
 
 static int wl12xx_cmd_role_start_dev(struct wl1271 *wl,
-				     struct wl12xx_vif *wlvif)
+				     struct wl12xx_vif *wlvif,
+				     enum ieee80211_band band,
+				     int channel)
 {
 	struct wl12xx_cmd_role_start *cmd;
 	int ret;
@@ -359,9 +361,9 @@ static int wl12xx_cmd_role_start_dev(struct wl1271 *wl,
 	wl1271_debug(DEBUG_CMD, "cmd role start dev %d", wlvif->dev_role_id);
 
 	cmd->role_id = wlvif->dev_role_id;
-	if (wlvif->band == IEEE80211_BAND_5GHZ)
+	if (band == IEEE80211_BAND_5GHZ)
 		cmd->band = WLCORE_BAND_5GHZ;
-	cmd->channel = wlvif->channel;
+	cmd->channel = channel;
 
 	if (wlvif->dev_hlid == WL12XX_INVALID_LINK_ID) {
 		ret = wl12xx_allocate_link(wl, wlvif, &wlvif->dev_hlid);
@@ -1591,12 +1593,12 @@ out:
 }
 
 static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			  u8 role_id)
+			  u8 role_id, enum ieee80211_band band, u8 channel)
 {
 	struct wl12xx_cmd_roc *cmd;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_CMD, "cmd roc %d (%d)", wlvif->channel, role_id);
+	wl1271_debug(DEBUG_CMD, "cmd roc %d (%d)", channel, role_id);
 
 	if (WARN_ON(role_id == WL12XX_INVALID_ROLE_ID))
 		return -EINVAL;
@@ -1608,8 +1610,8 @@ static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	}
 
 	cmd->role_id = role_id;
-	cmd->channel = wlvif->channel;
-	switch (wlvif->band) {
+	cmd->channel = channel;
+	switch (band) {
 	case IEEE80211_BAND_2GHZ:
 		cmd->band = WLCORE_BAND_2_4GHZ;
 		break;
@@ -1664,30 +1666,18 @@ out:
 	return ret;
 }
 
-int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id)
+int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id,
+	       enum ieee80211_band band, u8 channel)
 {
 	int ret = 0;
-	bool is_first_roc;
 
 	if (WARN_ON(test_bit(role_id, wl->roc_map)))
 		return 0;
 
-	is_first_roc = (find_first_bit(wl->roc_map, WL12XX_MAX_ROLES) >=
-			WL12XX_MAX_ROLES);
-
-	ret = wl12xx_cmd_roc(wl, wlvif, role_id);
+	ret = wl12xx_cmd_roc(wl, wlvif, role_id, band, channel);
 	if (ret < 0)
 		goto out;
 
-	if (is_first_roc) {
-		ret = wl1271_cmd_wait_for_event(wl,
-					   REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID);
-		if (ret < 0) {
-			wl1271_error("cmd roc event completion error");
-			goto out;
-		}
-	}
-
 	__set_bit(role_id, wl->roc_map);
 out:
 	return ret;
@@ -1780,7 +1770,8 @@ out:
 }
 
 /* start dev role and roc on its channel */
-int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		     enum ieee80211_band band, int channel)
 {
 	int ret;
 
@@ -1795,11 +1786,11 @@ int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (ret < 0)
 		goto out;
 
-	ret = wl12xx_cmd_role_start_dev(wl, wlvif);
+	ret = wl12xx_cmd_role_start_dev(wl, wlvif, band, channel);
 	if (ret < 0)
 		goto out_disable;
 
-	ret = wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
+	ret = wl12xx_roc(wl, wlvif, wlvif->dev_role_id, band, channel);
 	if (ret < 0)
 		goto out_stop;
 
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 2409f3d..3be2e92 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -39,7 +39,8 @@ int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_stop_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif);
-int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		     enum ieee80211_band band, int channel);
 int wl12xx_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
@@ -76,7 +77,8 @@ int wl1271_cmd_set_ap_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			  u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
 			  u16 tx_seq_16);
 int wl12xx_cmd_set_peer_state(struct wl1271 *wl, u8 hlid);
-int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id);
+int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id,
+	       enum ieee80211_band band, u8 channel);
 int wl12xx_croc(struct wl1271 *wl, u8 role_id);
 int wl12xx_cmd_add_peer(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			struct ieee80211_sta *sta, u8 hlid);
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 4890705..cf45aaf 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -250,6 +250,13 @@ static int wl1271_event_process(struct wl1271 *wl)
 		disconnect_sta = true;
 	}
 
+	if (vector & REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID) {
+		wl1271_debug(DEBUG_EVENT,
+			     "REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID");
+		if (wl->roc_vif)
+			ieee80211_ready_on_channel(wl->hw);
+	}
+
 	if (disconnect_sta) {
 		u32 num_packets = wl->conf.tx.max_tx_retries;
 		struct ieee80211_sta *sta;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index be60394..e9a8092 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2723,24 +2723,6 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			if (ret < 0)
 				wl1271_warning("rate policy for channel "
 					       "failed %d", ret);
-
-			/*
-			 * change the ROC channel. do it only if we are
-			 * not idle. otherwise, CROC will be called
-			 * anyway.
-			 */
-			if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED,
-				      &wlvif->flags) &&
-			    wl12xx_dev_role_started(wlvif) &&
-			    !(conf->flags & IEEE80211_CONF_IDLE)) {
-				ret = wl12xx_stop_dev(wl, wlvif);
-				if (ret < 0)
-					return ret;
-
-				ret = wl12xx_start_dev(wl, wlvif);
-				if (ret < 0)
-					return ret;
-			}
 		}
 	}
 
@@ -4057,7 +4039,8 @@ sta_not_found:
 
 		/* ROC until connected (after EAPOL exchange) */
 		if (!is_ibss) {
-			ret = wl12xx_roc(wl, wlvif, wlvif->role_id);
+			ret = wl12xx_roc(wl, wlvif, wlvif->role_id,
+					 wlvif->band, wlvif->channel);
 			if (ret < 0)
 				goto out;
 		}
@@ -4692,6 +4675,134 @@ static void wlcore_op_flush(struct ieee80211_hw *hw, bool drop)
 	wl1271_tx_flush(wl);
 }
 
+static int wlcore_op_remain_on_channel(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_channel *chan,
+				       enum nl80211_channel_type channel_type,
+				       int duration)
+{
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl1271 *wl = hw->priv;
+	int channel, ret = 0;
+
+	channel = ieee80211_frequency_to_channel(chan->center_freq);
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 roc %d (%d)",
+		     channel, wlvif->role_id);
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	/* return EBUSY if we can't ROC right now */
+	if (WARN_ON(wl->roc_vif ||
+		    find_first_bit(wl->roc_map,
+				   WL12XX_MAX_ROLES) < WL12XX_MAX_ROLES)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl12xx_start_dev(wl, wlvif, chan->band, channel);
+	if (ret < 0)
+		goto out_sleep;
+
+	wl->roc_vif = vif;
+	ieee80211_queue_delayed_work(hw, &wl->roc_complete_work,
+				     msecs_to_jiffies(duration));
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+	return ret;
+}
+
+static int __wlcore_roc_completed(struct wl1271 *wl)
+{
+	struct wl12xx_vif *wlvif;
+	int ret;
+
+	/* already completed */
+	if (unlikely(!wl->roc_vif))
+		return 0;
+
+	wlvif = wl12xx_vif_to_data(wl->roc_vif);
+
+	if (!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags))
+		return -EBUSY;
+
+	ret = wl12xx_stop_dev(wl, wlvif);
+	if (ret < 0)
+		return ret;
+
+	wl->roc_vif = NULL;
+
+	return 0;
+}
+
+static int wlcore_roc_completed(struct wl1271 *wl)
+{
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "roc complete");
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = __wlcore_roc_completed(wl);
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static void wlcore_roc_complete_work(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct wl1271 *wl;
+	int ret;
+
+	dwork = container_of(work, struct delayed_work, work);
+	wl = container_of(dwork, struct wl1271, roc_complete_work);
+
+	ret = wlcore_roc_completed(wl);
+	if (!ret)
+		ieee80211_remain_on_channel_expired(wl->hw);
+}
+
+static int wlcore_op_cancel_remain_on_channel(struct ieee80211_hw *hw)
+{
+	struct wl1271 *wl = hw->priv;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 croc");
+
+	/* TODO: per-vif */
+	wl1271_tx_flush(wl);
+
+	/*
+	 * we can't just flush_work here, because it might deadlock
+	 * (as we might get called from the same workqueue)
+	 */
+	cancel_delayed_work_sync(&wl->roc_complete_work);
+	wlcore_roc_completed(wl);
+
+	return 0;
+}
+
 static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
@@ -4883,6 +4994,8 @@ static const struct ieee80211_ops wl1271_ops = {
 	.set_bitrate_mask = wl12xx_set_bitrate_mask,
 	.channel_switch = wl12xx_op_channel_switch,
 	.flush = wlcore_op_flush,
+	.remain_on_channel = wlcore_op_remain_on_channel,
+	.cancel_remain_on_channel = wlcore_op_cancel_remain_on_channel,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
@@ -5279,6 +5392,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->max_sched_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
 		sizeof(struct ieee80211_header);
 
+	wl->hw->wiphy->max_remain_on_channel_duration = 5000;
+
 	wl->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD |
 				WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
@@ -5377,6 +5492,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size)
 	INIT_WORK(&wl->tx_work, wl1271_tx_work);
 	INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
 	INIT_DELAYED_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
+	INIT_DELAYED_WORK(&wl->roc_complete_work, wlcore_roc_complete_work);
 	INIT_DELAYED_WORK(&wl->tx_watchdog_work, wl12xx_tx_watchdog_work);
 	INIT_DELAYED_WORK(&wl->connection_loss_work,
 			  wl1271_connection_loss_work);
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index a555a70..cf6dbee 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -155,12 +155,20 @@ static u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		      struct sk_buff *skb, struct ieee80211_sta *sta)
 {
+	struct ieee80211_tx_info *control;
+
 	if (!wlvif || wl12xx_is_dummy_packet(wl, skb))
 		return wl->system_hlid;
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl12xx_tx_get_hlid_ap(wl, wlvif, skb, sta);
 
+	control = IEEE80211_SKB_CB(skb);
+	if (control->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
+		wl1271_debug(DEBUG_TX, "tx offchannel");
+		return wlvif->dev_hlid;
+	}
+
 	return wlvif->sta.hlid;
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 1030b6b..b636f1d 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -286,6 +286,9 @@ struct wl1271 {
 	/* Connection loss work */
 	struct delayed_work connection_loss_work;
 
+	struct ieee80211_vif *roc_vif;
+	struct delayed_work roc_complete_work;
+
 	bool sched_scanning;
 
 	/* The current band */
-- 
1.7.6.401.g6a319

