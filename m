Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44802 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764352AbZC0Xpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 19:45:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Refresh RX poison on buffer recycling
Date: Sat, 28 Mar 2009 00:41:25 +0100
Cc: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903280041.25265.mb@bu3sch.de> (sfid-20090328_004605_036260_E8B7AAF7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RX buffer poison needs to be refreshed, if we recycle an RX buffer,
because it might be (partially) overwritten by some DMA operations.

Cc: stable@kernel.org
Cc: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Francesco, please stresstest this on top of the other patch that adds poisoning.
John, please queue as bugfix.


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-03-27 23:15:36.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-03-27 23:30:17.000000000 +0100
@@ -1503,20 +1503,16 @@ static void dma_rx(struct b43_dmaring *r
 			len = le16_to_cpu(rxhdr->frame_len);
 		} while (len == 0 && i++ < 5);
 		if (unlikely(len == 0)) {
-			/* recycle the descriptor buffer. */
-			sync_descbuffer_for_device(ring, meta->dmaaddr,
-						   ring->rx_buffersize);
-			goto drop;
+			dmaaddr = meta->dmaaddr;
+			goto drop_recycle_buffer;
 		}
 	}
 	if (unlikely(b43_rx_buffer_is_poisoned(ring, skb))) {
 		/* Something went wrong with the DMA.
 		 * The device did not touch the buffer and did not overwrite the poison. */
 		b43dbg(ring->dev->wl, "DMA RX: Dropping poisoned buffer.\n");
-		/* recycle the descriptor buffer. */
-		sync_descbuffer_for_device(ring, meta->dmaaddr,
-					   ring->rx_buffersize);
-		goto drop;
+		dmaaddr = meta->dmaaddr;
+		goto drop_recycle_buffer;
 	}
 	if (unlikely(len > ring->rx_buffersize)) {
 		/* The data did not fit into one descriptor buffer
@@ -1530,6 +1526,7 @@ static void dma_rx(struct b43_dmaring *r
 		while (1) {
 			desc = ops->idx2desc(ring, *slot, &meta);
 			/* recycle the descriptor buffer. */
+			b43_poison_rx_buffer(ring, meta->skb);
 			sync_descbuffer_for_device(ring, meta->dmaaddr,
 						   ring->rx_buffersize);
 			*slot = next_slot(ring, *slot);
@@ -1548,8 +1545,7 @@ static void dma_rx(struct b43_dmaring *r
 	err = setup_rx_descbuffer(ring, desc, meta, GFP_ATOMIC);
 	if (unlikely(err)) {
 		b43dbg(ring->dev->wl, "DMA RX: setup_rx_descbuffer() failed\n");
-		sync_descbuffer_for_device(ring, dmaaddr, ring->rx_buffersize);
-		goto drop;
+		goto drop_recycle_buffer;
 	}
 
 	unmap_descbuffer(ring, dmaaddr, ring->rx_buffersize, 0);
@@ -1559,6 +1555,11 @@ static void dma_rx(struct b43_dmaring *r
 	b43_rx(ring->dev, skb, rxhdr);
 drop:
 	return;
+
+drop_recycle_buffer:
+	/* Poison and recycle the RX buffer. */
+	b43_poison_rx_buffer(ring, skb);
+	sync_descbuffer_for_device(ring, dmaaddr, ring->rx_buffersize);
 }
 
 void b43_dma_rx(struct b43_dmaring *ring)

-- 
Greetings, Michael.
