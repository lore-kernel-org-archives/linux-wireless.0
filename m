Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab1GPPcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:15 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/18] iwlagn: move rx transport functions to iwl-trans-rx-pcie.c
Date: Sat, 16 Jul 2011 07:56:35 -0700
Message-Id: <1310828199-18000-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173238_275168_B35CF2C1)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Also create a new file: iwl-trans-int-pcie.h which will include
the non static functions that are shared among the current pcie transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |  226 +-------
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  354 -----------
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    6 -
 drivers/net/wireless/iwlwifi/iwl-core.h           |    3 -
 drivers/net/wireless/iwlwifi/iwl-rx.c             |  136 ----
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   42 ++
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |  694 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   61 ++
 9 files changed, 799 insertions(+), 725 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 2433389..d3c8e37 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -14,7 +14,7 @@ iwlagn-objs             += iwl-6000.o
 iwlagn-objs             += iwl-1000.o
 iwlagn-objs             += iwl-2000.o
 iwlagn-objs             += iwl-pci.o
-iwlagn-objs             += iwl-trans.o
+iwlagn-objs             += iwl-trans.o iwl-trans-rx-pcie.o
 
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlagn-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index d2ba200..4156316 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -628,56 +628,6 @@ struct iwl_mod_params iwlagn_mod_params = {
 	/* the rest are 0 by default */
 };
 
