Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1HMSSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 54/60] iwlagn: move the check_empty logic to the transport layer
Date: Sat, 13 Aug 2011 10:38:30 -0700
Message-Id: <1313257116-2697-55-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201859_463468_40BDC785)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This logic is responsible to tell mac80211 when the HW queues are
empty and the BA session can be started / torn down.

Fix a bug on the way:
When the the Tx BA session is stopped and the HW queues aren't empty,
we stop the SW queue to drain the HW queue and then switch to the
legacy HW queue. This is the IWL_EMPTYING_HW_QUEUE_DELBA state.

While in this state, we never wake the SW queue, even when the HW
queue is almost empty, since we need to drain it completely. Look
at iwl_trans_pcie_reclaim regarding this.

Once the HW queue is really empty, we must wake the SW queue in order
to get traffic to the legacy queue.
This step was missing leading to an odd situation were the traffic
would just stall after we tore down a Tx BA session while the HW
queue was not empty.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   65 +-----------------
 drivers/net/wireless/iwlwifi/iwl-core.c           |   21 ++++++-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    6 ++-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   11 ++-
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   73 +++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   11 ++--
 7 files changed, 110 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index e4df664..1456e87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -477,43 +477,6 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	return 0;
 }
 
-static int iwlagn_txq_check_empty(struct iwl_priv *priv,
-			   int sta_id, u8 tid, int txq_id)
-{
-	struct iwl_queue *q = &priv->txq[txq_id].q;
-	u8 *addr = priv->stations[sta_id].sta.sta.addr;
-	struct iwl_tid_data *tid_data = &priv->shrd->tid_data[sta_id][tid];
-	struct iwl_rxon_context *ctx;
-
-	ctx = &priv->contexts[priv->stations[sta_id].ctxid];
-
-	lockdep_assert_held(&priv->shrd->sta_lock);
-
-	switch (priv->shrd->tid_data[sta_id][tid].agg.state) {
-	case IWL_EMPTYING_HW_QUEUE_DELBA:
-		/* We are reclaiming the last packet of the */
-		/* aggregated HW queue */
-		if ((txq_id  == tid_data->agg.txq_id) &&
-		    (q->read_ptr == q->write_ptr)) {
-			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
-			iwl_trans_txq_agg_disable(trans(priv), txq_id);
-			tid_data->agg.state = IWL_AGG_OFF;
-			ieee80211_stop_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
-		}
-		break;
-	case IWL_EMPTYING_HW_QUEUE_ADDBA:
-		/* We are reclaiming the last packet of the queue */
-		if (tid_data->tfds_in_queue == 0) {
-			IWL_DEBUG_HT(priv, "HW queue empty: continue ADDBA flow\n");
-			tid_data->agg.state = IWL_AGG_ON;
-			ieee80211_start_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
-		}
-		break;
-	}
-
-	return 0;
-}
-
 static void iwlagn_non_agg_tx_status(struct iwl_priv *priv,
 				     struct iwl_rxon_context *ctx,
 				     const u8 *addr1)
@@ -724,21 +687,6 @@ static inline u32 iwlagn_get_scd_ssn(struct iwlagn_tx_resp *tx_resp)
 			    tx_resp->frame_count) & MAX_SN;
 }
 
-static void iwl_free_tfds_in_queue(struct iwl_priv *priv,
-			    int sta_id, int tid, int freed)
-{
-	lockdep_assert_held(&priv->shrd->sta_lock);
-
-	if (priv->shrd->tid_data[sta_id][tid].tfds_in_queue >= freed)
-		priv->shrd->tid_data[sta_id][tid].tfds_in_queue -= freed;
-	else {
-		IWL_DEBUG_TX(priv, "free more than tfds_in_queue (%u:%d)\n",
-			priv->shrd->tid_data[sta_id][tid].tfds_in_queue,
-			freed);
-		priv->shrd->tid_data[sta_id][tid].tfds_in_queue = 0;
-	}
-}
-
 static void iwlagn_count_tx_err_status(struct iwl_priv *priv, u16 status)
 {
 	status &= TX_STATUS_MSK;
@@ -889,7 +837,8 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 
 		__skb_queue_head_init(&skbs);
 		/*we can free until ssn % q.n_bd not inclusive */
-		iwl_trans_reclaim(trans(priv), txq_id, ssn, status, &skbs);
+		iwl_trans_reclaim(trans(priv), sta_id, tid, txq_id,
+				  ssn, status, &skbs);
 		freed = 0;
 		while (!skb_queue_empty(&skbs)) {
 			skb = __skb_dequeue(&skbs);
@@ -939,9 +888,6 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		}
 
 		WARN_ON(!is_agg && freed != 1);
-
-		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
-		iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 	}
 
 	iwl_check_abort_status(priv, tx_resp->frame_count, status);
@@ -1050,8 +996,8 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	/* Release all TFDs before the SSN, i.e. all TFDs in front of
 	 * block-ack window (we assume that they've been successfully
 	 * transmitted ... if not, it's too late anyway). */
