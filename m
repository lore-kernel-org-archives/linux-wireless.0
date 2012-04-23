Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab2DWVxA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:53:00 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 29/29] iwlwifi: use new mac80211 queue scheme
Date: Mon, 23 Apr 2012 14:47:40 -0700
Message-Id: <1335217660-21950-30-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235321_061627_73A2AE09)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   13 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   89 +++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   32 +++++++---
 4 files changed, 66 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 587cfe6..f2e9f29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -463,6 +463,10 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	else
 		txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
 
+	WARN_ON_ONCE(!is_agg && txq_id != info->hw_queue);
+	WARN_ON_ONCE(is_agg &&
+		     priv->queue_to_mac80211[txq_id] != info->hw_queue);
+
 	if (iwl_trans_tx(priv->trans, skb, dev_cmd, txq_id))
 		goto drop_unlock_sta;
 
@@ -492,14 +496,14 @@ drop_unlock_priv:
 	return -1;
 }
 
-static int iwlagn_alloc_agg_txq(struct iwl_priv *priv, int ac)
+static int iwlagn_alloc_agg_txq(struct iwl_priv *priv, int mq)
 {
 	int q;
 
 	for (q = IWLAGN_FIRST_AMPDU_QUEUE;
 	     q < priv->cfg->base_params->num_of_queues; q++) {
 		if (!test_and_set_bit(q, priv->agg_q_alloc)) {
-			priv->queue_to_ac[q] = ac;
+			priv->queue_to_mac80211[q] = mq;
 			return q;
 		}
 	}
@@ -510,7 +514,7 @@ static int iwlagn_alloc_agg_txq(struct iwl_priv *priv, int ac)
 static void iwlagn_dealloc_agg_txq(struct iwl_priv *priv, int q)
 {
 	clear_bit(q, priv->agg_q_alloc);
-	priv->queue_to_ac[q] = IWL_INVALID_AC;
+	priv->queue_to_mac80211[q] = IWL_INVALID_MAC80211_QUEUE;
 }
 
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
@@ -602,6 +606,7 @@ turn_off:
 int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 	struct iwl_tid_data *tid_data;
 	int sta_id, txq_id, ret;
 
@@ -621,7 +626,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return -ENXIO;
 	}
 
-	txq_id = iwlagn_alloc_agg_txq(priv, tid_to_ac[tid]);
+	txq_id = iwlagn_alloc_agg_txq(priv, ctx->ac_to_queue[tid_to_ac[tid]]);
 	if (txq_id < 0) {
 		IWL_DEBUG_TX_QUEUES(priv,
 			"No free aggregation queue for %pM/%d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e219868..b53852d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -578,24 +578,6 @@ static const u8 iwlagn_pan_ac_to_queue[] = {
 	7, 6, 5, 4,
 };
 
-static const u8 iwlagn_bss_queue_to_ac[] = {
-	IEEE80211_AC_VO,
-	IEEE80211_AC_VI,
-	IEEE80211_AC_BE,
-	IEEE80211_AC_BK,
-};
-
-static const u8 iwlagn_pan_queue_to_ac[] = {
-	IEEE80211_AC_VO,
-	IEEE80211_AC_VI,
-	IEEE80211_AC_BE,
-	IEEE80211_AC_BK,
-	IEEE80211_AC_BK,
-	IEEE80211_AC_BE,
-	IEEE80211_AC_VI,
-	IEEE80211_AC_VO,
-};
-
 void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 {
 	int i;
@@ -1030,12 +1012,12 @@ void iwlagn_prepare_restart(struct iwl_priv *priv)
 	priv->bt_status = bt_status;
 	priv->bt_is_sco = bt_is_sco;
 
-	/* reset all queues */
-	for (i = 0; i < IEEE80211_NUM_ACS; i++)
-		atomic_set(&priv->ac_stop_count[i], 0);
-
+	/* reset aggregation queues */
 	for (i = IWLAGN_FIRST_AMPDU_QUEUE; i < IWL_MAX_HW_QUEUES; i++)
-		priv->queue_to_ac[i] = IWL_INVALID_AC;
+		priv->queue_to_mac80211[i] = IWL_INVALID_MAC80211_QUEUE;
+	/* and stop counts */
+	for (i = 0; i < IWL_MAX_HW_QUEUES; i++)
+		atomic_set(&priv->queue_stop_count[i], 0);
 
 	memset(priv->agg_q_alloc, 0, sizeof(priv->agg_q_alloc));
 }
@@ -1491,8 +1473,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		STATISTICS_NOTIFICATION,
 		REPLY_TX,
 	};
