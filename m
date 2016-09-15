Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54782 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753047AbcIOSLw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:11:52 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:16 +0300
Message-Id: <20160915181131.32213-10-luca@coelho.fi> (sfid-20160915_201202_833325_004CC9F9)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 10/25] iwlwifi: pcie: merge iwl_queue and iwl_txq
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The original intent was to have the general iwl_queue shared
between RX and TX queues, but it is not the actual status.
Since it is not shared with any struct but iwl_txq, it adds
unnecessary complexity. Merge those structs.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  80 ++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  30 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 197 ++++++++++-----------
 4 files changed, 146 insertions(+), 163 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index d185692..cad2d11 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -195,39 +195,6 @@ struct iwl_cmd_meta {
 	u32 tbs;
 };
 
-/*
- * Generic queue structure
- *
- * Contains common data for Rx and Tx queues.
- *
- * Note the difference between TFD_QUEUE_SIZE_MAX and n_window: the hardware
- * always assumes 256 descriptors, so TFD_QUEUE_SIZE_MAX is always 256 (unless
- * there might be HW changes in the future). For the normal TX
- * queues, n_window, which is the size of the software queue data
- * is also 256; however, for the command queue, n_window is only
- * 32 since we don't need so many commands pending. Since the HW
- * still uses 256 BDs for DMA though, TFD_QUEUE_SIZE_MAX stays 256. As a result,
- * the software buffers (in the variables @meta, @txb in struct
- * iwl_txq) only have 32 entries, while the HW buffers (@tfds in
- * the same struct) have 256.
- * This means that we end up with the following:
- *  HW entries: | 0 | ... | N * 32 | ... | N * 32 + 31 | ... | 255 |
- *  SW entries:           | 0      | ... | 31          |
- * where N is a number between 0 and 7. This means that the SW
- * data is a window overlayed over the HW queue.
- */
-struct iwl_queue {
-	int write_ptr;       /* 1-st empty entry (index) host_w*/
-	int read_ptr;         /* last used entry (index) host_r*/
-	/* use for monitoring and recovering the stuck queue */
-	dma_addr_t dma_addr;   /* physical addr for BD's */
-	int n_window;	       /* safe queue window */
-	u32 id;
-	int low_mark;	       /* low watermark, resume queue if free
-				* space more than this */
-	int high_mark;         /* high watermark, stop queue if free
-				* space less than this */
-};
 
 #define TFD_TX_CMD_SLOTS 256
 #define TFD_CMD_SLOTS 32
@@ -274,12 +241,31 @@ struct iwl_pcie_first_tb_buf {
  * @wd_timeout: queue watchdog timeout (jiffies) - per queue
  * @frozen: tx stuck queue timer is frozen
  * @frozen_expiry_remainder: remember how long until the timer fires
+ * @write_ptr: 1-st empty entry (index) host_w
+ * @read_ptr: last used entry (index) host_r
+ * @dma_addr:  physical addr for BD's
+ * @n_window: safe queue window
+ * @id: queue id
+ * @low_mark: low watermark, resume queue if free space more than this
+ * @high_mark: high watermark, stop queue if free space less than this
  *
  * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
  * descriptors) and required locking structures.
