Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757036Ab0FDCiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 22:38:20 -0400
Message-Id: <201006040237.o542bXLv001415@imap1.linux-foundation.org>
Subject: [patch 3/5] b43: replace the ssb_dma API with the generic DMA API
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	fujita.tomonori@lab.ntt.co.jp, Larry.Finger@lwfinger.net,
	davem@davemloft.net, mb@bu3sch.de, stefano.brivio@polimi.it
From: akpm@linux-foundation.org
Date: Thu, 03 Jun 2010 19:37:36 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Stefano Brivio <stefano.brivio@polimi.it>
Cc: John W. Linville <linville@tuxdriver.com>
Acked-by: Michael Buesch <mb@bu3sch.de>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/dma.c |   65 ++++++++++++++++---------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff -puN drivers/net/wireless/b43/dma.c~b43-replace-the-ssb_dma-api-with-the-generic-dma-api drivers/net/wireless/b43/dma.c
--- a/drivers/net/wireless/b43/dma.c~b43-replace-the-ssb_dma-api-with-the-generic-dma-api
+++ a/drivers/net/wireless/b43/dma.c
@@ -333,11 +333,11 @@ static inline
 	dma_addr_t dmaaddr;
 
 	if (tx) {
-		dmaaddr = ssb_dma_map_single(ring->dev->dev,
-					     buf, len, DMA_TO_DEVICE);
+		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
+					 buf, len, DMA_TO_DEVICE);
 	} else {
-		dmaaddr = ssb_dma_map_single(ring->dev->dev,
-					     buf, len, DMA_FROM_DEVICE);
+		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
+					 buf, len, DMA_FROM_DEVICE);
 	}
 
 	return dmaaddr;
@@ -348,11 +348,11 @@ static inline
 			  dma_addr_t addr, size_t len, int tx)
 {
 	if (tx) {
-		ssb_dma_unmap_single(ring->dev->dev,
-				     addr, len, DMA_TO_DEVICE);
+		dma_unmap_single(ring->dev->dev->dma_dev,
+				 addr, len, DMA_TO_DEVICE);
 	} else {
-		ssb_dma_unmap_single(ring->dev->dev,
-				     addr, len, DMA_FROM_DEVICE);
+		dma_unmap_single(ring->dev->dev->dma_dev,
+				 addr, len, DMA_FROM_DEVICE);
 	}
 }
 
@@ -361,7 +361,7 @@ static inline
 				 dma_addr_t addr, size_t len)
 {
 	B43_WARN_ON(ring->tx);
-	ssb_dma_sync_single_for_cpu(ring->dev->dev,
+	dma_sync_single_for_cpu(ring->dev->dev->dma_dev,
 				    addr, len, DMA_FROM_DEVICE);
 }
 
@@ -370,8 +370,8 @@ static inline
 				    dma_addr_t addr, size_t len)
 {
 	B43_WARN_ON(ring->tx);
-	ssb_dma_sync_single_for_device(ring->dev->dev,
-				       addr, len, DMA_FROM_DEVICE);
+	dma_sync_single_for_device(ring->dev->dev->dma_dev,
+				   addr, len, DMA_FROM_DEVICE);
 }
 
 static inline
@@ -401,9 +401,9 @@ static int alloc_ringmemory(struct b43_d
 	 */
 	if (ring->type == B43_DMA_64BIT)
 		flags |= GFP_DMA;
-	ring->descbase = ssb_dma_alloc_consistent(ring->dev->dev,
-						  B43_DMA_RINGMEMSIZE,
-						  &(ring->dmabase), flags);
+	ring->descbase = dma_alloc_coherent(ring->dev->dev->dma_dev,
+					    B43_DMA_RINGMEMSIZE,
+					    &(ring->dmabase), flags);
 	if (!ring->descbase) {
 		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
 		return -ENOMEM;
@@ -420,8 +420,8 @@ static void free_ringmemory(struct b43_d
 	if (ring->type == B43_DMA_64BIT)
 		flags |= GFP_DMA;
 
-	ssb_dma_free_consistent(ring->dev->dev, B43_DMA_RINGMEMSIZE,
-				ring->descbase, ring->dmabase, flags);
+	dma_free_coherent(ring->dev->dev->dma_dev, B43_DMA_RINGMEMSIZE,
+			  ring->descbase, ring->dmabase);
 }
 
 /* Reset the RX DMA channel */
@@ -528,7 +528,7 @@ static bool b43_dma_mapping_error(struct
 				  dma_addr_t addr,
 				  size_t buffersize, bool dma_to_device)
 {
-	if (unlikely(ssb_dma_mapping_error(ring->dev->dev, addr)))
+	if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
 		return 1;
 
 	switch (ring->type) {
@@ -874,10 +874,10 @@ struct b43_dmaring *b43_setup_dmaring(st
 			goto err_kfree_meta;
 
 		/* test for ability to dma to txhdr_cache */
-		dma_test = ssb_dma_map_single(dev->dev,
-					      ring->txhdr_cache,
-					      b43_txhdr_size(dev),
-					      DMA_TO_DEVICE);
+		dma_test = dma_map_single(dev->dev->dma_dev,
+					  ring->txhdr_cache,
+					  b43_txhdr_size(dev),
+					  DMA_TO_DEVICE);
 
 		if (b43_dma_mapping_error(ring, dma_test,
 					  b43_txhdr_size(dev), 1)) {
@@ -889,10 +889,10 @@ struct b43_dmaring *b43_setup_dmaring(st
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
-			dma_test = ssb_dma_map_single(dev->dev,
-						      ring->txhdr_cache,
-						      b43_txhdr_size(dev),
-						      DMA_TO_DEVICE);
+			dma_test = dma_map_single(dev->dev->dma_dev,
+						  ring->txhdr_cache,
+						  b43_txhdr_size(dev),
+						  DMA_TO_DEVICE);
 
 			if (b43_dma_mapping_error(ring, dma_test,
 						  b43_txhdr_size(dev), 1)) {
@@ -903,9 +903,9 @@ struct b43_dmaring *b43_setup_dmaring(st
 			}
 		}
 
-		ssb_dma_unmap_single(dev->dev,
-				     dma_test, b43_txhdr_size(dev),
-				     DMA_TO_DEVICE);
+		dma_unmap_single(dev->dev->dma_dev,
+				 dma_test, b43_txhdr_size(dev),
+				 DMA_TO_DEVICE);
 	}
 
 	err = alloc_ringmemory(ring);
@@ -1018,9 +1018,12 @@ static int b43_dma_set_mask(struct b43_w
 	/* Try to set the DMA mask. If it fails, try falling back to a
 	 * lower mask, as we can always also support a lower one. */
 	while (1) {
-		err = ssb_dma_set_mask(dev->dev, mask);
-		if (!err)
-			break;
+		err = dma_set_mask(dev->dev->dma_dev, mask);
+		if (!err) {
+			err = dma_set_coherent_mask(dev->dev->dma_dev, mask);
+			if (!err)
+				break;
+		}
 		if (mask == DMA_BIT_MASK(64)) {
 			mask = DMA_BIT_MASK(32);
 			fallback = 1;
_
