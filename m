Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43434 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759144AbYCGBkW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 20:40:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/4] iwlwifi: 3945 split tx_complete to command and packet function
Date: Thu,  6 Mar 2008 17:36:55 -0800
Message-Id: <1204853816-8964-4-git-send-email-reinette.chatre@intel.com> (sfid-20080307_014030_134586_3DAE3E1A)
In-Reply-To: <1204853816-8964-3-git-send-email-reinette.chatre@intel.com>
References: <1204853816-8964-1-git-send-email-reinette.chatre@intel.com>
 <1204853816-8964-2-git-send-email-reinette.chatre@intel.com>
 <1204853816-8964-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch
1. removes cmd completion from iwl3945_tx_queue_reclaim
and creates iwl3945_cmd_queue_reclaim.
1. removes 11n relevant elements from this function
2. removes call to ieee80211_tx_status_irqsafe
and uses ieee80211_tx_status only

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |  117 ++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  188 +++++----------------------
 2 files changed, 148 insertions(+), 157 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 49b7811..dc3d695 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -227,14 +227,126 @@ __le32 iwl3945_get_antenna_flags(const struct iwl3945_priv *priv)
 	return 0;		/* "diversity" is default if error */
 }
 
+#ifdef CONFIG_IWL3945_DEBUG
+#define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
+
+static const char *iwl3945_get_tx_fail_reason(u32 status)
+{
+	switch (status & TX_STATUS_MSK) {
+	case TX_STATUS_SUCCESS:
+		return "SUCCESS";
+		TX_STATUS_ENTRY(SHORT_LIMIT);
+		TX_STATUS_ENTRY(LONG_LIMIT);
+		TX_STATUS_ENTRY(FIFO_UNDERRUN);
+		TX_STATUS_ENTRY(MGMNT_ABORT);
+		TX_STATUS_ENTRY(NEXT_FRAG);
+		TX_STATUS_ENTRY(LIFE_EXPIRE);
+		TX_STATUS_ENTRY(DEST_PS);
+		TX_STATUS_ENTRY(ABORTED);
+		TX_STATUS_ENTRY(BT_RETRY);
+		TX_STATUS_ENTRY(STA_INVALID);
+		TX_STATUS_ENTRY(FRAG_DROPPED);
+		TX_STATUS_ENTRY(TID_DISABLE);
+		TX_STATUS_ENTRY(FRAME_FLUSHED);
+		TX_STATUS_ENTRY(INSUFFICIENT_CF_POLL);
+		TX_STATUS_ENTRY(TX_LOCKED);
+		TX_STATUS_ENTRY(NO_BEACON_ON_RADAR);
+	}
+
+	return "UNKNOWN";
+}
+#else
+static inline const char *iwl3945_get_tx_fail_reason(u32 status)
+{
+	return "";
+}
+#endif
+
+
+/**
+ * iwl3945_tx_queue_reclaim - Reclaim Tx queue entries already Tx'd
+ *
+ * When FW advances 'R' index, all entries between old and new 'R' index
+ * need to be reclaimed. As result, some free space forms. If there is
+ * enough free space (> low mark), wake the stack that feeds us.
+ */
+static void iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv,
+				     int txq_id, int index)
+{
+	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl3945_queue *q = &txq->q;
+	struct iwl3945_tx_info *tx_info;
+
+	BUG_ON(txq_id == IWL_CMD_QUEUE_NUM);
+
+	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+
+		tx_info = &txq->txb[txq->q.read_ptr];
+		ieee80211_tx_status(priv->hw, tx_info->skb[0],
+				    &tx_info->status);
+		tx_info->skb[0] = NULL;
+		iwl3945_hw_txq_free_tfd(priv, txq);
+	}
+
+	if (iwl3945_queue_space(q) > q->low_mark && (txq_id >= 0) &&
+			(txq_id != IWL_CMD_QUEUE_NUM) &&
+			priv->mac80211_registered)
+		ieee80211_wake_queue(priv->hw, txq_id);
+}
+
+/**
+ * iwl3945_rx_reply_tx - Handle Tx response
+ */
+static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
+			    struct iwl3945_rx_mem_buffer *rxb)
+{
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
+	int txq_id = SEQ_TO_QUEUE(sequence);
+	int index = SEQ_TO_INDEX(sequence);
+	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
+	struct ieee80211_tx_status *tx_status;
+	struct iwl3945_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
+	u32  status = le32_to_cpu(tx_resp->status);
+	int rate_idx;
+
+	if ((index >= txq->q.n_bd) || (iwl3945_x2_queue_used(&txq->q, index) == 0)) {
+		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
+			  "is out of range [0-%d] %d %d\n", txq_id,
+			  index, txq->q.n_bd, txq->q.write_ptr,
+			  txq->q.read_ptr);
+		return;
+	}
+
+	tx_status = &(txq->txb[txq->q.read_ptr].status);
+
+	tx_status->retry_count = tx_resp->failure_frame;
+	/* tx_status->rts_retry_count = tx_resp->failure_rts; */
+	tx_status->flags = ((status & TX_STATUS_MSK) == TX_STATUS_SUCCESS) ?
+				IEEE80211_TX_STATUS_ACK : 0;
+
+	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) plcp rate %d retries %d\n",
+			txq_id, iwl3945_get_tx_fail_reason(status), status,
+			tx_resp->rate, tx_resp->failure_frame);
+
+	rate_idx = iwl3945_hwrate_to_plcp_idx(tx_resp->rate);
+	tx_status->control.tx_rate = &priv->ieee_rates[rate_idx];
+	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
+	iwl3945_tx_queue_reclaim(priv, txq_id, index);
+
+	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
+		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
+}
+
+
+
 /*****************************************************************************
  *
  * Intel PRO/Wireless 3945ABG/BG Network Connection
  *
  *  RX handler implementations
  *
- *  Used by iwl-base.c
- *
  *****************************************************************************/
 
 void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl3945_rx_mem_buffer *rxb)
