Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1HMSSz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 60/60] iwlagn: move tx queues to transport layer
Date: Sat, 13 Aug 2011 10:38:36 -0700
Message-Id: <1313257116-2697-61-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201926_632052_DC057394)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This finalizes the move of the data path to the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   23 +----
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   42 --------
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   50 +++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   53 ++++++----
 drivers/net/wireless/iwlwifi/iwl-trans.c          |  105 +++++++++++----------
 6 files changed, 136 insertions(+), 139 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 44e408e..95b86ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -742,7 +742,6 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int cmd_index = SEQ_TO_INDEX(sequence);
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwlagn_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	struct ieee80211_hdr *hdr;
 	u32 status = le16_to_cpu(tx_resp->status.status);
@@ -755,17 +754,7 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct sk_buff_head skbs;
 	struct sk_buff *skb;
 	struct iwl_rxon_context *ctx;
-
-	if ((cmd_index >= txq->q.n_bd) ||
-	    (iwl_queue_used(&txq->q, cmd_index) == 0)) {
-		IWL_ERR(priv, "%s: Read index for DMA queue txq_id (%d) "
-			  "cmd_index %d is out of range [0-%d] %d %d\n",
-			  __func__, txq_id, cmd_index, txq->q.n_bd,
-			  txq->q.write_ptr, txq->q.read_ptr);
-		return;
-	}
-
-	txq->time_stamp = jiffies;
+	bool is_agg = (txq_id >= IWLAGN_FIRST_AMPDU_QUEUE);
 
 	tid = (tx_resp->ra_tid & IWLAGN_TX_RES_TID_MSK) >>
 		IWLAGN_TX_RES_TID_POS;
