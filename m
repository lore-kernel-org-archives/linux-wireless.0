Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53360 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbYC1Kr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 06:47:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add DMA mapping failure messages
Date: Fri, 28 Mar 2008 11:46:58 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803281146.59217.mb@bu3sch.de> (sfid-20080328_104800_650008_8F41E0A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds messages for some DMA mapping failures.
These are useful for debugging DMA address problems, as they appear
on x86_64 machines with IOMMU enabled.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Please queue for 2.6.25

Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-03-28 11:33:52.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-03-28 11:34:12.000000000 +0100
@@ -571,12 +571,13 @@ static int setup_rx_descbuffer(struct b4
 			return -ENOMEM;
 		dmaaddr = map_descbuffer(ring, skb->data,
 					 ring->rx_buffersize, 0);
 	}
 
 	if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize, 0)) {
+		b43err(ring->dev->wl, "RX DMA buffer allocation failed\n");
 		dev_kfree_skb_any(skb);
 		return -EIO;
 	}
 
 	meta->skb = skb;
 	meta->dmaaddr = dmaaddr;
@@ -826,14 +827,18 @@ struct b43_dmaring *b43_setup_dmaring(st
 			dma_test = dma_map_single(dev->dev->dev,
 						  ring->txhdr_cache,
 						  b43_txhdr_size(dev),
 						  DMA_TO_DEVICE);
 
 			if (b43_dma_mapping_error(ring, dma_test,
-						  b43_txhdr_size(dev), 1))
+						  b43_txhdr_size(dev), 1)) {
+
+				b43err(dev->wl,
+				       "TXHDR DMA allocation failed\n");
 				goto err_kfree_txhdr_cache;
+			}
 		}
 
 		dma_unmap_single(dev->dev->dev,
 				 dma_test, b43_txhdr_size(dev),
 				 DMA_TO_DEVICE);
 	}