+ *
+ * Note the difference between TFD_QUEUE_SIZE_MAX and n_window: the hardware
+ * always assumes 256 descriptors, so TFD_QUEUE_SIZE_MAX is always 256 (unless
+ * there might be HW changes in the future). For the normal TX
+ * queues, n_window, which is the size of the software queue data
+ * is also 256; however, for the command queue, n_window is only
+ * 32 since we don't need so many commands pending. Since the HW
+ * still uses 256 BDs for DMA though, TFD_QUEUE_SIZE_MAX stays 256.
+ * This means that we end up with the following:
+ *  HW entries: | 0 | ... | N * 32 | ... | N * 32 + 31 | ... | 255 |
+ *  SW entries:           | 0      | ... | 31          |
+ * where N is a number between 0 and 7. This means that the SW
+ * data is a window overlayed over the HW queue.
  */
 struct iwl_txq {
-	struct iwl_queue q;
 	void *tfds;
 	struct iwl_pcie_first_tb_buf *first_tb_bufs;
 	dma_addr_t first_tb_dma;
@@ -295,6 +281,14 @@ struct iwl_txq {
 	bool block;
 	unsigned long wd_timeout;
 	struct sk_buff_head overflow_q;
+
+	int write_ptr;
+	int read_ptr;
+	dma_addr_t dma_addr;
+	int n_window;
+	u32 id;
+	int low_mark;
+	int high_mark;
 };
 
 static inline dma_addr_t
@@ -633,9 +627,9 @@ static inline void iwl_wake_queue(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	if (test_and_clear_bit(txq->q.id, trans_pcie->queue_stopped)) {
-		IWL_DEBUG_TX_QUEUES(trans, "Wake hwq %d\n", txq->q.id);
-		iwl_op_mode_queue_not_full(trans->op_mode, txq->q.id);
+	if (test_and_clear_bit(txq->id, trans_pcie->queue_stopped)) {
+		IWL_DEBUG_TX_QUEUES(trans, "Wake hwq %d\n", txq->id);
+		iwl_op_mode_queue_not_full(trans->op_mode, txq->id);
 	}
 }
 
@@ -644,22 +638,22 @@ static inline void iwl_stop_queue(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	if (!test_and_set_bit(txq->q.id, trans_pcie->queue_stopped)) {
-		iwl_op_mode_queue_full(trans->op_mode, txq->q.id);
-		IWL_DEBUG_TX_QUEUES(trans, "Stop hwq %d\n", txq->q.id);
+	if (!test_and_set_bit(txq->id, trans_pcie->queue_stopped)) {
+		iwl_op_mode_queue_full(trans->op_mode, txq->id);
+		IWL_DEBUG_TX_QUEUES(trans, "Stop hwq %d\n", txq->id);
 	} else
 		IWL_DEBUG_TX_QUEUES(trans, "hwq %d already stopped\n",
-				    txq->q.id);
+				    txq->id);
 }
 
-static inline bool iwl_queue_used(const struct iwl_queue *q, int i)
+static inline bool iwl_queue_used(const struct iwl_txq *q, int i)
 {
 	return q->write_ptr >= q->read_ptr ?
 		(i >= q->read_ptr && i < q->write_ptr) :
 		!(i < q->read_ptr && i >= q->write_ptr);
 }
 
-static inline u8 get_cmd_index(struct iwl_queue *q, u32 index)
+static inline u8 get_cmd_index(struct iwl_txq *q, u32 index)
 {
 	return index & (q->n_window - 1);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 5c36e6d..452387c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1142,7 +1142,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 
 		sequence = le16_to_cpu(pkt->hdr.sequence);
 		index = SEQ_TO_INDEX(sequence);
-		cmd_index = get_cmd_index(&txq->q, index);
+		cmd_index = get_cmd_index(txq, index);
 
 		if (rxq->id == 0)
 			iwl_op_mode_rx(trans->op_mode, &rxq->napi,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e908bb8..361ccf6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1899,7 +1899,7 @@ static void iwl_trans_pcie_freeze_txq_timer(struct iwl_trans *trans,
 
 		txq->frozen = freeze;
 
-		if (txq->q.read_ptr == txq->q.write_ptr)
+		if (txq->read_ptr == txq->write_ptr)
 			goto next_queue;
 
 		if (freeze) {
@@ -1947,7 +1947,7 @@ static void iwl_trans_pcie_block_txq_ptrs(struct iwl_trans *trans, bool block)
 			txq->block--;
 			if (!txq->block) {
 				iwl_write32(trans, HBUS_TARG_WRPTR,
-					    txq->q.write_ptr | (i << 8));
+					    txq->write_ptr | (i << 8));
 			}
 		} else if (block) {
 			txq->block++;
@@ -1967,14 +1967,14 @@ void iwl_trans_pcie_log_scd_error(struct iwl_trans *trans, struct iwl_txq *txq)
 	int cnt;
 
 	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
-		txq->q.read_ptr, txq->q.write_ptr);
+		txq->read_ptr, txq->write_ptr);
 
 	if (trans->cfg->use_tfh)
 		/* TODO: access new SCD registers and dump them */
 		return;
 
 	scd_sram_addr = trans_pcie->scd_base_addr +
-			SCD_TX_STTS_QUEUE_OFFSET(txq->q.id);
+			SCD_TX_STTS_QUEUE_OFFSET(txq->id);
 	iwl_trans_read_mem_bytes(trans, scd_sram_addr, buf, sizeof(buf));
 
 	iwl_print_hex_error(trans, buf, sizeof(buf));
@@ -2009,7 +2009,6 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq;
-	struct iwl_queue *q;
 	int cnt;
 	unsigned long now = jiffies;
 	int ret = 0;
@@ -2027,13 +2026,12 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 
 		IWL_DEBUG_TX_QUEUES(trans, "Emptying queue %d...\n", cnt);
 		txq = &trans_pcie->txq[cnt];
-		q = &txq->q;
-		wr_ptr = ACCESS_ONCE(q->write_ptr);
+		wr_ptr = ACCESS_ONCE(txq->write_ptr);
 
-		while (q->read_ptr != ACCESS_ONCE(q->write_ptr) &&
+		while (txq->read_ptr != ACCESS_ONCE(txq->write_ptr) &&
 		       !time_after(jiffies,
 				   now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS))) {
-			u8 write_ptr = ACCESS_ONCE(q->write_ptr);
+			u8 write_ptr = ACCESS_ONCE(txq->write_ptr);
 
 			if (WARN_ONCE(wr_ptr != write_ptr,
 				      "WR pointer moved while flushing %d -> %d\n",
@@ -2042,7 +2040,7 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 			usleep_range(1000, 2000);
 		}
 
-		if (q->read_ptr != q->write_ptr) {
+		if (txq->read_ptr != txq->write_ptr) {
 			IWL_ERR(trans,
 				"fail to flush all tx fifo queues Q %d\n", cnt);
 			ret = -ETIMEDOUT;
@@ -2210,7 +2208,6 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	struct iwl_trans *trans = file->private_data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq;
-	struct iwl_queue *q;
 	char *buf;
 	int pos = 0;
 	int cnt;
@@ -2228,10 +2225,9 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 
 	for (cnt = 0; cnt < trans->cfg->base_params->num_of_queues; cnt++) {
 		txq = &trans_pcie->txq[cnt];
-		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"hwq %.2d: read=%u write=%u use=%d stop=%d need_update=%d frozen=%d%s\n",
-				cnt, q->read_ptr, q->write_ptr,
+				cnt, txq->read_ptr, txq->write_ptr,
 				!!test_bit(cnt, trans_pcie->queue_used),
 				 !!test_bit(cnt, trans_pcie->queue_stopped),
 				 txq->need_update, txq->frozen,
@@ -2659,7 +2655,7 @@ static struct iwl_trans_dump_data
 
 	/* host commands */
 	len += sizeof(*data) +
-		cmdq->q.n_window * (sizeof(*txcmd) + TFD_MAX_PAYLOAD_SIZE);
+		cmdq->n_window * (sizeof(*txcmd) + TFD_MAX_PAYLOAD_SIZE);
 
 	/* FW monitor */
 	if (trans_pcie->fw_mon_page) {
@@ -2727,9 +2723,9 @@ static struct iwl_trans_dump_data
 	data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_TXCMD);
 	txcmd = (void *)data->data;
 	spin_lock_bh(&cmdq->lock);
-	ptr = cmdq->q.write_ptr;
-	for (i = 0; i < cmdq->q.n_window; i++) {
-		u8 idx = get_cmd_index(&cmdq->q, ptr);
+	ptr = cmdq->write_ptr;
+	for (i = 0; i < cmdq->n_window; i++) {
+		u8 idx = get_cmd_index(cmdq, ptr);
 		u32 caplen, cmdlen;
 
 		cmdlen = iwl_trans_pcie_get_cmdlen(trans, cmdq->tfds +
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index b4b925e..0d156fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -71,7 +71,7 @@
  *
  ***************************************************/
 
-static int iwl_queue_space(const struct iwl_queue *q)
+static int iwl_queue_space(const struct iwl_txq *q)
 {
 	unsigned int max;
 	unsigned int used;
@@ -102,7 +102,7 @@ static int iwl_queue_space(const struct iwl_queue *q)
 /*
  * iwl_queue_init - Initialize queue's high/low-water and read/write indexes
  */
-static int iwl_queue_init(struct iwl_queue *q, int slots_num, u32 id)
+static int iwl_queue_init(struct iwl_txq *q, int slots_num, u32 id)
 {
 	q->n_window = slots_num;
 	q->id = id;
@@ -158,13 +158,13 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 
 	spin_lock(&txq->lock);
 	/* check if triggered erroneously */
-	if (txq->q.read_ptr == txq->q.write_ptr) {
+	if (txq->read_ptr == txq->write_ptr) {
 		spin_unlock(&txq->lock);
 		return;
 	}
 	spin_unlock(&txq->lock);
 
-	IWL_ERR(trans, "Queue %d stuck for %u ms.\n", txq->q.id,
+	IWL_ERR(trans, "Queue %d stuck for %u ms.\n", txq->id,
 		jiffies_to_msecs(txq->wd_timeout));
 
 	iwl_trans_pcie_log_scd_error(trans, txq);
@@ -181,13 +181,13 @@ static void iwl_pcie_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 {
 	struct iwlagn_scd_bc_tbl *scd_bc_tbl;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int write_ptr = txq->q.write_ptr;
-	int txq_id = txq->q.id;
+	int write_ptr = txq->write_ptr;
+	int txq_id = txq->id;
 	u8 sec_ctl = 0;
 	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 	__le16 bc_ent;
 	struct iwl_tx_cmd *tx_cmd =
-		(void *) txq->entries[txq->q.write_ptr].cmd->payload;
+		(void *)txq->entries[txq->write_ptr].cmd->payload;
 
 	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
 
@@ -244,12 +244,12 @@ static void iwl_pcie_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwlagn_scd_bc_tbl *scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
-	int txq_id = txq->q.id;
-	int read_ptr = txq->q.read_ptr;
+	int txq_id = txq->id;
+	int read_ptr = txq->read_ptr;
 	u8 sta_id = 0;
 	__le16 bc_ent;
 	struct iwl_tx_cmd *tx_cmd =
-		(void *)txq->entries[txq->q.read_ptr].cmd->payload;
+		(void *)txq->entries[read_ptr].cmd->payload;
 
 	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
 
@@ -273,7 +273,7 @@ static void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 reg = 0;
-	int txq_id = txq->q.id;
+	int txq_id = txq->id;
 
 	lockdep_assert_held(&txq->lock);
 
@@ -307,10 +307,10 @@ static void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans,
 	 * if not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx).
 	 */
-	IWL_DEBUG_TX(trans, "Q:%d WR: 0x%x\n", txq_id, txq->q.write_ptr);
+	IWL_DEBUG_TX(trans, "Q:%d WR: 0x%x\n", txq_id, txq->write_ptr);
 	if (!txq->block)
 		iwl_write32(trans, HBUS_TARG_WRPTR,
-			    txq->q.write_ptr | (txq_id << 8));
+			    txq->write_ptr | (txq_id << 8));
 }
 
 void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans)
@@ -462,8 +462,8 @@ static void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 	/* rd_ptr is bounded by TFD_QUEUE_SIZE_MAX and
 	 * idx is bounded by n_window
 	 */
-	int rd_ptr = txq->q.read_ptr;
-	int idx = get_cmd_index(&txq->q, rd_ptr);
+	int rd_ptr = txq->read_ptr;
+	int idx = get_cmd_index(txq, rd_ptr);
 
 	lockdep_assert_held(&txq->lock);
 
@@ -493,12 +493,10 @@ static int iwl_pcie_txq_build_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
 				  dma_addr_t addr, u16 len, bool reset)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_queue *q;
 	void *tfd;
 	u32 num_tbs;
 
-	q = &txq->q;
-	tfd = txq->tfds + trans_pcie->tfd_size * q->write_ptr;
+	tfd = txq->tfds + trans_pcie->tfd_size * txq->write_ptr;
 
 	if (reset)
 		memset(tfd, 0, trans_pcie->tfd_size);
@@ -537,7 +535,7 @@ static int iwl_pcie_txq_alloc(struct iwl_trans *trans,
 		    (unsigned long)txq);
 	txq->trans_pcie = trans_pcie;
 
-	txq->q.n_window = slots_num;
+	txq->n_window = slots_num;
 
 	txq->entries = kcalloc(slots_num,
 			       sizeof(struct iwl_pcie_txq_entry),
@@ -558,7 +556,7 @@ static int iwl_pcie_txq_alloc(struct iwl_trans *trans,
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
 	txq->tfds = dma_alloc_coherent(trans->dev, tfd_sz,
-				       &txq->q.dma_addr, GFP_KERNEL);
+				       &txq->dma_addr, GFP_KERNEL);
 	if (!txq->tfds)
 		goto error;
 
@@ -572,11 +570,11 @@ static int iwl_pcie_txq_alloc(struct iwl_trans *trans,
 	if (!txq->first_tb_bufs)
 		goto err_free_tfds;
 
-	txq->q.id = txq_id;
+	txq->id = txq_id;
 
 	return 0;
 err_free_tfds:
-	dma_free_coherent(trans->dev, tfd_sz, txq->tfds, txq->q.dma_addr);
+	dma_free_coherent(trans->dev, tfd_sz, txq->tfds, txq->dma_addr);
 error:
 	if (txq->entries && txq_id == trans_pcie->cmd_queue)
 		for (i = 0; i < slots_num; i++)
@@ -600,7 +598,7 @@ static int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
 
 	/* Initialize queue's high/low-water marks, and head/tail indexes */
-	ret = iwl_queue_init(&txq->q, slots_num, txq_id);
+	ret = iwl_queue_init(txq, slots_num, txq_id);
 	if (ret)
 		return ret;
 
@@ -614,10 +612,10 @@ static int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 	if (trans->cfg->use_tfh)
 		iwl_write_direct64(trans,
 				   FH_MEM_CBBC_QUEUE(trans, txq_id),
-				   txq->q.dma_addr);
+				   txq->dma_addr);
 	else
 		iwl_write_direct32(trans, FH_MEM_CBBC_QUEUE(trans, txq_id),
-				   txq->q.dma_addr >> 8);
+				   txq->dma_addr >> 8);
 
 	return 0;
 }
@@ -664,15 +662,14 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
 
 	spin_lock_bh(&txq->lock);
-	while (q->write_ptr != q->read_ptr) {
+	while (txq->write_ptr != txq->read_ptr) {
 		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",
-				   txq_id, q->read_ptr);
+				   txq_id, txq->read_ptr);
 
 		if (txq_id != trans_pcie->cmd_queue) {
-			struct sk_buff *skb = txq->entries[q->read_ptr].skb;
+			struct sk_buff *skb = txq->entries[txq->read_ptr].skb;
 
 			if (WARN_ON_ONCE(!skb))
 				continue;
@@ -680,15 +677,15 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 			iwl_pcie_free_tso_page(trans_pcie, skb);
 		}
 		iwl_pcie_txq_free_tfd(trans, txq);
-		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr);
+		txq->read_ptr = iwl_queue_inc_wrap(txq->read_ptr);
 
-		if (q->read_ptr == q->write_ptr) {
+		if (txq->read_ptr == txq->write_ptr) {
 			unsigned long flags;
 
 			spin_lock_irqsave(&trans_pcie->reg_lock, flags);
 			if (txq_id != trans_pcie->cmd_queue) {
 				IWL_DEBUG_RPM(trans, "Q %d - last tx freed\n",
-					      q->id);
+					      txq->id);
 				iwl_trans_unref(trans);
 			} else {
 				iwl_pcie_clear_cmd_in_flight(trans);
@@ -732,7 +729,7 @@ static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 
 	/* De-alloc array of command/tx buffers */
 	if (txq_id == trans_pcie->cmd_queue)
-		for (i = 0; i < txq->q.n_window; i++) {
+		for (i = 0; i < txq->n_window; i++) {
 			kzfree(txq->entries[i].cmd);
 			kzfree(txq->entries[i].free_buf);
 		}
@@ -741,12 +738,12 @@ static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 	if (txq->tfds) {
 		dma_free_coherent(dev,
 				  trans_pcie->tfd_size * TFD_QUEUE_SIZE_MAX,
-				  txq->tfds, txq->q.dma_addr);
-		txq->q.dma_addr = 0;
+				  txq->tfds, txq->dma_addr);
+		txq->dma_addr = 0;
 		txq->tfds = NULL;
 
 		dma_free_coherent(dev,
-				  sizeof(*txq->first_tb_bufs) * txq->q.n_window,
+				  sizeof(*txq->first_tb_bufs) * txq->n_window,
 				  txq->first_tb_bufs, txq->first_tb_dma);
 	}
 
@@ -830,14 +827,14 @@ void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
 		if (trans->cfg->use_tfh)
 			iwl_write_direct64(trans,
 					   FH_MEM_CBBC_QUEUE(trans, txq_id),
-					   txq->q.dma_addr);
+					   txq->dma_addr);
 		else
 			iwl_write_direct32(trans,
 					   FH_MEM_CBBC_QUEUE(trans, txq_id),
-					   txq->q.dma_addr >> 8);
+					   txq->dma_addr >> 8);
 		iwl_pcie_txq_unmap(trans, txq_id);
-		txq->q.read_ptr = 0;
-		txq->q.write_ptr = 0;
+		txq->read_ptr = 0;
+		txq->write_ptr = 0;
 	}
 
 	/* Tell NIC where to find the "keep warm" buffer */
@@ -1081,7 +1078,7 @@ static inline void iwl_pcie_txq_progress(struct iwl_txq *txq)
 	 * if empty delete timer, otherwise move timer forward
 	 * since we're making progress on this queue
 	 */
-	if (txq->q.read_ptr == txq->q.write_ptr)
+	if (txq->read_ptr == txq->write_ptr)
 		del_timer(&txq->stuck_timer);
 	else
 		mod_timer(&txq->stuck_timer, jiffies + txq->wd_timeout);
@@ -1094,7 +1091,6 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
 	int tfd_num = ssn & (TFD_QUEUE_SIZE_MAX - 1);
-	struct iwl_queue *q = &txq->q;
 	int last_to_free;
 
 	/* This function is not meant to release cmd queue*/
@@ -1109,21 +1105,21 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 		goto out;
 	}
 
-	if (txq->q.read_ptr == tfd_num)
+	if (txq->read_ptr == tfd_num)
 		goto out;
 
 	IWL_DEBUG_TX_REPLY(trans, "[Q %d] %d -> %d (%d)\n",
-			   txq_id, txq->q.read_ptr, tfd_num, ssn);
+			   txq_id, txq->read_ptr, tfd_num, ssn);
 
 	/*Since we free until index _not_ inclusive, the one before index is
 	 * the last we will free. This one must be used */
 	last_to_free = iwl_queue_dec_wrap(tfd_num);
 
-	if (!iwl_queue_used(q, last_to_free)) {
+	if (!iwl_queue_used(txq, last_to_free)) {
 		IWL_ERR(trans,
 			"%s: Read index for DMA queue txq id (%d), last_to_free %d is out of range [0-%d] %d %d.\n",
 			__func__, txq_id, last_to_free, TFD_QUEUE_SIZE_MAX,
-			q->write_ptr, q->read_ptr);
+			txq->write_ptr, txq->read_ptr);
 		goto out;
 	}
 
@@ -1131,9 +1127,9 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 		goto out;
 
 	for (;
-	     q->read_ptr != tfd_num;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr)) {
-		struct sk_buff *skb = txq->entries[txq->q.read_ptr].skb;
+	     txq->read_ptr != tfd_num;
+	     txq->read_ptr = iwl_queue_inc_wrap(txq->read_ptr)) {
+		struct sk_buff *skb = txq->entries[txq->read_ptr].skb;
 
 		if (WARN_ON_ONCE(!skb))
 			continue;
@@ -1142,7 +1138,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 		__skb_queue_tail(skbs, skb);
 
-		txq->entries[txq->q.read_ptr].skb = NULL;
+		txq->entries[txq->read_ptr].skb = NULL;
 
 		if (!trans->cfg->use_tfh)
 			iwl_pcie_txq_inval_byte_cnt_tbl(trans, txq);
@@ -1152,7 +1148,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	iwl_pcie_txq_progress(txq);
 
-	if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
+	if (iwl_queue_space(txq) > txq->low_mark &&
 	    test_bit(txq_id, trans_pcie->queue_stopped)) {
 		struct sk_buff_head overflow_skbs;
 
@@ -1184,12 +1180,12 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 		}
 		spin_lock_bh(&txq->lock);
 
-		if (iwl_queue_space(&txq->q) > txq->q.low_mark)
+		if (iwl_queue_space(txq) > txq->low_mark)
 			iwl_wake_queue(trans, txq);
 	}
 
-	if (q->read_ptr == q->write_ptr) {
-		IWL_DEBUG_RPM(trans, "Q %d - last tx reclaimed\n", q->id);
+	if (txq->read_ptr == txq->write_ptr) {
+		IWL_DEBUG_RPM(trans, "Q %d - last tx reclaimed\n", txq->id);
 		iwl_trans_unref(trans);
 	}
 
@@ -1251,31 +1247,30 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
 	unsigned long flags;
 	int nfreed = 0;
 
 	lockdep_assert_held(&txq->lock);
 
-	if ((idx >= TFD_QUEUE_SIZE_MAX) || (!iwl_queue_used(q, idx))) {
+	if ((idx >= TFD_QUEUE_SIZE_MAX) || (!iwl_queue_used(txq, idx))) {
 		IWL_ERR(trans,
 			"%s: Read index for DMA queue txq id (%d), index %d is out of range [0-%d] %d %d.\n",
 			__func__, txq_id, idx, TFD_QUEUE_SIZE_MAX,
-			q->write_ptr, q->read_ptr);
+			txq->write_ptr, txq->read_ptr);
 		return;
 	}
 
-	for (idx = iwl_queue_inc_wrap(idx); q->read_ptr != idx;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr)) {
+	for (idx = iwl_queue_inc_wrap(idx); txq->read_ptr != idx;
+	     txq->read_ptr = iwl_queue_inc_wrap(txq->read_ptr)) {
 
 		if (nfreed++ > 0) {
 			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n",
-				idx, q->write_ptr, q->read_ptr);
+				idx, txq->write_ptr, txq->read_ptr);
 			iwl_force_nmi(trans);
 		}
 	}
 
-	if (q->read_ptr == q->write_ptr) {
+	if (txq->read_ptr == txq->write_ptr) {
 		spin_lock_irqsave(&trans_pcie->reg_lock, flags);
 		iwl_pcie_clear_cmd_in_flight(trans);
 		spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
@@ -1361,14 +1356,14 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 			 */
 			iwl_scd_txq_disable_agg(trans, txq_id);
 
-			ssn = txq->q.read_ptr;
+			ssn = txq->read_ptr;
 		}
 	}
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
-	txq->q.read_ptr = (ssn & 0xff);
-	txq->q.write_ptr = (ssn & 0xff);
+	txq->read_ptr = (ssn & 0xff);
+	txq->write_ptr = (ssn & 0xff);
 	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
 			   (ssn & 0xff) | (txq_id << 8));
 
@@ -1484,7 +1479,6 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
-	struct iwl_queue *q = &txq->q;
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
 	unsigned long flags;
@@ -1583,7 +1577,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 
 	spin_lock_bh(&txq->lock);
 
-	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
+	if (iwl_queue_space(txq) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
 		spin_unlock_bh(&txq->lock);
 
 		IWL_ERR(trans, "No space in command queue\n");
@@ -1592,7 +1586,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		goto free_dup_buf;
 	}
 
-	idx = get_cmd_index(q, q->write_ptr);
+	idx = get_cmd_index(txq, txq->write_ptr);
 	out_cmd = txq->entries[idx].cmd;
 	out_meta = &txq->entries[idx].meta;
 
@@ -1611,7 +1605,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		out_cmd->hdr_wide.reserved = 0;
 		out_cmd->hdr_wide.sequence =
 			cpu_to_le16(QUEUE_TO_SEQ(trans_pcie->cmd_queue) |
-						 INDEX_TO_SEQ(q->write_ptr));
+						 INDEX_TO_SEQ(txq->write_ptr));
 
 		cmd_pos = sizeof(struct iwl_cmd_header_wide);
 		copy_size = sizeof(struct iwl_cmd_header_wide);
@@ -1619,7 +1613,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		out_cmd->hdr.cmd = iwl_cmd_opcode(cmd->id);
 		out_cmd->hdr.sequence =
 			cpu_to_le16(QUEUE_TO_SEQ(trans_pcie->cmd_queue) |
-						 INDEX_TO_SEQ(q->write_ptr));
+						 INDEX_TO_SEQ(txq->write_ptr));
 		out_cmd->hdr.group_id = 0;
 
 		cmd_pos = sizeof(struct iwl_cmd_header);
@@ -1669,7 +1663,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		     iwl_get_cmd_string(trans, cmd->id),
 		     group_id, out_cmd->hdr.cmd,
 		     le16_to_cpu(out_cmd->hdr.sequence),
-		     cmd_size, q->write_ptr, idx, trans_pcie->cmd_queue);
+		     cmd_size, txq->write_ptr, idx, trans_pcie->cmd_queue);
 
 	/* start the TFD with the minimum copy bytes */
 	tb0_size = min_t(int, copy_size, IWL_FIRST_TB_SIZE);
