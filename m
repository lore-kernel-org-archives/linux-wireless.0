Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57634 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbbGLRIm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 13:08:42 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/10] Revert "iwlwifi: pcie: New RBD allocation model"
Date: Sun, 12 Jul 2015 20:08:19 +0300
Message-Id: <1436720900-18588-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150712_190852_342436_3C9E5397)
In-Reply-To: <1436720814.17999.2.camel@intel.com>
References: <1436720814.17999.2.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 5f17570354f91275b0a37a4da33d29a2ab57d32e.

This patch introduced a high latency in buffer allocation
under extreme load. This latency caused a firmwre crash.
The same scenario works fine with this patch reverted.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fh.h        |   6 +
 drivers/net/wireless/iwlwifi/pcie/internal.h |  51 +---
 drivers/net/wireless/iwlwifi/pcie/rx.c       | 414 ++++++---------------------
 3 files changed, 97 insertions(+), 374 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index d560648..d45dc02 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -438,6 +438,12 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 #define RX_QUEUE_MASK                         255
 #define RX_QUEUE_SIZE_LOG                     8
 
+/*
+ * RX related structures and functions
+ */
+#define RX_FREE_BUFFERS 64
+#define RX_LOW_WATERMARK 8
+
 /**
  * struct iwl_rb_status - reserve buffer status
  * 	host memory mapped FH registers
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 31f72a6..376b84e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -44,15 +44,6 @@
 #include "iwl-io.h"
 #include "iwl-op-mode.h"
 
-/*
- * RX related structures and functions
- */
-#define RX_NUM_QUEUES 1
-#define RX_POST_REQ_ALLOC 2
-#define RX_CLAIM_REQ_ALLOC 8
-#define RX_POOL_SIZE ((RX_CLAIM_REQ_ALLOC - RX_POST_REQ_ALLOC) * RX_NUM_QUEUES)
-#define RX_LOW_WATERMARK 8
-
 struct iwl_host_cmd;
 
 /*This file includes the declaration that are internal to the
@@ -86,29 +77,29 @@ struct isr_statistics {
  * struct iwl_rxq - Rx queue
  * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
  * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
+ * @pool:
+ * @queue:
  * @read: Shared index to newest available Rx buffer
  * @write: Shared index to oldest written Rx packet
  * @free_count: Number of pre-allocated buffers in rx_free
- * @used_count: Number of RBDs handled to allocator to use for allocation
  * @write_actual:
- * @rx_free: list of RBDs with allocated RB ready for use
- * @rx_used: list of RBDs with no RB attached
+ * @rx_free: list of free SKBs for use
+ * @rx_used: List of Rx buffers with no SKB
  * @need_update: flag to indicate we need to update read/write index
  * @rb_stts: driver's pointer to receive buffer status
  * @rb_stts_dma: bus address of receive buffer status
  * @lock:
- * @pool: initial pool of iwl_rx_mem_buffer for the queue
- * @queue: actual rx queue
  *
  * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
  */
 struct iwl_rxq {
 	__le32 *bd;
 	dma_addr_t bd_dma;
+	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
+	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
 	u32 read;
 	u32 write;
 	u32 free_count;
-	u32 used_count;
 	u32 write_actual;
 	struct list_head rx_free;
 	struct list_head rx_used;
@@ -116,32 +107,6 @@ struct iwl_rxq {
 	struct iwl_rb_status *rb_stts;
 	dma_addr_t rb_stts_dma;
 	spinlock_t lock;
-	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE];
-	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
-};
-
-/**
- * struct iwl_rb_allocator - Rx allocator
- * @pool: initial pool of allocator
- * @req_pending: number of requests the allcator had not processed yet
- * @req_ready: number of requests honored and ready for claiming
- * @rbd_allocated: RBDs with pages allocated and ready to be handled to
- *	the queue. This is a list of &struct iwl_rx_mem_buffer
- * @rbd_empty: RBDs with no page attached for allocator use. This is a list
- *	of &struct iwl_rx_mem_buffer
- * @lock: protects the rbd_allocated and rbd_empty lists
- * @alloc_wq: work queue for background calls
- * @rx_alloc: work struct for background calls
- */
-struct iwl_rb_allocator {
-	struct iwl_rx_mem_buffer pool[RX_POOL_SIZE];
-	atomic_t req_pending;
-	atomic_t req_ready;
-	struct list_head rbd_allocated;
-	struct list_head rbd_empty;
-	spinlock_t lock;
-	struct workqueue_struct *alloc_wq;
-	struct work_struct rx_alloc;
 };
 
 struct iwl_dma_ptr {
@@ -285,7 +250,7 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
 /**
  * struct iwl_trans_pcie - PCIe transport specific data
  * @rxq: all the RX queue data
- * @rba: allocator for RX replenishing
+ * @rx_replenish: work that will be called when buffers need to be allocated
  * @drv - pointer to iwl_drv
  * @trans: pointer to the generic transport area
  * @scd_base_addr: scheduler sram base address in SRAM
@@ -308,7 +273,7 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
  */
 struct iwl_trans_pcie {
 	struct iwl_rxq rxq;
-	struct iwl_rb_allocator rba;
+	struct work_struct rx_replenish;
 	struct iwl_trans *trans;
 	struct iwl_drv *drv;
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index a3fbaa0..adad8d0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1,7 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -74,29 +74,16 @@
  * resets the Rx queue buffers with new memory.
  *
  * The management in the driver is as follows:
- * + A list of pre-allocated RBDs is stored in iwl->rxq->rx_free.
- *   When the interrupt handler is called, the request is processed.
- *   The page is either stolen - transferred to the upper layer
- *   or reused - added immediately to the iwl->rxq->rx_free list.
- * + When the page is stolen - the driver updates the matching queue's used
- *   count, detaches the RBD and transfers it to the queue used list.
- *   When there are two used RBDs - they are transferred to the allocator empty
- *   list. Work is then scheduled for the allocator to start allocating
- *   eight buffers.
- *   When there are another 6 used RBDs - they are transferred to the allocator
- *   empty list and the driver tries to claim the pre-allocated buffers and
- *   add them to iwl->rxq->rx_free. If it fails - it continues to claim them
- *   until ready.
- *   When there are 8+ buffers in the free list - either from allocation or from
- *   8 reused unstolen pages - restock is called to update the FW and indexes.
- * + In order to make sure the allocator always has RBDs to use for allocation
- *   the allocator has initial pool in the size of num_queues*(8-2) - the
- *   maximum missing RBDs per allocation request (request posted with 2
- *    empty RBDs, there is no guarantee when the other 6 RBDs are supplied).
- *   The queues supplies the recycle of the rest of the RBDs.
+ * + A list of pre-allocated SKBs is stored in iwl->rxq->rx_free.  When
+ *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
+ *   to replenish the iwl->rxq->rx_free.
+ * + In iwl_pcie_rx_replenish (scheduled) if 'processed' != 'read' then the
+ *   iwl->rxq is replenished and the READ INDEX is updated (updating the
+ *   'processed' and 'read' driver indexes as well)
  * + A received packet is processed and handed to the kernel network stack,
  *   detached from the iwl->rxq.  The driver 'processed' index is updated.
- * + If there are no allocated buffers in iwl->rxq->rx_free,
+ * + The Host/Firmware iwl->rxq is replenished at irq thread time from the
+ *   rx_free list. If there are no allocated buffers in iwl->rxq->rx_free,
  *   the READ INDEX is not incremented and iwl->status(RX_STALLED) is set.
  *   If there were enough free buffers and RX_STALLED is set it is cleared.
  *
@@ -105,32 +92,18 @@
  *
  * iwl_rxq_alloc()            Allocates rx_free
  * iwl_pcie_rx_replenish()    Replenishes rx_free list from rx_used, and calls
- *                            iwl_pcie_rxq_restock.
- *                            Used only during initialization.
+ *                            iwl_pcie_rxq_restock
  * iwl_pcie_rxq_restock()     Moves available buffers from rx_free into Rx
  *                            queue, updates firmware pointers, and updates
- *                            the WRITE index.
- * iwl_pcie_rx_allocator()     Background work for allocating pages.
+ *                            the WRITE index.  If insufficient rx_free buffers
+ *                            are available, schedules iwl_pcie_rx_replenish
  *
  * -- enable interrupts --
  * ISR - iwl_rx()             Detach iwl_rx_mem_buffers from pool up to the
  *                            READ INDEX, detaching the SKB from the pool.
  *                            Moves the packet buffer from queue to rx_used.
- *                            Posts and claims requests to the allocator.
  *                            Calls iwl_pcie_rxq_restock to refill any empty
  *                            slots.
- *
- * RBD life-cycle:
- *
- * Init:
- * rxq.pool -> rxq.rx_used -> rxq.rx_free -> rxq.queue
- *
- * Regular Receive interrupt:
- * Page Stolen:
- * rxq.queue -> rxq.rx_used -> allocator.rbd_empty ->
- * allocator.rbd_allocated -> rxq.rx_free -> rxq.queue
- * Page not Stolen:
- * rxq.queue -> rxq.rx_free -> rxq.queue
  * ...
  *
  */
@@ -267,6 +240,10 @@ static void iwl_pcie_rxq_restock(struct iwl_trans *trans)
 		rxq->free_count--;
 	}
 	spin_unlock(&rxq->lock);
+	/* If the pre-allocated buffer pool is dropping low, schedule to
+	 * refill it */
+	if (rxq->free_count <= RX_LOW_WATERMARK)
+		schedule_work(&trans_pcie->rx_replenish);
 
 	/* If we've added more space for the firmware to place data, tell it.
 	 * Increment device's write pointer in multiples of 8. */
@@ -278,44 +255,6 @@ static void iwl_pcie_rxq_restock(struct iwl_trans *trans)
 }
 
 /*
- * iwl_pcie_rx_alloc_page - allocates and returns a page.
- *
- */
-static struct page *iwl_pcie_rx_alloc_page(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rxq *rxq = &trans_pcie->rxq;
-	struct page *page;
-	gfp_t gfp_mask = GFP_KERNEL;
-
-	if (rxq->free_count > RX_LOW_WATERMARK)
-		gfp_mask |= __GFP_NOWARN;
-
-	if (trans_pcie->rx_page_order > 0)
-		gfp_mask |= __GFP_COMP;
-
-	/* Alloc a new receive buffer */
-	page = alloc_pages(gfp_mask, trans_pcie->rx_page_order);
-	if (!page) {
-		if (net_ratelimit())
-			IWL_DEBUG_INFO(trans, "alloc_pages failed, order: %d\n",
-				       trans_pcie->rx_page_order);
-		/* Issue an error if the hardware has consumed more than half
-		 * of its free buffer list and we don't have enough
-		 * pre-allocated buffers.
-`		 */
-		if (rxq->free_count <= RX_LOW_WATERMARK &&
-		    iwl_rxq_space(rxq) > (RX_QUEUE_SIZE / 2) &&
-		    net_ratelimit())
-			IWL_CRIT(trans,
-				 "Failed to alloc_pages with GFP_KERNEL. Only %u free buffers remaining.\n",
-				 rxq->free_count);
-		return NULL;
-	}
-	return page;
-}
-
-/*
  * iwl_pcie_rxq_alloc_rbs - allocate a page for each used RBD
  *
  * A used RBD is an Rx buffer that has been given to the stack. To use it again
@@ -324,12 +263,13 @@ static struct page *iwl_pcie_rx_alloc_page(struct iwl_trans *trans)
  * iwl_pcie_rxq_restock. The latter function will update the HW to use the newly
  * allocated buffers.
  */
