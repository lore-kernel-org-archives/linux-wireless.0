Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:35703 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbYJEAfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 20:35:15 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][PATCH 3/5] p54: refactor p54_rx_frame_sent
Date: Sun, 5 Oct 2008 02:39:10 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810050239.10220.chunkeey@web.de> (sfid-20081005_023521_632305_32DB188C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the long names and the nesting in p54_rx_frame_sent really became a "line longer than 80 characters" problem.

---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-05 01:46:18.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-05 01:46:31.000000000 +0200
@@ -557,54 +557,56 @@ static void p54_rx_frame_sent(struct iee
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
-		range = (void *)info->driver_data;
-		if (range->start_addr == addr) {
-			struct p54_control_hdr *entry_hdr;
-			struct p54_tx_control_allocdata *entry_data;
-			int pad = 0;
-
-			if (entry->next != (struct sk_buff *)&priv->tx_queue) {
-				struct ieee80211_tx_info *ni;
-				struct memrecord *mr;
-
-				ni = IEEE80211_SKB_CB(entry->next);
-				mr = (struct memrecord *)ni->driver_data;
-				freed = mr->start_addr - last_addr;
-			} else
-				freed = priv->rx_end - last_addr;
+		struct p54_control_hdr *entry_hdr;
+		struct p54_tx_control_allocdata *entry_data;
+		int pad = 0;
 
+		range = (void *)info->driver_data;
+		if (range->start_addr != addr) {
 			last_addr = range->end_addr;
-			__skb_unlink(entry, &priv->tx_queue);
-			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+			entry = entry->next;
+			continue;
+		}
 
-			memset(&info->status, 0, sizeof(info->status));
-			entry_hdr = (struct p54_control_hdr *) entry->data;
-			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
-			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
-				pad = entry_data->align[0];
-
-			priv->tx_stats[entry_data->hw_queue].len--;
-			if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-				if (!(payload->status & 0x01))
-					info->flags |= IEEE80211_TX_STAT_ACK;
-				else
-					info->status.excessive_retries = 1;
-			}
-			info->status.retry_count = payload->retries - 1;
-			info->status.ack_signal = p54_rssi_to_dbm(dev,
-					le16_to_cpu(payload->ack_rssi));
-			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
-			ieee80211_tx_status_irqsafe(dev, entry);
-			goto out;
+		if (entry->next != (struct sk_buff *)&priv->tx_queue) {
+			struct ieee80211_tx_info *ni;
+			struct memrecord *mr;
+
+			ni = IEEE80211_SKB_CB(entry->next);
+			mr = (struct memrecord *)ni->driver_data;
+			freed = mr->start_addr - last_addr;
 		} else
-			last_addr = range->end_addr;
-		entry = entry->next;
+			freed = priv->rx_end - last_addr;
+
+		last_addr = range->end_addr;
+		__skb_unlink(entry, &priv->tx_queue);
+		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+
+		memset(&info->status, 0, sizeof(info->status));
+		entry_hdr = (struct p54_control_hdr *) entry->data;
+		entry_data = (struct p54_tx_control_allocdata *)entry_hdr->data;
+		if (entry_hdr->magic1 & cpu_to_le16(0x4000))
+			pad = entry_data->align[0];
+
+		priv->tx_stats[entry_data->hw_queue].len--;
+		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+			if (!(payload->status & 0x01))
+				info->flags |= IEEE80211_TX_STAT_ACK;
+			else
+				info->status.excessive_retries = 1;
+		}
+		info->status.retry_count = payload->retries - 1;
+		info->status.ack_signal = p54_rssi_to_dbm(dev,
+				le16_to_cpu(payload->ack_rssi));
+		skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
+		ieee80211_tx_status_irqsafe(dev, entry);
+		goto out;
 	}
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
 out:
-	if (freed >= IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
-	    sizeof(struct p54_control_hdr))
+	if (freed >= IEEE80211_MAX_RTS_THRESHOLD + priv->headroom +
+	    priv->tailroom + sizeof(struct p54_control_hdr))
 		p54_wake_free_queues(dev);
 }
 

