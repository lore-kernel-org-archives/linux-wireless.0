Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59127 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1HXTkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 15:40:37 -0400
Date: Wed, 24 Aug 2011 14:40:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: zajec5@gmail.com
Cc: Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [RFC/RFT] b43: Relax requirement for descriptors to be in the DMA zone
Message-ID: <4e5553a8.vSmpTZc2Cr8jeze3%Larry.Finger@lwfinger.net> (sfid-20110824_214043_534418_23ABC321)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When 64-bit DMA was first used, there were problems with the
BCM4311 (14e4:4311). The problem was "fixed" by using the GFP_DMA
flag in the allocation of coherent ring descriptor memory.

The original problem is now believed to have been due to bugs in
the 64-bit DMA implementation in the rest of the kernel, and that
those bugs have been fixed. Accordingly, relaxation of the
requirement for the descriptors to be in the DMA zone is relaxed.

When a bounce buffer is needed, that is left in the DMA zone.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

@Michael - Your idea seems to be correct.

@Rafal - Incorporate this in your other patch.


Index: wireless-testing-new/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43/dma.c
+++ wireless-testing-new/drivers/net/wireless/b43/dma.c
@@ -393,14 +393,7 @@ static int alloc_ringmemory(struct b43_d
 	 * has shown that 4K is sufficient for the latter as long as the buffer
 	 * does not cross an 8K boundary.
 	 *
-	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
-	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
-	 * which accounts for the GFP_DMA flag below.
-	 *
-	 * The flags here must match the flags in free_ringmemory below!
 	 */
-	if (ring->type == B43_DMA_64BIT)
-		flags |= GFP_DMA;
 	ring->descbase = dma_alloc_coherent(ring->dev->dev->dma_dev,
 					    B43_DMA_RINGMEMSIZE,
 					    &(ring->dmabase), flags);
@@ -589,7 +582,7 @@ static int setup_rx_descbuffer(struct b4
 	dmaaddr = map_descbuffer(ring, skb->data, ring->rx_buffersize, 0);
 	if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize, 0)) {
 		/* ugh. try to realloc in zone_dma */
-		gfp_flags |= GFP_DMA;
+		gfp_flags |= GFP_KERNEL;
 
 		dev_kfree_skb_any(skb);
 
@@ -903,7 +896,7 @@ struct b43_dmaring *b43_setup_dmaring(st
 			kfree(ring->txhdr_cache);
 			ring->txhdr_cache = kcalloc(ring->nr_slots / TX_SLOTS_PER_FRAME,
 						    b43_txhdr_size(dev),
-						    GFP_KERNEL | GFP_DMA);
+						    GFP_KERNEL);
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
