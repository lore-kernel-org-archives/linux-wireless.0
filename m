Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63426 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbbHRH6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:05 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/26] iwlwifi: pcie: New RBD allocation model
Date: Tue, 18 Aug 2015 10:57:19 +0300
Message-Id: <1439884656-18146-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100110_791800_AB6F9F06)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

As a preperation for multiple RX queues change the RBD
allocation model.

The new model includes a background allocator. The allocator is
called by the interrupt handler when there are two released
buffers by the queue, and the allocator starts allocating eight
pages per request.
When the queue has released 8 pages it tries claiming the
request. If the pages are not ready - it keeps claiming.
This new model should make sure that RBDs are always available
across the multiple queues.

The RBDs are transferred between the allocator and the queue.
The queue moves the free RBDs upon freeing them to the allocator.
The allocator moves them back to the queue's possession when the
request is claimed.
The allocator has an initial pool to make sure there are always RBDs
available for the request completion.
Release of the buffers at exit is done per pools - the allocator
frees its own initial pool and the queue frees its own pool.

Existing code refactor -
-Queue's initial pool is the size of the queue only as the allocation
of the new buffers no longer uses this pool.
-Removal of replenish background work, and replenish calls in the
interrupt handler and restock().
-The replenish() and the rxq used_list are used only during
initialization.
-Moved page allocation to a new function for code reuse.

New code -
Allocator code - new structure and functions.
Interrupt handler uses the allocator functions for replenishing buffers.
Reuse of the restock() method.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fh.h        |   6 -
 drivers/net/wireless/iwlwifi/pcie/internal.h |  51 ++-
 drivers/net/wireless/iwlwifi/pcie/rx.c       | 473 ++++++++++++++++++++++-----
 3 files changed, 435 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index d45dc02..d560648 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -438,12 +438,6 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 #define RX_QUEUE_MASK                         255
 #define RX_QUEUE_SIZE_LOG                     8
 
-/*
- * RX related structures and functions
- */
-#define RX_FREE_BUFFERS 64
-#define RX_LOW_WATERMARK 8
-
 /**
  * struct iwl_rb_status - reserve buffer status
  * 	host memory mapped FH registers
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 2de3d9a..feb2f7e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -50,6 +50,15 @@
  */
 #define IWL_PCIE_MAX_FRAGS (IWL_NUM_OF_TBS - 3)
 
