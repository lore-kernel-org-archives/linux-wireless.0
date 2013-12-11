Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20040 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab3LKIfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 03:35:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 10/10] iwlwifi: pcie: stop using _irqsave
Date: Wed, 11 Dec 2013 10:33:46 +0200
Message-Id: <1386750826-25219-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131211_093520_315168_0FECED46)
In-Reply-To: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we don't take any locks in the upper half any more,
we don't need _irqsave in any place.

Change-Id: I33b33edb063b3b55fb2a50bdb607e0b2ca8cde37
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c    | 76 ++++++++++++++-----------------
 drivers/net/wireless/iwlwifi/pcie/trans.c | 23 ++++------
 drivers/net/wireless/iwlwifi/pcie/tx.c    | 10 ++--
 3 files changed, 47 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index f25e6bb..02b8747 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -148,10 +148,9 @@ int iwl_pcie_rx_stop(struct iwl_trans *trans)
 static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 				    struct iwl_rxq *rxq)
 {
-	unsigned long flags;
 	u32 reg;
 
-	spin_lock_irqsave(&rxq->lock, flags);
+	spin_lock(&rxq->lock);
 
 	if (rxq->need_update == 0)
 		goto exit_unlock;
@@ -190,7 +189,7 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 	rxq->need_update = 0;
 
  exit_unlock:
-	spin_unlock_irqrestore(&rxq->lock, flags);
+	spin_unlock(&rxq->lock);
 }
 
 /*
@@ -209,7 +208,6 @@ static void iwl_pcie_rxq_restock(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
 	struct iwl_rx_mem_buffer *rxb;
-	unsigned long flags;
 
 	/*
 	 * If the device isn't enabled - not need to try to add buffers...
@@ -222,7 +220,7 @@ static void iwl_pcie_rxq_restock(struct iwl_trans *trans)
 	if (!test_bit(STATUS_DEVICE_ENABLED, &trans->status))
 		return;
 
-	spin_lock_irqsave(&rxq->lock, flags);
+	spin_lock(&rxq->lock);
 	while ((iwl_rxq_space(rxq) > 0) && (rxq->free_count)) {
 		/* The overwritten rxb must be a used one */
 		rxb = rxq->queue[rxq->write];
@@ -239,7 +237,7 @@ static void iwl_pcie_rxq_restock(struct iwl_trans *trans)
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
 		rxq->free_count--;
 	}
-	spin_unlock_irqrestore(&rxq->lock, flags);
+	spin_unlock(&rxq->lock);
 	/* If the pre-allocated buffer pool is dropping low, schedule to
 	 * refill it */
 	if (rxq->free_count <= RX_LOW_WATERMARK)
@@ -248,9 +246,9 @@ static void iwl_pcie_rxq_restock(struct iwl_trans *trans)
 	/* If we've added more space for the firmware to place data, tell it.
 	 * Increment device's write pointer in multiples of 8. */
 	if (rxq->write_actual != (rxq->write & ~0x7)) {
-		spin_lock_irqsave(&rxq->lock, flags);
+		spin_lock(&rxq->lock);
 		rxq->need_update = 1;
-		spin_unlock_irqrestore(&rxq->lock, flags);
+		spin_unlock(&rxq->lock);
 		iwl_pcie_rxq_inc_wr_ptr(trans, rxq);
 	}
 }
@@ -270,16 +268,15 @@ static void iwl_pcie_rxq_alloc_rbs(struct iwl_trans *trans, gfp_t priority)
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
 	struct iwl_rx_mem_buffer *rxb;
 	struct page *page;
-	unsigned long flags;
 	gfp_t gfp_mask = priority;
 
 	while (1) {
-		spin_lock_irqsave(&rxq->lock, flags);
+		spin_lock(&rxq->lock);
 		if (list_empty(&rxq->rx_used)) {
-			spin_unlock_irqrestore(&rxq->lock, flags);
+			spin_unlock(&rxq->lock);
 			return;
 		}
-		spin_unlock_irqrestore(&rxq->lock, flags);
+		spin_unlock(&rxq->lock);
 
 		if (rxq->free_count > RX_LOW_WATERMARK)
 			gfp_mask |= __GFP_NOWARN;
@@ -308,17 +305,17 @@ static void iwl_pcie_rxq_alloc_rbs(struct iwl_trans *trans, gfp_t priority)
 			return;
 		}
 