-	const u8 *q_to_ac;
-	int n_q_to_ac;
 	int i;
 
 	/************************
@@ -1575,16 +1555,12 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		trans_cfg.queue_to_fifo = iwlagn_ipan_queue_to_tx_fifo;
 		trans_cfg.n_queue_to_fifo =
 			ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo);
-		q_to_ac = iwlagn_pan_queue_to_ac;
-		n_q_to_ac = ARRAY_SIZE(iwlagn_pan_queue_to_ac);
 	} else {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 		trans_cfg.cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
 		trans_cfg.queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
 		trans_cfg.n_queue_to_fifo =
 			ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo);
-		q_to_ac = iwlagn_bss_queue_to_ac;
-		n_q_to_ac = ARRAY_SIZE(iwlagn_bss_queue_to_ac);
 	}
 
 	/* Configure transport layer */
@@ -1670,8 +1646,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		trans_cfg.queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
 		trans_cfg.n_queue_to_fifo =
 			ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo);
-		q_to_ac = iwlagn_bss_queue_to_ac;
-		n_q_to_ac = ARRAY_SIZE(iwlagn_bss_queue_to_ac);
 
 		/* Configure transport layer again*/
 		iwl_trans_configure(priv->trans, &trans_cfg);
@@ -1680,14 +1654,13 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/*******************
 	 * 5. Setup priv
 	 *******************/
-	for (i = 0; i < IEEE80211_NUM_ACS; i++)
-		atomic_set(&priv->ac_stop_count[i], 0);
-
 	for (i = 0; i < IWL_MAX_HW_QUEUES; i++) {
-		if (i < n_q_to_ac)
-			priv->queue_to_ac[i] = q_to_ac[i];
-		else
-			priv->queue_to_ac[i] = IWL_INVALID_AC;
+		priv->queue_to_mac80211[i] = IWL_INVALID_MAC80211_QUEUE;
+		if (i < IWLAGN_FIRST_AMPDU_QUEUE &&
+		    i != IWL_DEFAULT_CMD_QUEUE_NUM &&
+		    i != IWL_IPAN_CMD_QUEUE_NUM)
+			priv->queue_to_mac80211[i] = i;
+		atomic_set(&priv->queue_stop_count[i], 0);
 	}
 
 	WARN_ON(trans_cfg.queue_to_fifo[trans_cfg.cmd_queue] !=
@@ -2256,56 +2229,56 @@ static void iwl_wimax_active(struct iwl_op_mode *op_mode)
 void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
-	int ac = priv->queue_to_ac[queue];
+	int mq = priv->queue_to_mac80211[queue];
 
-	if (WARN_ON_ONCE(ac == IWL_INVALID_AC))
+	if (WARN_ON_ONCE(mq == IWL_INVALID_MAC80211_QUEUE))
 		return;
 
-	if (atomic_inc_return(&priv->ac_stop_count[ac]) > 1) {
+	if (atomic_inc_return(&priv->queue_stop_count[mq]) > 1) {
 		IWL_DEBUG_TX_QUEUES(priv,
-			"queue %d (AC %d) already stopped\n",
-			queue, ac);
+			"queue %d (mac80211 %d) already stopped\n",
+			queue, mq);
 		return;
 	}
 
-	set_bit(ac, &priv->transport_queue_stop);
-	ieee80211_stop_queue(priv->hw, ac);
+	set_bit(mq, &priv->transport_queue_stop);
+	ieee80211_stop_queue(priv->hw, mq);
 }
 
 void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
-	int ac = priv->queue_to_ac[queue];
+	int mq = priv->queue_to_mac80211[queue];
 
-	if (WARN_ON_ONCE(ac == IWL_INVALID_AC))
+	if (WARN_ON_ONCE(mq == IWL_INVALID_MAC80211_QUEUE))
 		return;
 
