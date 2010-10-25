Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48303 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab0JYOaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 10:30:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: remove extraneous code in free_ringmemory
Date: Mon, 25 Oct 2010 10:24:09 -0400
Message-Id: <1288016649-4334-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code seems to have been cut-n-pasted from alloc_ringmemory?
Anyway, it is useless.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/dma.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 10d0aaf..3d5566e 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -415,11 +415,6 @@ static int alloc_ringmemory(struct b43_dmaring *ring)
 
 static void free_ringmemory(struct b43_dmaring *ring)
 {
-	gfp_t flags = GFP_KERNEL;
-
-	if (ring->type == B43_DMA_64BIT)
-		flags |= GFP_DMA;
-
 	dma_free_coherent(ring->dev->dev->dma_dev, B43_DMA_RINGMEMSIZE,
 			  ring->descbase, ring->dmabase);
 }
-- 
1.7.2.3

