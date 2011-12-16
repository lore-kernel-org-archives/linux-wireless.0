Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760142Ab1LPQhn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:43 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/24] iwlwifi: tid_data logic move to upper layer - tx AGG alloc
Date: Fri, 16 Dec 2011 07:37:13 -0800
Message-Id: <1324049849-831-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173759_833191_F244166F)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The tid_data is not related to the transport layer, so move
the logic that depends on it to the upper layer.
This patch deals with tx AGG alloc.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   32 +++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    4 +--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   26 +---------------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    8 ++---
 4 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index a31cdef..1ec4720 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -470,6 +470,8 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+	struct iwl_tid_data *tid_data;
+	unsigned long flags;
 	int sta_id;
 	int ret;
 
@@ -493,8 +495,34 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	ret = iwl_trans_tx_agg_alloc(trans(priv), vif_priv->ctx->ctxid, sta_id,
-				     tid, ssn);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+
+	tid_data = &priv->shrd->tid_data[sta_id][tid];
+	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
+
+	*ssn = tid_data->agg.ssn;
+
+	ret = iwl_trans_tx_agg_alloc(trans(priv), sta_id, tid);
+	if (ret) {
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+		return ret;
+	}
+
+	if (*ssn == tid_data->next_reclaimed) {
+		IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d",
+				    tid_data->agg.ssn);
+		tid_data->agg.state = IWL_AGG_ON;
+		iwl_start_tx_ba_trans_ready(priv, vif_priv->ctx->ctxid, sta_id,
+					    tid);
+	} else {
+		IWL_DEBUG_TX_QUEUES(priv, "Can't proceed: ssn %d, "
+				    "next_reclaimed = %d",
+				    tid_data->agg.ssn,
+				    tid_data->next_reclaimed);
+		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
+	}
+
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 342ee2d..395c9f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -286,9 +286,7 @@ void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
 void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 			     struct iwl_tx_queue *txq,
 			     int tx_fifo_id, int scd_retry);
-int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
-				enum iwl_rxon_context_id ctx, int sta_id,
-				int tid, u16 *ssn);
+int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans, int sta_id, int tid);
 void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 				 enum iwl_rxon_context_id ctx,
 				 int sta_id, int tid, int frame_limit);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 4ee5f50..28be8a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -539,12 +539,9 @@ static int iwlagn_txq_ctx_activate_free(struct iwl_trans *trans)
 }
 
 int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
-				enum iwl_rxon_context_id ctx, int sta_id,
-				int tid, u16 *ssn)
+				int sta_id, int tid)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tid_data *tid_data;
-	unsigned long flags;
 	int txq_id;
 
 	txq_id = iwlagn_txq_ctx_activate_free(trans);
@@ -553,28 +550,9 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 		return -ENXIO;
 	}
 
-	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
-	tid_data = &trans->shrd->tid_data[sta_id][tid];
-	tid_data->agg.txq_id = txq_id;
-	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
-
-	*ssn = tid_data->agg.ssn;
+	trans->shrd->tid_data[sta_id][tid].agg.txq_id = txq_id;
 	iwl_set_swq_id(&trans_pcie->txq[txq_id], get_ac_from_tid(tid), txq_id);
 
-	if (*ssn == tid_data->next_reclaimed) {
-		IWL_DEBUG_TX_QUEUES(trans, "Proceed: ssn = next_recl = %d",
-				    tid_data->agg.ssn);
-		tid_data->agg.state = IWL_AGG_ON;
-		iwl_start_tx_ba_trans_ready(priv(trans), ctx, sta_id, tid);
-	} else {
-		IWL_DEBUG_TX_QUEUES(trans, "Can't proceed: ssn %d, "
-				    "next_recl = %d",
-				    tid_data->agg.ssn,
-				    tid_data->next_reclaimed);
-		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
-	}
-	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 32c1deb..134d5f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -186,8 +186,7 @@ struct iwl_trans_ops {
 	int (*tx_agg_disable)(struct iwl_trans *trans,
 			      int sta_id, int tid);
 	int (*tx_agg_alloc)(struct iwl_trans *trans,
-			    enum iwl_rxon_context_id ctx, int sta_id, int tid,
-			    u16 *ssn);
+			    int sta_id, int tid);
 	void (*tx_agg_setup)(struct iwl_trans *trans,
 			     enum iwl_rxon_context_id ctx, int sta_id, int tid,
 			     int frame_limit);
@@ -323,10 +322,9 @@ static inline int iwl_trans_tx_agg_disable(struct iwl_trans *trans,
 }
 
 static inline int iwl_trans_tx_agg_alloc(struct iwl_trans *trans,
-					 enum iwl_rxon_context_id ctx,
-					 int sta_id, int tid, u16 *ssn)
+					 int sta_id, int tid)
 {
-	return trans->ops->tx_agg_alloc(trans, ctx, sta_id, tid, ssn);
+	return trans->ops->tx_agg_alloc(trans, sta_id, tid);
 }
 
 
-- 
1.7.0.4

