Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38048 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab1HMSSs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 55/60] iwlagn: move the disable agg logic to transport layer
Date: Sat, 13 Aug 2011 10:38:31 -0700
Message-Id: <1313257116-2697-56-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201855_465036_12CE4CA3)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since all the check_empty logic is now in the transport layer,
the upper layer doesn't need to know anything about tx queues.
The disable aggregation flow was the last to know what a tx queue
is, so move it too.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   63 +--------------
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    5 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   88 +++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-trans.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   12 ++-
 5 files changed, 92 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 1456e87..9969a76 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -408,10 +408,8 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid)
 {
-	int txq_id, sta_id, ssn;
-	struct iwl_tid_data *tid_data;
-	int write_ptr, read_ptr;
-	unsigned long flags;
+	int sta_id;
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 
 	sta_id = iwl_sta_id(sta);
 
@@ -420,61 +418,8 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return -ENXIO;
 	}
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-
-	tid_data = &priv->shrd->tid_data[sta_id][tid];
-	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
-	txq_id = tid_data->agg.txq_id;
-
-	switch (priv->shrd->tid_data[sta_id][tid].agg.state) {
-	case IWL_EMPTYING_HW_QUEUE_ADDBA:
-		/*
-		 * This can happen if the peer stops aggregation
-		 * again before we've had a chance to drain the
-		 * queue we selected previously, i.e. before the
-		 * session was really started completely.
-		 */
-		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
-		goto turn_off;
-	case IWL_AGG_ON:
-		break;
-	default:
-		IWL_WARN(priv, "Stopping AGG while state not ON or starting\n");
-	}
-
-	write_ptr = priv->txq[txq_id].q.write_ptr;
-	read_ptr = priv->txq[txq_id].q.read_ptr;
-
-	/* The queue is not empty */
-	if (write_ptr != read_ptr) {
-		IWL_DEBUG_HT(priv, "Stopping a non empty AGG HW QUEUE\n");
-		priv->shrd->tid_data[sta_id][tid].agg.state =
-				IWL_EMPTYING_HW_QUEUE_DELBA;
-		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
-		return 0;
-	}
-
-	IWL_DEBUG_HT(priv, "HW queue is empty\n");
- turn_off:
-	priv->shrd->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
-
-	/* do not restore/save irqs */
-	spin_unlock(&priv->shrd->sta_lock);
-	spin_lock(&priv->shrd->lock);
-
-	/*
-	 * the only reason this call can fail is queue number out of range,
-	 * which can happen if uCode is reloaded and all the station
-	 * information are lost. if it is outside the range, there is no need
-	 * to deactivate the uCode queue, just return "success" to allow
-	 *  mac80211 to clean up it own data.
-	 */
-	iwl_trans_txq_agg_disable(trans(priv), txq_id);
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
-
-	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-
-	return 0;
+	return iwl_trans_tx_agg_disable(trans(priv), vif_priv->ctx->ctxid,
+					sta_id, tid);
 }
 
 static void iwlagn_non_agg_tx_status(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index ba82c8b..a310831 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -189,7 +189,10 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt);
-int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id);
+void iwl_trans_pcie_txq_agg_disable(struct iwl_trans *trans, int txq_id);
+int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
+				  enum iwl_rxon_context_id ctx, int sta_id,
+				  int tid);
 void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
 void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 2a08d13..7bb86eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -560,32 +560,92 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 
 	return 0;
 }
-int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id)
+
+void iwl_trans_pcie_txq_agg_disable(struct iwl_trans *trans, int txq_id)
 {
-	struct iwl_trans *trans = trans(priv);
+	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
+
+	iwl_clear_bits_prph(bus(trans), SCD_AGGR_SEL, (1 << txq_id));
+
+	priv(trans)->txq[txq_id].q.read_ptr = 0;
+	priv(trans)->txq[txq_id].q.write_ptr = 0;
+	/* supposes that ssn_idx is valid (!= 0xFFF) */
+	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
+
+	iwl_clear_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_txq_ctx_deactivate(priv(trans), txq_id);
+	iwl_trans_tx_queue_set_status(priv(trans),
+					&priv(trans)->txq[txq_id], 0, 0);
+}
+
+int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
+				  enum iwl_rxon_context_id ctx, int sta_id,
+				  int tid)
+{
+	unsigned long flags;
+	int read_ptr, write_ptr;
+	struct iwl_tid_data *tid_data;
+	int txq_id;
+
+	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
+
+	tid_data = &trans->shrd->tid_data[sta_id][tid];
+	txq_id = tid_data->agg.txq_id;
+
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWLAGN_FIRST_AMPDU_QUEUE +
-		hw_params(priv).num_ampdu_queues <= txq_id)) {
-		IWL_ERR(priv,
+		hw_params(trans).num_ampdu_queues <= txq_id)) {
+		IWL_ERR(trans,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
 			IWLAGN_FIRST_AMPDU_QUEUE +
-			hw_params(priv).num_ampdu_queues - 1);
+			hw_params(trans).num_ampdu_queues - 1);
+		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
 		return -EINVAL;
 	}
 
