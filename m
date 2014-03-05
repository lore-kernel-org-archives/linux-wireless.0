Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbaCEML1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:11:27 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: [RFC/RFT 9/9] iwlegacy: rework rx buffers allocation
Date: Wed,  5 Mar 2014 13:13:34 +0100
Message-Id: <1394021614-11514-10-git-send-email-sgruszka@redhat.com> (sfid-20140305_131709_038439_70CE5A0D)
In-Reply-To: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
References: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This big patch removes most of current rx allocation algorithm.

To avoid firmware microcode errors driver has to assure that there is
always free space on RX queue. Current implementation works well, except
situation when system is overloaded, we can not provide buffers to RX
queue fast enough (not even due to allocation errors, but due to
delays, what happens usually on slow boxes).

Patch vastly simplify RX allocation algorithm, based on observation that
we can always reuse allocated pages, except when we have to pass them to
mac80211 (we receive new frame). In the last situation we allocate new
RX buffer and replace it. If there is no memory we just drop the frame,
what assures (once initialized) we always have available buffers in
the RX queue.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c | 461 +++++--------------------------
 drivers/net/wireless/iwlegacy/3945.c     |  41 +--
 drivers/net/wireless/iwlegacy/3945.h     |   3 +-
 drivers/net/wireless/iwlegacy/4965-mac.c | 404 ++++-----------------------
 drivers/net/wireless/iwlegacy/4965.h     |   6 +-
 drivers/net/wireless/iwlegacy/common.c   | 223 +++++++++++----
 drivers/net/wireless/iwlegacy/common.h   |  41 +--
 drivers/net/wireless/iwlegacy/debug.c    |   3 -
 8 files changed, 311 insertions(+), 871 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index de531e7..3b574f6 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -864,294 +864,6 @@ il3945_setup_handlers(struct il_priv *il)
 	il3945_hw_handler_setup(il);
 }
 
-/************************** RX-FUNCTIONS ****************************/
-/*
- * Rx theory of operation
- *
- * The host allocates 32 DMA target addresses and passes the host address
- * to the firmware at register IL_RFDS_TBL_LOWER + N * RFD_SIZE where N is
- * 0 to 31
- *
- * Rx Queue Indexes
- * The host/firmware share two idx registers for managing the Rx buffers.
- *
- * The READ idx maps to the first position that the firmware may be writing
- * to -- the driver can read up to (but not including) this position and get
- * good data.
- * The READ idx is managed by the firmware once the card is enabled.
- *
- * The WRITE idx maps to the last position the driver has read from -- the
- * position preceding WRITE is the last slot the firmware can place a packet.
- *
- * The queue is empty (no good data) if WRITE = READ - 1, and is full if
- * WRITE = READ.
- *
- * During initialization, the host sets up the READ queue position to the first
- * IDX position, and WRITE to the last (READ - 1 wrapped)
- *
- * When the firmware places a packet in a buffer, it will advance the READ idx
- * and fire the RX interrupt.  The driver can then query the READ idx and
- * process as many packets as possible, moving the WRITE idx forward as it
- * resets the Rx queue buffers with new memory.
- *
- * The management in the driver is as follows:
- * + A list of pre-allocated SKBs is stored in iwl->rxq->rx_free.  When
- *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
- *   to replenish the iwl->rxq->rx_free.
- * + In il3945_rx_replenish (scheduled) if 'processed' != 'read' then the
- *   iwl->rxq is replenished and the READ IDX is updated (updating the
- *   'processed' and 'read' driver idxes as well)
- * + A received packet is processed and handed to the kernel network stack,
- *   detached from the iwl->rxq.  The driver 'processed' idx is updated.
- * + The Host/Firmware iwl->rxq is replenished at tasklet time from the rx_free
- *   list. If there are no allocated buffers in iwl->rxq->rx_free, the READ
- *   IDX is not incremented and iwl->status(RX_STALLED) is set.  If there
- *   were enough free buffers and RX_STALLED is set it is cleared.
- *
- *
- * Driver sequence:
- *
- * il3945_rx_replenish()     Replenishes rx_free list from rx_used, and calls
- *                            il3945_rx_queue_restock
- * il3945_rx_queue_restock() Moves available buffers from rx_free into Rx
- *                            queue, updates firmware pointers, and updates
- *                            the WRITE idx.  If insufficient rx_free buffers
- *                            are available, schedules il3945_rx_replenish
- *
- * -- enable interrupts --
- * ISR - il3945_rx()         Detach il_rx_bufs from pool up to the
- *                            READ IDX, detaching the SKB from the pool.
- *                            Moves the packet buffer from queue to rx_used.
- *                            Calls il3945_rx_queue_restock to refill any empty
- *                            slots.
- * ...
- *
- */
-
-/**
- * il3945_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
- */
-static inline __le32
-il3945_dma_addr2rbd_ptr(struct il_priv *il, dma_addr_t dma_addr)
-{
-	return cpu_to_le32((u32) dma_addr);
-}
-
-/**
- * il3945_rx_queue_restock - refill RX queue from pre-allocated pool
- *
- * If there are slots in the RX queue that need to be restocked,
- * and we have free pre-allocated buffers, fill the ranks as much
- * as we can, pulling from rx_free.
- *
- * This moves the 'write' idx forward to catch up with 'processed', and
- * also updates the memory address in the firmware to reference the new
- * target buffer.
- */
-static void
-il3945_rx_queue_restock(struct il_priv *il)
-{
-	struct il_rx_queue *rxq = &il->rxq;
-	struct list_head *element;
-	struct il_rx_buf *rxb;
-	unsigned long flags;
-	int write;
-
-	spin_lock_irqsave(&rxq->lock, flags);
-	write = rxq->write & ~0x7;
-	while (il_rx_queue_space(rxq) > 0 && rxq->free_count) {
-		/* Get next free Rx buffer, remove from free list */
-		element = rxq->rx_free.next;
-		rxb = list_entry(element, struct il_rx_buf, list);
-		list_del(element);
-
-		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] =
-		    il3945_dma_addr2rbd_ptr(il, rxb->page_dma);
-		rxq->queue[rxq->write] = rxb;
-		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
-		rxq->free_count--;
-	}
-	spin_unlock_irqrestore(&rxq->lock, flags);
-	/* If the pre-allocated buffer pool is dropping low, schedule to
-	 * refill it */
-	if (rxq->free_count <= RX_LOW_WATERMARK)
-		queue_work(il->workqueue, &il->rx_replenish);
-
-	/* If we've added more space for the firmware to place data, tell it.
-	 * Increment device's write pointer in multiples of 8. */
-	if (rxq->write_actual != (rxq->write & ~0x7) ||
-	    abs(rxq->write - rxq->read) > 7) {
-		spin_lock_irqsave(&rxq->lock, flags);
-		rxq->need_update = 1;
-		spin_unlock_irqrestore(&rxq->lock, flags);
-		il_rx_queue_update_write_ptr(il, rxq);
-	}
-}
-
-/**
- * il3945_rx_replenish - Move all used packet from rx_used to rx_free
- *
- * When moving to rx_free an SKB is allocated for the slot.
- *
- * Also restock the Rx queue via il3945_rx_queue_restock.
- * This is called as a scheduled work item (except for during initialization)
- */
-static void
-il3945_rx_allocate(struct il_priv *il, gfp_t priority)
-{
-	struct il_rx_queue *rxq = &il->rxq;
-	struct list_head *element;
-	struct il_rx_buf *rxb;
-	struct page *page;
-	dma_addr_t page_dma;
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
-		if (il->hw_params.rx_page_order > 0)
-			gfp_mask |= __GFP_COMP;
-
-		/* Alloc a new receive buffer */
-		page = alloc_pages(gfp_mask, il->hw_params.rx_page_order);
-		if (!page) {
-			if (net_ratelimit())
-				D_INFO("Failed to allocate SKB buffer.\n");
-			if (rxq->free_count <= RX_LOW_WATERMARK &&
-			    net_ratelimit())
-				IL_ERR("Failed to allocate SKB buffer with %0x."
-				       "Only %u free buffers remaining.\n",
-				       priority, rxq->free_count);
-			/* We don't reschedule replenish work here -- we will
-			 * call the restock method and if it still needs
-			 * more buffers it will schedule replenish */
-			break;
-		}
-
-		/* Get physical address of RB/SKB */
-		page_dma =
-		    pci_map_page(il->pci_dev, page, 0,
-				 PAGE_SIZE << il->hw_params.rx_page_order,
-				 PCI_DMA_FROMDEVICE);
-
-		if (unlikely(pci_dma_mapping_error(il->pci_dev, page_dma))) {
-			__free_pages(page, il->hw_params.rx_page_order);
-			break;
-		}
-
-		spin_lock_irqsave(&rxq->lock, flags);
-
-		if (list_empty(&rxq->rx_used)) {
-			spin_unlock_irqrestore(&rxq->lock, flags);
-			pci_unmap_page(il->pci_dev, page_dma,
-				       PAGE_SIZE << il->hw_params.rx_page_order,
-				       PCI_DMA_FROMDEVICE);
-			__free_pages(page, il->hw_params.rx_page_order);
-			return;
-		}
-
-		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct il_rx_buf, list);
-		list_del(element);
-
-		rxb->page = page;
-		rxb->page_dma = page_dma;
-		list_add_tail(&rxb->list, &rxq->rx_free);
-		rxq->free_count++;
-		il->alloc_rxb_page++;
-
-		spin_unlock_irqrestore(&rxq->lock, flags);
-	}
-}
-
-void
-il3945_rx_queue_reset(struct il_priv *il, struct il_rx_queue *rxq)
-{
-	unsigned long flags;
-	int i;
-	spin_lock_irqsave(&rxq->lock, flags);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
-	/* Fill the rx_used queue with _all_ of the Rx buffers */
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
-		/* In the reset function, these buffers may have been allocated
-		 * to an SKB, so we need to unmap and free potential storage */
-		if (rxq->pool[i].page != NULL) {
-			pci_unmap_page(il->pci_dev, rxq->pool[i].page_dma,
-				       PAGE_SIZE << il->hw_params.rx_page_order,
-				       PCI_DMA_FROMDEVICE);
-			__il_free_pages(il, rxq->pool[i].page);
-			rxq->pool[i].page = NULL;
-		}
-		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-	}
-
-	/* Set us so that we have processed and used all buffers, but have
-	 * not restocked the Rx queue with fresh buffers */
-	rxq->read = rxq->write = 0;
-	rxq->write_actual = 0;
-	rxq->free_count = 0;
-	spin_unlock_irqrestore(&rxq->lock, flags);
-}
-
-void
-il3945_rx_replenish(void *data)
-{
-	struct il_priv *il = data;
-	unsigned long flags;
-
-	il3945_rx_allocate(il, GFP_KERNEL);
-
-	spin_lock_irqsave(&il->lock, flags);
-	il3945_rx_queue_restock(il);
-	spin_unlock_irqrestore(&il->lock, flags);
-}
-
-static void
-il3945_rx_replenish_now(struct il_priv *il)
-{
-	il3945_rx_allocate(il, GFP_ATOMIC);
-
-	il3945_rx_queue_restock(il);
-}
-
-/* Assumes that the skb field of the buffers in 'pool' is kept accurate.
- * If an SKB has been detached, the POOL needs to have its SKB set to NULL
- * This free routine walks the list of POOL entries and if SKB is set to
- * non NULL it is unmapped and freed
- */
-static void
-il3945_rx_queue_free(struct il_priv *il, struct il_rx_queue *rxq)
-{
-	int i;
-	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
-		if (rxq->pool[i].page != NULL) {
-			pci_unmap_page(il->pci_dev, rxq->pool[i].page_dma,
-				       PAGE_SIZE << il->hw_params.rx_page_order,
-				       PCI_DMA_FROMDEVICE);
-			__il_free_pages(il, rxq->pool[i].page);
-			rxq->pool[i].page = NULL;
-		}
-	}
-
-	dma_free_coherent(&il->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			  rxq->bd_dma);
-	dma_free_coherent(&il->pci_dev->dev, sizeof(struct il_rb_status),
-			  rxq->rb_stts, rxq->rb_stts_dma);
-	rxq->bd = NULL;
-	rxq->rb_stts = NULL;
-}
-
 /* Convert linear signal-to-noise ratio into dB */
 static u8 ratio2dB[100] = {
 /*	 0   1   2   3   4   5   6   7   8   9 */
@@ -1190,6 +902,34 @@ il3945_calc_db_from_ratio(int sig_ratio)
 	return (int)ratio2dB[sig_ratio];
 }
 