+/*
+ * RX related structures and functions
+ */
+#define RX_NUM_QUEUES 1
+#define RX_POST_REQ_ALLOC 2
+#define RX_CLAIM_REQ_ALLOC 8
+#define RX_POOL_SIZE ((RX_CLAIM_REQ_ALLOC - RX_POST_REQ_ALLOC) * RX_NUM_QUEUES)
+#define RX_LOW_WATERMARK 8
+
 struct iwl_host_cmd;
 
 /*This file includes the declaration that are internal to the
@@ -83,29 +92,29 @@ struct isr_statistics {
  * struct iwl_rxq - Rx queue
  * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
  * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
- * @pool:
- * @queue:
  * @read: Shared index to newest available Rx buffer
  * @write: Shared index to oldest written Rx packet
  * @free_count: Number of pre-allocated buffers in rx_free
+ * @used_count: Number of RBDs handled to allocator to use for allocation
  * @write_actual:
- * @rx_free: list of free SKBs for use
- * @rx_used: List of Rx buffers with no SKB
+ * @rx_free: list of RBDs with allocated RB ready for use
+ * @rx_used: list of RBDs with no RB attached
  * @need_update: flag to indicate we need to update read/write index
  * @rb_stts: driver's pointer to receive buffer status
  * @rb_stts_dma: bus address of receive buffer status
  * @lock:
+ * @pool: initial pool of iwl_rx_mem_buffer for the queue
+ * @queue: actual rx queue
  *
  * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
  */
 struct iwl_rxq {
 	__le32 *bd;
 	dma_addr_t bd_dma;
-	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
-	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
 	u32 read;
 	u32 write;
 	u32 free_count;
+	u32 used_count;
 	u32 write_actual;
 	struct list_head rx_free;
 	struct list_head rx_used;
@@ -113,6 +122,32 @@ struct iwl_rxq {
 	struct iwl_rb_status *rb_stts;
 	dma_addr_t rb_stts_dma;
 	spinlock_t lock;
+	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE];
+	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
+};
+
+/**
+ * struct iwl_rb_allocator - Rx allocator
+ * @pool: initial pool of allocator
+ * @req_pending: number of requests the allcator had not processed yet
+ * @req_ready: number of requests honored and ready for claiming
+ * @rbd_allocated: RBDs with pages allocated and ready to be handled to
+ *	the queue. This is a list of &struct iwl_rx_mem_buffer
+ * @rbd_empty: RBDs with no page attached for allocator use. This is a list
+ *	of &struct iwl_rx_mem_buffer
+ * @lock: protects the rbd_allocated and rbd_empty lists
+ * @alloc_wq: work queue for background calls
+ * @rx_alloc: work struct for background calls
+ */
+struct iwl_rb_allocator {
+	struct iwl_rx_mem_buffer pool[RX_POOL_SIZE];
+	atomic_t req_pending;
+	atomic_t req_ready;
+	struct list_head rbd_allocated;
+	struct list_head rbd_empty;
+	spinlock_t lock;
+	struct workqueue_struct *alloc_wq;
+	struct work_struct rx_alloc;
 };
 
 struct iwl_dma_ptr {
@@ -256,7 +291,7 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
 /**
  * struct iwl_trans_pcie - PCIe transport specific data
  * @rxq: all the RX queue data
- * @rx_replenish: work that will be called when buffers need to be allocated
+ * @rba: allocator for RX replenishing
  * @drv - pointer to iwl_drv
  * @trans: pointer to the generic transport area
  * @scd_base_addr: scheduler sram base address in SRAM
@@ -281,7 +316,7 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
  */
 struct iwl_trans_pcie {
 	struct iwl_rxq rxq;
-	struct work_struct rx_replenish;
+	struct iwl_rb_allocator rba;
 	struct iwl_trans *trans;
 	struct iwl_drv *drv;
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index e1af0ff..5643ace 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1,7 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -74,16 +74,29 @@
  * resets the Rx queue buffers with new memory.
  *
  * The management in the driver is as follows:
- * + A list of pre-allocated SKBs is stored in iwl->rxq->rx_free.  When
- *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
- *   to replenish the iwl->rxq->rx_free.
- * + In iwl_pcie_rx_replenish (scheduled) if 'processed' != 'read' then the
- *   iwl->rxq is replenished and the READ INDEX is updated (updating the
- *   'processed' and 'read' driver indexes as well)
+ * + A list of pre-allocated RBDs is stored in iwl->rxq->rx_free.
+ *   When the interrupt handler is called, the request is processed.
+ *   The page is either stolen - transferred to the upper layer
+ *   or reused - added immediately to the iwl->rxq->rx_free list.
+ * + When the page is stolen - the driver updates the matching queue's used
+ *   count, detaches the RBD and transfers it to the queue used list.
+ *   When there are two used RBDs - they are transferred to the allocator empty
+ *   list. Work is then scheduled for the allocator to start allocating
+ *   eight buffers.
+ *   When there are another 6 used RBDs - they are transferred to the allocator
+ *   empty list and the driver tries to claim the pre-allocated buffers and
+ *   add them to iwl->rxq->rx_free. If it fails - it continues to claim them
+ *   until ready.
+ *   When there are 8+ buffers in the free list - either from allocation or from
+ *   8 reused unstolen pages - restock is called to update the FW and indexes.
+ * + In order to make sure the allocator always has RBDs to use for allocation
+ *   the allocator has initial pool in the size of num_queues*(8-2) - the
+ *   maximum missing RBDs per allocation request (request posted with 2
+ *    empty RBDs, there is no guarantee when the other 6 RBDs are supplied).
+ *   The queues supplies the recycle of the rest of the RBDs.
  * + A received packet is processed and handed to the kernel network stack,
  *   detached from the iwl->rxq.  The driver 'processed' index is updated.
- * + The Host/Firmware iwl->rxq is replenished at irq thread time from the
- *   rx_free list. If there are no allocated buffers in iwl->rxq->rx_free,
+ * + If there are no allocated buffers in iwl->rxq->rx_free,
  *   the READ INDEX is not incremented and iwl->status(RX_STALLED) is set.
  *   If there were enough free buffers and RX_STALLED is set it is cleared.
  *
@@ -92,18 +105,32 @@
  *
  * iwl_rxq_alloc()            Allocates rx_free
  * iwl_pcie_rx_replenish()    Replenishes rx_free list from rx_used, and calls
- *                            iwl_pcie_rxq_restock
+ *                            iwl_pcie_rxq_restock.
+ *                            Used only during initialization.
  * iwl_pcie_rxq_restock()     Moves available buffers from rx_free into Rx
  *                            queue, updates firmware pointers, and updates
- *                            the WRITE index.  If insufficient rx_free buffers
- *                            are available, schedules iwl_pcie_rx_replenish
+ *                            the WRITE index.
+ * iwl_pcie_rx_allocator()     Background work for allocating pages.
  *
  * -- enable interrupts --
  * ISR - iwl_rx()             Detach iwl_rx_mem_buffers from pool up to the
  *                            READ INDEX, detaching the SKB from the pool.
  *                            Moves the packet buffer from queue to rx_used.
+ *                            Posts and claims requests to the allocator.
  *                            Calls iwl_pcie_rxq_restock to refill any empty
  *                            slots.
+ *
+ * RBD life-cycle:
+ *
+ * Init:
+ * rxq.pool -> rxq.rx_used -> rxq.rx_free -> rxq.queue
+ *
+ * Regular Receive interrupt:
+ * Page Stolen:
+ * rxq.queue -> rxq.rx_used -> allocator.rbd_empty ->
+ * allocator.rbd_allocated -> rxq.rx_free -> rxq.queue
+ * Page not Stolen:
+ * rxq.queue -> rxq.rx_free -> rxq.queue
  * ...
  *
  */
@@ -240,10 +267,6 @@ static void iwl_pcie_rxq_restock(struct iwl_trans *trans)
 		rxq->free_count--;
 	}
 	spin_unlock(&rxq->lock);
-	/* If the pre-allocated buffer pool is dropping low, schedule to
-	 * refill it */
-	if (rxq->free_count <= RX_LOW_WATERMARK)
-		schedule_work(&trans_pcie->rx_replenish);
 
 	/* If we've added more space for the firmware to place data, tell it.
 	 * Increment device's write pointer in multiples of 8. */
@@ -255,6 +278,45 @@ static void iwl_pcie_rxq_restock(struct iwl_trans *trans)
 }
 
 /*
+ * iwl_pcie_rx_alloc_page - allocates and returns a page.
+ *
+ */
+static struct page *iwl_pcie_rx_alloc_page(struct iwl_trans *trans,
+					   gfp_t priority)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rxq *rxq = &trans_pcie->rxq;
+	struct page *page;
+	gfp_t gfp_mask = priority;
+
+	if (rxq->free_count > RX_LOW_WATERMARK)
+		gfp_mask |= __GFP_NOWARN;
+
+	if (trans_pcie->rx_page_order > 0)
+		gfp_mask |= __GFP_COMP;
+
+	/* Alloc a new receive buffer */
+	page = alloc_pages(gfp_mask, trans_pcie->rx_page_order);
+	if (!page) {
+		if (net_ratelimit())
+			IWL_DEBUG_INFO(trans, "alloc_pages failed, order: %d\n",
+				       trans_pcie->rx_page_order);
+		/* Issue an error if the hardware has consumed more than half
+		 * of its free buffer list and we don't have enough
+		 * pre-allocated buffers.
+`		 */
+		if (rxq->free_count <= RX_LOW_WATERMARK &&
+		    iwl_rxq_space(rxq) > (RX_QUEUE_SIZE / 2) &&
+		    net_ratelimit())
+			IWL_CRIT(trans,
+				 "Failed to alloc_pages with GFP_KERNEL. Only %u free buffers remaining.\n",
+				 rxq->free_count);
+		return NULL;
+	}
+	return page;
+}
+
+/*
  * iwl_pcie_rxq_alloc_rbs - allocate a page for each used RBD
  *
  * A used RBD is an Rx buffer that has been given to the stack. To use it again
@@ -269,7 +331,6 @@ static void iwl_pcie_rxq_alloc_rbs(struct iwl_trans *trans, gfp_t priority)
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
 	struct iwl_rx_mem_buffer *rxb;
 	struct page *page;
-	gfp_t gfp_mask = priority;
 
 	while (1) {
 		spin_lock(&rxq->lock);
@@ -279,32 +340,10 @@ static void iwl_pcie_rxq_alloc_rbs(struct iwl_trans *trans, gfp_t priority)
 		}
 		spin_unlock(&rxq->lock);
 
-		if (rxq->free_count > RX_LOW_WATERMARK)
-			gfp_mask |= __GFP_NOWARN;
-
-		if (trans_pcie->rx_page_order > 0)
-			gfp_mask |= __GFP_COMP;
-
 		/* Alloc a new receive buffer */
