Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:48618 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755585AbYAYNmX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 08:42:23 -0500
Date: Fri, 25 Jan 2008 14:32:00 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: stable@kernel.org
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH stable 4/4] b43legacy: fix DMA slot resource leakage
Message-ID: <20080125143200.4a77d304@morte> (sfid-20080125_134229_114450_047599D2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes four resource leakages.
In any error path we must deallocate the DMA frame slots we
previously allocated by request_slot().
This is done by storing the ring pointers before doing any ring
allocation and restoring the old pointers in case of an error.

This patch by Michael Buesch has been ported to b43legacy.

Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: linux-2.6.24/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43legacy/dma.c
+++ linux-2.6.24/drivers/net/wireless/b43legacy/dma.c
@@ -1164,7 +1164,7 @@ static int dma_tx_fragment(struct b43leg
 {
 	const struct b43legacy_dma_ops *ops = ring->ops;
 	u8 *header;
-	int slot;
+	int slot, old_top_slot, old_used_slots;
 	int err;
 	struct b43legacy_dmadesc_generic *desc;
 	struct b43legacy_dmadesc_meta *meta;
@@ -1174,6 +1174,9 @@ static int dma_tx_fragment(struct b43leg
 #define SLOTS_PER_PACKET  2
 	B43legacy_WARN_ON(skb_shinfo(skb)->nr_frags != 0);
 
+	old_top_slot = ring->current_slot;
+	old_used_slots = ring->used_slots;
+
 	/* Get a slot for the header. */
 	slot = request_slot(ring);
 	desc = ops->idx2desc(ring, slot, &meta_hdr);
@@ -1184,8 +1187,11 @@ static int dma_tx_fragment(struct b43leg
 	err = b43legacy_generate_txhdr(ring->dev, header,
 				 skb->data, skb->len, ctl,
 				 generate_cookie(ring, slot));
-	if (unlikely(err))
+	if (unlikely(err)) {
+		ring->current_slot = old_top_slot;
+		ring->used_slots = old_used_slots;
 		return err;
+	}
 
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
 				       sizeof(struct b43legacy_txhdr_fw3), 1);
@@ -1208,6 +1214,8 @@ static int dma_tx_fragment(struct b43leg
 	if (dma_mapping_error(meta->dmaaddr)) {
 		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb) {
+			ring->current_slot = old_top_slot;
+			ring->used_slots = old_used_slots;
 			err = -ENOMEM;
 			goto out_unmap_hdr;
 		}
@@ -1218,6 +1226,8 @@ static int dma_tx_fragment(struct b43leg
 		meta->skb = skb;
 		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 		if (dma_mapping_error(meta->dmaaddr)) {
+			ring->current_slot = old_top_slot;
+			ring->used_slots = old_used_slots;
 			err = -EIO;
 			goto out_free_bounce;
 		}


--
Ciao
Stefano