@@ -774,12 +763,10 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
-	if (txq->sched_retry)
+	if (is_agg)
 		iwl_rx_reply_tx_agg(priv, tx_resp);
 
 	if (tx_resp->frame_count == 1) {
-		bool is_agg = (txq_id >= IWLAGN_FIRST_AMPDU_QUEUE);
-
 		__skb_queue_head_init(&skbs);
 		/*we can free until ssn % q.n_bd not inclusive */
 		iwl_trans_reclaim(trans(priv), sta_id, tid, txq_id,
@@ -850,14 +837,12 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
-	struct iwl_tx_queue *txq = NULL;
 	struct iwl_ht_agg *agg;
 	struct sk_buff_head reclaimed_skbs;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
 	unsigned long flags;
-	int index;
 	int sta_id;
 	int tid;
 	int freed;
@@ -875,14 +860,10 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		return;
 	}
 
-	txq = &priv->txq[scd_flow];
 	sta_id = ba_resp->sta_id;
 	tid = ba_resp->tid;
 	agg = &priv->shrd->tid_data[sta_id][tid].agg;
 
-	/* Find index of block-ack window */
-	index = ba_resp_scd_ssn & (txq->q.n_bd - 1);
-
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
 	if (unlikely(agg->txq_id != scd_flow)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 80dad8f..27d73d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -573,19 +573,6 @@ struct iwl_sensitivity_ranges {
  ****************************************************************************/
 extern void iwl_update_chain_flags(struct iwl_priv *priv);
 extern const u8 iwl_bcast_addr[ETH_ALEN];
-extern int iwl_queue_space(const struct iwl_queue *q);
-static inline int iwl_queue_used(const struct iwl_queue *q, int i)
-{
-	return q->write_ptr >= q->read_ptr ?
-		(i >= q->read_ptr && i < q->write_ptr) :
-		!(i < q->read_ptr && i >= q->write_ptr);
-}
-
-
-static inline u8 get_cmd_index(struct iwl_queue *q, u32 index)
-{
-	return index & (q->n_window - 1);
-}
 
 #define IWL_OPERATION_MODE_AUTO     0
 #define IWL_OPERATION_MODE_HT_ONLY  1
@@ -1158,10 +1145,6 @@ struct iwl_priv {
 
 	int activity_timer_active;
 
-	/* Tx DMA processing queues */
-	struct iwl_tx_queue *txq;
-	unsigned long txq_ctx_active_msk;
-
 	/* counts mgmt, ctl, and data packets */
 	struct traffic_stats tx_stats;
 	struct traffic_stats rx_stats;
@@ -1174,12 +1157,6 @@ struct iwl_priv {
 	struct iwl_station_entry stations[IWLAGN_STATION_COUNT];
 	unsigned long ucode_key_table;
 
-	/* queue refcounts */
-#define IWL_MAX_HW_QUEUES	32
-	unsigned long queue_stopped[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
-	/* for each AC */
-	atomic_t queue_stop_count[4];
-
 	/* Indication if ieee80211_ops->open has been called */
 	u8 is_open;
 
@@ -1336,27 +1313,8 @@ struct iwl_priv {
 	bool have_rekey_data;
 }; /*iwl_priv */
 
-static inline void iwl_txq_ctx_activate(struct iwl_priv *priv, int txq_id)
-{
-	set_bit(txq_id, &priv->txq_ctx_active_msk);
-}
-
-static inline void iwl_txq_ctx_deactivate(struct iwl_priv *priv, int txq_id)
-{
-	clear_bit(txq_id, &priv->txq_ctx_active_msk);
-}
-
 extern struct iwl_mod_params iwlagn_mod_params;
 
-static inline struct ieee80211_hdr *iwl_tx_queue_get_hdr(struct iwl_priv *priv,
-							 int txq_id, int idx)
-{
-	if (priv->txq[txq_id].skbs[idx])
-		return (struct ieee80211_hdr *)priv->txq[txq_id].
-				skbs[idx]->data;
-	return NULL;
-}
-
 static inline struct iwl_rxon_context *
 iwl_rxon_ctx_from_vif(struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index 255b326..ec4e737 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -125,6 +125,10 @@ struct iwl_dma_ptr {
  * @ac_to_fifo: to what fifo is a specifc AC mapped ?
  * @ac_to_queue: to what tx queue  is a specifc AC mapped ?
  * @mcast_queue:
+ * @txq: Tx DMA processing queues
+ * @txq_ctx_active_msk: what queue is active
+ * queue_stopped: tracks what queue is stopped
+ * queue_stop_count: tracks what SW queue is stopped
  */
 struct iwl_trans_pcie {
 	struct iwl_rx_queue rxq;
@@ -150,6 +154,12 @@ struct iwl_trans_pcie {
 	const u8 *ac_to_fifo[NUM_IWL_RXON_CTX];
 	const u8 *ac_to_queue[NUM_IWL_RXON_CTX];
 	u8 mcast_queue[NUM_IWL_RXON_CTX];
+
+	struct iwl_tx_queue *txq;
+	unsigned long txq_ctx_active_msk;
+#define IWL_MAX_HW_QUEUES	32
+	unsigned long queue_stopped[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
+	atomic_t queue_stop_count[4];
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
@@ -207,6 +217,7 @@ void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	int index);
 int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 			 struct sk_buff_head *skbs);
+int iwl_queue_space(const struct iwl_queue *q);
 
 /*****************************************************
 * Error handling
@@ -216,6 +227,9 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display);
 void iwl_dump_csr(struct iwl_trans *trans);
 
+/*****************************************************
+* Helpers
+******************************************************/
 static inline void iwl_disable_interrupts(struct iwl_trans *trans)
 {
 	clear_bit(STATUS_INT_ENABLED, &trans->shrd->status);
@@ -265,12 +279,14 @@ static inline void iwl_wake_queue(struct iwl_trans *trans,
 	u8 queue = txq->swq_id;
 	u8 ac = queue & 3;
 	u8 hwq = (queue >> 2) & 0x1f;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	if (unlikely(!trans->shrd->mac80211_registered))
 		return;
 
-	if (test_and_clear_bit(hwq, priv(trans)->queue_stopped))
-		if (atomic_dec_return(&priv(trans)->queue_stop_count[ac]) <= 0)
+	if (test_and_clear_bit(hwq, trans_pcie->queue_stopped))
+		if (atomic_dec_return(&trans_pcie->queue_stop_count[ac]) <= 0)
 			ieee80211_wake_queue(trans->shrd->hw, ac);
 }
 
@@ -280,12 +296,14 @@ static inline void iwl_stop_queue(struct iwl_trans *trans,
 	u8 queue = txq->swq_id;
 	u8 ac = queue & 3;
 	u8 hwq = (queue >> 2) & 0x1f;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	if (unlikely(!trans->shrd->mac80211_registered))
 		return;
 
-	if (!test_and_set_bit(hwq, priv(trans)->queue_stopped))
-		if (atomic_inc_return(&priv(trans)->queue_stop_count[ac]) > 0)
+	if (!test_and_set_bit(hwq, trans_pcie->queue_stopped))
+		if (atomic_inc_return(&trans_pcie->queue_stop_count[ac]) > 0)
 			ieee80211_stop_queue(trans->shrd->hw, ac);
 }
 
@@ -301,4 +319,28 @@ static inline void iwl_stop_queue(struct iwl_trans *trans,
 
 #define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
 
+static inline void iwl_txq_ctx_activate(struct iwl_trans_pcie *trans_pcie,
+					int txq_id)
+{
+	set_bit(txq_id, &trans_pcie->txq_ctx_active_msk);
+}
+
+static inline void iwl_txq_ctx_deactivate(struct iwl_trans_pcie *trans_pcie,
+					  int txq_id)
+{
+	clear_bit(txq_id, &trans_pcie->txq_ctx_active_msk);
+}
+
+static inline int iwl_queue_used(const struct iwl_queue *q, int i)
+{
+	return q->write_ptr >= q->read_ptr ?
+		(i >= q->read_ptr && i < q->write_ptr) :
+		!(i < q->read_ptr && i >= q->write_ptr);
+}
+
+static inline u8 get_cmd_index(struct iwl_queue *q, u32 index)
+{
+	return index & (q->n_window - 1);
+}
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index a0699c0..2d0ddb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -1032,7 +1032,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		iwl_rx_queue_update_write_ptr(trans, &trans_pcie->rxq);
 		for (i = 0; i < hw_params(trans).max_txq_num; i++)
 			iwl_txq_update_write_ptr(trans,
-						 &priv(trans)->txq[i]);
+						 &trans_pcie->txq[i]);
 
 		isr_stats->wakeup++;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 8713233..d48eb5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -407,9 +407,10 @@ void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 					struct iwl_tx_queue *txq,
 					int tx_fifo_id, int scd_retry)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int txq_id = txq->q.id;
 	int active =
-		test_bit(txq_id, &priv(trans)->txq_ctx_active_msk) ? 1 : 0;
+		test_bit(txq_id, &trans_pcie->txq_ctx_active_msk) ? 1 : 0;
 
 	iwl_write_prph(bus(trans), SCD_QUEUE_STATUS_BITS(txq_id),
 			(active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
@@ -482,8 +483,8 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
-	priv(trans)->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
-	priv(trans)->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
+	trans_pcie->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
+	trans_pcie->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	iwl_trans_set_wr_ptrs(trans, txq_id, ssn_idx);
 
 	/* Set up Tx window size and frame limit for this queue */
@@ -500,11 +501,11 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 	iwl_set_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
-	iwl_trans_tx_queue_set_status(trans, &priv(trans)->txq[txq_id],
+	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id],
 					tx_fifo, 1);
 
-	priv(trans)->txq[txq_id].sta_id = sta_id;
-	priv(trans)->txq[txq_id].tid = tid;
+	trans_pcie->txq[txq_id].sta_id = sta_id;
+	trans_pcie->txq[txq_id].tid = tid;
 
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 }
@@ -517,11 +518,12 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
  */
 static int iwlagn_txq_ctx_activate_free(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int txq_id;
 
 	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++)
 		if (!test_and_set_bit(txq_id,
-					&priv(trans)->txq_ctx_active_msk))
+					&trans_pcie->txq_ctx_active_msk))
 			return txq_id;
 	return -1;
 }
@@ -530,6 +532,7 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 				enum iwl_rxon_context_id ctx, int sta_id,
 				int tid, u16 *ssn)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tid_data *tid_data;
 	unsigned long flags;
 	u16 txq_id;
@@ -545,7 +548,7 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 	tid_data = &trans->shrd->tid_data[sta_id][tid];
 	*ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
-	iwl_set_swq_id(&priv->txq[txq_id], get_ac_from_tid(tid), txq_id);
+	iwl_set_swq_id(&trans_pcie->txq[txq_id], get_ac_from_tid(tid), txq_id);
 
 	tid_data = &trans->shrd->tid_data[sta_id][tid];
 	if (tid_data->tfds_in_queue == 0) {
@@ -564,24 +567,26 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 
 void iwl_trans_pcie_txq_agg_disable(struct iwl_trans *trans, int txq_id)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
 
 	iwl_clear_bits_prph(bus(trans), SCD_AGGR_SEL, (1 << txq_id));
 
-	priv(trans)->txq[txq_id].q.read_ptr = 0;
-	priv(trans)->txq[txq_id].q.write_ptr = 0;
+	trans_pcie->txq[txq_id].q.read_ptr = 0;
+	trans_pcie->txq[txq_id].q.write_ptr = 0;
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
 
 	iwl_clear_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
-	iwl_txq_ctx_deactivate(priv(trans), txq_id);
-	iwl_trans_tx_queue_set_status(trans, &priv(trans)->txq[txq_id], 0, 0);
+	iwl_txq_ctx_deactivate(trans_pcie, txq_id);
+	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id], 0, 0);
 }
 
 int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
 				  enum iwl_rxon_context_id ctx, int sta_id,
 				  int tid)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	unsigned long flags;
 	int read_ptr, write_ptr;
 	struct iwl_tid_data *tid_data;
@@ -621,8 +626,8 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
 				"or starting\n");
 	}
 