-static void iwl_pcie_rxq_alloc_rbs(struct iwl_trans *trans)
+static void iwl_pcie_rxq_alloc_rbs(struct iwl_trans *trans, gfp_t priority)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
 	struct iwl_rx_mem_buffer *rxb;
 	struct page *page;
+	gfp_t gfp_mask = priority;
 
 	while (1) {
 		spin_lock(&rxq->lock);
@@ -339,10 +279,32 @@ static void iwl_pcie_rxq_alloc_rbs(struct iwl_trans *trans)
 		}
 		spin_unlock(&rxq->lock);
 
+		if (rxq->free_count > RX_LOW_WATERMARK)
+			gfp_mask |= __GFP_NOWARN;
+
+		if (trans_pcie->rx_page_order > 0)
+			gfp_mask |= __GFP_COMP;
+
 		/* Alloc a new receive buffer */
-		page = iwl_pcie_rx_alloc_page(trans);
-		if (!page)
+		page = alloc_pages(gfp_mask, trans_pcie->rx_page_order);
+		if (!page) {
+			if (net_ratelimit())
+				IWL_DEBUG_INFO(trans, "alloc_pages failed, "
+					   "order: %d\n",
+					   trans_pcie->rx_page_order);
+
+			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
+			    net_ratelimit())
+				IWL_CRIT(trans, "Failed to alloc_pages with %s."
+					 "Only %u free buffers remaining.\n",
+					 priority == GFP_ATOMIC ?
+					 "GFP_ATOMIC" : "GFP_KERNEL",
+					 rxq->free_count);
+			/* We don't reschedule replenish work here -- we will
+			 * call the restock method and if it still needs
+			 * more buffers it will schedule replenish */
 			return;