-	iwl_trans_reclaim(trans(priv), scd_flow, ba_resp_scd_ssn, 0,
-			  &reclaimed_skbs);
+	iwl_trans_reclaim(trans(priv), sta_id, tid, scd_flow, ba_resp_scd_ssn,
+			  0, &reclaimed_skbs);
 	freed = 0;
 	while (!skb_queue_empty(&reclaimed_skbs)) {
 
@@ -1082,9 +1028,6 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		ieee80211_tx_status_irqsafe(priv->hw, skb);
 	}
 
-	iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
-	iwlagn_txq_check_empty(priv, sta_id, tid, scd_flow);
-
 	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 49c4f91..d7fde63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1858,12 +1858,31 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 	return cpu_to_le32(res);
 }
 
-void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv, u8 ctx,
+void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv,
+				 enum iwl_rxon_context_id ctx,
 				 u8 sta_id, u8 tid)
 {
 	struct ieee80211_vif *vif = priv->contexts[ctx].vif;
 	u8 *addr = priv->stations[sta_id].sta.sta.addr;
 
+	if (ctx == NUM_IWL_RXON_CTX)
+		ctx = priv->stations[sta_id].ctxid;
+	vif = priv->contexts[ctx].vif;
+
 	ieee80211_start_tx_ba_cb_irqsafe(vif, addr, tid);
 }
 
+void iwl_stop_tx_ba_trans_ready(struct iwl_priv *priv,
+				enum iwl_rxon_context_id ctx,
+				u8 sta_id, u8 tid)
+{
+	struct ieee80211_vif *vif;
+	u8 *addr = priv->stations[sta_id].sta.sta.addr;
+
+	if (ctx == NUM_IWL_RXON_CTX)
+		ctx = priv->stations[sta_id].ctxid;
+	vif = priv->contexts[ctx].vif;
+
+	ieee80211_stop_tx_ba_cb_irqsafe(vif, addr, tid);
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index a2be28a..0bd6f7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -346,8 +346,12 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 		struct iwl_cfg *cfg);
 void __devexit iwl_remove(struct iwl_priv * priv);
 
-void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv, u8 ctx,
+void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv,
+				 enum iwl_rxon_context_id ctx,
 				 u8 sta_id, u8 tid);
+void iwl_stop_tx_ba_trans_ready(struct iwl_priv *priv,
+				enum iwl_rxon_context_id ctx,
+				u8 sta_id, u8 tid);
 
 /*****************************************************
 * DRIVER STATUS FUNCTIONS
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index ece9408..ba82c8b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -202,8 +202,8 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv,
 					int sta_id, int tid, int frame_limit);
 void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	int index);
-void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
-			  struct sk_buff_head *skbs);
+int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
+			 struct sk_buff_head *skbs);
 
 /*****************************************************
 * Error handling
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 0b05048..2a08d13 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -1118,12 +1118,13 @@ int iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id, u32 flags,
 }
 
 /* Frees buffers until index _not_ inclusive */
-void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
-			    struct sk_buff_head *skbs)
+int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
+			 struct sk_buff_head *skbs)
 {
 	struct iwl_tx_queue *txq = &priv(trans)->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	int last_to_free;
+	int freed = 0;
 
 	/*Since we free until index _not_ inclusive, the one before index is
 	 * the last we will free. This one must be used */
@@ -1135,14 +1136,14 @@ void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 			  "last_to_free %d is out of range [0-%d] %d %d.\n",
 			  __func__, txq_id, last_to_free, q->n_bd,
 			  q->write_ptr, q->read_ptr);
-		return;
+		return 0;
 	}
 
 	IWL_DEBUG_TX_REPLY(trans, "reclaim: [%d, %d, %d]\n", txq_id,
 			   q->read_ptr, index);
 
 	if (WARN_ON(!skb_queue_empty(skbs)))
-		return;
+		return 0;
 
 	for (;
 	     q->read_ptr != index;
@@ -1158,6 +1159,8 @@ void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 		iwlagn_txq_inval_byte_cnt_tbl(trans, txq);
 
 		iwlagn_txq_free_tfd(trans, txq, txq->q.read_ptr);
+		freed++;
 	}
+	return freed;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 13e8fdc..0256454 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1265,19 +1265,75 @@ static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 	return 0;
 }
 
