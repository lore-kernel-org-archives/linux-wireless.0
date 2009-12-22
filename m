Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55158 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbZLVFZy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 00:25:54 -0500
Subject: Re: [BISECTED] [PATCH v2 8/8] rt2x00: Properly request tx headroom
 for alignment operations.
From: Pavel Roskin <proski@gnu.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Markus Baier <Markus_Baier@web.de>, linux-wireless@vger.kernel.org
In-Reply-To: <4B2FA1CF.1010903@gmail.com>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-2-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-3-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-4-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-5-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-6-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-7-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-8-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-9-git-send-email-gwingerde@gmail.com>
	 <loom.20091220T163829-137@post.gmane.org> <4B2E8729.7050501@gmail.com>
	 <20091221013316.nm9belnhywwwsc0w-cebfxv@webmail.spamcop.net>
	 <4B2FA1CF.1010903@gmail.com>
Content-Type: text/plain
Date: Tue, 22 Dec 2009 00:25:49 -0500
Message-Id: <1261459549.31982.2.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Gertjan van Wingerde <gwingerde@gmail.com>:

>> Perhaps non-zero headroom is not handled correctly?
>>
>
> Hmmm, perhaps the problem is that the headroom is not a multiple of 4.
> Can you check what happens when you set the extra_tx_headroom fixed  
> to e.g. 20?

I tried 64 and 2, and neither worked.  rt2x00dev->ops->extra_tx_headroom
is 0 for me.  When the rt2x00dev->hw->extra_tx_headroom is 2, I observed
invalid packets being emitted (using another interface).  The packets
have two bytes inserted in the beginning of the frame:

0000  00 00 1c 00 6f 48 00 00  fc de ee 13 00 00 00 00   ....oH.. ........
0010  10 02 85 09 a0 00 b1 b7  00 00 00 00 00 00 40 00   ........ ......@.
radiotap, 28 bytes ---------------------->
2 extra bytes                              <--->
correct 802.11 header                            <----
0020  00 00 ff ff ff ff ff ff  00 d0 41 af ad 2c ff ff   ........ ..A..,..
0030  ff ff cf 02 c0 02 00 05  77 62 65 6e 64 01 08 02   ........ wbend...
0040  04 0b 16 0c 12 18 24 32  04 30 48 e7 f8 07 9d      ......$2 .0H.... 

Here's a patch that is working for me, but I would not vouch for its
correctness.  Signing off just in case it happens to be correct ;-)


rt2x00: use correct headroom for transmission

Use rt2x00dev->ops->extra_tx_headroom, not
rt2x00dev->hw->extra_tx_headroom in the tx code, as the later includes
headroom only meant for the monitor mode.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 3d8fb68..0b4801a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -104,7 +104,7 @@ void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	 * is also mapped to the DMA so it can be used for transfering
 	 * additional descriptor information to the hardware.
 	 */
-	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
+	skb_push(skb, rt2x00dev->ops->extra_tx_headroom);
 
 	skbdesc->skb_dma =
 	    dma_map_single(rt2x00dev->dev, skb->data, skb->len, DMA_TO_DEVICE);
@@ -112,7 +112,7 @@ void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	/*
 	 * Restore data pointer to original location again.
 	 */
-	skb_pull(skb, rt2x00dev->hw->extra_tx_headroom);
+	skb_pull(skb, rt2x00dev->ops->extra_tx_headroom);
 
 	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
 }
@@ -134,7 +134,7 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 		 * by the driver, but it was actually mapped to DMA.
 		 */
 		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma,
-				 skb->len + rt2x00dev->hw->extra_tx_headroom,
+				 skb->len + rt2x00dev->ops->extra_tx_headroom,
 				 DMA_TO_DEVICE);
 		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_TX;
 	}

-- 
Regards,
Pavel Roskin