+		}
 
 		spin_lock(&rxq->lock);
 
@@ -393,7 +355,7 @@ static void iwl_pcie_rxq_free_rbs(struct iwl_trans *trans)
 
 	lockdep_assert_held(&rxq->lock);
 
-	for (i = 0; i < RX_QUEUE_SIZE; i++) {
+	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
 		if (!rxq->pool[i].page)
 			continue;
 		dma_unmap_page(trans->dev, rxq->pool[i].page_dma,
@@ -410,144 +372,32 @@ static void iwl_pcie_rxq_free_rbs(struct iwl_trans *trans)
  * When moving to rx_free an page is allocated for the slot.
  *
  * Also restock the Rx queue via iwl_pcie_rxq_restock.
- * This is called only during initialization
+ * This is called as a scheduled work item (except for during initialization)
  */
-static void iwl_pcie_rx_replenish(struct iwl_trans *trans)
+static void iwl_pcie_rx_replenish(struct iwl_trans *trans, gfp_t gfp)
 {
-	iwl_pcie_rxq_alloc_rbs(trans);
+	iwl_pcie_rxq_alloc_rbs(trans, gfp);
 
 	iwl_pcie_rxq_restock(trans);
 }
 
-/*
- * iwl_pcie_rx_allocator - Allocates pages in the background for RX queues
- *
- * Allocates for each received request 8 pages
- * Called as a scheduled work item.
- */
-static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rb_allocator *rba = &trans_pcie->rba;
-
-	while (atomic_read(&rba->req_pending)) {
-		int i;
-		struct list_head local_empty;
-		struct list_head local_allocated;
-
-		INIT_LIST_HEAD(&local_allocated);
-		spin_lock(&rba->lock);
-		/* swap out the entire rba->rbd_empty to a local list */
-		list_replace_init(&rba->rbd_empty, &local_empty);
-		spin_unlock(&rba->lock);
-
-		for (i = 0; i < RX_CLAIM_REQ_ALLOC;) {
-			struct iwl_rx_mem_buffer *rxb;
-			struct page *page;
-
-			/* List should never be empty - each reused RBD is
-			 * returned to the list, and initial pool covers any
-			 * possible gap between the time the page is allocated
-			 * to the time the RBD is added.
-			 */
-			BUG_ON(list_empty(&local_empty));
-			/* Get the first rxb from the rbd list */
-			rxb = list_first_entry(&local_empty,
-					       struct iwl_rx_mem_buffer, list);
-			BUG_ON(rxb->page);
-
-			/* Alloc a new receive buffer */
-			page = iwl_pcie_rx_alloc_page(trans);
-			if (!page)
-				continue;
-			rxb->page = page;
-
-			/* Get physical address of the RB */
-			rxb->page_dma = dma_map_page(trans->dev, page, 0,
-					PAGE_SIZE << trans_pcie->rx_page_order,
-					DMA_FROM_DEVICE);
-			if (dma_mapping_error(trans->dev, rxb->page_dma)) {
-				rxb->page = NULL;
-				__free_pages(page, trans_pcie->rx_page_order);
-				continue;
-			}
-			/* dma address must be no more than 36 bits */
-			BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
-			/* and also 256 byte aligned! */
-			BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
-
-			/* move the allocated entry to the out list */
-			list_move(&rxb->list, &local_allocated);
-			i++;
-		}
-
-		spin_lock(&rba->lock);
-		/* add the allocated rbds to the allocator allocated list */
-		list_splice_tail(&local_allocated, &rba->rbd_allocated);
-		/* add the unused rbds back to the allocator empty list */
-		list_splice_tail(&local_empty, &rba->rbd_empty);
-		spin_unlock(&rba->lock);
-
-		atomic_dec(&rba->req_pending);
-		atomic_inc(&rba->req_ready);
-	}
-}
-
-/*
- * iwl_pcie_rx_allocator_get - Returns the pre-allocated pages
-.*
-.* Called by queue when the queue posted allocation request and
- * has freed 8 RBDs in order to restock itself.
- */
-static int iwl_pcie_rx_allocator_get(struct iwl_trans *trans,
-				     struct iwl_rx_mem_buffer
-				     *out[RX_CLAIM_REQ_ALLOC])
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rb_allocator *rba = &trans_pcie->rba;
-	int i;
-
-	if (atomic_dec_return(&rba->req_ready) < 0) {
-		atomic_inc(&rba->req_ready);
-		IWL_DEBUG_RX(trans,
-			     "Allocation request not ready, pending requests = %d\n",
-			     atomic_read(&rba->req_pending));
-		return -ENOMEM;
-	}
-
-	spin_lock(&rba->lock);
-	for (i = 0; i < RX_CLAIM_REQ_ALLOC; i++) {
-		/* Get next free Rx buffer, remove it from free list */
-		out[i] = list_first_entry(&rba->rbd_allocated,
-			       struct iwl_rx_mem_buffer, list);
-		list_del(&out[i]->list);
-	}
-	spin_unlock(&rba->lock);
-
-	return 0;
-}
-
-static void iwl_pcie_rx_allocator_work(struct work_struct *data)
+static void iwl_pcie_rx_replenish_work(struct work_struct *data)
 {
-	struct iwl_rb_allocator *rba_p =
-		container_of(data, struct iwl_rb_allocator, rx_alloc);
 	struct iwl_trans_pcie *trans_pcie =
-		container_of(rba_p, struct iwl_trans_pcie, rba);
+	    container_of(data, struct iwl_trans_pcie, rx_replenish);
 
-	iwl_pcie_rx_allocator(trans_pcie->trans);
+	iwl_pcie_rx_replenish(trans_pcie->trans, GFP_KERNEL);
 }
 
 static int iwl_pcie_rx_alloc(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
-	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 	struct device *dev = trans->dev;
 
 	memset(&trans_pcie->rxq, 0, sizeof(trans_pcie->rxq));
 
 	spin_lock_init(&rxq->lock);
-	spin_lock_init(&rba->lock);
 
 	if (WARN_ON(rxq->bd || rxq->rb_stts))
 		return -EINVAL;
@@ -637,49 +487,15 @@ static void iwl_pcie_rx_init_rxb_lists(struct iwl_rxq *rxq)
 	INIT_LIST_HEAD(&rxq->rx_free);
 	INIT_LIST_HEAD(&rxq->rx_used);
 	rxq->free_count = 0;
-	rxq->used_count = 0;
 
-	for (i = 0; i < RX_QUEUE_SIZE; i++)
+	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
 		list_add(&rxq->pool[i].list, &rxq->rx_used);
 }
 