-		page = alloc_pages(gfp_mask, trans_pcie->rx_page_order);
-		if (!page) {
-			if (net_ratelimit())
-				IWL_DEBUG_INFO(trans, "alloc_pages failed, "
-					   "order: %d\n",
-					   trans_pcie->rx_page_order);
-
-			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
-			    net_ratelimit())
-				IWL_CRIT(trans, "Failed to alloc_pages with %s."
-					 "Only %u free buffers remaining.\n",
-					 priority == GFP_ATOMIC ?
-					 "GFP_ATOMIC" : "GFP_KERNEL",
-					 rxq->free_count);
-			/* We don't reschedule replenish work here -- we will
-			 * call the restock method and if it still needs
-			 * more buffers it will schedule replenish */
+		page = iwl_pcie_rx_alloc_page(trans, priority);
+		if (!page)
 			return;
-		}
 
 		spin_lock(&rxq->lock);
 
@@ -355,7 +394,7 @@ static void iwl_pcie_rxq_free_rbs(struct iwl_trans *trans)
 
 	lockdep_assert_held(&rxq->lock);
 
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
+	for (i = 0; i < RX_QUEUE_SIZE; i++) {
 		if (!rxq->pool[i].page)
 			continue;
 		dma_unmap_page(trans->dev, rxq->pool[i].page_dma,
@@ -372,32 +411,164 @@ static void iwl_pcie_rxq_free_rbs(struct iwl_trans *trans)
  * When moving to rx_free an page is allocated for the slot.
  *
  * Also restock the Rx queue via iwl_pcie_rxq_restock.
- * This is called as a scheduled work item (except for during initialization)
+ * This is called only during initialization
  */
-static void iwl_pcie_rx_replenish(struct iwl_trans *trans, gfp_t gfp)
+static void iwl_pcie_rx_replenish(struct iwl_trans *trans)
 {
-	iwl_pcie_rxq_alloc_rbs(trans, gfp);
+	iwl_pcie_rxq_alloc_rbs(trans, GFP_KERNEL);
 
 	iwl_pcie_rxq_restock(trans);
 }
 
-static void iwl_pcie_rx_replenish_work(struct work_struct *data)
+/*
+ * iwl_pcie_rx_allocator - Allocates pages in the background for RX queues
+ *
+ * Allocates for each received request 8 pages
+ * Called as a scheduled work item.
+ */
+static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rb_allocator *rba = &trans_pcie->rba;
+	struct list_head local_empty;
+	int pending = atomic_xchg(&rba->req_pending, 0);
+
+	IWL_DEBUG_RX(trans, "Pending allocation requests = %d\n", pending);
+
+	/* If we were scheduled - there is at least one request */
+	spin_lock(&rba->lock);
+	/* swap out the rba->rbd_empty to a local list */
+	list_replace_init(&rba->rbd_empty, &local_empty);
+	spin_unlock(&rba->lock);
+
+	while (pending) {
+		int i;
+		struct list_head local_allocated;
+
+		INIT_LIST_HEAD(&local_allocated);
+
+		for (i = 0; i < RX_CLAIM_REQ_ALLOC;) {
+			struct iwl_rx_mem_buffer *rxb;
+			struct page *page;
+
+			/* List should never be empty - each reused RBD is
+			 * returned to the list, and initial pool covers any
+			 * possible gap between the time the page is allocated
+			 * to the time the RBD is added.
+			 */
+			BUG_ON(list_empty(&local_empty));
+			/* Get the first rxb from the rbd list */
+			rxb = list_first_entry(&local_empty,
+					       struct iwl_rx_mem_buffer, list);
+			BUG_ON(rxb->page);
+
+			/* Alloc a new receive buffer */
+			page = iwl_pcie_rx_alloc_page(trans, GFP_KERNEL);
+			if (!page)
+				continue;
+			rxb->page = page;
+
+			/* Get physical address of the RB */
+			rxb->page_dma = dma_map_page(trans->dev, page, 0,
+					PAGE_SIZE << trans_pcie->rx_page_order,
+					DMA_FROM_DEVICE);
+			if (dma_mapping_error(trans->dev, rxb->page_dma)) {
+				rxb->page = NULL;
+				__free_pages(page, trans_pcie->rx_page_order);
+				continue;
+			}
+			/* dma address must be no more than 36 bits */
+			BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
+			/* and also 256 byte aligned! */
+			BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
+
+			/* move the allocated entry to the out list */
+			list_move(&rxb->list, &local_allocated);
+			i++;
+		}
+
+		pending--;
+		if (!pending) {
+			pending = atomic_xchg(&rba->req_pending, 0);
+			IWL_DEBUG_RX(trans,
+				     "Pending allocation requests = %d\n",
+				     pending);
+		}
+
+		spin_lock(&rba->lock);
+		/* add the allocated rbds to the allocator allocated list */
+		list_splice_tail(&local_allocated, &rba->rbd_allocated);
+		/* get more empty RBDs for current pending requests */
+		list_splice_tail_init(&rba->rbd_empty, &local_empty);
+		spin_unlock(&rba->lock);
+
+		atomic_inc(&rba->req_ready);
+	}
+
+	spin_lock(&rba->lock);
+	/* return unused rbds to the allocator empty list */
+	list_splice_tail(&local_empty, &rba->rbd_empty);
+	spin_unlock(&rba->lock);
+}
+
+/*
+ * iwl_pcie_rx_allocator_get - Returns the pre-allocated pages
+.*
+.* Called by queue when the queue posted allocation request and
+ * has freed 8 RBDs in order to restock itself.
+ */
+static int iwl_pcie_rx_allocator_get(struct iwl_trans *trans,
+				     struct iwl_rx_mem_buffer
+				     *out[RX_CLAIM_REQ_ALLOC])
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rb_allocator *rba = &trans_pcie->rba;
+	int i;
+
+	/*
+	 * atomic_dec_if_positive returns req_ready - 1 for any scenario.
+	 * If req_ready is 0 atomic_dec_if_positive will return -1 and this
+	 * function will return -ENOMEM, as there are no ready requests.
+	 * atomic_dec_if_positive will perofrm the *actual* decrement only if
+	 * req_ready > 0, i.e. - there are ready requests and the function
+	 * hands one request to the caller.
+	 */
+	if (atomic_dec_if_positive(&rba->req_ready) < 0)
+		return -ENOMEM;
+
+	spin_lock(&rba->lock);
+	for (i = 0; i < RX_CLAIM_REQ_ALLOC; i++) {
+		/* Get next free Rx buffer, remove it from free list */
+		out[i] = list_first_entry(&rba->rbd_allocated,
+			       struct iwl_rx_mem_buffer, list);
+		list_del(&out[i]->list);
+	}
+	spin_unlock(&rba->lock);
+
+	return 0;
+}
+
+static void iwl_pcie_rx_allocator_work(struct work_struct *data)
 {
+	struct iwl_rb_allocator *rba_p =
+		container_of(data, struct iwl_rb_allocator, rx_alloc);
 	struct iwl_trans_pcie *trans_pcie =
-	    container_of(data, struct iwl_trans_pcie, rx_replenish);
+		container_of(rba_p, struct iwl_trans_pcie, rba);
 
-	iwl_pcie_rx_replenish(trans_pcie->trans, GFP_KERNEL);
+	iwl_pcie_rx_allocator(trans_pcie->trans);
 }
 
 static int iwl_pcie_rx_alloc(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
+	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 	struct device *dev = trans->dev;
 
 	memset(&trans_pcie->rxq, 0, sizeof(trans_pcie->rxq));
 
 	spin_lock_init(&rxq->lock);
+	spin_lock_init(&rba->lock);
 
 	if (WARN_ON(rxq->bd || rxq->rb_stts))
 		return -EINVAL;
@@ -487,15 +658,49 @@ static void iwl_pcie_rx_init_rxb_lists(struct iwl_rxq *rxq)
 	INIT_LIST_HEAD(&rxq->rx_free);
 	INIT_LIST_HEAD(&rxq->rx_used);
 	rxq->free_count = 0;
+	rxq->used_count = 0;
 
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
+	for (i = 0; i < RX_QUEUE_SIZE; i++)
 		list_add(&rxq->pool[i].list, &rxq->rx_used);
 }
 
