Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:55806 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161AbYICUW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 16:22:27 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] p54: better firmware support
Date: Wed, 3 Sep 2008 22:25:25 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809032225.25664.chunkeey@web.de> (sfid-20080903_222241_078598_8AB21D89)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch hopefully contains all necessary changes to support
firmwares for all devices up to atleast 2.13.3.0. 
(or: LowerMAC Protocol Rev: 5.5 ) 

And this is a big win, since:
 * newer firmwares are more stable and reliable than the old ones.
 * no problems anymore with packages > 1399 octets (without lowering the MTU).
 * monitor mode finally works on USB for more than just a few seconds.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

I hope this patch (& new firmware) will fix http://bugzilla.kernel.org/show_bug.cgi?id=11386
so put it into the queue for the next wireless-next.
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-09-03 21:51:52.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-09-03 21:52:05.000000000 +0200
@@ -426,11 +426,12 @@ int p54_parse_eeprom(struct ieee80211_hw
 }
 EXPORT_SYMBOL_GPL(p54_parse_eeprom);
 
-static void p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
+static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_rx_hdr *hdr = (struct p54_rx_hdr *) skb->data;
 	struct ieee80211_rx_status rx_status = {0};
 	u16 freq = le16_to_cpu(hdr->freq);
+	size_t header_len = sizeof(*hdr);
 
 	rx_status.signal = hdr->rssi;
 	/* XX correct? */
@@ -442,10 +443,15 @@ static void p54_rx_data(struct ieee80211
 	rx_status.mactime = le64_to_cpu(hdr->timestamp);
 	rx_status.flag |= RX_FLAG_TSFT;
 
-	skb_pull(skb, sizeof(*hdr));
+	if (hdr->magic & cpu_to_le16(0x4000))
+		header_len += hdr->align[0];
+
+	skb_pull(skb, header_len);
 	skb_trim(skb, le16_to_cpu(hdr->len));
 
 	ieee80211_rx_irqsafe(dev, skb, &rx_status);
+
+	return -1;
 }
 
 static void inline p54_wake_free_queues(struct ieee80211_hw *dev)
@@ -538,7 +544,7 @@ static void p54_rx_eeprom_readback(struc
 	complete(&priv->eeprom_comp);
 }
 
-static void p54_rx_control(struct ieee80211_hw *dev, struct sk_buff *skb)
+static int p54_rx_control(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
 
@@ -556,31 +562,19 @@ static void p54_rx_control(struct ieee80
 		       wiphy_name(dev->wiphy), le16_to_cpu(hdr->type));
 		break;
 	}
+
+	return 0;
 }
 
 /* returns zero if skb can be reused */
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	u8 type = le16_to_cpu(*((__le16 *)skb->data)) >> 8;
-	switch (type) {
-	case 0x00:
-	case 0x01:
-		p54_rx_data(dev, skb);
-		return -1;
-	case 0x4d:
-		/* TODO: do something better... but then again, I've never seen this happen */
-		printk(KERN_ERR "%s: Received fault. Probably need to restart hardware now..\n",
-		       wiphy_name(dev->wiphy));
-		break;
-	case 0x80:
-		p54_rx_control(dev, skb);
-		break;
-	default:
-		printk(KERN_ERR "%s: unknown frame RXed (0x%02x)\n",
-		       wiphy_name(dev->wiphy), type);
-		break;
-	}
-	return 0;
+
+	if (type == 0x80)
+		return p54_rx_control(dev, skb);
+	else
+		return p54_rx_data(dev, skb);
 }
 EXPORT_SYMBOL_GPL(p54_rx);
 
@@ -793,6 +787,7 @@ static int p54_set_filter(struct ieee802
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_filter *filter;
+	size_t data_len;
 
 	hdr = kzalloc(sizeof(*hdr) + sizeof(*filter) +
 		      priv->tx_hdr_len, GFP_ATOMIC);
@@ -803,8 +798,6 @@ static int p54_set_filter(struct ieee802
 
 	filter = (struct p54_tx_control_filter *) hdr->data;
 	hdr->magic1 = cpu_to_le16(0x8001);
-	hdr->len = cpu_to_le16(sizeof(*filter));
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*filter));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_FILTER_SET);
 
 	priv->filter_type = filter->filter_type = cpu_to_le16(filter_type);