+void
+il3945_rx_queue_update(struct il_priv *il)
+{
+	struct il_rx_queue *rxq = &il->rxq;
+	struct il_rx_buf *rxb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rxq->lock, flags);
+
+	while (il_rx_queue_space(rxq) > 0) {
+		rxb = &rxq->queue[rxq->write];
+		rxq->bd[rxq->write] = cpu_to_le32((u32)rxb->page_dma);
+		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
+	}
+
+	/* If we've added more space for the firmware to place data, tell it.
+	 * Increment device's write pointer in multiples of 8.
+	 */
+	if (rxq->write_actual != (rxq->write & ~0x7) ||
+	    abs(rxq->write - rxq->read) > 7) {
+		rxq->need_update = 1;
+		il_rx_queue_update_write_ptr(il, rxq);
+	}
+
+	spin_unlock_irqrestore(&rxq->lock, flags);
+}
+
+
 /**
  * il3945_rx_handle - Main entry function for receiving responses from uCode
  *
@@ -1204,123 +944,68 @@ il3945_rx_handle(struct il_priv *il)
 	struct il_rx_pkt *pkt;
 	struct il_rx_queue *rxq = &il->rxq;
 	u32 r, i;
-	int reclaim;
-	unsigned long flags;
-	u8 fill_rx = 0;
-	u32 count = 8;
-	int total_empty = 0;
+	u32 count = 0;
 
 	/* uCode's read idx (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
 	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) & 0x0FFF;
 	i = rxq->read;
 
-	/* calculate total frames need to be restock after handling RX */
-	total_empty = r - rxq->write_actual;
-	if (total_empty < 0)
-		total_empty += RX_QUEUE_SIZE;
-
-	if (total_empty > (RX_QUEUE_SIZE / 2))
-		fill_rx = 1;
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
 		D_RX("r = %d, i = %d\n", r, i);
 
 	while (i != r) {
-		rxb = rxq->queue[i];
-
-		/* If an RXB doesn't have a Rx queue slot associated with it,
-		 * then a bug has been introduced in the queue refilling
-		 * routines -- catch it here */
-		BUG_ON(rxb == NULL);
-
-		rxq->queue[i] = NULL;
-
-		pci_unmap_page(il->pci_dev, rxb->page_dma,
-			       PAGE_SIZE << il->hw_params.rx_page_order,
-			       PCI_DMA_FROMDEVICE);
+		rxb = &rxq->queue[i];
 		pkt = rxb_addr(rxb);
 
-		reclaim = il_need_reclaim(il, pkt);
+		pci_dma_sync_single_for_cpu(il->pci_dev, rxb->page_dma,
+					    IL_RX_PG_SIZE(il),
+					    PCI_DMA_FROMDEVICE);
+
+		D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
+		     il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 
 		if (pkt->hdr.cmd == N_3945_RX) {
-			D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
-			     il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			il3945_data_rx(il, rxb);
-		} else if (il->handlers[pkt->hdr.cmd]) {
-			/* Based on type of command response or notification,
-			 * handle those that need handling via function in
-			 * handlers table. See il3945_setup_handlers()
-			 */
-			D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
-			     il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
-			il->isr_stats.handlers[pkt->hdr.cmd]++;
-			il->handlers[pkt->hdr.cmd] (il, pkt);
+			/* DMA sync for device or unmap is done data rx code. */
 		} else {
-			/* No handling needed */
-			D_RX("r %d i %d No handler needed for %s, 0x%02x\n", r,
-			     i, il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
-		}
-
-		/*
-		 * XXX: After here, we should always check rxb->page
-		 * against NULL before touching it or its virtual
-		 * memory (pkt). Because some handler might have
-		 * already taken or freed the pages.
-		 */
+			if (il->handlers[pkt->hdr.cmd]) {
+				/* Based on type of command response or
+				 * notification, handle those that need handling
+				 * via function in handlers table.
+				 * See il3945_setup_handlers().
+				 */
+				il->isr_stats.handlers[pkt->hdr.cmd]++;
+				il->handlers[pkt->hdr.cmd] (il, pkt);
+			}
 
-		if (reclaim) {
-			/* Invoke any callbacks, transfer the buffer to caller,
-			 * and fire off the (possibly) blocking il_send_cmd()
-			 * as we reclaim the driver command queue */
-			if (rxb->page)
+			if (il_need_reclaim(il, pkt)) {
+				/* Invoke any callbacks, transfer the buffer
+				 * to caller, and fire off the (possibly)
+				 * blocking il_send_cmd().
+				 */
 				il_tx_cmd_complete(il, pkt);
-			else
-				IL_WARN("Claim null rxb?\n");
-		}
-
-		/* Reuse the page if possible. For notification packets and
-		 * SKBs that fail to Rx correctly, add them back into the
-		 * rx_free list for reuse later. */
-		spin_lock_irqsave(&rxq->lock, flags);
-		if (rxb->page != NULL) {
-			rxb->page_dma =
-			    pci_map_page(il->pci_dev, rxb->page, 0,
-					 PAGE_SIZE << il->hw_params.
-					 rx_page_order, PCI_DMA_FROMDEVICE);
-			if (unlikely(pci_dma_mapping_error(il->pci_dev,
-							   rxb->page_dma))) {
-				__il_free_pages(il, rxb->page);
-				rxb->page = NULL;
-				list_add_tail(&rxb->list, &rxq->rx_used);
-			} else {
-				list_add_tail(&rxb->list, &rxq->rx_free);
-				rxq->free_count++;
 			}
-		} else
-			list_add_tail(&rxb->list, &rxq->rx_used);
 
-		spin_unlock_irqrestore(&rxq->lock, flags);
+			pci_dma_sync_single_for_device(il->pci_dev,
+						       rxb->page_dma,
+						       IL_RX_PG_SIZE(il),
+						       PCI_DMA_FROMDEVICE);
+		}
 
 		i = (i + 1) & RX_QUEUE_MASK;
-		/* If there are a lot of unused frames,
-		 * restock the Rx queue so ucode won't assert. */
-		if (fill_rx) {
-			count++;
-			if (count >= 8) {
-				rxq->read = i;
-				il3945_rx_replenish_now(il);
-				count = 0;
-			}
+
+		if (++count >= 8) {
+			rxq->read = i;
+			il3945_rx_queue_update(il);
+			count = 0;
 		}
 	}
 
-	/* Backtrack one entry */
 	rxq->read = i;
-	if (fill_rx)
-		il3945_rx_replenish_now(il);
-	else
-		il3945_rx_queue_restock(il);
+	if (count != 0)
+		il3945_rx_queue_update(il);
 }
 
 /* call this function to flush any scheduled tasklet */
@@ -1485,7 +1170,9 @@ il3945_irq_tasklet(struct il_priv *il)
 	/* uCode wakes up after power-down sleep */
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		D_ISR("Wakeup interrupt\n");
+		spin_lock_irqsave(&il->rxq.lock, flags);
 		il_rx_queue_update_write_ptr(il, &il->rxq);
+		spin_unlock_irqrestore(&il->rxq.lock, flags);
 
 		spin_lock_irqsave(&il->lock, flags);
 		il_txq_update_write_ptr(il, &il->txq[0]);
@@ -2705,20 +2392,6 @@ il3945_bg_restart(struct work_struct *data)
 	}
 }
 