-static void iwl_pcie_rx_init_rba(struct iwl_rb_allocator *rba)
-{
-	int i;
-
-	lockdep_assert_held(&rba->lock);
-
-	INIT_LIST_HEAD(&rba->rbd_allocated);
-	INIT_LIST_HEAD(&rba->rbd_empty);
-
-	for (i = 0; i < RX_POOL_SIZE; i++)
-		list_add(&rba->pool[i].list, &rba->rbd_empty);
-}
-
-static void iwl_pcie_rx_free_rba(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rb_allocator *rba = &trans_pcie->rba;
-	int i;
-
-	lockdep_assert_held(&rba->lock);
-
-	for (i = 0; i < RX_POOL_SIZE; i++) {
-		if (!rba->pool[i].page)
-			continue;
-		dma_unmap_page(trans->dev, rba->pool[i].page_dma,
-			       PAGE_SIZE << trans_pcie->rx_page_order,
-			       DMA_FROM_DEVICE);
-		__free_pages(rba->pool[i].page, trans_pcie->rx_page_order);
-		rba->pool[i].page = NULL;
-	}
-}
-
 int iwl_pcie_rx_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
-	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 	int i, err;
 
 	if (!rxq->bd) {
@@ -687,21 +503,11 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 		if (err)
 			return err;
 	}
