Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:47442 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYIFAww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 20:52:52 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] p54: 32-bit tsf timestamps
Date: Sat, 6 Sep 2008 02:56:04 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809060256.04842.chunkeey@web.de> (sfid-20080906_025258_255343_C417D6E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


tcpdump:
02:15:42.874518 61112184us tsft 48.0 Mb/s 2437 MHz (0x0480) antenna 1 [0x0000000e] CF +QoS Data IV
02:15:42.874557 >>>4356079526us<<< tsft 24.0 Mb/s 2437 MHz (0x0480) antenna 1 [0x0000000e] Acknowledgment 
02:15:42.976844 61214513us tsft 1.0 Mb/s 2437 MHz (0x0480) antenna 0 [0x0000000e] Beacon

as one can see on the huge jump, it's very plausible that firmware does not report the
full 64-bit mac time, just the lower 32bit and some kinds of flags... 
Therefore if we want a useful timestamp we have to emulate the high bits.
 
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

these are the last patches with new features for longer time for wireless-next.
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-09-04 11:58:24.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-09-05 21:02:22.000000000 +0200
@@ -426,10 +426,12 @@ EXPORT_SYMBOL_GPL(p54_parse_eeprom);
 
 static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
+	struct p54_common *priv = dev->priv;
 	struct p54_rx_hdr *hdr = (struct p54_rx_hdr *) skb->data;
 	struct ieee80211_rx_status rx_status = {0};
 	u16 freq = le16_to_cpu(hdr->freq);
 	size_t header_len = sizeof(*hdr);
+	u32 tsf32;
 
 	rx_status.signal = hdr->rssi;
 	/* XX correct? */
@@ -438,7 +440,13 @@ static int p54_rx_data(struct ieee80211_
 	rx_status.freq = freq;
 	rx_status.band = IEEE80211_BAND_2GHZ;
 	rx_status.antenna = hdr->antenna;
-	rx_status.mactime = le64_to_cpu(hdr->timestamp);
+
+	tsf32 = le32_to_cpu(hdr->tsf32);
+	if (tsf32 < priv->tsf_low32)
+		priv->tsf_high32++;
+	rx_status.mactime = ((u64)priv->tsf_high32) << 32 | tsf32;
+	priv->tsf_low32 = tsf32;
+
 	rx_status.flag |= RX_FLAG_TSFT;
 
 	if (hdr->magic & cpu_to_le16(0x4000))
@@ -1037,6 +1045,7 @@ static void p54_stop(struct ieee80211_hw
 	while ((skb = skb_dequeue(&priv->tx_queue)))
 		kfree_skb(skb);
 	priv->stop(dev);
+	priv->tsf_high32 = priv->tsf_low32 = 0;
 	priv->mode = IEEE80211_IF_TYPE_INVALID;
 }
 
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-09-03 21:53:40.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-09-04 14:42:49.000000000 +0200
@@ -185,7 +185,8 @@ struct p54_rx_hdr {
 	u8 rssi;
 	u8 quality;
 	u16 unknown2;
-	__le64 timestamp;
+	__le32 tsf32;
+	__le32 unalloc0;
 	u8 align[0];
 } __attribute__ ((packed));
 
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-09-03 21:41:19.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-09-04 14:43:07.000000000 +0200
@@ -87,6 +87,8 @@ struct p54_common {
 	void *cached_vdcf;
 	unsigned int fw_var;
 	unsigned int fw_interface;
+	u32 tsf_low32;
+	u32 tsf_high32;
 	struct ieee80211_tx_queue_stats tx_stats[8];
 	void *eeprom;
 	struct completion eeprom_comp;

