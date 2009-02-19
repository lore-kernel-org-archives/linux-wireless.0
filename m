Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41998 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbZBSWte (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 17:49:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Optimize DMA buffers
Date: Thu, 19 Feb 2009 23:45:43 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200902192345.44141.mb@bu3sch.de> (sfid-20090219_234938_774624_8ED333F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the old days we used one slot per frame. But when we changed that to 2,
we didn't raise the overall slot count. Which resulted in an effective
division of two to the number of slots.

Double the number of TX slots, so we have an effective hardware queue
of 128 frames per QoS queue.

Also optimize the TX header cache handling. We don't need a cached TX header
for slots that will never carry an actual header.
So we reduce the memory consumption of the cache by 50%.

So as a net result we end up with more or less the same memory usage before
and after this patch (except a few tiny meta structures), but have twice
the number of TX slots available.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Please queue for the next round of features.


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-02-19 22:30:16.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-02-19 22:49:06.000000000 +0100
@@ -38,12 +38,18 @@
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <asm/div64.h>
 
 
+/* Required number of TX DMA slots per TX frame.
+ * This currently is 2, because we put the header and the ieee80211 frame
+ * into separate slots. */
+#define TX_SLOTS_PER_FRAME	2
+
+
 /* 32bit DMA ops. */
 static
 struct b43_dmadesc_generic *op32_idx2desc(struct b43_dmaring *ring,
 					  int slot,
 					  struct b43_dmadesc_meta **meta)
 {
@@ -571,18 +577,17 @@ static int setup_rx_descbuffer(struct b4
 
 		skb = __dev_alloc_skb(ring->rx_buffersize, gfp_flags);
 		if (unlikely(!skb))
 			return -ENOMEM;
 		dmaaddr = map_descbuffer(ring, skb->data,
 					 ring->rx_buffersize, 0);
-	}
-
-	if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize, 0)) {
-		b43err(ring->dev->wl, "RX DMA buffer allocation failed\n");
-		dev_kfree_skb_any(skb);
-		return -EIO;
+		if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize, 0)) {
+			b43err(ring->dev->wl, "RX DMA buffer allocation failed\n");
+			dev_kfree_skb_any(skb);
+			return -EIO;
+		}
 	}
 
 	meta->skb = skb;
 	meta->dmaaddr = dmaaddr;
 	ring->ops->fill_descriptor(ring, desc, dmaaddr,
 				   ring->rx_buffersize, 0, 0, 0);
