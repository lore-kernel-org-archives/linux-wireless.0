Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759707Ab1LPQhj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:39 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/24] iwlwifi: tid_data logic move to upper layer - tx AGG stop
Date: Fri, 16 Dec 2011 07:37:12 -0800
Message-Id: <1324049849-831-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173748_278693_F844B1AF)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The tid_data is not related to the transport layer, so move
the logic that depends on it to the upper layer.
This patch deals with tx AGG stop.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   88 +++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   86 +++-----------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    6 +-
 5 files changed, 87 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 69d0f99..a31cdef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -395,6 +395,77 @@ drop_unlock_priv:
 	return -1;
 }
 
+int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta, u16 tid)
+{
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+	struct iwl_tid_data *tid_data;
+	unsigned long flags;
+	int sta_id;
+
+	sta_id = iwl_sta_id(sta);
+
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
+		return -ENXIO;
+	}
+
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+
+	tid_data = &priv->shrd->tid_data[sta_id][tid];
+
+	switch (priv->shrd->tid_data[sta_id][tid].agg.state) {
+	case IWL_EMPTYING_HW_QUEUE_ADDBA:
+		/*
+		* This can happen if the peer stops aggregation
+		* again before we've had a chance to drain the
+		* queue we selected previously, i.e. before the
+		* session was really started completely.
+		*/
+		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
+		goto turn_off;
+	case IWL_AGG_ON:
+		break;
+	default:
+		IWL_WARN(priv, "Stopping AGG while state not ON "
+			 "or starting for %d on %d (%d)\n", sta_id, tid,
+			 priv->shrd->tid_data[sta_id][tid].agg.state);
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+		return 0;
+	}
+
+	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
+
+	/* There are still packets for this RA / TID in the HW */
+	if (tid_data->agg.ssn != tid_data->next_reclaimed) {
+		IWL_DEBUG_TX_QUEUES(priv, "Can't proceed: ssn %d, "
+				    "next_recl = %d",
+				    tid_data->agg.ssn,
+				    tid_data->next_reclaimed);
+		priv->shrd->tid_data[sta_id][tid].agg.state =
+			IWL_EMPTYING_HW_QUEUE_DELBA;
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+		return 0;
+	}
+
+	IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d",
+			    tid_data->agg.ssn);
+turn_off:
+	priv->shrd->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
+
+	/* do not restore/save irqs */
+	spin_unlock(&priv->shrd->sta_lock);
+	spin_lock(&priv->shrd->lock);
+
+	iwl_trans_tx_agg_disable(trans(priv), sta_id, tid);
+
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+
+	iwl_stop_tx_ba_trans_ready(priv, vif_priv->ctx->ctxid, sta_id, tid);
+
+	return 0;
+}
+
 int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
@@ -428,23 +499,6 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	return ret;
 }
 
-int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta, u16 tid)
-{
-	int sta_id;
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-
-	sta_id = iwl_sta_id(sta);
-
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
-		return -ENXIO;
-	}
-
-	return iwl_trans_tx_agg_disable(trans(priv), vif_priv->ctx->ctxid,
-					sta_id, tid);
-}
-
 static void iwlagn_non_agg_tx_status(struct iwl_priv *priv,
 				     struct iwl_rxon_context *ctx,
 				     const u8 *addr1)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 5a384b3..342ee2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -280,10 +280,8 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans,
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt);
-void iwl_trans_pcie_txq_agg_disable(struct iwl_trans *trans, int txq_id);
 int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
-				  enum iwl_rxon_context_id ctx, int sta_id,
-				  int tid);
+				  int sta_id, int tid);
 void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
 void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 			     struct iwl_tx_queue *txq,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 58ee0ac..4ee5f50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -578,35 +578,11 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 	return 0;
 }
 
-void iwl_trans_pcie_txq_agg_disable(struct iwl_trans *trans, int txq_id)
+int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int sta_id, int tid)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
-
-	iwl_clear_bits_prph(bus(trans), SCD_AGGR_SEL, (1 << txq_id));
-
-	trans_pcie->txq[txq_id].q.read_ptr = 0;
-	trans_pcie->txq[txq_id].q.write_ptr = 0;
-	/* supposes that ssn_idx is valid (!= 0xFFF) */
-	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
-
-	iwl_clear_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
-	iwl_txq_ctx_deactivate(trans_pcie, txq_id);
-	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id], 0, 0);
-}
-
-int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
-				  enum iwl_rxon_context_id ctx, int sta_id,
-				  int tid)
-{
-	struct iwl_tid_data *tid_data;
-	unsigned long flags;
-	int txq_id;
-
-	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
-
-	tid_data = &trans->shrd->tid_data[sta_id][tid];
-	txq_id = tid_data->agg.txq_id;
+	/* TODO: the transport layer shouldn't access the tid_data */
+	int txq_id = trans->shrd->tid_data[sta_id][tid].agg.txq_id;
 
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWLAGN_FIRST_AMPDU_QUEUE +
@@ -616,59 +592,21 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
 			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
 			IWLAGN_FIRST_AMPDU_QUEUE +
 			hw_params(trans).num_ampdu_queues - 1);
