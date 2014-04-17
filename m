Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:61355 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaDQN1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 09:27:43 -0400
Received: by mail-pb0-f53.google.com with SMTP id rp16so375923pbb.40
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2014 06:27:42 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 1/6] p54: replace wiphy_debug() with wiphy_dbg()
Date: Thu, 17 Apr 2014 21:27:09 +0800
Message-Id: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com> (sfid-20140417_152747_166081_D6EF8383)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dynamic debug function wiphy_dbg() is more convenient for debugging,
and if user doesn't enable CONFIG_DYNAMIC_DEBUG, it will fall back to
normal static debug, just as what wiphy_debug() does.

When all the users of wiphy_debug() are gone, wiphy_debug() can be
removed.

Cc: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/p54/txrx.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 153c615..2212e99 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -39,8 +39,8 @@ static void p54_dump_tx_queue(struct p54_common *priv)
 	u32 largest_hole = 0, free;
 
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
-	wiphy_debug(priv->hw->wiphy, "/ --- tx queue dump (%d entries) ---\n",
-		    skb_queue_len(&priv->tx_queue));
+	wiphy_dbg(priv->hw->wiphy, "/ --- tx queue dump (%d entries) ---\n",
+		  skb_queue_len(&priv->tx_queue));
 
 	prev_addr = priv->rx_start;
 	skb_queue_walk(&priv->tx_queue, skb) {
@@ -49,23 +49,23 @@ static void p54_dump_tx_queue(struct p54_common *priv)
 		hdr = (void *) skb->data;
 
 		free = range->start_addr - prev_addr;
-		wiphy_debug(priv->hw->wiphy,
-			    "| [%02d] => [skb:%p skb_len:0x%04x "
-			    "hdr:{flags:%02x len:%04x req_id:%04x type:%02x} "
-			    "mem:{start:%04x end:%04x, free:%d}]\n",
-			    i++, skb, skb->len,
-			    le16_to_cpu(hdr->flags), le16_to_cpu(hdr->len),
-			    le32_to_cpu(hdr->req_id), le16_to_cpu(hdr->type),
-			    range->start_addr, range->end_addr, free);
+		wiphy_dbg(priv->hw->wiphy,
+			  "| [%02d] => [skb:%p skb_len:0x%04x "
+			  "hdr:{flags:%02x len:%04x req_id:%04x type:%02x} "
+			  "mem:{start:%04x end:%04x, free:%d}]\n",
+			  i++, skb, skb->len,
+			  le16_to_cpu(hdr->flags), le16_to_cpu(hdr->len),
+			  le32_to_cpu(hdr->req_id), le16_to_cpu(hdr->type),
+			  range->start_addr, range->end_addr, free);
 
 		prev_addr = range->end_addr;
 		largest_hole = max(largest_hole, free);
 	}
 	free = priv->rx_end - prev_addr;
 	largest_hole = max(largest_hole, free);
-	wiphy_debug(priv->hw->wiphy,
-		    "\\ --- [free: %d], largest free block: %d ---\n",
-		    free, largest_hole);
+	wiphy_dbg(priv->hw->wiphy,
+		  "\\ --- [free: %d], largest free block: %d ---\n",
+		  free, largest_hole);
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 }
 #endif /* P54_MM_DEBUG */
@@ -657,9 +657,9 @@ static int p54_rx_control(struct p54_common *priv, struct sk_buff *skb)
 		p54_rx_eeprom_readback(priv, skb);
 		break;
 	default:
-		wiphy_debug(priv->hw->wiphy,
-			    "not handling 0x%02x type control frame\n",
-			    le16_to_cpu(hdr->type));
+		wiphy_dbg(priv->hw->wiphy,
+			  "not handling 0x%02x type control frame\n",
+			  le16_to_cpu(hdr->type));
 		break;
 	}
 	return 0;
-- 
1.9.0

