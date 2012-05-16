Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab2EPUyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:54:39 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 8/9] iwlwifi: clean up coding style in PCIe transport
Date: Wed, 16 May 2012 22:54:29 +0200
Message-Id: <1337201670-21604-9-git-send-email-johannes@sipsolutions.net> (sfid-20120516_225447_495579_34D5F69C)
In-Reply-To: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
References: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Mostly clean up indentation around parentheses
after if, function calls, etc. and also a few
unneeded line breaks and some other things.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    8 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   67 +++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   68 ++++---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |  203 ++++++++++-----------
 4 files changed, 161 insertions(+), 185 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index ccb97b9..f027769 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -313,7 +313,7 @@ void iwl_bg_rx_replenish(struct work_struct *data);
 void iwl_irq_tasklet(struct iwl_trans *trans);
 void iwlagn_rx_replenish(struct iwl_trans *trans);
 void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
-			struct iwl_rx_queue *q);
+				   struct iwl_rx_queue *q);
 
 /*****************************************************
 * ICT
@@ -328,7 +328,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data);
 * TX / HCMD
 ******************************************************/
 void iwl_txq_update_write_ptr(struct iwl_trans *trans,
-			struct iwl_tx_queue *txq);
+			      struct iwl_tx_queue *txq);
 int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
 				 struct iwl_tx_queue *txq,
 				 dma_addr_t addr, u16 len, u8 reset);
@@ -337,8 +337,8 @@ int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 void iwl_tx_cmd_complete(struct iwl_trans *trans,
 			 struct iwl_rx_cmd_buffer *rxb, int handler_status);
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
-					   struct iwl_tx_queue *txq,
-					   u16 byte_cnt);
+				       struct iwl_tx_queue *txq,
+				       u16 byte_cnt);
 void iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int queue);
 void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
 void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 1a7eb2a..98605fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -130,7 +130,7 @@ static int iwl_rx_queue_space(const struct iwl_rx_queue *q)
  * iwl_rx_queue_update_write_ptr - Update the write pointer for the RX queue
  */
 void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
-			struct iwl_rx_queue *q)
+				   struct iwl_rx_queue *q)
 {
 	unsigned long flags;
 	u32 reg;
@@ -201,9 +201,7 @@ static inline __le32 iwlagn_dma_addr2rbd_ptr(dma_addr_t dma_addr)
  */
 static void iwlagn_rx_queue_restock(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
@@ -253,9 +251,7 @@ static void iwlagn_rx_queue_restock(struct iwl_trans *trans)
  */
 static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
@@ -278,8 +274,7 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 			gfp_mask |= __GFP_COMP;
 
 		/* Alloc a new receive buffer */
-		page = alloc_pages(gfp_mask,
-				  trans_pcie->rx_page_order);
+		page = alloc_pages(gfp_mask, trans_pcie->rx_page_order);
 		if (!page) {
 			if (net_ratelimit())
 				IWL_DEBUG_INFO(trans, "alloc_pages failed, "
@@ -315,9 +310,10 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 		BUG_ON(rxb->page);
 		rxb->page = page;
 		/* Get physical address of the RB */
-		rxb->page_dma = dma_map_page(trans->dev, page, 0,
-				PAGE_SIZE << trans_pcie->rx_page_order,
-				DMA_FROM_DEVICE);
+		rxb->page_dma =
+			dma_map_page(trans->dev, page, 0,
+				     PAGE_SIZE << trans_pcie->rx_page_order,
+				     DMA_FROM_DEVICE);
 		/* dma address must be no more than 36 bits */
 		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
 		/* and also 256 byte aligned! */
@@ -465,8 +461,8 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 	if (rxb->page != NULL) {
 		rxb->page_dma =
 			dma_map_page(trans->dev, rxb->page, 0,
-				PAGE_SIZE << trans_pcie->rx_page_order,
-				DMA_FROM_DEVICE);
+				     PAGE_SIZE << trans_pcie->rx_page_order,
+				     DMA_FROM_DEVICE);
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
 	} else
@@ -546,12 +542,12 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
 	if (trans->cfg->internal_wimax_coex &&
 	    (!(iwl_read_prph(trans, APMG_CLK_CTRL_REG) &
-			APMS_CLK_VAL_MRB_FUNC_MODE) ||
+			     APMS_CLK_VAL_MRB_FUNC_MODE) ||
 	     (iwl_read_prph(trans, APMG_PS_CTRL_REG) &
-			APMG_PS_CTRL_VAL_RESET_REQ))) {
-		struct iwl_trans_pcie *trans_pcie;
+			    APMG_PS_CTRL_VAL_RESET_REQ))) {
+		struct iwl_trans_pcie *trans_pcie =
+			IWL_TRANS_GET_PCIE_TRANS(trans);
 
-		trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
 		iwl_op_mode_wimax_active(trans->op_mode);
 		wake_up(&trans->wait_command_queue);
@@ -567,6 +563,8 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 /* tasklet for iwlagn interrupt */
 void iwl_irq_tasklet(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
 	u32 inta = 0;
 	u32 handled = 0;
 	unsigned long flags;
@@ -575,10 +573,6 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	u32 inta_mask;
 #endif
 
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
-
-
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
 	/* Ack/clear/reset pending uCode interrupts.
@@ -593,7 +587,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	 * interrupt coalescing can still be achieved.
 	 */
 	iwl_write32(trans, CSR_INT,
-		trans_pcie->inta | ~trans_pcie->inta_mask);
+		    trans_pcie->inta | ~trans_pcie->inta_mask);
 
 	inta = trans_pcie->inta;
 
@@ -602,7 +596,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		/* just for debug */
 		inta_mask = iwl_read32(trans, CSR_INT_MASK);
 		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n",
-				inta, inta_mask);
+			      inta, inta_mask);
 	}
 #endif
 