-int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
-{
-	u32 rb_size;
-	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
-	u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT for all devices? */
-
-	rb_timeout = RX_RB_TIMEOUT;
-
-	if (iwlagn_mod_params.amsdu_size_8K)
-		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
-	else
-		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
-
-	/* Stop Rx DMA */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-
-	/* Reset driver's Rx queue write index */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
-
-	/* Tell device where to find RBD circular buffer in DRAM */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-			   (u32)(rxq->bd_dma >> 8));
-
-	/* Tell device where in DRAM to update its Rx status */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
-			   rxq->rb_stts_dma >> 4);
-
-	/* Enable Rx DMA
-	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set because of HW bug in
-	 *      the credit mechanism in 5000 HW RX FIFO
-	 * Direct rx interrupts to hosts
-	 * Rx buffer size 4 or 8k
-	 * RB timeout 0x10
-	 * 256 RBDs
-	 */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
-			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
-			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
-			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
-			   rb_size|
-			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
-			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
-
-	/* Set interrupt coalescing timer to default (2048 usecs) */
-	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
-
-	return 0;
-}
-
 static void iwlagn_set_pwr_vmain(struct iwl_priv *priv)
 {
 /*
@@ -695,10 +645,10 @@ static void iwlagn_set_pwr_vmain(struct iwl_priv *priv)
 			       ~APMG_PS_CTRL_MSK_PWR_SRC);
 }
 
+/*TODO: this function should move to transport layer */
 int iwlagn_hw_nic_init(struct iwl_priv *priv)
 {
 	unsigned long flags;
-	struct iwl_rx_queue *rxq = &priv->rxq;
 
 	/* nic_init */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -716,17 +666,6 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 	/* Allocate the RX queue, or reset if it is already allocated */
 	trans_rx_init(priv);
 
-	iwlagn_rx_replenish(priv);
-
-	iwlagn_rx_init(priv, rxq);
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	rxq->need_update = 1;
-	iwl_rx_queue_update_write_ptr(priv, rxq);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	/* Allocate or reset and init all Tx and Command queues */
 	if (trans_tx_init(priv))
 		return -ENOMEM;
@@ -742,169 +681,6 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 	return 0;
 }
 
-/**
- * iwlagn_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
- */
-static inline __le32 iwlagn_dma_addr2rbd_ptr(struct iwl_priv *priv,
-					  dma_addr_t dma_addr)
-{
-	return cpu_to_le32((u32)(dma_addr >> 8));
-}
-
-/**
- * iwlagn_rx_queue_restock - refill RX queue from pre-allocated pool
- *
- * If there are slots in the RX queue that need to be restocked,
- * and we have free pre-allocated buffers, fill the ranks as much
- * as we can, pulling from rx_free.
- *
- * This moves the 'write' index forward to catch up with 'processed', and
- * also updates the memory address in the firmware to reference the new
- * target buffer.
- */
-void iwlagn_rx_queue_restock(struct iwl_priv *priv)
-{
-	struct iwl_rx_queue *rxq = &priv->rxq;
-	struct list_head *element;
-	struct iwl_rx_mem_buffer *rxb;
-	unsigned long flags;
-
-	spin_lock_irqsave(&rxq->lock, flags);
-	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
-		/* The overwritten rxb must be a used one */
-		rxb = rxq->queue[rxq->write];
-		BUG_ON(rxb && rxb->page);
-
-		/* Get next free Rx buffer, remove from free list */
-		element = rxq->rx_free.next;
-		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
-		list_del(element);
-
-		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] = iwlagn_dma_addr2rbd_ptr(priv,
-							      rxb->page_dma);
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
-
-/**
- * iwlagn_rx_replenish - Move all used packet from rx_used to rx_free
- *
- * When moving to rx_free an SKB is allocated for the slot.
- *
- * Also restock the Rx queue via iwl_rx_queue_restock.
- * This is called as a scheduled work item (except for during initialization)
- */
-void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
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
-		BUG_ON(rxb->page);
-		rxb->page = page;
-		/* Get physical address of the RB */
-		rxb->page_dma = dma_map_page(priv->bus.dev, page, 0,
-				PAGE_SIZE << priv->hw_params.rx_page_order,
-				DMA_FROM_DEVICE);
-		/* dma address must be no more than 36 bits */
-		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
-		/* and also 256 byte aligned! */
-		BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
-
-		spin_lock_irqsave(&rxq->lock, flags);
-
-		list_add_tail(&rxb->list, &rxq->rx_free);
-		rxq->free_count++;
-
-		spin_unlock_irqrestore(&rxq->lock, flags);
-	}
-}
-
-void iwlagn_rx_replenish(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	iwlagn_rx_allocate(priv, GFP_KERNEL);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwlagn_rx_queue_restock(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
-void iwlagn_rx_replenish_now(struct iwl_priv *priv)
-{
-	iwlagn_rx_allocate(priv, GFP_ATOMIC);
-
-	iwlagn_rx_queue_restock(priv);
-}
-
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
 {
 	int idx = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c2a1241..bd85af9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -457,346 +457,6 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 	iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
 }
 
-/**
- * iwl_rx_handle - Main entry function for receiving responses from uCode
- *
- * Uses the priv->rx_handlers callback function array to invoke
- * the appropriate handlers, including command responses,
- * frame-received notifications, and other notifications.
- */
-static void iwl_rx_handle(struct iwl_priv *priv)
-{
-	struct iwl_rx_mem_buffer *rxb;
-	struct iwl_rx_packet *pkt;
-	struct iwl_rx_queue *rxq = &priv->rxq;
-	u32 r, i;
-	int reclaim;
-	unsigned long flags;
-	u8 fill_rx = 0;
-	u32 count = 8;
-	int total_empty;
-
-	/* uCode's read index (stored in shared DRAM) indicates the last Rx
-	 * buffer that the driver may process (last buffer filled by ucode). */
-	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
-	i = rxq->read;
-
-	/* Rx interrupt, but nothing sent from uCode */
-	if (i == r)
-		IWL_DEBUG_RX(priv, "r = %d, i = %d\n", r, i);
-
-	/* calculate total frames need to be restock after handling RX */
-	total_empty = r - rxq->write_actual;
-	if (total_empty < 0)
-		total_empty += RX_QUEUE_SIZE;
-
-	if (total_empty > (RX_QUEUE_SIZE / 2))
-		fill_rx = 1;
-
-	while (i != r) {
-		int len;
-
-		rxb = rxq->queue[i];
-
-		/* If an RXB doesn't have a Rx queue slot associated with it,
-		 * then a bug has been introduced in the queue refilling
-		 * routines -- catch it here */
-		if (WARN_ON(rxb == NULL)) {
-			i = (i + 1) & RX_QUEUE_MASK;
-			continue;
-		}
-
-		rxq->queue[i] = NULL;
-
-		dma_unmap_page(priv->bus.dev, rxb->page_dma,
-			       PAGE_SIZE << priv->hw_params.rx_page_order,
-			       DMA_FROM_DEVICE);
-		pkt = rxb_addr(rxb);
-
-		IWL_DEBUG_RX(priv, "r = %d, i = %d, %s, 0x%02x\n", r,
-			i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
-
-		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-		len += sizeof(u32); /* account for status word */
-		trace_iwlwifi_dev_rx(priv, pkt, len);
-
-		/* Reclaim a command buffer only if this packet is a response
-		 *   to a (driver-originated) command.
-		 * If the packet (e.g. Rx frame) originated from uCode,
-		 *   there is no command buffer to reclaim.
-		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
-		 *   but apparently a few don't get set; catch them here. */
-		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-			(pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
-			(pkt->hdr.cmd != REPLY_RX) &&
-			(pkt->hdr.cmd != REPLY_RX_MPDU_CMD) &&
-			(pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
-			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
-			(pkt->hdr.cmd != REPLY_TX);
-
-		iwl_rx_dispatch(priv, rxb);
-
-		/*
-		 * XXX: After here, we should always check rxb->page
-		 * against NULL before touching it or its virtual
-		 * memory (pkt). Because some rx_handler might have
-		 * already taken or freed the pages.
-		 */
-
-		if (reclaim) {
-			/* Invoke any callbacks, transfer the buffer to caller,
-			 * and fire off the (possibly) blocking
-			 * trans_send_cmd()
-			 * as we reclaim the driver command queue */
-			if (rxb->page)
-				iwl_tx_cmd_complete(priv, rxb);
-			else
-				IWL_WARN(priv, "Claim null rxb?\n");
-		}
-
-		/* Reuse the page if possible. For notification packets and
-		 * SKBs that fail to Rx correctly, add them back into the
-		 * rx_free list for reuse later. */
-		spin_lock_irqsave(&rxq->lock, flags);
-		if (rxb->page != NULL) {
-			rxb->page_dma = dma_map_page(priv->bus.dev, rxb->page,
-				0, PAGE_SIZE << priv->hw_params.rx_page_order,
-				DMA_FROM_DEVICE);
-			list_add_tail(&rxb->list, &rxq->rx_free);
-			rxq->free_count++;
-		} else
-			list_add_tail(&rxb->list, &rxq->rx_used);
-
-		spin_unlock_irqrestore(&rxq->lock, flags);
-
-		i = (i + 1) & RX_QUEUE_MASK;
-		/* If there are a lot of unused frames,
-		 * restock the Rx queue so ucode wont assert. */
-		if (fill_rx) {
-			count++;
-			if (count >= 8) {
-				rxq->read = i;
-				iwlagn_rx_replenish_now(priv);
-				count = 0;
-			}
-		}
-	}
-
-	/* Backtrack one entry */
-	rxq->read = i;
-	if (fill_rx)
-		iwlagn_rx_replenish_now(priv);
-	else
-		iwlagn_rx_queue_restock(priv);
-}
-
-/* tasklet for iwlagn interrupt */
-void iwl_irq_tasklet(struct iwl_priv *priv)
-{
-	u32 inta = 0;
-	u32 handled = 0;
-	unsigned long flags;
-	u32 i;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	u32 inta_mask;
-#endif
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* Ack/clear/reset pending uCode interrupts.
-	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
-	 */
-	/* There is a hardware bug in the interrupt mask function that some
-	 * interrupts (i.e. CSR_INT_BIT_SCD) can still be generated even if
-	 * they are disabled in the CSR_INT_MASK register. Furthermore the
-	 * ICT interrupt handling mechanism has another bug that might cause
-	 * these unmasked interrupts fail to be detected. We workaround the
-	 * hardware bugs here by ACKing all the possible interrupts so that
-	 * interrupt coalescing can still be achieved.
-	 */
-	iwl_write32(priv, CSR_INT, priv->_agn.inta | ~priv->inta_mask);
-
-	inta = priv->_agn.inta;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv) & IWL_DL_ISR) {
-		/* just for debug */
-		inta_mask = iwl_read32(priv, CSR_INT_MASK);
-		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x\n ",
-				inta, inta_mask);
-	}
-#endif
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* saved interrupt in inta variable now we can reset priv->_agn.inta */
-	priv->_agn.inta = 0;
-
-	/* Now service all interrupt bits discovered above. */
-	if (inta & CSR_INT_BIT_HW_ERR) {
-		IWL_ERR(priv, "Hardware error detected.  Restarting.\n");
-
-		/* Tell the device to stop sending interrupts */
-		iwl_disable_interrupts(priv);
-
-		priv->isr_stats.hw++;
-		iwl_irq_handle_error(priv);
-
-		handled |= CSR_INT_BIT_HW_ERR;
-
-		return;
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
-		/* NIC fires this, but we don't use it, redundant with WAKEUP */
-		if (inta & CSR_INT_BIT_SCD) {
-			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
-				      "the frame/frames.\n");
-			priv->isr_stats.sch++;
-		}
-
-		/* Alive notification via Rx interrupt will do the real work */
-		if (inta & CSR_INT_BIT_ALIVE) {
-			IWL_DEBUG_ISR(priv, "Alive interrupt\n");
-			priv->isr_stats.alive++;
-		}
-	}
-#endif
-	/* Safely ignore these bits for debug checks below */
-	inta &= ~(CSR_INT_BIT_SCD | CSR_INT_BIT_ALIVE);
-
-	/* HW RF KILL switch toggled */
-	if (inta & CSR_INT_BIT_RF_KILL) {
-		int hw_rf_kill = 0;
-		if (!(iwl_read32(priv, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
-			hw_rf_kill = 1;
-
-		IWL_WARN(priv, "RF_KILL bit toggled to %s.\n",
-				hw_rf_kill ? "disable radio" : "enable radio");
-
-		priv->isr_stats.rfkill++;
-
-		/* driver only loads ucode once setting the interface up.
-		 * the driver allows loading the ucode even if the radio
-		 * is killed. Hence update the killswitch state here. The
-		 * rfkill handler will care about restarting if needed.
-		 */
-		if (!test_bit(STATUS_ALIVE, &priv->status)) {
-			if (hw_rf_kill)
-				set_bit(STATUS_RF_KILL_HW, &priv->status);
-			else
-				clear_bit(STATUS_RF_KILL_HW, &priv->status);
-			wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rf_kill);
-		}
-
-		handled |= CSR_INT_BIT_RF_KILL;
-	}
-
-	/* Chip got too hot and stopped itself */
-	if (inta & CSR_INT_BIT_CT_KILL) {
-		IWL_ERR(priv, "Microcode CT kill error detected.\n");
-		priv->isr_stats.ctkill++;
-		handled |= CSR_INT_BIT_CT_KILL;
-	}
-
-	/* Error detected by uCode */
-	if (inta & CSR_INT_BIT_SW_ERR) {
-		IWL_ERR(priv, "Microcode SW error detected. "
-			" Restarting 0x%X.\n", inta);
-		priv->isr_stats.sw++;
-		iwl_irq_handle_error(priv);
-		handled |= CSR_INT_BIT_SW_ERR;
-	}
-
-	/* uCode wakes up after power-down sleep */
-	if (inta & CSR_INT_BIT_WAKEUP) {
-		IWL_DEBUG_ISR(priv, "Wakeup interrupt\n");
-		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
-		for (i = 0; i < priv->hw_params.max_txq_num; i++)
-			iwl_txq_update_write_ptr(priv, &priv->txq[i]);
-
-		priv->isr_stats.wakeup++;
-
-		handled |= CSR_INT_BIT_WAKEUP;
-	}
-
-	/* All uCode command responses, including Tx command responses,
-	 * Rx "responses" (frame-received notification), and other
-	 * notifications from uCode come through here*/
-	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX |
-			CSR_INT_BIT_RX_PERIODIC)) {
-		IWL_DEBUG_ISR(priv, "Rx interrupt\n");
-		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
-			handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
-			iwl_write32(priv, CSR_FH_INT_STATUS,
-					CSR_FH_INT_RX_MASK);
-		}
-		if (inta & CSR_INT_BIT_RX_PERIODIC) {
-			handled |= CSR_INT_BIT_RX_PERIODIC;
-			iwl_write32(priv, CSR_INT, CSR_INT_BIT_RX_PERIODIC);
-		}
-		/* Sending RX interrupt require many steps to be done in the
-		 * the device:
-		 * 1- write interrupt to current index in ICT table.
-		 * 2- dma RX frame.
-		 * 3- update RX shared data to indicate last write index.
-		 * 4- send interrupt.
-		 * This could lead to RX race, driver could receive RX interrupt
-		 * but the shared data changes does not reflect this;
-		 * periodic interrupt will detect any dangling Rx activity.
-		 */
-
-		/* Disable periodic interrupt; we use it as just a one-shot. */
-		iwl_write8(priv, CSR_INT_PERIODIC_REG,
-			    CSR_INT_PERIODIC_DIS);
-		iwl_rx_handle(priv);
-
-		/*
-		 * Enable periodic interrupt in 8 msec only if we received
-		 * real RX interrupt (instead of just periodic int), to catch
-		 * any dangling Rx interrupt.  If it was just the periodic
-		 * interrupt, there was no dangling Rx activity, and no need
-		 * to extend the periodic interrupt; one-shot is enough.
-		 */
-		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX))
-			iwl_write8(priv, CSR_INT_PERIODIC_REG,
-				    CSR_INT_PERIODIC_ENA);
-
-		priv->isr_stats.rx++;
-	}
-
-	/* This "Tx" DMA channel is used only for loading uCode */
-	if (inta & CSR_INT_BIT_FH_TX) {
-		iwl_write32(priv, CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
-		IWL_DEBUG_ISR(priv, "uCode load interrupt\n");
-		priv->isr_stats.tx++;
-		handled |= CSR_INT_BIT_FH_TX;
-		/* Wake up uCode load routine, now that load is complete */
-		priv->ucode_write_complete = 1;
-		wake_up_interruptible(&priv->wait_command_queue);
-	}
-
-	if (inta & ~handled) {
-		IWL_ERR(priv, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
-		priv->isr_stats.unhandled++;
-	}
-
-	if (inta & ~(priv->inta_mask)) {
-		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
-			 inta & ~priv->inta_mask);
-	}
-
-	/* Re-enable all interrupts */
-	/* only Re-enable if disabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status))
-		iwl_enable_interrupts(priv);
-	/* Re-enable RF_KILL if it occurred */
-	else if (handled & CSR_INT_BIT_RF_KILL)
-		iwl_enable_rfkill_int(priv);
-}
-
 /*****************************************************************************
  *
  * sysfs attributes
@@ -2321,19 +1981,6 @@ static void iwl_bg_restart(struct work_struct *data)
 	}
 }
 
-static void iwl_bg_rx_replenish(struct work_struct *data)
-{
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, rx_replenish);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	mutex_lock(&priv->mutex);
-	iwlagn_rx_replenish(priv);
-	mutex_unlock(&priv->mutex);
-}
-
 static int iwl_mac_offchannel_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 				 struct ieee80211_channel *chan,
 				 enum nl80211_channel_type channel_type,
@@ -3188,7 +2835,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	init_waitqueue_head(&priv->wait_command_queue);
 
 	INIT_WORK(&priv->restart, iwl_bg_restart);
-	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
 	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
 	INIT_WORK(&priv->run_time_calib_work, iwl_bg_run_time_calib_work);
 	INIT_WORK(&priv->tx_flush, iwl_bg_tx_flush);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 6ddfd93..1655e59 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -174,7 +174,6 @@ int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 int iwlagn_send_tx_power(struct iwl_priv *priv);
 void iwlagn_temperature(struct iwl_priv *priv);
 u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv);
-int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_hw_nic_init(struct iwl_priv *priv);
 int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv);
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
@@ -182,11 +181,6 @@ void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
 
 /* rx */
