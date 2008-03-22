Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41823 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYCVVH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2008 17:07:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix DMA mapping leakage
Date: Sat, 22 Mar 2008 22:04:45 +0100
Cc: Christian Casteyde <casteyde.christian@free.fr>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803222204.45919.mb@bu3sch.de> (sfid-20080322_210733_407649_E61BB399)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a DMA mapping leakage in the case where we reject a DMA
buffer because of its address.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Christian Casteyde <casteyde.christian@free.fr>

---

John, this is a fix for 2.6.25.


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-03-22 21:50:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-03-22 21:57:53.000000000 +0100
@@ -512,34 +512,40 @@ static int b43_dmacontroller_tx_reset(st
 	return 0;
 }
 
 /* Check if a DMA mapping address is invalid. */
 static bool b43_dma_mapping_error(struct b43_dmaring *ring,
 				  dma_addr_t addr,
-				  size_t buffersize)
+				  size_t buffersize, bool dma_to_device)
 {
 	if (unlikely(dma_mapping_error(addr)))
 		return 1;
 
 	switch (ring->type) {
 	case B43_DMA_30BIT:
 		if ((u64)addr + buffersize > (1ULL << 30))
-			return 1;
+			goto address_error;
 		break;
 	case B43_DMA_32BIT:
 		if ((u64)addr + buffersize > (1ULL << 32))
-			return 1;
+			goto address_error;
 		break;
 	case B43_DMA_64BIT:
 		/* Currently we can't have addresses beyond
 		 * 64bit in the kernel. */
 		break;
 	}
 
 	/* The address is OK. */
 	return 0;
+
+address_error:
+	/* We can't support this address. Unmap it again. */
+	unmap_descbuffer(ring, addr, buffersize, dma_to_device);
+
+	return 1;
 }
 
 static int setup_rx_descbuffer(struct b43_dmaring *ring,
 			       struct b43_dmadesc_generic *desc,
 			       struct b43_dmadesc_meta *meta, gfp_t gfp_flags)
 {
@@ -551,26 +557,26 @@ static int setup_rx_descbuffer(struct b4
 	B43_WARN_ON(ring->tx);
 
 	skb = __dev_alloc_skb(ring->rx_buffersize, gfp_flags);
 	if (unlikely(!skb))
 		return -ENOMEM;
 	dmaaddr = map_descbuffer(ring, skb->data, ring->rx_buffersize, 0);
-	if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize)) {
+	if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize, 0)) {
 		/* ugh. try to realloc in zone_dma */
 		gfp_flags |= GFP_DMA;
 
 		dev_kfree_skb_any(skb);
 
 		skb = __dev_alloc_skb(ring->rx_buffersize, gfp_flags);
 		if (unlikely(!skb))
 			return -ENOMEM;
 		dmaaddr = map_descbuffer(ring, skb->data,
 					 ring->rx_buffersize, 0);
 	}
 
-	if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize)) {
+	if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize, 0)) {
 		dev_kfree_skb_any(skb);
 		return -EIO;
 	}
 
 	meta->skb = skb;
 	meta->dmaaddr = dmaaddr;
@@ -804,13 +810,14 @@ struct b43_dmaring *b43_setup_dmaring(st
 		/* test for ability to dma to txhdr_cache */
 		dma_test = dma_map_single(dev->dev->dev,
 					  ring->txhdr_cache,
 					  b43_txhdr_size(dev),
 					  DMA_TO_DEVICE);
 
-		if (b43_dma_mapping_error(ring, dma_test, b43_txhdr_size(dev))) {
+		if (b43_dma_mapping_error(ring, dma_test,
+					  b43_txhdr_size(dev), 1)) {
 			/* ugh realloc */
 			kfree(ring->txhdr_cache);
 			ring->txhdr_cache = kcalloc(nr_slots,
 						    b43_txhdr_size(dev),
 						    GFP_KERNEL | GFP_DMA);
 			if (!ring->txhdr_cache)
@@ -819,13 +826,13 @@ struct b43_dmaring *b43_setup_dmaring(st
 			dma_test = dma_map_single(dev->dev->dev,
 						  ring->txhdr_cache,
 						  b43_txhdr_size(dev),
 						  DMA_TO_DEVICE);
 
 			if (b43_dma_mapping_error(ring, dma_test,
-						  b43_txhdr_size(dev)))
+						  b43_txhdr_size(dev), 1))
 				goto err_kfree_txhdr_cache;
 		}
 
 		dma_unmap_single(dev->dev->dev,
 				 dma_test, b43_txhdr_size(dev),
 				 DMA_TO_DEVICE);
@@ -1120,13 +1127,13 @@ static int dma_tx_fragment(struct b43_dm
 		ring->used_slots = old_used_slots;
 		return err;
 	}
 
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
 					   hdrsize, 1);
-	if (b43_dma_mapping_error(ring, meta_hdr->dmaaddr, hdrsize)) {
+	if (b43_dma_mapping_error(ring, meta_hdr->dmaaddr, hdrsize, 1)) {
 		ring->current_slot = old_top_slot;
 		ring->used_slots = old_used_slots;
 		return -EIO;
 	}
 	ops->fill_descriptor(ring, desc, meta_hdr->dmaaddr,
 			     hdrsize, 1, 0, 0);
@@ -1139,13 +1146,13 @@ static int dma_tx_fragment(struct b43_dm
 	memcpy(&meta->txstat.control, ctl, sizeof(*ctl));
 	meta->skb = skb;
 	meta->is_last_fragment = 1;
 
 	meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 	/* create a bounce buffer in zone_dma on mapping failure. */
-	if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len)) {
+	if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
 		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb) {
 			ring->current_slot = old_top_slot;
 			ring->used_slots = old_used_slots;
 			err = -ENOMEM;
 			goto out_unmap_hdr;
@@ -1153,13 +1160,13 @@ static int dma_tx_fragment(struct b43_dm
 
 		memcpy(skb_put(bounce_skb, skb->len), skb->data, skb->len);
 		dev_kfree_skb_any(skb);
 		skb = bounce_skb;
 		meta->skb = skb;
 		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
-		if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len)) {
+		if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
 			ring->current_slot = old_top_slot;
 			ring->used_slots = old_used_slots;
 			err = -EIO;
 			goto out_free_bounce;
 		}
 	}