-	if (atomic_dec_return(&priv->ac_stop_count[ac]) > 0) {
+	if (atomic_dec_return(&priv->queue_stop_count[mq]) > 0) {
 		IWL_DEBUG_TX_QUEUES(priv,
-			"queue %d (AC %d) already awake\n",
-			queue, ac);
+			"queue %d (mac80211 %d) already awake\n",
+			queue, mq);
 		return;
 	}
 
-	clear_bit(ac, &priv->transport_queue_stop);
+	clear_bit(mq, &priv->transport_queue_stop);
 
 	if (!priv->passive_no_rx)
-		ieee80211_wake_queue(priv->hw, ac);
+		ieee80211_wake_queue(priv->hw, mq);
 }
 
 void iwlagn_lift_passive_no_rx(struct iwl_priv *priv)
 {
-	int ac;
+	int mq;
 
 	if (!priv->passive_no_rx)
 		return;
 
-	for (ac = IEEE80211_AC_VO; ac < IEEE80211_NUM_ACS; ac++) {
-		if (!test_bit(ac, &priv->transport_queue_stop)) {
-			IWL_DEBUG_TX_QUEUES(priv, "Wake queue %d");
-			ieee80211_wake_queue(priv->hw, ac);
+	for (mq = 0; mq < IWLAGN_FIRST_AMPDU_QUEUE; mq++) {
+		if (!test_bit(mq, &priv->transport_queue_stop)) {
+			IWL_DEBUG_TX_QUEUES(priv, "Wake queue %d", mq);
+			ieee80211_wake_queue(priv->hw, mq);
 		} else {
-			IWL_DEBUG_TX_QUEUES(priv, "Don't wake queue %d");
+			IWL_DEBUG_TX_QUEUES(priv, "Don't wake queue %d", mq);
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b064676..f70219c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -727,9 +727,9 @@ struct iwl_priv {
 
 	unsigned long transport_queue_stop;
 	bool passive_no_rx;
-#define IWL_INVALID_AC	0xff
-	u8 queue_to_ac[IWL_MAX_HW_QUEUES];
-	atomic_t ac_stop_count[IEEE80211_NUM_ACS];
+#define IWL_INVALID_MAC80211_QUEUE	0xff
+	u8 queue_to_mac80211[IWL_MAX_HW_QUEUES];
+	atomic_t queue_stop_count[IWL_MAX_HW_QUEUES];
 
 	unsigned long agg_q_alloc[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 9670554..b30bb0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -146,7 +146,13 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_NEED_DTIM_PERIOD |
 		    IEEE80211_HW_SPECTRUM_MGMT |
-		    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
+		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+		    IEEE80211_HW_QUEUE_CONTROL |
+		    IEEE80211_HW_SUPPORTS_PS |
+		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
+		    IEEE80211_HW_SCAN_WHILE_IDLE;
+
+	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
 
 	/*
 	 * Including the following line will crash some AP's.  This
@@ -155,10 +161,6 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	hw->max_tx_aggregation_subframes = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	 */
 
-	hw->flags |= IEEE80211_HW_SUPPORTS_PS |
-		     IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
-		     IEEE80211_HW_SCAN_WHILE_IDLE;
-
 	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE)
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
@@ -224,8 +226,11 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	/* we create the 802.11 header and a zero-length SSID element */
 	hw->wiphy->max_scan_ie_len = capa->max_probe_length - 24 - 2;
 
-	/* Default value; 4 EDCA QOS priorities */
-	hw->queues = 4;
+	/*
+	 * We don't use all queues: 4 and 9 are unused and any
+	 * aggregation queue gets mapped down to the AC queue.
+	 */
+	hw->queues = IWLAGN_FIRST_AMPDU_QUEUE;
 
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
 
@@ -1218,7 +1223,7 @@ static int iwl_set_mode(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 int iwl_setup_interface(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	struct ieee80211_vif *vif = ctx->vif;
-	int err;
+	int err, ac;
 
 	lockdep_assert_held(&priv->mutex);
 
@@ -1248,11 +1253,20 @@ int iwl_setup_interface(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		priv->bt_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_HIGH;
 	}
 
+	/* set up queue mappings */
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+		vif->hw_queue[ac] = ctx->ac_to_queue[ac];
+
+	if (vif->type == NL80211_IFTYPE_AP)
+		vif->cab_queue = ctx->mcast_queue;
+	else
+		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
+
 	return 0;
 }
 
 static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif)
+				    struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-- 
1.7.0.4