-void iwl_irq_tasklet(struct iwl_priv *priv);
-void iwlagn_rx_queue_restock(struct iwl_priv *priv);
-void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority);
-void iwlagn_rx_replenish(struct iwl_priv *priv);
-void iwlagn_rx_replenish_now(struct iwl_priv *priv);
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 void iwl_setup_rx_handlers(struct iwl_priv *priv);
 void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2318052..711d2f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -336,9 +336,6 @@ static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 /*****************************************************
 * RX
 ******************************************************/
-void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
-				  struct iwl_rx_queue *q);
-int iwl_rx_queue_space(const struct iwl_rx_queue *q);
 void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 
 void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index bd63b78..05fd75f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -41,142 +41,6 @@
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
 
-/******************************************************************************
- *
- * RX path functions
- *
- ******************************************************************************/
-
-/*
- * Rx theory of operation
- *
- * Driver allocates a circular buffer of Receive Buffer Descriptors (RBDs),
- * each of which point to Receive Buffers to be filled by the NIC.  These get
- * used not only for Rx frames, but for any command response or notification
- * from the NIC.  The driver and NIC manage the Rx buffers by means
- * of indexes into the circular buffer.
- *
- * Rx Queue Indexes
- * The host/firmware share two index registers for managing the Rx buffers.
- *
- * The READ index maps to the first position that the firmware may be writing
- * to -- the driver can read up to (but not including) this position and get
- * good data.
- * The READ index is managed by the firmware once the card is enabled.
- *
- * The WRITE index maps to the last position the driver has read from -- the
- * position preceding WRITE is the last slot the firmware can place a packet.
- *
- * The queue is empty (no good data) if WRITE = READ - 1, and is full if
- * WRITE = READ.
- *
- * During initialization, the host sets up the READ queue position to the first
- * INDEX position, and WRITE to the last (READ - 1 wrapped)
- *
- * When the firmware places a packet in a buffer, it will advance the READ index
- * and fire the RX interrupt.  The driver can then query the READ index and
- * process as many packets as possible, moving the WRITE index forward as it
- * resets the Rx queue buffers with new memory.
- *
- * The management in the driver is as follows:
- * + A list of pre-allocated SKBs is stored in iwl->rxq->rx_free.  When
- *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
- *   to replenish the iwl->rxq->rx_free.
- * + In iwl_rx_replenish (scheduled) if 'processed' != 'read' then the
- *   iwl->rxq is replenished and the READ INDEX is updated (updating the
- *   'processed' and 'read' driver indexes as well)
- * + A received packet is processed and handed to the kernel network stack,
- *   detached from the iwl->rxq.  The driver 'processed' index is updated.
- * + The Host/Firmware iwl->rxq is replenished at tasklet time from the rx_free
- *   list. If there are no allocated buffers in iwl->rxq->rx_free, the READ
- *   INDEX is not incremented and iwl->status(RX_STALLED) is set.  If there
- *   were enough free buffers and RX_STALLED is set it is cleared.
- *
- *
- * Driver sequence:
- *
- * iwl_rx_queue_alloc()   Allocates rx_free
- * iwl_rx_replenish()     Replenishes rx_free list from rx_used, and calls
- *                            iwl_rx_queue_restock
- * iwl_rx_queue_restock() Moves available buffers from rx_free into Rx
- *                            queue, updates firmware pointers, and updates
- *                            the WRITE index.  If insufficient rx_free buffers
- *                            are available, schedules iwl_rx_replenish
- *
- * -- enable interrupts --
- * ISR - iwl_rx()         Detach iwl_rx_mem_buffers from pool up to the
- *                            READ INDEX, detaching the SKB from the pool.
- *                            Moves the packet buffer from queue to rx_used.
- *                            Calls iwl_rx_queue_restock to refill any empty
- *                            slots.
- * ...
- *
- */
-
-/**
- * iwl_rx_queue_space - Return number of free slots available in queue.
- */
-int iwl_rx_queue_space(const struct iwl_rx_queue *q)
-{
-	int s = q->read - q->write;
-	if (s <= 0)
-		s += RX_QUEUE_SIZE;
-	/* keep some buffer to not confuse full and empty queue */
-	s -= 2;
-	if (s < 0)
-		s = 0;
-	return s;
-}
-
-/**
- * iwl_rx_queue_update_write_ptr - Update the write pointer for the RX queue
- */
-void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
-{
-	unsigned long flags;
-	u32 reg;
-
-	spin_lock_irqsave(&q->lock, flags);
-
-	if (q->need_update == 0)
-		goto exit_unlock;
-
-	if (priv->cfg->base_params->shadow_reg_enable) {
-		/* shadow register enabled */
-		/* Device expects a multiple of 8 */
-		q->write_actual = (q->write & ~0x7);
-		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write_actual);
-	} else {
-		/* If power-saving is in use, make sure device is awake */
-		if (test_bit(STATUS_POWER_PMI, &priv->status)) {
-			reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
-
-			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-				IWL_DEBUG_INFO(priv,
-					"Rx queue requesting wakeup,"
-					" GP1 = 0x%x\n", reg);
-				iwl_set_bit(priv, CSR_GP_CNTRL,
-					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-				goto exit_unlock;
-			}
-
-			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
-					q->write_actual);
-
-		/* Else device is assumed to be awake */
-		} else {
-			/* Device expects a multiple of 8 */
-			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
-				q->write_actual);
-		}
-	}
-	q->need_update = 0;
-
- exit_unlock:
-	spin_unlock_irqrestore(&q->lock, flags);
-}
 
 /******************************************************************************
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
new file mode 100644
index 0000000..6c56a3f
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -0,0 +1,42 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+#ifndef __iwl_trans_int_pcie_h__
+#define __iwl_trans_int_pcie_h__
+
+/*This file includes the declaration that are internal to the
+ * trans_pcie layer */
+
+void iwl_bg_rx_replenish(struct work_struct *data);
+void iwl_irq_tasklet(struct iwl_priv *priv);
+void iwlagn_rx_replenish(struct iwl_priv *priv);
+void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
+			struct iwl_rx_queue *q);
+
+#endif /* __iwl_trans_int_pcie_h__ */
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
new file mode 100644
index 0000000..046a33f
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -0,0 +1,694 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+#include <linux/sched.h>
+#include <linux/wait.h>
+
+#include "iwl-dev.h"
+#include "iwl-agn.h"
+#include "iwl-core.h"
+#include "iwl-io.h"
+#include "iwl-helpers.h"
+#include "iwl-trans-int-pcie.h"
+
+/******************************************************************************
+ *
+ * RX path functions
+ *
+ ******************************************************************************/
+
+/*
+ * Rx theory of operation
+ *
+ * Driver allocates a circular buffer of Receive Buffer Descriptors (RBDs),
+ * each of which point to Receive Buffers to be filled by the NIC.  These get
+ * used not only for Rx frames, but for any command response or notification
+ * from the NIC.  The driver and NIC manage the Rx buffers by means
+ * of indexes into the circular buffer.
+ *
+ * Rx Queue Indexes
+ * The host/firmware share two index registers for managing the Rx buffers.
+ *
+ * The READ index maps to the first position that the firmware may be writing
+ * to -- the driver can read up to (but not including) this position and get
+ * good data.
+ * The READ index is managed by the firmware once the card is enabled.
+ *
+ * The WRITE index maps to the last position the driver has read from -- the
+ * position preceding WRITE is the last slot the firmware can place a packet.
+ *
+ * The queue is empty (no good data) if WRITE = READ - 1, and is full if
+ * WRITE = READ.
+ *
+ * During initialization, the host sets up the READ queue position to the first
+ * INDEX position, and WRITE to the last (READ - 1 wrapped)
+ *
+ * When the firmware places a packet in a buffer, it will advance the READ index
+ * and fire the RX interrupt.  The driver can then query the READ index and
+ * process as many packets as possible, moving the WRITE index forward as it
+ * resets the Rx queue buffers with new memory.
+ *
+ * The management in the driver is as follows:
+ * + A list of pre-allocated SKBs is stored in iwl->rxq->rx_free.  When
+ *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
+ *   to replenish the iwl->rxq->rx_free.
+ * + In iwl_rx_replenish (scheduled) if 'processed' != 'read' then the
+ *   iwl->rxq is replenished and the READ INDEX is updated (updating the
+ *   'processed' and 'read' driver indexes as well)
+ * + A received packet is processed and handed to the kernel network stack,
+ *   detached from the iwl->rxq.  The driver 'processed' index is updated.
+ * + The Host/Firmware iwl->rxq is replenished at tasklet time from the rx_free
+ *   list. If there are no allocated buffers in iwl->rxq->rx_free, the READ
+ *   INDEX is not incremented and iwl->status(RX_STALLED) is set.  If there
+ *   were enough free buffers and RX_STALLED is set it is cleared.
+ *
+ *
+ * Driver sequence:
+ *
+ * iwl_rx_queue_alloc()   Allocates rx_free
+ * iwl_rx_replenish()     Replenishes rx_free list from rx_used, and calls
+ *                            iwl_rx_queue_restock
+ * iwl_rx_queue_restock() Moves available buffers from rx_free into Rx
+ *                            queue, updates firmware pointers, and updates
+ *                            the WRITE index.  If insufficient rx_free buffers
+ *                            are available, schedules iwl_rx_replenish
+ *
+ * -- enable interrupts --
+ * ISR - iwl_rx()         Detach iwl_rx_mem_buffers from pool up to the
+ *                            READ INDEX, detaching the SKB from the pool.
+ *                            Moves the packet buffer from queue to rx_used.
+ *                            Calls iwl_rx_queue_restock to refill any empty
+ *                            slots.
+ * ...
+ *
+ */
+
+/**
+ * iwl_rx_queue_space - Return number of free slots available in queue.
+ */
+static int iwl_rx_queue_space(const struct iwl_rx_queue *q)
+{
+	int s = q->read - q->write;
+	if (s <= 0)
+		s += RX_QUEUE_SIZE;
+	/* keep some buffer to not confuse full and empty queue */
+	s -= 2;
+	if (s < 0)
+		s = 0;
+	return s;
+}
+
+/**
+ * iwl_rx_queue_update_write_ptr - Update the write pointer for the RX queue
+ */
+void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
+			struct iwl_rx_queue *q)
+{
+	unsigned long flags;
+	u32 reg;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	if (q->need_update == 0)
+		goto exit_unlock;
+
+	if (priv->cfg->base_params->shadow_reg_enable) {
+		/* shadow register enabled */
+		/* Device expects a multiple of 8 */
+		q->write_actual = (q->write & ~0x7);
+		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write_actual);
+	} else {
+		/* If power-saving is in use, make sure device is awake */
+		if (test_bit(STATUS_POWER_PMI, &priv->status)) {
+			reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
+
+			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
+				IWL_DEBUG_INFO(priv,
+					"Rx queue requesting wakeup,"
+					" GP1 = 0x%x\n", reg);
+				iwl_set_bit(priv, CSR_GP_CNTRL,
+					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+				goto exit_unlock;
+			}
+
+			q->write_actual = (q->write & ~0x7);
+			iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
+					q->write_actual);
+
+		/* Else device is assumed to be awake */
+		} else {
+			/* Device expects a multiple of 8 */
+			q->write_actual = (q->write & ~0x7);
+			iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
+				q->write_actual);
+		}
+	}
+	q->need_update = 0;
+
+ exit_unlock:
+	spin_unlock_irqrestore(&q->lock, flags);
+}
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
+static void iwlagn_rx_queue_restock(struct iwl_priv *priv)
+{
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct list_head *element;
+	struct iwl_rx_mem_buffer *rxb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rxq->lock, flags);
+	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+		/* The overwritten rxb must be a used one */
+		rxb = rxq->queue[rxq->write];
+		BUG_ON(rxb && rxb->page);
+
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
+static void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
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
+				IWL_CRIT(priv, "Failed to alloc_pages with %s."
+					 "Only %u free buffers remaining.\n",
+					 priority == GFP_ATOMIC ?
+					 "GFP_ATOMIC" : "GFP_KERNEL",
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
+		BUG_ON(rxb->page);
+		rxb->page = page;
+		/* Get physical address of the RB */
+		rxb->page_dma = dma_map_page(priv->bus.dev, page, 0,
+				PAGE_SIZE << priv->hw_params.rx_page_order,
+				DMA_FROM_DEVICE);
+		/* dma address must be no more than 36 bits */
+		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
+		/* and also 256 byte aligned! */
+		BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
+
+		spin_lock_irqsave(&rxq->lock, flags);
+
+		list_add_tail(&rxb->list, &rxq->rx_free);
+		rxq->free_count++;
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
+static void iwlagn_rx_replenish_now(struct iwl_priv *priv)
+{
+	iwlagn_rx_allocate(priv, GFP_ATOMIC);
+
+	iwlagn_rx_queue_restock(priv);
+}
+
+void iwl_bg_rx_replenish(struct work_struct *data)
+{
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, rx_replenish);
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	mutex_lock(&priv->mutex);
+	iwlagn_rx_replenish(priv);
+	mutex_unlock(&priv->mutex);
+}
+
+/**
+ * iwl_rx_handle - Main entry function for receiving responses from uCode
+ *
+ * Uses the priv->rx_handlers callback function array to invoke
+ * the appropriate handlers, including command responses,
+ * frame-received notifications, and other notifications.
+ */
+static void iwl_rx_handle(struct iwl_priv *priv)
+{
+	struct iwl_rx_mem_buffer *rxb;
+	struct iwl_rx_packet *pkt;
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	u32 r, i;
+	int reclaim;
+	unsigned long flags;
+	u8 fill_rx = 0;
+	u32 count = 8;
+	int total_empty;
+
+	/* uCode's read index (stored in shared DRAM) indicates the last Rx
+	 * buffer that the driver may process (last buffer filled by ucode). */
+	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
+	i = rxq->read;
+
+	/* Rx interrupt, but nothing sent from uCode */
+	if (i == r)
+		IWL_DEBUG_RX(priv, "r = %d, i = %d\n", r, i);
+
+	/* calculate total frames need to be restock after handling RX */
+	total_empty = r - rxq->write_actual;
+	if (total_empty < 0)
+		total_empty += RX_QUEUE_SIZE;
+
+	if (total_empty > (RX_QUEUE_SIZE / 2))
+		fill_rx = 1;
+
+	while (i != r) {
+		int len;
+
+		rxb = rxq->queue[i];
+
+		/* If an RXB doesn't have a Rx queue slot associated with it,
+		 * then a bug has been introduced in the queue refilling
+		 * routines -- catch it here */
+		if (WARN_ON(rxb == NULL)) {
+			i = (i + 1) & RX_QUEUE_MASK;
+			continue;
+		}
+
+		rxq->queue[i] = NULL;
+
+		dma_unmap_page(priv->bus.dev, rxb->page_dma,
+			       PAGE_SIZE << priv->hw_params.rx_page_order,
+			       DMA_FROM_DEVICE);
+		pkt = rxb_addr(rxb);
+
+		IWL_DEBUG_RX(priv, "r = %d, i = %d, %s, 0x%02x\n", r,
+			i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
+
+		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+		len += sizeof(u32); /* account for status word */
+		trace_iwlwifi_dev_rx(priv, pkt, len);
+
+		/* Reclaim a command buffer only if this packet is a response
+		 *   to a (driver-originated) command.
+		 * If the packet (e.g. Rx frame) originated from uCode,
+		 *   there is no command buffer to reclaim.
+		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
+		 *   but apparently a few don't get set; catch them here. */
+		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
+			(pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
+			(pkt->hdr.cmd != REPLY_RX) &&
+			(pkt->hdr.cmd != REPLY_RX_MPDU_CMD) &&
+			(pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
+			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
+			(pkt->hdr.cmd != REPLY_TX);
+
+		iwl_rx_dispatch(priv, rxb);
+
+		/*
+		 * XXX: After here, we should always check rxb->page
+		 * against NULL before touching it or its virtual
+		 * memory (pkt). Because some rx_handler might have
+		 * already taken or freed the pages.
+		 */
+
+		if (reclaim) {
+			/* Invoke any callbacks, transfer the buffer to caller,
+			 * and fire off the (possibly) blocking
+			 * trans_send_cmd()
+			 * as we reclaim the driver command queue */
+			if (rxb->page)
+				iwl_tx_cmd_complete(priv, rxb);
+			else
+				IWL_WARN(priv, "Claim null rxb?\n");
+		}
+
+		/* Reuse the page if possible. For notification packets and
+		 * SKBs that fail to Rx correctly, add them back into the
+		 * rx_free list for reuse later. */
+		spin_lock_irqsave(&rxq->lock, flags);
+		if (rxb->page != NULL) {
+			rxb->page_dma = dma_map_page(priv->bus.dev, rxb->page,
+				0, PAGE_SIZE << priv->hw_params.rx_page_order,
+				DMA_FROM_DEVICE);
+			list_add_tail(&rxb->list, &rxq->rx_free);
+			rxq->free_count++;
+		} else
+			list_add_tail(&rxb->list, &rxq->rx_used);
+
+		spin_unlock_irqrestore(&rxq->lock, flags);
+
+		i = (i + 1) & RX_QUEUE_MASK;
+		/* If there are a lot of unused frames,
+		 * restock the Rx queue so ucode wont assert. */
+		if (fill_rx) {
+			count++;
+			if (count >= 8) {
+				rxq->read = i;
+				iwlagn_rx_replenish_now(priv);
+				count = 0;
+			}
+		}
+	}
+
+	/* Backtrack one entry */
+	rxq->read = i;
+	if (fill_rx)
+		iwlagn_rx_replenish_now(priv);
+	else
+		iwlagn_rx_queue_restock(priv);
+}
+
+/* tasklet for iwlagn interrupt */
+void iwl_irq_tasklet(struct iwl_priv *priv)
+{
+	u32 inta = 0;
+	u32 handled = 0;
+	unsigned long flags;
+	u32 i;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	u32 inta_mask;
+#endif
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* Ack/clear/reset pending uCode interrupts.
+	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
+	 */
+	/* There is a hardware bug in the interrupt mask function that some
+	 * interrupts (i.e. CSR_INT_BIT_SCD) can still be generated even if
+	 * they are disabled in the CSR_INT_MASK register. Furthermore the
+	 * ICT interrupt handling mechanism has another bug that might cause
+	 * these unmasked interrupts fail to be detected. We workaround the
+	 * hardware bugs here by ACKing all the possible interrupts so that
+	 * interrupt coalescing can still be achieved.
+	 */
+	iwl_write32(priv, CSR_INT, priv->_agn.inta | ~priv->inta_mask);
+
+	inta = priv->_agn.inta;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_get_debug_level(priv) & IWL_DL_ISR) {
+		/* just for debug */
+		inta_mask = iwl_read32(priv, CSR_INT_MASK);
+		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x\n ",
+				inta, inta_mask);
+	}
+#endif
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* saved interrupt in inta variable now we can reset priv->_agn.inta */
+	priv->_agn.inta = 0;
+
+	/* Now service all interrupt bits discovered above. */
+	if (inta & CSR_INT_BIT_HW_ERR) {
+		IWL_ERR(priv, "Hardware error detected.  Restarting.\n");
+
+		/* Tell the device to stop sending interrupts */
+		iwl_disable_interrupts(priv);
+
+		priv->isr_stats.hw++;
+		iwl_irq_handle_error(priv);
+
+		handled |= CSR_INT_BIT_HW_ERR;
+
+		return;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
+		/* NIC fires this, but we don't use it, redundant with WAKEUP */
+		if (inta & CSR_INT_BIT_SCD) {
+			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
+				      "the frame/frames.\n");
+			priv->isr_stats.sch++;
+		}
+
+		/* Alive notification via Rx interrupt will do the real work */
+		if (inta & CSR_INT_BIT_ALIVE) {
+			IWL_DEBUG_ISR(priv, "Alive interrupt\n");
+			priv->isr_stats.alive++;
+		}
+	}
+#endif
+	/* Safely ignore these bits for debug checks below */
+	inta &= ~(CSR_INT_BIT_SCD | CSR_INT_BIT_ALIVE);
+
+	/* HW RF KILL switch toggled */
+	if (inta & CSR_INT_BIT_RF_KILL) {
+		int hw_rf_kill = 0;
+		if (!(iwl_read32(priv, CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
+			hw_rf_kill = 1;
+
+		IWL_WARN(priv, "RF_KILL bit toggled to %s.\n",
+				hw_rf_kill ? "disable radio" : "enable radio");
+
+		priv->isr_stats.rfkill++;
+
+		/* driver only loads ucode once setting the interface up.
+		 * the driver allows loading the ucode even if the radio
+		 * is killed. Hence update the killswitch state here. The
+		 * rfkill handler will care about restarting if needed.
+		 */
+		if (!test_bit(STATUS_ALIVE, &priv->status)) {
+			if (hw_rf_kill)
+				set_bit(STATUS_RF_KILL_HW, &priv->status);
+			else
+				clear_bit(STATUS_RF_KILL_HW, &priv->status);
+			wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rf_kill);
+		}
+
+		handled |= CSR_INT_BIT_RF_KILL;
+	}
+
+	/* Chip got too hot and stopped itself */
+	if (inta & CSR_INT_BIT_CT_KILL) {
+		IWL_ERR(priv, "Microcode CT kill error detected.\n");
+		priv->isr_stats.ctkill++;
+		handled |= CSR_INT_BIT_CT_KILL;
+	}
+
+	/* Error detected by uCode */
+	if (inta & CSR_INT_BIT_SW_ERR) {
+		IWL_ERR(priv, "Microcode SW error detected. "
+			" Restarting 0x%X.\n", inta);
+		priv->isr_stats.sw++;
+		iwl_irq_handle_error(priv);
+		handled |= CSR_INT_BIT_SW_ERR;
+	}
+
+	/* uCode wakes up after power-down sleep */
+	if (inta & CSR_INT_BIT_WAKEUP) {
+		IWL_DEBUG_ISR(priv, "Wakeup interrupt\n");
+		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
+		for (i = 0; i < priv->hw_params.max_txq_num; i++)
+			iwl_txq_update_write_ptr(priv, &priv->txq[i]);
+
+		priv->isr_stats.wakeup++;
+
+		handled |= CSR_INT_BIT_WAKEUP;
+	}
+
+	/* All uCode command responses, including Tx command responses,
+	 * Rx "responses" (frame-received notification), and other
+	 * notifications from uCode come through here*/
+	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX |
+			CSR_INT_BIT_RX_PERIODIC)) {
+		IWL_DEBUG_ISR(priv, "Rx interrupt\n");
+		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
+			handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
+			iwl_write32(priv, CSR_FH_INT_STATUS,
+					CSR_FH_INT_RX_MASK);
+		}
+		if (inta & CSR_INT_BIT_RX_PERIODIC) {
+			handled |= CSR_INT_BIT_RX_PERIODIC;
+			iwl_write32(priv, CSR_INT, CSR_INT_BIT_RX_PERIODIC);
+		}
+		/* Sending RX interrupt require many steps to be done in the
+		 * the device:
+		 * 1- write interrupt to current index in ICT table.
+		 * 2- dma RX frame.
+		 * 3- update RX shared data to indicate last write index.
+		 * 4- send interrupt.
+		 * This could lead to RX race, driver could receive RX interrupt
+		 * but the shared data changes does not reflect this;
+		 * periodic interrupt will detect any dangling Rx activity.
+		 */
+
+		/* Disable periodic interrupt; we use it as just a one-shot. */
+		iwl_write8(priv, CSR_INT_PERIODIC_REG,
+			    CSR_INT_PERIODIC_DIS);
+		iwl_rx_handle(priv);
+
+		/*
+		 * Enable periodic interrupt in 8 msec only if we received
+		 * real RX interrupt (instead of just periodic int), to catch
+		 * any dangling Rx interrupt.  If it was just the periodic
+		 * interrupt, there was no dangling Rx activity, and no need
+		 * to extend the periodic interrupt; one-shot is enough.
+		 */
+		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX))
+			iwl_write8(priv, CSR_INT_PERIODIC_REG,
+				    CSR_INT_PERIODIC_ENA);
+
+		priv->isr_stats.rx++;
+	}
+
+	/* This "Tx" DMA channel is used only for loading uCode */
+	if (inta & CSR_INT_BIT_FH_TX) {
+		iwl_write32(priv, CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
+		IWL_DEBUG_ISR(priv, "uCode load interrupt\n");
+		priv->isr_stats.tx++;
+		handled |= CSR_INT_BIT_FH_TX;
+		/* Wake up uCode load routine, now that load is complete */
+		priv->ucode_write_complete = 1;
+		wake_up_interruptible(&priv->wait_command_queue);
+	}
+
+	if (inta & ~handled) {
+		IWL_ERR(priv, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
+		priv->isr_stats.unhandled++;
+	}
+
+	if (inta & ~(priv->inta_mask)) {
+		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
+			 inta & ~priv->inta_mask);
+	}
+
+	/* Re-enable all interrupts */
+	/* only Re-enable if disabled by irq */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status))
+		iwl_enable_interrupts(priv);
+	/* Re-enable RF_KILL if it occurred */
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_enable_rfkill_int(priv);
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index ca96902..6b7cb73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -64,6 +64,7 @@
 #include "iwl-trans.h"
 #include "iwl-core.h"
 #include "iwl-helpers.h"