@@ -815,13 +808,25 @@ static int p54_set_filter(struct ieee802
 		memcpy(filter->bssid, bssid, ETH_ALEN);
 
 	filter->rx_antenna = priv->rx_antenna;
-	filter->basic_rate_mask = cpu_to_le32(0x15F);
-	filter->rx_addr = cpu_to_le32(priv->rx_end);
-	filter->max_rx = cpu_to_le16(priv->rx_mtu);
-	filter->rxhw = cpu_to_le16(priv->rxhw);
-	filter->wakeup_timer = cpu_to_le16(500);
 
-	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*filter), 1);
+	if (priv->fw_var < 0x500) {
+		data_len = P54_TX_CONTROL_FILTER_V1_LEN;
+		filter->v1.basic_rate_mask = cpu_to_le32(0x15F);
+		filter->v1.rx_addr = cpu_to_le32(priv->rx_end);
+		filter->v1.max_rx = cpu_to_le16(priv->rx_mtu);
+		filter->v1.rxhw = cpu_to_le16(priv->rxhw);
+		filter->v1.wakeup_timer = cpu_to_le16(500);
+	} else {
+		data_len = P54_TX_CONTROL_FILTER_V2_LEN;
+		filter->v2.rx_addr = cpu_to_le32(priv->rx_end);
+		filter->v2.max_rx = cpu_to_le16(priv->rx_mtu);
+		filter->v2.rxhw = cpu_to_le16(priv->rxhw);
+		filter->v2.timer = cpu_to_le16(1000);
+	}
+
+	hdr->len = cpu_to_le16(data_len);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + data_len);
+	priv->tx(dev, hdr, sizeof(*hdr) + data_len, 1);
 	return 0;
 }
 
@@ -831,6 +836,7 @@ static int p54_set_freq(struct ieee80211
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_channel *chan;
 	unsigned int i;
+	size_t data_len;
 	void *entry;
 
 	hdr = kzalloc(sizeof(*hdr) + sizeof(*chan) +
@@ -843,9 +849,8 @@ static int p54_set_freq(struct ieee80211
 	chan = (struct p54_tx_control_channel *) hdr->data;
 
 	hdr->magic1 = cpu_to_le16(0x8001);
-	hdr->len = cpu_to_le16(sizeof(*chan));
+
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_CHANNEL_CHANGE);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*chan));
 
 	chan->flags = cpu_to_le16(0x1);
 	chan->dwell = cpu_to_le16(0x0);
@@ -897,10 +902,20 @@ static int p54_set_freq(struct ieee80211
 		break;
 	}
 
-	chan->rssical_mul = cpu_to_le16(130);
-	chan->rssical_add = cpu_to_le16(0xfe70);	/* -400 */
+	if (priv->fw_var < 0x500) {
+		data_len = P54_TX_CONTROL_CHANNEL_V1_LEN;
+		chan->v1.rssical_mul = cpu_to_le16(130);
+		chan->v1.rssical_add = cpu_to_le16(0xfe70);
+	} else {
+		data_len = P54_TX_CONTROL_CHANNEL_V2_LEN;
+		chan->v2.rssical_mul = cpu_to_le16(130);
+		chan->v2.rssical_add = cpu_to_le16(0xfe70);
+		chan->v2.basic_rate_mask = cpu_to_le32(0x15f);
+	}
 