-static void
-il3945_bg_rx_replenish(struct work_struct *data)
-{
-	struct il_priv *il = container_of(data, struct il_priv, rx_replenish);
-
-	mutex_lock(&il->mutex);
-	if (test_bit(S_EXIT_PENDING, &il->status))
-		goto out;
-
-	il3945_rx_replenish(il);
-out:
-	mutex_unlock(&il->mutex);
-}
-
 void
 il3945_post_associate(struct il_priv *il)
 {
@@ -3418,7 +3091,6 @@ il3945_setup_deferred_work(struct il_priv *il)
 	init_waitqueue_head(&il->wait_command_queue);
 
 	INIT_WORK(&il->restart, il3945_bg_restart);
-	INIT_WORK(&il->rx_replenish, il3945_bg_rx_replenish);
 	INIT_DELAYED_WORK(&il->init_alive_start, il3945_bg_init_alive_start);
 	INIT_DELAYED_WORK(&il->alive_start, il3945_bg_alive_start);
 	INIT_DELAYED_WORK(&il->_3945.rfkill_poll, il3945_rfkill_poll);
@@ -3858,8 +3530,7 @@ il3945_pci_remove(struct pci_dev *pdev)
 
 	il3945_dealloc_ucode_pci(il);
 
-	if (il->rxq.bd)
-		il3945_rx_queue_free(il, &il->rxq);
+	il_rx_queue_free(il);
 	il3945_hw_txq_ctx_free(il);
 
 	il3945_unset_hw_params(il);
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 80a2c6c..b302b1c 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -470,8 +470,6 @@ il3945_is_network_packet(struct il_priv *il, struct ieee80211_hdr *header)
 	}
 }
 
-#define SMALL_PACKET_SIZE 256
-
 static void
 il3945_pass_packet_to_mac80211(struct il_priv *il, struct il_rx_buf *rxb,
 			       struct ieee80211_rx_status *stats)
@@ -481,12 +479,9 @@ il3945_pass_packet_to_mac80211(struct il_priv *il, struct il_rx_buf *rxb,
 	struct il3945_rx_frame_hdr *rx_hdr = IL_RX_HDR(pkt);
 	struct il3945_rx_frame_end *rx_end = IL_RX_END(pkt);
 	u32 len = le16_to_cpu(rx_hdr->len);
-	struct sk_buff *skb;
-	__le16 fc = hdr->frame_control;
-	u32 fraglen = PAGE_SIZE << il->hw_params.rx_page_order;
 
 	/* We received data from the HW, so stop the watchdog */
-	if (unlikely(len + IL39_RX_FRAME_SIZE > fraglen)) {
+	if (unlikely(len + IL39_RX_FRAME_SIZE > IL_RX_PG_SIZE(il))) {
 		D_DROP("Corruption detected!\n");
 		return;
 	}
@@ -502,32 +497,11 @@ il3945_pass_packet_to_mac80211(struct il_priv *il, struct il_rx_buf *rxb,
 		D_INFO("Woke queues - frame received on passive channel\n");
 	}
 
-	skb = dev_alloc_skb(SMALL_PACKET_SIZE);
-	if (!skb) {
-		IL_ERR("dev_alloc_skb failed\n");
-		return;
-	}
-
 	if (!il3945_mod_params.sw_crypto)
-		il_set_decrypted_flag(il, (struct ieee80211_hdr *)pkt,
-				      le32_to_cpu(rx_end->status), stats);
+		il_set_decrypted_flag(il, hdr, le32_to_cpu(rx_end->status),
+				      stats);
 
-	/* If frame is small enough to fit into skb->head, copy it
-	 * and do not consume a full page
-	 */
-	if (len <= SMALL_PACKET_SIZE) {
-		memcpy(skb_put(skb, len), rx_hdr->payload, len);
-	} else {
-		skb_add_rx_frag(skb, 0, rxb->page,
-				(void *)rx_hdr->payload - (void *)pkt, len,
-				fraglen);
-		il->alloc_rxb_page--;
-		rxb->page = NULL;
-	}
-	il_update_stats(il, false, fc, len);
-	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
-
-	ieee80211_rx(il->hw, skb);
+	il_pass_packet_to_mac80211(il, rxb, hdr, len, stats);
 }
 
 #define IL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
@@ -981,10 +955,11 @@ il3945_hw_nic_init(struct il_priv *il)
 			IL_ERR("Unable to initialize Rx queue\n");
 			return -ENOMEM;
 		}
