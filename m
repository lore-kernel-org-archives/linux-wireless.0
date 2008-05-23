Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:50159 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbYEWCLK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: rename iwl4965_queue to iwl_queue
Date: Fri, 23 May 2008 10:08:43 +0800
Message-Id: <1211508569-3163-6-git-send-email-yi.zhu@intel.com> (sfid-20080523_041118_760605_EAA3CBBD)
In-Reply-To: <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch renames iwl4965_queue to iwl_queue.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   16 ++------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   28 +++++++++++++-------------
 4 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 17847f9..2bb0075 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3231,7 +3231,7 @@ static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 int iwl4965_check_empty_hw_queue(struct iwl_priv *priv, int sta_id,
 					 u8 tid, int txq_id)
 {
-	struct iwl4965_queue *q = &priv->txq[txq_id].q;
+	struct iwl_queue *q = &priv->txq[txq_id].q;
 	u8 *addr = priv->stations[sta_id].sta.sta.addr;
 	struct iwl_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
 
@@ -3263,16 +3263,6 @@ int iwl4965_check_empty_hw_queue(struct iwl_priv *priv, int sta_id,
 }
 
 /**
- * iwl4965_queue_dec_wrap - Decrement queue index, wrap back to end if needed
- * @index -- current index
- * @n_bd -- total number of entries in queue (s/b power of 2)
- */
-static inline int iwl4965_queue_dec_wrap(int index, int n_bd)
-{
-	return (index == 0) ? n_bd - 1 : index - 1;
-}
-
-/**
  * iwl4965_rx_reply_compressed_ba - Handler for REPLY_COMPRESSED_BA
  *
  * Handles block-acknowledge notification from device, which reports success
@@ -3304,7 +3294,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 	agg = &priv->stations[ba_resp->sta_id].tid[ba_resp->tid].agg;
 
 	/* Find index just before block-ack window */
-	index = iwl4965_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
+	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
 
 	/* TODO: Need to get this copy more safely - now good for debug */
 
@@ -3337,7 +3327,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 		int freed = iwl4965_tx_queue_reclaim(priv, scd_flow, index);
 		priv->stations[ba_resp->sta_id].
 			tid[ba_resp->tid].tfds_in_queue -= freed;
-		if (iwl4965_queue_space(&txq->q) > txq->q.low_mark &&
+		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
 			priv->mac80211_registered &&
 			agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)
 			ieee80211_wake_queue(priv->hw, ampdu_q);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5dccc5a..cf99224 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -102,7 +102,7 @@ struct iwl_rx_mem_buffer {
  *
  * Contains common data for Rx and Tx queues
  */
-struct iwl4965_queue {
+struct iwl_queue {
 	int n_bd;              /* number of BDs in this queue */
 	int write_ptr;       /* 1-st empty entry (index) host_w*/
 	int read_ptr;         /* last used entry (index) host_r*/
@@ -137,7 +137,7 @@ struct iwl4965_tx_info {
  * descriptors) and required locking structures.
  */
 struct iwl_tx_queue {
-	struct iwl4965_queue q;
+	struct iwl_queue q;
 	struct iwl_tfd_frame *bd;
 	struct iwl_cmd *cmd;
 	dma_addr_t dma_addr_cmd;
@@ -721,7 +721,7 @@ extern u8 iwl_find_station(struct iwl_priv *priv, const u8 *bssid);
 
 extern int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel);
 extern int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
-extern int iwl4965_queue_space(const struct iwl4965_queue *q);
+extern int iwl_queue_space(const struct iwl_queue *q);
 struct iwl_priv;
 
 extern void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index a1e03cc..870d257 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -105,7 +105,7 @@ EXPORT_SYMBOL(iwl_hw_txq_free_tfd);
  */
 static void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
-	struct iwl4965_queue *q = &txq->q;
+	struct iwl_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
 	int len;
 
@@ -158,7 +158,7 @@ EXPORT_SYMBOL(iwl_hw_txq_ctx_free);
 /**
  * iwl_queue_init - Initialize queue's high/low-water and read/write indexes
  */
-static int iwl_queue_init(struct iwl_priv *priv, struct iwl4965_queue *q,
+static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 			  int count, int slots_num, u32 id)
 {
 	q->n_bd = count;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index c713b27..2e7e616 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -173,7 +173,7 @@ static const char *iwl4965_escape_essid(const char *essid, u8 essid_len)
  * See more detailed info in iwl-4965-hw.h.
  ***************************************************/
 
-int iwl4965_queue_space(const struct iwl4965_queue *q)
+int iwl_queue_space(const struct iwl_queue *q)
 {
 	int s = q->read_ptr - q->write_ptr;
 
@@ -190,14 +190,14 @@ int iwl4965_queue_space(const struct iwl4965_queue *q)
 }
 
 
-static inline int x2_queue_used(const struct iwl4965_queue *q, int i)
+static inline int iwl_queue_used(const struct iwl_queue *q, int i)
 {
 	return q->write_ptr > q->read_ptr ?
 		(i >= q->read_ptr && i < q->write_ptr) :
 		!(i < q->read_ptr && i >= q->write_ptr);
 }
 
-static inline u8 get_cmd_index(struct iwl4965_queue *q, u32 index, int is_huge)
+static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
 {
 	/* This is for scan command, the big buffer at end of command array */
 	if (is_huge)
@@ -348,7 +348,7 @@ u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
-	struct iwl4965_queue *q = &txq->q;
+	struct iwl_queue *q = &txq->q;
 	struct iwl_tfd_frame *tfd;
 	u32 *control_flags;
 	struct iwl_cmd *out_cmd;
@@ -369,7 +369,7 @@ int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
-	if (iwl4965_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
+	if (iwl_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
 		IWL_ERROR("No space for Tx\n");
 		return -ENOSPC;
 	}
@@ -1768,7 +1768,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	u32 *control_flags;
 	int txq_id = ctl->queue;
 	struct iwl_tx_queue *txq = NULL;
-	struct iwl4965_queue *q = NULL;
+	struct iwl_queue *q = NULL;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	dma_addr_t scratch_phys;
@@ -1981,7 +1981,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	if (rc)
 		return rc;
 
-	if ((iwl4965_queue_space(q) < q->high_mark)
+	if ((iwl_queue_space(q) < q->high_mark)
 	    && priv->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
@@ -2332,10 +2332,10 @@ static void iwl4965_txstatus_to_ieee(struct iwl_priv *priv,
 int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl4965_queue *q = &txq->q;
+	struct iwl_queue *q = &txq->q;
 	int nfreed = 0;
 
-	if ((index >= q->n_bd) || (x2_queue_used(q, index) == 0)) {
+	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
 			  index, q->n_bd, q->write_ptr, q->read_ptr);
@@ -2541,7 +2541,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	__le16 *qc;
 #endif
 
-	if ((index >= txq->q.n_bd) || (x2_queue_used(&txq->q, index) == 0)) {
+	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
 			  index, txq->q.n_bd, txq->q.write_ptr,
@@ -2587,7 +2587,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 
-			if (iwl4965_queue_space(&txq->q) > txq->q.low_mark &&
+			if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
 			    txq_id >= 0 && priv->mac80211_registered &&
 			    agg->state != IWL_EMPTYING_HW_QUEUE_DELBA) {
 				/* calculate mac80211 ampdu sw queue to wake */
@@ -2621,7 +2621,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		int freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
 		if (tid != MAX_TID_COUNT)
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
-		if (iwl4965_queue_space(&txq->q) > txq->q.low_mark &&
+		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
 			(txq_id >= 0) && priv->mac80211_registered)
 			ieee80211_wake_queue(priv->hw, txq_id);
 		if (tid != MAX_TID_COUNT)
@@ -5783,7 +5783,7 @@ static int iwl4965_mac_get_tx_stats(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = hw->priv;
 	int i, avail;
 	struct iwl_tx_queue *txq;
-	struct iwl4965_queue *q;
+	struct iwl_queue *q;
 	unsigned long flags;
 
 	IWL_DEBUG_MAC80211("enter\n");
@@ -5798,7 +5798,7 @@ static int iwl4965_mac_get_tx_stats(struct ieee80211_hw *hw,
 	for (i = 0; i < AC_NUM; i++) {
 		txq = &priv->txq[i];
 		q = &txq->q;
-		avail = iwl4965_queue_space(q);
+		avail = iwl_queue_space(q);
 
 		stats[i].len = q->n_window - avail;
 		stats[i].limit = q->n_window - q->high_mark;
-- 
1.5.3.6

