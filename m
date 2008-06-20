Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33998 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbYFTJlr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 05:41:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: Fix possible NULL pointer dereference in DMA code
Date: Fri, 20 Jun 2008 11:40:46 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806201140.46568.mb@bu3sch.de> (sfid-20080620_114151_000795_3AAA5BB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a possible NULL pointer dereference in an error path of the
DMA allocation error checking code. This is also necessary for a future
DMA API change that is on its way into the mainline kernel that adds
an additional dev parameter to dma_mapping_error().

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply to 2.6.26



Index: wireless-testing/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/dma.c	2008-06-20 02:04:56.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/dma.c	2008-06-20 02:06:45.000000000 +0200
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
