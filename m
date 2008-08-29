Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:61799 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbYH2TH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 15:07:57 -0400
Received: by ey-out-2122.google.com with SMTP id 6so320107eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 12:07:57 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/7] rt2x00: Map extra_tx_headroom to DMA
Date: Fri, 29 Aug 2008 21:04:50 +0200
Cc: "rt2400-devel" <rt2400-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <200808292103.53179.IvDoorn@gmail.com> <200808292104.26914.IvDoorn@gmail.com>
In-Reply-To: <200808292104.26914.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808292104.50501.IvDoorn@gmail.com> (sfid-20080829_210802_483442_37721ADD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a driver requests additional headroom it should
be mapped to DMA as well because it will be send to
the hardware as well (as form of extra descriptor).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index d10a801..2822684 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -100,8 +100,21 @@ void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 
-	skbdesc->skb_dma = dma_map_single(rt2x00dev->dev, skb->data, skb->len,
-					  DMA_TO_DEVICE);
+	/*
+	 * If device has requested headroom, we should make sure that
+	 * is also mapped to the DMA so it can be used for transfering
+	 * additional descriptor information to the hardware.
+	 */
+	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
+
+	skbdesc->skb_dma =
+	    dma_map_single(rt2x00dev->dev, skb->data, skb->len, DMA_TO_DEVICE);
+
+	/*
+	 * Restore data pointer to original location again.
+	 */
+	skb_pull(skb, rt2x00dev->hw->extra_tx_headroom);
+
 	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_map_txskb);
@@ -117,7 +130,12 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	}
 
 	if (skbdesc->flags & SKBDESC_DMA_MAPPED_TX) {
-		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
+		/*
+		 * Add headroom to the skb length, it has been removed
+		 * by the driver, but it was actually mapped to DMA.
+		 */
+		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma,
+				 skb->len + rt2x00dev->hw->extra_tx_headroom,
 				 DMA_TO_DEVICE);
 		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_TX;
 	}
-- 
1.5.6.1