+#include "iwl-trans-int-pcie.h"
 /*TODO remove uneeded includes when the transport layer tx_free will be here */
 #include "iwl-agn.h"
 #include "iwl-core.h"
@@ -127,6 +128,55 @@ static void iwl_trans_rxq_free_rx_bufs(struct iwl_priv *priv)
 	}
 }
 
+static void iwl_trans_rx_hw_init(struct iwl_priv *priv,
+				 struct iwl_rx_queue *rxq)
+{
+	u32 rb_size;
+	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
+	u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT for all devices? */
+
+	rb_timeout = RX_RB_TIMEOUT;
+
+	if (iwlagn_mod_params.amsdu_size_8K)
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
+	else
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
+
+	/* Stop Rx DMA */
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+
+	/* Reset driver's Rx queue write index */
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+
+	/* Tell device where to find RBD circular buffer in DRAM */
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+			   (u32)(rxq->bd_dma >> 8));
+
+	/* Tell device where in DRAM to update its Rx status */
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
+			   rxq->rb_stts_dma >> 4);
+
+	/* Enable Rx DMA
+	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set because of HW bug in
+	 *      the credit mechanism in 5000 HW RX FIFO
+	 * Direct rx interrupts to hosts
+	 * Rx buffer size 4 or 8k
+	 * RB timeout 0x10
+	 * 256 RBDs
+	 */
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
+			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
+			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
+			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
+			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
+			   rb_size|
+			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
+			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
+
+	/* Set interrupt coalescing timer to default (2048 usecs) */
+	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+}
+
 static int iwl_trans_rx_init(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
@@ -155,6 +205,15 @@ static int iwl_trans_rx_init(struct iwl_priv *priv)
 	rxq->free_count = 0;
 	spin_unlock_irqrestore(&rxq->lock, flags);
 
+	iwlagn_rx_replenish(priv);
+
+	iwl_trans_rx_hw_init(priv, rxq);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	rxq->need_update = 1;
+	iwl_rx_queue_update_write_ptr(priv, rxq);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
 	return 0;
 }
 
@@ -756,5 +815,7 @@ int iwl_trans_register(struct iwl_priv *priv)
 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
 		iwl_irq_tasklet, (unsigned long)priv);
 
+	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
+
 	return 0;
 }
-- 
1.7.0.4