+static void iwl_pcie_rx_init_rba(struct iwl_rb_allocator *rba)
+{
+	int i;
+
+	lockdep_assert_held(&rba->lock);
+
+	INIT_LIST_HEAD(&rba->rbd_allocated);
+	INIT_LIST_HEAD(&rba->rbd_empty);
+
+	for (i = 0; i < RX_POOL_SIZE; i++)
+		list_add(&rba->pool[i].list, &rba->rbd_empty);
+}
+
+static void iwl_pcie_rx_free_rba(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rb_allocator *rba = &trans_pcie->rba;
+	int i;
+
+	lockdep_assert_held(&rba->lock);
+
+	for (i = 0; i < RX_POOL_SIZE; i++) {
+		if (!rba->pool[i].page)
+			continue;
+		dma_unmap_page(trans->dev, rba->pool[i].page_dma,
+			       PAGE_SIZE << trans_pcie->rx_page_order,
+			       DMA_FROM_DEVICE);
+		__free_pages(rba->pool[i].page, trans_pcie->rx_page_order);
+		rba->pool[i].page = NULL;
+	}
+}
+
 int iwl_pcie_rx_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
+	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 	int i, err;
 
 	if (!rxq->bd) {
@@ -503,11 +708,21 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 		if (err)
 			return err;
 	}
