Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:57981 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbYK2VeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 16:34:00 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/6 v2] p54: revamp station power save management in access point mode
Date: Sat, 29 Nov 2008 22:33:57 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811292233.58204.chunkeey@web.de> (sfid-20081129_223408_914013_737E231A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch addresses the problem in:
http://marc.info/?l=linux-wireless&m=122727674810057&w=2

Thanks to Stefan Steuerwald <salsasepp@googlemail.com> 
extensive iPod touch tests. We could finally squash some bugs in 
p54's master mode / access point implementation.

Let's hope we got everything right this time and all stations
from now on will wake up on TIM and receive their queued frames
and go to sleep again without any hiccups. 

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-28 20:18:53.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-29 21:32:59.000000000 +0100
@@ -653,6 +653,10 @@ static void p54_rx_frame_sent(struct iee
 		__skb_unlink(entry, &priv->tx_queue);
 		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
+		entry_hdr = (struct p54_hdr *) entry->data;
+		entry_data = (struct p54_tx_data *) entry_hdr->data;
+		priv->tx_stats[entry_data->hw_queue].len--;
+
 		if (unlikely(entry == priv->cached_beacon)) {
 			kfree_skb(entry);
 			priv->cached_beacon = NULL;
@@ -669,8 +673,6 @@ static void p54_rx_frame_sent(struct iee
 		BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
 				      status.ampdu_ack_len) != 23);
 
-		entry_hdr = (struct p54_hdr *) entry->data;
-		entry_data = (struct p54_tx_data *) entry_hdr->data;
 		if (entry_hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 			pad = entry_data->align[0];
 
@@ -688,7 +690,6 @@ static void p54_rx_frame_sent(struct iee
 			}
 		}
 
-		priv->tx_stats[entry_data->hw_queue].len--;
 		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
 		     (!payload->status))
 			info->flags |= IEEE80211_TX_STAT_ACK;
@@ -1005,6 +1006,38 @@ static int p54_sta_unlock(struct ieee802
 	return 0;
 }
 
+static void p54_sta_notify_ps(struct ieee80211_hw *dev,
+			      enum sta_notify_ps_cmd notify_cmd,
+			      struct ieee80211_sta *sta)
+{
+	switch (notify_cmd) {
+	case STA_NOTIFY_AWAKE:
+		p54_sta_unlock(dev, sta->addr);
+		break;
+	default:
+		break;
+	}
+}
+
+static void p54_sta_notify(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
+			      enum sta_notify_cmd notify_cmd,
+			      struct ieee80211_sta *sta)
+{
+	switch (notify_cmd) {
+	case STA_NOTIFY_ADD:
+	case STA_NOTIFY_REMOVE:
+		/*
+		 * Notify the firmware that we don't want or we don't
+		 * need to buffer frames for this station anymore.
+		 */
+
+		p54_sta_unlock(dev, sta->addr);
+		break;
+	default:
+		break;
+	}
+}
+
 static int p54_tx_cancel(struct ieee80211_hw *dev, struct sk_buff *entry)
 {
 	struct p54_common *priv = dev->priv;
@@ -1070,7 +1103,7 @@ static int p54_tx_fill(struct ieee80211_
 		if (info->control.sta)
 			*aid = info->control.sta->aid;
 		else
-			*flags = P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+			*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 	}
 	return ret;
 }
@@ -1083,7 +1116,7 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
 	size_t padding, len, tim_len = 0;
-	int i, j, ridx;
+	int i, j, ridx, ret;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue;
 	u8 cts_rate = 0x20;
@@ -1093,30 +1126,18 @@ static int p54_tx(struct ieee80211_hw *d
 
 	queue = skb_get_queue_mapping(skb);
 
-	if (p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid)) {
-		current_queue = &priv->tx_stats[queue];
-		if (unlikely(current_queue->len > current_queue->limit))
-			return NETDEV_TX_BUSY;
-		current_queue->len++;
-		current_queue->count++;
-		if (current_queue->len == current_queue->limit)
-			ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
-	}
+	ret = p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid);
+	current_queue = &priv->tx_stats[queue];
+	if (unlikely((current_queue->len > current_queue->limit) && ret))
+		return NETDEV_TX_BUSY;
+	current_queue->len++;
+	current_queue->count++;
+	if ((current_queue->len == current_queue->limit) && ret)
+		ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
 
-	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) {
-		if (info->control.sta)
-			if (p54_sta_unlock(dev, info->control.sta->addr)) {
-				if (current_queue) {
-					current_queue->len--;
-					current_queue->count--;
-				}
-				return NETDEV_TX_BUSY;
-			}
-	}
-
 	txhdr = (struct p54_tx_data *) skb_push(skb, sizeof(*txhdr) + padding);
 	hdr = (struct p54_hdr *) skb_push(skb, sizeof(*hdr));
 
@@ -1835,6 +1856,8 @@ static const struct ieee80211_ops p54_op
 	.add_interface		= p54_add_interface,
 	.remove_interface	= p54_remove_interface,
 	.set_tim		= p54_set_tim,
+	.sta_notify_ps		= p54_sta_notify_ps,
+	.sta_notify		= p54_sta_notify,
 	.config			= p54_config,
 	.config_interface	= p54_config_interface,
 	.bss_info_changed	= p54_bss_info_changed,
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-11-28 20:18:53.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-11-29 18:19:35.000000000 +0100
@@ -302,7 +302,7 @@ enum p54_frame_sent_status {
 	P54_TX_OK = 0,
 	P54_TX_FAILED,
 	P54_TX_PSM,
-	P54_TX_PSM_CANCELLED
+	P54_TX_PSM_CANCELLED = 4
 };
 
 struct p54_frame_sent {