-	} else
-		il3945_rx_queue_reset(il, rxq);
+	} else {
+		il_rx_queue_reset(il);
+	}
 
-	il3945_rx_replenish(il);
+	il3945_rx_queue_update(il);
 
 	il3945_rx_init(il, rxq);
 
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index d4380fa..aca2684 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -190,8 +190,7 @@ struct il3945_ibss_seq {
  *
  *****************************************************************************/
 int il3945_calc_db_from_ratio(int sig_ratio);
-void il3945_rx_replenish(void *data);
-void il3945_rx_queue_reset(struct il_priv *il, struct il_rx_queue *rxq);
+void il3945_rx_queue_update(struct il_priv *il);
 unsigned int il3945_fill_beacon_frame(struct il_priv *il,
 				      struct ieee80211_hdr *hdr, int left);
 int il3945_dump_nic_event_log(struct il_priv *il, bool full_log, char **buf,
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 8677652..bbc824c 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -96,39 +96,6 @@ struct il_mod_params il4965_mod_params = {
 	/* the rest are 0 by default */
 };
 
-void
-il4965_rx_queue_reset(struct il_priv *il, struct il_rx_queue *rxq)
-{
-	unsigned long flags;
-	int i;
-	spin_lock_irqsave(&rxq->lock, flags);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
-	/* Fill the rx_used queue with _all_ of the Rx buffers */
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
-		/* In the reset function, these buffers may have been allocated
-		 * to an SKB, so we need to unmap and free potential storage */
-		if (rxq->pool[i].page != NULL) {
-			pci_unmap_page(il->pci_dev, rxq->pool[i].page_dma,
-				       PAGE_SIZE << il->hw_params.rx_page_order,
-				       PCI_DMA_FROMDEVICE);
-			__il_free_pages(il, rxq->pool[i].page);
-			rxq->pool[i].page = NULL;
-		}
-		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-	}
-
-	for (i = 0; i < RX_QUEUE_SIZE; i++)
-		rxq->queue[i] = NULL;
-
-	/* Set us so that we have processed and used all buffers, but have
-	 * not restocked the Rx queue with fresh buffers */
-	rxq->read = rxq->write = 0;
-	rxq->write_actual = 0;
-	rxq->free_count = 0;
-	spin_unlock_irqrestore(&rxq->lock, flags);
-}
-
 int
 il4965_rx_init(struct il_priv *il, struct il_rx_queue *rxq)
 {
@@ -214,19 +181,17 @@ il4965_hw_nic_init(struct il_priv *il)
 			IL_ERR("Unable to initialize Rx queue\n");
 			return -ENOMEM;
 		}
-	} else
-		il4965_rx_queue_reset(il, rxq);
-
-	il4965_rx_replenish(il);
+	} else {
+		il_rx_queue_reset(il);
+	}
 
+	il4965_rx_queue_update(il);
 	il4965_rx_init(il, rxq);
 
-	spin_lock_irqsave(&il->lock, flags);
-
+	spin_lock_irqsave(&rxq->lock, flags);
 	rxq->need_update = 1;
 	il_rx_queue_update_write_ptr(il, rxq);
-
-	spin_unlock_irqrestore(&il->lock, flags);
+	spin_unlock_irqrestore(&rxq->lock, flags);
 
 	/* Allocate or reset and init all Tx and Command queues */
 	if (!il->txq) {
@@ -242,202 +207,34 @@ il4965_hw_nic_init(struct il_priv *il)
 }
 
 /**
- * il4965_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
- */
-static inline __le32
-il4965_dma_addr2rbd_ptr(struct il_priv *il, dma_addr_t dma_addr)
-{
-	return cpu_to_le32((u32) (dma_addr >> 8));
-}
-
-/**
- * il4965_rx_queue_restock - refill RX queue from pre-allocated pool
- *
- * If there are slots in the RX queue that need to be restocked,
- * and we have free pre-allocated buffers, fill the ranks as much
- * as we can, pulling from rx_free.
+ * il4965_rx_queue_update - update RX queue for ucode
  *
- * This moves the 'write' idx forward to catch up with 'processed', and
- * also updates the memory address in the firmware to reference the new
- * target buffer.
+ * Provide new page_dma addresses to the firmware (if they changed) and update
+ * write pointer.
  */
 void
-il4965_rx_queue_restock(struct il_priv *il)
+il4965_rx_queue_update(struct il_priv *il)
 {
 	struct il_rx_queue *rxq = &il->rxq;
-	struct list_head *element;
 	struct il_rx_buf *rxb;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rxq->lock, flags);
-	while (il_rx_queue_space(rxq) > 0 && rxq->free_count) {
-		/* The overwritten rxb must be a used one */
-		rxb = rxq->queue[rxq->write];
-		BUG_ON(rxb && rxb->page);
-
-		/* Get next free Rx buffer, remove from free list */
-		element = rxq->rx_free.next;
-		rxb = list_entry(element, struct il_rx_buf, list);
-		list_del(element);
 
-		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] =
-		    il4965_dma_addr2rbd_ptr(il, rxb->page_dma);
-		rxq->queue[rxq->write] = rxb;
+	while (il_rx_queue_space(rxq) > 0) {
+		rxb = &rxq->queue[rxq->write];
+		rxq->bd[rxq->write] = cpu_to_le32((u32)(rxb->page_dma >> 8));
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
-		rxq->free_count--;
 	}
-	spin_unlock_irqrestore(&rxq->lock, flags);
-	/* If the pre-allocated buffer pool is dropping low, schedule to
-	 * refill it */
-	if (rxq->free_count <= RX_LOW_WATERMARK)
-		queue_work(il->workqueue, &il->rx_replenish);
 
 	/* If we've added more space for the firmware to place data, tell it.
 	 * Increment device's write pointer in multiples of 8. */
 	if (rxq->write_actual != (rxq->write & ~0x7)) {
-		spin_lock_irqsave(&rxq->lock, flags);
 		rxq->need_update = 1;
-		spin_unlock_irqrestore(&rxq->lock, flags);
 		il_rx_queue_update_write_ptr(il, rxq);
 	}
