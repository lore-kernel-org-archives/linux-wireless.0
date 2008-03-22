Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailfe02.tele2.fr ([212.247.154.44]:55314 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757821AbYCVScq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2008 14:32:46 -0400
From: Christian Casteyde <casteyde.christian@free.fr>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.25-rc6] b43/dma.c: fix DMA unmapping in DMA ring error path
Date: Sat, 22 Mar 2008 18:32:18 +0100
Cc: linville@tuxdriver.com, mb@bu3sch.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803221832.18285.casteyde.christian@free.fr> (sfid-20080322_183259_132994_069C19F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a DMA mapping leak in error path of the b43_setup_dmaring function.
When DMA mapping fails because of device mask preventing the allocated DMA
zone from being used, the mapping should be reversed before the second try with GFP_DMA.

Signed-off-by: Christian Casteyde <casteyde.christian@free.fr>

---
--- linux-2.6.25.old/drivers/net/wireless/b43/dma.c	2008-03-22 17:28:52.000000000 +0100
+++ linux-2.6.25/drivers/net/wireless/b43/dma.c	2008-03-22 17:57:44.000000000 +0100
@@ -854,6 +854,10 @@
 
 		if (b43_dma_mapping_error(ring, dma_test, b43_txhdr_size(dev))) {
 			/* ugh realloc */
+			if (!dma_mapping_error(dma_test))
+				dma_unmap_single(dev->dev->dev,
+						 dma_test, b43_txhdr_size(dev),
+						 DMA_TO_DEVICE);
 			kfree(ring->txhdr_cache);
 			ring->txhdr_cache = kcalloc(nr_slots,
 						    b43_txhdr_size(dev),
@@ -867,8 +871,13 @@
 						  DMA_TO_DEVICE);
 
 			if (b43_dma_mapping_error(ring, dma_test,
-						  b43_txhdr_size(dev)))
+						  b43_txhdr_size(dev))) {
+				if (!dma_mapping_error(dma_test))
+					dma_unmap_single(dev->dev->dev,
+							 dma_test, b43_txhdr_size(dev),
+							 DMA_TO_DEVICE);
 				goto err_kfree_txhdr_cache;
+			}
 		}
 
 		dma_unmap_single(dev->dev->dev,
