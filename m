Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60462 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbZC0V4Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:56:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Poison RX buffers
Date: Fri, 27 Mar 2009 22:51:58 +0100
Cc: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200903272251.58384.mb@bu3sch.de> (sfid-20090327_225627_197485_1BCD20F3)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds poisoning and sanity checking to the RX DMA buffers.
This is used for protection against buggy hardware/firmware that raises
RX interrupts without doing an actual DMA transfer.

This mechanism protects against rare "bad packets" (due to uninitialized skb data)
and rare kernel crashes due to uninitialized RX headers.

The poison is selected to not match on valid frames and to be cheap for checking.

The poison check mechanism _might_ trigger incorrectly, if we are voluntarily
receiving frames with bad PLCP headers. However, this is nonfatal, because the
chance of such a match is basically zero and in case it happens it just results
in dropping the packet.
Bad-PLCP RX defaults to off, and you should leave it off unless you want to listen
to the latest news broadcasted by your microwave oven.

This patch also moves the initialization of the RX-header "length" field in front of
the mapping of the DMA buffer. The CPU should not touch the buffer after we mapped it.

Cc: stable@kernel.org
Reported-by: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Francesco, please stresstest this.
John, please queue as bugfix.


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-03-27 12:29:57.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-03-27 22:22:21.000000000 +0100
@@ -555,11 +555,32 @@ address_error:
 	return 1;
 }
 
+static bool b43_rx_buffer_is_poisoned(struct b43_dmaring *ring, struct sk_buff *skb)
+{
+	unsigned char *f = skb->data + ring->frameoffset;
+
+	return ((f[0] & f[1] & f[2] & f[3] & f[4] & f[5] & f[6] & f[7]) == 0xFF);
+}
+
+static void b43_poison_rx_buffer(struct b43_dmaring *ring, struct sk_buff *skb)
+{
+	struct b43_rxhdr_fw4 *rxhdr;
+	unsigned char *frame;
+
+	/* This poisons the RX buffer to detect DMA failures. */
+
+	rxhdr = (struct b43_rxhdr_fw4 *)(skb->data);
+	rxhdr->frame_len = 0;
+
+	B43_WARN_ON(ring->rx_buffersize < ring->frameoffset + sizeof(struct b43_plcp_hdr6) + 2);
+	frame = skb->data + ring->frameoffset;
+	memset(frame, 0xFF, sizeof(struct b43_plcp_hdr6) + 2 /* padding */);
+}
+
 static int setup_rx_descbuffer(struct b43_dmaring *ring,
 			       struct b43_dmadesc_generic *desc,
 			       struct b43_dmadesc_meta *meta, gfp_t gfp_flags)
 {
-	struct b43_rxhdr_fw4 *rxhdr;
 	dma_addr_t dmaaddr;
 	struct sk_buff *skb;
 
@@ -568,6 +589,7 @@ static int setup_rx_descbuffer(struct b4
 	skb = __dev_alloc_skb(ring->rx_buffersize, gfp_flags);
 	if (unlikely(!skb))
 		return -ENOMEM;
+	b43_poison_rx_buffer(ring, skb);
 	dmaaddr = map_descbuffer(ring, skb->data, ring->rx_buffersize, 0);
 	if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize, 0)) {
 		/* ugh. try to realloc in zone_dma */
@@ -578,6 +600,7 @@ static int setup_rx_descbuffer(struct b4
 		skb = __dev_alloc_skb(ring->rx_buffersize, gfp_flags);
 		if (unlikely(!skb))
 			return -ENOMEM;
+		b43_poison_rx_buffer(ring, skb);
 		dmaaddr = map_descbuffer(ring, skb->data,
 					 ring->rx_buffersize, 0);
 		if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize, 0)) {
@@ -592,9 +615,6 @@ static int setup_rx_descbuffer(struct b4
 	ring->ops->fill_descriptor(ring, desc, dmaaddr,
 				   ring->rx_buffersize, 0, 0, 0);
 
-	rxhdr = (struct b43_rxhdr_fw4 *)(skb->data);
-	rxhdr->frame_len = 0;
-
 	return 0;
 }
 
@@ -1489,6 +1509,15 @@ static void dma_rx(struct b43_dmaring *r
 			goto drop;
 		}
 	}
+	if (unlikely(b43_rx_buffer_is_poisoned(ring, skb))) {
+		/* Something went wrong with the DMA.
+		 * The device did not touch the buffer and did not overwrite the poison. */
+		b43dbg(ring->dev->wl, "DMA RX: Dropping poisoned buffer.\n");
+		/* recycle the descriptor buffer. */
+		sync_descbuffer_for_device(ring, meta->dmaaddr,
+					   ring->rx_buffersize);
+		goto drop;
+	}
 	if (unlikely(len > ring->rx_buffersize)) {
 		/* The data did not fit into one descriptor buffer
 		 * and is split over multiple buffers.


-- 
Greetings, Michael.