+	if (!rba->alloc_wq)
+		rba->alloc_wq = alloc_workqueue("rb_allocator",
+						WQ_HIGHPRI | WQ_UNBOUND, 1);
+	INIT_WORK(&rba->rx_alloc, iwl_pcie_rx_allocator_work);
+
+	spin_lock(&rba->lock);
+	atomic_set(&rba->req_pending, 0);
+	atomic_set(&rba->req_ready, 0);
+	/* free all first - we might be reconfigured for a different size */
+	iwl_pcie_rx_free_rba(trans);
+	iwl_pcie_rx_init_rba(rba);
+	spin_unlock(&rba->lock);
 
 	spin_lock(&rxq->lock);
 
-	INIT_WORK(&trans_pcie->rx_replenish, iwl_pcie_rx_replenish_work);
-
 	/* free all first - we might be reconfigured for a different size */
 	iwl_pcie_rxq_free_rbs(trans);
 	iwl_pcie_rx_init_rxb_lists(rxq);
@@ -522,7 +737,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	memset(rxq->rb_stts, 0, sizeof(*rxq->rb_stts));
 	spin_unlock(&rxq->lock);
 
-	iwl_pcie_rx_replenish(trans, GFP_KERNEL);
+	iwl_pcie_rx_replenish(trans);
 
 	iwl_pcie_rx_hw_init(trans, rxq);
 