@@ -651,7 +645,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 
 		hw_rfkill = iwl_is_rfkill_set(trans);
 		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
-				hw_rfkill ? "disable radio" : "enable radio");
+			 hw_rfkill ? "disable radio" : "enable radio");
 
 		isr_stats->rfkill++;
 
@@ -693,7 +687,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	 * Rx "responses" (frame-received notification), and other
 	 * notifications from uCode come through here*/
 	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX |
-			CSR_INT_BIT_RX_PERIODIC)) {
+		    CSR_INT_BIT_RX_PERIODIC)) {
 		IWL_DEBUG_ISR(trans, "Rx interrupt\n");
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
 			handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
@@ -733,7 +727,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		 */
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX))
 			iwl_write8(trans, CSR_INT_PERIODIC_REG,
-				    CSR_INT_PERIODIC_ENA);
+				   CSR_INT_PERIODIC_ENA);
 
 		isr_stats->rx++;
 	}
@@ -782,8 +776,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 /* Free dram table */
 void iwl_free_isr_ict(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	if (trans_pcie->ict_tbl) {
 		dma_free_coherent(trans->dev, ICT_SIZE,
@@ -802,8 +795,7 @@ void iwl_free_isr_ict(struct iwl_trans *trans)
  */
 int iwl_alloc_isr_ict(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	trans_pcie->ict_tbl =
 		dma_alloc_coherent(trans->dev, ICT_SIZE,
@@ -837,10 +829,9 @@ int iwl_alloc_isr_ict(struct iwl_trans *trans)
  */
 void iwl_reset_ict(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 val;
 	unsigned long flags;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	if (!trans_pcie->ict_tbl)
 		return;
@@ -868,9 +859,7 @@ void iwl_reset_ict(struct iwl_trans *trans)
 /* Device is going down disable ict interrupt usage */
 void iwl_disable_ict(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
@@ -934,7 +923,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	if (likely(inta))
 		tasklet_schedule(&trans_pcie->irq_tasklet);
 	else if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
-			!trans_pcie->inta)
+		 !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
  unplugged:
@@ -945,7 +934,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	/* re-enable interrupts here since we don't have anything to service. */
 	/* only Re-enable if disabled by irq  and no schedules tasklet. */
 	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
-		!trans_pcie->inta)
+	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
@@ -1036,7 +1025,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 
 	inta = (0xff & val) | ((0xff00 & val) << 16);
 	IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled 0x%08x ict 0x%08x\n",
-			inta, inta_mask, val);
+		      inta, inta_mask, val);
 
 	inta &= trans_pcie->inta_mask;
 	trans_pcie->inta |= inta;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index e727c4f..6f601cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -47,12 +47,11 @@
  * iwl_trans_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
-					   struct iwl_tx_queue *txq,
-					   u16 byte_cnt)
+				       struct iwl_tx_queue *txq,
+				       u16 byte_cnt)
 {
 	struct iwlagn_scd_bc_tbl *scd_bc_tbl;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int write_ptr = txq->q.write_ptr;
 	int txq_id = txq->q.id;
 	u8 sec_ctl = 0;
@@ -270,7 +269,7 @@ int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
 	/* Each TFD can point to a maximum 20 Tx buffers */
 	if (num_tbs >= IWL_NUM_OF_TBS) {
 		IWL_ERR(trans, "Error can not send more than %d chunks\n",
-			  IWL_NUM_OF_TBS);
+			IWL_NUM_OF_TBS);
 		return -EINVAL;
 	}
 
@@ -279,7 +278,7 @@ int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
 
 	if (unlikely(addr & ~IWL_TX_DMA_MASK))
 		IWL_ERR(trans, "Unaligned address = %llx\n",
-			  (unsigned long long)addr);
+			(unsigned long long)addr);
 
 	iwl_tfd_set_tb(tfd, num_tbs, addr, len);
 
