Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1HMSSo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/60] iwlagn: iwl_rx_queue moves to the iwl_trans_pcie
Date: Sat, 13 Aug 2011 10:37:55 -0700
Message-Id: <1313257116-2697-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_204257_616006_20B8F804)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since this struct is specific to pcie transport, move it the the pcie
specific transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   44 +--------
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    8 ++
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   49 +++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |  114 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans.c          |  109 ++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    4 +-
 6 files changed, 184 insertions(+), 144 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6e28602..170e310 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -90,14 +90,6 @@ struct iwl_tx_queue;
 #define	DEFAULT_SHORT_RETRY_LIMIT 7U
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
-struct iwl_rx_mem_buffer {
-	dma_addr_t page_dma;
-	struct page *page;
-	struct list_head list;
-};
-
-#define rxb_addr(r) page_address(r->page)
-
 /* defined below */
 struct iwl_device_cmd;
 
@@ -334,38 +326,6 @@ struct iwl_host_cmd {
 #define SUP_RATE_11B_MAX_NUM_CHANNELS  4
 #define SUP_RATE_11G_MAX_NUM_CHANNELS  12
 
-/**
- * struct iwl_rx_queue - Rx queue
- * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
- * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
- * @read: Shared index to newest available Rx buffer
- * @write: Shared index to oldest written Rx packet
- * @free_count: Number of pre-allocated buffers in rx_free
- * @rx_free: list of free SKBs for use
- * @rx_used: List of Rx buffers with no SKB
- * @need_update: flag to indicate we need to update read/write index
- * @rb_stts: driver's pointer to receive buffer status
- * @rb_stts_dma: bus address of receive buffer status
- *
- * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
- */
-struct iwl_rx_queue {
-	__le32 *bd;
-	dma_addr_t bd_dma;
-	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
-	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
-	u32 read;
-	u32 write;
-	u32 free_count;
-	u32 write_actual;
-	struct list_head rx_free;
-	struct list_head rx_used;
-	int need_update;
-	struct iwl_rb_status *rb_stts;
-	dma_addr_t rb_stts_dma;
-	spinlock_t lock;
-};
-
 #define IWL_SUPPORTED_RATES_IE_LEN         8
 
 #define MAX_TID_COUNT        9
@@ -1288,8 +1248,7 @@ struct iwl_priv {
 
 	int activity_timer_active;
 
-	/* Rx and Tx DMA processing queues */
-	struct iwl_rx_queue rxq;
+	/* Tx DMA processing queues */
 	struct iwl_tx_queue *txq;
 	unsigned long txq_ctx_active_msk;
 	struct iwl_dma_ptr  kw;	/* keep warm address */
@@ -1428,7 +1387,6 @@ struct iwl_priv {
 
 	struct work_struct restart;
 	struct work_struct scan_completed;
-	struct work_struct rx_replenish;
 	struct work_struct abort_scan;
 
 	struct work_struct beacon_update;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 467cfaa..539b76b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -205,6 +205,14 @@ static inline u32 iwl_get_debug_level(struct iwl_shared *shrd)
 }
 #endif
 
+struct iwl_rx_mem_buffer {
+	dma_addr_t page_dma;
+	struct page *page;
+	struct list_head list;
+};
+
+#define rxb_addr(r) page_address(r->page)
+
 #ifdef CONFIG_PM
 int iwl_suspend(struct iwl_priv *priv);
 int iwl_resume(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index 2bc421b..1d80515 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -33,18 +33,63 @@
  * trans_pcie layer */
 
 /**
+ * struct iwl_rx_queue - Rx queue
+ * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
+ * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
+ * @pool:
+ * @queue:
+ * @read: Shared index to newest available Rx buffer
+ * @write: Shared index to oldest written Rx packet
+ * @free_count: Number of pre-allocated buffers in rx_free
+ * @write_actual:
+ * @rx_free: list of free SKBs for use
+ * @rx_used: List of Rx buffers with no SKB
+ * @need_update: flag to indicate we need to update read/write index
+ * @rb_stts: driver's pointer to receive buffer status
+ * @rb_stts_dma: bus address of receive buffer status
+ * @lock:
+ *
+ * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
+ */
+struct iwl_rx_queue {
+	__le32 *bd;
+	dma_addr_t bd_dma;
+	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
+	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
+	u32 read;
+	u32 write;
+	u32 free_count;
+	u32 write_actual;
+	struct list_head rx_free;
+	struct list_head rx_used;
+	int need_update;
+	struct iwl_rb_status *rb_stts;
+	dma_addr_t rb_stts_dma;
+	spinlock_t lock;
+};
+
+/**
  * struct iwl_trans_pcie - PCIe transport specific data
+ * @rxq: all the RX queue data
+ * @rx_replenish: work that will be called when buffers need to be allocated
+ * @trans: pointer to the generic transport area
  */
 struct iwl_trans_pcie {
+	struct iwl_rx_queue rxq;
+	struct work_struct rx_replenish;
+	struct iwl_trans *trans;
 };
 
+#define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
+	((struct iwl_trans_pcie *) ((_iwl_trans)->trans_specific))
+
 /*****************************************************
 * RX
 ******************************************************/
 void iwl_bg_rx_replenish(struct work_struct *data);
 void iwl_irq_tasklet(struct iwl_priv *priv);
-void iwlagn_rx_replenish(struct iwl_priv *priv);
-void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
+void iwlagn_rx_replenish(struct iwl_trans *trans);
+void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 			struct iwl_rx_queue *q);
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 6f5edf7..fb06acf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -127,9 +127,10 @@ static int iwl_rx_queue_space(const struct iwl_rx_queue *q)
 /**
  * iwl_rx_queue_update_write_ptr - Update the write pointer for the RX queue
  */
-void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
+void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 			struct iwl_rx_queue *q)
 {
+	struct iwl_priv *priv = priv(trans);
 	unsigned long flags;
 	u32 reg;
 
@@ -145,11 +146,11 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write_actual);
 	} else {
 		/* If power-saving is in use, make sure device is awake */
-		if (test_bit(STATUS_POWER_PMI, &priv->shrd->status)) {
+		if (test_bit(STATUS_POWER_PMI, &trans->shrd->status)) {
 			reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
 
 			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-				IWL_DEBUG_INFO(priv,
+				IWL_DEBUG_INFO(trans,
 					"Rx queue requesting wakeup,"
 					" GP1 = 0x%x\n", reg);
 				iwl_set_bit(priv, CSR_GP_CNTRL,
@@ -178,8 +179,7 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 /**
  * iwlagn_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
  */
-static inline __le32 iwlagn_dma_addr2rbd_ptr(struct iwl_priv *priv,
-					  dma_addr_t dma_addr)
+static inline __le32 iwlagn_dma_addr2rbd_ptr(dma_addr_t dma_addr)
 {
 	return cpu_to_le32((u32)(dma_addr >> 8));
 }
@@ -195,9 +195,12 @@ static inline __le32 iwlagn_dma_addr2rbd_ptr(struct iwl_priv *priv,
  * also updates the memory address in the firmware to reference the new
  * target buffer.
  */
-static void iwlagn_rx_queue_restock(struct iwl_priv *priv)
+static void iwlagn_rx_queue_restock(struct iwl_trans *trans)
 {
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
@@ -214,8 +217,7 @@ static void iwlagn_rx_queue_restock(struct iwl_priv *priv)
 		list_del(element);
 
 		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] = iwlagn_dma_addr2rbd_ptr(priv,
-							      rxb->page_dma);
+		rxq->bd[rxq->write] = iwlagn_dma_addr2rbd_ptr(rxb->page_dma);
 		rxq->queue[rxq->write] = rxb;
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
 		rxq->free_count--;
@@ -224,7 +226,7 @@ static void iwlagn_rx_queue_restock(struct iwl_priv *priv)
 	/* If the pre-allocated buffer pool is dropping low, schedule to
 	 * refill it */
 	if (rxq->free_count <= RX_LOW_WATERMARK)
-		queue_work(priv->shrd->workqueue, &priv->rx_replenish);
+		queue_work(trans->shrd->workqueue, &trans_pcie->rx_replenish);
 
 
 	/* If we've added more space for the firmware to place data, tell it.
@@ -233,7 +235,7 @@ static void iwlagn_rx_queue_restock(struct iwl_priv *priv)
 		spin_lock_irqsave(&rxq->lock, flags);
 		rxq->need_update = 1;
 		spin_unlock_irqrestore(&rxq->lock, flags);
-		iwl_rx_queue_update_write_ptr(priv, rxq);
+		iwl_rx_queue_update_write_ptr(trans, rxq);
 	}
 }
 
@@ -245,9 +247,12 @@ static void iwlagn_rx_queue_restock(struct iwl_priv *priv)
  * Also restock the Rx queue via iwl_rx_queue_restock.
  * This is called as a scheduled work item (except for during initialization)
  */
-static void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
+static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 {
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
 	struct page *page;
@@ -265,21 +270,21 @@ static void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		if (rxq->free_count > RX_LOW_WATERMARK)
 			gfp_mask |= __GFP_NOWARN;
 
-		if (hw_params(priv).rx_page_order > 0)
+		if (hw_params(trans).rx_page_order > 0)
 			gfp_mask |= __GFP_COMP;
 
 		/* Alloc a new receive buffer */
 		page = alloc_pages(gfp_mask,
-				  hw_params(priv).rx_page_order);
+				  hw_params(trans).rx_page_order);
 		if (!page) {
 			if (net_ratelimit())
-				IWL_DEBUG_INFO(priv, "alloc_pages failed, "
+				IWL_DEBUG_INFO(trans, "alloc_pages failed, "
 					   "order: %d\n",
-					   hw_params(priv).rx_page_order);
+					   hw_params(trans).rx_page_order);
 
 			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
 			    net_ratelimit())
-				IWL_CRIT(priv, "Failed to alloc_pages with %s."
+				IWL_CRIT(trans, "Failed to alloc_pages with %s."
 					 "Only %u free buffers remaining.\n",
 					 priority == GFP_ATOMIC ?
 					 "GFP_ATOMIC" : "GFP_KERNEL",
@@ -294,7 +299,7 @@ static void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 
 		if (list_empty(&rxq->rx_used)) {
 			spin_unlock_irqrestore(&rxq->lock, flags);
-			__free_pages(page, hw_params(priv).rx_page_order);
+			__free_pages(page, hw_params(trans).rx_page_order);
 			return;
 		}
 		element = rxq->rx_used.next;
@@ -306,8 +311,8 @@ static void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		BUG_ON(rxb->page);
 		rxb->page = page;
 		/* Get physical address of the RB */
-		rxb->page_dma = dma_map_page(priv->bus->dev, page, 0,
-				PAGE_SIZE << hw_params(priv).rx_page_order,
+		rxb->page_dma = dma_map_page(bus(trans)->dev, page, 0,
+				PAGE_SIZE << hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
 		/* dma address must be no more than 36 bits */
 		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
@@ -323,35 +328,36 @@ static void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 	}
 }
 
-void iwlagn_rx_replenish(struct iwl_priv *priv)
+void iwlagn_rx_replenish(struct iwl_trans *trans)
 {
 	unsigned long flags;
 
-	iwlagn_rx_allocate(priv, GFP_KERNEL);
+	iwlagn_rx_allocate(trans, GFP_KERNEL);
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
-	iwlagn_rx_queue_restock(priv);
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+	iwlagn_rx_queue_restock(trans);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 }
 
-static void iwlagn_rx_replenish_now(struct iwl_priv *priv)
+static void iwlagn_rx_replenish_now(struct iwl_trans *trans)
 {
-	iwlagn_rx_allocate(priv, GFP_ATOMIC);
+	iwlagn_rx_allocate(trans, GFP_ATOMIC);
 
-	iwlagn_rx_queue_restock(priv);
+	iwlagn_rx_queue_restock(trans);
 }
 
 void iwl_bg_rx_replenish(struct work_struct *data)
 {
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, rx_replenish);
+	struct iwl_trans_pcie *trans_pcie =
+	    container_of(data, struct iwl_trans_pcie, rx_replenish);
+	struct iwl_trans *trans = trans_pcie->trans;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &trans->shrd->status))
 		return;
 
-	mutex_lock(&priv->shrd->mutex);
-	iwlagn_rx_replenish(priv);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_lock(&trans->shrd->mutex);
+	iwlagn_rx_replenish(trans);
+	mutex_unlock(&trans->shrd->mutex);
 }
 
 /**
@@ -361,11 +367,13 @@ void iwl_bg_rx_replenish(struct work_struct *data)
  * the appropriate handlers, including command responses,
  * frame-received notifications, and other notifications.
  */
-static void iwl_rx_handle(struct iwl_priv *priv)
+static void iwl_rx_handle(struct iwl_trans *trans)
 {
 	struct iwl_rx_mem_buffer *rxb;
 	struct iwl_rx_packet *pkt;
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	u32 r, i;
 	int reclaim;
 	unsigned long flags;
@@ -380,7 +388,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
-		IWL_DEBUG_RX(priv, "r = %d, i = %d\n", r, i);
+		IWL_DEBUG_RX(trans, "r = %d, i = %d\n", r, i);
 
 	/* calculate total frames need to be restock after handling RX */
 	total_empty = r - rxq->write_actual;
@@ -405,17 +413,17 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 
 		rxq->queue[i] = NULL;
 
-		dma_unmap_page(priv->bus->dev, rxb->page_dma,
-			       PAGE_SIZE << hw_params(priv).rx_page_order,
+		dma_unmap_page(bus(trans)->dev, rxb->page_dma,
+			       PAGE_SIZE << hw_params(trans).rx_page_order,
 			       DMA_FROM_DEVICE);
 		pkt = rxb_addr(rxb);
 
-		IWL_DEBUG_RX(priv, "r = %d, i = %d, %s, 0x%02x\n", r,
+		IWL_DEBUG_RX(trans, "r = %d, i = %d, %s, 0x%02x\n", r,
 			i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 
 		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 		len += sizeof(u32); /* account for status word */
-		trace_iwlwifi_dev_rx(priv, pkt, len);
+		trace_iwlwifi_dev_rx(priv(trans), pkt, len);
 
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
@@ -431,7 +439,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
 			(pkt->hdr.cmd != REPLY_TX);
 
-		iwl_rx_dispatch(priv, rxb);
+		iwl_rx_dispatch(priv(trans), rxb);
 
 		/*
 		 * XXX: After here, we should always check rxb->page
@@ -446,9 +454,9 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 			 * iwl_trans_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb->page)
-				iwl_tx_cmd_complete(priv, rxb);
+				iwl_tx_cmd_complete(priv(trans), rxb);
 			else
-				IWL_WARN(priv, "Claim null rxb?\n");
+				IWL_WARN(trans, "Claim null rxb?\n");
 		}
 
 		/* Reuse the page if possible. For notification packets and
@@ -456,9 +464,9 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		 * rx_free list for reuse later. */
 		spin_lock_irqsave(&rxq->lock, flags);
 		if (rxb->page != NULL) {
-			rxb->page_dma = dma_map_page(priv->bus->dev, rxb->page,
+			rxb->page_dma = dma_map_page(bus(trans)->dev, rxb->page,
 				0, PAGE_SIZE <<
-				    hw_params(priv).rx_page_order,
+				    hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
 			list_add_tail(&rxb->list, &rxq->rx_free);
 			rxq->free_count++;
@@ -474,7 +482,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 			count++;
 			if (count >= 8) {
 				rxq->read = i;
-				iwlagn_rx_replenish_now(priv);
+				iwlagn_rx_replenish_now(trans);
 				count = 0;
 			}
 		}
@@ -483,9 +491,9 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 	/* Backtrack one entry */
 	rxq->read = i;
 	if (fill_rx)
-		iwlagn_rx_replenish_now(priv);
+		iwlagn_rx_replenish_now(trans);
 	else
-		iwlagn_rx_queue_restock(priv);
+		iwlagn_rx_queue_restock(trans);
 }
 
 /* tasklet for iwlagn interrupt */
@@ -611,8 +619,10 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 
 	/* uCode wakes up after power-down sleep */
 	if (inta & CSR_INT_BIT_WAKEUP) {
+		struct iwl_trans_pcie *trans_pcie =
+			IWL_TRANS_GET_PCIE_TRANS(trans(priv));
 		IWL_DEBUG_ISR(priv, "Wakeup interrupt\n");
-		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
+		iwl_rx_queue_update_write_ptr(trans(priv), &trans_pcie->rxq);
 		for (i = 0; i < hw_params(priv).max_txq_num; i++)
 			iwl_txq_update_write_ptr(priv, &priv->txq[i]);
 
@@ -650,7 +660,7 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 		/* Disable periodic interrupt; we use it as just a one-shot. */
 		iwl_write8(priv, CSR_INT_PERIODIC_REG,
 			    CSR_INT_PERIODIC_DIS);
-		iwl_rx_handle(priv);
+		iwl_rx_handle(trans(priv));
 
 		/*
 		 * Enable periodic interrupt in 8 msec only if we received
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index eeeb130..95d7b04 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -73,12 +73,14 @@
 #include "iwl-core.h"
 #include "iwl-shared.h"
 
-static int iwl_trans_rx_alloc(struct iwl_priv *priv)
+static int iwl_trans_rx_alloc(struct iwl_trans *trans)
 {
-	struct iwl_rx_queue *rxq = &priv->rxq;
-	struct device *dev = priv->bus->dev;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+	struct device *dev = bus(trans)->dev;
 
-	memset(&priv->rxq, 0, sizeof(priv->rxq));
+	memset(&trans_pcie->rxq, 0, sizeof(trans_pcie->rxq));
 
 	spin_lock_init(&rxq->lock);
 	INIT_LIST_HEAD(&rxq->rx_free);
@@ -112,9 +114,11 @@ err_bd:
 	return -ENOMEM;
 }
 
-static void iwl_trans_rxq_free_rx_bufs(struct iwl_priv *priv)
+static void iwl_trans_rxq_free_rx_bufs(struct iwl_trans *trans)
 {
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	int i;
 
 	/* Fill the rx_used queue with _all_ of the Rx buffers */
@@ -122,10 +126,10 @@ static void iwl_trans_rxq_free_rx_bufs(struct iwl_priv *priv)
 		/* In the reset function, these buffers may have been allocated
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].page != NULL) {
-			dma_unmap_page(priv->bus->dev, rxq->pool[i].page_dma,
-				PAGE_SIZE << hw_params(priv).rx_page_order,
+			dma_unmap_page(bus(trans)->dev, rxq->pool[i].page_dma,
+				PAGE_SIZE << hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
-			__iwl_free_pages(priv, rxq->pool[i].page);
+			__iwl_free_pages(priv(trans), rxq->pool[i].page);
 			rxq->pool[i].page = NULL;
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
@@ -181,14 +185,17 @@ static void iwl_trans_rx_hw_init(struct iwl_priv *priv,
 	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
 }
 
-static int iwl_rx_init(struct iwl_priv *priv)
+static int iwl_rx_init(struct iwl_trans *trans)
 {
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+
 	int i, err;
 	unsigned long flags;
 
 	if (!rxq->bd) {
-		err = iwl_trans_rx_alloc(priv);
+		err = iwl_trans_rx_alloc(trans);
 		if (err)
 			return err;
 	}
@@ -197,7 +204,7 @@ static int iwl_rx_init(struct iwl_priv *priv)
 	INIT_LIST_HEAD(&rxq->rx_free);
 	INIT_LIST_HEAD(&rxq->rx_used);
 
-	iwl_trans_rxq_free_rx_bufs(priv);
+	iwl_trans_rxq_free_rx_bufs(trans);
 
 	for (i = 0; i < RX_QUEUE_SIZE; i++)
 		rxq->queue[i] = NULL;
@@ -209,45 +216,48 @@ static int iwl_rx_init(struct iwl_priv *priv)
 	rxq->free_count = 0;
 	spin_unlock_irqrestore(&rxq->lock, flags);
 
-	iwlagn_rx_replenish(priv);
+	iwlagn_rx_replenish(trans);
 
-	iwl_trans_rx_hw_init(priv, rxq);
+	iwl_trans_rx_hw_init(priv(trans), rxq);
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	spin_lock_irqsave(&trans->shrd->lock, flags);
 	rxq->need_update = 1;
-	iwl_rx_queue_update_write_ptr(priv, rxq);
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	iwl_rx_queue_update_write_ptr(trans, rxq);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
 	return 0;
 }
 
-static void iwl_trans_pcie_rx_free(struct iwl_priv *priv)
+static void iwl_trans_pcie_rx_free(struct iwl_trans *trans)
 {
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+
 	unsigned long flags;
 
 	/*if rxq->bd is NULL, it means that nothing has been allocated,
 	 * exit now */
 	if (!rxq->bd) {
-		IWL_DEBUG_INFO(priv, "Free NULL rx context\n");
+		IWL_DEBUG_INFO(trans, "Free NULL rx context\n");
 		return;
 	}
 
 	spin_lock_irqsave(&rxq->lock, flags);
-	iwl_trans_rxq_free_rx_bufs(priv);
+	iwl_trans_rxq_free_rx_bufs(trans);
 	spin_unlock_irqrestore(&rxq->lock, flags);
 
-	dma_free_coherent(priv->bus->dev, sizeof(__le32) * RX_QUEUE_SIZE,
+	dma_free_coherent(bus(trans)->dev, sizeof(__le32) * RX_QUEUE_SIZE,
 			  rxq->bd, rxq->bd_dma);
 	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
 	rxq->bd = NULL;
 
 	if (rxq->rb_stts)
-		dma_free_coherent(priv->bus->dev,
+		dma_free_coherent(bus(trans)->dev,
 				  sizeof(struct iwl_rb_status),
 				  rxq->rb_stts, rxq->rb_stts_dma);
 	else
-		IWL_DEBUG_INFO(priv, "Free rxq->rb_stts which is NULL\n");
+		IWL_DEBUG_INFO(trans, "Free rxq->rb_stts which is NULL\n");
 	memset(&rxq->rb_stts_dma, 0, sizeof(rxq->rb_stts_dma));
 	rxq->rb_stts = NULL;
 }
@@ -614,7 +624,7 @@ static int iwl_nic_init(struct iwl_priv *priv)
 	priv->cfg->lib->nic_config(priv);
 
 	/* Allocate the RX queue, or reset if it is already allocated */
-	iwl_rx_init(priv);
+	iwl_rx_init(trans(priv));
 
 	/* Allocate or reset and init all Tx and Command queues */
 	if (iwl_tx_init(priv))
@@ -1120,6 +1130,8 @@ static void iwl_trans_pcie_kick_nic(struct iwl_priv *priv)
 
 static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_priv *priv = priv(trans);
 	int err;
 
@@ -1136,7 +1148,7 @@ static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 		return err;
 	}
 
-	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
+	INIT_WORK(&trans_pcie->rx_replenish, iwl_bg_rx_replenish);
 	return 0;
 }
 
@@ -1163,8 +1175,11 @@ static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
 					      sizeof(struct iwl_trans_pcie),
 					      GFP_KERNEL);
 	if (iwl_trans) {
+		struct iwl_trans_pcie *trans_pcie =
+			IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
 		iwl_trans->ops = &trans_ops_pcie;
 		iwl_trans->shrd = shrd;
+		trans_pcie->trans = iwl_trans;
 	}
 
 	return iwl_trans;
@@ -1173,7 +1188,7 @@ static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
-	if (!debugfs_create_file(#name, mode, parent, priv,		\
+	if (!debugfs_create_file(#name, mode, parent, trans,		\
 				 &iwl_dbgfs_##name##_ops))		\
 		return -ENOMEM;						\
 } while (0)
@@ -1218,12 +1233,15 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 					 char __user *user_buf,
 					 size_t count, loff_t *ppos)
 {
-	struct iwl_priv *priv = file->private_data;
+	struct iwl_trans *trans = file->private_data;
+	struct iwl_priv *priv = priv(trans);
 	int pos = 0, ofs = 0;
 	int cnt = 0, entry;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	char *buf;
 	int bufsz = ((IWL_TRAFFIC_ENTRIES * IWL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
 		(priv->cfg->base_params->num_of_queues * 32 * 8) + 400;
@@ -1231,16 +1249,16 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 	ssize_t ret;
 
 	if (!priv->txq) {
-		IWL_ERR(priv, "txq not ready\n");
+		IWL_ERR(trans, "txq not ready\n");
 		return -EAGAIN;
 	}
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
-		IWL_ERR(priv, "Can not allocate buffer\n");
+		IWL_ERR(trans, "Can not allocate buffer\n");
 		return -ENOMEM;
 	}
 	pos += scnprintf(buf + pos, bufsz - pos, "Tx Queue\n");
-	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
+	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
 		txq = &priv->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
@@ -1248,10 +1266,10 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 				cnt, q->read_ptr, q->write_ptr);
 	}
 	if (priv->tx_traffic &&
-		(iwl_get_debug_level(priv->shrd) & IWL_DL_TX)) {
+		(iwl_get_debug_level(trans->shrd) & IWL_DL_TX)) {
 		ptr = priv->tx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"Tx Traffic idx: %u\n",	priv->tx_traffic_idx);
+				"Tx Traffic idx: %u\n", priv->tx_traffic_idx);
 		for (cnt = 0, ofs = 0; cnt < IWL_TRAFFIC_ENTRIES; cnt++) {
 			for (entry = 0; entry < IWL_TRAFFIC_ENTRY_SIZE / 16;
 			     entry++,  ofs += 16) {
@@ -1272,10 +1290,10 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 			 rxq->read, rxq->write);
 
 	if (priv->rx_traffic &&
-		(iwl_get_debug_level(priv->shrd) & IWL_DL_RX)) {
+		(iwl_get_debug_level(trans->shrd) & IWL_DL_RX)) {
 		ptr = priv->rx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"Rx Traffic idx: %u\n",	priv->rx_traffic_idx);
+				"Rx Traffic idx: %u\n", priv->rx_traffic_idx);
 		for (cnt = 0, ofs = 0; cnt < IWL_TRAFFIC_ENTRIES; cnt++) {
 			for (entry = 0; entry < IWL_TRAFFIC_ENTRY_SIZE / 16;
 			     entry++,  ofs += 16) {
@@ -1299,7 +1317,7 @@ static ssize_t iwl_dbgfs_traffic_log_write(struct file *file,
 					 const char __user *user_buf,
 					 size_t count, loff_t *ppos)
 {
-	struct iwl_priv *priv = file->private_data;
+	struct iwl_trans *trans = file->private_data;
 	char buf[8];
 	int buf_size;
 	int traffic_log;
@@ -1311,7 +1329,7 @@ static ssize_t iwl_dbgfs_traffic_log_write(struct file *file,
 	if (sscanf(buf, "%d", &traffic_log) != 1)
 		return -EFAULT;
 	if (traffic_log == 0)
-		iwl_reset_traffic_log(priv);
+		iwl_reset_traffic_log(priv(trans));
 
 	return count;
 }
@@ -1320,7 +1338,8 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 						char __user *user_buf,
 						size_t count, loff_t *ppos) {
 
-	struct iwl_priv *priv = file->private_data;
+	struct iwl_trans *trans = file->private_data;
+	struct iwl_priv *priv = priv(trans);
 	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
 	char *buf;
@@ -1338,7 +1357,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
+	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
 		txq = &priv->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
@@ -1363,8 +1382,10 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 						char __user *user_buf,
 						size_t count, loff_t *ppos) {
-	struct iwl_priv *priv = file->private_data;
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl_trans *trans = file->private_data;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	char buf[256];
 	int pos = 0;
 	const size_t bufsz = sizeof(buf);
@@ -1396,8 +1417,6 @@ DEBUGFS_READ_FILE_OPS(tx_queue);
 static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 					struct dentry *dir)
 {
-	struct iwl_priv *priv = priv(trans);
-
 	DEBUGFS_ADD_FILE(traffic_log, dir, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index a9b3157..8eee910 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -112,7 +112,7 @@ struct iwl_trans_ops {
 	void (*stop_device)(struct iwl_priv *priv);
 	void (*tx_start)(struct iwl_priv *priv);
 	void (*tx_free)(struct iwl_priv *priv);
-	void (*rx_free)(struct iwl_priv *priv);
+	void (*rx_free)(struct iwl_trans *trans);
 
 	int (*send_cmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
@@ -177,7 +177,7 @@ static inline void iwl_trans_tx_start(struct iwl_trans *trans)
 
 static inline void iwl_trans_rx_free(struct iwl_trans *trans)
 {
-	trans->ops->rx_free(priv(trans));
+	trans->ops->rx_free(trans);
 }
 
 static inline void iwl_trans_tx_free(struct iwl_trans *trans)
-- 
1.7.0.4

