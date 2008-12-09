Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:60424 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbYLIUHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 15:07:48 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] p54: fix oops on faulty devices
Date: Tue, 9 Dec 2008 21:07:50 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812092107.50174.chunkeey@web.de> (sfid-20081209_210752_395713_CD9A22DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an oops when the devices suddenly starts
to receive martian data frames.

bug reference:
http://marc.info/?l=linux-wireless&m=122872280317635&w=2

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-09 19:13:06.867910376 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-09 20:13:56.467888032 +0100
@@ -541,6 +541,14 @@ static int p54_rx_data(struct ieee80211_
 	size_t header_len = sizeof(*hdr);
 	u32 tsf32;
 
+	/*
+	 * If the device is in a unspecified state we have to
+	 * ignore all data frames. Else we could end up with a
+	 * nasty crash.
+	 */
+	if (unlikely(priv->mode == NL80211_IFTYPE_UNSPECIFIED))
+		return 0;
+
 	if (!(hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_IN_FCS_GOOD))) {
 		if (priv->filter_flags & FIF_FCSFAIL)
 			rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
@@ -609,6 +617,12 @@ void p54_free_skb(struct ieee80211_hw *d
 	if (unlikely(!skb || !dev || !skb_queue_len(&priv->tx_queue)))
 		return;
 
+	/*
+	 * don't try to free an already unlinked skb
+	 */
+	if (unlikely((!skb->next) || (!skb->prev)))
+		return;
+
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	info = IEEE80211_SKB_CB(skb);
 	range = (void *)info->rate_driver_data;
@@ -1676,19 +1690,18 @@ static void p54_stop(struct ieee80211_hw
 	struct sk_buff *skb;
 
 	mutex_lock(&priv->conf_mutex);
+	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 	del_timer(&priv->stats_timer);
 	p54_free_skb(dev, priv->cached_stats);
 	priv->cached_stats = NULL;
 	if (priv->cached_beacon)
 		p54_tx_cancel(dev, priv->cached_beacon);
 
+	priv->stop(dev);
 	while ((skb = skb_dequeue(&priv->tx_queue)))
 		kfree_skb(skb);
-
 	priv->cached_beacon = NULL;
-	priv->stop(dev);
 	priv->tsf_high32 = priv->tsf_low32 = 0;
-	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 	mutex_unlock(&priv->conf_mutex);
 }
 