-}
-
-/**
- * il4965_rx_replenish - Move all used packet from rx_used to rx_free
- *
- * When moving to rx_free an SKB is allocated for the slot.
- *
- * Also restock the Rx queue via il_rx_queue_restock.
- * This is called as a scheduled work item (except for during initialization)
- */
-static void
-il4965_rx_allocate(struct il_priv *il, gfp_t priority)
-{
-	struct il_rx_queue *rxq = &il->rxq;
-	struct list_head *element;
-	struct il_rx_buf *rxb;
-	struct page *page;
-	dma_addr_t page_dma;
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
-		if (il->hw_params.rx_page_order > 0)
-			gfp_mask |= __GFP_COMP;
-
-		/* Alloc a new receive buffer */
-		page = alloc_pages(gfp_mask, il->hw_params.rx_page_order);
-		if (!page) {
-			if (net_ratelimit())
-				D_INFO("alloc_pages failed, " "order: %d\n",
-				       il->hw_params.rx_page_order);
-
-			if (rxq->free_count <= RX_LOW_WATERMARK &&
-			    net_ratelimit())
-				IL_ERR("Failed to alloc_pages with %s. "
-				       "Only %u free buffers remaining.\n",
-				       priority ==
-				       GFP_ATOMIC ? "GFP_ATOMIC" : "GFP_KERNEL",
-				       rxq->free_count);
-			/* We don't reschedule replenish work here -- we will
-			 * call the restock method and if it still needs
-			 * more buffers it will schedule replenish */
-			return;
-		}
-
-		/* Get physical address of the RB */
-		page_dma =
-		    pci_map_page(il->pci_dev, page, 0,
-				 PAGE_SIZE << il->hw_params.rx_page_order,
-				 PCI_DMA_FROMDEVICE);
-		if (unlikely(pci_dma_mapping_error(il->pci_dev, page_dma))) {
-			__free_pages(page, il->hw_params.rx_page_order);
-			break;
-		}
-
-		spin_lock_irqsave(&rxq->lock, flags);
-
-		if (list_empty(&rxq->rx_used)) {
-			spin_unlock_irqrestore(&rxq->lock, flags);
-			pci_unmap_page(il->pci_dev, page_dma,
-				       PAGE_SIZE << il->hw_params.rx_page_order,
-				       PCI_DMA_FROMDEVICE);
-			__free_pages(page, il->hw_params.rx_page_order);
-			return;
-		}
-
-		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct il_rx_buf, list);
-		list_del(element);
-
-		BUG_ON(rxb->page);
-
-		rxb->page = page;
-		rxb->page_dma = page_dma;
-		list_add_tail(&rxb->list, &rxq->rx_free);
-		rxq->free_count++;
-		il->alloc_rxb_page++;
-
-		spin_unlock_irqrestore(&rxq->lock, flags);
-	}
-}
 
-void
-il4965_rx_replenish(struct il_priv *il)
-{
-	unsigned long flags;
-
-	il4965_rx_allocate(il, GFP_KERNEL);
-
-	spin_lock_irqsave(&il->lock, flags);
-	il4965_rx_queue_restock(il);
-	spin_unlock_irqrestore(&il->lock, flags);
-}
-
-void
-il4965_rx_replenish_now(struct il_priv *il)
-{
-	il4965_rx_allocate(il, GFP_ATOMIC);
-
-	il4965_rx_queue_restock(il);
-}
-
-/* Assumes that the skb field of the buffers in 'pool' is kept accurate.
- * If an SKB has been detached, the POOL needs to have its SKB set to NULL
- * This free routine walks the list of POOL entries and if SKB is set to
- * non NULL it is unmapped and freed
- */
-void
-il4965_rx_queue_free(struct il_priv *il, struct il_rx_queue *rxq)
-{
-	int i;
-	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
-		if (rxq->pool[i].page != NULL) {
-			pci_unmap_page(il->pci_dev, rxq->pool[i].page_dma,
-				       PAGE_SIZE << il->hw_params.rx_page_order,
-				       PCI_DMA_FROMDEVICE);
-			__il_free_pages(il, rxq->pool[i].page);
-			rxq->pool[i].page = NULL;
-		}
-	}
-
-	dma_free_coherent(&il->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			  rxq->bd_dma);
-	dma_free_coherent(&il->pci_dev->dev, sizeof(struct il_rb_status),
-			  rxq->rb_stts, rxq->rb_stts_dma);
-	rxq->bd = NULL;
-	rxq->rb_stts = NULL;
+	spin_unlock_irqrestore(&rxq->lock, flags);
 }
 
 int
@@ -573,16 +370,11 @@ il4965_translate_rx_status(struct il_priv *il, u32 decrypt_in)
 	return decrypt_out;
 }
 
-#define SMALL_PACKET_SIZE 256
-
 static void
 il4965_pass_packet_to_mac80211(struct il_priv *il, struct ieee80211_hdr *hdr,
 			       u32 len, u32 ampdu_status, struct il_rx_buf *rxb,
 			       struct ieee80211_rx_status *stats)
 {
-	struct sk_buff *skb;
-	__le16 fc = hdr->frame_control;
-
 	/* We only process data packets if the interface is open */
 	if (unlikely(!il->is_open)) {
 		D_DROP("Dropping packet while interface is not open.\n");
@@ -599,28 +391,9 @@ il4965_pass_packet_to_mac80211(struct il_priv *il, struct ieee80211_hdr *hdr,
 	    il_set_decrypted_flag(il, hdr, ampdu_status, stats))
 		return;
 
-	skb = dev_alloc_skb(SMALL_PACKET_SIZE);
-	if (!skb) {
-		IL_ERR("dev_alloc_skb failed\n");
-		return;
-	}
-
-	if (len <= SMALL_PACKET_SIZE) {
-		memcpy(skb_put(skb, len), hdr, len);
-	} else {
-		skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb),
-				len, PAGE_SIZE << il->hw_params.rx_page_order);
-		il->alloc_rxb_page--;
-		rxb->page = NULL;
-	}
-
-	il_update_stats(il, false, fc, len);
-	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
-
-	ieee80211_rx(il->hw, skb);
+	il_pass_packet_to_mac80211(il, rxb, hdr, len, stats);
 }
 