@@ -1685,7 +1679,8 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 					   copy_size - tb0_size,
 					   DMA_TO_DEVICE);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
-			iwl_pcie_tfd_unmap(trans, out_meta, txq, q->write_ptr);
+			iwl_pcie_tfd_unmap(trans, out_meta, txq,
+					   txq->write_ptr);
 			idx = -ENOMEM;
 			goto out;
 		}
@@ -1708,7 +1703,8 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		phys_addr = dma_map_single(trans->dev, (void *)data,
 					   cmdlen[i], DMA_TO_DEVICE);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
-			iwl_pcie_tfd_unmap(trans, out_meta, txq, q->write_ptr);
+			iwl_pcie_tfd_unmap(trans, out_meta, txq,
+					   txq->write_ptr);
 			idx = -ENOMEM;
 			goto out;
 		}
@@ -1725,7 +1721,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr_wide);
 
 	/* start timer if queue currently empty */
-	if (q->read_ptr == q->write_ptr && txq->wd_timeout)
+	if (txq->read_ptr == txq->write_ptr && txq->wd_timeout)
 		mod_timer(&txq->stuck_timer, jiffies + txq->wd_timeout);
 
 	spin_lock_irqsave(&trans_pcie->reg_lock, flags);
@@ -1737,7 +1733,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	}
 
 	/* Increment and update queue's write index */
