Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:58048 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab3LaRQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:18 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so5531740eaj.21
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:17 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/28] iwlwifi: pcie: use don't disable interrupt when rxq->lock is taken
Date: Tue, 31 Dec 2013 19:15:40 +0200
Message-Id: <1388510157-23345-11-git-send-email-egrumbach@gmail.com> (sfid-20131231_183437_428092_67448EFF)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This lock was never acquired in the primary interrupt
handler, but since it was acquired along with irq_lock
which had to disable interrupts, rxq->lock had to disable
interrupts too.
Now that trans_pcie->irq_lock isn't acquired in the primary
interrupt handler, rxq->lock can let interrupt enabled.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |   50 ++++++++++++++------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 7ab510e..e06a3fe 100644
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
 
@@ -510,7 +507,6 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
 	int i, err;
-	unsigned long flags;
 
 	if (!rxq->bd) {
 		err = iwl_pcie_rx_alloc(trans);
@@ -518,7 +514,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 			return err;
 	}
 
-	spin_lock_irqsave(&rxq->lock, flags);
+	spin_lock(&rxq->lock);
 
 	INIT_WORK(&trans_pcie->rx_replenish, iwl_pcie_rx_replenish_work);
 
@@ -534,7 +530,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	rxq->read = rxq->write = 0;
 	rxq->write_actual = 0;
 	memset(rxq->rb_stts, 0, sizeof(*rxq->rb_stts));
-	spin_unlock_irqrestore(&rxq->lock, flags);
+	spin_unlock(&rxq->lock);
 
 	iwl_pcie_rx_replenish(trans);
 
@@ -552,7 +548,6 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
-	unsigned long flags;
 
 	/*if rxq->bd is NULL, it means that nothing has been allocated,
 	 * exit now */
@@ -563,9 +558,9 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 
 	cancel_work_sync(&trans_pcie->rx_replenish);
 
-	spin_lock_irqsave(&rxq->lock, flags);
+	spin_lock(&rxq->lock);
 	iwl_pcie_rxq_free_rbs(trans);
-	spin_unlock_irqrestore(&rxq->lock, flags);
+	spin_unlock(&rxq->lock);
 
 	dma_free_coherent(trans->dev, sizeof(__le32) * RX_QUEUE_SIZE,
 			  rxq->bd, rxq->bd_dma);
@@ -588,7 +583,6 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
 	struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
-	unsigned long flags;
 	bool page_stolen = false;
 	int max_len = PAGE_SIZE << trans_pcie->rx_page_order;
 	u32 offset = 0;
@@ -690,7 +684,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 	/* Reuse the page if possible. For notification packets and
 	 * SKBs that fail to Rx correctly, add them back into the
 	 * rx_free list for reuse later. */
-	spin_lock_irqsave(&rxq->lock, flags);
+	spin_lock(&rxq->lock);
 	if (rxb->page != NULL) {
 		rxb->page_dma =
 			dma_map_page(trans->dev, rxb->page, 0,
@@ -711,7 +705,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		}
 	} else
 		list_add_tail(&rxb->list, &rxq->rx_used);
-	spin_unlock_irqrestore(&rxq->lock, flags);
+	spin_unlock(&rxq->lock);
 }
 
 /*
-- 
1.7.9.5

