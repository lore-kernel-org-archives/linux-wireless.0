Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47152 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab1HZSs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 14:48:27 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so2779206fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 11:48:26 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
	Maxime Vincent <maxime.vince@gmail.com>,
	Darren <dmbtech@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [wireless-next][PATCH 2/3] b43: use 8K buffers for 64-bit DMA to workaround hardware bug
Date: Fri, 26 Aug 2011 20:41:39 +0200
Message-Id: <1314384100-3492-3-git-send-email-zajec5@gmail.com> (sfid-20110826_204830_737534_377BB7F4)
In-Reply-To: <1314384100-3492-2-git-send-email-zajec5@gmail.com>
References: <1314384100-3492-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/dma.c |   24 ++++++++++++++++--------
 drivers/net/wireless/b43/dma.h |    3 ++-
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index e36e8b5..5e45604 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -419,26 +419,34 @@ static int alloc_ringmemory(struct b43_dmaring *ring)
 	gfp_t flags = GFP_KERNEL;
 
 	/* The specs call for 4K buffers for 30- and 32-bit DMA with 4K
-	 * alignment and 8K buffers for 64-bit DMA with 8K alignment. Testing
-	 * has shown that 4K is sufficient for the latter as long as the buffer
-	 * does not cross an 8K boundary.
-	 *
+	 * alignment and 8K buffers for 64-bit DMA with 8K alignment.
+	 * In practice we could use smaller buffers for the latter, but the
+	 * alignment is really important because of the hardware bug. If bit
+	 * 0x00001000 is used in DMA address, some hardware (like BCM4331)
+	 * copies that bit into B43_DMA64_RXSTATUS and we get false values from
+	 * B43_DMA64_RXSTATDPTR. Let's just use 8K buffers even if we don't use
+	 * more than 256 slots for ring.
 	 */
+	u16 ring_mem_size = (ring->type == B43_DMA_64BIT) ?
+				B43_DMA64_RINGMEMSIZE : B43_DMA32_RINGMEMSIZE;
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
index 7e20b04..315b96e 100644
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
1.7.1