-	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr);
+	txq->write_ptr = iwl_queue_inc_wrap(txq->write_ptr);
 	iwl_pcie_txq_inc_wr_ptr(trans, txq);
 
 	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
@@ -1775,15 +1771,15 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 	if (WARN(txq_id != trans_pcie->cmd_queue,
 		 "wrong command queue %d (should be %d), sequence 0x%X readp=%d writep=%d\n",
 		 txq_id, trans_pcie->cmd_queue, sequence,
-		 trans_pcie->txq[trans_pcie->cmd_queue].q.read_ptr,
-		 trans_pcie->txq[trans_pcie->cmd_queue].q.write_ptr)) {
+		 trans_pcie->txq[trans_pcie->cmd_queue].read_ptr,
+		 trans_pcie->txq[trans_pcie->cmd_queue].write_ptr)) {
 		iwl_print_hex_error(trans, pkt, 32);
 		return;
 	}
 
 	spin_lock_bh(&txq->lock);
 
-	cmd_index = get_cmd_index(&txq->q, index);
+	cmd_index = get_cmd_index(txq, index);
 	cmd = txq->entries[cmd_index].cmd;
 	meta = &txq->entries[cmd_index].meta;
 	cmd_id = iwl_cmd_id(cmd->hdr.cmd, group_id, 0);