@@ -383,15 +382,13 @@ static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
 }
 
 static int iwlagn_tx_queue_set_q2ratid(struct iwl_trans *trans, u16 ra_tid,
-					u16 txq_id)
+				       u16 txq_id)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 tbl_dw_addr;
 	u32 tbl_dw;
 	u16 scd_q2ratid;
 
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
 	scd_q2ratid = ra_tid & SCD_QUEUE_RA_TID_MAP_RATID_MSK;
 
 	tbl_dw_addr = trans_pcie->scd_base_addr +
@@ -419,12 +416,11 @@ static void iwlagn_tx_queue_stop_scheduler(struct iwl_trans *trans, u16 txq_id)
 		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
-void iwl_trans_set_wr_ptrs(struct iwl_trans *trans,
-				int txq_id, u32 index)
+void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index)
 {
 	IWL_DEBUG_TX_QUEUES(trans, "Q %d  WrPtr: %d\n", txq_id, index & 0xff);
 	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
-			(index & 0xff) | (txq_id << 8));
+			   (index & 0xff) | (txq_id << 8));
 	iwl_write_prph(trans, SCD_QUEUE_RDPTR(txq_id), index);
 }
 
@@ -615,13 +611,13 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	}
 
 	IWL_DEBUG_HC(trans,
-		"Sending command %s (#%x), seq: 0x%04X, %d bytes at %d[%d]:%d\n",
-		trans_pcie_get_cmd_string(trans_pcie, out_cmd->hdr.cmd),
-		out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
-		q->write_ptr, idx, trans_pcie->cmd_queue);
+		     "Sending command %s (#%x), seq: 0x%04X, %d bytes at %d[%d]:%d\n",
+		     trans_pcie_get_cmd_string(trans_pcie, out_cmd->hdr.cmd),
+		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
+		     cmd_size, q->write_ptr, idx, trans_pcie->cmd_queue);
 
 	phys_addr = dma_map_single(trans->dev, &out_cmd->hdr, copy_size,
-				DMA_BIDIRECTIONAL);
+				   DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(trans->dev, phys_addr))) {
 		idx = -ENOMEM;
 		goto out;
@@ -630,8 +626,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	dma_unmap_addr_set(out_meta, mapping, phys_addr);
 	dma_unmap_len_set(out_meta, len, copy_size);
 
-	iwlagn_txq_attach_buf_to_tfd(trans, txq,
-					phys_addr, copy_size, 1);
+	iwlagn_txq_attach_buf_to_tfd(trans, txq, phys_addr, copy_size, 1);
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
 	trace_bufs[0] = &out_cmd->hdr;
 	trace_lens[0] = copy_size;
@@ -643,8 +638,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 			continue;
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
-		phys_addr = dma_map_single(trans->dev,
-					   (void *)cmd->data[i],
+		phys_addr = dma_map_single(trans->dev, (void *)cmd->data[i],
 					   cmd->len[i], DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
 			iwl_unmap_tfd(trans, out_meta,
@@ -723,9 +717,10 @@ static void iwl_hcmd_queue_reclaim(struct iwl_trans *trans, int txq_id,
 	lockdep_assert_held(&txq->lock);
 
 	if ((idx >= q->n_bd) || (iwl_queue_used(q, idx) == 0)) {
-		IWL_ERR(trans, "%s: Read index for DMA queue txq id (%d), "
-			  "index %d is out of range [0-%d] %d %d.\n", __func__,
-			  txq_id, idx, q->n_bd, q->write_ptr, q->read_ptr);
+		IWL_ERR(trans,
+			"%s: Read index for DMA queue txq id (%d), index %d is out of range [0-%d] %d %d.\n",
+			__func__, txq_id, idx, q->n_bd,
+			q->write_ptr, q->read_ptr);
 		return;
 	}
 
@@ -733,8 +728,8 @@ static void iwl_hcmd_queue_reclaim(struct iwl_trans *trans, int txq_id,
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		if (nfreed++ > 0) {
-			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n", idx,
-					q->write_ptr, q->read_ptr);
+			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n",
+				idx, q->write_ptr, q->read_ptr);
 			iwl_op_mode_nic_error(trans->op_mode);
 		}
 
@@ -771,9 +766,9 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
 	 * in the queue management code. */
 	if (WARN(txq_id != trans_pcie->cmd_queue,
 		 "wrong command queue %d (should be %d), sequence 0x%X readp=%d writep=%d\n",
-		  txq_id, trans_pcie->cmd_queue, sequence,
-		  trans_pcie->txq[trans_pcie->cmd_queue].q.read_ptr,
-		  trans_pcie->txq[trans_pcie->cmd_queue].q.write_ptr)) {
+		 txq_id, trans_pcie->cmd_queue, sequence,
+		 trans_pcie->txq[trans_pcie->cmd_queue].q.read_ptr,
+		 trans_pcie->txq[trans_pcie->cmd_queue].q.write_ptr)) {
 		iwl_print_hex_error(trans, pkt, 32);
 		return;
 	}
@@ -869,8 +864,9 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	}
 
 	ret = wait_event_timeout(trans->wait_command_queue,
-			!test_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status),
-			HOST_COMPLETE_TIMEOUT);
+				 !test_bit(STATUS_HCMD_ACTIVE,
+					   &trans_pcie->status),
+				 HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
 		if (test_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status)) {
 			struct iwl_tx_queue *txq =
@@ -955,10 +951,10 @@ int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 
 	if ((index >= q->n_bd) ||
 	   (iwl_queue_used(q, last_to_free) == 0)) {
-		IWL_ERR(trans, "%s: Read index for DMA queue txq id (%d), "
-			  "last_to_free %d is out of range [0-%d] %d %d.\n",
-			  __func__, txq_id, last_to_free, q->n_bd,
-			  q->write_ptr, q->read_ptr);
+		IWL_ERR(trans,
+			"%s: Read index for DMA queue txq id (%d), last_to_free %d is out of range [0-%d] %d %d.\n",
+			__func__, txq_id, last_to_free, q->n_bd,
+			q->write_ptr, q->read_ptr);
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 12d84e9..02ef48c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -84,8 +84,7 @@
 
 static int iwl_trans_rx_alloc(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	struct device *dev = trans->dev;
 
@@ -112,7 +111,7 @@ static int iwl_trans_rx_alloc(struct iwl_trans *trans)
 
 err_rb_stts:
 	dma_free_coherent(dev, sizeof(__le32) * RX_QUEUE_SIZE,
-			rxq->bd, rxq->bd_dma);
+			  rxq->bd, rxq->bd_dma);
 	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
 	rxq->bd = NULL;
 err_bd:
@@ -121,8 +120,7 @@ err_bd:
 
 static void iwl_trans_rxq_free_rx_bufs(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	int i;
 
@@ -132,8 +130,8 @@ static void iwl_trans_rxq_free_rx_bufs(struct iwl_trans *trans)
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].page != NULL) {
 			dma_unmap_page(trans->dev, rxq->pool[i].page_dma,
-				PAGE_SIZE << trans_pcie->rx_page_order,
-				DMA_FROM_DEVICE);
+				       PAGE_SIZE << trans_pcie->rx_page_order,
+				       DMA_FROM_DEVICE);
 			__free_pages(rxq->pool[i].page,
 				     trans_pcie->rx_page_order);
 			rxq->pool[i].page = NULL;
@@ -191,8 +189,7 @@ static void iwl_trans_rx_hw_init(struct iwl_trans *trans,
 
 static int iwl_rx_init(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 
 	int i, err;
@@ -234,10 +231,8 @@ static int iwl_rx_init(struct iwl_trans *trans)
 
 static void iwl_trans_pcie_rx_free(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-
 	unsigned long flags;
 
 	/*if rxq->bd is NULL, it means that nothing has been allocated,
@@ -272,11 +267,11 @@ static int iwl_trans_rx_stop(struct iwl_trans *trans)
 	/* stop Rx DMA */
 	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 	return iwl_poll_direct_bit(trans, FH_MEM_RSSR_RX_STATUS_REG,
-			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
+				   FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 }
 
-static inline int iwlagn_alloc_dma_ptr(struct iwl_trans *trans,
-				    struct iwl_dma_ptr *ptr, size_t size)
+static int iwlagn_alloc_dma_ptr(struct iwl_trans *trans,
+				struct iwl_dma_ptr *ptr, size_t size)
 {
 	if (WARN_ON(ptr->addr))
 		return -EINVAL;
@@ -289,8 +284,8 @@ static inline int iwlagn_alloc_dma_ptr(struct iwl_trans *trans,
 	return 0;
 }
 
-static inline void iwlagn_free_dma_ptr(struct iwl_trans *trans,
-				    struct iwl_dma_ptr *ptr)
+static void iwlagn_free_dma_ptr(struct iwl_trans *trans,
+				struct iwl_dma_ptr *ptr)
 {
 	if (unlikely(!ptr->addr))
 		return;
@@ -327,12 +322,12 @@ static void iwl_trans_pcie_queue_stuck_timer(unsigned long data)
 }
 
 static int iwl_trans_txq_alloc(struct iwl_trans *trans,
-				struct iwl_tx_queue *txq, int slots_num,
-				u32 txq_id)
+			       struct iwl_tx_queue *txq, int slots_num,
+			       u32 txq_id)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	size_t tfd_sz = sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX;
 	int i;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	if (WARN_ON(txq->entries || txq->tfds))
 		return -EINVAL;
@@ -453,6 +448,7 @@ static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
 	struct device *dev = trans->dev;
 	int i;
+
 	if (WARN_ON(!txq))
 		return;
 
@@ -572,11 +568,11 @@ error:
 }
 static int iwl_tx_init(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
 	int txq_id, slots_num;
 	unsigned long flags;
 	bool alloc = false;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	if (!trans_pcie->txq) {
 		ret = iwl_trans_tx_alloc(trans);
@@ -641,10 +637,9 @@ static void iwl_set_pwr_vmain(struct iwl_trans *trans)
 
 static u16 iwl_pciexp_link_ctrl(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int pos;
 	u16 pci_lnk_ctl;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	struct pci_dev *pci_dev = trans_pcie->pci_dev;
 
@@ -698,14 +693,14 @@ static int iwl_apm_init(struct iwl_trans *trans)
 
 	/* Disable L0S exit timer (platform NMI Work/Around) */
 	iwl_set_bit(trans, CSR_GIO_CHICKEN_BITS,
-			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+		    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
 	/*
 	 * Disable L0s without affecting L1;
 	 *  don't wait for ICH L0s (ICH bug W/A)
 	 */
 	iwl_set_bit(trans, CSR_GIO_CHICKEN_BITS,
-			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
+		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
 	/* Set FH wait threshold to maximum (HW error during stress W/A) */
 	iwl_set_bit(trans, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
@@ -715,7 +710,7 @@ static int iwl_apm_init(struct iwl_trans *trans)
 	 * wake device's PCI Express link L1a -> L0s
 	 */
 	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-				    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
+		    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
 
 	iwl_apm_config(trans);
 
@@ -736,8 +731,8 @@ static int iwl_apm_init(struct iwl_trans *trans)
 	 * and accesses to uCode SRAM.
 	 */
 	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
 		IWL_DEBUG_INFO(trans, "Failed to init the card\n");
 		goto out;
@@ -771,8 +766,8 @@ static int iwl_apm_stop_master(struct iwl_trans *trans)
 	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
 	ret = iwl_poll_bit(trans, CSR_RESET,
-			CSR_RESET_REG_FLAG_MASTER_DISABLED,
-			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
+			   CSR_RESET_REG_FLAG_MASTER_DISABLED,
+			   CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 	if (ret)
 		IWL_WARN(trans, "Master Disable Timed Out, 100 usec\n");
 
@@ -814,8 +809,7 @@ static int iwl_nic_init(struct iwl_trans *trans)
 	iwl_apm_init(trans);
 
 	/* Set interrupt coalescing calibration timer to default (512 usecs) */
-	iwl_write8(trans, CSR_INT_COALESCING,
-		IWL_HOST_INT_CALIB_TIMEOUT_DEF);
+	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
 
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
@@ -834,8 +828,7 @@ static int iwl_nic_init(struct iwl_trans *trans)
 
 	if (trans->cfg->base_params->shadow_reg_enable) {
 		/* enable shadow regs in HW */
-		iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL,
-			0x800FFFFF);
+		iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL, 0x800FFFFF);
 	}
 
 	return 0;
@@ -849,13 +842,13 @@ static int iwl_set_hw_ready(struct iwl_trans *trans)
 	int ret;
 
 	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-		CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
+		    CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
 
 	/* See if we got it */
 	ret = iwl_poll_bit(trans, CSR_HW_IF_CONFIG_REG,
-				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
-				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
-				HW_READY_TIMEOUT);
+			   CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
+			   CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
+			   HW_READY_TIMEOUT);
 
 	IWL_DEBUG_INFO(trans, "hardware%s ready\n", ret < 0 ? " not" : "");
 	return ret;
@@ -875,11 +868,11 @@ static int iwl_prepare_card_hw(struct iwl_trans *trans)
 
 	/* If HW is not ready, prepare the conditions to check again */
 	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-			CSR_HW_IF_CONFIG_REG_PREPARE);
+		    CSR_HW_IF_CONFIG_REG_PREPARE);
 
 	ret = iwl_poll_bit(trans, CSR_HW_IF_CONFIG_REG,
-			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
-			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
+			   ~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
+			   CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
 
 	if (ret < 0)
 		return ret;
@@ -906,32 +899,33 @@ static int iwl_load_section(struct iwl_trans *trans, u8 section_num,
 	trans_pcie->ucode_write_complete = false;
 
 	iwl_write_direct32(trans,
-		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
+			   FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
+			   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
 
 	iwl_write_direct32(trans,
-		FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL), dst_addr);
+			   FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL),
+			   dst_addr);
 
 	iwl_write_direct32(trans,
 		FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
 		phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
 
 	iwl_write_direct32(trans,
-		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
-		(iwl_get_dma_hi_addr(phy_addr)
-			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
+			   FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
+			   (iwl_get_dma_hi_addr(phy_addr)
+				<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
 
 	iwl_write_direct32(trans,
-		FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
-		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
-		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX |
-		FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
+			   FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
+			   1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
+			   1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX |
+			   FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
 
 	iwl_write_direct32(trans,
-		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
-		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
+			   FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
+			   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
+			   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
+			   FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
 	IWL_DEBUG_FW(trans, "[%d] uCode section being loaded...\n",
 		     section_num);
@@ -1068,7 +1062,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
 	iwl_write_prph(trans, SCD_QUEUECHAIN_SEL,
-		SCD_QUEUECHAIN_SEL_ALL(trans, trans_pcie));
+		       SCD_QUEUECHAIN_SEL_ALL(trans, trans_pcie));
 	iwl_write_prph(trans, SCD_AGGR_SEL, 0);
 
 	/* initiate the queues */
@@ -1089,7 +1083,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	}
 
 	iwl_write_prph(trans, SCD_INTERRUPT_MASK,
-			IWL_MASK(0, trans->cfg->base_params->num_of_queues));
+		       IWL_MASK(0, trans->cfg->base_params->num_of_queues));
 
 	/* Activate all Tx DMA/FIFO channels */
 	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
@@ -1113,7 +1107,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 
 	/* Enable L1-Active */
 	iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
-			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+			    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 }
 
 static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans)
@@ -1127,9 +1121,9 @@ static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans)
  */
 static int iwl_trans_tx_stop(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ch, txq_id, ret;
 	unsigned long flags;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	/* Turn off all Tx DMA fifos */
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
@@ -1141,13 +1135,13 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 		iwl_write_direct32(trans,
 				   FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
 		ret = iwl_poll_direct_bit(trans, FH_TSSR_TX_STATUS_REG,
-				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
-				    1000);
+			FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch), 1000);
 		if (ret < 0)
-			IWL_ERR(trans, "Failing on timeout while stopping"
-			    " DMA channel %d [0x%08x]", ch,
-			    iwl_read_direct32(trans,
-					      FH_TSSR_TX_STATUS_REG));
+			IWL_ERR(trans,
+				"Failing on timeout while stopping DMA channel %d [0x%08x]",
+				ch,
+				iwl_read_direct32(trans,
+						  FH_TSSR_TX_STATUS_REG));
 	}
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
@@ -1166,8 +1160,8 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 
 static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 {
-	unsigned long flags;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	unsigned long flags;
 
 	/* tell the device to stop sending interrupts */
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
@@ -1197,7 +1191,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 
 	/* Make sure (redundant) we've released our request to stay awake */
 	iwl_clear_bit(trans, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	/* Stop the device, and put it in low power state */
 	iwl_apm_stop(trans);
@@ -1271,8 +1265,9 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	txq->entries[q->write_ptr].cmd = dev_cmd;
 
 	dev_cmd->hdr.cmd = REPLY_TX;
-	dev_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
-				INDEX_TO_SEQ(q->write_ptr)));
+	dev_cmd->hdr.sequence =
+		cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
+			    INDEX_TO_SEQ(q->write_ptr)));
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_meta = &txq->entries[q->write_ptr].meta;
@@ -1337,7 +1332,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	/* take back ownership of DMA buffer to enable update */
 	dma_sync_single_for_cpu(trans->dev, txcmd_phys, firstlen,
-			DMA_BIDIRECTIONAL);
+				DMA_BIDIRECTIONAL);
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
 
@@ -1349,7 +1344,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	iwl_trans_txq_update_byte_cnt_tbl(trans, txq, le16_to_cpu(tx_cmd->len));
 
 	dma_sync_single_for_device(trans->dev, txcmd_phys, firstlen,
-			DMA_BIDIRECTIONAL);
+				   DMA_BIDIRECTIONAL);
 
 	trace_iwlwifi_dev_tx(trans->dev,
 			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
@@ -1388,8 +1383,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int err;
 	bool hw_rfkill;
 
@@ -1402,7 +1396,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 		iwl_alloc_isr_ict(trans);
 
 		err = request_irq(trans_pcie->irq, iwl_isr_ict, IRQF_SHARED,
-			DRV_NAME, trans);
+				  DRV_NAME, trans);
 		if (err) {
 			IWL_ERR(trans, "Error allocating IRQ %d\n",
 				trans_pcie->irq);
@@ -1440,9 +1434,9 @@ error:
 static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans,
 				   bool op_mode_leaving)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	bool hw_rfkill;
 	unsigned long flags;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	iwl_apm_stop(trans);
 
