Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:37616 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYJOCBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 22:01:41 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] p54: p54: refactor p54_rx_frame_sent
Date: Wed, 15 Oct 2008 04:05:51 +0200
Cc: Pavel Roskin <proski@gnu.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810150405.51476.chunkeey@web.de> (sfid-20081015_040143_761622_6117FC8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the long names and the nesting in p54_rx_frame_sent really
became a "line longer than 80 characters" problem.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-14 22:22:12.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-14 22:23:19.000000000 +0200
@@ -549,73 +549,77 @@ static void p54_rx_frame_sent(struct iee
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
-		range = (void *)info->rate_driver_data;
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
-				mr = (struct memrecord *)ni->rate_driver_data;
-				freed = mr->start_addr - last_addr;
-			} else
-				freed = priv->rx_end - last_addr;
+		struct p54_control_hdr *entry_hdr;
+		struct p54_tx_control_allocdata *entry_data;
+		int pad = 0;
 
+		range = (void *)info->rate_driver_data;
+		if (range->start_addr != addr) {
 			last_addr = range->end_addr;
-			__skb_unlink(entry, &priv->tx_queue);
-			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+			entry = entry->next;
+			continue;
+		}
+
+		if (entry->next != (struct sk_buff *)&priv->tx_queue) {
+			struct ieee80211_tx_info *ni;
+			struct memrecord *mr;
+
+			ni = IEEE80211_SKB_CB(entry->next);
+			mr = (struct memrecord *)ni->rate_driver_data;
+			freed = mr->start_addr - last_addr;
+		} else
+			freed = priv->rx_end - last_addr;
+
+		last_addr = range->end_addr;
+		__skb_unlink(entry, &priv->tx_queue);
+		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
-			/*
-			 * Clear manually, ieee80211_tx_info_clear_status would
-			 * clear the counts too and we need them.
-			 */
-			memset(&info->status.ampdu_ack_len, 0,
-			       sizeof(struct ieee80211_tx_info) -
-			       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
-			BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
-			                      status.ampdu_ack_len) != 23);
-
-			entry_hdr = (struct p54_control_hdr *) entry->data;
-			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
-			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
-				pad = entry_data->align[0];
-
-			/* walk through the rates array and adjust the counts */
-			count = payload->retries;
-			for (idx = 0; idx < 4; idx++) {
-				if (count >= info->status.rates[idx].count) {
-					count -= info->status.rates[idx].count;
-				} else if (count > 0) {
-					info->status.rates[idx].count = count;
-					count = 0;
-				} else {
-					info->status.rates[idx].idx = -1;
-					info->status.rates[idx].count = 0;
-				}
+		/*
+		 * Clear manually, ieee80211_tx_info_clear_status would
+		 * clear the counts too and we need them.
+		 */
+		memset(&info->status.ampdu_ack_len, 0,
+		       sizeof(struct ieee80211_tx_info) -
+		       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
+		BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
+				      status.ampdu_ack_len) != 23);
+
+		entry_hdr = (struct p54_control_hdr *) entry->data;
+		entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
+		if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
+			pad = entry_data->align[0];
+
+		/* walk through the rates array and adjust the counts */
+		count = payload->retries;
+		for (idx = 0; idx < 4; idx++) {
+			if (count >= info->status.rates[idx].count) {
+				count -= info->status.rates[idx].count;
+			} else if (count > 0) {
+				info->status.rates[idx].count = count;
+				count = 0;
+			} else {
+				info->status.rates[idx].idx = -1;
+				info->status.rates[idx].count = 0;
 			}
+		}
 
-			priv->tx_stats[entry_data->hw_queue].len--;
-			if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
-			    !(payload->status & 0x01))
-				info->flags |= IEEE80211_TX_STAT_ACK;
-			info->status.ack_signal = p54_rssi_to_dbm(dev,
-					le16_to_cpu(payload->ack_rssi));
-			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
-			ieee80211_tx_status_irqsafe(dev, entry);
-			goto out;
-		} else
-			last_addr = range->end_addr;
-		entry = entry->next;
+		priv->tx_stats[entry_data->hw_queue].len--;
+		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+		     (!payload->status))
+			info->flags |= IEEE80211_TX_STAT_ACK;
+		if (payload->status & 0x02)
+			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
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
+	if (freed >= priv->headroom + sizeof(struct p54_control_hdr) + 48 +
+		     IEEE80211_MAX_RTS_THRESHOLD + priv->tailroom)
 		p54_wake_free_queues(dev);
 }
 