@@ -1901,14 +1897,13 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 				 HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
 		struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
-		struct iwl_queue *q = &txq->q;
 
 		IWL_ERR(trans, "Error sending %s: time out after %dms.\n",
 			iwl_get_cmd_string(trans, cmd->id),
 			jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
 		IWL_ERR(trans, "Current CMD queue read_ptr %d write_ptr %d\n",
-			q->read_ptr, q->write_ptr);
+			txq->read_ptr, txq->write_ptr);
 
 		clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
@@ -1987,7 +1982,6 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 			     struct iwl_device_cmd *dev_cmd, u16 tb1_len)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_queue *q = &txq->q;
 	u16 tb2_len;
 	int i;
 
@@ -2002,7 +1996,8 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 						     skb->data + hdr_len,
 						     tb2_len, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(trans->dev, tb2_phys))) {
-			iwl_pcie_tfd_unmap(trans, out_meta, txq, q->write_ptr);
+			iwl_pcie_tfd_unmap(trans, out_meta, txq,
+					   txq->write_ptr);
 			return -EINVAL;
 		}
 		iwl_pcie_txq_build_tfd(trans, txq, tb2_phys, tb2_len, false);
@@ -2021,7 +2016,8 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 					   skb_frag_size(frag), DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(trans->dev, tb_phys))) {
-			iwl_pcie_tfd_unmap(trans, out_meta, txq, q->write_ptr);
+			iwl_pcie_tfd_unmap(trans, out_meta, txq,
+					   txq->write_ptr);
 			return -EINVAL;
 		}
 		tb_idx = iwl_pcie_txq_build_tfd(trans, txq, tb_phys,
@@ -2031,7 +2027,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 	}
 
 	trace_iwlwifi_dev_tx(trans->dev, skb,
-			     iwl_pcie_get_tfd(trans_pcie, txq, q->write_ptr),
+			     iwl_pcie_get_tfd(trans_pcie, txq, txq->write_ptr),
 			     trans_pcie->tfd_size,
 			     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
 			     skb->data + hdr_len, tb2_len);