@@ -1546,8 +1540,7 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 
 void iwl_trans_pcie_free(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	iwl_trans_pcie_tx_free(trans);
 #ifndef CONFIG_IWLWIFI_IDI
@@ -1809,8 +1802,8 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 };
 
 static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
-						char __user *user_buf,
-						size_t count, loff_t *ppos)
+				       char __user *user_buf,
+				       size_t count, loff_t *ppos)
 {
 	struct iwl_trans *trans = file->private_data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -1846,11 +1839,11 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 }
 
 static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
-						char __user *user_buf,
-						size_t count, loff_t *ppos) {
+				       char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
 	struct iwl_trans *trans = file->private_data;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	char buf[256];
 	int pos = 0;
@@ -1874,11 +1867,10 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 
 static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
 					char __user *user_buf,
-					size_t count, loff_t *ppos) {
-
+					size_t count, loff_t *ppos)
+{
 	struct iwl_trans *trans = file->private_data;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
 
 	int pos = 0;
@@ -1936,8 +1928,7 @@ static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
 					 size_t count, loff_t *ppos)
 {
 	struct iwl_trans *trans = file->private_data;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
 
 	char buf[8];
@@ -1957,8 +1948,8 @@ static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
 }
 
 static ssize_t iwl_dbgfs_csr_write(struct file *file,
-					 const char __user *user_buf,
-					 size_t count, loff_t *ppos)
+				   const char __user *user_buf,
+				   size_t count, loff_t *ppos)
 {
 	struct iwl_trans *trans = file->private_data;
 	char buf[8];
@@ -1978,8 +1969,8 @@ static ssize_t iwl_dbgfs_csr_write(struct file *file,
 }
 
 static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
+				     char __user *user_buf,
+				     size_t count, loff_t *ppos)
 {
 	struct iwl_trans *trans = file->private_data;
 	char *buf;
@@ -2022,7 +2013,7 @@ DEBUGFS_WRITE_FILE_OPS(fw_restart);
  *
  */
 static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
-					struct dentry *dir)
+					 struct dentry *dir)
 {
 	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
@@ -2034,9 +2025,10 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 }
 #else
 static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
