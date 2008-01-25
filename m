Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:48429 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYAYLWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 06:22:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable 3/3] b43: Fix dma-slot resource leakage
Date: Fri, 25 Jan 2008 12:20:20 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801251220.20332.mb@bu3sch.de> (sfid-20080125_112300_967875_84954419)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes four resource leakages.
In any error path we must deallocate the DMA frame slots we
previously allocated by request_slot().
This is done by storing the ring pointers before doing any ring
allocation and restoring the old pointers in case of an error.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch is upstream inside of the netdev tree.


Index: linux-2.6.24/drivers/net/wireless/b43/dma.c
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43/dma.c	2008-01-25 11:48:31.000000000 +0100
+++ linux-2.6.24/drivers/net/wireless/b43/dma.c	2008-01-25 11:48:34.000000000 +0100
@@ -1106,7 +1106,7 @@ static int dma_tx_fragment(struct b43_dm
 {
 	const struct b43_dma_ops *ops = ring->ops;
 	u8 *header;
-	int slot;
+	int slot, old_top_slot, old_used_slots;
 	int err;
 	struct b43_dmadesc_generic *desc;
 	struct b43_dmadesc_meta *meta;
@@ -1116,6 +1116,9 @@ static int dma_tx_fragment(struct b43_dm
 #define SLOTS_PER_PACKET  2
 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
 
+	old_top_slot = ring->current_slot;
+	old_used_slots = ring->used_slots;
+
 	/* Get a slot for the header. */
 	slot = request_slot(ring);
 	desc = ops->idx2desc(ring, slot, &meta_hdr);
@@ -1125,13 +1128,19 @@ static int dma_tx_fragment(struct b43_dm
 	err = b43_generate_txhdr(ring->dev, header,
 			   skb->data, skb->len, ctl,
 			   generate_cookie(ring, slot));
-	if (unlikely(err))
+	if (unlikely(err)) {
+		ring->current_slot = old_top_slot;
+		ring->used_slots = old_used_slots;
 		return err;
+	}
 
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
 					   sizeof(struct b43_txhdr_fw4), 1);
-	if (dma_mapping_error(meta_hdr->dmaaddr))
+	if (dma_mapping_error(meta_hdr->dmaaddr)) {
+		ring->current_slot = old_top_slot;
+		ring->used_slots = old_used_slots;
 		return -EIO;
+	}
 	ops->fill_descriptor(ring, desc, meta_hdr->dmaaddr,
 			     sizeof(struct b43_txhdr_fw4), 1, 0, 0);
 
@@ -1149,6 +1158,8 @@ static int dma_tx_fragment(struct b43_dm
 	if (dma_mapping_error(meta->dmaaddr)) {
 		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb) {
+			ring->current_slot = old_top_slot;
+			ring->used_slots = old_used_slots;
 			err = -ENOMEM;
 			goto out_unmap_hdr;
 		}
@@ -1159,6 +1170,8 @@ static int dma_tx_fragment(struct b43_dm
 		meta->skb = skb;
 		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 		if (dma_mapping_error(meta->dmaaddr)) {
+			ring->current_slot = old_top_slot;
+			ring->used_slots = old_used_slots;
 			err = -EIO;
 			goto out_free_bounce;
 		}