-		spin_lock_irqsave(&rxq->lock, flags);
+		spin_lock(&rxq->lock);
 
 		if (list_empty(&rxq->rx_used)) {
-			spin_unlock_irqrestore(&rxq->lock, flags);
+			spin_unlock(&rxq->lock);
 			__free_pages(page, trans_pcie->rx_page_order);
 			return;
 		}
 		rxb = list_first_entry(&rxq->rx_used, struct iwl_rx_mem_buffer,
 				       list);
 		list_del(&rxb->list);
-		spin_unlock_irqrestore(&rxq->lock, flags);
+		spin_unlock(&rxq->lock);
 
 		BUG_ON(rxb->page);
 		rxb->page = page;
@@ -329,9 +326,9 @@ static void iwl_pcie_rxq_alloc_rbs(struct iwl_trans *trans, gfp_t priority)
 				     DMA_FROM_DEVICE);
 		if (dma_mapping_error(trans->dev, rxb->page_dma)) {
 			rxb->page = NULL;
-			spin_lock_irqsave(&rxq->lock, flags);
+			spin_lock(&rxq->lock);
 			list_add(&rxb->list, &rxq->rx_used);
-			spin_unlock_irqrestore(&rxq->lock, flags);
+			spin_unlock(&rxq->lock);
 			__free_pages(page, trans_pcie->rx_page_order);
 			return;
 		}
@@ -340,12 +337,12 @@ static void iwl_pcie_rxq_alloc_rbs(struct iwl_trans *trans, gfp_t priority)
 		/* and also 256 byte aligned! */
 		BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
 
-		spin_lock_irqsave(&rxq->lock, flags);
+		spin_lock(&rxq->lock);
 
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
 
-		spin_unlock_irqrestore(&rxq->lock, flags);
+		spin_unlock(&rxq->lock);
 	}
 }
 
@@ -379,13 +376,12 @@ static void iwl_pcie_rxq_free_rbs(struct iwl_trans *trans)
 static void iwl_pcie_rx_replenish(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 
 	iwl_pcie_rxq_alloc_rbs(trans, GFP_KERNEL);
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_pcie_rxq_restock(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 }
 
 static void iwl_pcie_rx_replenish_now(struct iwl_trans *trans)
@@ -511,7 +507,6 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
 	int i, err;
-	unsigned long flags;
 
 	if (!rxq->bd) {
 		err = iwl_pcie_rx_alloc(trans);
@@ -519,7 +514,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 			return err;
 	}
 
-	spin_lock_irqsave(&rxq->lock, flags);
+	spin_lock(&rxq->lock);
 
 	INIT_WORK(&trans_pcie->rx_replenish, iwl_pcie_rx_replenish_work);
 
@@ -535,16 +530,16 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	rxq->read = rxq->write = 0;
 	rxq->write_actual = 0;
 	memset(rxq->rb_stts, 0, sizeof(*rxq->rb_stts));
-	spin_unlock_irqrestore(&rxq->lock, flags);
+	spin_unlock(&rxq->lock);
 
 	iwl_pcie_rx_replenish(trans);
 
 	iwl_pcie_rx_hw_init(trans, rxq);
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	rxq->need_update = 1;
 	iwl_pcie_rxq_inc_wr_ptr(trans, rxq);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	return 0;
 }
@@ -553,7 +548,6 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
-	unsigned long flags;
 
 	/*if rxq->bd is NULL, it means that nothing has been allocated,
 	 * exit now */
@@ -564,9 +558,9 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 
 	cancel_work_sync(&trans_pcie->rx_replenish);
 
-	spin_lock_irqsave(&rxq->lock, flags);
+	spin_lock(&rxq->lock);
 	iwl_pcie_rxq_free_rbs(trans);
-	spin_unlock_irqrestore(&rxq->lock, flags);
+	spin_unlock(&rxq->lock);
 
 	dma_free_coherent(trans->dev, sizeof(__le32) * RX_QUEUE_SIZE,
 			  rxq->bd, rxq->bd_dma);
@@ -589,7 +583,6 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
 	struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
-	unsigned long flags;
 	bool page_stolen = false;
 	int max_len = PAGE_SIZE << trans_pcie->rx_page_order;
 	u32 offset = 0;