-	if (!rba->alloc_wq)
-		rba->alloc_wq = alloc_workqueue("rb_allocator",
-						WQ_HIGHPRI | WQ_UNBOUND, 1);
-	INIT_WORK(&rba->rx_alloc, iwl_pcie_rx_allocator_work);
-
-	spin_lock(&rba->lock);
-	atomic_set(&rba->req_pending, 0);
-	atomic_set(&rba->req_ready, 0);
-	/* free all first - we might be reconfigured for a different size */
-	iwl_pcie_rx_free_rba(trans);
-	iwl_pcie_rx_init_rba(rba);
-	spin_unlock(&rba->lock);
 
 	spin_lock(&rxq->lock);
 
+	INIT_WORK(&trans_pcie->rx_replenish, iwl_pcie_rx_replenish_work);
+
 	/* free all first - we might be reconfigured for a different size */
 	iwl_pcie_rxq_free_rbs(trans);
 	iwl_pcie_rx_init_rxb_lists(rxq);
@@ -716,7 +522,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	memset(rxq->rb_stts, 0, sizeof(*rxq->rb_stts));
 	spin_unlock(&rxq->lock);
 
-	iwl_pcie_rx_replenish(trans);
+	iwl_pcie_rx_replenish(trans, GFP_KERNEL);
 
 	iwl_pcie_rx_hw_init(trans, rxq);
 
