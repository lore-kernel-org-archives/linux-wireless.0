Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:42003 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752750AbYDMXAR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 19:00:17 -0400
Date: Mon, 14 Apr 2008 00:59:49 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	bcm43xx-dev@lists.berlios.de,
	Christian Casteyde <casteyde.christian@free.fr>
Subject: [PATCH] b43legacy: fix DMA mapping leakage
Message-ID: <20080414005949.162956b2@polimi.it> (sfid-20080414_000021_120624_1E9C6C7B)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a DMA mapping leakage in the case where we reject a DMA buffer
because of its address.
The patch by Michael Buesch has been ported to b43legacy.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Christian Casteyde <casteyde.christian@free.fr>
---
John, this is a fix for 2.6.25.
---
Index: bcm-testing/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- bcm-testing.orig/drivers/net/wireless/b43legacy/dma.c
+++ bcm-testing/drivers/net/wireless/b43legacy/dma.c
@@ -585,8 +585,9 @@ static int b43legacy_dmacontroller_tx_re
 
 /* Check if a DMA mapping address is invalid. */
 static bool b43legacy_dma_mapping_error(struct b43legacy_dmaring *ring,
-					dma_addr_t addr,
-					size_t buffersize)
+					 dma_addr_t addr,
+					 size_t buffersize,
+					 bool dma_to_device)
 {
 	if (unlikely(dma_mapping_error(addr)))
 		return 1;
@@ -594,11 +595,11 @@ static bool b43legacy_dma_mapping_error(
 	switch (ring->type) {
 	case B43legacy_DMA_30BIT:
 		if ((u64)addr + buffersize > (1ULL << 30))
-			return 1;
+			goto address_error;
 		break;
 	case B43legacy_DMA_32BIT:
 		if ((u64)addr + buffersize > (1ULL << 32))
-			return 1;
+			goto address_error;
 		break;
 	case B43legacy_DMA_64BIT:
 		/* Currently we can't have addresses beyond 64 bits in the kernel. */
@@ -607,6 +608,12 @@ static bool b43legacy_dma_mapping_error(
 
 	/* The address is OK. */
 	return 0;
+
+address_error:
+	/* We can't support this address. Unmap it again. */
+	unmap_descbuffer(ring, addr, buffersize, dma_to_device);
+
+	return 1;
 }
 
 static int setup_rx_descbuffer(struct b43legacy_dmaring *ring,
@@ -626,7 +633,7 @@ static int setup_rx_descbuffer(struct b4
 		return -ENOMEM;
 	dmaaddr = map_descbuffer(ring, skb->data,
 				 ring->rx_buffersize, 0);
-	if (b43legacy_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize)) {
+	if (b43legacy_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize, 0)) {
 		/* ugh. try to realloc in zone_dma */
 		gfp_flags |= GFP_DMA;
 
@@ -639,7 +646,7 @@ static int setup_rx_descbuffer(struct b4
 					 ring->rx_buffersize, 0);
 	}
 
-	if (b43legacy_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize)) {
+	if (b43legacy_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize, 0)) {
 		dev_kfree_skb_any(skb);
 		return -EIO;
 	}
@@ -891,7 +898,7 @@ struct b43legacy_dmaring *b43legacy_setu
 					  DMA_TO_DEVICE);
 
 		if (b43legacy_dma_mapping_error(ring, dma_test,
-					sizeof(struct b43legacy_txhdr_fw3))) {
+					sizeof(struct b43legacy_txhdr_fw3), 1)) {
 			/* ugh realloc */
 			kfree(ring->txhdr_cache);
 			ring->txhdr_cache = kcalloc(nr_slots,
@@ -906,7 +913,7 @@ struct b43legacy_dmaring *b43legacy_setu
 					DMA_TO_DEVICE);
 
 			if (b43legacy_dma_mapping_error(ring, dma_test,
-					sizeof(struct b43legacy_txhdr_fw3)))
+					sizeof(struct b43legacy_txhdr_fw3), 1))
 				goto err_kfree_txhdr_cache;
 		}
 
@@ -1235,7 +1242,7 @@ static int dma_tx_fragment(struct b43leg
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
 					   sizeof(struct b43legacy_txhdr_fw3), 1);
 	if (b43legacy_dma_mapping_error(ring, meta_hdr->dmaaddr,
-					sizeof(struct b43legacy_txhdr_fw3))) {
+					sizeof(struct b43legacy_txhdr_fw3), 1)) {
 		ring->current_slot = old_top_slot;
 		ring->used_slots = old_used_slots;
 		return -EIO;
@@ -1254,7 +1261,7 @@ static int dma_tx_fragment(struct b43leg
 
 	meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 	/* create a bounce buffer in zone_dma on mapping failure. */
-	if (b43legacy_dma_mapping_error(ring, meta->dmaaddr, skb->len)) {
+	if (b43legacy_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
 		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb) {
 			ring->current_slot = old_top_slot;
@@ -1268,7 +1275,7 @@ static int dma_tx_fragment(struct b43leg
 		skb = bounce_skb;
 		meta->skb = skb;
 		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
-		if (b43legacy_dma_mapping_error(ring, meta->dmaaddr, skb->len)) {
+		if (b43legacy_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
 			ring->current_slot = old_top_slot;
 			ring->used_slots = old_used_slots;
 			err = -EIO;


--
Ciao
Stefano
