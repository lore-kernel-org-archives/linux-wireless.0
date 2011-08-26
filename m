Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7217 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab1HZGxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 53/60] iwlagn: allocate resources for TX BA session in transport
Date: Thu, 25 Aug 2011 23:11:25 -0700
Message-Id: <1314339092-20797-54-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085358_005749_F70161E5)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The queues and all the related logic suits to the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   77 ++-------------------
 drivers/net/wireless/iwlwifi/iwl-core.c           |    9 +++
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   12 +++
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   53 ++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   12 +++
 7 files changed, 94 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 7da65a4..e4df664 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -42,33 +42,6 @@
 #include "iwl-agn.h"
 #include "iwl-trans.h"
 
-static inline int get_ac_from_tid(u16 tid)
-{
-	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
-		return tid_to_ac[tid];
-
-	/* no support for TIDs 8-15 yet */
-	return -EINVAL;
-}
-
-static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id, int sta_id,
-				int tid)
-{
-	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWLAGN_FIRST_AMPDU_QUEUE +
-		hw_params(priv).num_ampdu_queues <= txq_id)) {
-		IWL_WARN(priv,
-			"queue number out of range: %d, must be %d to %d\n",
-			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
-			IWLAGN_FIRST_AMPDU_QUEUE +
-			hw_params(priv).num_ampdu_queues - 1);
-		return -EINVAL;
-	}
-
-	/* Modify device's station table to Tx this TID */
-	return iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
-}
-
 static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
 				     struct ieee80211_tx_info *info,
 				     __le16 fc, __le32 *tx_flags)
@@ -399,30 +372,12 @@ drop_unlock_priv:
 	return -1;
 }
 
-/*
- * Find first available (lowest unused) Tx Queue, mark it "active".
- * Called only when finding queue for aggregation.
- * Should never return anything < 7, because they should already
- * be in use as EDCA AC (0-3), Command (4), reserved (5, 6)
- */
-static int iwlagn_txq_ctx_activate_free(struct iwl_priv *priv)
-{
-	int txq_id;
-
-	for (txq_id = 0; txq_id < hw_params(priv).max_txq_num; txq_id++)
-		if (!test_and_set_bit(txq_id, &priv->txq_ctx_active_msk))
-			return txq_id;
-	return -1;
-}
-
 int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	int sta_id;
-	int txq_id;
 	int ret;
-	unsigned long flags;
-	struct iwl_tid_data *tid_data;
 
 	IWL_DEBUG_HT(priv, "TX AGG request on ra = %pM tid = %d\n",
 		     sta->addr, tid);
@@ -440,35 +395,13 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return -ENXIO;
 	}
 
-	txq_id = iwlagn_txq_ctx_activate_free(priv);
-	if (txq_id == -1) {
-		IWL_ERR(priv, "No free aggregation queue available\n");
-		return -ENXIO;
-	}
-
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	tid_data = &priv->shrd->tid_data[sta_id][tid];
-	*ssn = SEQ_TO_SN(tid_data->seq_number);
-	tid_data->agg.txq_id = txq_id;
-	iwl_set_swq_id(&priv->txq[txq_id], get_ac_from_tid(tid), txq_id);
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
-
-	ret = iwlagn_txq_agg_enable(priv, txq_id, sta_id, tid);
+	ret = iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
 	if (ret)
 		return ret;
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	tid_data = &priv->shrd->tid_data[sta_id][tid];
-	if (tid_data->tfds_in_queue == 0) {
-		IWL_DEBUG_HT(priv, "HW queue is empty\n");
-		tid_data->agg.state = IWL_AGG_ON;
-		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-	} else {
-		IWL_DEBUG_HT(priv, "HW queue is NOT empty: %d packets in HW queue\n",
-			     tid_data->tfds_in_queue);
-		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
-	}
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	ret = iwl_trans_tx_agg_alloc(trans(priv), vif_priv->ctx->ctxid, sta_id,
+				     tid, ssn);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 411edc8..49c4f91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1858,3 +1858,12 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 	return cpu_to_le32(res);
 }
 