@@ -537,6 +752,7 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
+	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 
 	/*if rxq->bd is NULL, it means that nothing has been allocated,
 	 * exit now */
@@ -545,7 +761,15 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 		return;
 	}
 
-	cancel_work_sync(&trans_pcie->rx_replenish);
+	cancel_work_sync(&rba->rx_alloc);
+	if (rba->alloc_wq) {
+		destroy_workqueue(rba->alloc_wq);
+		rba->alloc_wq = NULL;
+	}
+
+	spin_lock(&rba->lock);
+	iwl_pcie_rx_free_rba(trans);
+	spin_unlock(&rba->lock);
 
 	spin_lock(&rxq->lock);
 	iwl_pcie_rxq_free_rbs(trans);
@@ -566,8 +790,49 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 	rxq->rb_stts = NULL;
 }
 
+/*
+ * iwl_pcie_rx_reuse_rbd - Recycle used RBDs
+ *
+ * Called when a RBD can be reused. The RBD is transferred to the allocator.
+ * When there are 2 empty RBDs - a request for allocation is posted
+ */
+static void iwl_pcie_rx_reuse_rbd(struct iwl_trans *trans,
+				  struct iwl_rx_mem_buffer *rxb,
+				  struct iwl_rxq *rxq, bool emergency)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rb_allocator *rba = &trans_pcie->rba;
+
+	/* Move the RBD to the used list, will be moved to allocator in batches
+	 * before claiming or posting a request*/
+	list_add_tail(&rxb->list, &rxq->rx_used);
+
+	if (unlikely(emergency))
+		return;
+
+	/* Count the allocator owned RBDs */
+	rxq->used_count++;
+
+	/* If we have RX_POST_REQ_ALLOC new released rx buffers -
+	 * issue a request for allocator. Modulo RX_CLAIM_REQ_ALLOC is
+	 * used for the case we failed to claim RX_CLAIM_REQ_ALLOC,
+	 * after but we still need to post another request.
+	 */
+	if ((rxq->used_count % RX_CLAIM_REQ_ALLOC) == RX_POST_REQ_ALLOC) {
+		/* Move the 2 RBDs to the allocator ownership.
+		 Allocator has another 6 from pool for the request completion*/
+		spin_lock(&rba->lock);
+		list_splice_tail_init(&rxq->rx_used, &rba->rbd_empty);
+		spin_unlock(&rba->lock);
+
+		atomic_inc(&rba->req_pending);
+		queue_work(rba->alloc_wq, &rba->rx_alloc);
+	}
+}
+
 static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
