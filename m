Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6615 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab0H0Q4u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/27] iwlwifi: move virtual interface pointer into context
Date: Fri, 27 Aug 2010 09:59:37 -0700
Message-Id: <1282928395-32762-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwlwifi occasionally needs to find the virtual
interface pointer to give it to mac80211, but right
now it only keeps one. Move it into the context so
that we can keep one pointer each.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   10 ++++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   17 +++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   12 ++++--
 drivers/net/wireless/iwlwifi/iwl-core.c     |   48 +++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +++-
 10 files changed, 66 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 0cfc7a6..d707f5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -932,7 +932,7 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 
 	rcu_read_lock();
 
-	sta = ieee80211_find_sta(priv->vif,
+	sta = ieee80211_find_sta(priv->contexts[IWL_RXON_CTX_BSS].vif,
 				 priv->stations[sta_id].sta.sta.addr);
 	if (!sta) {
 		IWL_DEBUG_RATE(priv, "Unable to find station to initialize rate scaling.\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index c155816..1d6a46d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1462,7 +1462,7 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv,
 	u32 tsf_low;
 	u8 switch_count;
 	u16 beacon_interval = le16_to_cpu(ctx->timing.beacon_interval);
-	struct ieee80211_vif *vif = priv->vif;
+	struct ieee80211_vif *vif = ctx->vif;
 	band = priv->band == IEEE80211_BAND_2GHZ;
 
 	is_ht40 = is_ht40_channel(ctx->staging.flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d67031f..1dbb124 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -287,7 +287,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 	u32 tsf_low;
 	u8 switch_count;
 	u16 beacon_interval = le16_to_cpu(ctx->timing.beacon_interval);
-	struct ieee80211_vif *vif = priv->vif;
+	struct ieee80211_vif *vif = ctx->vif;
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
 		.len = sizeof(cmd),
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 8c4a98b..2fdba08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -210,7 +210,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	u32 tsf_low;
 	u8 switch_count;
 	u16 beacon_interval = le16_to_cpu(ctx->timing.beacon_interval);
-	struct ieee80211_vif *vif = priv->vif;
+	struct ieee80211_vif *vif = ctx->vif;
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
 		.len = sizeof(cmd),
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index cb3c173..7002d7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1720,6 +1720,7 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 {
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, bt_traffic_change_work);
+	struct iwl_rxon_context *ctx;
 	int smps_request = -1;
 
 	IWL_DEBUG_INFO(priv, "BT traffic load changes: %d\n",
@@ -1747,9 +1748,12 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 	if (priv->cfg->ops->lib->update_chain_flags)
 		priv->cfg->ops->lib->update_chain_flags(priv);
 
-	if (smps_request != -1 &&
-	    priv->vif && priv->vif->type == NL80211_IFTYPE_STATION)
-		ieee80211_request_smps(priv->vif, smps_request);
+	if (smps_request != -1) {
+		for_each_context(priv, ctx) {
+			if (ctx->vif && ctx->vif->type == NL80211_IFTYPE_STATION)
+				ieee80211_request_smps(ctx->vif, smps_request);
+		}
+	}
 
 	mutex_unlock(&priv->mutex);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index bff593a..64daddd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1120,6 +1120,9 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 	struct iwl_queue *q = &priv->txq[txq_id].q;
 	u8 *addr = priv->stations[sta_id].sta.sta.addr;
 	struct iwl_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
+	struct iwl_rxon_context *ctx;
+
+	ctx = &priv->contexts[priv->stations[sta_id].ctxid];
 
 	lockdep_assert_held(&priv->sta_lock);
 
@@ -1135,7 +1138,7 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			priv->cfg->ops->lib->txq_agg_disable(priv, txq_id,
 							     ssn, tx_fifo);
 			tid_data->agg.state = IWL_AGG_OFF;
-			ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, addr, tid);
+			ieee80211_stop_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
 		}
 		break;
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -1143,7 +1146,7 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 		if (tid_data->tfds_in_queue == 0) {
 			IWL_DEBUG_HT(priv, "HW queue empty: continue ADDBA flow\n");
 			tid_data->agg.state = IWL_AGG_ON;
-			ieee80211_start_tx_ba_cb_irqsafe(priv->vif, addr, tid);
+			ieee80211_start_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
 		}
 		break;
 	}
@@ -1151,14 +1154,14 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 	return 0;
 }
 
-static void iwlagn_tx_status(struct iwl_priv *priv, struct sk_buff *skb)
+static void iwlagn_tx_status(struct iwl_priv *priv, struct iwl_tx_info *tx_info)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx_info->skb->data;
 	struct ieee80211_sta *sta;
 	struct iwl_station_priv *sta_priv;
 
 	rcu_read_lock();
-	sta = ieee80211_find_sta(priv->vif, hdr->addr1);
+	sta = ieee80211_find_sta(tx_info->ctx->vif, hdr->addr1);
 	if (sta) {
 		sta_priv = (void *)sta->drv_priv;
 		/* avoid atomic ops if this isn't a client */
@@ -1168,7 +1171,7 @@ static void iwlagn_tx_status(struct iwl_priv *priv, struct sk_buff *skb)
 	}
 	rcu_read_unlock();
 
-	ieee80211_tx_status_irqsafe(priv->hw, skb);
+	ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb);
 }
 
 int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