@@ -2093,7 +2089,6 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int snap_ip_tcp_hdrlen, ip_hdrlen, total_len, hdr_room;
 	unsigned int mss = skb_shinfo(skb)->gso_size;
-	struct iwl_queue *q = &txq->q;
 	u16 length, iv_len, amsdu_pad;
 	u8 *start_hdr;
 	struct iwl_tso_hdr_page *hdr_page;
@@ -2107,7 +2102,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 		IEEE80211_CCMP_HDR_LEN : 0;
 
 	trace_iwlwifi_dev_tx(trans->dev, skb,
-			     iwl_pcie_get_tfd(trans_pcie, txq, q->write_ptr),
+			     iwl_pcie_get_tfd(trans_pcie, txq, txq->write_ptr),
 			     trans_pcie->tfd_size,
 			     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
 			     NULL, 0);
@@ -2264,7 +2259,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 	return 0;
 
 out_unmap:
-	iwl_pcie_tfd_unmap(trans, out_meta, txq, q->write_ptr);
+	iwl_pcie_tfd_unmap(trans, out_meta, txq, txq->write_ptr);
 	return ret;
 }
 #else /* CONFIG_INET */
@@ -2288,7 +2283,6 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	struct iwl_tx_cmd *tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
 	struct iwl_cmd_meta *out_meta;
 	struct iwl_txq *txq;