-				struct iwl_rx_mem_buffer *rxb)
+				struct iwl_rx_mem_buffer *rxb,
+				bool emergency)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
@@ -682,13 +947,13 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 			 */
 			__free_pages(rxb->page, trans_pcie->rx_page_order);
 			rxb->page = NULL;
-			list_add_tail(&rxb->list, &rxq->rx_used);
+			iwl_pcie_rx_reuse_rbd(trans, rxb, rxq, emergency);
 		} else {
 			list_add_tail(&rxb->list, &rxq->rx_free);
 			rxq->free_count++;
 		}
 	} else
-		list_add_tail(&rxb->list, &rxq->rx_used);
+		iwl_pcie_rx_reuse_rbd(trans, rxb, rxq, emergency);
 }
 
 /*
@@ -698,10 +963,8 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
-	u32 r, i;
-	u8 fill_rx = 0;
-	u32 count = 8;
-	int total_empty;
+	u32 r, i, j, count = 0;
+	bool emergency = false;
 
 restart:
 	spin_lock(&rxq->lock);
@@ -714,47 +977,95 @@ restart:
 	if (i == r)
 		IWL_DEBUG_RX(trans, "HW = SW = %d\n", r);
 
-	/* calculate total frames need to be restock after handling RX */
-	total_empty = r - rxq->write_actual;
-	if (total_empty < 0)
-		total_empty += RX_QUEUE_SIZE;
-
-	if (total_empty > (RX_QUEUE_SIZE / 2))
-		fill_rx = 1;
-
 	while (i != r) {
 		struct iwl_rx_mem_buffer *rxb;
 
+		if (unlikely(rxq->used_count == RX_QUEUE_SIZE / 2))
+			emergency = true;
+
 		rxb = rxq->queue[i];
 		rxq->queue[i] = NULL;
 
 		IWL_DEBUG_RX(trans, "rxbuf: HW = %d, SW = %d (%p)\n",
 			     r, i, rxb);
-		iwl_pcie_rx_handle_rb(trans, rxb);
+		iwl_pcie_rx_handle_rb(trans, rxb, emergency);
 
 		i = (i + 1) & RX_QUEUE_MASK;
-		/* If there are a lot of unused frames,
-		 * restock the Rx queue so ucode wont assert. */
-		if (fill_rx) {
+
+		/* If we have RX_CLAIM_REQ_ALLOC released rx buffers -
+		 * try to claim the pre-allocated buffers from the allocator */
+		if (rxq->used_count >= RX_CLAIM_REQ_ALLOC) {
+			struct iwl_rb_allocator *rba = &trans_pcie->rba;
+			struct iwl_rx_mem_buffer *out[RX_CLAIM_REQ_ALLOC];
+
+			if (rxq->used_count % RX_CLAIM_REQ_ALLOC == 0 &&
+			    !emergency) {
+				/* Add the remaining 6 empty RBDs
+				* for allocator use
+				 */
+				spin_lock(&rba->lock);
+				list_splice_tail_init(&rxq->rx_used,
+						      &rba->rbd_empty);
+				spin_unlock(&rba->lock);
+			}
+
+			/* If not ready - continue, will try to reclaim later.
+			* No need to reschedule work - allocator exits only on
+			* success */
+			if (!iwl_pcie_rx_allocator_get(trans, out)) {
+				/* If success - then RX_CLAIM_REQ_ALLOC
+				 * buffers were retrieved and should be added
+				 * to free list */
+				rxq->used_count -= RX_CLAIM_REQ_ALLOC;
+				for (j = 0; j < RX_CLAIM_REQ_ALLOC; j++) {
+					list_add_tail(&out[j]->list,
+						      &rxq->rx_free);
+					rxq->free_count++;
+				}
+			}
+		}
+		if (emergency) {
 			count++;
-			if (count >= 8) {
-				rxq->read = i;
-				spin_unlock(&rxq->lock);
-				iwl_pcie_rx_replenish(trans, GFP_ATOMIC);
+			if (count == 8) {
 				count = 0;
-				goto restart;
+				if (rxq->used_count < RX_QUEUE_SIZE / 3)
+					emergency = false;
+				spin_unlock(&rxq->lock);
+				iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC);
+				spin_lock(&rxq->lock);
 			}
 		}
+		/* handle restock for three cases, can be all of them at once:
+		* - we just pulled buffers from the allocator
+		* - we have 8+ unstolen pages accumulated
+		* - we are in emergency and allocated buffers
+		 */
+		if (rxq->free_count >=  RX_CLAIM_REQ_ALLOC) {
+			rxq->read = i;
+			spin_unlock(&rxq->lock);
+			iwl_pcie_rxq_restock(trans);
+			goto restart;
+		}
 	}
 
 	/* Backtrack one entry */
 	rxq->read = i;
 	spin_unlock(&rxq->lock);
 
-	if (fill_rx)
-		iwl_pcie_rx_replenish(trans, GFP_ATOMIC);
-	else
-		iwl_pcie_rxq_restock(trans);
+	/*
+	 * handle a case where in emergency there are some unallocated RBDs.
+	 * those RBDs are in the used list, but are not tracked by the queue's
+	 * used_count which counts allocator owned RBDs.
+	 * unallocated emergency RBDs must be allocated on exit, otherwise
+	 * when called again the function may not be in emergency mode and
+	 * they will be handed to the allocator with no tracking in the RBD
+	 * allocator counters, which will lead to them never being claimed back
+	 * by the queue.
+	 * by allocating them here, they are now in the queue free list, and
+	 * will be restocked by the next call of iwl_pcie_rxq_restock.
+	 */
+	if (unlikely(emergency && count))
+		iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC);
 
 	if (trans_pcie->napi.poll)
 		napi_gro_flush(&trans_pcie->napi, false);
-- 
2.1.4

