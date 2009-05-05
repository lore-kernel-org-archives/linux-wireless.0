Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:44175 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908AbZEEVrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 17:47:08 -0400
Received: by ey-out-2122.google.com with SMTP id 9so1324537eyd.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2009 14:47:06 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] p54: call p54_wake_free_queues on every p54_free_skb and p54_rx_frame_sent
Date: Wed,  6 May 2009 01:47:02 +0400
Message-Id: <1241560022-7597-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently queues are stopped when their length reaches their length limit,
but are restarted only when the size of freed range of packet buffer is
not less than the size of the largest possible packet.

This causes permanent queue stop on radio visibility loss in the middle
of ping series: there is plenty of room in the packet buffer, but it is
never freed more than 3 (size of 'best effort' queue) * 288 (ping packet
plus headers) bytes at once.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/wireless/p54/p54common.c |   23 ++++-------------------
 1 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index b857852..48d81d9 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -822,7 +822,6 @@ void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct ieee80211_tx_info *info;
 	struct p54_tx_info *range;
 	unsigned long flags;
-	u32 freed = 0, last_addr = priv->rx_start;
 
 	if (unlikely(!skb || !dev || !skb_queue_len(&priv->tx_queue)))
 		return;
@@ -842,7 +841,6 @@ void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 		ni = IEEE80211_SKB_CB(skb->prev);
 		mr = (struct p54_tx_info *)ni->rate_driver_data;
-		last_addr = mr->end_addr;
 	}
 	if (skb->next != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *ni;
@@ -850,16 +848,11 @@ void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 		ni = IEEE80211_SKB_CB(skb->next);
 		mr = (struct p54_tx_info *)ni->rate_driver_data;
-		freed = mr->start_addr - last_addr;
-	} else
-		freed = priv->rx_end - last_addr;
+	}
 	__skb_unlink(skb, &priv->tx_queue);
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 	dev_kfree_skb_any(skb);
-
-	if (freed >= priv->headroom + sizeof(struct p54_hdr) + 48 +
-		     IEEE80211_MAX_RTS_THRESHOLD + priv->tailroom)
-		p54_wake_free_queues(dev);
+	p54_wake_free_queues(dev);
 }
 EXPORT_SYMBOL_GPL(p54_free_skb);
 
@@ -893,8 +886,6 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct sk_buff *entry;
 	u32 addr = le32_to_cpu(hdr->req_id) - priv->headroom;
 	struct p54_tx_info *range = NULL;
-	u32 freed = 0;
-	u32 last_addr = priv->rx_start;
 	unsigned long flags;
 	int count, idx;
 
@@ -908,7 +899,6 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 		range = (void *)info->rate_driver_data;
 		if (range->start_addr != addr) {
-			last_addr = range->end_addr;
 			entry = entry->next;
 			continue;
 		}
@@ -919,11 +909,8 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 			ni = IEEE80211_SKB_CB(entry->next);
 			mr = (struct p54_tx_info *)ni->rate_driver_data;
-			freed = mr->start_addr - last_addr;
-		} else
-			freed = priv->rx_end - last_addr;
+		}
 
-		last_addr = range->end_addr;
 		__skb_unlink(entry, &priv->tx_queue);
 		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
@@ -1010,9 +997,7 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
 out:
-	if (freed >= priv->headroom + sizeof(struct p54_hdr) + 48 +
-		     IEEE80211_MAX_RTS_THRESHOLD + priv->tailroom)
-		p54_wake_free_queues(dev);
+	p54_wake_free_queues(dev);
 }
 
 static void p54_rx_eeprom_readback(struct ieee80211_hw *dev,
-- 
1.6.0.6