-	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
+	switch (trans->shrd->tid_data[sta_id][tid].agg.state) {
+	case IWL_EMPTYING_HW_QUEUE_ADDBA:
+		/*
+		* This can happen if the peer stops aggregation
+		* again before we've had a chance to drain the
+		* queue we selected previously, i.e. before the
+		* session was really started completely.
+		*/
+		IWL_DEBUG_HT(trans, "AGG stop before setup done\n");
+		goto turn_off;
+	case IWL_AGG_ON:
+		break;
+	default:
+		IWL_WARN(trans, "Stopping AGG while state not ON"
+				"or starting\n");
+	}
 
-	iwl_clear_bits_prph(bus(priv), SCD_AGGR_SEL, (1 << txq_id));
+	write_ptr = priv(trans)->txq[txq_id].q.write_ptr;
+	read_ptr = priv(trans)->txq[txq_id].q.read_ptr;
 
-	priv->txq[txq_id].q.read_ptr = 0;
-	priv->txq[txq_id].q.write_ptr = 0;
-	/* supposes that ssn_idx is valid (!= 0xFFF) */
-	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
+	/* The queue is not empty */
+	if (write_ptr != read_ptr) {
+		IWL_DEBUG_HT(trans, "Stopping a non empty AGG HW QUEUE\n");
+		trans->shrd->tid_data[sta_id][tid].agg.state =
+			IWL_EMPTYING_HW_QUEUE_DELBA;
+		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
+		return 0;
+	}
+
+	IWL_DEBUG_HT(trans, "HW queue is empty\n");
+turn_off:
+	trans->shrd->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
+
+	/* do not restore/save irqs */
+	spin_unlock(&trans->shrd->sta_lock);
+	spin_lock(&trans->shrd->lock);
+
+	iwl_trans_pcie_txq_agg_disable(trans, txq_id);
+
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
-	iwl_clear_bits_prph(bus(priv), SCD_INTERRUPT_MASK, (1 << txq_id));
-	iwl_txq_ctx_deactivate(priv, txq_id);
-	iwl_trans_tx_queue_set_status(priv, &priv->txq[txq_id], 0, 0);
+	iwl_stop_tx_ba_trans_ready(priv(trans), ctx, sta_id, tid);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 0256454..ab35fd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1281,7 +1281,7 @@ static int iwlagn_txq_check_empty(struct iwl_trans *trans,
 		    (q->read_ptr == q->write_ptr)) {
 			IWL_DEBUG_HT(trans,
 				"HW queue empty: continue DELBA flow\n");
-			iwl_trans_pcie_txq_agg_disable(priv(trans), txq_id);
+			iwl_trans_pcie_txq_agg_disable(trans, txq_id);
 			tid_data->agg.state = IWL_AGG_OFF;
 			iwl_stop_tx_ba_trans_ready(priv(trans),
 						   NUM_IWL_RXON_CTX,
@@ -2015,7 +2015,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.tx = iwl_trans_pcie_tx,
 	.reclaim = iwl_trans_pcie_reclaim,
 
-	.txq_agg_disable = iwl_trans_pcie_txq_agg_disable,
+	.tx_agg_disable = iwl_trans_pcie_tx_agg_disable,
 	.tx_agg_alloc = iwl_trans_pcie_tx_agg_alloc,
 	.txq_agg_setup = iwl_trans_pcie_txq_agg_setup,
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 7586a15..1fd6bde 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -97,7 +97,7 @@ struct iwl_device_cmd;
  * @tx_agg_alloc: allocate resources for a TX BA session
  * @txq_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
  *                 ready and a successful ADDBA response has been received.
- * @txq_agg_disable: de-configure a Tx queue to send AMPDUs
+ * @tx_agg_disable: de-configure a Tx queue to send AMPDUs
  * @kick_nic: remove the RESET from the embedded CPU and let it run
  * @free: release all the ressource for the transport layer itself such as
  *        irq, tasklet etc...
@@ -127,7 +127,9 @@ struct iwl_trans_ops {
 			int txq_id, int ssn, u32 status,
 			struct sk_buff_head *skbs);
 
-	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id);
+	int (*tx_agg_disable)(struct iwl_trans *trans,
+			       enum iwl_rxon_context_id ctx, int sta_id,
+			       int tid);
 	int (*tx_agg_alloc)(struct iwl_trans *trans,
 			    enum iwl_rxon_context_id ctx, int sta_id, int tid,
 			    u16 *ssn);
@@ -216,9 +218,11 @@ static inline void iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
 	trans->ops->reclaim(trans, sta_id, tid, txq_id, ssn, status, skbs);
 }
 
-static inline int iwl_trans_txq_agg_disable(struct iwl_trans *trans, u16 txq_id)
+static inline int iwl_trans_tx_agg_disable(struct iwl_trans *trans,
+					    enum iwl_rxon_context_id ctx,
+					    int sta_id, int tid)
 {
-	return trans->ops->txq_agg_disable(priv(trans), txq_id);
+	return trans->ops->tx_agg_disable(trans, ctx, sta_id, tid);
 }
 
 static inline int iwl_trans_tx_agg_alloc(struct iwl_trans *trans,
-- 
1.7.0.4

