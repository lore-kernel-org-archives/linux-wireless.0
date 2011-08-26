Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1HZGxg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 34/60] iwlagn: transport layer should receive iwl_trans
Date: Thu, 25 Aug 2011 23:11:06 -0700
Message-Id: <1314339092-20797-35-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085443_537150_8A40542F)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Change a lot of functions to have them receive iwl_trans and not iwl_priv.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   16 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |  186 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-trans.c          |  248 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   40 ++--
 4 files changed, 251 insertions(+), 239 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index cb4b59d..b2af467 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -140,28 +140,26 @@ irqreturn_t iwl_isr_ict(int irq, void *data);
 * TX / HCMD
 ******************************************************/
 void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
+int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
 				 struct iwl_tx_queue *txq,
 				 dma_addr_t addr, u16 len, u8 reset);
-int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
-			  int count, int slots_num, u32 id);
-int iwl_trans_pcie_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
-int __must_check iwl_trans_pcie_send_cmd_pdu(struct iwl_priv *priv, u8 id,
+int iwl_queue_init(struct iwl_queue *q, int count, int slots_num, u32 id);
+int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
+int __must_check iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id,
 			u32 flags, u16 len, const void *data);
 void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
-void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt);
 int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 				  u16 ssn_idx, u8 tx_fifo);
-void iwl_trans_set_wr_ptrs(struct iwl_priv *priv,
-		     int txq_id, u32 index);
+void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
 void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq,
 			     int tx_fifo_id, int scd_retry);
 void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 						int frame_limit);
-void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	int index);
 void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 			  struct sk_buff_head *skbs);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 8ba9a46..49845c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -41,12 +41,11 @@
 /**
  * iwl_trans_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
-void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt)
 {
 	struct iwlagn_scd_bc_tbl *scd_bc_tbl;
-	struct iwl_trans *trans = trans(priv);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 	int write_ptr = txq->q.write_ptr;
@@ -170,7 +169,7 @@ static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
 	return tfd->num_tbs & 0x1f;
 }
 
-static void iwlagn_unmap_tfd(struct iwl_priv *priv, struct iwl_cmd_meta *meta,
+static void iwlagn_unmap_tfd(struct iwl_trans *trans, struct iwl_cmd_meta *meta,
 		     struct iwl_tfd *tfd, enum dma_data_direction dma_dir)
 {
 	int i;
@@ -180,39 +179,39 @@ static void iwlagn_unmap_tfd(struct iwl_priv *priv, struct iwl_cmd_meta *meta,
 	num_tbs = iwl_tfd_get_num_tbs(tfd);
 
 	if (num_tbs >= IWL_NUM_OF_TBS) {
-		IWL_ERR(priv, "Too many chunks: %i\n", num_tbs);
+		IWL_ERR(trans, "Too many chunks: %i\n", num_tbs);
 		/* @todo issue fatal error, it is quite serious situation */
 		return;
 	}
 
 	/* Unmap tx_cmd */
 	if (num_tbs)
-		dma_unmap_single(priv->bus->dev,
+		dma_unmap_single(bus(trans)->dev,
 				dma_unmap_addr(meta, mapping),
 				dma_unmap_len(meta, len),
 				DMA_BIDIRECTIONAL);
 
 	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++)
-		dma_unmap_single(priv->bus->dev, iwl_tfd_tb_get_addr(tfd, i),
+		dma_unmap_single(bus(trans)->dev, iwl_tfd_tb_get_addr(tfd, i),
 				iwl_tfd_tb_get_len(tfd, i), dma_dir);
 }
 
 /**
  * iwlagn_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
- * @priv - driver private data
+ * @trans - transport private data
  * @txq - tx queue
  * @index - the index of the TFD to be freed
  *
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
-void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	int index)
 {
 	struct iwl_tfd *tfd_tmp = txq->tfds;
 
-	iwlagn_unmap_tfd(priv, &txq->meta[index], &tfd_tmp[index],
+	iwlagn_unmap_tfd(trans, &txq->meta[index], &tfd_tmp[index],
 			 DMA_TO_DEVICE);
 
 	/* free SKB */
@@ -229,7 +228,7 @@ void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	}
 }
 
-int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
+int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
 				 struct iwl_tx_queue *txq,
 				 dma_addr_t addr, u16 len,
 				 u8 reset)
@@ -249,7 +248,7 @@ int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 
 	/* Each TFD can point to a maximum 20 Tx buffers */
 	if (num_tbs >= IWL_NUM_OF_TBS) {
-		IWL_ERR(priv, "Error can not send more than %d chunks\n",
+		IWL_ERR(trans, "Error can not send more than %d chunks\n",
 			  IWL_NUM_OF_TBS);
 		return -EINVAL;
 	}
@@ -258,7 +257,7 @@ int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 		return -EINVAL;
 
 	if (unlikely(addr & ~IWL_TX_DMA_MASK))
-		IWL_ERR(priv, "Unaligned address = %llx\n",
+		IWL_ERR(trans, "Unaligned address = %llx\n",
 			  (unsigned long long)addr);
 
 	iwl_tfd_set_tb(tfd, num_tbs, addr, len);
@@ -307,8 +306,7 @@ int iwl_queue_space(const struct iwl_queue *q)
 /**
  * iwl_queue_init - Initialize queue's high/low-water and read/write indexes
  */
-int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
-			  int count, int slots_num, u32 id)
+int iwl_queue_init(struct iwl_queue *q, int count, int slots_num, u32 id)
 {
 	q->n_bd = count;
 	q->n_window = slots_num;
@@ -337,23 +335,20 @@ int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	return 0;
 }
 
-static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
+static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
 					  struct iwl_tx_queue *txq)
 {
-	struct iwlagn_scd_bc_tbl *scd_bc_tbl;
-	struct iwl_trans *trans = trans(priv);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwlagn_scd_bc_tbl *scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
 	int txq_id = txq->q.id;
 	int read_ptr = txq->q.read_ptr;
 	u8 sta_id = 0;
 	__le16 bc_ent;
 
-	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
-
 	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
 
-	if (txq_id != priv->shrd->cmd_queue)
+	if (txq_id != trans->shrd->cmd_queue)
 		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
 
 	bc_ent = cpu_to_le16(1 | (sta_id << 12));
@@ -364,14 +359,13 @@ static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] = bc_ent;
 }
 
