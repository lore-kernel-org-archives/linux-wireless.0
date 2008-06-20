Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38728 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYFTJzh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 05:55:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb, b43, b43legacy, b44: Rewrite SSB DMA API
Date: Fri, 20 Jun 2008 11:50:29 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806201150.29497.mb@bu3sch.de> (sfid-20080620_115542_230274_AC8D67F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a rewrite of the DMA API for SSB devices.
This is needed, because the old (non-existing) "API" made too many bad
assumptions on the API of the host-bus (PCI).
This introduces an almost complete SSB-DMA-API that maps to the lowlevel
bus-API based on the bustype.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please merge for 2.6.27
This is one huge patch, because it's not really possible to split this
without breaking bisect.


Index: wireless-testing/drivers/net/b44.c
===================================================================
--- wireless-testing.orig/drivers/net/b44.c	2008-06-20 02:04:56.000000000 +0200
+++ wireless-testing/drivers/net/b44.c	2008-06-20 02:07:31.000000000 +0200
@@ -145,25 +145,25 @@ B44_STAT_REG_DECLARE
 
 static inline void b44_sync_dma_desc_for_device(struct ssb_device *sdev,
 						dma_addr_t dma_base,
 						unsigned long offset,
 						enum dma_data_direction dir)
 {
-	dma_sync_single_range_for_device(sdev->dma_dev, dma_base,
-					 offset & dma_desc_align_mask,
-					 dma_desc_sync_size, dir);
+	ssb_dma_sync_single_range_for_device(sdev, dma_base,
+					     offset & dma_desc_align_mask,
+					     dma_desc_sync_size, dir);
 }
 
 static inline void b44_sync_dma_desc_for_cpu(struct ssb_device *sdev,
 					     dma_addr_t dma_base,
 					     unsigned long offset,
 					     enum dma_data_direction dir)
 {
-	dma_sync_single_range_for_cpu(sdev->dma_dev, dma_base,
-				      offset & dma_desc_align_mask,
-				      dma_desc_sync_size, dir);
+	ssb_dma_sync_single_range_for_cpu(sdev, dma_base,
+					  offset & dma_desc_align_mask,
+					  dma_desc_sync_size, dir);
 }
 
 static inline unsigned long br32(const struct b44 *bp, unsigned long reg)
 {
 	return ssb_read32(bp->sdev, reg);
 }
@@ -610,16 +610,16 @@ static void b44_tx(struct b44 *bp)
 	for (cons = bp->tx_cons; cons != cur; cons = NEXT_TX(cons)) {
 		struct ring_info *rp = &bp->tx_buffers[cons];
 		struct sk_buff *skb = rp->skb;
 
 		BUG_ON(skb == NULL);
 
-		dma_unmap_single(bp->sdev->dma_dev,
-				 rp->mapping,
-				 skb->len,
-				 DMA_TO_DEVICE);
+		ssb_dma_unmap_single(bp->sdev,
+				     rp->mapping,
+				     skb->len,
+				     DMA_TO_DEVICE);
 		rp->skb = NULL;
 		dev_kfree_skb_irq(skb);
 	}
 
 	bp->tx_cons = cons;
 	if (netif_queue_stopped(bp->dev) &&
@@ -650,35 +650,35 @@ static int b44_alloc_rx_skb(struct b44 *
 	dest_idx = dest_idx_unmasked & (B44_RX_RING_SIZE - 1);
 	map = &bp->rx_buffers[dest_idx];
 	skb = netdev_alloc_skb(bp->dev, RX_PKT_BUF_SZ);
 	if (skb == NULL)
 		return -ENOMEM;
 
-	mapping = dma_map_single(bp->sdev->dma_dev, skb->data,
-				 RX_PKT_BUF_SZ,
-				 DMA_FROM_DEVICE);
+	mapping = ssb_dma_map_single(bp->sdev, skb->data,
+				     RX_PKT_BUF_SZ,
+				     DMA_FROM_DEVICE);
 
 	/* Hardware bug work-around, the chip is unable to do PCI DMA
 	   to/from anything above 1GB :-( */
-	if (dma_mapping_error(mapping) ||
+	if (ssb_dma_mapping_error(bp->sdev, mapping) ||
 		mapping + RX_PKT_BUF_SZ > DMA_30BIT_MASK) {
 		/* Sigh... */
-		if (!dma_mapping_error(mapping))
-			dma_unmap_single(bp->sdev->dma_dev, mapping,
-					RX_PKT_BUF_SZ, DMA_FROM_DEVICE);
+		if (!ssb_dma_mapping_error(bp->sdev, mapping))
+			ssb_dma_unmap_single(bp->sdev, mapping,
+					     RX_PKT_BUF_SZ, DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
 		skb = __netdev_alloc_skb(bp->dev, RX_PKT_BUF_SZ, GFP_ATOMIC|GFP_DMA);
 		if (skb == NULL)
 			return -ENOMEM;
-		mapping = dma_map_single(bp->sdev->dma_dev, skb->data,
-					 RX_PKT_BUF_SZ,
-					 DMA_FROM_DEVICE);
-		if (dma_mapping_error(mapping) ||
+		mapping = ssb_dma_map_single(bp->sdev, skb->data,
+					     RX_PKT_BUF_SZ,
+					     DMA_FROM_DEVICE);
+		if (ssb_dma_mapping_error(bp->sdev, mapping) ||
 			mapping + RX_PKT_BUF_SZ > DMA_30BIT_MASK) {
-			if (!dma_mapping_error(mapping))
-				dma_unmap_single(bp->sdev->dma_dev, mapping, RX_PKT_BUF_SZ,DMA_FROM_DEVICE);
+			if (!ssb_dma_mapping_error(bp->sdev, mapping))
+				ssb_dma_unmap_single(bp->sdev, mapping, RX_PKT_BUF_SZ,DMA_FROM_DEVICE);
 			dev_kfree_skb_any(skb);
 			return -ENOMEM;
 		}
 	}
 
 	rh = (struct rx_header *) skb->data;
@@ -747,15 +747,15 @@ static void b44_recycle_rx(struct b44 *b
 
 	if (bp->flags & B44_FLAG_RX_RING_HACK)
 		b44_sync_dma_desc_for_device(bp->sdev, bp->rx_ring_dma,
 					     dest_idx * sizeof(dest_desc),
 					     DMA_BIDIRECTIONAL);
 
-	dma_sync_single_for_device(bp->sdev->dma_dev, le32_to_cpu(src_desc->addr),
-				   RX_PKT_BUF_SZ,
-				   DMA_FROM_DEVICE);
+	ssb_dma_sync_single_for_device(bp->sdev, le32_to_cpu(src_desc->addr),
+				       RX_PKT_BUF_SZ,
+				       DMA_FROM_DEVICE);
 }
 
 static int b44_rx(struct b44 *bp, int budget)
 {
 	int received;
 	u32 cons, prod;
@@ -769,13 +769,13 @@ static int b44_rx(struct b44 *bp, int bu
 		struct ring_info *rp = &bp->rx_buffers[cons];
 		struct sk_buff *skb = rp->skb;
 		dma_addr_t map = rp->mapping;
 		struct rx_header *rh;
 		u16 len;
 
-		dma_sync_single_for_cpu(bp->sdev->dma_dev, map,
+		ssb_dma_sync_single_for_cpu(bp->sdev, map,
 					    RX_PKT_BUF_SZ,
 					    DMA_FROM_DEVICE);
 		rh = (struct rx_header *) skb->data;
 		len = le16_to_cpu(rh->len);
 		if ((len > (RX_PKT_BUF_SZ - RX_PKT_OFFSET)) ||
 		    (rh->flags & cpu_to_le16(RX_FLAG_ERRORS))) {
@@ -803,14 +803,14 @@ static int b44_rx(struct b44 *bp, int bu
 
 		if (len > RX_COPY_THRESHOLD) {
 			int skb_size;
 			skb_size = b44_alloc_rx_skb(bp, cons, bp->rx_prod);
 			if (skb_size < 0)
 				goto drop_it;
-			dma_unmap_single(bp->sdev->dma_dev, map,
-					 skb_size, DMA_FROM_DEVICE);
+			ssb_dma_unmap_single(bp->sdev, map,
+					     skb_size, DMA_FROM_DEVICE);
 			/* Leave out rx_header */
                 	skb_put(skb, len + RX_PKT_OFFSET);
             	        skb_pull(skb, RX_PKT_OFFSET);
 		} else {
 			struct sk_buff *copy_skb;
 
@@ -963,31 +963,31 @@ static int b44_start_xmit(struct sk_buff
 		netif_stop_queue(dev);
 		printk(KERN_ERR PFX "%s: BUG! Tx Ring full when queue awake!\n",
 		       dev->name);
 		goto err_out;
 	}
 
-	mapping = dma_map_single(bp->sdev->dma_dev, skb->data, len, DMA_TO_DEVICE);
-	if (dma_mapping_error(mapping) || mapping + len > DMA_30BIT_MASK) {
+	mapping = ssb_dma_map_single(bp->sdev, skb->data, len, DMA_TO_DEVICE);
+	if (ssb_dma_mapping_error(bp->sdev, mapping) || mapping + len > DMA_30BIT_MASK) {
 		struct sk_buff *bounce_skb;
 
 		/* Chip can't handle DMA to/from >1GB, use bounce buffer */
-		if (!dma_mapping_error(mapping))
-			dma_unmap_single(bp->sdev->dma_dev, mapping, len,
-					DMA_TO_DEVICE);
+		if (!ssb_dma_mapping_error(bp->sdev, mapping))
+			ssb_dma_unmap_single(bp->sdev, mapping, len,
+					     DMA_TO_DEVICE);
 
 		bounce_skb = __dev_alloc_skb(len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb)
 			goto err_out;
 
-		mapping = dma_map_single(bp->sdev->dma_dev, bounce_skb->data,
-					 len, DMA_TO_DEVICE);
-		if (dma_mapping_error(mapping) || mapping + len > DMA_30BIT_MASK) {
-			if (!dma_mapping_error(mapping))
-				dma_unmap_single(bp->sdev->dma_dev, mapping,
-					 len, DMA_TO_DEVICE);
+		mapping = ssb_dma_map_single(bp->sdev, bounce_skb->data,
+					     len, DMA_TO_DEVICE);
+		if (ssb_dma_mapping_error(bp->sdev, mapping) || mapping + len > DMA_30BIT_MASK) {
+			if (!ssb_dma_mapping_error(bp->sdev, mapping))
+				ssb_dma_unmap_single(bp->sdev, mapping,
+						     len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(bounce_skb);
 			goto err_out;
 		}
 
 		skb_copy_from_linear_data(skb, skb_put(bounce_skb, len), len);
 		dev_kfree_skb_any(skb);
@@ -1079,26 +1079,26 @@ static void b44_free_rings(struct b44 *b
 
 	for (i = 0; i < B44_RX_RING_SIZE; i++) {
 		rp = &bp->rx_buffers[i];
 
 		if (rp->skb == NULL)
 			continue;
-		dma_unmap_single(bp->sdev->dma_dev, rp->mapping, RX_PKT_BUF_SZ,
-					DMA_FROM_DEVICE);
+		ssb_dma_unmap_single(bp->sdev, rp->mapping, RX_PKT_BUF_SZ,
+				     DMA_FROM_DEVICE);
 		dev_kfree_skb_any(rp->skb);
 		rp->skb = NULL;
 	}
 
 	/* XXX needs changes once NETIF_F_SG is set... */
 	for (i = 0; i < B44_TX_RING_SIZE; i++) {
 		rp = &bp->tx_buffers[i];
 
 		if (rp->skb == NULL)
 			continue;
-		dma_unmap_single(bp->sdev->dma_dev, rp->mapping, rp->skb->len,
-					DMA_TO_DEVICE);
+		ssb_dma_unmap_single(bp->sdev, rp->mapping, rp->skb->len,
+				     DMA_TO_DEVICE);
 		dev_kfree_skb_any(rp->skb);
 		rp->skb = NULL;
 	}
 }
 
 /* Initialize tx/rx rings for packet processing.
@@ -1114,20 +1114,20 @@ static void b44_init_rings(struct b44 *b
 	b44_free_rings(bp);
 
 	memset(bp->rx_ring, 0, B44_RX_RING_BYTES);
 	memset(bp->tx_ring, 0, B44_TX_RING_BYTES);
 
 	if (bp->flags & B44_FLAG_RX_RING_HACK)
-		dma_sync_single_for_device(bp->sdev->dma_dev, bp->rx_ring_dma,
-			                  DMA_TABLE_BYTES,
-			                  DMA_BIDIRECTIONAL);
+		ssb_dma_sync_single_for_device(bp->sdev, bp->rx_ring_dma,
+					       DMA_TABLE_BYTES,
+					       DMA_BIDIRECTIONAL);
 
 	if (bp->flags & B44_FLAG_TX_RING_HACK)
-		dma_sync_single_for_device(bp->sdev->dma_dev, bp->tx_ring_dma,
-			                  DMA_TABLE_BYTES,
-			                  DMA_TO_DEVICE);
+		ssb_dma_sync_single_for_device(bp->sdev, bp->tx_ring_dma,
+					       DMA_TABLE_BYTES,
+					       DMA_TO_DEVICE);
 
 	for (i = 0; i < bp->rx_pending; i++) {
 		if (b44_alloc_rx_skb(bp, -1, i) < 0)
 			break;
 	}
 }
@@ -1141,31 +1141,33 @@ static void b44_free_consistent(struct b
 	kfree(bp->rx_buffers);
 	bp->rx_buffers = NULL;
 	kfree(bp->tx_buffers);
 	bp->tx_buffers = NULL;
 	if (bp->rx_ring) {
 		if (bp->flags & B44_FLAG_RX_RING_HACK) {
-			dma_unmap_single(bp->sdev->dma_dev, bp->rx_ring_dma,
-					DMA_TABLE_BYTES,
-					DMA_BIDIRECTIONAL);
+			ssb_dma_unmap_single(bp->sdev, bp->rx_ring_dma,
+					     DMA_TABLE_BYTES,
+					     DMA_BIDIRECTIONAL);
 			kfree(bp->rx_ring);
 		} else
-			dma_free_coherent(bp->sdev->dma_dev, DMA_TABLE_BYTES,
-					    bp->rx_ring, bp->rx_ring_dma);
+			ssb_dma_free_consistent(bp->sdev, DMA_TABLE_BYTES,
+						bp->rx_ring, bp->rx_ring_dma,
+						GFP_KERNEL);
 		bp->rx_ring = NULL;
 		bp->flags &= ~B44_FLAG_RX_RING_HACK;
 	}
 	if (bp->tx_ring) {
 		if (bp->flags & B44_FLAG_TX_RING_HACK) {
-			dma_unmap_single(bp->sdev->dma_dev, bp->tx_ring_dma,
-					DMA_TABLE_BYTES,
-					DMA_TO_DEVICE);
+			ssb_dma_unmap_single(bp->sdev, bp->tx_ring_dma,
+					     DMA_TABLE_BYTES,
+					     DMA_TO_DEVICE);
 			kfree(bp->tx_ring);
 		} else
-			dma_free_coherent(bp->sdev->dma_dev, DMA_TABLE_BYTES,
-					    bp->tx_ring, bp->tx_ring_dma);
+			ssb_dma_free_consistent(bp->sdev, DMA_TABLE_BYTES,
+						bp->tx_ring, bp->tx_ring_dma,
+						GFP_KERNEL);
 		bp->tx_ring = NULL;
 		bp->flags &= ~B44_FLAG_TX_RING_HACK;
 	}
 }
 
 /*
@@ -1184,56 +1186,56 @@ static int b44_alloc_consistent(struct b
 	size = B44_TX_RING_SIZE * sizeof(struct ring_info);
 	bp->tx_buffers = kzalloc(size, gfp);
 	if (!bp->tx_buffers)
 		goto out_err;
 
 	size = DMA_TABLE_BYTES;
-	bp->rx_ring = dma_alloc_coherent(bp->sdev->dma_dev, size, &bp->rx_ring_dma, gfp);
+	bp->rx_ring = ssb_dma_alloc_consistent(bp->sdev, size, &bp->rx_ring_dma, gfp);
 	if (!bp->rx_ring) {
 		/* Allocation may have failed due to pci_alloc_consistent
 		   insisting on use of GFP_DMA, which is more restrictive
 		   than necessary...  */
 		struct dma_desc *rx_ring;
 		dma_addr_t rx_ring_dma;
 
 		rx_ring = kzalloc(size, gfp);
 		if (!rx_ring)
 			goto out_err;
 
-		rx_ring_dma = dma_map_single(bp->sdev->dma_dev, rx_ring,
-			                    DMA_TABLE_BYTES,
-			                    DMA_BIDIRECTIONAL);
+		rx_ring_dma = ssb_dma_map_single(bp->sdev, rx_ring,
+						 DMA_TABLE_BYTES,
+						 DMA_BIDIRECTIONAL);
 
-		if (dma_mapping_error(rx_ring_dma) ||
+		if (ssb_dma_mapping_error(bp->sdev, rx_ring_dma) ||
 			rx_ring_dma + size > DMA_30BIT_MASK) {
 			kfree(rx_ring);
 			goto out_err;
 		}
 
 		bp->rx_ring = rx_ring;
 		bp->rx_ring_dma = rx_ring_dma;
 		bp->flags |= B44_FLAG_RX_RING_HACK;
 	}
 
-	bp->tx_ring = dma_alloc_coherent(bp->sdev->dma_dev, size, &bp->tx_ring_dma, gfp);
+	bp->tx_ring = ssb_dma_alloc_consistent(bp->sdev, size, &bp->tx_ring_dma, gfp);
 	if (!bp->tx_ring) {
-		/* Allocation may have failed due to dma_alloc_coherent
+		/* Allocation may have failed due to ssb_dma_alloc_consistent
 		   insisting on use of GFP_DMA, which is more restrictive
 		   than necessary...  */
 		struct dma_desc *tx_ring;
 		dma_addr_t tx_ring_dma;
 
 		tx_ring = kzalloc(size, gfp);
 		if (!tx_ring)
 			goto out_err;
 
-		tx_ring_dma = dma_map_single(bp->sdev->dma_dev, tx_ring,
+		tx_ring_dma = ssb_dma_map_single(bp->sdev, tx_ring,
 			                    DMA_TABLE_BYTES,
 			                    DMA_TO_DEVICE);
 
-		if (dma_mapping_error(tx_ring_dma) ||
+		if (ssb_dma_mapping_error(bp->sdev, tx_ring_dma) ||
 			tx_ring_dma + size > DMA_30BIT_MASK) {
 			kfree(tx_ring);
 			goto out_err;
 		}
 
 		bp->tx_ring = tx_ring;
Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-06-20 02:04:56.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-06-20 02:07:31.000000000 +0200
@@ -325,51 +325,51 @@ static inline
     dma_addr_t map_descbuffer(struct b43_dmaring *ring,
 			      unsigned char *buf, size_t len, int tx)
 {
 	dma_addr_t dmaaddr;
 
 	if (tx) {
-		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
-					 buf, len, DMA_TO_DEVICE);
+		dmaaddr = ssb_dma_map_single(ring->dev->dev,
+					     buf, len, DMA_TO_DEVICE);
 	} else {
-		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
-					 buf, len, DMA_FROM_DEVICE);
+		dmaaddr = ssb_dma_map_single(ring->dev->dev,
+					     buf, len, DMA_FROM_DEVICE);
 	}
 
 	return dmaaddr;
 }
 
 static inline
     void unmap_descbuffer(struct b43_dmaring *ring,
 			  dma_addr_t addr, size_t len, int tx)
 {
 	if (tx) {
-		dma_unmap_single(ring->dev->dev->dma_dev,
-				 addr, len, DMA_TO_DEVICE);
+		ssb_dma_unmap_single(ring->dev->dev,
+				     addr, len, DMA_TO_DEVICE);
 	} else {
-		dma_unmap_single(ring->dev->dev->dma_dev,
-				 addr, len, DMA_FROM_DEVICE);
+		ssb_dma_unmap_single(ring->dev->dev,
+				     addr, len, DMA_FROM_DEVICE);
 	}
 }
 
 static inline
     void sync_descbuffer_for_cpu(struct b43_dmaring *ring,
 				 dma_addr_t addr, size_t len)
 {
 	B43_WARN_ON(ring->tx);
-	dma_sync_single_for_cpu(ring->dev->dev->dma_dev,
-				addr, len, DMA_FROM_DEVICE);
+	ssb_dma_sync_single_for_cpu(ring->dev->dev,
+				    addr, len, DMA_FROM_DEVICE);
 }
 
 static inline
     void sync_descbuffer_for_device(struct b43_dmaring *ring,
 				    dma_addr_t addr, size_t len)
 {
 	B43_WARN_ON(ring->tx);
-	dma_sync_single_for_device(ring->dev->dev->dma_dev,
-				   addr, len, DMA_FROM_DEVICE);
+	ssb_dma_sync_single_for_device(ring->dev->dev,
+				       addr, len, DMA_FROM_DEVICE);
 }
 
 static inline
     void free_descriptor_buffer(struct b43_dmaring *ring,
 				struct b43_dmadesc_meta *meta)
 {
@@ -378,43 +378,48 @@ static inline
 		meta->skb = NULL;
 	}
 }
 
 static int alloc_ringmemory(struct b43_dmaring *ring)
 {
-	struct device *dma_dev = ring->dev->dev->dma_dev;
 	gfp_t flags = GFP_KERNEL;
 
 	/* The specs call for 4K buffers for 30- and 32-bit DMA with 4K
 	 * alignment and 8K buffers for 64-bit DMA with 8K alignment. Testing
 	 * has shown that 4K is sufficient for the latter as long as the buffer
 	 * does not cross an 8K boundary.
 	 *
 	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
 	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
 	 * which accounts for the GFP_DMA flag below.
+	 *
+	 * The flags here must match the flags in free_ringmemory below!
 	 */
 	if (ring->type == B43_DMA_64BIT)
 		flags |= GFP_DMA;
-	ring->descbase = dma_alloc_coherent(dma_dev, B43_DMA_RINGMEMSIZE,
-					    &(ring->dmabase), flags);
+	ring->descbase = ssb_dma_alloc_consistent(ring->dev->dev,
+						  B43_DMA_RINGMEMSIZE,
+						  &(ring->dmabase), flags);
 	if (!ring->descbase) {
 		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
 		return -ENOMEM;
 	}
 	memset(ring->descbase, 0, B43_DMA_RINGMEMSIZE);
 
 	return 0;
 }
 
 static void free_ringmemory(struct b43_dmaring *ring)
 {
-	struct device *dma_dev = ring->dev->dev->dma_dev;
+	gfp_t flags = GFP_KERNEL;
+
+	if (ring->type == B43_DMA_64BIT)
+		flags |= GFP_DMA;
 
-	dma_free_coherent(dma_dev, B43_DMA_RINGMEMSIZE,
-			  ring->descbase, ring->dmabase);
+	ssb_dma_free_consistent(ring->dev->dev, B43_DMA_RINGMEMSIZE,
+				ring->descbase, ring->dmabase, flags);
 }
 
 /* Reset the RX DMA channel */
 static int b43_dmacontroller_rx_reset(struct b43_wldev *dev, u16 mmio_base,
 				      enum b43_dmatype type)
 {
@@ -515,13 +520,13 @@ static int b43_dmacontroller_tx_reset(st
 
 /* Check if a DMA mapping address is invalid. */
 static bool b43_dma_mapping_error(struct b43_dmaring *ring,
 				  dma_addr_t addr,
 				  size_t buffersize, bool dma_to_device)
 {
-	if (unlikely(dma_mapping_error(addr)))
+	if (unlikely(ssb_dma_mapping_error(ring->dev->dev, addr)))
 		return 1;
 
 	switch (ring->type) {
 	case B43_DMA_30BIT:
 		if ((u64)addr + buffersize > (1ULL << 30))
 			goto address_error;
@@ -841,44 +846,44 @@ struct b43_dmaring *b43_setup_dmaring(st
 					    b43_txhdr_size(dev),
 					    GFP_KERNEL);
 		if (!ring->txhdr_cache)
 			goto err_kfree_meta;
 
 		/* test for ability to dma to txhdr_cache */
-		dma_test = dma_map_single(dev->dev->dma_dev,
-					  ring->txhdr_cache,
-					  b43_txhdr_size(dev),
-					  DMA_TO_DEVICE);
+		dma_test = ssb_dma_map_single(dev->dev,
+					      ring->txhdr_cache,
+					      b43_txhdr_size(dev),
+					      DMA_TO_DEVICE);
 
 		if (b43_dma_mapping_error(ring, dma_test,
 					  b43_txhdr_size(dev), 1)) {
 			/* ugh realloc */
 			kfree(ring->txhdr_cache);
 			ring->txhdr_cache = kcalloc(ring->nr_slots,
 						    b43_txhdr_size(dev),
 						    GFP_KERNEL | GFP_DMA);
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
-			dma_test = dma_map_single(dev->dev->dma_dev,
-						  ring->txhdr_cache,
-						  b43_txhdr_size(dev),
-						  DMA_TO_DEVICE);
+			dma_test = ssb_dma_map_single(dev->dev,
+						      ring->txhdr_cache,
+						      b43_txhdr_size(dev),
+						      DMA_TO_DEVICE);
 
 			if (b43_dma_mapping_error(ring, dma_test,
 						  b43_txhdr_size(dev), 1)) {
 
 				b43err(dev->wl,
 				       "TXHDR DMA allocation failed\n");
 				goto err_kfree_txhdr_cache;
 			}
 		}
 
-		dma_unmap_single(dev->dev->dma_dev,
-				 dma_test, b43_txhdr_size(dev),
-				 DMA_TO_DEVICE);
+		ssb_dma_unmap_single(dev->dev,
+				     dma_test, b43_txhdr_size(dev),
+				     DMA_TO_DEVICE);
 	}
 
 	err = alloc_ringmemory(ring);
 	if (err)
 		goto err_kfree_txhdr_cache;
 	err = dmacontroller_setup(ring);
Index: wireless-testing/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/dma.c	2008-06-20 02:06:45.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/dma.c	2008-06-20 02:08:02.000000000 +0200
@@ -390,59 +390,59 @@ dma_addr_t map_descbuffer(struct b43lega
 			  size_t len,
 			  int tx)
 {
 	dma_addr_t dmaaddr;
 
 	if (tx)
-		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
-					 buf, len,
-					 DMA_TO_DEVICE);
+		dmaaddr = ssb_dma_map_single(ring->dev->dev,
+					     buf, len,
+					     DMA_TO_DEVICE);
 	else
-		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
-					 buf, len,
-					 DMA_FROM_DEVICE);
+		dmaaddr = ssb_dma_map_single(ring->dev->dev,
+					     buf, len,
+					     DMA_FROM_DEVICE);
 
 	return dmaaddr;
 }
 
 static inline
 void unmap_descbuffer(struct b43legacy_dmaring *ring,
 		      dma_addr_t addr,
 		      size_t len,
 		      int tx)
 {
 	if (tx)
-		dma_unmap_single(ring->dev->dev->dma_dev,
-				 addr, len,
-				 DMA_TO_DEVICE);
+		ssb_dma_unmap_single(ring->dev->dev,
+				     addr, len,
+				     DMA_TO_DEVICE);
 	else
-		dma_unmap_single(ring->dev->dev->dma_dev,
-				 addr, len,
-				 DMA_FROM_DEVICE);
+		ssb_dma_unmap_single(ring->dev->dev,
+				     addr, len,
+				     DMA_FROM_DEVICE);
 }
 
 static inline
 void sync_descbuffer_for_cpu(struct b43legacy_dmaring *ring,
 			     dma_addr_t addr,
 			     size_t len)
 {
 	B43legacy_WARN_ON(ring->tx);
 
-	dma_sync_single_for_cpu(ring->dev->dev->dma_dev,
-				addr, len, DMA_FROM_DEVICE);
+	ssb_dma_sync_single_for_cpu(ring->dev->dev,
+				    addr, len, DMA_FROM_DEVICE);
 }
 
 static inline
 void sync_descbuffer_for_device(struct b43legacy_dmaring *ring,
 				dma_addr_t addr,
 				size_t len)
 {
 	B43legacy_WARN_ON(ring->tx);
 
-	dma_sync_single_for_device(ring->dev->dev->dma_dev,
-				   addr, len, DMA_FROM_DEVICE);
+	ssb_dma_sync_single_for_device(ring->dev->dev,
+				       addr, len, DMA_FROM_DEVICE);
 }
 
 static inline
 void free_descriptor_buffer(struct b43legacy_dmaring *ring,
 			    struct b43legacy_dmadesc_meta *meta,
 			    int irq_context)
@@ -455,32 +455,31 @@ void free_descriptor_buffer(struct b43le
 		meta->skb = NULL;
 	}
 }
 
 static int alloc_ringmemory(struct b43legacy_dmaring *ring)
 {
-	struct device *dma_dev = ring->dev->dev->dma_dev;
-
-	ring->descbase = dma_alloc_coherent(dma_dev, B43legacy_DMA_RINGMEMSIZE,
-					    &(ring->dmabase), GFP_KERNEL);
+	/* GFP flags must match the flags in free_ringmemory()! */
+	ring->descbase = ssb_dma_alloc_consistent(ring->dev->dev,
+						  B43legacy_DMA_RINGMEMSIZE,
+						  &(ring->dmabase),
+						  GFP_KERNEL);
 	if (!ring->descbase) {
 		b43legacyerr(ring->dev->wl, "DMA ringmemory allocation"
 			     " failed\n");
 		return -ENOMEM;
 	}
 	memset(ring->descbase, 0, B43legacy_DMA_RINGMEMSIZE);
 
 	return 0;
 }
 
 static void free_ringmemory(struct b43legacy_dmaring *ring)
 {
-	struct device *dma_dev = ring->dev->dev->dma_dev;
-
-	dma_free_coherent(dma_dev, B43legacy_DMA_RINGMEMSIZE,
-			  ring->descbase, ring->dmabase);
+	ssb_dma_free_consistent(ring->dev->dev, B43legacy_DMA_RINGMEMSIZE,
+				ring->descbase, ring->dmabase, GFP_KERNEL);
 }
 
 /* Reset the RX DMA channel */
 static int b43legacy_dmacontroller_rx_reset(struct b43legacy_wldev *dev,
 					    u16 mmio_base,
 					    enum b43legacy_dmatype type)
@@ -586,13 +585,13 @@ static int b43legacy_dmacontroller_tx_re
 /* Check if a DMA mapping address is invalid. */
 static bool b43legacy_dma_mapping_error(struct b43legacy_dmaring *ring,
 					 dma_addr_t addr,
 					 size_t buffersize,
 					 bool dma_to_device)
 {
-	if (unlikely(dma_mapping_error(addr)))
+	if (unlikely(ssb_dma_mapping_error(ring->dev->dev, addr)))
 		return 1;
 
 	switch (ring->type) {
 	case B43legacy_DMA_30BIT:
 		if ((u64)addr + buffersize > (1ULL << 30))
 			goto address_error;
@@ -891,39 +890,39 @@ struct b43legacy_dmaring *b43legacy_setu
 					sizeof(struct b43legacy_txhdr_fw3),
 					GFP_KERNEL);
 		if (!ring->txhdr_cache)
 			goto err_kfree_meta;
 
 		/* test for ability to dma to txhdr_cache */
-		dma_test = dma_map_single(dev->dev->dma_dev, ring->txhdr_cache,
-					  sizeof(struct b43legacy_txhdr_fw3),
-					  DMA_TO_DEVICE);
+		dma_test = ssb_dma_map_single(dev->dev, ring->txhdr_cache,
+					      sizeof(struct b43legacy_txhdr_fw3),
+					      DMA_TO_DEVICE);
 
 		if (b43legacy_dma_mapping_error(ring, dma_test,
 					sizeof(struct b43legacy_txhdr_fw3), 1)) {
 			/* ugh realloc */
 			kfree(ring->txhdr_cache);
 			ring->txhdr_cache = kcalloc(nr_slots,
 					sizeof(struct b43legacy_txhdr_fw3),
 					GFP_KERNEL | GFP_DMA);
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
-			dma_test = dma_map_single(dev->dev->dma_dev,
+			dma_test = ssb_dma_map_single(dev->dev,
 					ring->txhdr_cache,
 					sizeof(struct b43legacy_txhdr_fw3),
 					DMA_TO_DEVICE);
 
 			if (b43legacy_dma_mapping_error(ring, dma_test,
 					sizeof(struct b43legacy_txhdr_fw3), 1))
 				goto err_kfree_txhdr_cache;
 		}
 
-		dma_unmap_single(dev->dev->dma_dev,
-				 dma_test, sizeof(struct b43legacy_txhdr_fw3),
-				 DMA_TO_DEVICE);
+		ssb_dma_unmap_single(dev->dev, dma_test,
+				     sizeof(struct b43legacy_txhdr_fw3),
+				     DMA_TO_DEVICE);
 	}
 
 	ring->nr_slots = nr_slots;
 	ring->mmio_base = b43legacy_dmacontroller_base(type, controller_index);
 	ring->index = controller_index;
 	if (type == B43legacy_DMA_64BIT)
Index: wireless-testing/drivers/ssb/Kconfig
===================================================================
--- wireless-testing.orig/drivers/ssb/Kconfig	2008-06-20 02:04:56.000000000 +0200
+++ wireless-testing/drivers/ssb/Kconfig	2008-06-20 02:07:31.000000000 +0200
@@ -1,11 +1,11 @@
 menu "Sonics Silicon Backplane"
 
 config SSB_POSSIBLE
 	bool
-	depends on HAS_IOMEM
+	depends on HAS_IOMEM && HAS_DMA
 	default y
 
 config SSB
 	tristate "Sonics Silicon Backplane support"
 	depends on SSB_POSSIBLE
 	help
Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2008-06-20 02:04:56.000000000 +0200
+++ wireless-testing/drivers/ssb/main.c	2008-06-20 02:07:31.000000000 +0200
@@ -459,24 +459,21 @@ static int ssb_devices_register(struct s
 
 		switch (bus->bustype) {
 		case SSB_BUSTYPE_PCI:
 #ifdef CONFIG_SSB_PCIHOST
 			sdev->irq = bus->host_pci->irq;
 			dev->parent = &bus->host_pci->dev;
-			sdev->dma_dev = &bus->host_pci->dev;
 #endif
 			break;
 		case SSB_BUSTYPE_PCMCIA:
 #ifdef CONFIG_SSB_PCMCIAHOST
 			sdev->irq = bus->host_pcmcia->irq.AssignedIRQ;
 			dev->parent = &bus->host_pcmcia->dev;
-			sdev->dma_dev = &bus->host_pcmcia->dev;
 #endif
 			break;
 		case SSB_BUSTYPE_SSB:
-			sdev->dma_dev = dev;
 			break;
 		}
 
 		sdev->dev = dev;
 		err = device_register(dev);
 		if (err) {
@@ -1153,42 +1150,88 @@ void ssb_device_disable(struct ssb_devic
 EXPORT_SYMBOL(ssb_device_disable);
 
 u32 ssb_dma_translation(struct ssb_device *dev)
 {
 	switch (dev->bus->bustype) {
 	case SSB_BUSTYPE_SSB:
-	case SSB_BUSTYPE_PCMCIA:
 		return 0;
 	case SSB_BUSTYPE_PCI:
 		return SSB_PCI_DMA;
+	default:
+		__ssb_dma_not_implemented(dev);
 	}
 	return 0;
 }
 EXPORT_SYMBOL(ssb_dma_translation);
 
-int ssb_dma_set_mask(struct ssb_device *ssb_dev, u64 mask)
+int ssb_dma_set_mask(struct ssb_device *dev, u64 mask)
 {
-	struct device *dma_dev = ssb_dev->dma_dev;
-	int err = 0;
+	int err;
 
-#ifdef CONFIG_SSB_PCIHOST
-	if (ssb_dev->bus->bustype == SSB_BUSTYPE_PCI) {
-		err = pci_set_dma_mask(ssb_dev->bus->host_pci, mask);
+	switch (dev->bus->bustype) {
+	case SSB_BUSTYPE_PCI:
+		err = pci_set_dma_mask(dev->bus->host_pci, mask);
 		if (err)
 			return err;
-		err = pci_set_consistent_dma_mask(ssb_dev->bus->host_pci, mask);
+		err = pci_set_consistent_dma_mask(dev->bus->host_pci, mask);
 		return err;
+	case SSB_BUSTYPE_SSB:
+		return dma_set_mask(dev->dev, mask);
+	default:
+		__ssb_dma_not_implemented(dev);
 	}
-#endif
-	dma_dev->coherent_dma_mask = mask;
-	dma_dev->dma_mask = &dma_dev->coherent_dma_mask;
-
-	return err;
+	return -ENOSYS;
 }
 EXPORT_SYMBOL(ssb_dma_set_mask);
 
+void * ssb_dma_alloc_consistent(struct ssb_device *dev, size_t size,
+				dma_addr_t *dma_handle, gfp_t gfp_flags)
+{
+	switch (dev->bus->bustype) {
+	case SSB_BUSTYPE_PCI:
+		if (gfp_flags & GFP_DMA) {
+			/* Workaround: The PCI API does not support passing
+			 * a GFP flag. */
+			return dma_alloc_coherent(&dev->bus->host_pci->dev,
+						  size, dma_handle, gfp_flags);
+		}
+		return pci_alloc_consistent(dev->bus->host_pci, size, dma_handle);
+	case SSB_BUSTYPE_SSB:
+		return dma_alloc_coherent(dev->dev, size, dma_handle, gfp_flags);
+	default:
+		__ssb_dma_not_implemented(dev);
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(ssb_dma_alloc_consistent);
+
+void ssb_dma_free_consistent(struct ssb_device *dev, size_t size,
+			     void *vaddr, dma_addr_t dma_handle,
+			     gfp_t gfp_flags)
+{
+	switch (dev->bus->bustype) {
+	case SSB_BUSTYPE_PCI:
+		if (gfp_flags & GFP_DMA) {
+			/* Workaround: The PCI API does not support passing
+			 * a GFP flag. */
+			dma_free_coherent(&dev->bus->host_pci->dev,
+					  size, vaddr, dma_handle);
+			return;
+		}
+		pci_free_consistent(dev->bus->host_pci, size,
+				    vaddr, dma_handle);
+		return;
+	case SSB_BUSTYPE_SSB:
+		dma_free_coherent(dev->dev, size, vaddr, dma_handle);
+		return;
+	default:
+		__ssb_dma_not_implemented(dev);
+	}
+}
+EXPORT_SYMBOL(ssb_dma_free_consistent);
+
 int ssb_bus_may_powerdown(struct ssb_bus *bus)
 {
 	struct ssb_chipcommon *cc;
 	int err = 0;
 
 	/* On buses where more than one core may be working
Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h	2008-06-20 02:04:56.000000000 +0200
+++ wireless-testing/include/linux/ssb/ssb.h	2008-06-20 02:07:31.000000000 +0200
@@ -134,15 +134,12 @@ struct __ssb_dev_wrapper {
 struct ssb_device {
 	/* Having a copy of the ops pointer in each dev struct
 	 * is an optimization. */
 	const struct ssb_bus_ops *ops;
 
 	struct device *dev;
-	/* Pointer to the device that has to be used for
-	 * any DMA related operation. */
-	struct device *dma_dev;
 
 	struct ssb_bus *bus;
 	struct ssb_device_id id;
 
 	u8 core_index;
 	unsigned int irq;
@@ -396,19 +393,157 @@ static inline void ssb_block_write(struc
 {
 	dev->ops->block_write(dev, buffer, count, offset, reg_width);
 }
 #endif /* CONFIG_SSB_BLOCKIO */
 
 
+/* The SSB DMA API. Use this API for any DMA operation on the device.
+ * This API basically is a wrapper that calls the correct DMA API for
+ * the host device type the SSB device is attached to. */
+
 /* Translation (routing) bits that need to be ORed to DMA
  * addresses before they are given to a device. */
 extern u32 ssb_dma_translation(struct ssb_device *dev);
 #define SSB_DMA_TRANSLATION_MASK	0xC0000000
 #define SSB_DMA_TRANSLATION_SHIFT	30
 
-extern int ssb_dma_set_mask(struct ssb_device *ssb_dev, u64 mask);
+extern int ssb_dma_set_mask(struct ssb_device *dev, u64 mask);
+
+extern void * ssb_dma_alloc_consistent(struct ssb_device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t gfp_flags);
+extern void ssb_dma_free_consistent(struct ssb_device *dev, size_t size,
+				    void *vaddr, dma_addr_t dma_handle,
+				    gfp_t gfp_flags);
+
+static inline void __cold __ssb_dma_not_implemented(struct ssb_device *dev)
+{
+#ifdef CONFIG_SSB_DEBUG
+	printk(KERN_ERR "SSB: BUG! Calling DMA API for "
+	       "unsupported bustype %d\n", dev->bus->bustype);
+#endif /* DEBUG */
+}
+
+static inline int ssb_dma_mapping_error(struct ssb_device *dev, dma_addr_t addr)
+{
+	switch (dev->bus->bustype) {
+	case SSB_BUSTYPE_PCI:
+		return pci_dma_mapping_error(addr);
+	case SSB_BUSTYPE_SSB:
+		return dma_mapping_error(addr);
+	default:
+		__ssb_dma_not_implemented(dev);
+	}
+	return -ENOSYS;
+}
+
+static inline dma_addr_t ssb_dma_map_single(struct ssb_device *dev, void *p,
+					    size_t size, enum dma_data_direction dir)
+{
+	switch (dev->bus->bustype) {
+	case SSB_BUSTYPE_PCI:
+		return pci_map_single(dev->bus->host_pci, p, size, dir);
+	case SSB_BUSTYPE_SSB:
+		return dma_map_single(dev->dev, p, size, dir);
+	default:
+		__ssb_dma_not_implemented(dev);
+	}
+	return 0;
+}
+
+static inline void ssb_dma_unmap_single(struct ssb_device *dev, dma_addr_t dma_addr,
+					size_t size, enum dma_data_direction dir)
+{
+	switch (dev->bus->bustype) {
+	case SSB_BUSTYPE_PCI:
+		pci_unmap_single(dev->bus->host_pci, dma_addr, size, dir);
+		return;
+	case SSB_BUSTYPE_SSB:
+		dma_unmap_single(dev->dev, dma_addr, size, dir);
+		return;
+	default:
+		__ssb_dma_not_implemented(dev);
+	}
+}
+
+static inline void ssb_dma_sync_single_for_cpu(struct ssb_device *dev,
+					       dma_addr_t dma_addr,
+					       size_t size,
+					       enum dma_data_direction dir)
+{
+	switch (dev->bus->bustype) {
+	case SSB_BUSTYPE_PCI:
+		pci_dma_sync_single_for_cpu(dev->bus->host_pci, dma_addr,
+					    size, dir);
+		return;
+	case SSB_BUSTYPE_SSB:
+		dma_sync_single_for_cpu(dev->dev, dma_addr, size, dir);
+		return;
+	default:
+		__ssb_dma_not_implemented(dev);
+	}
+}
+
+static inline void ssb_dma_sync_single_for_device(struct ssb_device *dev,
+						  dma_addr_t dma_addr,
+						  size_t size,
+						  enum dma_data_direction dir)
+{
+	switch (dev->bus->bustype) {
+	case SSB_BUSTYPE_PCI:
+		pci_dma_sync_single_for_device(dev->bus->host_pci, dma_addr,
+					       size, dir);
+		return;
+	case SSB_BUSTYPE_SSB:
+		dma_sync_single_for_device(dev->dev, dma_addr, size, dir);
+		return;
+	default:
+		__ssb_dma_not_implemented(dev);
+	}
+}
+
+static inline void ssb_dma_sync_single_range_for_cpu(struct ssb_device *dev,
+						     dma_addr_t dma_addr,
+						     unsigned long offset,
+						     size_t size,
+						     enum dma_data_direction dir)
+{
+	switch (dev->bus->bustype) {
+	case SSB_BUSTYPE_PCI:
+		/* Just sync everything. That's all the PCI API can do. */
+		pci_dma_sync_single_for_cpu(dev->bus->host_pci, dma_addr,
+					    offset + size, dir);
+		return;
+	case SSB_BUSTYPE_SSB:
+		dma_sync_single_range_for_cpu(dev->dev, dma_addr, offset,
+					      size, dir);
+		return;
+	default:
+		__ssb_dma_not_implemented(dev);
+	}
+}
+
+static inline void ssb_dma_sync_single_range_for_device(struct ssb_device *dev,
+							dma_addr_t dma_addr,
+							unsigned long offset,
+							size_t size,
+							enum dma_data_direction dir)
+{
+	switch (dev->bus->bustype) {
+	case SSB_BUSTYPE_PCI:
+		/* Just sync everything. That's all the PCI API can do. */
+		pci_dma_sync_single_for_device(dev->bus->host_pci, dma_addr,
+					       offset + size, dir);
+		return;
+	case SSB_BUSTYPE_SSB:
+		dma_sync_single_range_for_device(dev->dev, dma_addr, offset,
+						 size, dir);
+		return;
+	default:
+		__ssb_dma_not_implemented(dev);
+	}
+}
 
 
 #ifdef CONFIG_SSB_PCIHOST
 /* PCI-host wrapper driver */
 extern int ssb_pcihost_register(struct pci_driver *driver);
 static inline void ssb_pcihost_unregister(struct pci_driver *driver)
