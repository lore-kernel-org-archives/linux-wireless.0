Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31394 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab1HMSSk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 50/60] iwlagn: set tx_fifo for ampdu in transport layer
Date: Sat, 13 Aug 2011 10:38:26 -0700
Message-Id: <1313257116-2697-51-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201956_836074_7370C71E)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

the mapping tx_queue -> fifo is really transport related. The upper
layer should be involved in such things.

Note that upon agg_disable, the queue is always mapped to fifo 0, but
this doesn't matter since when the queue will be setup again for a
new BA session, it will be configured to the good fifo anyway.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   65 +--------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    5 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    7 --
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   46 ++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    8 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   32 +++++++---
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   22 ++++----
 7 files changed, 89 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index fa359f4..2b8fb53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -42,43 +42,6 @@
 #include "iwl-agn.h"
 #include "iwl-trans.h"
 
-/*
- * mac80211 queues, ACs, hardware queues, FIFOs.
- *
- * Cf. http://wireless.kernel.org/en/developers/Documentation/mac80211/queues
- *
- * Mac80211 uses the following numbers, which we get as from it
- * by way of skb_get_queue_mapping(skb):
- *
- *	VO	0
- *	VI	1
- *	BE	2
- *	BK	3
- *
- *
- * Regular (not A-MPDU) frames are put into hardware queues corresponding
- * to the FIFOs, see comments in iwl-prph.h. Aggregated frames get their
- * own queue per aggregation session (RA/TID combination), such queues are
- * set up to map into FIFOs too, for which we need an AC->FIFO mapping. In
- * order to map frames to the right queue, we also need an AC->hw queue
- * mapping. This is implemented here.
- *
- * Due to the way hw queues are set up (by the hw specific modules like
- * iwl-4965.c, iwl-5000.c etc.), the AC->hw queue mapping is the identity
- * mapping.
- */
-
-static const u8 tid_to_ac[] = {
-	IEEE80211_AC_BE,
-	IEEE80211_AC_BK,
-	IEEE80211_AC_BK,
-	IEEE80211_AC_BE,
-	IEEE80211_AC_VI,
-	IEEE80211_AC_VI,
-	IEEE80211_AC_VO,
-	IEEE80211_AC_VO
-};
-
 static inline int get_ac_from_tid(u16 tid)
 {
 	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
@@ -88,15 +51,6 @@ static inline int get_ac_from_tid(u16 tid)
 	return -EINVAL;
 }
 
