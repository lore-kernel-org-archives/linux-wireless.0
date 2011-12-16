Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759919Ab1LPQhm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:42 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/24] iwlwifi: tid_data logic move to upper layer - check_empty
Date: Fri, 16 Dec 2011 07:37:15 -0800
Message-Id: <1324049849-831-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173757_506751_ABD5B68E)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The tid_data is not related to the transport layer, so move
the logic that depends on it to the upper layer.
This patch deals with the code that checks if there are still
pending packets for an RA / TID.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |   39 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   43 -------------------------
 2 files changed, 39 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index c46d50d..6321ea2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -588,6 +588,43 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			&sta_priv->lq_sta.lq, CMD_ASYNC, false);
 }
 
+static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
+{
+	struct iwl_tid_data *tid_data = &priv->shrd->tid_data[sta_id][tid];
+
+	lockdep_assert_held(&priv->shrd->sta_lock);
+
+	switch (priv->shrd->tid_data[sta_id][tid].agg.state) {
+	case IWL_EMPTYING_HW_QUEUE_DELBA:
+		/* There are no packets for this RA / TID in the HW any more */
+		if (tid_data->agg.ssn == tid_data->next_reclaimed) {
+			IWL_DEBUG_TX_QUEUES(priv,
+				"Can continue DELBA flow ssn = next_recl ="
+				" %d", tid_data->next_reclaimed);
+			iwl_trans_tx_agg_disable(trans(priv), sta_id, tid);
+			tid_data->agg.state = IWL_AGG_OFF;
+			iwl_stop_tx_ba_trans_ready(priv,
+						   NUM_IWL_RXON_CTX,
+						   sta_id, tid);
+		}
+		break;
+	case IWL_EMPTYING_HW_QUEUE_ADDBA:
+		/* There are no packets for this RA / TID in the HW any more */
+		if (tid_data->agg.ssn == tid_data->next_reclaimed) {
+			IWL_DEBUG_TX_QUEUES(priv,
+				"Can continue ADDBA flow ssn = next_recl ="
+				" %d", tid_data->next_reclaimed);
+			tid_data->agg.state = IWL_AGG_ON;
+			iwl_start_tx_ba_trans_ready(priv,
+						    NUM_IWL_RXON_CTX,
+						    sta_id, tid);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 static void iwlagn_non_agg_tx_status(struct iwl_priv *priv,
 				     struct iwl_rxon_context *ctx,
 				     const u8 *addr1)
@@ -965,6 +1002,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 		/*we can free until ssn % q.n_bd not inclusive */
 		iwl_trans_reclaim(trans(priv), sta_id, tid, txq_id,
 				  ssn, status, &skbs);
+		iwlagn_check_ratid_empty(priv, sta_id, tid);
 		freed = 0;
 		while (!skb_queue_empty(&skbs)) {
 			skb = __skb_dequeue(&skbs);
@@ -1120,6 +1158,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	priv->shrd->tid_data[sta_id][tid].next_reclaimed = ba_resp_scd_ssn;
 	iwl_trans_reclaim(trans(priv), sta_id, tid, scd_flow, ba_resp_scd_ssn,
 			  0, &reclaimed_skbs);
+	iwlagn_check_ratid_empty(priv, sta_id, tid);
 	freed = 0;
 	while (!skb_queue_empty(&reclaimed_skbs)) {
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 15bee2b..5d44ec5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1275,47 +1275,6 @@ static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 	return 0;
 }
 
-static int iwlagn_txq_check_empty(struct iwl_trans *trans,
-			   int sta_id, u8 tid, int txq_id)
-{
-	struct iwl_tid_data *tid_data = &trans->shrd->tid_data[sta_id][tid];
-
-	lockdep_assert_held(&trans->shrd->sta_lock);
-
-	switch (trans->shrd->tid_data[sta_id][tid].agg.state) {
-	case IWL_EMPTYING_HW_QUEUE_DELBA:
-		/* There are no packets for this RA / TID in the HW any more */
-		if ((txq_id  == tid_data->agg.txq_id) &&
-		    (tid_data->agg.ssn == tid_data->next_reclaimed)) {
-			IWL_DEBUG_TX_QUEUES(trans,
-				"Can continue DELBA flow ssn = next_recl ="
-				" %d", tid_data->next_reclaimed);
-			iwl_trans_pcie_tx_agg_disable(trans, sta_id, tid);
-			tid_data->agg.state = IWL_AGG_OFF;
-			iwl_stop_tx_ba_trans_ready(priv(trans),
-						   NUM_IWL_RXON_CTX,
-						   sta_id, tid);
-		}
-		break;
-	case IWL_EMPTYING_HW_QUEUE_ADDBA:
-		/* There are no packets for this RA / TID in the HW any more */
-		if (tid_data->agg.ssn == tid_data->next_reclaimed) {
-			IWL_DEBUG_TX_QUEUES(trans,
-				"Can continue ADDBA flow ssn = next_recl ="
-				" %d", tid_data->next_reclaimed);
-			tid_data->agg.state = IWL_AGG_ON;
-			iwl_start_tx_ba_trans_ready(priv(trans),
-						    NUM_IWL_RXON_CTX,
-						    sta_id, tid);
-		}
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 		      int txq_id, int ssn, u32 status,
 		      struct sk_buff_head *skbs)
@@ -1338,8 +1297,6 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 		   status != TX_STATUS_FAIL_PASSIVE_NO_RX))
 			iwl_wake_queue(trans, txq, "Packets reclaimed");
 	}
-
-	iwlagn_txq_check_empty(trans, sta_id, tid, txq_id);
 }
 
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
-- 
1.7.0.4