@@ -731,7 +537,6 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
-	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 
 	/*if rxq->bd is NULL, it means that nothing has been allocated,
 	 * exit now */
@@ -740,15 +545,7 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 		return;
 	}
 
-	cancel_work_sync(&rba->rx_alloc);
-	if (rba->alloc_wq) {
-		destroy_workqueue(rba->alloc_wq);
-		rba->alloc_wq = NULL;
-	}
-
-	spin_lock(&rba->lock);
-	iwl_pcie_rx_free_rba(trans);
-	spin_unlock(&rba->lock);
+	cancel_work_sync(&trans_pcie->rx_replenish);
 
 	spin_lock(&rxq->lock);
 	iwl_pcie_rxq_free_rbs(trans);
@@ -769,43 +566,6 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 	rxq->rb_stts = NULL;
 }
 
-/*
- * iwl_pcie_rx_reuse_rbd - Recycle used RBDs
- *
- * Called when a RBD can be reused. The RBD is transferred to the allocator.
- * When there are 2 empty RBDs - a request for allocation is posted
- */
-static void iwl_pcie_rx_reuse_rbd(struct iwl_trans *trans,
-				  struct iwl_rx_mem_buffer *rxb,
-				  struct iwl_rxq *rxq)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rb_allocator *rba = &trans_pcie->rba;
-
-	/* Count the used RBDs */
-	rxq->used_count++;
-
-	/* Move the RBD to the used list, will be moved to allocator in batches
-	 * before claiming or posting a request*/
-	list_add_tail(&rxb->list, &rxq->rx_used);
-
-	/* If we have RX_POST_REQ_ALLOC new released rx buffers -
-	 * issue a request for allocator. Modulo RX_CLAIM_REQ_ALLOC is
-	 * used for the case we failed to claim RX_CLAIM_REQ_ALLOC,
-	 * after but we still need to post another request.
-	 */
-	if ((rxq->used_count % RX_CLAIM_REQ_ALLOC) == RX_POST_REQ_ALLOC) {
-		/* Move the 2 RBDs to the allocator ownership.
-		 Allocator has another 6 from pool for the request completion*/
-		spin_lock(&rba->lock);
-		list_splice_tail_init(&rxq->rx_used, &rba->rbd_empty);
-		spin_unlock(&rba->lock);
-
-		atomic_inc(&rba->req_pending);
-		queue_work(rba->alloc_wq, &rba->rx_alloc);
-	}
-}
-
 static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 				struct iwl_rx_mem_buffer *rxb)
 {
@@ -928,13 +688,13 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 			 */
 			__free_pages(rxb->page, trans_pcie->rx_page_order);
 			rxb->page = NULL;
-			iwl_pcie_rx_reuse_rbd(trans, rxb, rxq);
+			list_add_tail(&rxb->list, &rxq->rx_used);
 		} else {
 			list_add_tail(&rxb->list, &rxq->rx_free);
 			rxq->free_count++;
 		}
 	} else