-static inline int get_fifo_from_tid(struct iwl_rxon_context *ctx, u16 tid)
-{
-	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
-		return ctx->ac_to_fifo[tid_to_ac[tid]];
-
-	/* no support for TIDs 8-15 yet */
-	return -EINVAL;
-}
-
 static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id, int sta_id,
 				int tid)
 {
@@ -508,16 +462,11 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	int sta_id;
-	int tx_fifo;
 	int txq_id;
 	int ret;
 	unsigned long flags;
 	struct iwl_tid_data *tid_data;
 
-	tx_fifo = get_fifo_from_tid(iwl_rxon_ctx_from_vif(vif), tid);
-	if (unlikely(tx_fifo < 0))
-		return tx_fifo;
-
 	IWL_DEBUG_HT(priv, "TX AGG request on ra = %pM tid = %d\n",
 		     sta->addr, tid);
 
@@ -544,7 +493,6 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	tid_data = &priv->shrd->tid_data[sta_id][tid];
 	*ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
-	tid_data->agg.tx_fifo = tx_fifo;
 	iwl_set_swq_id(&priv->txq[txq_id], get_ac_from_tid(tid), txq_id);
 	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
@@ -570,15 +518,11 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid)
 {
-	int tx_fifo_id, txq_id, sta_id, ssn;
+	int txq_id, sta_id, ssn;
 	struct iwl_tid_data *tid_data;
 	int write_ptr, read_ptr;
 	unsigned long flags;
 
-	tx_fifo_id = get_fifo_from_tid(iwl_rxon_ctx_from_vif(vif), tid);
-	if (unlikely(tx_fifo_id < 0))
-		return tx_fifo_id;
-
 	sta_id = iwl_sta_id(sta);
 
 	if (sta_id == IWL_INVALID_STATION) {
@@ -635,7 +579,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	 * to deactivate the uCode queue, just return "success" to allow
 	 *  mac80211 to clean up it own data.
 	 */
-	iwl_trans_txq_agg_disable(trans(priv), txq_id, ssn, tx_fifo_id);
+	iwl_trans_txq_agg_disable(trans(priv), txq_id);
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
@@ -661,11 +605,8 @@ static int iwlagn_txq_check_empty(struct iwl_priv *priv,
 		/* aggregated HW queue */
 		if ((txq_id  == tid_data->agg.txq_id) &&
 		    (q->read_ptr == q->write_ptr)) {
-			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
-			int tx_fifo = get_fifo_from_tid(ctx, tid);
 			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
-			iwl_trans_txq_agg_disable(trans(priv), txq_id,
-				ssn, tx_fifo);
+			iwl_trans_txq_agg_disable(trans(priv), txq_id);
 			tid_data->agg.state = IWL_AGG_OFF;
 			ieee80211_stop_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 868770b..da04c85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2531,6 +2531,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = hw->priv;
 	int ret = -EINVAL;
 	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
+	struct iwl_rxon_context *ctx =  iwl_rxon_ctx_from_vif(vif);
 
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
@@ -2584,8 +2585,8 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
 
-		iwl_trans_txq_agg_setup(trans(priv), iwl_sta_id(sta), tid,
-				buf_size);
+		iwl_trans_txq_agg_setup(trans(priv), ctx->ctxid, iwl_sta_id(sta),
+				tid, buf_size);
 
 		/*
 		 * If the limit is 0, then it wasn't initialised yet,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9c1163c..b490a2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -960,13 +960,6 @@ struct iwl_notification_wait {
 	bool triggered, aborted;
 };
 
-enum iwl_rxon_context_id {
-	IWL_RXON_CTX_BSS,
-	IWL_RXON_CTX_PAN,
-
-	NUM_IWL_RXON_CTX
-};
-
 struct iwl_rxon_context {
 	struct ieee80211_vif *vif;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index db606a6..4cfa31e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -67,6 +67,7 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/gfp.h>
+#include <net/mac80211.h>
 
 #include "iwl-commands.h"
 
@@ -192,7 +193,6 @@ struct iwl_ht_agg {
 #define IWL_EMPTYING_HW_QUEUE_ADDBA 2
 #define IWL_EMPTYING_HW_QUEUE_DELBA 3
 	u8 state;
-	u8 tx_fifo;
 };
 
 struct iwl_tid_data {
@@ -284,6 +284,50 @@ struct iwl_rx_mem_buffer {
 
 #define rxb_addr(r) page_address(r->page)
 
+/*
+ * mac80211 queues, ACs, hardware queues, FIFOs.
+ *
+ * Cf. http://wireless.kernel.org/en/developers/Documentation/mac80211/queues
+ *
+ * Mac80211 uses the following numbers, which we get as from it
+ * by way of skb_get_queue_mapping(skb):
+ *
+ *	VO	0
+ *	VI	1
+ *	BE	2
+ *	BK	3
+ *
+ *
+ * Regular (not A-MPDU) frames are put into hardware queues corresponding
+ * to the FIFOs, see comments in iwl-prph.h. Aggregated frames get their
+ * own queue per aggregation session (RA/TID combination), such queues are
+ * set up to map into FIFOs too, for which we need an AC->FIFO mapping. In
+ * order to map frames to the right queue, we also need an AC->hw queue
+ * mapping. This is implemented here.
+ *
+ * Due to the way hw queues are set up (by the hw specific modules like
+ * iwl-4965.c, iwl-5000.c etc.), the AC->hw queue mapping is the identity
+ * mapping.
+ */
+
+static const u8 tid_to_ac[] = {
+	IEEE80211_AC_BE,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BE,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VO,
+	IEEE80211_AC_VO
+};
+
+enum iwl_rxon_context_id {
+	IWL_RXON_CTX_BSS,
+	IWL_RXON_CTX_PAN,
+
+	NUM_IWL_RXON_CTX
+};
+
 #ifdef CONFIG_PM
 int iwl_suspend(struct iwl_priv *priv);
 int iwl_resume(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index 269d9e3..f443c10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -175,14 +175,14 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt);
-int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
-				  u16 ssn_idx, u8 tx_fifo);
+int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id);
 void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
 void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq,
 			     int tx_fifo_id, int scd_retry);
-void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
-						int frame_limit);
+void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv,
+					enum iwl_rxon_context_id ctx,
+					int sta_id, int tid, int frame_limit);
 void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	int index);
 void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index cc5ec2d..31adf99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -424,8 +424,18 @@ void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
 }
 
