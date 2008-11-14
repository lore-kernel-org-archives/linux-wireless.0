Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:40645 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYKNSlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 13:41:24 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] p54: minor fixes
Date: Fri, 14 Nov 2008 19:41:22 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811141941.22513.chunkeey@web.de> (sfid-20081114_194126_527233_40278930)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch contains only contains a one-liner fixes and enhancements

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-14 17:57:47.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-14 18:08:22.000000000 +0100
@@ -531,6 +531,8 @@ static int p54_rx_data(struct ieee80211_
 	rx_status.noise = priv->noise;
 	/* XX correct? */
 	rx_status.qual = (100 * hdr->rssi) / 127;
+	if (hdr->rate & 0x10)
+		rx_status.flag |= RX_FLAG_SHORTPRE;
 	rx_status.rate_idx = (dev->conf.channel->band == IEEE80211_BAND_2GHZ ?
 			hdr->rate : (hdr->rate - 4)) & 0xf;
 	rx_status.freq = freq;
@@ -577,7 +579,7 @@ void p54_free_skb(struct ieee80211_hw *d
 	unsigned long flags;
 	u32 freed = 0, last_addr = priv->rx_start;
 
-	if (!skb || !dev)
+	if (unlikely(!skb || !dev || !skb_queue_len(&priv->tx_queue)))
 		return;
 
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
@@ -1200,7 +1202,10 @@ static int p54_tx(struct ieee80211_hw *d
 	txhdr->key_type = 0;
 	txhdr->key_len = 0;
 	txhdr->hw_queue = queue;
-	txhdr->backlog = 32;
+	if (current_queue)
+		txhdr->backlog = current_queue->len;
+	else
+		txhdr->backlog = 0;
 	memset(txhdr->durations, 0, sizeof(txhdr->durations));
 	txhdr->tx_antenna = (info->antenna_sel_tx == 0) ?
 		2 : info->antenna_sel_tx - 1;
@@ -1549,7 +1554,6 @@ static void p54_stop(struct ieee80211_hw
 	while ((skb = skb_dequeue(&priv->tx_queue)))
 		kfree_skb(skb);
 
-	kfree(priv->cached_beacon);
 	priv->cached_beacon = NULL;
 	priv->stop(dev);
 	priv->tsf_high32 = priv->tsf_low32 = 0;
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-11-05 23:30:57.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-11-14 00:16:44.000000000 +0100
@@ -259,7 +259,7 @@ enum p54_rx_decrypt_status {
 	P54_DECRYPT_NOCKIPMIC,
 	P54_DECRYPT_FAIL_WEP,
 	P54_DECRYPT_FAIL_TKIP,
-	P54_DECRYPT_FAIL_MICAHEL,
+	P54_DECRYPT_FAIL_MICHAEL,
 	P54_DECRYPT_FAIL_CKIPKP,
 	P54_DECRYPT_FAIL_CKIPMIC,
 	P54_DECRYPT_FAIL_AESCCMP
