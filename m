Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932138Ab0FDCib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 22:38:31 -0400
Message-Id: <201006040237.o542bT8f001412@imap1.linux-foundation.org>
Subject: [patch 2/5] b43legacy: replace the ssb_dma API with the generic DMA API
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	fujita.tomonori@lab.ntt.co.jp, Larry.Finger@lwfinger.net,
	davem@davemloft.net, mb@bu3sch.de, stefano.brivio@polimi.it
From: akpm@linux-foundation.org
Date: Thu, 03 Jun 2010 19:37:33 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>
Cc: John W. Linville <linville@tuxdriver.com>
Acked-by: Michael Buesch <mb@bu3sch.de>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43legacy/dma.c |   49 +++++++++++++------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff -puN drivers/net/wireless/b43legacy/dma.c~b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api drivers/net/wireless/b43legacy/dma.c
--- a/drivers/net/wireless/b43legacy/dma.c~b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api
+++ a/drivers/net/wireless/b43legacy/dma.c
@@ -394,11 +394,11 @@ dma_addr_t map_descbuffer(struct b43lega
 	dma_addr_t dmaaddr;
 
 	if (tx)
-		dmaaddr = ssb_dma_map_single(ring->dev->dev,
+		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
 					     buf, len,
 					     DMA_TO_DEVICE);
 	else
-		dmaaddr = ssb_dma_map_single(ring->dev->dev,
+		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
 					     buf, len,
 					     DMA_FROM_DEVICE);
 
@@ -412,11 +412,11 @@ void unmap_descbuffer(struct b43legacy_d
 		      int tx)
 {
 	if (tx)
-		ssb_dma_unmap_single(ring->dev->dev,
+		dma_unmap_single(ring->dev->dev->dma_dev,
 				     addr, len,
 				     DMA_TO_DEVICE);
 	else
-		ssb_dma_unmap_single(ring->dev->dev,
+		dma_unmap_single(ring->dev->dev->dma_dev,
 				     addr, len,
 				     DMA_FROM_DEVICE);
 }
@@ -428,8 +428,8 @@ void sync_descbuffer_for_cpu(struct b43l
 {
 	B43legacy_WARN_ON(ring->tx);
 
-	ssb_dma_sync_single_for_cpu(ring->dev->dev,
-				    addr, len, DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(ring->dev->dev->dma_dev,
+				addr, len, DMA_FROM_DEVICE);
 }
 
 static inline
@@ -439,8 +439,8 @@ void sync_descbuffer_for_device(struct b
 {
 	B43legacy_WARN_ON(ring->tx);
 
-	ssb_dma_sync_single_for_device(ring->dev->dev,
-				       addr, len, DMA_FROM_DEVICE);
+	dma_sync_single_for_device(ring->dev->dev->dma_dev,
+				   addr, len, DMA_FROM_DEVICE);
 }
 
 static inline
@@ -460,10 +460,10 @@ void free_descriptor_buffer(struct b43le
 static int alloc_ringmemory(struct b43legacy_dmaring *ring)
 {
 	/* GFP flags must match the flags in free_ringmemory()! */
-	ring->descbase = ssb_dma_alloc_consistent(ring->dev->dev,
-						  B43legacy_DMA_RINGMEMSIZE,
-						  &(ring->dmabase),
-						  GFP_KERNEL);
+	ring->descbase = dma_alloc_coherent(ring->dev->dev->dma_dev,
+					    B43legacy_DMA_RINGMEMSIZE,
+					    &(ring->dmabase),
+					    GFP_KERNEL);
 	if (!ring->descbase) {
 		b43legacyerr(ring->dev->wl, "DMA ringmemory allocation"
 			     " failed\n");
@@ -476,8 +476,8 @@ static int alloc_ringmemory(struct b43le
 
 static void free_ringmemory(struct b43legacy_dmaring *ring)
 {
-	ssb_dma_free_consistent(ring->dev->dev, B43legacy_DMA_RINGMEMSIZE,
-				ring->descbase, ring->dmabase, GFP_KERNEL);
+	dma_free_coherent(ring->dev->dev->dma_dev, B43legacy_DMA_RINGMEMSIZE,
+			  ring->descbase, ring->dmabase);
 }
 
 /* Reset the RX DMA channel */
@@ -589,7 +589,7 @@ static bool b43legacy_dma_mapping_error(
 					 size_t buffersize,
 					 bool dma_to_device)
 {
-	if (unlikely(ssb_dma_mapping_error(ring->dev->dev, addr)))
+	if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
 		return 1;
 
 	switch (ring->type) {
@@ -906,7 +906,7 @@ struct b43legacy_dmaring *b43legacy_setu
 			goto err_kfree_meta;
 
 		/* test for ability to dma to txhdr_cache */
-		dma_test = ssb_dma_map_single(dev->dev, ring->txhdr_cache,
+		dma_test = dma_map_single(dev->dev->dma_dev, ring->txhdr_cache,
 					      sizeof(struct b43legacy_txhdr_fw3),
 					      DMA_TO_DEVICE);
 
@@ -920,7 +920,7 @@ struct b43legacy_dmaring *b43legacy_setu
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
-			dma_test = ssb_dma_map_single(dev->dev,
+			dma_test = dma_map_single(dev->dev->dma_dev,
 					ring->txhdr_cache,
 					sizeof(struct b43legacy_txhdr_fw3),
 					DMA_TO_DEVICE);
@@ -930,9 +930,9 @@ struct b43legacy_dmaring *b43legacy_setu
 				goto err_kfree_txhdr_cache;
 		}
 
-		ssb_dma_unmap_single(dev->dev, dma_test,
-				     sizeof(struct b43legacy_txhdr_fw3),
-				     DMA_TO_DEVICE);
+		dma_unmap_single(dev->dev->dma_dev, dma_test,
+				 sizeof(struct b43legacy_txhdr_fw3),
+				 DMA_TO_DEVICE);
 	}
 
 	ring->nr_slots = nr_slots;
@@ -1040,9 +1040,12 @@ static int b43legacy_dma_set_mask(struct
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
