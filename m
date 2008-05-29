Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbYE2Ihn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:43 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 27/43] iwlwifi: move tx reclaim flow into iwl-tx
Date: Thu, 29 May 2008 16:35:12 +0800
Message-Id: <1212050128-17132-28-git-send-email-yi.zhu@intel.com> (sfid-20080529_110547_985121_D7ED132F)
In-Reply-To: <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch
1. moves TX reclaim flow into iwl-tx
2. separates command queue and tx queue reclaim flow

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-tx.c       |  108 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   93 +-----------------------
 6 files changed, 116 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 98f3df0..1d95e8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3132,7 +3132,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 		/* calculate mac80211 ampdu sw queue to wake */
 		int ampdu_q =
 		   scd_flow - IWL_BACK_QUEUE_FIRST_ID + priv->hw->queues;
-		int freed = iwl4965_tx_queue_reclaim(priv, scd_flow, index);
+		int freed = iwl_tx_queue_reclaim(priv, scd_flow, index);
 		priv->stations[ba_resp->sta_id].
 			tid[ba_resp->tid].tfds_in_queue -= freed;
 		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
@@ -3673,7 +3673,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
 			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
-			freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
+			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 
 			if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
@@ -3705,7 +3705,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
 #ifdef CONFIG_IWL4965_HT
 	if (index != -1) {
-		int freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
+		int freed = iwl_tx_queue_reclaim(priv, txq_id, index);
 		if (tid != MAX_TID_COUNT)
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index cfabcb0..dc9f3b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1159,7 +1159,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
 			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
-			freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
+			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 
 			if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
@@ -1191,7 +1191,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
 #ifdef CONFIG_IWL4965_HT
 	if (index != -1) {
-		int freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
+		int freed = iwl_tx_queue_reclaim(priv, txq_id, index);
 		if (tid != MAX_TID_COUNT)
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 9449b61..8264b4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -205,6 +205,8 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwl_rx_queue_restock(struct iwl_priv *priv);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
 void iwl_rx_allocate(struct iwl_priv *priv);
+void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
+int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 /* Handlers */
 void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9343313..8c258d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -714,7 +714,6 @@ extern int iwl4965_get_temperature(const struct iwl_priv *priv);
 extern u8 iwl_find_station(struct iwl_priv *priv, const u8 *bssid);
 
 extern int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel);
-extern int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 extern int iwl_queue_space(const struct iwl_queue *q);
 static inline int iwl_queue_used(const struct iwl_queue *q, int i)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 885a4c1..b2b2ed2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1060,6 +1060,114 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	return ret ? ret : idx;
 }
 
+int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
+{
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+	struct iwl_tx_info *tx_info;
+	int nfreed = 0;
+
+	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
+		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
+			  "is out of range [0-%d] %d %d.\n", txq_id,
+			  index, q->n_bd, q->write_ptr, q->read_ptr);
+		return 0;
+	}
+
+	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+
+		tx_info = &txq->txb[txq->q.read_ptr];
+		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
+		tx_info->skb[0] = NULL;
+		iwl_hw_txq_free_tfd(priv, txq);
+
+		nfreed++;
+	}
+	return nfreed;
+}
+EXPORT_SYMBOL(iwl_tx_queue_reclaim);
+
+
+/**
+ * iwl_hcmd_queue_reclaim - Reclaim TX command queue entries already Tx'd
+ *
+ * When FW advances 'R' index, all entries between old and new 'R' index
+ * need to be reclaimed. As result, some free space forms.  If there is
+ * enough free space (> low mark), wake the stack that feeds us.
+ */
+static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
+{
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+	int nfreed = 0;
+
+	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
+		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
+			  "is out of range [0-%d] %d %d.\n", txq_id,
+			  index, q->n_bd, q->write_ptr, q->read_ptr);
+		return;
+	}
+
+	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+
+		if (nfreed > 1) {
+			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", index,
+					q->write_ptr, q->read_ptr);
+			queue_work(priv->workqueue, &priv->restart);
+		}
+		nfreed++;
+	}
+}
+
+/**
+ * iwl_tx_cmd_complete - Pull unused buffers off the queue and reclaim them
+ * @rxb: Rx buffer to reclaim
+ *
+ * If an Rx buffer has an async callback associated with it the callback
+ * will be executed.  The attached skb (if present) will only be freed
+ * if the callback returns 1
+ */
+void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
+	int txq_id = SEQ_TO_QUEUE(sequence);
+	int index = SEQ_TO_INDEX(sequence);
+	int huge = sequence & SEQ_HUGE_FRAME;
+	int cmd_index;
+	struct iwl_cmd *cmd;
+
+	/* If a Tx command is being handled and it isn't in the actual
+	 * command queue then there a command routing bug has been introduced
+	 * in the queue management code. */
+	if (txq_id != IWL_CMD_QUEUE_NUM)
+		IWL_ERROR("Error wrong command queue %d command id 0x%X\n",
+			  txq_id, pkt->hdr.cmd);
+	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
+
+	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
+	cmd = &priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
+
+	/* Input error checking is done when commands are added to queue. */
+	if (cmd->meta.flags & CMD_WANT_SKB) {
+		cmd->meta.source->u.skb = rxb->skb;
+		rxb->skb = NULL;
+	} else if (cmd->meta.u.callback &&
+		   !cmd->meta.u.callback(priv, cmd, rxb->skb))
+		rxb->skb = NULL;
+
+	iwl_hcmd_queue_reclaim(priv, txq_id, index);
+
+	if (!(cmd->meta.flags & CMD_ASYNC)) {
+		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
+		wake_up_interruptible(&priv->wait_command_queue);
+	}
+}
+EXPORT_SYMBOL(iwl_tx_cmd_complete);
+
+
 #ifdef CONFIG_IWLWIF_DEBUG
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 10d7734..4322cd6 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1535,51 +1535,6 @@ static int iwl4965_get_measurement(struct iwl_priv *priv,
 }
 #endif
 