-		iwl_pcie_rx_reuse_rbd(trans, rxb, rxq);
+		list_add_tail(&rxb->list, &rxq->rx_used);
 }
 
 /*
@@ -944,7 +704,10 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
-	u32 r, i, j;
+	u32 r, i;
+	u8 fill_rx = 0;
+	u32 count = 8;
+	int total_empty;
 
 restart:
 	spin_lock(&rxq->lock);
@@ -957,6 +720,14 @@ restart:
 	if (i == r)
 		IWL_DEBUG_RX(trans, "HW = SW = %d\n", r);
 
+	/* calculate total frames need to be restock after handling RX */
+	total_empty = r - rxq->write_actual;
+	if (total_empty < 0)
+		total_empty += RX_QUEUE_SIZE;
+
+	if (total_empty > (RX_QUEUE_SIZE / 2))
+		fill_rx = 1;
+
 	while (i != r) {
 		struct iwl_rx_mem_buffer *rxb;
 
@@ -968,48 +739,29 @@ restart:
 		iwl_pcie_rx_handle_rb(trans, rxb);
 
 		i = (i + 1) & RX_QUEUE_MASK;
-
-		/* If we have RX_CLAIM_REQ_ALLOC released rx buffers -
-		 * try to claim the pre-allocated buffers from the allocator */
-		if (rxq->used_count >= RX_CLAIM_REQ_ALLOC) {
-			struct iwl_rb_allocator *rba = &trans_pcie->rba;
-			struct iwl_rx_mem_buffer *out[RX_CLAIM_REQ_ALLOC];
-
-			/* Add the remaining 6 empty RBDs for allocator use */
-			spin_lock(&rba->lock);
-			list_splice_tail_init(&rxq->rx_used, &rba->rbd_empty);
-			spin_unlock(&rba->lock);
-
-			/* If not ready - continue, will try to reclaim later.
-			* No need to reschedule work - allocator exits only on
-			* success */
-			if (!iwl_pcie_rx_allocator_get(trans, out)) {
-				/* If success - then RX_CLAIM_REQ_ALLOC
-				 * buffers were retrieved and should be added
-				 * to free list */
-				rxq->used_count -= RX_CLAIM_REQ_ALLOC;
-				for (j = 0; j < RX_CLAIM_REQ_ALLOC; j++) {
-					list_add_tail(&out[j]->list,
-						      &rxq->rx_free);
-					rxq->free_count++;
-				}
+		/* If there are a lot of unused frames,
+		 * restock the Rx queue so ucode wont assert. */
+		if (fill_rx) {
+			count++;
+			if (count >= 8) {
+				rxq->read = i;
+				spin_unlock(&rxq->lock);
+				iwl_pcie_rx_replenish(trans, GFP_ATOMIC);
+				count = 0;
+				goto restart;
 			}
 		}
-		/* handle restock for two cases:
-		* - we just pulled buffers from the allocator
-		* - we have 8+ unstolen pages accumulated */
-		if (rxq->free_count >=  RX_CLAIM_REQ_ALLOC) {
-			rxq->read = i;
-			spin_unlock(&rxq->lock);
-			iwl_pcie_rxq_restock(trans);
-			goto restart;
-		}
 	}
 
 	/* Backtrack one entry */
 	rxq->read = i;
 	spin_unlock(&rxq->lock);
 
+	if (fill_rx)
+		iwl_pcie_rx_replenish(trans, GFP_ATOMIC);
+	else
+		iwl_pcie_rxq_restock(trans);
+
 	if (trans_pcie->napi.poll)
 		napi_gro_flush(&trans_pcie->napi, false);
 }
-- 
2.1.4

