Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab0CYUo5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/22] iwlwifi: move agn only rx functions from iwlcore to iwlagn
Date: Thu, 25 Mar 2010 13:44:41 -0700
Message-Id: <1269549890-19195-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Identify the rx functions only used by agn driver and move those from
iwlcore to iwlagn.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |  200 +++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    8 +
 drivers/net/wireless/iwlwifi/iwl-core.h    |    5 -
 drivers/net/wireless/iwlwifi/iwl-rx.c      |  203 ----------------------------
 5 files changed, 213 insertions(+), 215 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 6f9d52d..3117382 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -491,7 +491,7 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 	} else
 		iwlagn_rx_queue_reset(priv, rxq);
 
-	iwl_rx_replenish(priv);
+	iwlagn_rx_replenish(priv);
 
 	iwlagn_rx_init(priv, rxq);
 
@@ -511,3 +511,201 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 
 	return 0;
 }
+
+/**
+ * iwlagn_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
+ */
+static inline __le32 iwlagn_dma_addr2rbd_ptr(struct iwl_priv *priv,
+					  dma_addr_t dma_addr)
+{
+	return cpu_to_le32((u32)(dma_addr >> 8));
+}
+
+/**
+ * iwlagn_rx_queue_restock - refill RX queue from pre-allocated pool
+ *
+ * If there are slots in the RX queue that need to be restocked,
+ * and we have free pre-allocated buffers, fill the ranks as much
+ * as we can, pulling from rx_free.
+ *
+ * This moves the 'write' index forward to catch up with 'processed', and
+ * also updates the memory address in the firmware to reference the new
+ * target buffer.
+ */
+void iwlagn_rx_queue_restock(struct iwl_priv *priv)
+{
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct list_head *element;
+	struct iwl_rx_mem_buffer *rxb;
+	unsigned long flags;
+	int write;
+
+	spin_lock_irqsave(&rxq->lock, flags);
+	write = rxq->write & ~0x7;
+	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+		/* Get next free Rx buffer, remove from free list */
+		element = rxq->rx_free.next;
+		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+		list_del(element);
+
+		/* Point to Rx buffer via next RBD in circular buffer */
+		rxq->bd[rxq->write] = iwlagn_dma_addr2rbd_ptr(priv,
+							      rxb->page_dma);
+		rxq->queue[rxq->write] = rxb;
+		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
+		rxq->free_count--;
+	}
+	spin_unlock_irqrestore(&rxq->lock, flags);
+	/* If the pre-allocated buffer pool is dropping low, schedule to
+	 * refill it */
+	if (rxq->free_count <= RX_LOW_WATERMARK)
+		queue_work(priv->workqueue, &priv->rx_replenish);
+
+
+	/* If we've added more space for the firmware to place data, tell it.
+	 * Increment device's write pointer in multiples of 8. */
+	if (rxq->write_actual != (rxq->write & ~0x7)) {
+		spin_lock_irqsave(&rxq->lock, flags);
+		rxq->need_update = 1;
+		spin_unlock_irqrestore(&rxq->lock, flags);
+		iwl_rx_queue_update_write_ptr(priv, rxq);
+	}
+}
+
+/**
+ * iwlagn_rx_replenish - Move all used packet from rx_used to rx_free
+ *
+ * When moving to rx_free an SKB is allocated for the slot.
+ *
+ * Also restock the Rx queue via iwl_rx_queue_restock.
+ * This is called as a scheduled work item (except for during initialization)
+ */
+void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
+{
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct list_head *element;
+	struct iwl_rx_mem_buffer *rxb;
+	struct page *page;
+	unsigned long flags;
+	gfp_t gfp_mask = priority;
+
+	while (1) {
+		spin_lock_irqsave(&rxq->lock, flags);
+		if (list_empty(&rxq->rx_used)) {
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			return;
+		}
+		spin_unlock_irqrestore(&rxq->lock, flags);
+
+		if (rxq->free_count > RX_LOW_WATERMARK)
+			gfp_mask |= __GFP_NOWARN;
+
+		if (priv->hw_params.rx_page_order > 0)
+			gfp_mask |= __GFP_COMP;
+
+		/* Alloc a new receive buffer */
+		page = alloc_pages(gfp_mask, priv->hw_params.rx_page_order);
+		if (!page) {
+			if (net_ratelimit())
+				IWL_DEBUG_INFO(priv, "alloc_pages failed, "
+					       "order: %d\n",
+					       priv->hw_params.rx_page_order);
+
+			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
+			    net_ratelimit())
+				IWL_CRIT(priv, "Failed to alloc_pages with %s. Only %u free buffers remaining.\n",
+					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
+					 rxq->free_count);
+			/* We don't reschedule replenish work here -- we will
+			 * call the restock method and if it still needs
+			 * more buffers it will schedule replenish */
+			return;
+		}
+
+		spin_lock_irqsave(&rxq->lock, flags);
+
+		if (list_empty(&rxq->rx_used)) {
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			__free_pages(page, priv->hw_params.rx_page_order);
+			return;
+		}
+		element = rxq->rx_used.next;
+		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+		list_del(element);
+
+		spin_unlock_irqrestore(&rxq->lock, flags);
+
+		rxb->page = page;
+		/* Get physical address of the RB */
+		rxb->page_dma = pci_map_page(priv->pci_dev, page, 0,
+				PAGE_SIZE << priv->hw_params.rx_page_order,
+				PCI_DMA_FROMDEVICE);
+		/* dma address must be no more than 36 bits */
+		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
+		/* and also 256 byte aligned! */
+		BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
+
+		spin_lock_irqsave(&rxq->lock, flags);
+
+		list_add_tail(&rxb->list, &rxq->rx_free);
+		rxq->free_count++;
+		priv->alloc_rxb_page++;
+
+		spin_unlock_irqrestore(&rxq->lock, flags);
+	}
+}
+
+void iwlagn_rx_replenish(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	iwlagn_rx_allocate(priv, GFP_KERNEL);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iwlagn_rx_queue_restock(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+void iwlagn_rx_replenish_now(struct iwl_priv *priv)
+{
+	iwlagn_rx_allocate(priv, GFP_ATOMIC);
+
+	iwlagn_rx_queue_restock(priv);
+}
+
+/* Assumes that the skb field of the buffers in 'pool' is kept accurate.
+ * If an SKB has been detached, the POOL needs to have its SKB set to NULL
+ * This free routine walks the list of POOL entries and if SKB is set to
+ * non NULL it is unmapped and freed
+ */
+void iwlagn_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+{
+	int i;
+	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
+		if (rxq->pool[i].page != NULL) {
+			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
+				PAGE_SIZE << priv->hw_params.rx_page_order,
+				PCI_DMA_FROMDEVICE);
+			__iwl_free_pages(priv, rxq->pool[i].page);
+			rxq->pool[i].page = NULL;
+		}
+	}
+
+	dma_free_coherent(&priv->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
+			  rxq->dma_addr);
+	dma_free_coherent(&priv->pci_dev->dev, sizeof(struct iwl_rb_status),
+			  rxq->rb_stts, rxq->rb_stts_dma);
+	rxq->bd = NULL;
+	rxq->rb_stts  = NULL;
+}
+
+int iwlagn_rxq_stop(struct iwl_priv *priv)
+{
+
+	/* stop Rx DMA */
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
+			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a57933b..d9a287b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1015,7 +1015,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 			count++;
 			if (count >= 8) {
 				rxq->read = i;
-				iwl_rx_replenish_now(priv);
+				iwlagn_rx_replenish_now(priv);
 				count = 0;
 			}
 		}