-	struct iwl_queue *q;
 	dma_addr_t tb0_phys, tb1_phys, scratch_phys;
 	void *tb1_addr;
 	void *tfd;
@@ -2300,7 +2294,6 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	bool amsdu;
 
 	txq = &trans_pcie->txq[txq_id];
-	q = &txq->q;
 
 	if (WARN_ONCE(!test_bit(txq_id, trans_pcie->queue_used),
 		      "TX on unused queue %d\n", txq_id))
@@ -2335,11 +2328,11 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	spin_lock(&txq->lock);
 
-	if (iwl_queue_space(q) < q->high_mark) {
+	if (iwl_queue_space(txq) < txq->high_mark) {
 		iwl_stop_queue(trans, txq);
 
 		/* don't put the packet on the ring, if there is no room */
-		if (unlikely(iwl_queue_space(q) < 3)) {
+		if (unlikely(iwl_queue_space(txq) < 3)) {
 			struct iwl_device_cmd **dev_cmd_ptr;
 
 			dev_cmd_ptr = (void *)((u8 *)skb->cb +
@@ -2360,19 +2353,19 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	 */
 	wifi_seq = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 	WARN_ONCE(txq->ampdu &&
-		  (wifi_seq & 0xff) != q->write_ptr,
+		  (wifi_seq & 0xff) != txq->write_ptr,
 		  "Q: %d WiFi Seq %d tfdNum %d",
-		  txq_id, wifi_seq, q->write_ptr);
+		  txq_id, wifi_seq, txq->write_ptr);
 
 	/* Set up driver data for this TFD */
-	txq->entries[q->write_ptr].skb = skb;
-	txq->entries[q->write_ptr].cmd = dev_cmd;
+	txq->entries[txq->write_ptr].skb = skb;
+	txq->entries[txq->write_ptr].cmd = dev_cmd;
 
 	dev_cmd->hdr.sequence =
 		cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
-			    INDEX_TO_SEQ(q->write_ptr)));
+			    INDEX_TO_SEQ(txq->write_ptr)));
 