+void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv, u8 ctx,
+				 u8 sta_id, u8 tid)
+{
+	struct ieee80211_vif *vif = priv->contexts[ctx].vif;
+	u8 *addr = priv->stations[sta_id].sta.sta.addr;
+
+	ieee80211_start_tx_ba_cb_irqsafe(vif, addr, tid);
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 4cfa31e..a2be28a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -321,6 +321,15 @@ static const u8 tid_to_ac[] = {
 	IEEE80211_AC_VO
 };
 
+static inline int get_ac_from_tid(u16 tid)
+{
+	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
+		return tid_to_ac[tid];
+
+	/* no support for TIDs 8-15 yet */
+	return -EINVAL;
+}
+
 enum iwl_rxon_context_id {
 	IWL_RXON_CTX_BSS,
 	IWL_RXON_CTX_PAN,
@@ -337,6 +346,9 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 		struct iwl_cfg *cfg);
 void __devexit iwl_remove(struct iwl_priv * priv);
 
+void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv, u8 ctx,
+				 u8 sta_id, u8 tid);
+
 /*****************************************************
 * DRIVER STATUS FUNCTIONS
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index d73ebef..ece9408 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -194,6 +194,9 @@ void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
 void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq,
 			     int tx_fifo_id, int scd_retry);
+int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
+				enum iwl_rxon_context_id ctx, int sta_id,
+				int tid, u16 *ssn);
 void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv,
 					enum iwl_rxon_context_id ctx,
 					int sta_id, int tid, int frame_limit);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index aa67f9a..0b05048 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -29,7 +29,6 @@
 #include <linux/etherdevice.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <net/mac80211.h>
 
 #include "iwl-agn.h"
 #include "iwl-dev.h"
@@ -509,6 +508,58 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv,
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 }
 
+/*
+ * Find first available (lowest unused) Tx Queue, mark it "active".
+ * Called only when finding queue for aggregation.
+ * Should never return anything < 7, because they should already
+ * be in use as EDCA AC (0-3), Command (4), reserved (5, 6)
+ */
+static int iwlagn_txq_ctx_activate_free(struct iwl_trans *trans)
+{
+	int txq_id;
+
+	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++)
+		if (!test_and_set_bit(txq_id,
+					&priv(trans)->txq_ctx_active_msk))
+			return txq_id;
+	return -1;
+}
+
+int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
+				enum iwl_rxon_context_id ctx, int sta_id,
+				int tid, u16 *ssn)
+{
+	struct iwl_tid_data *tid_data;
+	unsigned long flags;
+	u16 txq_id;
+	struct iwl_priv *priv = priv(trans);
+
+	txq_id = iwlagn_txq_ctx_activate_free(trans);
+	if (txq_id == -1) {
+		IWL_ERR(trans, "No free aggregation queue available\n");
+		return -ENXIO;
+	}
+
+	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
+	tid_data = &trans->shrd->tid_data[sta_id][tid];
+	*ssn = SEQ_TO_SN(tid_data->seq_number);
+	tid_data->agg.txq_id = txq_id;
+	iwl_set_swq_id(&priv->txq[txq_id], get_ac_from_tid(tid), txq_id);
+
+	tid_data = &trans->shrd->tid_data[sta_id][tid];
+	if (tid_data->tfds_in_queue == 0) {
+		IWL_DEBUG_HT(trans, "HW queue is empty\n");
+		tid_data->agg.state = IWL_AGG_ON;
+		iwl_start_tx_ba_trans_ready(priv(trans), ctx, sta_id, tid);
+	} else {
+		IWL_DEBUG_HT(trans, "HW queue is NOT empty: %d packets in HW"
+			     "queue\n", tid_data->tfds_in_queue);
+		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
+	}
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+
+	return 0;
+}
 int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id)
 {
 	struct iwl_trans *trans = trans(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 133b227..13e8fdc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1957,6 +1957,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.reclaim = iwl_trans_pcie_reclaim,
 
 	.txq_agg_disable = iwl_trans_pcie_txq_agg_disable,
+	.tx_agg_alloc = iwl_trans_pcie_tx_agg_alloc,
 	.txq_agg_setup = iwl_trans_pcie_txq_agg_setup,
 
 	.kick_nic = iwl_trans_pcie_kick_nic,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0fee884..8aaab08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -94,6 +94,7 @@ struct iwl_device_cmd;
  * @send_cmd_pdu:send a host command: flags can be CMD_*
  * @tx: send an skb
  * @reclaim: free packet until ssn. Returns a list of freed packets.
+ * @tx_agg_alloc: allocate resources for a TX BA session
  * @txq_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
  *                 ready and a successful ADDBA response has been received.
  * @txq_agg_disable: de-configure a Tx queue to send AMPDUs
@@ -126,6 +127,9 @@ struct iwl_trans_ops {
 			u32 status, struct sk_buff_head *skbs);
 
 	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id);
+	int (*tx_agg_alloc)(struct iwl_trans *trans,
+			    enum iwl_rxon_context_id ctx, int sta_id, int tid,
+			    u16 *ssn);
 	void (*txq_agg_setup)(struct iwl_priv *priv,
 			      enum iwl_rxon_context_id ctx, int sta_id,
 			      int tid, int frame_limit);
@@ -216,6 +220,14 @@ static inline int iwl_trans_txq_agg_disable(struct iwl_trans *trans, u16 txq_id)
 	return trans->ops->txq_agg_disable(priv(trans), txq_id);
 }
 
+static inline int iwl_trans_tx_agg_alloc(struct iwl_trans *trans,
+					 enum iwl_rxon_context_id ctx,
+					 int sta_id, int tid, u16 *ssn)
+{
+	return trans->ops->tx_agg_alloc(trans, ctx, sta_id, tid, ssn);
+}
+
+
 static inline void iwl_trans_txq_agg_setup(struct iwl_trans *trans,
 					   enum iwl_rxon_context_id ctx,
 					   int sta_id, int tid,
-- 
1.7.0.4

