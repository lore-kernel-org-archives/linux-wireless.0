Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37211 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1HXPzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 11:55:08 -0400
Received: by gxk21 with SMTP id 21so970857gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 08:55:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFT][PATCH] b43: use 8K buffers for 64-bit DMA to workaround hardware bug
Date: Wed, 24 Aug 2011 17:57:18 +0200
Message-Id: <1314201438-12125-1-git-send-email-zajec5@gmail.com> (sfid-20110824_175511_258981_C4139D46)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
David: can you give it a try?
---
 drivers/net/wireless/b43/dma.c |   33 ++++++++++++++++++++-------------
 drivers/net/wireless/b43/dma.h |    3 ++-
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 5151c7f..ee583b2 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -386,36 +386,43 @@ static inline
 
 static int alloc_ringmemory(struct b43_dmaring *ring)
 {
-	gfp_t flags = GFP_KERNEL;
-
 	/* The specs call for 4K buffers for 30- and 32-bit DMA with 4K
-	 * alignment and 8K buffers for 64-bit DMA with 8K alignment. Testing
-	 * has shown that 4K is sufficient for the latter as long as the buffer
-	 * does not cross an 8K boundary.
-	 *
-	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
+	 * alignment and 8K buffers for 64-bit DMA with 8K alignment.
+	 * In practice we could use smaller buffers for the latter, but the
+	 * alignment is really important because of the hardware bug. If bit
+	 * 0x00001000 is used in DMA address, some hardware (like BCM4331)
+	 * copies that bit into B43_DMA64_RXSTATUS and we get false values from
+	 * B43_DMA64_RXSTATDPTR. Let's just use 8K buffers even if we don't use
+	 * more than 256 slots for ring.
+	 */
+	u16 ring_mem_size = (ring->type == B43_DMA_64BIT) ?
+				B43_DMA64_RINGMEMSIZE : B43_DMA32_RINGMEMSIZE;
+
+	/* For unknown reasons - possibly a hardware error - the BCM4311 rev
 	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
 	 * which accounts for the GFP_DMA flag below.
-	 *
-	 * The flags here must match the flags in free_ringmemory below!
 	 */
+	gfp_t flags = GFP_KERNEL;
 	if (ring->type == B43_DMA_64BIT)
 		flags |= GFP_DMA;
+
 	ring->descbase = dma_alloc_coherent(ring->dev->dev->dma_dev,
-					    B43_DMA_RINGMEMSIZE,
-					    &(ring->dmabase), flags);
+					    ring_mem_size, &(ring->dmabase),
+					    flags);
 	if (!ring->descbase) {
 		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
 		return -ENOMEM;
 	}
-	memset(ring->descbase, 0, B43_DMA_RINGMEMSIZE);
+	memset(ring->descbase, 0, ring_mem_size);
 
 	return 0;
 }
 
 static void free_ringmemory(struct b43_dmaring *ring)
 {
-	dma_free_coherent(ring->dev->dev->dma_dev, B43_DMA_RINGMEMSIZE,
+	u16 ring_mem_size = (ring->type == B43_DMA_64BIT) ?
+				B43_DMA64_RINGMEMSIZE : B43_DMA32_RINGMEMSIZE;
+	dma_free_coherent(ring->dev->dev->dma_dev, ring_mem_size,
 			  ring->descbase, ring->dmabase);
 }
 
diff --git a/drivers/net/wireless/b43/dma.h b/drivers/net/wireless/b43/dma.h
index 546d19c..55244e7 100644
--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -161,7 +161,8 @@ struct b43_dmadesc_generic {
 } __packed;
 
 /* Misc DMA constants */
-#define B43_DMA_RINGMEMSIZE		PAGE_SIZE
+#define B43_DMA32_RINGMEMSIZE		4096
+#define B43_DMA64_RINGMEMSIZE		8192
 /* Offset of frame with actual data */
 #define B43_DMA0_RX_FW598_FO		38
 #define B43_DMA0_RX_FW351_FO		30
-- 
1.7.3.4