-	write_ptr = priv(trans)->txq[txq_id].q.write_ptr;
-	read_ptr = priv(trans)->txq[txq_id].q.read_ptr;
+	write_ptr = trans_pcie->txq[txq_id].q.write_ptr;
+	read_ptr = trans_pcie->txq[txq_id].q.read_ptr;
 
 	/* The queue is not empty */
 	if (write_ptr != read_ptr) {
@@ -663,7 +668,8 @@ turn_off:
  */
 static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
-	struct iwl_tx_queue *txq = &priv(trans)->txq[trans->shrd->cmd_queue];
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
 	struct iwl_queue *q = &txq->q;
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
@@ -852,7 +858,9 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
  */
 static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int idx)
 {
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans(priv));
+	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	int nfreed = 0;
 
@@ -893,7 +901,8 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_device_cmd *cmd;
 	struct iwl_cmd_meta *meta;
 	struct iwl_trans *trans = trans(priv);
-	struct iwl_tx_queue *txq = &priv->txq[trans->shrd->cmd_queue];
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
 	unsigned long flags;
 
 	/* If a Tx command is being handled and it isn't in the actual
@@ -902,8 +911,8 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	if (WARN(txq_id != trans->shrd->cmd_queue,
 		 "wrong command queue %d (should be %d), sequence 0x%X readp=%d writep=%d\n",
 		  txq_id, trans->shrd->cmd_queue, sequence,
-		  priv->txq[trans->shrd->cmd_queue].q.read_ptr,
-		  priv->txq[trans->shrd->cmd_queue].q.write_ptr)) {
+		  trans_pcie->txq[trans->shrd->cmd_queue].q.read_ptr,
+		  trans_pcie->txq[trans->shrd->cmd_queue].q.write_ptr)) {
 		iwl_print_hex_error(priv, pkt, 32);
 		return;
 	}
@@ -1072,6 +1081,7 @@ static int iwl_send_cmd_async(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 
 static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int cmd_idx;
 	int ret;
 
@@ -1144,7 +1154,7 @@ cancel:
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source).
 		 */