@@ -1191,7 +1194,7 @@ int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		iwlagn_tx_status(priv, tx_info->skb);
+		iwlagn_tx_status(priv, tx_info);
 
 		hdr = (struct ieee80211_hdr *)tx_info->skb->data;
 		if (hdr && ieee80211_is_data_qos(hdr->frame_control))
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 007dede..5e1df24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -603,7 +603,9 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 	struct sk_buff *beacon;
 
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
-	beacon = ieee80211_beacon_get(priv->hw, priv->vif);
+#warning "introduce and use beacon context"
+	beacon = ieee80211_beacon_get(priv->hw,
+			priv->contexts[IWL_RXON_CTX_BSS].vif);
 
 	if (!beacon) {
 		IWL_ERR(priv, "update beacon failed\n");
@@ -3154,13 +3156,15 @@ static void iwl_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
+		struct iwl_rxon_context *ctx;
 		bool bt_sco, bt_full_concurrent;
 		u8 bt_ci_compliance;
 		u8 bt_load;
 		u8 bt_status;
 
 		mutex_lock(&priv->mutex);
-		priv->vif = NULL;
+		for_each_context(priv, ctx)
+			ctx->vif = NULL;
 		priv->is_open = 0;
 
 		/*
@@ -3838,7 +3842,7 @@ static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
 			iwl_set_rxon_channel(priv, channel, ctx);
 			iwl_set_rxon_ht(priv, ht_conf);
 			iwl_set_flags_for_band(priv, ctx, channel->band,
-					       priv->vif);
+					       ctx->vif);
 			spin_unlock_irqrestore(&priv->lock, flags);
 
 			iwl_set_rate(priv);
@@ -3855,7 +3859,7 @@ out:
 	mutex_unlock(&priv->mutex);
 out_exit:
 	if (!priv->switch_rxon.switch_in_progress)
-		ieee80211_chswitch_done(priv->vif, false);
+		ieee80211_chswitch_done(ctx->vif, false);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d5499db..f9abcd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1133,11 +1133,17 @@ EXPORT_SYMBOL(iwl_set_rate);
 
 void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 {
+	/*
+	 * MULTI-FIXME
+	 * See iwl_mac_channel_switch.
+	 */
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	if (priv->switch_rxon.switch_in_progress) {
-		ieee80211_chswitch_done(priv->vif, is_success);
+		ieee80211_chswitch_done(ctx->vif, is_success);
 		mutex_lock(&priv->mutex);
 		priv->switch_rxon.switch_in_progress = false;
 		mutex_unlock(&priv->mutex);
@@ -1149,9 +1155,11 @@ void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
-#if !TODO
+	/*
+	 * MULTI-FIXME
+	 * See iwl_mac_channel_switch.
+	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-#endif
 	struct iwl_rxon_cmd *rxon = (void *)&ctx->active;
 
 	if (priv->switch_rxon.switch_in_progress) {
@@ -1735,7 +1743,9 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	priv->cfg->ops->lib->post_associate(priv, priv->vif);
+#warning "use beacon context?"
+	priv->cfg->ops->lib->post_associate(
+			priv, priv->contexts[IWL_RXON_CTX_BSS].vif);
 
 	return 0;
 }
@@ -1927,6 +1937,7 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+	struct iwl_rxon_context *ctx;
 	int err = 0;
 
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
@@ -1934,20 +1945,23 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	mutex_lock(&priv->mutex);
 
-	vif_priv->ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	/* For now always use this context. */
+	ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+
+	vif_priv->ctx = ctx;
 
 	if (WARN_ON(!iwl_is_ready_rf(priv))) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	if (priv->vif) {
+	if (ctx->vif) {
 		IWL_DEBUG_MAC80211(priv, "leave - vif != NULL\n");
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	priv->vif = vif;
+	ctx->vif = vif;
 	priv->iw_mode = vif->type;
 
 	err = iwl_set_mode(priv, vif);
@@ -1967,7 +1981,7 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	goto out;
 
  out_err:
-	priv->vif = NULL;
+	ctx->vif = NULL;
 	priv->iw_mode = NL80211_IFTYPE_STATION;
  out:
 	mutex_unlock(&priv->mutex);
@@ -1993,14 +2007,11 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 		ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv, ctx);
 	}
-	if (priv->vif == vif) {
-		priv->vif = NULL;
-		if (priv->scan_vif == vif) {
-			scan_completed = true;
-			priv->scan_vif = NULL;
-			priv->scan_request = NULL;
-		}
-		memset(priv->bssid, 0, ETH_ALEN);
+
+	if (priv->scan_vif == vif) {
+		scan_completed = true;
+		priv->scan_vif = NULL;
+		priv->scan_request = NULL;
 	}
 
 	/*
@@ -2013,6 +2024,9 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_ADHOC)
 		priv->bt_traffic_load = priv->notif_bt_traffic_load;
 
+	WARN_ON(ctx->vif != vif);
+	ctx->vif = NULL;
+	memset(priv->bssid, 0, ETH_ALEN);
 	mutex_unlock(&priv->mutex);
 
 	if (scan_completed)
@@ -2117,7 +2131,7 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 			iwl_set_rxon_ht(priv, ht_conf);
 
 			iwl_set_flags_for_band(priv, ctx, channel->band,
-					       priv->vif);
+					       ctx->vif);
 		}
 
 		spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 90bf6b3..a332ec5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1114,6 +1114,7 @@ enum iwl_rxon_context_id {
 };
 
 struct iwl_rxon_context {
+	struct ieee80211_vif *vif;
 	enum iwl_rxon_context_id ctxid;
 	/*
 	 * We declare this const so it can only be
@@ -1321,7 +1322,6 @@ struct iwl_priv {
 
 	/* Last Rx'd beacon timestamp */
 	u64 timestamp;
-	struct ieee80211_vif *vif;
 
 	union {
 #if defined(CONFIG_IWL3945) || defined(CONFIG_IWL3945_MODULE)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index aef5f81..6b56295 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -802,7 +802,8 @@ static void iwl3945_bg_beacon_update(struct work_struct *work)
 	struct sk_buff *beacon;
 
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
-	beacon = ieee80211_beacon_get(priv->hw, priv->vif);
+	beacon = ieee80211_beacon_get(priv->hw,
+			priv->contexts[IWL_RXON_CTX_BSS].vif);
 
 	if (!beacon) {
 		IWL_ERR(priv, "update beacon failed\n");
@@ -3048,8 +3049,10 @@ static void iwl3945_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
+		struct iwl_rxon_context *ctx;
 		mutex_lock(&priv->mutex);
-		priv->vif = NULL;
+		for_each_context(priv, ctx)
+			ctx->vif = NULL;
 		priv->is_open = 0;
 		mutex_unlock(&priv->mutex);
 		iwl3945_down(priv);
-- 
1.7.0.4

