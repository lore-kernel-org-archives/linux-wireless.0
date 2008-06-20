Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35908 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbYFTJrI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 05:47:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable] b43legacy: Fix possible NULL pointer dereference in DMA code
Date: Fri, 20 Jun 2008 11:46:12 +0200
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200806201146.12984.mb@bu3sch.de> (sfid-20080620_114712_208796_8A6FC337)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a possible NULL pointer dereference in an error path of the
DMA allocation error checking code.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch is not merged to an upstream tree, yet, but is sent to John.


Index: linux-2.6.25.6/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- linux-2.6.25.6.orig/drivers/net/wireless/b43legacy/dma.c	2008-06-14 22:41:44.000000000 +0200
+++ linux-2.6.25.6/drivers/net/wireless/b43legacy/dma.c	2008-06-20 11:42:20.000000000 +0200
@@ -873,12 +873,13 @@ struct b43legacy_dmaring *b43legacy_setu
 	dma_addr_t dma_test;
 
 	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
 	if (!ring)
 		goto out;
 	ring->type = type;
+	ring->dev = dev;
 
 	nr_slots = B43legacy_RXRING_SLOTS;
 	if (for_tx)
 		nr_slots = B43legacy_TXRING_SLOTS;
 
 	ring->meta = kcalloc(nr_slots, sizeof(struct b43legacy_dmadesc_meta),
@@ -919,13 +920,12 @@ struct b43legacy_dmaring *b43legacy_setu
 
 		dma_unmap_single(dev->dev->dma_dev,
 				 dma_test, sizeof(struct b43legacy_txhdr_fw3),
 				 DMA_TO_DEVICE);
 	}
 
-	ring->dev = dev;
 	ring->nr_slots = nr_slots;
 	ring->mmio_base = b43legacy_dmacontroller_base(type, controller_index);
 	ring->index = controller_index;
 	if (type == B43legacy_DMA_64BIT)
 		ring->ops = &dma64_ops;
 	else
