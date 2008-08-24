Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:56020 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYHXBMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2008 21:12:07 -0400
From: Chr <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] p54: take tx_queue's lock in rx_frame_sent
Date: Sun, 24 Aug 2008 03:15:06 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808240315.07032.chunkeey@web.de> (sfid-20080824_031212_248932_2C938D0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

p54_rx_frame_sent will alter the tx_queue. Therefore we should hold
the lock to protect against concurrent p54_assign_address calls.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
hmm,

(looking at [GIT]: Networking debate)
linux-next. since there is no known regression that this patch could possibly fix...
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-08-23 21:13:37.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-08-24 02:11:35.000000000 +0200
@@ -432,7 +432,9 @@ static void p54_rx_frame_sent(struct iee
 	struct memrecord *range = NULL;
 	u32 freed = 0;
 	u32 last_addr = priv->rx_start;
+	unsigned long flags;
 
+	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
 		range = (void *)info->driver_data;
@@ -453,6 +455,8 @@ static void p54_rx_frame_sent(struct iee
 
 			last_addr = range->end_addr;
 			__skb_unlink(entry, &priv->tx_queue);
+			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+
 			memset(&info->status, 0, sizeof(info->status));
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
@@ -470,12 +474,14 @@ static void p54_rx_frame_sent(struct iee
 			info->status.ack_signal = le16_to_cpu(payload->ack_rssi);
 			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
 			ieee80211_tx_status_irqsafe(dev, entry);
-			break;
+			goto out;
 		} else
 			last_addr = range->end_addr;
 		entry = entry->next;
 	}
+	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
+out:
 	if (freed >= IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
 	    sizeof(struct p54_control_hdr))
 		p54_wake_free_queues(dev);

