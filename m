Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45603 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab1C3SDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 14:03:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2.6.39-rc1] b43: allocate receive buffers big enough for max frame len + offset
Date: Wed, 30 Mar 2011 14:02:46 -0400
Message-Id: <1301508166-7692-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise, skb_put inside of dma_rx can fail...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/b43/dma.c |    2 +-
 drivers/net/wireless/b43/dma.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 3d5566e..ff0f5ba 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1536,7 +1536,7 @@ static void dma_rx(struct b43_dmaring *ring, int *slot)
 		dmaaddr = meta->dmaaddr;
 		goto drop_recycle_buffer;
 	}
-	if (unlikely(len > ring->rx_buffersize)) {
+	if (unlikely(len + ring->frameoffset > ring->rx_buffersize)) {
 		/* The data did not fit into one descriptor buffer
 		 * and is split over multiple buffers.
 		 * This should never happen, as we try to allocate buffers
diff --git a/drivers/net/wireless/b43/dma.h b/drivers/net/wireless/b43/dma.h
index a01c210..e8a80a1 100644
--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -163,7 +163,7 @@ struct b43_dmadesc_generic {
 /* DMA engine tuning knobs */
 #define B43_TXRING_SLOTS		256
 #define B43_RXRING_SLOTS		64
-#define B43_DMA0_RX_BUFFERSIZE		IEEE80211_MAX_FRAME_LEN
+#define B43_DMA0_RX_BUFFERSIZE		(B43_DMA0_RX_FRAMEOFFSET + IEEE80211_MAX_FRAME_LEN)
 
 /* Pointer poison */
 #define B43_DMA_PTR_POISON		((void *)ERR_PTR(-ENOMEM))
-- 
1.7.4