-		priv(trans)->txq[trans->shrd->cmd_queue].meta[cmd_idx].flags &=
+		trans_pcie->txq[trans->shrd->cmd_queue].meta[cmd_idx].flags &=
 							~CMD_WANT_SKB;
 	}
 fail:
@@ -1181,7 +1191,8 @@ int iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id, u32 flags,
 int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 			 struct sk_buff_head *skbs)
 {
-	struct iwl_tx_queue *txq = &priv(trans)->txq[txq_id];
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	int last_to_free;
 	int freed = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index cce57d5..cec13ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -409,8 +409,8 @@ static int iwl_trans_txq_init(struct iwl_trans *trans, struct iwl_tx_queue *txq,
  */
 static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 {
-	struct iwl_priv *priv = priv(trans);
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 
 	if (!q->n_bd)
@@ -433,8 +433,8 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
  */
 static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 {
-	struct iwl_priv *priv = priv(trans);
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
 	struct device *dev = bus(trans)->dev;
 	int i;
 	if (WARN_ON(!txq))
@@ -477,19 +477,17 @@ static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 static void iwl_trans_pcie_tx_free(struct iwl_trans *trans)
 {
 	int txq_id;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_priv *priv = priv(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	/* Tx queues */
-	if (priv->txq) {
+	if (trans_pcie->txq) {
 		for (txq_id = 0;
 		     txq_id < hw_params(trans).max_txq_num; txq_id++)
 			iwl_tx_queue_free(trans, txq_id);
 	}
 
-	kfree(priv->txq);
-	priv->txq = NULL;
+	kfree(trans_pcie->txq);
+	trans_pcie->txq = NULL;
 
 	iwlagn_free_dma_ptr(trans, &trans_pcie->kw);
 
@@ -507,16 +505,14 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 {
 	int ret;
 	int txq_id, slots_num;
-	struct iwl_priv *priv = priv(trans);
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	u16 scd_bc_tbls_size = hw_params(trans).max_txq_num *
 			sizeof(struct iwlagn_scd_bc_tbl);
 
 	/*It is not allowed to alloc twice, so warn when this happens.
 	 * We cannot rely on the previous allocation, so free and fail */
-	if (WARN_ON(priv->txq)) {
+	if (WARN_ON(trans_pcie->txq)) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -535,9 +531,9 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 		goto error;
 	}
 
-	priv->txq = kzalloc(sizeof(struct iwl_tx_queue) *
+	trans_pcie->txq = kzalloc(sizeof(struct iwl_tx_queue) *
 			hw_params(trans).max_txq_num, GFP_KERNEL);
-	if (!priv->txq) {
+	if (!trans_pcie->txq) {
 		IWL_ERR(trans, "Not enough memory for txq\n");
 		ret = ENOMEM;
 		goto error;
@@ -547,8 +543,8 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
 		slots_num = (txq_id == trans->shrd->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_trans_txq_alloc(trans, &priv->txq[txq_id], slots_num,
-				       txq_id);
+		ret = iwl_trans_txq_alloc(trans, &trans_pcie->txq[txq_id],
+					  slots_num, txq_id);
 		if (ret) {
 			IWL_ERR(trans, "Tx %d queue alloc failed\n", txq_id);
 			goto error;
@@ -568,11 +564,9 @@ static int iwl_tx_init(struct iwl_trans *trans)
 	int txq_id, slots_num;
 	unsigned long flags;
 	bool alloc = false;
-	struct iwl_priv *priv = priv(trans);
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	if (!priv->txq) {
+	if (!trans_pcie->txq) {
 		ret = iwl_trans_tx_alloc(trans);
 		if (ret)
 			goto error;
@@ -594,8 +588,8 @@ static int iwl_tx_init(struct iwl_trans *trans)
 	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
 		slots_num = (txq_id == trans->shrd->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_trans_txq_init(trans, &priv->txq[txq_id], slots_num,
-				       txq_id);
+		ret = iwl_trans_txq_init(trans, &trans_pcie->txq[txq_id],
+					 slots_num, txq_id);
 		if (ret) {
 			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
 			goto error;
@@ -916,14 +910,15 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 	iwl_trans_set_wr_ptrs(trans, trans->shrd->cmd_queue, 0);
 
 	/* make sure all queue are not stopped */
-	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
+	memset(&trans_pcie->queue_stopped[0], 0,
+		sizeof(trans_pcie->queue_stopped));
 	for (i = 0; i < 4; i++)
-		atomic_set(&priv->queue_stop_count[i], 0);
+		atomic_set(&trans_pcie->queue_stop_count[i], 0);
 	for_each_context(priv, ctx)
 		ctx->last_tx_rejected = false;
 
 	/* reset to 0 to enable all the queue first */
-	priv->txq_ctx_active_msk = 0;
+	trans_pcie->txq_ctx_active_msk = 0;
 
 	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) <
 						IWLAGN_FIRST_AMPDU_QUEUE);
@@ -934,14 +929,15 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 		int fifo = queue_to_fifo[i].fifo;
 		int ac = queue_to_fifo[i].ac;
 
-		iwl_txq_ctx_activate(priv, i);
+		iwl_txq_ctx_activate(trans_pcie, i);
 
 		if (fifo == IWL_TX_FIFO_UNUSED)
 			continue;
 
 		if (ac != IWL_AC_UNSET)
-			iwl_set_swq_id(&priv->txq[i], ac, i);
-		iwl_trans_tx_queue_set_status(trans, &priv->txq[i], fifo, 0);
+			iwl_set_swq_id(&trans_pcie->txq[i], ac, i);
+		iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[i],
+					      fifo, 0);
 	}
 
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
@@ -958,7 +954,7 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 {
 	int ch, txq_id;
 	unsigned long flags;
-	struct iwl_priv *priv = priv(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	/* Turn off all Tx DMA fifos */
 	spin_lock_irqsave(&trans->shrd->lock, flags);
@@ -979,7 +975,7 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 	}
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
-	if (!priv->txq) {
+	if (!trans_pcie->txq) {
 		IWL_WARN(trans, "Stopping tx queues that aren't allocated...");
 		return 0;
 	}
@@ -1108,7 +1104,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		}
 	}
 
-	txq = &priv(trans)->txq[txq_id];
+	txq = &trans_pcie->txq[txq_id];
 	q = &txq->q;
 
 	/* Set up driver data for this TFD */
@@ -1268,7 +1264,8 @@ static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 static int iwlagn_txq_check_empty(struct iwl_trans *trans,
 			   int sta_id, u8 tid, int txq_id)
 {
-	struct iwl_queue *q = &priv(trans)->txq[txq_id].q;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_queue *q = &trans_pcie->txq[txq_id].q;
 	struct iwl_tid_data *tid_data = &trans->shrd->tid_data[sta_id][tid];
 
 	lockdep_assert_held(&trans->shrd->sta_lock);
@@ -1286,7 +1283,7 @@ static int iwlagn_txq_check_empty(struct iwl_trans *trans,
 			iwl_stop_tx_ba_trans_ready(priv(trans),
 						   NUM_IWL_RXON_CTX,
 						   sta_id, tid);
-			iwl_wake_queue(trans, &priv(trans)->txq[txq_id]);
+			iwl_wake_queue(trans, &trans_pcie->txq[txq_id]);
 		}
 		break;
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -1324,13 +1321,16 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 		      int txq_id, int ssn, u32 status,
 		      struct sk_buff_head *skbs)
 {
-	struct iwl_tx_queue *txq = &priv(trans)->txq[txq_id];
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
 	/* n_bd is usually 256 => n_bd - 1 = 0xff */
 	int tfd_num = ssn & (txq->q.n_bd - 1);
 	int freed = 0;
 	u8 agg_state;
 	bool cond;
 
+	txq->time_stamp = jiffies;
+
 	if (txq->sched_retry) {
 		agg_state =
 			trans->shrd->tid_data[txq->sta_id][txq->tid].agg.state;
@@ -1421,9 +1421,9 @@ static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
 		txq_id = trans_pcie->ac_to_queue[ctx][ac];
 		IWL_DEBUG_INFO(trans, "Queue Status: Q[%d] %s\n",
 			ac,
-			(atomic_read(&priv(trans)->queue_stop_count[ac]) > 0)
+			(atomic_read(&trans_pcie->queue_stop_count[ac]) > 0)
 			      ? "stopped" : "awake");
-		iwl_wake_queue(trans, &priv(trans)->txq[txq_id]);
+		iwl_wake_queue(trans, &trans_pcie->txq[txq_id]);
 	}
 }
 
@@ -1448,13 +1448,16 @@ static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
 
 static void iwl_trans_pcie_stop_queue(struct iwl_trans *trans, int txq_id)
 {
-	iwl_stop_queue(trans, &priv(trans)->txq[txq_id]);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	iwl_stop_queue(trans, &trans_pcie->txq[txq_id]);
 }
 
 #define IWL_FLUSH_WAIT_MS	2000
 
 static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
 	int cnt;
@@ -1465,7 +1468,7 @@ static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
 	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
 		if (cnt == trans->shrd->cmd_queue)
 			continue;
-		txq = &priv(trans)->txq[cnt];
+		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
 		while (q->read_ptr != q->write_ptr && !time_after(jiffies,
 		       now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS)))
@@ -1486,7 +1489,8 @@ static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
  */
 static int iwl_trans_pcie_check_stuck_queue(struct iwl_trans *trans, int cnt)
 {
-	struct iwl_tx_queue *txq = &priv(trans)->txq[cnt];
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[cnt];
 	struct iwl_queue *q = &txq->q;
 	unsigned long timeout;
 
@@ -1578,7 +1582,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 	const u8 *ptr;
 	ssize_t ret;
 
-	if (!priv->txq) {
+	if (!trans_pcie->txq) {
 		IWL_ERR(trans, "txq not ready\n");
 		return -EAGAIN;
 	}
@@ -1589,7 +1593,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 	}
 	pos += scnprintf(buf + pos, bufsz - pos, "Tx Queue\n");
 	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
-		txq = &priv->txq[cnt];
+		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"q[%d]: read_ptr: %u, write_ptr: %u\n",
@@ -1666,9 +1670,10 @@ static ssize_t iwl_dbgfs_traffic_log_write(struct file *file,
 
 static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 						char __user *user_buf,
-						size_t count, loff_t *ppos) {
-
+						size_t count, loff_t *ppos)
+{
 	struct iwl_trans *trans = file->private_data;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_priv *priv = priv(trans);
 	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
@@ -1678,7 +1683,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	int ret;
 	const size_t bufsz = sizeof(char) * 64 * hw_params(trans).max_txq_num;
 
-	if (!priv->txq) {
+	if (!trans_pcie->txq) {
 		IWL_ERR(priv, "txq not ready\n");
 		return -EAGAIN;
 	}
@@ -1687,21 +1692,21 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 		return -ENOMEM;
 
 	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
-		txq = &priv->txq[cnt];
+		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"hwq %.2d: read=%u write=%u stop=%d"
 				" swq_id=%#.2x (ac %d/hwq %d)\n",
 				cnt, q->read_ptr, q->write_ptr,
-				!!test_bit(cnt, priv->queue_stopped),
+				!!test_bit(cnt, trans_pcie->queue_stopped),
 				txq->swq_id, txq->swq_id & 3,
 				(txq->swq_id >> 2) & 0x1f);
 		if (cnt >= 4)
 			continue;
 		/* for the ACs, display the stop count too */
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"        stop-count: %d\n",
-				atomic_read(&priv->queue_stop_count[cnt]));
+			"        stop-count: %d\n",
+			atomic_read(&trans_pcie->queue_stop_count[cnt]));
 	}
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
-- 
1.7.0.4