-static int iwlagn_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
+static int iwlagn_tx_queue_set_q2ratid(struct iwl_trans *trans, u16 ra_tid,
 					u16 txq_id)
 {
 	u32 tbl_dw_addr;
 	u32 tbl_dw;
 	u16 scd_q2ratid;
 
-	struct iwl_trans *trans = trans(priv);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -380,34 +374,34 @@ static int iwlagn_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
 	tbl_dw_addr = trans_pcie->scd_base_addr +
 			SCD_TRANS_TBL_OFFSET_QUEUE(txq_id);
 
-	tbl_dw = iwl_read_targ_mem(priv, tbl_dw_addr);
+	tbl_dw = iwl_read_targ_mem(priv(trans), tbl_dw_addr);
 
 	if (txq_id & 0x1)
 		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
 	else
 		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
 
-	iwl_write_targ_mem(priv, tbl_dw_addr, tbl_dw);
+	iwl_write_targ_mem(priv(trans), tbl_dw_addr, tbl_dw);
 
 	return 0;
 }
 
-static void iwlagn_tx_queue_stop_scheduler(struct iwl_priv *priv, u16 txq_id)
+static void iwlagn_tx_queue_stop_scheduler(struct iwl_trans *trans, u16 txq_id)
 {
 	/* Simply stop the queue, but don't change any configuration;
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
-	iwl_write_prph(priv,
+	iwl_write_prph(priv(trans),
 		SCD_QUEUE_STATUS_BITS(txq_id),
 		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
 		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
-void iwl_trans_set_wr_ptrs(struct iwl_priv *priv,
+void iwl_trans_set_wr_ptrs(struct iwl_trans *trans,
 				int txq_id, u32 index)
 {
-	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
+	iwl_write_direct32(priv(trans), HBUS_TARG_WRPTR,
 			(index & 0xff) | (txq_id << 8));
-	iwl_write_prph(priv, SCD_QUEUE_RDPTR(txq_id), index);
+	iwl_write_prph(priv(trans), SCD_QUEUE_RDPTR(txq_id), index);
 }
 
 void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
@@ -459,10 +453,10 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	spin_lock_irqsave(&priv->shrd->lock, flags);
 
 	/* Stop this Tx queue before configuring it */
-	iwlagn_tx_queue_stop_scheduler(priv, txq_id);
+	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
 
 	/* Map receiver-address / traffic-ID to this queue */
-	iwlagn_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
+	iwlagn_tx_queue_set_q2ratid(trans, ra_tid, txq_id);
 
 	/* Set this queue as a chain-building queue */
 	iwl_set_bits_prph(priv, SCD_QUEUECHAIN_SEL, (1<<txq_id));
@@ -474,7 +468,7 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
-	iwl_trans_set_wr_ptrs(priv, txq_id, ssn_idx);
+	iwl_trans_set_wr_ptrs(trans, txq_id, ssn_idx);
 
 	/* Set up Tx window size and frame limit for this queue */
 	iwl_write_targ_mem(priv, trans_pcie->scd_base_addr +
@@ -501,6 +495,7 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 				  u16 ssn_idx, u8 tx_fifo)
 {
+	struct iwl_trans *trans = trans(priv);
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWLAGN_FIRST_AMPDU_QUEUE +
 		priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
@@ -512,14 +507,14 @@ int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 		return -EINVAL;
 	}
 
-	iwlagn_tx_queue_stop_scheduler(priv, txq_id);
+	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
 
 	iwl_clear_bits_prph(priv, SCD_AGGR_SEL, (1 << txq_id));
 
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
-	iwl_trans_set_wr_ptrs(priv, txq_id, ssn_idx);
+	iwl_trans_set_wr_ptrs(trans, txq_id, ssn_idx);
 
 	iwl_clear_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
 	iwl_txq_ctx_deactivate(priv, txq_id);
@@ -539,8 +534,9 @@ int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
  * failed. On success, it turns the index (> 0) of command in the
  * command queue.
  */
-static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
+	struct iwl_priv *priv = priv(trans);
 	struct iwl_tx_queue *txq = &priv->txq[priv->shrd->cmd_queue];
 	struct iwl_queue *q = &txq->q;
 	struct iwl_device_cmd *out_cmd;
@@ -559,14 +555,14 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	int trace_idx;
 #endif
 
-	if (test_bit(STATUS_FW_ERROR, &priv->shrd->status)) {
-		IWL_WARN(priv, "fw recovery, no hcmd send\n");
+	if (test_bit(STATUS_FW_ERROR, &trans->shrd->status)) {
+		IWL_WARN(trans, "fw recovery, no hcmd send\n");
 		return -EIO;
 	}
 
 	if ((priv->ucode_owner == IWL_OWNERSHIP_TM) &&
 	    !(cmd->flags & CMD_ON_DEMAND)) {
-		IWL_DEBUG_HC(priv, "tm own the uCode, no regular hcmd send\n");
+		IWL_DEBUG_HC(trans, "tm own the uCode, no regular hcmd send\n");
 		return -EIO;
 	}
 
@@ -599,9 +595,9 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	if (WARN_ON(copy_size > TFD_MAX_PAYLOAD_SIZE))
 		return -EINVAL;
 
-	if (iwl_is_rfkill(priv->shrd) || iwl_is_ctkill(priv->shrd)) {
-		IWL_WARN(priv, "Not sending command - %s KILL\n",
-			 iwl_is_rfkill(priv->shrd) ? "RF" : "CT");
+	if (iwl_is_rfkill(trans->shrd) || iwl_is_ctkill(trans->shrd)) {
+		IWL_WARN(trans, "Not sending command - %s KILL\n",
+			 iwl_is_rfkill(trans->shrd) ? "RF" : "CT");
 		return -EIO;
 	}
 
@@ -610,10 +606,10 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
 		spin_unlock_irqrestore(&priv->hcmd_lock, flags);
 
-		IWL_ERR(priv, "No space in command queue\n");
+		IWL_ERR(trans, "No space in command queue\n");
 		is_ct_kill = iwl_check_for_ct_kill(priv);
 		if (!is_ct_kill) {
-			IWL_ERR(priv, "Restarting adapter due to queue full\n");
+			IWL_ERR(trans, "Restarting adapter queue is full\n");
 			iwlagn_fw_error(priv, false);
 		}
 		return -ENOSPC;
@@ -634,7 +630,7 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	out_cmd->hdr.cmd = cmd->id;
 	out_cmd->hdr.flags = 0;
 	out_cmd->hdr.sequence =
-		cpu_to_le16(QUEUE_TO_SEQ(priv->shrd->cmd_queue) |
+		cpu_to_le16(QUEUE_TO_SEQ(trans->shrd->cmd_queue) |
 					 INDEX_TO_SEQ(q->write_ptr));
 
 	/* and copy the data that needs to be copied */
@@ -649,16 +645,16 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		cmd_dest += cmd->len[i];
 	}
 
-	IWL_DEBUG_HC(priv, "Sending command %s (#%x), seq: 0x%04X, "
+	IWL_DEBUG_HC(trans, "Sending command %s (#%x), seq: 0x%04X, "
 			"%d bytes at %d[%d]:%d\n",
 			get_cmd_string(out_cmd->hdr.cmd),
 			out_cmd->hdr.cmd,
 			le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
-			q->write_ptr, idx, priv->shrd->cmd_queue);
+			q->write_ptr, idx, trans->shrd->cmd_queue);
 
-	phys_addr = dma_map_single(priv->bus->dev, &out_cmd->hdr, copy_size,
+	phys_addr = dma_map_single(bus(trans)->dev, &out_cmd->hdr, copy_size,
 				DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(priv->bus->dev, phys_addr))) {
+	if (unlikely(dma_mapping_error(bus(trans)->dev, phys_addr))) {
 		idx = -ENOMEM;
 		goto out;
 	}
@@ -666,7 +662,8 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	dma_unmap_addr_set(out_meta, mapping, phys_addr);
 	dma_unmap_len_set(out_meta, len, copy_size);
 
-	iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr, copy_size, 1);
+	iwlagn_txq_attach_buf_to_tfd(trans, txq,
+					phys_addr, copy_size, 1);
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
 	trace_bufs[0] = &out_cmd->hdr;
 	trace_lens[0] = copy_size;
@@ -678,17 +675,18 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			continue;
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
-		phys_addr = dma_map_single(priv->bus->dev, (void *)cmd->data[i],
+		phys_addr = dma_map_single(bus(trans)->dev,
+					   (void *)cmd->data[i],
 					   cmd->len[i], DMA_BIDIRECTIONAL);
-		if (dma_mapping_error(priv->bus->dev, phys_addr)) {
-			iwlagn_unmap_tfd(priv, out_meta,
+		if (dma_mapping_error(bus(trans)->dev, phys_addr)) {
+			iwlagn_unmap_tfd(trans, out_meta,
 					 &txq->tfds[q->write_ptr],
 					 DMA_BIDIRECTIONAL);
 			idx = -ENOMEM;
 			goto out;
 		}
 
-		iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr,
+		iwlagn_txq_attach_buf_to_tfd(trans, txq, phys_addr,
 					     cmd->len[i], 0);
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
 		trace_bufs[trace_idx] = cmd->data[i];
@@ -768,17 +766,18 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	int cmd_index;
 	struct iwl_device_cmd *cmd;
 	struct iwl_cmd_meta *meta;
-	struct iwl_tx_queue *txq = &priv->txq[priv->shrd->cmd_queue];
+	struct iwl_trans *trans = trans(priv);
+	struct iwl_tx_queue *txq = &priv->txq[trans->shrd->cmd_queue];
 	unsigned long flags;
 
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
 	 * in the queue management code. */
-	if (WARN(txq_id != priv->shrd->cmd_queue,
+	if (WARN(txq_id != trans->shrd->cmd_queue,
 		 "wrong command queue %d (should be %d), sequence 0x%X readp=%d writep=%d\n",
-		  txq_id, priv->shrd->cmd_queue, sequence,
-		  priv->txq[priv->shrd->cmd_queue].q.read_ptr,
-		  priv->txq[priv->shrd->cmd_queue].q.write_ptr)) {
+		  txq_id, trans->shrd->cmd_queue, sequence,
+		  priv->txq[trans->shrd->cmd_queue].q.read_ptr,
+		  priv->txq[trans->shrd->cmd_queue].q.write_ptr)) {
 		iwl_print_hex_error(priv, pkt, 32);
 		return;
 	}
@@ -787,7 +786,8 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
-	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index], DMA_BIDIRECTIONAL);
+	iwlagn_unmap_tfd(trans, meta, &txq->tfds[index],
+			 DMA_BIDIRECTIONAL);
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
@@ -801,8 +801,8 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	iwl_hcmd_queue_reclaim(priv, txq_id, index);
 
 	if (!(meta->flags & CMD_ASYNC)) {
-		clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
-		IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command %s\n",
+		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(cmd->hdr.cmd));
 		wake_up_interruptible(&priv->wait_command_queue);
 	}
@@ -920,7 +920,7 @@ static void iwl_generic_cmd_callback(struct iwl_priv *priv,
 #endif
 }
 
-static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+static int iwl_send_cmd_async(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
 	int ret;
 
@@ -932,77 +932,77 @@ static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	if (!cmd->callback)
 		cmd->callback = iwl_generic_cmd_callback;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &trans->shrd->status))
 		return -EBUSY;
 
-	ret = iwl_enqueue_hcmd(priv, cmd);
+	ret = iwl_enqueue_hcmd(trans, cmd);
 	if (ret < 0) {
-		IWL_ERR(priv, "Error sending %s: enqueue_hcmd failed: %d\n",
+		IWL_ERR(trans, "Error sending %s: enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
 		return ret;
 	}
 	return 0;
 }
 
-static int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
 	int cmd_idx;
 	int ret;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&trans->shrd->mutex);
 
 	 /* A synchronous command can not have a callback set. */
 	if (WARN_ON(cmd->callback))
 		return -EINVAL;
 
-	IWL_DEBUG_INFO(priv, "Attempting to send sync command %s\n",
+	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
 
-	set_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
-	IWL_DEBUG_INFO(priv, "Setting HCMD_ACTIVE for command %s\n",
+	set_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+	IWL_DEBUG_INFO(trans, "Setting HCMD_ACTIVE for command %s\n",
 			get_cmd_string(cmd->id));
 
-	cmd_idx = iwl_enqueue_hcmd(priv, cmd);
+	cmd_idx = iwl_enqueue_hcmd(trans, cmd);
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
-		clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
-		IWL_ERR(priv, "Error sending %s: enqueue_hcmd failed: %d\n",
+		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+		IWL_ERR(trans, "Error sending %s: enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
 		return ret;
 	}
 
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
-			!test_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status),
+	ret = wait_event_interruptible_timeout(priv(trans)->wait_command_queue,
+			!test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status),
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
-		if (test_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status)) {
-			IWL_ERR(priv,
+		if (test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status)) {
+			IWL_ERR(trans,
 				"Error sending %s: time out after %dms.\n",
 				get_cmd_string(cmd->id),
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
-			clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
-			IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command"
+			clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+			IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command"
 				 "%s\n", get_cmd_string(cmd->id));
 			ret = -ETIMEDOUT;
 			goto cancel;
 		}
 	}
 
-	if (test_bit(STATUS_RF_KILL_HW, &priv->shrd->status)) {
-		IWL_ERR(priv, "Command %s aborted: RF KILL Switch\n",
+	if (test_bit(STATUS_RF_KILL_HW, &trans->shrd->status)) {
+		IWL_ERR(trans, "Command %s aborted: RF KILL Switch\n",
 			       get_cmd_string(cmd->id));
 		ret = -ECANCELED;
 		goto fail;
 	}
-	if (test_bit(STATUS_FW_ERROR, &priv->shrd->status)) {
-		IWL_ERR(priv, "Command %s failed: FW Error\n",
+	if (test_bit(STATUS_FW_ERROR, &trans->shrd->status)) {
+		IWL_ERR(trans, "Command %s failed: FW Error\n",
 			       get_cmd_string(cmd->id));
 		ret = -EIO;
 		goto fail;
 	}
 	if ((cmd->flags & CMD_WANT_SKB) && !cmd->reply_page) {
-		IWL_ERR(priv, "Error: Response NULL in '%s'\n",
+		IWL_ERR(trans, "Error: Response NULL in '%s'\n",
 			  get_cmd_string(cmd->id));
 		ret = -EIO;
 		goto cancel;
@@ -1018,27 +1018,27 @@ cancel:
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source).
 		 */
-		priv->txq[priv->shrd->cmd_queue].meta[cmd_idx].flags &=
+		priv(trans)->txq[trans->shrd->cmd_queue].meta[cmd_idx].flags &=
 							~CMD_WANT_SKB;
 	}
 fail:
 	if (cmd->reply_page) {
-		iwl_free_pages(priv->shrd, cmd->reply_page);
+		iwl_free_pages(trans->shrd, cmd->reply_page);
 		cmd->reply_page = 0;
 	}
 
 	return ret;
 }
 
-int iwl_trans_pcie_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
 	if (cmd->flags & CMD_ASYNC)
-		return iwl_send_cmd_async(priv, cmd);
+		return iwl_send_cmd_async(trans, cmd);
 
-	return iwl_send_cmd_sync(priv, cmd);
+	return iwl_send_cmd_sync(trans, cmd);
 }
 
-int iwl_trans_pcie_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags,
+int iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id, u32 flags,
 		u16 len, const void *data)
 {
 	struct iwl_host_cmd cmd = {
@@ -1048,7 +1048,7 @@ int iwl_trans_pcie_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags,
 		.flags = flags,
 	};
 
-	return iwl_trans_pcie_send_cmd(priv, &cmd);
+	return iwl_trans_pcie_send_cmd(trans, &cmd);
 }
 
 /* Frees buffers until index _not_ inclusive */
@@ -1096,9 +1096,9 @@ void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 
 		tx_info->skb = NULL;
 
-		iwlagn_txq_inval_byte_cnt_tbl(priv(trans), txq);
+		iwlagn_txq_inval_byte_cnt_tbl(trans, txq);
 
-		iwlagn_txq_free_tfd(priv(trans), txq, txq->q.read_ptr);
+		iwlagn_txq_free_tfd(trans, txq, txq->q.read_ptr);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 8956008..b448e79 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -62,6 +62,8 @@
  *****************************************************************************/
 #include <linux/interrupt.h>
 #include <linux/debugfs.h>
+#include <linux/bitops.h>
+#include <linux/gfp.h>
 
 #include "iwl-dev.h"
 #include "iwl-trans.h"
@@ -263,22 +265,22 @@ static void iwl_trans_pcie_rx_free(struct iwl_trans *trans)
 	rxq->rb_stts = NULL;
 }
 
-static int iwl_trans_rx_stop(struct iwl_priv *priv)
+static int iwl_trans_rx_stop(struct iwl_trans *trans)
 {
 
 	/* stop Rx DMA */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	return iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
+	iwl_write_direct32(priv(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	return iwl_poll_direct_bit(priv(trans), FH_MEM_RSSR_RX_STATUS_REG,
 			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 }
 
-static inline int iwlagn_alloc_dma_ptr(struct iwl_priv *priv,
+static inline int iwlagn_alloc_dma_ptr(struct iwl_trans *trans,
 				    struct iwl_dma_ptr *ptr, size_t size)
 {
 	if (WARN_ON(ptr->addr))
 		return -EINVAL;
 
-	ptr->addr = dma_alloc_coherent(priv->bus->dev, size,
+	ptr->addr = dma_alloc_coherent(bus(trans)->dev, size,
 				       &ptr->dma, GFP_KERNEL);
 	if (!ptr->addr)
 		return -ENOMEM;
@@ -286,20 +288,21 @@ static inline int iwlagn_alloc_dma_ptr(struct iwl_priv *priv,
 	return 0;
 }
 
-static inline void iwlagn_free_dma_ptr(struct iwl_priv *priv,
+static inline void iwlagn_free_dma_ptr(struct iwl_trans *trans,
 				    struct iwl_dma_ptr *ptr)
 {
 	if (unlikely(!ptr->addr))
 		return;
 
-	dma_free_coherent(priv->bus->dev, ptr->size, ptr->addr, ptr->dma);
+	dma_free_coherent(bus(trans)->dev, ptr->size, ptr->addr, ptr->dma);
 	memset(ptr, 0, sizeof(*ptr));
 }
 
-static int iwl_trans_txq_alloc(struct iwl_priv *priv, struct iwl_tx_queue *txq,
-		      int slots_num, u32 txq_id)
+static int iwl_trans_txq_alloc(struct iwl_trans *trans,
+				struct iwl_tx_queue *txq, int slots_num,
+				u32 txq_id)
 {
-	size_t tfd_sz = hw_params(priv).tfd_size * TFD_QUEUE_SIZE_MAX;
+	size_t tfd_sz = hw_params(trans).tfd_size * TFD_QUEUE_SIZE_MAX;
 	int i;
 
 	if (WARN_ON(txq->meta || txq->cmd || txq->txb || txq->tfds))
@@ -325,11 +328,11 @@ static int iwl_trans_txq_alloc(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	/* Alloc driver data array and TFD circular buffer */
 	/* Driver private data, only for Tx (not command) queues,
 	 * not shared with device. */
-	if (txq_id != priv->shrd->cmd_queue) {
+	if (txq_id != trans->shrd->cmd_queue) {
 		txq->txb = kzalloc(sizeof(txq->txb[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
 		if (!txq->txb) {
-			IWL_ERR(priv, "kmalloc for auxiliary BD "
+			IWL_ERR(trans, "kmalloc for auxiliary BD "
 				  "structures failed\n");
 			goto error;
 		}
@@ -339,10 +342,10 @@ static int iwl_trans_txq_alloc(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
-	txq->tfds = dma_alloc_coherent(priv->bus->dev, tfd_sz, &txq->q.dma_addr,
-				       GFP_KERNEL);
+	txq->tfds = dma_alloc_coherent(bus(trans)->dev, tfd_sz,
+				       &txq->q.dma_addr, GFP_KERNEL);
 	if (!txq->tfds) {
-		IWL_ERR(priv, "dma_alloc_coherent(%zd) failed\n", tfd_sz);
+		IWL_ERR(trans, "dma_alloc_coherent(%zd) failed\n", tfd_sz);
 		goto error;
 	}
 	txq->q.id = txq_id;
@@ -365,7 +368,7 @@ error:
 
 }
 
-static int iwl_trans_txq_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+static int iwl_trans_txq_init(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 		      int slots_num, u32 txq_id)
 {
 	int ret;
@@ -386,7 +389,7 @@ static int iwl_trans_txq_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
 
 	/* Initialize queue's high/low-water marks, and head/tail indexes */
-	ret = iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num,
+	ret = iwl_queue_init(&txq->q, TFD_QUEUE_SIZE_MAX, slots_num,
 			txq_id);
 	if (ret)
 		return ret;
@@ -395,7 +398,7 @@ static int iwl_trans_txq_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	 * Tell nic where to find circular buffer of Tx Frame Descriptors for
 	 * given Tx queue, and enable the DMA channel used for that queue.
 	 * Circular buffer (TFD queue in DRAM) physical base address */
-	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
+	iwl_write_direct32(priv(trans), FH_MEM_CBBC_QUEUE(txq_id),
 			     txq->q.dma_addr >> 8);
 
 	return 0;
@@ -404,8 +407,9 @@ static int iwl_trans_txq_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 /**
  * iwl_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
  */
-static void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
+static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 {
+	struct iwl_priv *priv = priv(trans);
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 
@@ -414,7 +418,7 @@ static void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
 
 	while (q->write_ptr != q->read_ptr) {
 		/* The read_ptr needs to bound by q->n_window */
-		iwlagn_txq_free_tfd(priv, txq, get_cmd_index(q, q->read_ptr));
+		iwlagn_txq_free_tfd(trans, txq, get_cmd_index(q, q->read_ptr));
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 }
@@ -427,15 +431,16 @@ static void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
  * Free all buffers.
  * 0-fill, but do not free "txq" descriptor structure.
  */
-static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
+static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 {
+	struct iwl_priv *priv = priv(trans);
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct device *dev = priv->bus->dev;
+	struct device *dev = bus(trans)->dev;
 	int i;
 	if (WARN_ON(!txq))
 		return;
 
-	iwl_tx_queue_unmap(priv, txq_id);
+	iwl_tx_queue_unmap(trans, txq_id);
 
 	/* De-alloc array of command/tx buffers */
 	for (i = 0; i < txq->q.n_window; i++)
@@ -443,7 +448,7 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd) {
-		dma_free_coherent(dev, hw_params(priv).tfd_size *
+		dma_free_coherent(dev, hw_params(trans).tfd_size *
 				  txq->q.n_bd, txq->tfds, txq->q.dma_addr);
 		memset(&txq->q.dma_addr, 0, sizeof(txq->q.dma_addr));
 	}
@@ -467,26 +472,26 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
  *
  * Destroy all TX DMA queues and structures
  */
-static void iwl_trans_pcie_tx_free(struct iwl_priv *priv)
+static void iwl_trans_pcie_tx_free(struct iwl_trans *trans)
 {
 	int txq_id;
-	struct iwl_trans *trans = trans(priv);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_priv *priv = priv(trans);
 
 	/* Tx queues */
 	if (priv->txq) {
 		for (txq_id = 0;
-		     txq_id < hw_params(priv).max_txq_num; txq_id++)
-			iwl_tx_queue_free(priv, txq_id);
+		     txq_id < hw_params(trans).max_txq_num; txq_id++)
+			iwl_tx_queue_free(trans, txq_id);
 	}
 
 	kfree(priv->txq);
 	priv->txq = NULL;
 
-	iwlagn_free_dma_ptr(priv, &priv->kw);
+	iwlagn_free_dma_ptr(trans, &priv->kw);
 
-	iwlagn_free_dma_ptr(priv, &trans_pcie->scd_bc_tbls);
+	iwlagn_free_dma_ptr(trans, &trans_pcie->scd_bc_tbls);
 }
 
 /**
@@ -496,11 +501,11 @@ static void iwl_trans_pcie_tx_free(struct iwl_priv *priv)
  * @param priv
  * @return error code
  */
-static int iwl_trans_tx_alloc(struct iwl_priv *priv)
+static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 {
 	int ret;
 	int txq_id, slots_num;
-	struct iwl_trans *trans = trans(priv);
+	struct iwl_priv *priv = priv(trans);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -511,36 +516,36 @@ static int iwl_trans_tx_alloc(struct iwl_priv *priv)
 		goto error;
 	}
 
-	ret = iwlagn_alloc_dma_ptr(priv, &trans_pcie->scd_bc_tbls,
-				hw_params(priv).scd_bc_tbls_size);
+	ret = iwlagn_alloc_dma_ptr(trans, &trans_pcie->scd_bc_tbls,
+				hw_params(trans).scd_bc_tbls_size);
 	if (ret) {
-		IWL_ERR(priv, "Scheduler BC Table allocation failed\n");
+		IWL_ERR(trans, "Scheduler BC Table allocation failed\n");
 		goto error;
 	}
 
 	/* Alloc keep-warm buffer */
-	ret = iwlagn_alloc_dma_ptr(priv, &priv->kw, IWL_KW_SIZE);
+	ret = iwlagn_alloc_dma_ptr(trans, &priv->kw, IWL_KW_SIZE);
 	if (ret) {
-		IWL_ERR(priv, "Keep Warm allocation failed\n");
+		IWL_ERR(trans, "Keep Warm allocation failed\n");
 		goto error;
 	}
 
 	priv->txq = kzalloc(sizeof(struct iwl_tx_queue) *
 			priv->cfg->base_params->num_of_queues, GFP_KERNEL);
 	if (!priv->txq) {
-		IWL_ERR(priv, "Not enough memory for txq\n");
+		IWL_ERR(trans, "Not enough memory for txq\n");
 		ret = ENOMEM;
 		goto error;
 	}
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
-	for (txq_id = 0; txq_id < hw_params(priv).max_txq_num; txq_id++) {
-		slots_num = (txq_id == priv->shrd->cmd_queue) ?
+	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
+		slots_num = (txq_id == trans->shrd->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_trans_txq_alloc(priv, &priv->txq[txq_id], slots_num,
+		ret = iwl_trans_txq_alloc(trans, &priv->txq[txq_id], slots_num,
 				       txq_id);
 		if (ret) {
-			IWL_ERR(priv, "Tx %d queue alloc failed\n", txq_id);
+			IWL_ERR(trans, "Tx %d queue alloc failed\n", txq_id);
 			goto error;
 		}
 	}
@@ -548,25 +553,26 @@ static int iwl_trans_tx_alloc(struct iwl_priv *priv)
 	return 0;
 
 error:
-	iwl_trans_tx_free(trans(priv));
+	iwl_trans_tx_free(trans);
 
 	return ret;
 }
-static int iwl_tx_init(struct iwl_priv *priv)
+static int iwl_tx_init(struct iwl_trans *trans)
 {
 	int ret;
 	int txq_id, slots_num;
 	unsigned long flags;
 	bool alloc = false;
+	struct iwl_priv *priv = priv(trans);
 
 	if (!priv->txq) {
-		ret = iwl_trans_tx_alloc(priv);
+		ret = iwl_trans_tx_alloc(trans);
 		if (ret)
 			goto error;
 		alloc = true;
 	}
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	spin_lock_irqsave(&trans->shrd->lock, flags);
 
 	/* Turn off all Tx DMA fifos */
 	iwl_write_prph(priv, SCD_TXFACT, 0);
@@ -574,16 +580,16 @@ static int iwl_tx_init(struct iwl_priv *priv)
 	/* Tell NIC where to find the "keep warm" buffer */
 	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
 
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
-	for (txq_id = 0; txq_id < hw_params(priv).max_txq_num; txq_id++) {
-		slots_num = (txq_id == priv->shrd->cmd_queue) ?
+	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
+		slots_num = (txq_id == trans->shrd->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_trans_txq_init(priv, &priv->txq[txq_id], slots_num,
+		ret = iwl_trans_txq_init(trans, &priv->txq[txq_id], slots_num,
 				       txq_id);
 		if (ret) {
-			IWL_ERR(priv, "Tx %d queue init failed\n", txq_id);
+			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
 			goto error;
 		}
 	}
@@ -592,7 +598,7 @@ static int iwl_tx_init(struct iwl_priv *priv)
 error:
 	/*Upon error, free only if we allocated something */
 	if (alloc)
-		iwl_trans_tx_free(trans(priv));
+		iwl_trans_tx_free(trans);
 	return ret;
 }
 
@@ -613,28 +619,29 @@ static void iwl_set_pwr_vmain(struct iwl_priv *priv)
 			       ~APMG_PS_CTRL_MSK_PWR_SRC);
 }
 
-static int iwl_nic_init(struct iwl_priv *priv)
+static int iwl_nic_init(struct iwl_trans *trans)
 {
 	unsigned long flags;
+	struct iwl_priv *priv = priv(trans);
 
 	/* nic_init */
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	spin_lock_irqsave(&trans->shrd->lock, flags);
 	iwl_apm_init(priv);
 
 	/* Set interrupt coalescing calibration timer to default (512 usecs) */
 	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
 
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
 	iwl_set_pwr_vmain(priv);
 
 	priv->cfg->lib->nic_config(priv);
 
 	/* Allocate the RX queue, or reset if it is already allocated */
-	iwl_rx_init(trans(priv));
+	iwl_rx_init(trans);
 
 	/* Allocate or reset and init all Tx and Command queues */
-	if (iwl_tx_init(priv))
+	if (iwl_tx_init(trans))
 		return -ENOMEM;
 
 	if (priv->cfg->base_params->shadow_reg_enable) {
@@ -643,7 +650,7 @@ static int iwl_nic_init(struct iwl_priv *priv)
 			0x800FFFFF);
 	}
 
-	set_bit(STATUS_INIT, &priv->shrd->status);
+	set_bit(STATUS_INIT, &trans->shrd->status);
 
 	return 0;
 }
@@ -651,39 +658,39 @@ static int iwl_nic_init(struct iwl_priv *priv)
 #define HW_READY_TIMEOUT (50)
 
 /* Note: returns poll_bit return value, which is >= 0 if success */
-static int iwl_set_hw_ready(struct iwl_priv *priv)
+static int iwl_set_hw_ready(struct iwl_trans *trans)
 {
 	int ret;
 
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(priv(trans), CSR_HW_IF_CONFIG_REG,
 		CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
 
 	/* See if we got it */
-	ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
+	ret = iwl_poll_bit(priv(trans), CSR_HW_IF_CONFIG_REG,
 				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
 				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
 				HW_READY_TIMEOUT);
 
-	IWL_DEBUG_INFO(priv, "hardware%s ready\n", ret < 0 ? " not" : "");
+	IWL_DEBUG_INFO(trans, "hardware%s ready\n", ret < 0 ? " not" : "");
 	return ret;
 }
 
 /* Note: returns standard 0/-ERROR code */
-static int iwl_trans_pcie_prepare_card_hw(struct iwl_priv *priv)
+static int iwl_trans_pcie_prepare_card_hw(struct iwl_trans *trans)
 {
 	int ret;
 
-	IWL_DEBUG_INFO(priv, "iwl_trans_prepare_card_hw enter\n");
+	IWL_DEBUG_INFO(trans, "iwl_trans_prepare_card_hw enter\n");
 
-	ret = iwl_set_hw_ready(priv);
+	ret = iwl_set_hw_ready(trans);
 	if (ret >= 0)
 		return 0;
 
 	/* If HW is not ready, prepare the conditions to check again */
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(priv(trans), CSR_HW_IF_CONFIG_REG,
 			CSR_HW_IF_CONFIG_REG_PREPARE);
 
-	ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
+	ret = iwl_poll_bit(priv(trans), CSR_HW_IF_CONFIG_REG,
 			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
 			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
 
@@ -691,42 +698,43 @@ static int iwl_trans_pcie_prepare_card_hw(struct iwl_priv *priv)
 		return ret;
 
 	/* HW should be ready by now, check again. */
-	ret = iwl_set_hw_ready(priv);
+	ret = iwl_set_hw_ready(trans);
 	if (ret >= 0)
 		return 0;
 	return ret;
 }
 
-static int iwl_trans_pcie_start_device(struct iwl_priv *priv)
+static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 {
 	int ret;
+	struct iwl_priv *priv = priv(trans);
 
 	priv->ucode_owner = IWL_OWNERSHIP_DRIVER;
 
 	if ((priv->cfg->sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
-	     iwl_trans_pcie_prepare_card_hw(priv)) {
-		IWL_WARN(priv, "Exit HW not ready\n");
+	     iwl_trans_pcie_prepare_card_hw(trans)) {
+		IWL_WARN(trans, "Exit HW not ready\n");
 		return -EIO;
 	}
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (iwl_read32(priv, CSR_GP_CNTRL) &
 			CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
+		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
 	else
-		set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
+		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
 
-	if (iwl_is_rfkill(priv->shrd)) {
+	if (iwl_is_rfkill(trans->shrd)) {
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy, true);
-		iwl_enable_interrupts(trans(priv));
+		iwl_enable_interrupts(trans);
 		return -ERFKILL;
 	}
 
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
-	ret = iwl_nic_init(priv);
+	ret = iwl_nic_init(trans);
 	if (ret) {
-		IWL_ERR(priv, "Unable to init nic\n");
+		IWL_ERR(trans, "Unable to init nic\n");
 		return ret;
 	}
 
@@ -737,7 +745,7 @@ static int iwl_trans_pcie_start_device(struct iwl_priv *priv)
 
 	/* clear (again), then enable host interrupts */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_enable_interrupts(trans(priv));
+	iwl_enable_interrupts(trans);
 
 	/* really make sure rfkill handshake bits are cleared */
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
@@ -750,9 +758,9 @@ static int iwl_trans_pcie_start_device(struct iwl_priv *priv)
  * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
  * must be called under priv->shrd->lock and mac access
  */
-static void iwl_trans_txq_set_sched(struct iwl_priv *priv, u32 mask)
+static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
 {
-	iwl_write_prph(priv, SCD_TXFACT, mask);
+	iwl_write_prph(priv(trans), SCD_TXFACT, mask);
 }
 
 #define IWL_AC_UNSET -1
@@ -788,11 +796,11 @@ static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
 	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
 	{ IWL_TX_FIFO_AUX, IWL_AC_UNSET, },
 };
-static void iwl_trans_pcie_tx_start(struct iwl_priv *priv)
+static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 {
 	const struct queue_to_fifo_ac *queue_to_fifo;
 	struct iwl_rxon_context *ctx;
-	struct iwl_trans *trans = trans(priv);
+	struct iwl_priv *priv = priv(trans);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 a;
@@ -856,7 +864,7 @@ static void iwl_trans_pcie_tx_start(struct iwl_priv *priv)
 			IWL_MASK(0, hw_params(trans).max_txq_num));
 
 	/* Activate all Tx DMA/FIFO channels */
-	iwl_trans_txq_set_sched(priv, IWL_MASK(0, 7));
+	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
 
 	/* map queues to FIFOs */
 	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
@@ -864,7 +872,7 @@ static void iwl_trans_pcie_tx_start(struct iwl_priv *priv)
 	else
 		queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
 
-	iwl_trans_set_wr_ptrs(priv, priv->shrd->cmd_queue, 0);
+	iwl_trans_set_wr_ptrs(trans, trans->shrd->cmd_queue, 0);
 
 	/* make sure all queue are not stopped */
 	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
@@ -895,7 +903,7 @@ static void iwl_trans_pcie_tx_start(struct iwl_priv *priv)
 		iwl_trans_tx_queue_set_status(priv, &priv->txq[i], fifo, 0);
 	}
 
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
 	/* Enable L1-Active */
 	iwl_clear_bits_prph(priv, APMG_PCIDEV_STT_REG,
@@ -905,50 +913,53 @@ static void iwl_trans_pcie_tx_start(struct iwl_priv *priv)
 /**
  * iwlagn_txq_ctx_stop - Stop all Tx DMA channels
  */
-static int iwl_trans_tx_stop(struct iwl_priv *priv)
+static int iwl_trans_tx_stop(struct iwl_trans *trans)
 {
 	int ch, txq_id;
 	unsigned long flags;
+	struct iwl_priv *priv = priv(trans);
 
 	/* Turn off all Tx DMA fifos */
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	spin_lock_irqsave(&trans->shrd->lock, flags);
 
-	iwl_trans_txq_set_sched(priv, 0);
+	iwl_trans_txq_set_sched(trans, 0);
 
 	/* Stop each Tx DMA channel, and wait for it to be idle */
 	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
-		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		if (iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
+		iwl_write_direct32(priv(trans),
+				   FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
+		if (iwl_poll_direct_bit(priv(trans), FH_TSSR_TX_STATUS_REG,
 				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
 				    1000))
-			IWL_ERR(priv, "Failing on timeout while stopping"
+			IWL_ERR(trans, "Failing on timeout while stopping"
 			    " DMA channel %d [0x%08x]", ch,
-			    iwl_read_direct32(priv, FH_TSSR_TX_STATUS_REG));
+			    iwl_read_direct32(priv(trans),
+					      FH_TSSR_TX_STATUS_REG));
 	}
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
 	if (!priv->txq) {
-		IWL_WARN(priv, "Stopping tx queues that aren't allocated...");
+		IWL_WARN(trans, "Stopping tx queues that aren't allocated...");
 		return 0;
 	}
 
 	/* Unmap DMA from host system and free skb's */
-	for (txq_id = 0; txq_id < hw_params(priv).max_txq_num; txq_id++)
-		iwl_tx_queue_unmap(priv, txq_id);
+	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++)
+		iwl_tx_queue_unmap(trans, txq_id);
 
 	return 0;
 }
 
-static void iwl_trans_pcie_stop_device(struct iwl_priv *priv)
+static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 {
 	/* stop and reset the on-board processor */
-	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	iwl_write32(priv(trans), CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
-	iwl_trans_disable_sync_irq(trans(priv));
+	iwl_trans_disable_sync_irq(trans);
 
 	/* device going down, Stop using ICT table */
-	iwl_disable_ict(trans(priv));
+	iwl_disable_ict(trans);
 
 	/*
 	 * If a HW restart happens during firmware loading,
@@ -957,26 +968,28 @@ static void iwl_trans_pcie_stop_device(struct iwl_priv *priv)
 	 * restart. So don't process again if the device is
 	 * already dead.
 	 */
-	if (test_bit(STATUS_DEVICE_ENABLED, &priv->shrd->status)) {
-		iwl_trans_tx_stop(priv);
-		iwl_trans_rx_stop(priv);
+	if (test_bit(STATUS_DEVICE_ENABLED, &trans->shrd->status)) {
+		iwl_trans_tx_stop(trans);
+		iwl_trans_rx_stop(trans);
 
 		/* Power-down device's busmaster DMA clocks */
-		iwl_write_prph(priv, APMG_CLK_DIS_REG,
+		iwl_write_prph(priv(trans), APMG_CLK_DIS_REG,
 			       APMG_CLK_VAL_DMA_CLK_RQT);
 		udelay(5);
 	}
 
 	/* Make sure (redundant) we've released our request to stay awake */
-	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	iwl_clear_bit(priv(trans), CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	/* Stop the device, and put it in low power state */
-	iwl_apm_stop(priv);
+	iwl_apm_stop(priv(trans));
 }
 
-static struct iwl_tx_cmd *iwl_trans_pcie_get_tx_cmd(struct iwl_priv *priv,
+static struct iwl_tx_cmd *iwl_trans_pcie_get_tx_cmd(struct iwl_trans *trans,
 						int txq_id)
 {
+	struct iwl_priv *priv = priv(trans);
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	struct iwl_device_cmd *dev_cmd;
@@ -1072,9 +1085,10 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	}
 
 	/* Attach buffers to TFD */
-	iwlagn_txq_attach_buf_to_tfd(priv, txq, txcmd_phys, firstlen, 1);
+	iwlagn_txq_attach_buf_to_tfd(trans(priv), txq, txcmd_phys,
+					firstlen, 1);
 	if (secondlen > 0)
-		iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr,
+		iwlagn_txq_attach_buf_to_tfd(trans(priv), txq, phys_addr,
 					     secondlen, 0);
 
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
@@ -1094,7 +1108,7 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 
 	/* Set up entry for this TFD in Tx byte-count array */
 	if (ampdu)
-		iwl_trans_txq_update_byte_cnt_tbl(priv, txq,
+		iwl_trans_txq_update_byte_cnt_tbl(trans(priv), txq,
 					       le16_to_cpu(tx_cmd->len));
 
 	dma_sync_single_for_device(priv->bus->dev, txcmd_phys, firstlen,
@@ -1127,10 +1141,10 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	return 0;
 }
 
-static void iwl_trans_pcie_kick_nic(struct iwl_priv *priv)
+static void iwl_trans_pcie_kick_nic(struct iwl_trans *trans)
 {
 	/* Remove all resets to allow NIC to operate */
-	iwl_write32(priv, CSR_RESET, 0);
+	iwl_write32(priv(trans), CSR_RESET, 0);
 }
 
 static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
@@ -1201,12 +1215,12 @@ static void iwl_trans_pcie_disable_sync_irq(struct iwl_trans *trans)
 	tasklet_kill(&trans_pcie->irq_tasklet);
 }
 
-static void iwl_trans_pcie_free(struct iwl_priv *priv)
+static void iwl_trans_pcie_free(struct iwl_trans *trans)
 {
-	free_irq(priv->bus->irq, trans(priv));
-	iwl_free_isr_ict(trans(priv));
-	kfree(trans(priv));
-	trans(priv) = NULL;
+	free_irq(bus(trans)->irq, trans);
+	iwl_free_isr_ict(trans);
+	trans->shrd->trans = NULL;
+	kfree(trans);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 7fd0296..da6cc59 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -109,18 +109,18 @@ struct iwl_trans_ops {
 
 	struct iwl_trans *(*alloc)(struct iwl_shared *shrd);
 	int (*request_irq)(struct iwl_trans *iwl_trans);
-	int (*start_device)(struct iwl_priv *priv);
-	int (*prepare_card_hw)(struct iwl_priv *priv);
-	void (*stop_device)(struct iwl_priv *priv);
-	void (*tx_start)(struct iwl_priv *priv);
-	void (*tx_free)(struct iwl_priv *priv);
+	int (*start_device)(struct iwl_trans *trans);
+	int (*prepare_card_hw)(struct iwl_trans *trans);
+	void (*stop_device)(struct iwl_trans *trans);
+	void (*tx_start)(struct iwl_trans *trans);
+	void (*tx_free)(struct iwl_trans *trans);
 	void (*rx_free)(struct iwl_trans *trans);
 
-	int (*send_cmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
-	int (*send_cmd_pdu)(struct iwl_priv *priv, u8 id, u32 flags, u16 len,
+	int (*send_cmd_pdu)(struct iwl_trans *trans, u8 id, u32 flags, u16 len,
 		     const void *data);
-	struct iwl_tx_cmd * (*get_tx_cmd)(struct iwl_priv *priv, int txq_id);
+	struct iwl_tx_cmd * (*get_tx_cmd)(struct iwl_trans *trans, int txq_id);
 	int (*tx)(struct iwl_priv *priv, struct sk_buff *skb,
 		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
 		struct iwl_rxon_context *ctx);
@@ -132,10 +132,10 @@ struct iwl_trans_ops {
 	void (*txq_agg_setup)(struct iwl_priv *priv, int sta_id, int tid,
 						int frame_limit);
 
-	void (*kick_nic)(struct iwl_priv *priv);
+	void (*kick_nic)(struct iwl_trans *trans);
 
 	void (*disable_sync_irq)(struct iwl_trans *trans);
-	void (*free)(struct iwl_priv *priv);
+	void (*free)(struct iwl_trans *trans);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
 	int (*suspend)(struct iwl_trans *trans);
@@ -163,22 +163,22 @@ static inline int iwl_trans_request_irq(struct iwl_trans *trans)
 
 static inline int iwl_trans_start_device(struct iwl_trans *trans)
 {
-	return trans->ops->start_device(priv(trans));
+	return trans->ops->start_device(trans);
 }
 
 static inline int iwl_trans_prepare_card_hw(struct iwl_trans *trans)
 {
-	return trans->ops->prepare_card_hw(priv(trans));
+	return trans->ops->prepare_card_hw(trans);
 }
 
 static inline void iwl_trans_stop_device(struct iwl_trans *trans)
 {
-	trans->ops->stop_device(priv(trans));
+	trans->ops->stop_device(trans);
 }
 
 static inline void iwl_trans_tx_start(struct iwl_trans *trans)
 {
-	trans->ops->tx_start(priv(trans));
+	trans->ops->tx_start(trans);
 }
 
 static inline void iwl_trans_rx_free(struct iwl_trans *trans)
@@ -188,25 +188,25 @@ static inline void iwl_trans_rx_free(struct iwl_trans *trans)
 
 static inline void iwl_trans_tx_free(struct iwl_trans *trans)
 {
-	trans->ops->tx_free(priv(trans));
+	trans->ops->tx_free(trans);
 }
 
 static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 				struct iwl_host_cmd *cmd)
 {
-	return trans->ops->send_cmd(priv(trans), cmd);
+	return trans->ops->send_cmd(trans, cmd);
 }
 
 static inline int iwl_trans_send_cmd_pdu(struct iwl_trans *trans, u8 id,
 					u32 flags, u16 len, const void *data)
 {
-	return trans->ops->send_cmd_pdu(priv(trans), id, flags, len, data);
+	return trans->ops->send_cmd_pdu(trans, id, flags, len, data);
 }
 
 static inline struct iwl_tx_cmd *iwl_trans_get_tx_cmd(struct iwl_trans *trans,
 					int txq_id)
 {
-	return trans->ops->get_tx_cmd(priv(trans), txq_id);
+	return trans->ops->get_tx_cmd(trans, txq_id);
 }
 
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
@@ -238,7 +238,7 @@ static inline void iwl_trans_txq_agg_setup(struct iwl_trans *trans, int sta_id,
 
 static inline void iwl_trans_kick_nic(struct iwl_trans *trans)
 {
-	trans->ops->kick_nic(priv(trans));
+	trans->ops->kick_nic(trans);
 }
 
 static inline void iwl_trans_disable_sync_irq(struct iwl_trans *trans)
@@ -248,7 +248,7 @@ static inline void iwl_trans_disable_sync_irq(struct iwl_trans *trans)
 
 static inline void iwl_trans_free(struct iwl_trans *trans)
 {
-	trans->ops->free(priv(trans));
+	trans->ops->free(trans);
 }
 
 static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
-- 
1.7.0.4

