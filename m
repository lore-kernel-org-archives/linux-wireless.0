Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51797 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbYEAOpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 10:45:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	John Linville <linville@tuxdriver.com>
Subject: [PATCH 3/3] b43: Use the new weak DMA-mask API
Date: Thu, 1 May 2008 16:43:08 +0200
Cc: Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ingo Molnar <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>
References: <200805011638.15910.mb@bu3sch.de>
In-Reply-To: <200805011638.15910.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805011643.08605.mb@bu3sch.de> (sfid-20080501_164459_626023_DFE41E4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a user for the new weak DMA mask API.
This removes the b43 DMA mask probe loop.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: linux-2.6/drivers/net/wireless/b43/dma.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/dma.c	2008-05-01 13:19:51.000000000 +0200
+++ linux-2.6/drivers/net/wireless/b43/dma.c	2008-05-01 14:45:52.000000000 +0200
@@ -980,37 +980,27 @@ void b43_dma_free(struct b43_wldev *dev)
 	destroy_ring(dma, tx_ring_mcast);
 }
 
+static inline unsigned int mask_to_bit(u64 dma_mask)
+{
+	return fls64(dma_mask);
+}
+
 static int b43_dma_set_mask(struct b43_wldev *dev, u64 mask)
 {
 	u64 orig_mask = mask;
-	bool fallback = 0;
 	int err;
 
-	/* Try to set the DMA mask. If it fails, try falling back to a
-	 * lower mask, as we can always also support a lower one. */
-	while (1) {
-		err = ssb_dma_set_mask(dev->dev, mask);
-		if (!err)
-			break;
-		if (mask == DMA_64BIT_MASK) {
-			mask = DMA_32BIT_MASK;
-			fallback = 1;
-			continue;
-		}
-		if (mask == DMA_32BIT_MASK) {
-			mask = DMA_30BIT_MASK;
-			fallback = 1;
-			continue;
-		}
+	err = ssb_dma_set_mask_weak(dev->dev, &mask);
+	if (err) {
 		b43err(dev->wl, "The machine/kernel does not support "
 		       "the required %u-bit DMA mask\n",
-		       (unsigned int)dma_mask_to_engine_type(orig_mask));
+		       mask_to_bit(orig_mask));
 		return -EOPNOTSUPP;
 	}
-	if (fallback) {
+	if (mask != orig_mask) {
 		b43info(dev->wl, "DMA mask fallback from %u-bit to %u-bit\n",
-			(unsigned int)dma_mask_to_engine_type(orig_mask),
-			(unsigned int)dma_mask_to_engine_type(mask));
+			mask_to_bit(orig_mask),
+			mask_to_bit(mask));
 	}
 
 	return 0;


-- 
Greetings Michael.
