Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53803 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbYFNVlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2008 17:41:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable] b43: Fix possible NULL pointer dereference in DMA code
Date: Sat, 14 Jun 2008 22:57:55 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Message-Id: <200806142257.55946.mb@bu3sch.de> (sfid-20080614_234158_243127_D0C46798)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a possible NULL pointer dereference in an error path of the
DMA allocation error checking code. In case the DMA allocation address is invalid,
the dev pointer is dereferenced for unmapping of the buffer.

This is a cut-down version of 3ab4b64c46784ed83f213bf4e1b51d9c55858600
which is upstream in John Linville's wireless-testing.git tree.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: linux-2.6.25.6/drivers/net/wireless/b43/dma.c
===================================================================
--- linux-2.6.25.6.orig/drivers/net/wireless/b43/dma.c	2008-06-14 22:43:28.000000000 +0200
+++ linux-2.6.25.6/drivers/net/wireless/b43/dma.c	2008-06-14 22:45:30.000000000 +0200
@@ -847,12 +847,13 @@ struct b43_dmaring *b43_setup_dmaring(st
 	dma_addr_t dma_test;
 
 	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
 	if (!ring)
 		goto out;
 	ring->type = type;
+	ring->dev = dev;
 
 	nr_slots = B43_RXRING_SLOTS;
 	if (for_tx)
 		nr_slots = B43_TXRING_SLOTS;
 
 	ring->meta = kcalloc(nr_slots, sizeof(struct b43_dmadesc_meta),
@@ -898,13 +899,12 @@ struct b43_dmaring *b43_setup_dmaring(st
 
 		dma_unmap_single(dev->dev->dma_dev,
 				 dma_test, b43_txhdr_size(dev),
 				 DMA_TO_DEVICE);
 	}
 
-	ring->dev = dev;
 	ring->nr_slots = nr_slots;
 	ring->mmio_base = b43_dmacontroller_base(type, controller_index);
 	ring->index = controller_index;
 	if (type == B43_DMA_64BIT)
 		ring->ops = &dma64_ops;
 	else