@@ -834,13 +839,13 @@ struct b43_dmaring *b43_setup_dmaring(st
 	spin_lock_init(&ring->lock);
 #ifdef CONFIG_B43_DEBUG
 	ring->last_injected_overflow = jiffies;
 #endif
 
 	if (for_tx) {
-		ring->txhdr_cache = kcalloc(ring->nr_slots,
+		ring->txhdr_cache = kcalloc(ring->nr_slots / TX_SLOTS_PER_FRAME,
 					    b43_txhdr_size(dev),
 					    GFP_KERNEL);
 		if (!ring->txhdr_cache)
 			goto err_kfree_meta;
 
 		/* test for ability to dma to txhdr_cache */
@@ -850,13 +855,13 @@ struct b43_dmaring *b43_setup_dmaring(st
 					      DMA_TO_DEVICE);
 
 		if (b43_dma_mapping_error(ring, dma_test,
 					  b43_txhdr_size(dev), 1)) {
 			/* ugh realloc */
 			kfree(ring->txhdr_cache);
-			ring->txhdr_cache = kcalloc(ring->nr_slots,
+			ring->txhdr_cache = kcalloc(ring->nr_slots / TX_SLOTS_PER_FRAME,
 						    b43_txhdr_size(dev),
 						    GFP_KERNEL | GFP_DMA);
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
 			dma_test = ssb_dma_map_single(dev->dev,
@@ -1141,23 +1146,26 @@ static int dma_tx_fragment(struct b43_dm
 	struct b43_dmadesc_meta *meta;
 	struct b43_dmadesc_meta *meta_hdr;
 	struct sk_buff *bounce_skb;
 	u16 cookie;
 	size_t hdrsize = b43_txhdr_size(ring->dev);
 
-#define SLOTS_PER_PACKET  2
+	/* Important note: If the number of used DMA slots per TX frame
+	 * is changed here, the TX_SLOTS_PER_FRAME definition at the top of
+	 * the file has to be updated, too!
+	 */
 
 	old_top_slot = ring->current_slot;
 	old_used_slots = ring->used_slots;
 
 	/* Get a slot for the header. */
 	slot = request_slot(ring);
 	desc = ops->idx2desc(ring, slot, &meta_hdr);
 	memset(meta_hdr, 0, sizeof(*meta_hdr));
 
-	header = &(ring->txhdr_cache[slot * hdrsize]);
+	header = &(ring->txhdr_cache[(slot / TX_SLOTS_PER_FRAME) * hdrsize]);
 	cookie = generate_cookie(ring, slot);
 	err = b43_generate_txhdr(ring->dev, header,
 				 skb->data, skb->len, info, cookie);
 	if (unlikely(err)) {
 		ring->current_slot = old_top_slot;
 		ring->used_slots = old_used_slots;
@@ -1299,13 +1307,13 @@ int b43_dma_tx(struct b43_wldev *dev, st
 		ring = select_ring_by_priority(
 			dev, skb_get_queue_mapping(skb));
 	}
 
 	spin_lock_irqsave(&ring->lock, flags);
 	B43_WARN_ON(!ring->tx);
-	if (unlikely(free_slots(ring) < SLOTS_PER_PACKET)) {
+	if (unlikely(free_slots(ring) < TX_SLOTS_PER_FRAME)) {
 		b43warn(dev->wl, "DMA queue overflow\n");
 		err = -ENOSPC;
 		goto out_unlock;
 	}
 	/* Check if the queue was stopped in mac80211,
 	 * but we got called nevertheless.
@@ -1327,13 +1335,13 @@ int b43_dma_tx(struct b43_wldev *dev, st
 	}
 	if (unlikely(err)) {
 		b43err(dev->wl, "DMA tx mapping failure\n");
 		goto out_unlock;
 	}
 	ring->nr_tx_packets++;
-	if ((free_slots(ring) < SLOTS_PER_PACKET) ||
+	if ((free_slots(ring) < TX_SLOTS_PER_FRAME) ||
 	    should_inject_overflow(ring)) {
 		/* This TX ring is full. */
 		ieee80211_stop_queue(dev->wl->hw, skb_get_queue_mapping(skb));
 		ring->stopped = 1;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
@@ -1411,13 +1419,13 @@ void b43_dma_handle_txstatus(struct b43_
 		if (meta->is_last_fragment)
 			break;
 		slot = next_slot(ring, slot);
 	}
 	dev->stats.last_tx = jiffies;
 	if (ring->stopped) {
-		B43_WARN_ON(free_slots(ring) < SLOTS_PER_PACKET);
+		B43_WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME);
 		ieee80211_wake_queue(dev->wl->hw, ring->queue_prio);
 		ring->stopped = 0;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Woke up TX ring %d\n", ring->index);
 		}
 	}
@@ -1434,14 +1442,14 @@ void b43_dma_get_tx_stats(struct b43_wld
 	int i;
 
 	for (i = 0; i < nr_queues; i++) {
 		ring = select_ring_by_priority(dev, i);
 
 		spin_lock_irqsave(&ring->lock, flags);
-		stats[i].len = ring->used_slots / SLOTS_PER_PACKET;
-		stats[i].limit = ring->nr_slots / SLOTS_PER_PACKET;
+		stats[i].len = ring->used_slots / TX_SLOTS_PER_FRAME;
+		stats[i].limit = ring->nr_slots / TX_SLOTS_PER_FRAME;
 		stats[i].count = ring->nr_tx_packets;
 		spin_unlock_irqrestore(&ring->lock, flags);
 	}
 }
 
 static void dma_rx(struct b43_dmaring *ring, int *slot)
Index: wireless-testing/drivers/net/wireless/b43/dma.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.h	2009-02-19 22:32:21.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.h	2009-02-19 22:46:14.000000000 +0100
@@ -159,13 +159,13 @@ struct b43_dmadesc_generic {
 
 /* Misc DMA constants */
 #define B43_DMA_RINGMEMSIZE		PAGE_SIZE
 #define B43_DMA0_RX_FRAMEOFFSET		30
 
 /* DMA engine tuning knobs */
-#define B43_TXRING_SLOTS		128
+#define B43_TXRING_SLOTS		256
 #define B43_RXRING_SLOTS		64
 #define B43_DMA0_RX_BUFFERSIZE		IEEE80211_MAX_FRAME_LEN
 
 
 struct sk_buff;
 struct b43_private;
@@ -209,13 +209,13 @@ struct b43_dmaring {
 	/* Lowlevel DMA ops. */
 	const struct b43_dma_ops *ops;
 	/* Kernel virtual base address of the ring memory. */
 	void *descbase;
 	/* Meta data about all descriptors. */
 	struct b43_dmadesc_meta *meta;
-	/* Cache of TX headers for each slot.
+	/* Cache of TX headers for each TX frame.
 	 * This is to avoid an allocation on each TX.
 	 * This is NULL for an RX ring.
 	 */
 	u8 *txhdr_cache;
 	/* (Unadjusted) DMA base bus-address of the ring memory. */
 	dma_addr_t dmabase;

-- 
Greetings, Michael.