-	tb0_phys = iwl_pcie_get_first_tb_dma(txq, q->write_ptr);
+	tb0_phys = iwl_pcie_get_first_tb_dma(txq, txq->write_ptr);
 	scratch_phys = tb0_phys + sizeof(struct iwl_cmd_header) +
 		       offsetof(struct iwl_tx_cmd, scratch);
 
@@ -2380,7 +2373,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
-	out_meta = &txq->entries[q->write_ptr].meta;
+	out_meta = &txq->entries[txq->write_ptr].meta;
 	out_meta->flags = 0;
 
 	/*
@@ -2405,7 +2398,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	}
 
 	/* The first TB points to bi-directional DMA data */
-	memcpy(&txq->first_tb_bufs[q->write_ptr], &dev_cmd->hdr,
+	memcpy(&txq->first_tb_bufs[txq->write_ptr], &dev_cmd->hdr,
 	       IWL_FIRST_TB_SIZE);
 	iwl_pcie_txq_build_tfd(trans, txq, tb0_phys,
 			       IWL_FIRST_TB_SIZE, true);
@@ -2430,7 +2423,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		goto out_err;
 	}
 
-	tfd = iwl_pcie_get_tfd(trans_pcie, txq, q->write_ptr);
+	tfd = iwl_pcie_get_tfd(trans_pcie, txq, txq->write_ptr);
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_pcie_txq_update_byte_cnt_tbl(trans, txq, le16_to_cpu(tx_cmd->len),
 					 iwl_pcie_tfd_get_num_tbs(trans, tfd));
@@ -2438,7 +2431,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	wait_write_ptr = ieee80211_has_morefrags(fc);
 
 	/* start timer if queue currently empty */
-	if (q->read_ptr == q->write_ptr) {
+	if (txq->read_ptr == txq->write_ptr) {
 		if (txq->wd_timeout) {
 			/*
 			 * If the TXQ is active, then set the timer, if not,
@@ -2452,12 +2445,12 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			else
 				txq->frozen_expiry_remainder = txq->wd_timeout;
 		}
-		IWL_DEBUG_RPM(trans, "Q: %d first tx - take ref\n", q->id);
+		IWL_DEBUG_RPM(trans, "Q: %d first tx - take ref\n", txq->id);
 		iwl_trans_ref(trans);
 	}
 
 	/* Tell device the write index *just past* this latest filled TFD */
-	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr);
+	txq->write_ptr = iwl_queue_inc_wrap(txq->write_ptr);
 	if (!wait_write_ptr)
 		iwl_pcie_txq_inc_wr_ptr(trans, txq);
 
-- 
2.9.3
