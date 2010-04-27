Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47625 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab0D0VA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 17:00:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8180: use cached queue mapping for skb in rtl8180_tx
Date: Tue, 27 Apr 2010 16:57:38 -0400
Message-Id: <1272401858-23077-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index f4d3618..d84ad05 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -305,7 +305,7 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	entry->flags = cpu_to_le32(tx_flags);
 	__skb_queue_tail(&ring->queue, skb);
 	if (ring->entries - skb_queue_len(&ring->queue) < 2)
-		ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
+		ieee80211_stop_queue(dev, prio);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING, (1 << (prio + 4)));
-- 
1.6.6.1