-		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
 		return -EINVAL;
 	}
 
-	switch (trans->shrd->tid_data[sta_id][tid].agg.state) {
-	case IWL_EMPTYING_HW_QUEUE_ADDBA:
-		/*
-		* This can happen if the peer stops aggregation
-		* again before we've had a chance to drain the
-		* queue we selected previously, i.e. before the
-		* session was really started completely.
-		*/
-		IWL_DEBUG_HT(trans, "AGG stop before setup done\n");
-		goto turn_off;
-	case IWL_AGG_ON:
-		break;
-	default:
-		IWL_WARN(trans, "Stopping AGG while state not ON "
-			 "or starting for %d on %d (%d)\n", sta_id, tid,
-			 trans->shrd->tid_data[sta_id][tid].agg.state);
-		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
-		return 0;
-	}
-
-	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
-
-	/* There are still packets for this RA / TID in the HW */
-	if (tid_data->agg.ssn != tid_data->next_reclaimed) {
-		IWL_DEBUG_TX_QUEUES(trans, "Can't proceed: ssn %d, "
-				    "next_recl = %d",
-				    tid_data->agg.ssn,
-				    tid_data->next_reclaimed);
-		trans->shrd->tid_data[sta_id][tid].agg.state =
-			IWL_EMPTYING_HW_QUEUE_DELBA;
-		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
-		return 0;
-	}
-
-	IWL_DEBUG_TX_QUEUES(trans, "Can proceed: ssn = next_recl = %d",
-			    tid_data->agg.ssn);
-turn_off:
-	trans->shrd->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
-
-	/* do not restore/save irqs */
-	spin_unlock(&trans->shrd->sta_lock);
-	spin_lock(&trans->shrd->lock);
-
-	iwl_trans_pcie_txq_agg_disable(trans, txq_id);
+	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
 
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	iwl_clear_bits_prph(bus(trans), SCD_AGGR_SEL, (1 << txq_id));
 
-	iwl_stop_tx_ba_trans_ready(priv(trans), ctx, sta_id, tid);
+	trans_pcie->txq[txq_id].q.read_ptr = 0;
+	trans_pcie->txq[txq_id].q.write_ptr = 0;
+	/* supposes that ssn_idx is valid (!= 0xFFF) */
+	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
 
+	iwl_clear_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_txq_ctx_deactivate(trans_pcie, txq_id);
+	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id], 0, 0);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index ef057ff..15bee2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1290,7 +1290,7 @@ static int iwlagn_txq_check_empty(struct iwl_trans *trans,
 			IWL_DEBUG_TX_QUEUES(trans,
 				"Can continue DELBA flow ssn = next_recl ="
 				" %d", tid_data->next_reclaimed);
-			iwl_trans_pcie_txq_agg_disable(trans, txq_id);
+			iwl_trans_pcie_tx_agg_disable(trans, sta_id, tid);
 			tid_data->agg.state = IWL_AGG_OFF;
 			iwl_stop_tx_ba_trans_ready(priv(trans),
 						   NUM_IWL_RXON_CTX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index f94a6ee..32c1deb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -184,8 +184,7 @@ struct iwl_trans_ops {
 			struct sk_buff_head *skbs);
 
 	int (*tx_agg_disable)(struct iwl_trans *trans,
-			      enum iwl_rxon_context_id ctx, int sta_id,
-			      int tid);
+			      int sta_id, int tid);
 	int (*tx_agg_alloc)(struct iwl_trans *trans,
 			    enum iwl_rxon_context_id ctx, int sta_id, int tid,
 			    u16 *ssn);
@@ -318,10 +317,9 @@ static inline void iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
 }
 
 static inline int iwl_trans_tx_agg_disable(struct iwl_trans *trans,
-					    enum iwl_rxon_context_id ctx,
 					    int sta_id, int tid)
 {
-	return trans->ops->tx_agg_disable(trans, ctx, sta_id, tid);
+	return trans->ops->tx_agg_disable(trans, sta_id, tid);
 }
 
 static inline int iwl_trans_tx_agg_alloc(struct iwl_trans *trans,
-- 
1.7.0.4