-
 static inline bool
 il4965_is_data_rx(struct il_rx_pkt *pkt)
 {
@@ -4225,11 +3998,7 @@ il4965_rx_handle(struct il_priv *il)
 	struct il_rx_pkt *pkt;
 	struct il_rx_queue *rxq = &il->rxq;
 	u32 r, i;
-	bool reclaim;
-	unsigned long flags;
-	u8 fill_rx = 0;
-	u32 count = 8;
-	int total_empty;
+	int count = 8;
 
 	/* uCode's read idx (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
@@ -4240,110 +4009,59 @@ il4965_rx_handle(struct il_priv *il)
 	if (i == r)
 		D_RX("r = %d, i = %d\n", r, i);
 
-	/* calculate total frames need to be restock after handling RX */
-	total_empty = r - rxq->write_actual;
-	if (total_empty < 0)
-		total_empty += RX_QUEUE_SIZE;
-
-	if (total_empty > (RX_QUEUE_SIZE / 2))
-		fill_rx = 1;
-
 	while (i != r) {
-		rxb = rxq->queue[i];
-
-		/* If an RXB doesn't have a Rx queue slot associated with it,
-		 * then a bug has been introduced in the queue refilling
-		 * routines -- catch it here */
-		BUG_ON(rxb == NULL);
-
-		rxq->queue[i] = NULL;
-
-		pci_unmap_page(il->pci_dev, rxb->page_dma,
-			       PAGE_SIZE << il->hw_params.rx_page_order,
-			       PCI_DMA_FROMDEVICE);
+		rxb = &rxq->queue[i];
 		pkt = rxb_addr(rxb);
 
-		reclaim = il_need_reclaim(il, pkt);
+		pci_dma_sync_single_for_cpu(il->pci_dev, rxb->page_dma,
+					    IL_RX_PG_SIZE(il),
+					    PCI_DMA_FROMDEVICE);
+
+		D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
+		     il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 
 		if (il4965_is_data_rx(pkt)) {
-			D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
-			     il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			il4965_data_rx(il, rxb);
-		} else if (il->handlers[pkt->hdr.cmd]) {
-			/* Based on type of command response or notification,
-			 * handle those that need handling via function in
-			 * handlers table. See il4965_setup_handlers()
+			/* DMA sync for device or unmap is done data rx code.
 			 */
-			D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
-			     il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
-			il->isr_stats.handlers[pkt->hdr.cmd]++;
-			il->handlers[pkt->hdr.cmd] (il, pkt);
 		} else {
-			/* No handling needed */
-			D_RX("r %d i %d No handler needed for %s, 0x%02x\n", r,
-			     i, il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
-		}
-
-		/*
-		 * XXX: After here, we should always check rxb->page
-		 * against NULL before touching it or its virtual
-		 * memory (pkt). Because some handler might have
-		 * already taken or freed the pages.
-		 */
+			if (il->handlers[pkt->hdr.cmd]) {
+				/* Based on type of command response or
+				 * notification, handle those that need
+				 * handling via function in handlers table.
+				 * See il4965_setup_handlers().
+				 */
+				il->isr_stats.handlers[pkt->hdr.cmd]++;
+				il->handlers[pkt->hdr.cmd] (il, pkt);
+			}
 
-		if (reclaim) {
-			/* Invoke any callbacks, transfer the buffer to caller,
-			 * and fire off the (possibly) blocking il_send_cmd()
-			 * as we reclaim the driver command queue */
-			if (rxb->page)
+			if (il_need_reclaim(il, pkt)) {
+				/* Invoke any callbacks, transfer the buffer
+				 * to caller, and fire off the (possibly)
+				 * blocking il_send_cmd().
+				 */
 				il_tx_cmd_complete(il, pkt);
-			else
-				IL_WARN("Claim null rxb?\n");
-		}
-
-		/* Reuse the page if possible. For notification packets and
-		 * SKBs that fail to Rx correctly, add them back into the
-		 * rx_free list for reuse later. */
-		spin_lock_irqsave(&rxq->lock, flags);
-		if (rxb->page != NULL) {
-			rxb->page_dma =
-			    pci_map_page(il->pci_dev, rxb->page, 0,
-					 PAGE_SIZE << il->hw_params.
-					 rx_page_order, PCI_DMA_FROMDEVICE);
-
-			if (unlikely(pci_dma_mapping_error(il->pci_dev,
-							   rxb->page_dma))) {
-				__il_free_pages(il, rxb->page);
-				rxb->page = NULL;
-				list_add_tail(&rxb->list, &rxq->rx_used);
-			} else {
-				list_add_tail(&rxb->list, &rxq->rx_free);
-				rxq->free_count++;
 			}
-		} else
-			list_add_tail(&rxb->list, &rxq->rx_used);
 
-		spin_unlock_irqrestore(&rxq->lock, flags);
+			pci_dma_sync_single_for_device(il->pci_dev,
+						       rxb->page_dma,
+						       IL_RX_PG_SIZE(il),
+						       PCI_DMA_FROMDEVICE);
+		}
 
 		i = (i + 1) & RX_QUEUE_MASK;
-		/* If there are a lot of unused frames,
-		 * restock the Rx queue so ucode wont assert. */
-		if (fill_rx) {
-			count++;
-			if (count >= 8) {
-				rxq->read = i;
-				il4965_rx_replenish_now(il);
-				count = 0;
-			}
+
+		count++;
+		if (count >= 8) {
+			rxq->read = i;
+			il4965_rx_queue_update(il);
+			count = 0;
 		}
 	}
 
-	/* Backtrack one entry */
 	rxq->read = i;
-	if (fill_rx)
-		il4965_rx_replenish_now(il);
-	else
-		il4965_rx_queue_restock(il);
+	if (count != 0)
+		il4965_rx_queue_update(il);
 }
 
 /* call this function to flush any scheduled tasklet */
@@ -4484,7 +4202,10 @@ il4965_irq_tasklet(struct il_priv *il)
 	 */
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		D_ISR("Wakeup interrupt\n");
+		spin_lock_irqsave(&il->rxq.lock, flags);
 		il_rx_queue_update_write_ptr(il, &il->rxq);
+		spin_unlock_irqrestore(&il->rxq.lock, flags);
+
 		for (i = 0; i < il->hw_params.max_txq_num; i++)
 			il_txq_update_write_ptr(il, &il->txq[i]);
 		il->isr_stats.wakeup++;
@@ -5712,19 +5433,6 @@ il4965_bg_restart(struct work_struct *data)
 	}
 }
 
-static void
-il4965_bg_rx_replenish(struct work_struct *data)
-{
-	struct il_priv *il = container_of(data, struct il_priv, rx_replenish);
-
-	if (test_bit(S_EXIT_PENDING, &il->status))
-		return;
-
-	mutex_lock(&il->mutex);
-	il4965_rx_replenish(il);
-	mutex_unlock(&il->mutex);
-}
-
 /*****************************************************************************
  *
  * mac80211 entry point functions
@@ -6234,7 +5942,6 @@ il4965_setup_deferred_work(struct il_priv *il)
 	init_waitqueue_head(&il->wait_command_queue);
 
 	INIT_WORK(&il->restart, il4965_bg_restart);
-	INIT_WORK(&il->rx_replenish, il4965_bg_rx_replenish);
 	INIT_WORK(&il->run_time_calib_work, il4965_bg_run_time_calib_work);
 	INIT_DELAYED_WORK(&il->init_alive_start, il4965_bg_init_alive_start);
 	INIT_DELAYED_WORK(&il->alive_start, il4965_bg_alive_start);
@@ -6750,8 +6457,7 @@ il4965_pci_remove(struct pci_dev *pdev)
 
 	il4965_dealloc_ucode_pci(il);
 
-	if (il->rxq.bd)
-		il4965_rx_queue_free(il, &il->rxq);
+	il_rx_queue_free(il);
 	il4965_hw_txq_ctx_free(il);
 
 	il_eeprom_free(il);
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 337dfcf..2c7b67d 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -55,7 +55,6 @@ int il4965_verify_ucode(struct il_priv *il);
 /* lib */
 void il4965_check_abort_status(struct il_priv *il, u8 frame_count, u32 status);
 
-void il4965_rx_queue_reset(struct il_priv *il, struct il_rx_queue *rxq);
 int il4965_rx_init(struct il_priv *il, struct il_rx_queue *rxq);
 int il4965_hw_nic_init(struct il_priv *il);
 int il4965_dump_fh(struct il_priv *il, char **buf, bool display);
@@ -63,10 +62,7 @@ int il4965_dump_fh(struct il_priv *il, char **buf, bool display);
 void il4965_nic_config(struct il_priv *il);
 
 /* rx */
-void il4965_rx_queue_restock(struct il_priv *il);
-void il4965_rx_replenish(struct il_priv *il);
-void il4965_rx_replenish_now(struct il_priv *il);
-void il4965_rx_queue_free(struct il_priv *il, struct il_rx_queue *rxq);
+void il4965_rx_queue_update(struct il_priv *il);
 int il4965_rxq_stop(struct il_priv *il);
 int il4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 void il4965_rx_handle(struct il_priv *il);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 30bac85..9f6c492 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -2498,40 +2498,6 @@ EXPORT_SYMBOL(il_mac_sta_remove);
  * and fire the RX interrupt.  The driver can then query the READ idx and
  * process as many packets as possible, moving the WRITE idx forward as it
  * resets the Rx queue buffers with new memory.
