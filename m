Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:32956 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603AbYDKKPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 06:15:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: Fix usage of struct device used for DMAing
Date: Fri, 11 Apr 2008 12:13:03 +0200
Cc: bcm43xx-dev@lists.berlios.de,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200804111213.03606.mb@bu3sch.de> (sfid-20080411_111513_816177_1FC073FA)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes b43legacy for the SSB DMA API change.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>

---

John, this is a bugfix for 2.6.25


Index: wireless-testing/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/dma.c	2008-02-16 19:08:12.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43legacy/dma.c	2008-04-11 12:07:56.000000000 +0200
@@ -393,11 +393,11 @@ dma_addr_t map_descbuffer(struct b43lega
 	dma_addr_t dmaaddr;
 
 	if (tx)
-		dmaaddr = dma_map_single(ring->dev->dev->dev,
+		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
 					 buf, len,
 					 DMA_TO_DEVICE);
 	else
-		dmaaddr = dma_map_single(ring->dev->dev->dev,
+		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
 					 buf, len,
 					 DMA_FROM_DEVICE);
 
@@ -411,11 +411,11 @@ void unmap_descbuffer(struct b43legacy_d
 		      int tx)
 {
 	if (tx)
-		dma_unmap_single(ring->dev->dev->dev,
+		dma_unmap_single(ring->dev->dev->dma_dev,
 				 addr, len,
 				 DMA_TO_DEVICE);
 	else
-		dma_unmap_single(ring->dev->dev->dev,
+		dma_unmap_single(ring->dev->dev->dma_dev,
 				 addr, len,
 				 DMA_FROM_DEVICE);
 }
@@ -458,9 +458,9 @@ void free_descriptor_buffer(struct b43le
 
 static int alloc_ringmemory(struct b43legacy_dmaring *ring)
 {
-	struct device *dev = ring->dev->dev->dev;
+	struct device *dma_dev = ring->dev->dev->dma_dev;
 
-	ring->descbase = dma_alloc_coherent(dev, B43legacy_DMA_RINGMEMSIZE,
+	ring->descbase = dma_alloc_coherent(dma_dev, B43legacy_DMA_RINGMEMSIZE,
 					    &(ring->dmabase), GFP_KERNEL);
 	if (!ring->descbase) {
 		b43legacyerr(ring->dev->wl, "DMA ringmemory allocation"
@@ -474,9 +474,9 @@ static int alloc_ringmemory(struct b43le
 
 static void free_ringmemory(struct b43legacy_dmaring *ring)
 {
-	struct device *dev = ring->dev->dev->dev;
+	struct device *dma_dev = ring->dev->dev->dma_dev;
 
-	dma_free_coherent(dev, B43legacy_DMA_RINGMEMSIZE,
+	dma_free_coherent(dma_dev, B43legacy_DMA_RINGMEMSIZE,
 			  ring->descbase, ring->dmabase);
 }
 
@@ -886,7 +886,7 @@ struct b43legacy_dmaring *b43legacy_setu
 			goto err_kfree_meta;
 
 		/* test for ability to dma to txhdr_cache */
-		dma_test = dma_map_single(dev->dev->dev, ring->txhdr_cache,
+		dma_test = dma_map_single(dev->dev->dma_dev, ring->txhdr_cache,
 					  sizeof(struct b43legacy_txhdr_fw3),
 					  DMA_TO_DEVICE);
 
@@ -900,7 +900,7 @@ struct b43legacy_dmaring *b43legacy_setu
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
-			dma_test = dma_map_single(dev->dev->dev,
+			dma_test = dma_map_single(dev->dev->dma_dev,
 					ring->txhdr_cache,
 					sizeof(struct b43legacy_txhdr_fw3),
 					DMA_TO_DEVICE);
@@ -910,7 +910,7 @@ struct b43legacy_dmaring *b43legacy_setu
 				goto err_kfree_txhdr_cache;
 		}
 
-		dma_unmap_single(dev->dev->dev,
+		dma_unmap_single(dev->dev->dma_dev,
 				 dma_test, sizeof(struct b43legacy_txhdr_fw3),
 				 DMA_TO_DEVICE);
 	}

-- 
Greetings Michael.
