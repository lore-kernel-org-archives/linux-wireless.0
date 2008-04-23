Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:58379 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYDWRN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 13:13:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Workaround DMA quirks
Date: Wed, 23 Apr 2008 19:13:01 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Message-Id: <200804231913.01788.mb@bu3sch.de> (sfid-20080423_191402_401034_2B660FB7)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some mainboards/CPUs don't allow DMA masks bigger than a certain limit.
Some VIA crap^h^h^h^hdevices have an upper limit of 0xFFFFFFFF. So in this
case a 64-bit b43 device would always fail to acquire the mask.
Implement a workaround to fallback to lower DMA mask, as we can always
also support a lower mask.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is a bugfix for 2.6.26
Stefano, we might probably want to backport this to legacy.


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-04-16 20:27:55.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-04-23 18:35:06.000000000 +0200
@@ -977,29 +977,60 @@ void b43_dma_free(struct b43_wldev *dev)
 	destroy_ring(dma, tx_ring_AC_BE);
 	destroy_ring(dma, tx_ring_AC_VI);
 	destroy_ring(dma, tx_ring_AC_VO);
 	destroy_ring(dma, tx_ring_mcast);
 }
 
+static int b43_dma_set_mask(struct b43_wldev *dev, u64 mask)
+{
+	u64 orig_mask = mask;
+	bool fallback = 0;
+	int err;
+
+	/* Try to set the DMA mask. If it fails, try falling back to a
+	 * lower mask, as we can always also support a lower one. */
+	while (1) {
+		err = ssb_dma_set_mask(dev->dev, mask);
+		if (!err)
+			break;
+		if (mask == DMA_64BIT_MASK) {
+			mask = DMA_32BIT_MASK;
+			fallback = 1;
+			continue;
+		}
+		if (mask == DMA_32BIT_MASK) {
+			mask = DMA_30BIT_MASK;
+			fallback = 1;
+			continue;
+		}
+		b43err(dev->wl, "The machine/kernel does not support "
+		       "the required %u-bit DMA mask\n",
+		       (unsigned int)dma_mask_to_engine_type(orig_mask));
+		return -EOPNOTSUPP;
+	}
+	if (fallback) {
+		b43info(dev->wl, "DMA mask fallback from %u-bit to %u-bit\n",
+			(unsigned int)dma_mask_to_engine_type(orig_mask),
+			(unsigned int)dma_mask_to_engine_type(mask));
+	}
+
+	return 0;
+}
+
 int b43_dma_init(struct b43_wldev *dev)
 {
 	struct b43_dma *dma = &dev->dma;
 	int err;
 	u64 dmamask;
 	enum b43_dmatype type;
 
 	dmamask = supported_dma_mask(dev);
 	type = dma_mask_to_engine_type(dmamask);
-	err = ssb_dma_set_mask(dev->dev, dmamask);
-	if (err) {
-		b43err(dev->wl, "The machine/kernel does not support "
-		       "the required DMA mask (0x%08X%08X)\n",
-		       (unsigned int)((dmamask & 0xFFFFFFFF00000000ULL) >> 32),
-		       (unsigned int)(dmamask & 0x00000000FFFFFFFFULL));
-		return -EOPNOTSUPP;
-	}
+	err = b43_dma_set_mask(dev, dmamask);
+	if (err)
+		return err;
 
 	err = -ENOMEM;
 	/* setup TX DMA channels. */
 	dma->tx_ring_AC_BK = b43_setup_dmaring(dev, 0, 1, type);
 	if (!dma->tx_ring_AC_BK)
 		goto out;
