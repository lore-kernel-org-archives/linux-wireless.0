Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38048 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1HMSSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 49/60] iwlagn: upper layer stores iwl_rxon_context in skb's CB
Date: Sat, 13 Aug 2011 10:38:25 -0700
Message-Id: <1313257116-2697-50-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_204257_257286_64BCFF8F)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This removes the need for iwl_tx_info.
Each tx queue holds an array of skbs, the transport layer doesn't
need to know anything about the context in which a specific skb is
sent.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |    4 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   12 ++--------
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |   19 +++++------------
 drivers/net/wireless/iwlwifi/iwl-trans.c         |   23 +++++++++------------
 drivers/net/wireless/iwlwifi/iwl-trans.h         |    8 ++----
 5 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 872e39d..fa359f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -454,7 +454,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	iwl_update_stats(priv, true, fc, len);
 
-	if (iwl_trans_tx(trans(priv), skb, tx_cmd, txq_id, fc, is_agg, ctx))
+	info->driver_data[0] = ctx;
+
+	if (iwl_trans_tx(trans(priv), skb, tx_cmd, txq_id, fc, is_agg))
 		goto drop_unlock_sta;
 
 	if (ieee80211_is_data_qos(fc)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cf80fe8..9c1163c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -145,12 +145,6 @@ struct iwl_queue {
 				* space less than this */
 };
 
-/* One for each TFD */
-struct iwl_tx_info {
-	struct sk_buff *skb;
-	struct iwl_rxon_context *ctx;
-};
-
 /**
  * struct iwl_tx_queue - Tx Queue for DMA
  * @q: generic Rx/Tx queue descriptor
@@ -176,7 +170,7 @@ struct iwl_tx_queue {
 	struct iwl_tfd *tfds;
 	struct iwl_device_cmd **cmd;
 	struct iwl_cmd_meta *meta;
-	struct iwl_tx_info *txb;
+	struct sk_buff **skbs;
 	unsigned long time_stamp;
 	u8 need_update;
 	u8 sched_retry;
@@ -1375,9 +1369,9 @@ extern struct iwl_mod_params iwlagn_mod_params;
 static inline struct ieee80211_hdr *iwl_tx_queue_get_hdr(struct iwl_priv *priv,
 							 int txq_id, int idx)
 {
-	if (priv->txq[txq_id].txb[idx].skb)
+	if (priv->txq[txq_id].skbs[idx])
 		return (struct ieee80211_hdr *)priv->txq[txq_id].
-				txb[idx].skb->data;
+				skbs[idx]->data;
 	return NULL;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 0a57688..cc5ec2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -215,15 +215,15 @@ void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 			 DMA_TO_DEVICE);
 
 	/* free SKB */
-	if (txq->txb) {
+	if (txq->skbs) {
 		struct sk_buff *skb;
 
-		skb = txq->txb[index].skb;
+		skb = txq->skbs[index];
 
 		/* can be called from irqs-disabled context */
 		if (skb) {
 			dev_kfree_skb_any(skb);
-			txq->txb[index].skb = NULL;
+			txq->skbs[index] = NULL;
 		}
 	}
 }
@@ -1056,8 +1056,6 @@ void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 {
 	struct iwl_tx_queue *txq = &priv(trans)->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
-	struct iwl_tx_info *tx_info;
-	struct ieee80211_tx_info *info;
 	int last_to_free;
 
 	/*Since we free until index _not_ inclusive, the one before index is
@@ -1083,17 +1081,12 @@ void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 	     q->read_ptr != index;
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
-		tx_info = &txq->txb[txq->q.read_ptr];
-
-		if (WARN_ON_ONCE(tx_info->skb == NULL))
+		if (WARN_ON_ONCE(txq->skbs[txq->q.read_ptr] == NULL))
 			continue;
 
-		info = IEEE80211_SKB_CB(tx_info->skb);
-		info->driver_data[0] = tx_info->ctx;
-
-		__skb_queue_tail(skbs, tx_info->skb);
+		__skb_queue_tail(skbs, txq->skbs[txq->q.read_ptr]);
 
-		tx_info->skb = NULL;
+		txq->skbs[txq->q.read_ptr] = NULL;
 
 		iwlagn_txq_inval_byte_cnt_tbl(trans, txq);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 0a3dd6b..e545898 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -304,7 +304,7 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 	size_t tfd_sz = sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX;
 	int i;
 
-	if (WARN_ON(txq->meta || txq->cmd || txq->txb || txq->tfds))
+	if (WARN_ON(txq->meta || txq->cmd || txq->skbs || txq->tfds))
 		return -EINVAL;
 
 	txq->q.n_window = slots_num;
@@ -328,15 +328,15 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 	/* Driver private data, only for Tx (not command) queues,
 	 * not shared with device. */
 	if (txq_id != trans->shrd->cmd_queue) {
-		txq->txb = kzalloc(sizeof(txq->txb[0]) *
+		txq->skbs = kzalloc(sizeof(txq->skbs[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
-		if (!txq->txb) {
+		if (!txq->skbs) {
 			IWL_ERR(trans, "kmalloc for auxiliary BD "
 				  "structures failed\n");
 			goto error;
 		}
 	} else {
-		txq->txb = NULL;
+		txq->skbs = NULL;
 	}
 
 	/* Circular buffer of transmit frame descriptors (TFDs),
@@ -351,8 +351,8 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 
 	return 0;
 error:
-	kfree(txq->txb);
-	txq->txb = NULL;
+	kfree(txq->skbs);
+	txq->skbs = NULL;
 	/* since txq->cmd has been zeroed,
 	 * all non allocated cmd[i] will be NULL */
 	if (txq->cmd)
@@ -453,8 +453,8 @@ static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 	}
 
 	/* De-alloc array of per-TFD driver data */
-	kfree(txq->txb);
-	txq->txb = NULL;
+	kfree(txq->skbs);
+	txq->skbs = NULL;
 
 	/* deallocate arrays */
 	kfree(txq->cmd);
@@ -1035,8 +1035,7 @@ static struct iwl_tx_cmd *iwl_trans_pcie_get_tx_cmd(struct iwl_trans *trans,
 }
 
 static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
-		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
-		struct iwl_rxon_context *ctx)
+		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
@@ -1051,9 +1050,7 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	u8 hdr_len = ieee80211_hdrlen(fc);
 
 	/* Set up driver data for this TFD */
-	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
-	txq->txb[q->write_ptr].skb = skb;
-	txq->txb[q->write_ptr].ctx = ctx;
+	txq->skbs[q->write_ptr] = skb;
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_meta = &txq->meta[q->write_ptr];
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index e72e480..2385de2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -119,8 +119,7 @@ struct iwl_trans_ops {
 		     const void *data);
 	struct iwl_tx_cmd * (*get_tx_cmd)(struct iwl_trans *trans, int txq_id);
 	int (*tx)(struct iwl_priv *priv, struct sk_buff *skb,
-		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
-		struct iwl_rxon_context *ctx);
+		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu);
 	void (*reclaim)(struct iwl_trans *trans, int txq_id, int ssn,
 			u32 status, struct sk_buff_head *skbs);
 
@@ -198,10 +197,9 @@ static inline struct iwl_tx_cmd *iwl_trans_get_tx_cmd(struct iwl_trans *trans,
 }
 
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
-		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
-		struct iwl_rxon_context *ctx)
+		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu)
 {
-	return trans->ops->tx(priv(trans), skb, tx_cmd, txq_id, fc, ampdu, ctx);
+	return trans->ops->tx(priv(trans), skb, tx_cmd, txq_id, fc, ampdu);
 }
 
 static inline void iwl_trans_reclaim(struct iwl_trans *trans, int txq_id,
-- 
1.7.0.4