-static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id,
-		      int ssn, u32 status, struct sk_buff_head *skbs)
+static int iwlagn_txq_check_empty(struct iwl_trans *trans,
+			   int sta_id, u8 tid, int txq_id)
 {
-	struct iwl_priv *priv = priv(trans);
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_queue *q = &priv(trans)->txq[txq_id].q;
+	struct iwl_tid_data *tid_data = &trans->shrd->tid_data[sta_id][tid];
+
+	lockdep_assert_held(&trans->shrd->sta_lock);
+
+	switch (trans->shrd->tid_data[sta_id][tid].agg.state) {
+	case IWL_EMPTYING_HW_QUEUE_DELBA:
+		/* We are reclaiming the last packet of the */
+		/* aggregated HW queue */
+		if ((txq_id  == tid_data->agg.txq_id) &&
+		    (q->read_ptr == q->write_ptr)) {
+			IWL_DEBUG_HT(trans,
+				"HW queue empty: continue DELBA flow\n");
+			iwl_trans_pcie_txq_agg_disable(priv(trans), txq_id);
+			tid_data->agg.state = IWL_AGG_OFF;
+			iwl_stop_tx_ba_trans_ready(priv(trans),
+						   NUM_IWL_RXON_CTX,
+						   sta_id, tid);
+			iwl_wake_queue(priv(trans), &priv(trans)->txq[txq_id]);
+		}
+		break;
+	case IWL_EMPTYING_HW_QUEUE_ADDBA:
+		/* We are reclaiming the last packet of the queue */
+		if (tid_data->tfds_in_queue == 0) {
+			IWL_DEBUG_HT(trans,
+				"HW queue empty: continue ADDBA flow\n");
+			tid_data->agg.state = IWL_AGG_ON;
+			iwl_start_tx_ba_trans_ready(priv(trans),
+						    NUM_IWL_RXON_CTX,
+						    sta_id, tid);
+		}
+		break;
+	}
+
+	return 0;
+}
+
+static void iwl_free_tfds_in_queue(struct iwl_trans *trans,
+			    int sta_id, int tid, int freed)
+{
+	lockdep_assert_held(&trans->shrd->sta_lock);
+
+	if (trans->shrd->tid_data[sta_id][tid].tfds_in_queue >= freed)
+		trans->shrd->tid_data[sta_id][tid].tfds_in_queue -= freed;
+	else {
+		IWL_DEBUG_TX(trans, "free more than tfds_in_queue (%u:%d)\n",
+			trans->shrd->tid_data[sta_id][tid].tfds_in_queue,
+			freed);
+		trans->shrd->tid_data[sta_id][tid].tfds_in_queue = 0;
+	}
+}
+
+static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
+		      int txq_id, int ssn, u32 status,
+		      struct sk_buff_head *skbs)
+{
+	struct iwl_tx_queue *txq = &priv(trans)->txq[txq_id];
 	/* n_bd is usually 256 => n_bd - 1 = 0xff */
 	int tfd_num = ssn & (txq->q.n_bd - 1);
+	int freed = 0;
 	u8 agg_state;
 	bool cond;
 
 	if (txq->sched_retry) {
 		agg_state =
-			priv->shrd->tid_data[txq->sta_id][txq->tid].agg.state;
+			trans->shrd->tid_data[txq->sta_id][txq->tid].agg.state;
 		cond = (agg_state != IWL_EMPTYING_HW_QUEUE_DELBA);
 	} else {
 		cond = (status != TX_STATUS_FAIL_PASSIVE_NO_RX);
@@ -1287,10 +1343,13 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id,
 		IWL_DEBUG_TX_REPLY(trans, "Retry scheduler reclaim "
 				"scd_ssn=%d idx=%d txq=%d swq=%d\n",
 				ssn , tfd_num, txq_id, txq->swq_id);
-		iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
+		freed = iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
 		if (iwl_queue_space(&txq->q) > txq->q.low_mark && cond)
-			iwl_wake_queue(priv, txq);
+			iwl_wake_queue(priv(trans), txq);
 	}
+
+	iwl_free_tfds_in_queue(trans, sta_id, tid, freed);
+	iwlagn_txq_check_empty(trans, sta_id, tid, txq_id);
 }
 
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8aaab08..7586a15 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -123,8 +123,9 @@ struct iwl_trans_ops {
 		     const void *data);
 	int (*tx)(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_device_cmd *dev_cmd, u8 ctx, u8 sta_id);
-	void (*reclaim)(struct iwl_trans *trans, int txq_id, int ssn,
-			u32 status, struct sk_buff_head *skbs);
+	void (*reclaim)(struct iwl_trans *trans, int sta_id, int tid,
+			int txq_id, int ssn, u32 status,
+			struct sk_buff_head *skbs);
 
 	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id);
 	int (*tx_agg_alloc)(struct iwl_trans *trans,
@@ -208,11 +209,11 @@ static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	return trans->ops->tx(trans, skb, dev_cmd, ctx, sta_id);
 }
 
-static inline void iwl_trans_reclaim(struct iwl_trans *trans, int txq_id,
-				 int ssn, u32 status,
+static inline void iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
+				 int tid, int txq_id, int ssn, u32 status,
 				 struct sk_buff_head *skbs)
 {
-	trans->ops->reclaim(trans, txq_id, ssn, status, skbs);
+	trans->ops->reclaim(trans, sta_id, tid, txq_id, ssn, status, skbs);
 }
 
 static inline int iwl_trans_txq_agg_disable(struct iwl_trans *trans, u16 txq_id)
-- 
1.7.0.4