@@ -1024,9 +1024,9 @@ void iwl_rx_handle(struct iwl_priv *priv)
 	/* Backtrack one entry */
 	rxq->read = i;
 	if (fill_rx)
-		iwl_rx_replenish_now(priv);
+		iwlagn_rx_replenish_now(priv);
 	else
-		iwl_rx_queue_restock(priv);
+		iwlagn_rx_queue_restock(priv);
 }
 
 /* call this function to flush any scheduled tasklet */
@@ -2250,7 +2250,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	iwl_disable_ict(priv);
 
 	iwlagn_txq_ctx_stop(priv);
-	iwl_rxq_stop(priv);
+	iwlagn_rxq_stop(priv);
 
 	/* Power-down device's busmaster DMA clocks */
 	iwl_write_prph(priv, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
@@ -2521,7 +2521,7 @@ static void iwl_bg_rx_replenish(struct work_struct *data)
 		return;
 
 	mutex_lock(&priv->mutex);
-	iwl_rx_replenish(priv);
+	iwlagn_rx_replenish(priv);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -3737,7 +3737,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	iwl_dealloc_ucode_pci(priv);
 
 	if (priv->rxq.bd)
-		iwl_rx_queue_free(priv, &priv->rxq);
+		iwlagn_rx_queue_free(priv, &priv->rxq);
 	iwlagn_hw_txq_ctx_free(priv);
 
 	iwl_eeprom_free(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index c75a767..48f7de0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -117,6 +117,14 @@ void iwlagn_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_hw_nic_init(struct iwl_priv *priv);
 
+/* rx */
+void iwlagn_rx_queue_restock(struct iwl_priv *priv);
+void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority);
+void iwlagn_rx_replenish(struct iwl_priv *priv);
+void iwlagn_rx_replenish_now(struct iwl_priv *priv);
+void iwlagn_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
+int iwlagn_rxq_stop(struct iwl_priv *priv);
+
 /* tx */
 int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
 int iwlagn_tx_agg_start(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 446d27b..7c6ac34 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -419,17 +419,12 @@ void iwl_rx_reply_error(struct iwl_priv *priv,
 /*****************************************************
 * RX
 ******************************************************/
-void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 void iwl_cmd_queue_free(struct iwl_priv *priv);
 int iwl_rx_queue_alloc(struct iwl_priv *priv);
 void iwl_rx_handle(struct iwl_priv *priv);
 void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_rx_queue *q);
-void iwl_rx_replenish(struct iwl_priv *priv);
-void iwl_rx_replenish_now(struct iwl_priv *priv);
-void iwl_rx_queue_restock(struct iwl_priv *priv);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
-void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority);
 void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 /* Handlers */
 void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b75c3cc..45230c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -162,197 +162,6 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(iwl_rx_queue_update_write_ptr);
-/**
- * iwl_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
- */
-static inline __le32 iwl_dma_addr2rbd_ptr(struct iwl_priv *priv,
-					  dma_addr_t dma_addr)
-{
-	return cpu_to_le32((u32)(dma_addr >> 8));
-}
-
-/**
- * iwl_rx_queue_restock - refill RX queue from pre-allocated pool
- *
- * If there are slots in the RX queue that need to be restocked,
- * and we have free pre-allocated buffers, fill the ranks as much
- * as we can, pulling from rx_free.
- *
- * This moves the 'write' index forward to catch up with 'processed', and
- * also updates the memory address in the firmware to reference the new
- * target buffer.
- */
-void iwl_rx_queue_restock(struct iwl_priv *priv)
-{
-	struct iwl_rx_queue *rxq = &priv->rxq;
-	struct list_head *element;
-	struct iwl_rx_mem_buffer *rxb;
-	unsigned long flags;
-	int write;
-
-	spin_lock_irqsave(&rxq->lock, flags);
-	write = rxq->write & ~0x7;
-	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
-		/* Get next free Rx buffer, remove from free list */
-		element = rxq->rx_free.next;
-		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
-		list_del(element);
-
-		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] = iwl_dma_addr2rbd_ptr(priv, rxb->page_dma);
-		rxq->queue[rxq->write] = rxb;
-		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
-		rxq->free_count--;
-	}
-	spin_unlock_irqrestore(&rxq->lock, flags);
-	/* If the pre-allocated buffer pool is dropping low, schedule to
-	 * refill it */
-	if (rxq->free_count <= RX_LOW_WATERMARK)
-		queue_work(priv->workqueue, &priv->rx_replenish);
-
-
-	/* If we've added more space for the firmware to place data, tell it.
-	 * Increment device's write pointer in multiples of 8. */
-	if (rxq->write_actual != (rxq->write & ~0x7)) {
-		spin_lock_irqsave(&rxq->lock, flags);
-		rxq->need_update = 1;
-		spin_unlock_irqrestore(&rxq->lock, flags);
-		iwl_rx_queue_update_write_ptr(priv, rxq);
-	}
-}
-EXPORT_SYMBOL(iwl_rx_queue_restock);
-
-
-/**
- * iwl_rx_replenish - Move all used packet from rx_used to rx_free
- *
- * When moving to rx_free an SKB is allocated for the slot.
- *
- * Also restock the Rx queue via iwl_rx_queue_restock.
- * This is called as a scheduled work item (except for during initialization)
- */
-void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
-{
-	struct iwl_rx_queue *rxq = &priv->rxq;
-	struct list_head *element;
-	struct iwl_rx_mem_buffer *rxb;
-	struct page *page;
-	unsigned long flags;
-	gfp_t gfp_mask = priority;
-
-	while (1) {
-		spin_lock_irqsave(&rxq->lock, flags);
-		if (list_empty(&rxq->rx_used)) {
-			spin_unlock_irqrestore(&rxq->lock, flags);
-			return;
-		}
-		spin_unlock_irqrestore(&rxq->lock, flags);
-
-		if (rxq->free_count > RX_LOW_WATERMARK)
-			gfp_mask |= __GFP_NOWARN;
-
-		if (priv->hw_params.rx_page_order > 0)
-			gfp_mask |= __GFP_COMP;
-
-		/* Alloc a new receive buffer */
-		page = alloc_pages(gfp_mask, priv->hw_params.rx_page_order);
-		if (!page) {
-			if (net_ratelimit())
-				IWL_DEBUG_INFO(priv, "alloc_pages failed, "
-					       "order: %d\n",
-					       priv->hw_params.rx_page_order);
-
-			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
-			    net_ratelimit())
-				IWL_CRIT(priv, "Failed to alloc_pages with %s. Only %u free buffers remaining.\n",
-					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
-					 rxq->free_count);
-			/* We don't reschedule replenish work here -- we will
-			 * call the restock method and if it still needs
-			 * more buffers it will schedule replenish */
-			return;
-		}
-
-		spin_lock_irqsave(&rxq->lock, flags);
-
-		if (list_empty(&rxq->rx_used)) {
-			spin_unlock_irqrestore(&rxq->lock, flags);
-			__free_pages(page, priv->hw_params.rx_page_order);
-			return;
-		}
-		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
-		list_del(element);
-
-		spin_unlock_irqrestore(&rxq->lock, flags);
-
-		rxb->page = page;
-		/* Get physical address of the RB */
-		rxb->page_dma = pci_map_page(priv->pci_dev, page, 0,
-				PAGE_SIZE << priv->hw_params.rx_page_order,
-				PCI_DMA_FROMDEVICE);
-		/* dma address must be no more than 36 bits */
-		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
-		/* and also 256 byte aligned! */
-		BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
-
-		spin_lock_irqsave(&rxq->lock, flags);
-
-		list_add_tail(&rxb->list, &rxq->rx_free);
-		rxq->free_count++;
-		priv->alloc_rxb_page++;
-
-		spin_unlock_irqrestore(&rxq->lock, flags);
-	}
-}
-
-void iwl_rx_replenish(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	iwl_rx_allocate(priv, GFP_KERNEL);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_rx_queue_restock(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-EXPORT_SYMBOL(iwl_rx_replenish);
-
-void iwl_rx_replenish_now(struct iwl_priv *priv)
-{
-	iwl_rx_allocate(priv, GFP_ATOMIC);
-
-	iwl_rx_queue_restock(priv);
-}
-EXPORT_SYMBOL(iwl_rx_replenish_now);
-
-
-/* Assumes that the skb field of the buffers in 'pool' is kept accurate.
- * If an SKB has been detached, the POOL needs to have its SKB set to NULL
- * This free routine walks the list of POOL entries and if SKB is set to
- * non NULL it is unmapped and freed
- */
-void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
-{
-	int i;
-	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
-		if (rxq->pool[i].page != NULL) {
-			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
-				PAGE_SIZE << priv->hw_params.rx_page_order,
-				PCI_DMA_FROMDEVICE);
-			__iwl_free_pages(priv, rxq->pool[i].page);
-			rxq->pool[i].page = NULL;
-		}
-	}
-
-	dma_free_coherent(&priv->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			  rxq->dma_addr);
-	dma_free_coherent(&priv->pci_dev->dev, sizeof(struct iwl_rb_status),
-			  rxq->rb_stts, rxq->rb_stts_dma);
-	rxq->bd = NULL;
-	rxq->rb_stts  = NULL;
-}
-EXPORT_SYMBOL(iwl_rx_queue_free);
 
 int iwl_rx_queue_alloc(struct iwl_priv *priv)
 {
@@ -395,18 +204,6 @@ err_bd:
 }
 EXPORT_SYMBOL(iwl_rx_queue_alloc);
 
-int iwl_rxq_stop(struct iwl_priv *priv)
-{
-
-	/* stop Rx DMA */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
-			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
-
-	return 0;
-}
-EXPORT_SYMBOL(iwl_rxq_stop);
-
 void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 
-- 
1.6.3.3