@@ -2510,6 +2622,7 @@ unsigned int iwl3945_hw_get_beacon_cmd(struct iwl3945_priv *priv,
 
 void iwl3945_hw_rx_handler_setup(struct iwl3945_priv *priv)
 {
+	priv->rx_handlers[REPLY_TX] = iwl3945_rx_reply_tx;
 	priv->rx_handlers[REPLY_3945_RX] = iwl3945_rx_reply_rx;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 39fd544..ecf749c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2063,34 +2063,6 @@ int iwl3945_is_network_packet(struct iwl3945_priv *priv, struct ieee80211_hdr *h
 	return 1;
 }
 
-#define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
-
-static const char *iwl3945_get_tx_fail_reason(u32 status)
-{
-	switch (status & TX_STATUS_MSK) {
-	case TX_STATUS_SUCCESS:
-		return "SUCCESS";
-		TX_STATUS_ENTRY(SHORT_LIMIT);
-		TX_STATUS_ENTRY(LONG_LIMIT);
-		TX_STATUS_ENTRY(FIFO_UNDERRUN);
-		TX_STATUS_ENTRY(MGMNT_ABORT);
-		TX_STATUS_ENTRY(NEXT_FRAG);
-		TX_STATUS_ENTRY(LIFE_EXPIRE);
-		TX_STATUS_ENTRY(DEST_PS);
-		TX_STATUS_ENTRY(ABORTED);
-		TX_STATUS_ENTRY(BT_RETRY);
-		TX_STATUS_ENTRY(STA_INVALID);
-		TX_STATUS_ENTRY(FRAG_DROPPED);
-		TX_STATUS_ENTRY(TID_DISABLE);
-		TX_STATUS_ENTRY(FRAME_FLUSHED);
-		TX_STATUS_ENTRY(INSUFFICIENT_CF_POLL);
-		TX_STATUS_ENTRY(TX_LOCKED);
-		TX_STATUS_ENTRY(NO_BEACON_ON_RADAR);
-	}
-
-	return "UNKNOWN";
-}
-
 /**
  * iwl3945_scan_cancel - Cancel any currently executing HW scan
  *
@@ -3138,125 +3110,6 @@ static int iwl3945_get_measurement(struct iwl3945_priv *priv,
 }
 #endif
 
-static void iwl3945_txstatus_to_ieee(struct iwl3945_priv *priv,
-				 struct iwl3945_tx_info *tx_sta)
-{
-
-	tx_sta->status.ack_signal = 0;
-	tx_sta->status.excessive_retries = 0;
-	tx_sta->status.queue_length = 0;
-	tx_sta->status.queue_number = 0;
-
-	if (in_interrupt())
-		ieee80211_tx_status_irqsafe(priv->hw,
-					    tx_sta->skb[0], &(tx_sta->status));
-	else
-		ieee80211_tx_status(priv->hw,
-				    tx_sta->skb[0], &(tx_sta->status));
-
-	tx_sta->skb[0] = NULL;
-}
-
-/**
- * iwl3945_tx_queue_reclaim - Reclaim Tx queue entries already Tx'd
- *
- * When FW advances 'R' index, all entries between old and new 'R' index
- * need to be reclaimed. As result, some free space forms. If there is
- * enough free space (> low mark), wake the stack that feeds us.
- */
-static int iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv, int txq_id, int index)
-{
-	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl3945_queue *q = &txq->q;
-	int nfreed = 0;
-
-	if ((index >= q->n_bd) || (iwl3945_x2_queue_used(q, index) == 0)) {
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
-			iwl3945_txstatus_to_ieee(priv,
-					&(txq->txb[txq->q.read_ptr]));
-			iwl3945_hw_txq_free_tfd(priv, txq);
-		} else if (nfreed > 1) {
-			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", index,
-					q->write_ptr, q->read_ptr);
-			queue_work(priv->workqueue, &priv->restart);
-		}
-		nfreed++;
-	}
-
-	if (iwl3945_queue_space(q) > q->low_mark && (txq_id >= 0) &&
-			(txq_id != IWL_CMD_QUEUE_NUM) &&
-			priv->mac80211_registered)
-		ieee80211_wake_queue(priv->hw, txq_id);
-
-
-	return nfreed;
-}
-
-static int iwl3945_is_tx_success(u32 status)
-{
-	return (status & 0xFF) == 0x1;
-}
-
-/******************************************************************************
- *
- * Generic RX handler implementations
- *
- ******************************************************************************/
-/**
- * iwl3945_rx_reply_tx - Handle Tx response
- */
-static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
-			    struct iwl3945_rx_mem_buffer *rxb)
-{
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
-	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
-	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_INDEX(sequence);
-	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
-	struct ieee80211_tx_status *tx_status;
-	struct iwl3945_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
-	u32  status = le32_to_cpu(tx_resp->status);
-
-	if ((index >= txq->q.n_bd) || (iwl3945_x2_queue_used(&txq->q, index) == 0)) {
-		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
-			  "is out of range [0-%d] %d %d\n", txq_id,
-			  index, txq->q.n_bd, txq->q.write_ptr,
-			  txq->q.read_ptr);
-		return;
-	}
-
-	tx_status = &(txq->txb[txq->q.read_ptr].status);
-
-	tx_status->retry_count = tx_resp->failure_frame;
-	tx_status->queue_number = status;
-	tx_status->queue_length = tx_resp->bt_kill_count;
-	tx_status->queue_length |= tx_resp->failure_rts;
-
-	tx_status->flags =
-	    iwl3945_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
-
-	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) plcp rate %d retries %d\n",
-			txq_id, iwl3945_get_tx_fail_reason(status), status,
-			tx_resp->rate, tx_resp->failure_frame);
-
-	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
-	if (index != -1)
-		iwl3945_tx_queue_reclaim(priv, txq_id, index);
-
-	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
-		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
-}
-
-
 static void iwl3945_rx_reply_alive(struct iwl3945_priv *priv,
 			       struct iwl3945_rx_mem_buffer *rxb)
 {
@@ -3603,13 +3456,44 @@ static void iwl3945_setup_rx_handlers(struct iwl3945_priv *priv)
 	priv->rx_handlers[SCAN_COMPLETE_NOTIFICATION] =
 	    iwl3945_rx_scan_complete_notif;
 	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl3945_rx_card_state_notif;
-	priv->rx_handlers[REPLY_TX] = iwl3945_rx_reply_tx;
 
 	/* Set up hardware specific Rx handlers */
 	iwl3945_hw_rx_handler_setup(priv);
 }
 
 /**
+ * iwl3945_cmd_queue_reclaim - Reclaim CMD queue entries
+ * When FW advances 'R' index, all entries between old and new 'R' index
+ * need to be reclaimed.
+ */
+static void iwl3945_cmd_queue_reclaim(struct iwl3945_priv *priv,
+				      int txq_id, int index)
+{
+	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl3945_queue *q = &txq->q;
+	int nfreed = 0;
+
+	if ((index >= q->n_bd) || (iwl3945_x2_queue_used(q, index) == 0)) {
+		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
+			  "is out of range [0-%d] %d %d.\n", txq_id,
+			  index, q->n_bd, q->write_ptr, q->read_ptr);
+		return;
+	}
+
+	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+		if (nfreed > 1) {
+			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", index,
+					q->write_ptr, q->read_ptr);
+			queue_work(priv->workqueue, &priv->restart);
+			break;
+		}
+		nfreed++;
+	}
+}
+
+
+/**
  * iwl3945_tx_cmd_complete - Pull unused buffers off the queue and reclaim them
  * @rxb: Rx buffer to reclaim
  *
@@ -3628,12 +3512,6 @@ static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
 	int cmd_index;
 	struct iwl3945_cmd *cmd;
 
-	/* If a Tx command is being handled and it isn't in the actual
-	 * command queue then there a command routing bug has been introduced
-	 * in the queue management code. */
-	if (txq_id != IWL_CMD_QUEUE_NUM)
-		IWL_ERROR("Error wrong command queue %d command id 0x%X\n",
-			  txq_id, pkt->hdr.cmd);
 	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
 
 	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
@@ -3647,7 +3525,7 @@ static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
 		   !cmd->meta.u.callback(priv, cmd, rxb->skb))
 		rxb->skb = NULL;
 
-	iwl3945_tx_queue_reclaim(priv, txq_id, index);
+	iwl3945_cmd_queue_reclaim(priv, txq_id, index);
 
 	if (!(cmd->meta.flags & CMD_ASYNC)) {
 		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-- 
1.5.3.4