@@ -691,7 +684,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 	/* Reuse the page if possible. For notification packets and
 	 * SKBs that fail to Rx correctly, add them back into the
 	 * rx_free list for reuse later. */
-	spin_lock_irqsave(&rxq->lock, flags);
+	spin_lock(&rxq->lock);
 	if (rxb->page != NULL) {
 		rxb->page_dma =
 			dma_map_page(trans->dev, rxb->page, 0,
@@ -712,7 +705,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		}
 	} else
 		list_add_tail(&rxb->list, &rxq->rx_used);
-	spin_unlock_irqrestore(&rxq->lock, flags);
+	spin_unlock(&rxq->lock);
 }
 
 /*
@@ -895,12 +888,11 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
 	u32 inta = 0;
 	u32 handled = 0;
-	unsigned long flags;
 	u32 i;
 
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 
 	/* dram interrupt table not set yet,
 	 * use legacy interrupt.
@@ -934,7 +926,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		/* Re-enable interrupts here since we don't have anything to service */
 		if (test_bit(STATUS_INT_ENABLED, &trans->status))
 			iwl_enable_interrupts(trans);
-		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+		spin_unlock(&trans_pcie->irq_lock);
 		return IRQ_NONE;
 	}
 
@@ -960,7 +952,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n",
 			      inta, iwl_read32(trans, CSR_INT_MASK));
 
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
@@ -1185,12 +1177,11 @@ void iwl_pcie_reset_ict(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 val;
-	unsigned long flags;
 
 	if (!trans_pcie->ict_tbl)
 		return;
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
 
 	memset(trans_pcie->ict_tbl, 0, ICT_SIZE);
@@ -1207,18 +1198,17 @@ void iwl_pcie_reset_ict(struct iwl_trans *trans)
 	trans_pcie->ict_index = 0;
 	iwl_write32(trans, CSR_INT, trans_pcie->inta_mask);
 	iwl_enable_interrupts(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 }
 
 /* Device is going down disable ict interrupt usage */
 void iwl_pcie_disable_ict(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	trans_pcie->use_ict = false;
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 }
 
 irqreturn_t iwl_pcie_isr(int irq, void *data)
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index af3ec74..67ea0b1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -271,13 +271,12 @@ static void iwl_pcie_apm_stop(struct iwl_trans *trans)
 static int iwl_pcie_nic_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 
 	/* nic_init */
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_pcie_apm_init(trans);
 
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	iwl_pcie_set_pwr(trans, false);
 
@@ -635,13 +634,12 @@ static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans, u32 scd_addr)
 static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 	bool hw_rfkill;
 
 	/* tell the device to stop sending interrupts */
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	/* device going down, Stop using ICT table */
 	iwl_pcie_disable_ict(trans);
@@ -673,9 +671,9 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	/* Upon stop, the APM issues an interrupt if HW RF kill is set.
 	 * Clean again the interrupt here
 	 */
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	/* stop and reset the on-board processor */
 	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
@@ -821,18 +819,17 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 static void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 
 	/* disable interrupts - don't enable HW RF kill interrupt */
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	iwl_pcie_apm_stop(trans);
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	iwl_pcie_disable_ict(trans);
 }
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 049e474..127088e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -742,10 +742,9 @@ int iwl_pcie_tx_stop(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ch, txq_id, ret;
-	unsigned long flags;
 
 	/* Turn off all Tx DMA fifos */
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 
 	iwl_pcie_txq_set_sched(trans, 0);
 
@@ -762,7 +761,7 @@ int iwl_pcie_tx_stop(struct iwl_trans *trans)
 				iwl_read_direct32(trans,
 						  FH_TSSR_TX_STATUS_REG));
 	}
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	if (!trans_pcie->txq) {
 		IWL_WARN(trans,
@@ -870,7 +869,6 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
 	int txq_id, slots_num;
-	unsigned long flags;
 	bool alloc = false;
 
 	if (!trans_pcie->txq) {
@@ -880,7 +878,7 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 		alloc = true;
 	}
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 
 	/* Turn off all Tx DMA fifos */
 	iwl_write_prph(trans, SCD_TXFACT, 0);
@@ -889,7 +887,7 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	iwl_write_direct32(trans, FH_KW_MEM_ADDR_REG,
 			   trans_pcie->kw.dma >> 4);
 
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
-- 
1.8.3.2