-static void iwl4965_txstatus_to_ieee(struct iwl_priv *priv,
-				     struct iwl_tx_info *tx_sta)
-{
-	ieee80211_tx_status_irqsafe(priv->hw, tx_sta->skb[0]);
-	tx_sta->skb[0] = NULL;
-}
-
-/**
- * iwl4965_tx_queue_reclaim - Reclaim Tx queue entries already Tx'd
- *
- * When FW advances 'R' index, all entries between old and new 'R' index
- * need to be reclaimed. As result, some free space forms.  If there is
- * enough free space (> low mark), wake the stack that feeds us.
- */
-int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
-{
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
-	int nfreed = 0;
-
-	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
-		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
-			  "is out of range [0-%d] %d %d.\n", txq_id,
-			  index, q->n_bd, q->write_ptr, q->read_ptr);
-		return 0;
-	}
-
-	for (index = iwl_queue_inc_wrap(index, q->n_bd);
-		q->read_ptr != index;
-		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
-		if (txq_id != IWL_CMD_QUEUE_NUM) {
-			iwl4965_txstatus_to_ieee(priv,
-					&(txq->txb[txq->q.read_ptr]));
-			iwl_hw_txq_free_tfd(priv, txq);
-		} else if (nfreed > 1) {
-			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", index,
-					q->write_ptr, q->read_ptr);
-			queue_work(priv->workqueue, &priv->restart);
-		}
-		nfreed++;
-	}
-
-	return nfreed;
-}
-
 /******************************************************************************
  *
  * Generic RX handler implementations
@@ -1961,52 +1916,6 @@ static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 	priv->cfg->ops->lib->rx_handler_setup(priv);
 }
 
-/**
- * iwl4965_tx_cmd_complete - Pull unused buffers off the queue and reclaim them
- * @rxb: Rx buffer to reclaim
- *
- * If an Rx buffer has an async callback associated with it the callback
- * will be executed.  The attached skb (if present) will only be freed
- * if the callback returns 1
- */
-static void iwl4965_tx_cmd_complete(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
-	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_INDEX(sequence);
-	int huge = sequence & SEQ_HUGE_FRAME;
-	int cmd_index;
-	struct iwl_cmd *cmd;
-
-	/* If a Tx command is being handled and it isn't in the actual
-	 * command queue then there a command routing bug has been introduced
-	 * in the queue management code. */
-	if (txq_id != IWL_CMD_QUEUE_NUM)
-		IWL_ERROR("Error wrong command queue %d command id 0x%X\n",
-			  txq_id, pkt->hdr.cmd);
-	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
-
-	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
-	cmd = &priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
-
-	/* Input error checking is done when commands are added to queue. */
-	if (cmd->meta.flags & CMD_WANT_SKB) {
-		cmd->meta.source->u.skb = rxb->skb;
-		rxb->skb = NULL;
-	} else if (cmd->meta.u.callback &&
-		   !cmd->meta.u.callback(priv, cmd, rxb->skb))
-		rxb->skb = NULL;
-
-	iwl4965_tx_queue_reclaim(priv, txq_id, index);
-
-	if (!(cmd->meta.flags & CMD_ASYNC)) {
-		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-		wake_up_interruptible(&priv->wait_command_queue);
-	}
-}
-
 /*
  * this should be called while priv->lock is locked
 */
@@ -2095,7 +2004,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 			 * fire off the (possibly) blocking iwl_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb && rxb->skb)
-				iwl4965_tx_cmd_complete(priv, rxb);
+				iwl_tx_cmd_complete(priv, rxb);
 			else
 				IWL_WARNING("Claim null rxb?\n");
 		}
-- 
1.5.3.6

