Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:59768 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbYHXBMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2008 21:12:15 -0400
From: Chr <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] p54: redo queue numbering
Date: Sun, 24 Aug 2008 03:15:16 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808240315.16474.chunkeey@web.de> (sfid-20080824_031217_362246_B67F33B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware supports 8 different queues and not only 4. 
So, let's make some room for further tasks (ap/adhoc support)
in this area.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
that's definitely linux-next material.
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-08-24 02:11:35.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-08-24 02:20:55.000000000 +0200
@@ -146,10 +146,10 @@ void p54_parse_firmware(struct ieee80211
 
 	if (priv->fw_var >= 0x300) {
 		/* Firmware supports QoS, use it! */
-		priv->tx_stats[0].limit = 3;
-		priv->tx_stats[1].limit = 4;
-		priv->tx_stats[2].limit = 3;
-		priv->tx_stats[3].limit = 1;
+		priv->tx_stats[4].limit = 3;
+		priv->tx_stats[5].limit = 4;
+		priv->tx_stats[6].limit = 3;
+		priv->tx_stats[7].limit = 1;
 		dev->queues = 4;
 	}
 }
@@ -418,7 +418,7 @@ static void inline p54_wake_free_queues(
 	int i;
 
 	for (i = 0; i < dev->queues; i++)
-		if (priv->tx_stats[i].len < priv->tx_stats[i].limit)
+		if (priv->tx_stats[i + 4].len < priv->tx_stats[i + 4].limit)
 			ieee80211_wake_queue(dev, i);
 }
 
@@ -463,7 +463,7 @@ static void p54_rx_frame_sent(struct iee
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
 				pad = entry_data->align[0];
 
-			priv->tx_stats[entry_data->hw_queue - 4].len--;
+			priv->tx_stats[entry_data->hw_queue].len--;
 			if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 				if (!(payload->status & 0x01))
 					info->flags |= IEEE80211_TX_STAT_ACK;
@@ -606,7 +606,7 @@ static int p54_tx(struct ieee80211_hw *d
 	u8 rate;
 	u8 cts_rate = 0x20;
 
-	current_queue = &priv->tx_stats[skb_get_queue_mapping(skb)];
+	current_queue = &priv->tx_stats[skb_get_queue_mapping(skb) + 4];
 	if (unlikely(current_queue->len > current_queue->limit))
 		return NETDEV_TX_BUSY;
 	current_queue->len++;
@@ -1037,7 +1037,7 @@ static int p54_get_tx_stats(struct ieee8
 {
 	struct p54_common *priv = dev->priv;
 
-	memcpy(stats, &priv->tx_stats, sizeof(stats[0]) * dev->queues);
+	memcpy(stats, &priv->tx_stats[4], sizeof(stats[0]) * dev->queues);
 
 	return 0;
 }
@@ -1075,7 +1075,11 @@ struct ieee80211_hw *p54_init_common(siz
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	dev->max_signal = 127;
 
-	priv->tx_stats[0].limit = 5;
+	priv->tx_stats[0].limit = 1;
+	priv->tx_stats[1].limit = 1;
+	priv->tx_stats[2].limit = 1;
+	priv->tx_stats[3].limit = 1;
+	priv->tx_stats[4].limit = 5;
 	dev->queues = 1;
 
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-08-24 02:02:48.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-08-24 02:13:57.000000000 +0200
@@ -66,7 +66,7 @@ struct p54_common {
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
 	unsigned int fw_var;
-	struct ieee80211_tx_queue_stats tx_stats[4];
+	struct ieee80211_tx_queue_stats tx_stats[8];
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);

