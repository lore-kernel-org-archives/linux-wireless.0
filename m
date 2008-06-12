Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38966 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbYFLKCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 06:02:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix possible NULL pointer dereference in DMA code
Date: Thu, 12 Jun 2008 11:58:56 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	vegard.nossum@gmail.com, miles.lane@gmail.com,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806121158.57287.mb@bu3sch.de> (sfid-20080612_120210_650198_8E9F9056)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a possible NULL pointer dereference in an error path of the
DMA allocation error checking code. This is also necessary for a future
DMA API change that is on its way into the mainline kernel that adds
an additional dev parameter to dma_mapping_error().

This patch moves the whole struct b43_dmaring struct initialization
right before any DMA allocation operation.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is a bugfix for 2.6.26


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-06-12 11:49:24.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-06-12 11:50:10.000000000 +0200
@@ -792,30 +792,55 @@ struct b43_dmaring *b43_setup_dmaring(st
 				      int controller_index,
 				      int for_tx,
 				      enum b43_dmatype type)
 {
 	struct b43_dmaring *ring;
 	int err;
-	int nr_slots;
 	dma_addr_t dma_test;
 
 	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
 	if (!ring)
 		goto out;
-	ring->type = type;
 
-	nr_slots = B43_RXRING_SLOTS;
+	ring->nr_slots = B43_RXRING_SLOTS;
 	if (for_tx)
-		nr_slots = B43_TXRING_SLOTS;
+		ring->nr_slots = B43_TXRING_SLOTS;
 
-	ring->meta = kcalloc(nr_slots, sizeof(struct b43_dmadesc_meta),
+	ring->meta = kcalloc(ring->nr_slots, sizeof(struct b43_dmadesc_meta),
 			     GFP_KERNEL);
 	if (!ring->meta)
 		goto err_kfree_ring;
+
+	ring->type = type;
+	ring->dev = dev;
+	ring->mmio_base = b43_dmacontroller_base(type, controller_index);
+	ring->index = controller_index;
+	if (type == B43_DMA_64BIT)
+		ring->ops = &dma64_ops;
+	else
+		ring->ops = &dma32_ops;
 	if (for_tx) {
-		ring->txhdr_cache = kcalloc(nr_slots,
+		ring->tx = 1;
+		ring->current_slot = -1;
+	} else {
+		if (ring->index == 0) {
+			ring->rx_buffersize = B43_DMA0_RX_BUFFERSIZE;
+			ring->frameoffset = B43_DMA0_RX_FRAMEOFFSET;
+		} else if (ring->index == 3) {
+			ring->rx_buffersize = B43_DMA3_RX_BUFFERSIZE;
+			ring->frameoffset = B43_DMA3_RX_FRAMEOFFSET;
+		} else
+			B43_WARN_ON(1);
+	}
+	spin_lock_init(&ring->lock);
+#ifdef CONFIG_B43_DEBUG
+	ring->last_injected_overflow = jiffies;
+#endif
+
+	if (for_tx) {
+		ring->txhdr_cache = kcalloc(ring->nr_slots,
 					    b43_txhdr_size(dev),
 					    GFP_KERNEL);
 		if (!ring->txhdr_cache)
 			goto err_kfree_meta;
 
 		/* test for ability to dma to txhdr_cache */
@@ -825,13 +850,13 @@ struct b43_dmaring *b43_setup_dmaring(st
 					  DMA_TO_DEVICE);
 
 		if (b43_dma_mapping_error(ring, dma_test,
 					  b43_txhdr_size(dev), 1)) {
 			/* ugh realloc */
 			kfree(ring->txhdr_cache);
-			ring->txhdr_cache = kcalloc(nr_slots,
+			ring->txhdr_cache = kcalloc(ring->nr_slots,
 						    b43_txhdr_size(dev),
 						    GFP_KERNEL | GFP_DMA);
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
 			dma_test = dma_map_single(dev->dev->dma_dev,
@@ -850,38 +875,12 @@ struct b43_dmaring *b43_setup_dmaring(st
 
 		dma_unmap_single(dev->dev->dma_dev,
 				 dma_test, b43_txhdr_size(dev),
 				 DMA_TO_DEVICE);
 	}
 
-	ring->dev = dev;
-	ring->nr_slots = nr_slots;
-	ring->mmio_base = b43_dmacontroller_base(type, controller_index);
-	ring->index = controller_index;
-	if (type == B43_DMA_64BIT)
-		ring->ops = &dma64_ops;
-	else
-		ring->ops = &dma32_ops;
-	if (for_tx) {
-		ring->tx = 1;
-		ring->current_slot = -1;
-	} else {
-		if (ring->index == 0) {
-			ring->rx_buffersize = B43_DMA0_RX_BUFFERSIZE;
-			ring->frameoffset = B43_DMA0_RX_FRAMEOFFSET;
-		} else if (ring->index == 3) {
-			ring->rx_buffersize = B43_DMA3_RX_BUFFERSIZE;
-			ring->frameoffset = B43_DMA3_RX_FRAMEOFFSET;
-		} else
-			B43_WARN_ON(1);
-	}
-	spin_lock_init(&ring->lock);
-#ifdef CONFIG_B43_DEBUG
-	ring->last_injected_overflow = jiffies;
-#endif
-
 	err = alloc_ringmemory(ring);
 	if (err)
 		goto err_kfree_txhdr_cache;
 	err = dmacontroller_setup(ring);
 	if (err)
 		goto err_free_ringmemory;