-void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
-						int frame_limit)
+static inline int get_fifo_from_tid(struct iwl_rxon_context *ctx, u16 tid)
+{
+	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
+		return ctx->ac_to_fifo[tid_to_ac[tid]];
+
+	/* no support for TIDs 8-15 yet */
+	return -EINVAL;
+}
+
+void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv,
+				  enum iwl_rxon_context_id ctx, int sta_id,
+				  int tid, int frame_limit)
 {
 	int tx_fifo, txq_id, ssn_idx;
 	u16 ra_tid;
@@ -441,11 +451,16 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	if (WARN_ON(tid >= IWL_MAX_TID_COUNT))
 		return;
 
+	tx_fifo = get_fifo_from_tid(&priv->contexts[ctx], tid);
+	if (WARN_ON(tx_fifo < 0)) {
+		IWL_ERR(trans, "txq_agg_setup, bad fifo: %d\n", tx_fifo);
+		return;
+	}
+
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	tid_data = &priv->shrd->tid_data[sta_id][tid];
 	ssn_idx = SEQ_TO_SN(tid_data->seq_number);
 	txq_id = tid_data->agg.txq_id;
-	tx_fifo = tid_data->agg.tx_fifo;
 	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	ra_tid = BUILD_RAxTID(sta_id, tid);
@@ -492,8 +507,7 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 }
 
-int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
-				  u16 ssn_idx, u8 tx_fifo)
+int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id)
 {
 	struct iwl_trans *trans = trans(priv);
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
@@ -511,14 +525,14 @@ int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 
 	iwl_clear_bits_prph(bus(priv), SCD_AGGR_SEL, (1 << txq_id));
 
-	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
-	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
+	priv->txq[txq_id].q.read_ptr = 0;
+	priv->txq[txq_id].q.write_ptr = 0;
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
-	iwl_trans_set_wr_ptrs(trans, txq_id, ssn_idx);
+	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
 
 	iwl_clear_bits_prph(bus(priv), SCD_INTERRUPT_MASK, (1 << txq_id));
 	iwl_txq_ctx_deactivate(priv, txq_id);
-	iwl_trans_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
+	iwl_trans_tx_queue_set_status(priv, &priv->txq[txq_id], 0, 0);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 2385de2..011c824 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -123,10 +123,10 @@ struct iwl_trans_ops {
 	void (*reclaim)(struct iwl_trans *trans, int txq_id, int ssn,
 			u32 status, struct sk_buff_head *skbs);
 
-	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id,
-				  u16 ssn_idx, u8 tx_fifo);
-	void (*txq_agg_setup)(struct iwl_priv *priv, int sta_id, int tid,
-						int frame_limit);
+	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id);
+	void (*txq_agg_setup)(struct iwl_priv *priv,
+			      enum iwl_rxon_context_id ctx, int sta_id,
+			      int tid, int frame_limit);
 
 	void (*kick_nic)(struct iwl_trans *trans);
 
@@ -209,17 +209,17 @@ static inline void iwl_trans_reclaim(struct iwl_trans *trans, int txq_id,
 	trans->ops->reclaim(trans, txq_id, ssn, status, skbs);
 }
 
-static inline int iwl_trans_txq_agg_disable(struct iwl_trans *trans, u16 txq_id,
-			  u16 ssn_idx, u8 tx_fifo)
+static inline int iwl_trans_txq_agg_disable(struct iwl_trans *trans, u16 txq_id)
 {
-	return trans->ops->txq_agg_disable(priv(trans), txq_id,
-					   ssn_idx, tx_fifo);
+	return trans->ops->txq_agg_disable(priv(trans), txq_id);
 }
 
-static inline void iwl_trans_txq_agg_setup(struct iwl_trans *trans, int sta_id,
-						int tid, int frame_limit)
+static inline void iwl_trans_txq_agg_setup(struct iwl_trans *trans,
+					   enum iwl_rxon_context_id ctx,
+					   int sta_id, int tid,
+					   int frame_limit)
 {
-	trans->ops->txq_agg_setup(priv(trans), sta_id, tid, frame_limit);
+	trans->ops->txq_agg_setup(priv(trans), ctx, sta_id, tid, frame_limit);
 }
 
 static inline void iwl_trans_kick_nic(struct iwl_trans *trans)
-- 
1.7.0.4