-	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*chan), 1);
+	hdr->len = cpu_to_le16(data_len);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + data_len);
+	priv->tx(dev, hdr, sizeof(*hdr) + data_len, 1);
 	return 0;
 
  err:
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-09-03 20:17:51.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-09-03 21:53:40.000000000 +0200
@@ -186,7 +186,7 @@ struct p54_rx_hdr {
 	u8 quality;
 	u16 unknown2;
 	__le64 timestamp;
-	u8 data[0];
+	u8 align[0];
 } __attribute__ ((packed));
 
 struct p54_frame_sent_hdr {
@@ -218,15 +218,30 @@ struct p54_tx_control_filter {
 	u8 bssid[ETH_ALEN];
 	u8 rx_antenna;
 	u8 rx_align;
-	__le32 basic_rate_mask;
-	u8 rts_rates[8];
-	__le32 rx_addr;
-	__le16 max_rx;
-	__le16 rxhw;
-	__le16 wakeup_timer;
-	__le16 unalloc;
+	union {
+		struct {
+			__le32 basic_rate_mask;
+			u8 rts_rates[8];
+			__le32 rx_addr;
+			__le16 max_rx;
+			__le16 rxhw;
+			__le16 wakeup_timer;
+			__le16 unalloc0;
+		} v1 __attribute__ ((packed));
+		struct {
+			__le32 rx_addr;
+			__le16 max_rx;
+			__le16 rxhw;
+			__le16 timer;
+			__le16 unalloc0;
+			__le32 unalloc1;
+		} v2 __attribute__ ((packed));
+	} __attribute__ ((packed));
 } __attribute__ ((packed));
 
+#define P54_TX_CONTROL_FILTER_V1_LEN (sizeof(struct p54_tx_control_filter))
+#define P54_TX_CONTROL_FILTER_V2_LEN (sizeof(struct p54_tx_control_filter)-8)
+
 struct p54_tx_control_channel {
 	__le16 flags;
 	__le16 dwell;
@@ -238,15 +253,29 @@ struct p54_tx_control_channel {
 	u8 val_qpsk;
 	u8 val_16qam;
 	u8 val_64qam;
-	struct pda_pa_curve_data_sample_rev1 curve_data[8];
+	struct p54_pa_curve_data_sample curve_data[8];
 	u8 dup_bpsk;
 	u8 dup_qpsk;
 	u8 dup_16qam;
 	u8 dup_64qam;
-	__le16 rssical_mul;
-	__le16 rssical_add;
+	union {
+		struct {
+			__le16 rssical_mul;
+			__le16 rssical_add;
+		} v1 __attribute__ ((packed));
+
+		struct {
+			__le32 basic_rate_mask;
+			 u8 rts_rates[8];
+			__le16 rssical_mul;
+			__le16 rssical_add;
+		} v2 __attribute__ ((packed));
+	} __attribute__ ((packed));
 } __attribute__ ((packed));
 
+#define P54_TX_CONTROL_CHANNEL_V1_LEN (sizeof(struct p54_tx_control_channel)-12)
+#define P54_TX_CONTROL_CHANNEL_V2_LEN (sizeof(struct p54_tx_control_channel))
+
 struct p54_tx_control_led {
 	__le16 mode;
 	__le16 led_temporary;
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-09-03 20:28:20.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-09-03 21:41:19.000000000 +0200
@@ -19,13 +19,24 @@ enum control_frame_types {
 	P54_CONTROL_TYPE_CHANNEL_CHANGE,
 	P54_CONTROL_TYPE_FREQDONE,
 	P54_CONTROL_TYPE_DCFINIT,
-	P54_CONTROL_TYPE_FREEQUEUE = 7,
+	P54_CONTROL_TYPE_ENCRYPTION,
+	P54_CONTROL_TYPE_TIM,
+	P54_CONTROL_TYPE_POWERMGT,
+	P54_CONTROL_TYPE_FREEQUEUE,
 	P54_CONTROL_TYPE_TXDONE,
 	P54_CONTROL_TYPE_PING,
 	P54_CONTROL_TYPE_STAT_READBACK,
 	P54_CONTROL_TYPE_BBP,
 	P54_CONTROL_TYPE_EEPROM_READBACK,
-	P54_CONTROL_TYPE_LED
+	P54_CONTROL_TYPE_LED,
+	P54_CONTROL_TYPE_GPIO,
+	P54_CONTROL_TYPE_TIMER,
+	P54_CONTROL_TYPE_MODULATION,
+	P54_CONTROL_TYPE_SYNTH_CONFIG,
+	P54_CONTROL_TYPE_DETECTOR_VALUE,
+	P54_CONTROL_TYPE_XBOW_SYNTH_CFG,
+	P54_CONTROL_TYPE_CCE_QUIET,
+	P54_CONTROL_TYPE_PSM_STA_UNLOCK,
 };
 
 struct p54_control_hdr {