-					struct dentry *dir)
-{ return 0; }
-
+					 struct dentry *dir)
+{
+	return 0;
+}
 #endif /*CONFIG_IWLWIFI_DEBUGFS */
 
 static const struct iwl_trans_ops trans_ops_pcie = {
@@ -2081,7 +2073,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	int err;
 
 	trans = kzalloc(sizeof(struct iwl_trans) +
-			     sizeof(struct iwl_trans_pcie), GFP_KERNEL);
+			sizeof(struct iwl_trans_pcie), GFP_KERNEL);
 
 	if (WARN_ON(!trans))
 		return NULL;
@@ -2097,7 +2089,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	/* W/A - seems to solve weird behavior. We need to remove this if we
 	 * don't want to stay in L1 all the time. This wastes a lot of power */
 	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
-				PCIE_LINK_STATE_CLKPM);
+			       PCIE_LINK_STATE_CLKPM);
 
 	if (pci_enable_device(pdev)) {
 		err = -ENODEV;
@@ -2113,7 +2105,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (!err)
 			err = pci_set_consistent_dma_mask(pdev,
-							DMA_BIT_MASK(32));
+							  DMA_BIT_MASK(32));
 		/* both attempts failed: */
 		if (err) {
 			dev_printk(KERN_ERR, &pdev->dev,
@@ -2136,13 +2128,13 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	}
 
 	dev_printk(KERN_INFO, &pdev->dev,
-		"pci_resource_len = 0x%08llx\n",
-		(unsigned long long) pci_resource_len(pdev, 0));
+		   "pci_resource_len = 0x%08llx\n",
+		   (unsigned long long) pci_resource_len(pdev, 0));
 	dev_printk(KERN_INFO, &pdev->dev,
-		"pci_resource_base = %p\n", trans_pcie->hw_base);
+		   "pci_resource_base = %p\n", trans_pcie->hw_base);
 
 	dev_printk(KERN_INFO, &pdev->dev,
-		"HW Revision ID = 0x%X\n", pdev->revision);
+		   "HW Revision ID = 0x%X\n", pdev->revision);
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
 	 * PCI Tx retries from interfering with C3 CPU state */
@@ -2151,7 +2143,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	err = pci_enable_msi(pdev);
 	if (err)
 		dev_printk(KERN_ERR, &pdev->dev,
-			"pci_enable_msi failed(0X%x)", err);
+			   "pci_enable_msi failed(0X%x)", err);
 
 	trans->dev = &pdev->dev;
 	trans_pcie->irq = pdev->irq;
@@ -2183,4 +2175,3 @@ out_no_pci:
 	kfree(trans);
 	return NULL;
 }
-
-- 
1.7.10