- *
- * The management in the driver is as follows:
- * + A list of pre-allocated SKBs is stored in iwl->rxq->rx_free.  When
- *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
- *   to replenish the iwl->rxq->rx_free.
- * + In il_rx_replenish (scheduled) if 'processed' != 'read' then the
- *   iwl->rxq is replenished and the READ IDX is updated (updating the
- *   'processed' and 'read' driver idxes as well)
- * + A received packet is processed and handed to the kernel network stack,
- *   detached from the iwl->rxq.  The driver 'processed' idx is updated.
- * + The Host/Firmware iwl->rxq is replenished at tasklet time from the rx_free
- *   list. If there are no allocated buffers in iwl->rxq->rx_free, the READ
- *   IDX is not incremented and iwl->status(RX_STALLED) is set.  If there
- *   were enough free buffers and RX_STALLED is set it is cleared.
- *
- *
- * Driver sequence:
- *
- * il_rx_queue_alloc()   Allocates rx_free
- * il_rx_replenish()     Replenishes rx_free list from rx_used, and calls
- *                            il_rx_queue_restock
- * il_rx_queue_restock() Moves available buffers from rx_free into Rx
- *                            queue, updates firmware pointers, and updates
- *                            the WRITE idx.  If insufficient rx_free buffers
- *                            are available, schedules il_rx_replenish
- *
- * -- enable interrupts --
- * ISR - il_rx()         Detach il_rx_bufs from pool up to the
- *                            READ IDX, detaching the SKB from the pool.
- *                            Moves the packet buffer from queue to rx_used.
- *                            Calls il_rx_queue_restock to refill any empty
- *                            slots.
- * ...
- *
  */
 
 /**
@@ -2557,25 +2523,24 @@ EXPORT_SYMBOL(il_rx_queue_space);
 void
 il_rx_queue_update_write_ptr(struct il_priv *il, struct il_rx_queue *q)
 {
-	unsigned long flags;
-	u32 rx_wrt_ptr_reg = il->hw_params.rx_wrt_ptr_reg;
+	const u32 rx_wrt_ptr_reg = il->hw_params.rx_wrt_ptr_reg;
 	u32 reg;
 
-	spin_lock_irqsave(&q->lock, flags);
+	lockdep_assert_held(&q->lock);
 
 	if (q->need_update == 0)
-		goto exit_unlock;
+		return;
 
 	/* If power-saving is in use, make sure device is awake */
 	if (test_bit(S_POWER_PMI, &il->status)) {
 		reg = _il_rd(il, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			D_INFO("Rx queue requesting wakeup," " GP1 = 0x%x\n",
+			D_INFO("Rx queue requesting wakeup, GP1 = 0x%x\n",
 			       reg);
 			il_set_bit(il, CSR_GP_CNTRL,
 				   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			goto exit_unlock;
+			return;
 		}
 
 		q->write_actual = (q->write & ~0x7);
@@ -2589,22 +2554,104 @@ il_rx_queue_update_write_ptr(struct il_priv *il, struct il_rx_queue *q)
 	}
 
 	q->need_update = 0;
-
-exit_unlock:
-	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(il_rx_queue_update_write_ptr);
 
+static void
+il_free_rx_pages(struct il_priv *il, struct page *page, dma_addr_t page_dma)
+{
+	pci_unmap_page(il->pci_dev, page_dma, IL_RX_PG_SIZE(il),
+		       PCI_DMA_FROMDEVICE);
+	__free_pages(page, il->hw_params.rx_page_order);
+}
+
+static struct page *
+il_alloc_rx_pages(struct il_priv *il, dma_addr_t *page_dma, gfp_t gfp)
+{
+	struct page *page;
+
+	page = alloc_pages(gfp, il->hw_params.rx_page_order);
+	if (!page)
+		return NULL;
+
+	*page_dma = pci_map_page(il->pci_dev, page, 0, IL_RX_PG_SIZE(il),
+				 PCI_DMA_FROMDEVICE);
+	if (unlikely(pci_dma_mapping_error(il->pci_dev, *page_dma))) {
+		__free_pages(page, il->hw_params.rx_page_order);
+		return NULL;
+	}
+
+	return page;
+}
+
+static void
+il_rx_queue_free_pages(struct il_priv *il)
+{
+	struct il_rx_queue *rxq = &il->rxq;
+	int i;
+
+	for (i = 0; i < RX_QUEUE_SIZE; i++) {
+		struct il_rx_buf *rxb = &rxq->queue[i];
+
+		if (rxb->page) {
+			il_free_rx_pages(il, rxb->page, rxb->page_dma);
+			rxb->page = NULL;
+		}
+	}
+}
+
+static int
+il_rx_queue_alloc_pages(struct il_priv *il)
+{
+	struct il_rx_queue *rxq = &il->rxq;
+	struct page *page;
+	dma_addr_t page_dma;
+	int i;
+
+	for (i = 0; i < RX_QUEUE_SIZE; i++) {
+		struct il_rx_buf *rxb = &rxq->queue[i];
+
+		page = il_alloc_rx_pages(il, &page_dma, GFP_KERNEL);
+		if (!page)
+			goto err;
+
+		rxb->page_dma = page_dma;
+		rxb->page = page;
+	}
+
+	return 0;
+
+err:
+	il_rx_queue_free_pages(il);
+	return -ENOMEM;
+}
+
+void
+il_rx_queue_free(struct il_priv *il)
+{
+	struct il_rx_queue *rxq = &il->rxq;
+
+	if (WARN_ON(rxq->bd == NULL))
+		return;
+
+	il_rx_queue_free_pages(il);
+
+	dma_free_coherent(&il->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
+			  rxq->bd_dma);
+	dma_free_coherent(&il->pci_dev->dev, sizeof(struct il_rb_status),
+			  rxq->rb_stts, rxq->rb_stts_dma);
+	rxq->bd = NULL;
+	rxq->rb_stts = NULL;
+}
+EXPORT_SYMBOL(il_rx_queue_free);
+
 int
 il_rx_queue_alloc(struct il_priv *il)
 {
 	struct il_rx_queue *rxq = &il->rxq;
 	struct device *dev = &il->pci_dev->dev;
-	int i;
 
 	spin_lock_init(&rxq->lock);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
 
 	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
 	rxq->bd = dma_alloc_coherent(dev, 4 * RX_QUEUE_SIZE, &rxq->bd_dma,
@@ -2617,18 +2664,17 @@ il_rx_queue_alloc(struct il_priv *il)
 	if (!rxq->rb_stts)
 		goto err_rb;
 
-	/* Fill the rx_used queue with _all_ of the Rx buffers */
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
-		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
+	if (il_rx_queue_alloc_pages(il))
+		goto err_pages;
 
-	/* Set us so that we have processed and used all buffers, but have
-	 * not restocked the Rx queue with fresh buffers */
 	rxq->read = rxq->write = 0;
 	rxq->write_actual = 0;
-	rxq->free_count = 0;
 	rxq->need_update = 0;
 	return 0;
 
+err_pages:
+	dma_free_coherent(&il->pci_dev->dev, sizeof(struct il_rb_status),
+			  rxq->rb_stts, rxq->rb_stts_dma);
 err_rb:
 	dma_free_coherent(&il->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
 			  rxq->bd_dma);
@@ -2638,6 +2684,77 @@ err_bd:
 EXPORT_SYMBOL(il_rx_queue_alloc);
 
 void
+il_rx_queue_reset(struct il_priv *il)
+{
+	struct il_rx_queue *rxq = &il->rxq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rxq->lock, flags);
+	rxq->read = rxq->write = 0;
+	rxq->write_actual = 0;
+	spin_unlock_irqrestore(&rxq->lock, flags);
+}
+EXPORT_SYMBOL(il_rx_queue_reset);
+
+void
+il_pass_packet_to_mac80211(struct il_priv *il, struct il_rx_buf *rxb,
+			   struct ieee80211_hdr *hdr, unsigned len,
+			   struct ieee80211_rx_status *stats)
+{
+	const unsigned SMALL_PACKET_SIZE = 256;
+	__le16 fc = hdr->frame_control;
+	struct sk_buff *skb;
+	struct page *page, *new_page;
+	dma_addr_t page_dma, new_page_dma;
+	unsigned long flags;
+
+	if (len > SMALL_PACKET_SIZE) {
+		/* We have to pass pages to mac80211 and allocate new pages
+		 * as receive buffer. Drop packet if no memory.
+		 */
+		new_page = il_alloc_rx_pages(il, &new_page_dma, GFP_ATOMIC);
+		if (!new_page)
+			return;
+
+		page_dma = rxb->page_dma;
+		page = rxb->page;
+
+		spin_lock_irqsave(&il->rxq.lock, flags);
+		rxb->page_dma = new_page_dma;
+		rxb->page = new_page;
+		spin_unlock_irqrestore(&il->rxq.lock, flags);
+	}
+
+	skb = dev_alloc_skb(SMALL_PACKET_SIZE);
+	if (!skb) {
+		if (len > SMALL_PACKET_SIZE)
+			il_free_rx_pages(il, page, page_dma);
+		IL_ERR("dev_alloc_skb failed\n");
+		return;
+	}
+
+	/* If frame is small enough to fit into skb->head, copy it
+	 * and do not consume a full page.
+	 */
+	if (len <= SMALL_PACKET_SIZE) {
+		memcpy(skb_put(skb, len), hdr, len);
+
+		pci_dma_sync_single_for_device(il->pci_dev, rxb->page_dma,
+					       IL_RX_PG_SIZE(il),
+					       PCI_DMA_FROMDEVICE);
+	} else {
+		skb_add_rx_frag(skb, 0, page, (void *)hdr - page_address(page),
+				len, IL_RX_PG_SIZE(il));
+	}
+
+	il_update_stats(il, false, fc, len);
+	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
+
+	ieee80211_rx(il->hw, skb);
+}
+EXPORT_SYMBOL(il_pass_packet_to_mac80211);
+
+void
 il_hdl_spectrum_measurement(struct il_priv *il, struct il_rx_pkt *pkt)
 {
 	struct il_spectrum_notification *report = &(pkt->u.spectrum_notif);
@@ -3324,7 +3441,7 @@ il_tx_cmd_complete(struct il_priv *il, struct il_rx_pkt *pkt)
 }
 EXPORT_SYMBOL(il_tx_cmd_complete);
 
-MODULE_DESCRIPTION("iwl-legacy: common functions for 3945 and 4965");
+MODULE_DESCRIPTION("iwlegacy: common functions for 3945 and 4965");
 MODULE_VERSION(IWLWIFI_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 7cf76c9..b95873c 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -47,15 +47,12 @@ struct il_tx_queue;
 #define IL_WARN(f, a...) dev_warn(&il->pci_dev->dev, f, ## a)
 #define IL_INFO(f, a...) dev_info(&il->pci_dev->dev, f, ## a)
 
-#define RX_QUEUE_SIZE                         256
-#define RX_QUEUE_MASK                         255
-#define RX_QUEUE_SIZE_LOG                     8
-
 /*
  * RX related structures and functions
  */
-#define RX_FREE_BUFFERS 64
-#define RX_LOW_WATERMARK 8
+#define RX_QUEUE_SIZE                         256
+#define RX_QUEUE_MASK                         255
+#define RX_QUEUE_SIZE_LOG                     8
 
 #define U32_PAD(n)		((4-(n))&0x3)
 
@@ -95,10 +92,10 @@ struct il_tx_queue;
 struct il_rx_buf {
 	dma_addr_t page_dma;
 	struct page *page;
-	struct list_head list;
 };
 
 #define rxb_addr(r) page_address(r->page)
+#define IL_RX_PG_SIZE(_il) (PAGE_SIZE << (_il)->hw_params.rx_page_order)
 
 /* defined below */
 struct il_device_cmd;
@@ -594,9 +591,6 @@ struct il_host_cmd {
  * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
  * @read: Shared idx to newest available Rx buffer
  * @write: Shared idx to oldest written Rx packet
- * @free_count: Number of pre-allocated buffers in rx_free
- * @rx_free: list of free SKBs for use
- * @rx_used: List of Rx buffers with no SKB
  * @need_update: flag to indicate we need to update read/write idx
  * @rb_stts: driver's pointer to receive buffer status
  * @rb_stts_dma: bus address of receive buffer status
@@ -606,14 +600,10 @@ struct il_host_cmd {
 struct il_rx_queue {
 	__le32 *bd;
 	dma_addr_t bd_dma;
-	struct il_rx_buf pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
-	struct il_rx_buf *queue[RX_QUEUE_SIZE];
+	struct il_rx_buf queue[RX_QUEUE_SIZE];
 	u32 read;
 	u32 write;
-	u32 free_count;
 	u32 write_actual;
-	struct list_head rx_free;
-	struct list_head rx_used;
 	int need_update;
 	struct il_rb_status *rb_stts;
 	dma_addr_t rb_stts_dma;
@@ -1142,7 +1132,6 @@ struct il_priv {
 	int frames_count;
 
 	enum ieee80211_band band;
-	int alloc_rxb_page;
 
 	void (*handlers[IL_CN_MAX]) (struct il_priv *il,
 				     struct il_rx_pkt *pkt);
@@ -1389,7 +1378,6 @@ struct il_priv {
 
 	struct work_struct restart;
 	struct work_struct scan_completed;
-	struct work_struct rx_replenish;
 	struct work_struct abort_scan;
 
 	bool beacon_enabled;
@@ -1494,20 +1482,6 @@ il_is_channel_ibss(const struct il_channel_info *ch)
 	return (ch->flags & EEPROM_CHANNEL_IBSS) ? 1 : 0;
 }
 
-static inline void
-__il_free_pages(struct il_priv *il, struct page *page)
-{
-	__free_pages(page, il->hw_params.rx_page_order);
-	il->alloc_rxb_page--;
-}
-
-static inline void
-il_free_pages(struct il_priv *il, unsigned long page)
-{
-	free_pages(page, il->hw_params.rx_page_order);
-	il->alloc_rxb_page--;
-}
-
 #define IWLWIFI_VERSION "in-tree:"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2011 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
@@ -1750,8 +1724,13 @@ void il_hdl_csa(struct il_priv *il, struct il_rx_pkt *pkt);
 void il_cmd_queue_unmap(struct il_priv *il);
 void il_cmd_queue_free(struct il_priv *il);
 int il_rx_queue_alloc(struct il_priv *il);
+void il_rx_queue_free(struct il_priv *il);
 void il_rx_queue_update_write_ptr(struct il_priv *il, struct il_rx_queue *q);
+void il_rx_queue_reset(struct il_priv *il);
 int il_rx_queue_space(const struct il_rx_queue *q);
+void il_pass_packet_to_mac80211(struct il_priv *il, struct il_rx_buf *rxb,
+				struct ieee80211_hdr *hdr, unsigned len,
+				struct ieee80211_rx_status *stats);
 void il_tx_cmd_complete(struct il_priv *il, struct il_rx_pkt *pkt);
 
 void il_hdl_spectrum_measurement(struct il_priv *il, struct il_rx_pkt *pkt);
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index 3440101..9f4039f 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -903,9 +903,6 @@ il_dbgfs_rx_queue_read(struct file *file, char __user *user_buf, size_t count,
 
 	pos += scnprintf(buf + pos, bufsz - pos, "read: %u\n", rxq->read);
 	pos += scnprintf(buf + pos, bufsz - pos, "write: %u\n", rxq->write);
-	pos +=
-	    scnprintf(buf + pos, bufsz - pos, "free_count: %u\n",
-		      rxq->free_count);
 	if (rxq->rb_stts) {
 		pos +=
 		    scnprintf(buf + pos, bufsz - pos, "closed_rb_num: %u\n",
-- 
1.7.11.7

