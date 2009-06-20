Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:56668 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZFTTNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 15:13:45 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: redo rx_status into skb->cb
Date: Sat, 20 Jun 2009 21:13:46 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200906202113.46470.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch slightly optimizes p54_rx_data's stack and code size.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 47285b3..b2d3d03 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -743,7 +743,7 @@ static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_rx_data *hdr = (struct p54_rx_data *) skb->data;
-	struct ieee80211_rx_status rx_status = {0};
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	u16 freq = le16_to_cpu(hdr->freq);
 	size_t header_len = sizeof(*hdr);
 	u32 tsf32;
@@ -762,39 +762,37 @@ static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 	}
 
 	if (hdr->decrypt_status == P54_DECRYPT_OK)
-		rx_status.flag |= RX_FLAG_DECRYPTED;
+		rx_status->flag |= RX_FLAG_DECRYPTED;
 	if ((hdr->decrypt_status == P54_DECRYPT_FAIL_MICHAEL) ||
 	    (hdr->decrypt_status == P54_DECRYPT_FAIL_TKIP))
-		rx_status.flag |= RX_FLAG_MMIC_ERROR;
+		rx_status->flag |= RX_FLAG_MMIC_ERROR;
 
-	rx_status.signal = p54_rssi_to_dbm(dev, hdr->rssi);
-	rx_status.noise = priv->noise;
+	rx_status->signal = p54_rssi_to_dbm(dev, hdr->rssi);
+	rx_status->noise = priv->noise;
 	if (hdr->rate & 0x10)
-		rx_status.flag |= RX_FLAG_SHORTPRE;
+		rx_status->flag |= RX_FLAG_SHORTPRE;
 	if (dev->conf.channel->band == IEEE80211_BAND_5GHZ)
-		rx_status.rate_idx = (rate < 4) ? 0 : rate - 4;
+		rx_status->rate_idx = (rate < 4) ? 0 : rate - 4;
 	else
-		rx_status.rate_idx = rate;
+		rx_status->rate_idx = rate;
 
-	rx_status.freq = freq;
-	rx_status.band =  dev->conf.channel->band;
-	rx_status.antenna = hdr->antenna;
+	rx_status->freq = freq;
+	rx_status->band =  dev->conf.channel->band;
+	rx_status->antenna = hdr->antenna;
 
 	tsf32 = le32_to_cpu(hdr->tsf32);
 	if (tsf32 < priv->tsf_low32)
 		priv->tsf_high32++;
-	rx_status.mactime = ((u64)priv->tsf_high32) << 32 | tsf32;
+	rx_status->mactime = ((u64)priv->tsf_high32) << 32 | tsf32;
 	priv->tsf_low32 = tsf32;
 
-	rx_status.flag |= RX_FLAG_TSFT;
+	rx_status->flag |= RX_FLAG_TSFT;
 
 	if (hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 		header_len += hdr->align[0];
 
 	skb_pull(skb, header_len);
 	skb_trim(skb, le16_to_cpu(hdr->len));
-
-	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 	ieee80211_rx_irqsafe(dev, skb);
 
 	queue_delayed_work(dev->workqueue, &priv->work,
