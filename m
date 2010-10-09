Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35910 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab0JILgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 07:36:25 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so23937ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 04:36:25 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/06] rt2x00: Optimize unmapping of skbs
Date: Sat, 9 Oct 2010 13:33:43 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201010091333.17274.IvDoorn@gmail.com>
In-Reply-To: <201010091333.17274.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010091333.45001.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Since no skb will be mapped for RX and TX at the same time we can
simply shortcut the check for SKBDESC_DMA_MAPPED_TX.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 6d41599..4436ff7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -115,9 +115,7 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
 				 DMA_FROM_DEVICE);
 		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_RX;
-	}
-
-	if (skbdesc->flags & SKBDESC_DMA_MAPPED_TX) {
+	} else if (skbdesc->flags & SKBDESC_DMA_MAPPED_TX) {
 		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
 				 DMA_TO_DEVICE);
 		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_TX;
-- 
1.7.2.3

