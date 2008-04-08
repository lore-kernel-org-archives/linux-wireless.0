Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:58472 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYDHMsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 08:48:19 -0400
From: Chr <chunkeey@web.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [RFC][PATCH 0/4] p54: various updates (all in one)
Date: Tue, 8 Apr 2008 14:48:14 +0200
Cc: linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	"John Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <200804012339.37204.chunkeey@web.de> <43e72e890804031534y2afdc8d4h1154414df2ccdcd3@mail.gmail.com> <200804040407.52432.chunkeey@web.de>
In-Reply-To: <200804040407.52432.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Pm2+HLra7q2DoAa"
Message-Id: <200804081448.15135.chunkeey@web.de> (sfid-20080408_134826_540371_88F67720)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_Pm2+HLra7q2DoAa
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Give it a good testing!

Notes:
- IBSS mode is maybe a buggy, but it'll take another semester break to figure  
 out whats wrong with the TSF timer.

- Powersaving package queueing is disabled in AP-Mode. As my Intel 4965N
 won't reconnect with it. (but the atheros card does?!)

BTW:
since no one has the codebase to p54/, or made any other changes I made the 
(all-in-on) diff against the (old) kernel-code... but with the _new_ path!

if you want to test it, don't forget the mac80211 patch!
http://article.gmane.org/gmane.linux.kernel.wireless.general/13115 

Regards,
 	Chr.

--Boundary-00=_Pm2+HLra7q2DoAa
Content-Type: text/x-diff;
  charset="utf-8";
  name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="diff"

diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-03-29 16:05:32.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-04-08 14:24:39.000000000 +0200
@@ -3,7 +3,7 @@
  * Common code for mac80211 Prism54 drivers
  *
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
- * Copyright (c) 2007, Christian Lamparter <chunkeey@web.de>
+ * Copyright (c) 2007, 2008, Christian Lamparter <chunkeey@web.de>
  *
  * Based on the islsm (softmac prism54) driver, which is:
  * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
@@ -25,7 +25,7 @@
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_DESCRIPTION("Softmac Prism54 common code");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("prism54common");
+MODULE_ALIAS("p54common");
 
 static struct ieee80211_rate p54_rates[] = {
 	{ .bitrate = 10, .hw_value = 0, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
@@ -66,7 +66,6 @@ static struct ieee80211_supported_band b
 	.n_bitrates = ARRAY_SIZE(p54_rates),
 };
 
-
 void p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 {
 	struct p54_common *priv = dev->priv;
@@ -146,10 +145,10 @@ void p54_parse_firmware(struct ieee80211
 
 	if (priv->fw_var >= 0x300) {
 		/* Firmware supports QoS, use it! */
-		priv->tx_stats.data[0].limit = 3;
-		priv->tx_stats.data[1].limit = 4;
-		priv->tx_stats.data[2].limit = 3;
-		priv->tx_stats.data[3].limit = 1;
+		priv->tx_stats[4].limit = 3;
+		priv->tx_stats[5].limit = 4;
+		priv->tx_stats[6].limit = 3;
+		priv->tx_stats[7].limit = 1;
 		dev->queues = 4;
 	}
 }
@@ -297,10 +296,6 @@ int p54_parse_eeprom(struct ieee80211_hw
 			/* make it overrun */
 			entry_len = len;
 			break;
-		default:
-			printk(KERN_INFO "p54: unknown eeprom code : 0x%x\n",
-				le16_to_cpu(entry->code));
-			break;
 		}
 
 		entry = (void *)entry + (entry_len + 1)*2;
@@ -335,6 +330,11 @@ int p54_parse_eeprom(struct ieee80211_hw
 }
 EXPORT_SYMBOL_GPL(p54_parse_eeprom);
 
+static inline int p54_rssi_to_dbm(u8 rssi)
+{
+	return rssi / 2 - 100;
+}
+
 void p54_fill_eeprom_readback(struct p54_control_hdr *hdr)
 {
 	struct p54_eeprom_lm86 *eeprom_hdr;
@@ -349,16 +349,28 @@ void p54_fill_eeprom_readback(struct p54
 }
 EXPORT_SYMBOL_GPL(p54_fill_eeprom_readback);
 
-static void p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
+static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
+	struct p54_common *priv = dev->priv;
 	struct p54_rx_hdr *hdr = (struct p54_rx_hdr *) skb->data;
 	struct ieee80211_rx_status rx_status = {0};
-	u16 freq = le16_to_cpu(hdr->freq);
 
-	rx_status.ssi = hdr->rssi;
-	/* XX correct? */
+	if (!(hdr->magic & cpu_to_le16(0x01))) {
+		if (priv->rx_filter == P54_RX_FILTER_FCSFAIL)
+			rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+		else
+			/* reuse skb */
+			return 0;
+	}
+	rx_status.ssi = p54_rssi_to_dbm(hdr->rssi);
+	rx_status.noise = priv->stats.noise_floor;
+	if (rx_status.ssi > rx_status.noise)
+		rx_status.signal = rx_status.ssi - rx_status.noise;
+
+	/* FIX MAC80211: for now we remove the short preamble flag */
 	rx_status.rate_idx = hdr->rate & 0xf;
-	rx_status.freq = freq;
+
+	rx_status.freq = le16_to_cpu(hdr->freq);
 	rx_status.band = IEEE80211_BAND_2GHZ;
 	rx_status.antenna = hdr->antenna;
 	rx_status.mactime = le64_to_cpu(hdr->timestamp);
@@ -368,6 +380,8 @@ static void p54_rx_data(struct ieee80211
 	skb_trim(skb, le16_to_cpu(hdr->len));
 
 	ieee80211_rx_irqsafe(dev, skb, &rx_status);
+
+	return -1;
 }
 
 static void inline p54_wake_free_queues(struct ieee80211_hw *dev)
@@ -379,7 +393,7 @@ static void inline p54_wake_free_queues(
 	 * But, what if some are full? */
 
 	for (i = 0; i < dev->queues; i++)
-		if (priv->tx_stats.data[i].len < priv->tx_stats.data[i].limit)
+		if (priv->tx_stats[i + 4].len < priv->tx_stats[i + 4].limit)
 			ieee80211_wake_queue(dev, i);
 }
 
@@ -388,12 +402,15 @@ static void p54_rx_frame_sent(struct iee
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
 	struct p54_frame_sent_hdr *payload = (struct p54_frame_sent_hdr *) hdr->data;
-	struct sk_buff *entry = (struct sk_buff *) priv->tx_queue.next;
+	struct sk_buff *entry;
+	unsigned long flags;
 	u32 addr = le32_to_cpu(hdr->req_id) - 0x70;
 	struct memrecord *range = NULL;
 	u32 freed = 0;
 	u32 last_addr = priv->rx_start;
 
+	spin_lock_irqsave(&priv->tx_queue.lock, flags);
+	entry = (struct sk_buff *) priv->tx_queue.next;
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		range = (struct memrecord *)&entry->cb;
 		if (range->start_addr == addr) {
@@ -409,42 +426,68 @@ static void p54_rx_frame_sent(struct iee
 
 			last_addr = range->end_addr;
 			__skb_unlink(entry, &priv->tx_queue);
+			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+
 			if (!range->control) {
 				kfree_skb(entry);
-				break;
+				goto out;
 			}
 			memset(&status, 0, sizeof(status));
 			memcpy(&status.control, range->control,
 			       sizeof(status.control));
 			kfree(range->control);
-			priv->tx_stats.data[status.control.queue].len--;
 
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
+			priv->tx_stats[entry_data->frame_type].len--;
+
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
 				pad = entry_data->align[0];
 
 			if (!(status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
 				if (!(payload->status & 0x01))
 					status.flags |= IEEE80211_TX_STATUS_ACK;
-				else
-					status.excessive_retries = 1;
+				else {
+					if ((payload->status & 0x04) && 
+					   (priv->mode == IEEE80211_IF_TYPE_AP))
+						status.flags |= IEEE80211_TX_STATUS_TX_FILTERED;
+					else
+						status.excessive_retries = 1;
+				}
 			}
 			status.retry_count = payload->retries - 1;
 			status.ack_signal = le16_to_cpu(payload->ack_rssi);
 			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
 			ieee80211_tx_status_irqsafe(dev, entry, &status);
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
 }
 
+static void p54_rx_stats(struct ieee80211_hw *dev, struct sk_buff *skb)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
+	struct p54_statistics *hw_stats = (struct p54_statistics *)hdr->data;
+
+	priv->stats.rx_success = le32_to_cpu(hw_stats->rx_success);
+	priv->stats.rx_errors = le32_to_cpu(hw_stats->rx_errors);
+	priv->stats.rx_aborts = le32_to_cpu(hw_stats->rx_aborts);
+	priv->stats.rx_aborts_phy = le32_to_cpu(hw_stats->rx_aborts_phy);
+	priv->stats.rx_rts_success = le32_to_cpu(hw_stats->rx_rts_success);
+	priv->stats.rx_rts_failed = le32_to_cpu(hw_stats->rx_rts_failed);
+	priv->stats.noise_floor = p54_rssi_to_dbm(hw_stats->noise_floor);
+	priv->stats.tsf = le32_to_cpu(hw_stats->tsf);
+}
+
 static void p54_rx_control(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
@@ -453,6 +496,9 @@ static void p54_rx_control(struct ieee80
 	case P54_CONTROL_TYPE_TXDONE:
 		p54_rx_frame_sent(dev, skb);
 		break;
+	case P54_CONTROL_TYPE_STAT_READBACK:
+		p54_rx_stats(dev, skb);
+		break;
 	case P54_CONTROL_TYPE_BBP:
 		break;
 	default:
@@ -469,8 +515,7 @@ int p54_rx(struct ieee80211_hw *dev, str
 	switch (type) {
 	case 0x00:
 	case 0x01:
-		p54_rx_data(dev, skb);
-		return -1;
+		return p54_rx_data(dev, skb);
 	case 0x4d:
 		/* TODO: do something better... but then again, I've never seen this happen */
 		printk(KERN_ERR "%s: Received fault. Probably need to restart hardware now..\n",
@@ -552,6 +597,67 @@ static void p54_assign_address(struct ie
 	data->req_id = cpu_to_le32(target_addr + 0x70);
 }
 
+#ifndef WLAN_FC_GET_TYPE
+#define WLAN_FC_GET_TYPE(fc) (fc & IEEE80211_FCTL_FTYPE)
+#define WLAN_FC_GET_STYPE(fc) (fc & IEEE80211_FCTL_STYPE)
+#endif
+
+static int p54_tx_fill_header(struct ieee80211_hw *dev, struct ieee80211_hdr *hdr,
+	struct ieee80211_tx_control *control, u8 *retry1, u8 *retry2,
+	u8 *frame_type, u16 *magic, u16 *aid)
+{
+	struct p54_common *priv = dev->priv;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+
+	if (!(control->flags & (IEEE80211_TXCTL_USE_RTS_CTS |
+	   IEEE80211_TXCTL_USE_CTS_PROTECT)))
+		*magic = 0x10;
+	else	
+		*magic = 0;
+	
+	*retry1 = *retry2 = control->retry_limit;
+
+	if ((control->flags & IEEE80211_TXCTL_NO_ACK))
+		*aid = 0;
+	else {
+		if (control->aid) 
+			*aid = control->aid + 1;
+		else
+			*aid = 1;
+	}
+
+	/* TODO: enable powersaving package queueing in AP-Mode */
+	if (priv->mode == IEEE80211_IF_TYPE_AP)
+		*magic |= 0x20;
+
+	if (unlikely(WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT))
+		switch (WLAN_FC_GET_STYPE(fc)) {
+		case IEEE80211_STYPE_PROBE_REQ:
+			*aid = 0;
+			*magic |= 0x20;
+			*frame_type = 1;
+			return 0;
+		case IEEE80211_STYPE_BEACON:
+			*aid = 0;
+			*retry2 = *retry1 = 1;
+			*frame_type = 0;
+			*magic = 0x02; /* tell the FW to fill in the TSF */
+			return 0;
+		case IEEE80211_STYPE_PROBE_RESP:
+			*magic |= 0x02;
+			*aid = 0;
+			*frame_type = 2;
+			return 0;
+		default:
+			*frame_type = 2;
+			return 0;
+		}	
+	else
+		*frame_type = control->queue + 4;
+
+	return 1;
+}
+
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control)
 {
@@ -560,16 +666,26 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_allocdata *txhdr;
 	struct ieee80211_tx_control *control_copy;
+	struct ieee80211_hdr *ieeehdr = (struct ieee80211_hdr *)skb->data;
 	size_t padding, len;
-	u8 rate;
+	u16 aid, magic;
+	u8 rate, retry1, retry2, frame_type;
 
-	current_queue = &priv->tx_stats.data[control->queue];
-	if (unlikely(current_queue->len > current_queue->limit))
-		return NETDEV_TX_BUSY;
-	current_queue->len++;
-	current_queue->count++;
-	if (current_queue->len == current_queue->limit)
-		ieee80211_stop_queue(dev, control->queue);
+	if (p54_tx_fill_header(dev, ieeehdr, control, &retry1, &retry2, 
+			       &frame_type, &magic, &aid)) {
+
+		current_queue = &priv->tx_stats[frame_type];
+		if (unlikely(current_queue->len > current_queue->limit))
+			return NETDEV_TX_BUSY;
+		current_queue->len++;
+		current_queue->count++;
+		if (current_queue->len == current_queue->limit)
+			ieee80211_stop_queue(dev, control->queue);
+	} else {
+		current_queue = &priv->tx_stats[frame_type];
+		current_queue->len++;
+		current_queue->count++;
+	}
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
@@ -583,36 +699,38 @@ static int p54_tx(struct ieee80211_hw *d
 	hdr = (struct p54_control_hdr *) skb_push(skb, sizeof(*hdr));
 
 	if (padding)
-		hdr->magic1 = cpu_to_le16(0x4010);
-	else
-		hdr->magic1 = cpu_to_le16(0x0010);
+		magic |= 0x4000;
+	
+	hdr->magic1 = cpu_to_le16(magic);
 	hdr->len = cpu_to_le16(len);
-	hdr->type = (control->flags & IEEE80211_TXCTL_NO_ACK) ? 0 : cpu_to_le16(1);
-	hdr->retry1 = hdr->retry2 = control->retry_limit;
+	hdr->type = cpu_to_le16(aid);
+	hdr->retry1 = retry1;
+	hdr->retry2 = retry2;
 	p54_assign_address(dev, skb, hdr, skb->len, control_copy);
 
-	memset(txhdr->wep_key, 0x0, 16);
-	txhdr->padding = 0;
-	txhdr->padding2 = 0;
-
 	/* TODO: add support for alternate retry TX rates */
 	rate = control->tx_rate->hw_value;
 	if (control->flags & IEEE80211_TXCTL_SHORT_PREAMBLE)
 		rate |= 0x10;
-	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
+	else if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
 		rate |= 0x40;
 	else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		rate |= 0x20;
 	memset(txhdr->rateset, rate, 8);
-	txhdr->wep_key_present = 0;
-	txhdr->wep_key_len = 0;
-	txhdr->frame_type = cpu_to_le32(control->queue + 4);
-	txhdr->magic4 = 0;
+	txhdr->key_type = 0;
+	txhdr->key_len = 0;
+	txhdr->frame_type = frame_type;
 	txhdr->antenna = (control->antenna_sel_tx == 0) ?
 		2 : control->antenna_sel_tx - 1;
-	txhdr->output_power = 0x7f; // HW Maximum
-	txhdr->magic5 = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
-		0 : ((rate > 0x3) ? cpu_to_le32(0x33) : cpu_to_le32(0x23));
+	txhdr->output_power = 0x7f; /* 0.25 dbm / unit */
+	if (control->rts_cts_rate)
+		txhdr->cts_rate = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
+			0 : (control->rts_cts_rate->hw_value | 0x20 |
+			    (rate & 0x10));
+	else
+		txhdr->cts_rate = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
+			0 : (0x23 | (rate & 0x10));
+
 	if (padding)
 		txhdr->align[0] = padding;
 
@@ -620,9 +738,36 @@ static int p54_tx(struct ieee80211_hw *d
 	return 0;
 }
 
-static int p54_set_filter(struct ieee80211_hw *dev, u16 filter_type,
-			  const u8 *dst, const u8 *src, u8 antenna,
-			  u32 magic3, u32 magic8, u32 magic9)
+int __p54_set_tim(struct ieee80211_hw *dev, u16 aid, int set)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr;
+	struct p54_tx_control_tim *tim;
+
+	hdr = kzalloc(sizeof(*hdr) + sizeof(*tim) +
+		      priv->tx_hdr_len, GFP_ATOMIC);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr = (void *)hdr + priv->tx_hdr_len;
+	hdr->magic1 = cpu_to_le16(0x8001);
+	hdr->len = cpu_to_le16(sizeof(*tim));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_TIM);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*tim), NULL);
+
+	tim = (struct p54_tx_control_tim *) hdr->data;
+	tim->count = 1;	/* just one entry */
+	tim->entry[0] = set ? cpu_to_le16(aid | 0x8000) : cpu_to_le16(aid);
+
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*tim), 1);
+
+	return 0;
+}
+
+const static unsigned char p54_client_rts_rates[8] = { 8, 6, 4, 1, 0, 0, 0, 0 };
+const static unsigned char p54_ap_rts_rates[8] = { 3, 3, 1, 0, 0, 0, 0, 0 };
+
+static int p54_set_filter(struct ieee80211_hw *dev, u8 filter_type)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
@@ -641,24 +786,68 @@ static int p54_set_filter(struct ieee802
 	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*filter), NULL);
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_FILTER_SET);
 
-	filter->filter_type = cpu_to_le16(filter_type);
-	memcpy(filter->dst, dst, ETH_ALEN);
-	if (!src)
-		memset(filter->src, ~0, ETH_ALEN);
+	filter->filter_type = filter_type;
+	memcpy(filter->our_mac, priv->mac_addr, ETH_ALEN);
+
+	/* 0x15F is a bitrate mask
+	 * = 0000000101011111b
+	 * = 24MBits 12MBits 6MBit 11MBit 5.5MBits 2MBits 1Mbit */
+	filter->bss_basic_rates = cpu_to_le32(0x15F);
+	memset(filter->bss_filter_mac, ~0, ETH_ALEN);
+
+	if (filter_type == P54_FILTER_TYPE_AP)
+		memcpy(filter->rts_rates, p54_ap_rts_rates, 8);
 	else
-		memcpy(filter->src, src, ETH_ALEN);
-	filter->antenna = antenna;
-	filter->magic3 = cpu_to_le32(magic3);
+		memcpy(filter->rts_rates, p54_client_rts_rates, 8);
+
+	filter->rx_antenna = (dev->conf.antenna_sel_rx == 0) ? 2 :
+		dev->conf.antenna_sel_rx - 1;
 	filter->rx_addr = cpu_to_le32(priv->rx_end);
 	filter->max_rx = cpu_to_le16(0x0620);	/* FIXME: for usb ver 1.. maybe */
 	filter->rxhw = priv->rxhw;
-	filter->magic8 = cpu_to_le16(magic8);
-	filter->magic9 = cpu_to_le16(magic9);
+
+	/* that's beacon_int * dtim_period * 5, unless
+	 * there's a way to get these values here, let's
+	 * use the standard ones */
+	filter->dtim_timer = cpu_to_le16(dev->conf.beacon_int * 1 * 5);
 
 	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*filter), 1);
 	return 0;
 }
 
+static int p54_init_misc(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr;
+	struct p54_tx_control_misc *misc;
+
+	hdr = kzalloc(sizeof(*hdr) + sizeof(*misc) +
+		      priv->tx_hdr_len, GFP_KERNEL);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr = (void *)hdr + priv->tx_hdr_len;
+	hdr->magic1 = cpu_to_le16(0x8001);
+	hdr->len = cpu_to_le16(sizeof(*misc));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_MISCINIT);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*misc), NULL);
+
+	misc = (struct p54_tx_control_misc *) hdr->data;
+
+	misc->flags = cpu_to_le16(0);
+	misc->entry[1] = cpu_to_le16(1000);
+	misc->entry[3] = cpu_to_le16(1000);
+	misc->entry[5] = cpu_to_le16(1000);
+	misc->entry[7] = cpu_to_le16(1000);
+
+	misc->flag2 = cpu_to_le16(1);
+	misc->flag3 = misc->data = 0;
+
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*misc), 1);
+
+	return 0;
+}
+
 static int p54_set_freq(struct ieee80211_hw *dev, __le16 freq)
 {
 	struct p54_common *priv = dev->priv;
@@ -811,8 +1000,8 @@ static void p54_set_vdcf(struct ieee8021
 
 	if (dev->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
 		vdcf->slottime = 9;
-		vdcf->magic1 = 0x00;
-		vdcf->magic2 = 0x10;
+		vdcf->magic1 = 0x10;
+		vdcf->magic2 = 0x00;
 	} else {
 		vdcf->slottime = 20;
 		vdcf->magic1 = 0x0a;
@@ -861,6 +1050,8 @@ static int p54_add_interface(struct ieee
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_AP:
+	case IEEE80211_IF_TYPE_IBSS:
 		priv->mode = conf->type;
 		break;
 	default:
@@ -869,20 +1060,29 @@ static int p54_add_interface(struct ieee
 
 	memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 
-	p54_set_filter(dev, 0, priv->mac_addr, NULL, 0, 1, 0, 0xF642);
-	p54_set_filter(dev, 0, priv->mac_addr, NULL, 1, 0, 0, 0xF642);
+	p54_set_filter(dev, P54_FILTER_TYPE_NONE);
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
-		p54_set_filter(dev, 1, priv->mac_addr, NULL, 0, 0x15F, 0x1F4, 0);
+		priv->filter_type = P54_FILTER_TYPE_STA;
+		break;
+	case IEEE80211_IF_TYPE_AP:
+		priv->filter_type = P54_FILTER_TYPE_AP;
+		break;
+	case IEEE80211_IF_TYPE_IBSS:
+		priv->filter_type = P54_FILTER_TYPE_ADHOC;
 		break;
 	default:
 		BUG();	/* impossible */
 		break;
 	}
 
+	p54_init_misc(dev);
 	p54_set_leds(dev, 1, 0, 0);
 
+	/* start statistics readback timer */
+	mod_timer(&priv->stats.timer, jiffies + HZ);
+
 	return 0;
 }
 
@@ -890,9 +1090,15 @@ static void p54_remove_interface(struct 
 				 struct ieee80211_if_init_conf *conf)
 {
 	struct p54_common *priv = dev->priv;
+
+	del_timer(&priv->stats.timer);
+	if (priv->mode == P54_FILTER_TYPE_AP)
+		__p54_set_tim(dev, 0, 0);
+
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->filter_type = P54_FILTER_TYPE_NONE;
 	memset(priv->mac_addr, 0, ETH_ALEN);
-	p54_set_filter(dev, 0, priv->mac_addr, NULL, 2, 0, 0, 0);
+	p54_set_filter(dev, P54_FILTER_TYPE_NONE);
 }
 
 static int p54_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
@@ -904,16 +1110,90 @@ static int p54_config(struct ieee80211_h
 	return ret;
 }
 
+static void p54_beacon_tim(struct sk_buff *skb)
+{
+	/*
+	 * the TIM MUST be at the end of the beacon frame,
+	 * because it'll be overwritten!
+	 */
+
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 *pos, *end;
+
+	if (skb->len <= sizeof(mgmt))
+		return ;
+
+	pos = (u8 *)mgmt->u.beacon.variable;
+	end = skb->data + skb->len;
+	while (pos < end) {
+		if (pos + 2 + pos[1] > end) {
+			printk(KERN_ERR "p54: parsing beacon failed\n");
+			return;
+		}
+
+		if (pos[0] == WLAN_EID_TIM) {
+			u8 dtim_len = pos[1];
+			u8 dtim_period;
+			u8 *next = pos + 2 + dtim_len;
+
+			/* mac80211 sets it atleast to 4... */
+			if (dtim_len < 3)
+				return ;
+
+			dtim_period = pos[3];
+			memmove(pos, next, end - next);
+		        skb_trim(skb, skb->len - (dtim_len - 3));
+			pos = end - (dtim_len + 2);
+
+			/* add a dummy at the end */
+			pos[0] = WLAN_EID_TIM;
+			pos[1] = 3;
+			pos[2] = 0;
+			pos[3] = dtim_period;
+			pos[4] = 0;
+			return ;
+		}
+		pos += 2 + pos[1];
+	}
+}
+
+static int p54_beacon_update(struct ieee80211_hw *dev,
+			     struct sk_buff *skb,
+			     struct ieee80211_tx_control *control)
+{
+	struct p54_common *priv = dev->priv;
+
+	p54_set_freq(dev, dev->conf.channel->center_freq);
+	p54_set_filter(dev, priv->filter_type);
+	p54_beacon_tim(skb);
+	p54_tx(dev, skb, control);
+	p54_set_vdcf(dev);
+	p54_set_leds(dev, 1, 1, 0);
+
+	return 0;
+}
+
 static int p54_config_interface(struct ieee80211_hw *dev,
 				struct ieee80211_vif *vif,
 				struct ieee80211_if_conf *conf)
 {
 	struct p54_common *priv = dev->priv;
 
-	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 0, 1, 0, 0xF642);
-	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 2, 0, 0, 0);
-	p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
-	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+	switch (conf->type) {
+	case IEEE80211_IF_TYPE_STA:
+		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+		p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
+		break;
+	case IEEE80211_IF_TYPE_AP:
+		if (conf->beacon && conf->beacon_control)
+			return p54_beacon_update(dev, conf->beacon,
+						 conf->beacon_control);
+		__p54_set_tim(dev, 0, 0);
+		break;
+	}
+
+	p54_set_filter(dev, priv->filter_type);
+
 	return 0;
 }
 
@@ -923,16 +1203,34 @@ static void p54_configure_filter(struct 
 				 int mc_count, struct dev_mc_list *mclist)
 {
 	struct p54_common *priv = dev->priv;
+	unsigned flags = FIF_BCN_PRBRESP_PROMISC | FIF_PROMISC_IN_BSS;
+
+	if (priv->filter_type & P54_FILTER_TYPE_PROMISC)
+		flags |= FIF_FCSFAIL;
 
-	*total_flags &= FIF_BCN_PRBRESP_PROMISC;
+	*total_flags &= flags;
 
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			p54_set_filter(dev, 0, priv->mac_addr,
-				       NULL, 2, 0, 0, 0);
+			p54_set_filter(dev, P54_FILTER_TYPE_NONE);
+		else
+			p54_set_filter(dev, priv->filter_type);
+	}
+
+	if (changed_flags & FIF_PROMISC_IN_BSS) {
+		if (*total_flags & FIF_PROMISC_IN_BSS)
+			priv->filter_type |= P54_FILTER_TYPE_PROMISC;
+		else
+			priv->filter_type &= ~P54_FILTER_TYPE_PROMISC;
+
+		p54_set_filter(dev, priv->filter_type);
+	}
+
+	if (changed_flags & FIF_FCSFAIL) {
+		if (*total_flags & FIF_FCSFAIL)
+			priv->rx_filter |= P54_RX_FILTER_FCSFAIL;
 		else
-			p54_set_filter(dev, 0, priv->mac_addr,
-				       priv->bssid, 2, 0, 0, 0);
+			priv->rx_filter &= ~P54_RX_FILTER_FCSFAIL;
 	}
 }
 
@@ -956,10 +1254,38 @@ static int p54_conf_tx(struct ieee80211_
 	return 0;
 }
 
+static void p54_stats_timer(unsigned long data)
+{
+	struct ieee80211_hw *dev = (struct ieee80211_hw *)data;
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr;
+	struct p54_statistics *stat;
+
+	hdr = (void *)priv->stats.cached_stats + priv->tx_hdr_len;
+	hdr->magic1 = cpu_to_le16(0x8000);
+	hdr->len = cpu_to_le16(sizeof(*stat));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_STAT_READBACK);
+	hdr->retry1 = hdr->retry2 = 0;
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*stat), NULL);
+
+	stat = (struct p54_statistics *)hdr->data;
+	memset(stat, 0x0, sizeof(*stat));
+
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*stat), 0);
+
+	/* get stats every 5 seconds */
+	mod_timer(&priv->stats.timer, jiffies + 5*HZ);
+}
+
 static int p54_get_stats(struct ieee80211_hw *dev,
 			 struct ieee80211_low_level_stats *stats)
 {
-	/* TODO */
+	struct p54_common *priv = dev->priv;
+
+	stats->dot11RTSFailureCount = priv->stats.rx_rts_failed;
+	stats->dot11RTSSuccessCount = priv->stats.rx_rts_success;
+	stats->dot11FCSErrorCount = priv->stats.rx_errors;
+
 	return 0;
 }
 
@@ -967,11 +1293,19 @@ static int p54_get_tx_stats(struct ieee8
 			    struct ieee80211_tx_queue_stats *stats)
 {
 	struct p54_common *priv = dev->priv;
-	unsigned int i;
 
-	for (i = 0; i < dev->queues; i++)
-		memcpy(&stats->data[i], &priv->tx_stats.data[i],
-			sizeof(stats->data[i]));
+	memcpy(&stats->data, &priv->tx_stats[4],
+			sizeof(stats->data[0]) * dev->queues);
+
+	return 0;
+}
+
+
+int p54_set_tim(struct ieee80211_hw *dev, int aid, int set)
+{
+	/* AID 1 is reserved */
+
+	__p54_set_tim(dev, (u16)aid + 1, set);
 
 	return 0;
 }
@@ -986,6 +1320,8 @@ static const struct ieee80211_ops p54_op
 	.config_interface	= p54_config_interface,
 	.configure_filter	= p54_configure_filter,
 	.conf_tx		= p54_conf_tx,
+	.set_tim		= p54_set_tim,
+	.beacon_update		= p54_beacon_update,
 	.get_stats		= p54_get_stats,
 	.get_tx_stats		= p54_get_tx_stats
 };
@@ -1003,25 +1339,41 @@ struct ieee80211_hw *p54_init_common(siz
 	priv->mode = IEEE80211_IF_TYPE_INVALID;
 	skb_queue_head_init(&priv->tx_queue);
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
-	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
-		    IEEE80211_HW_RX_INCLUDES_FCS;
-	dev->channel_change_time = 1000;	/* TODO: find actual value */
-	dev->max_rssi = 127;
-
-	priv->tx_stats.data[0].limit = 5;
+	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+		     IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
+		     IEEE80211_HW_RX_INCLUDES_FCS;
+
+	dev->channel_change_time = 5000;
+	priv->stats.noise_floor = -93;
+	dev->max_signal = 64;
+	dev->max_rssi = -36;
+	dev->max_noise = -36;
+
+	priv->tx_stats[0].limit = 1; /* beacon queue */
+	priv->tx_stats[1].limit = 1; /* broadcasts / probes (passive scan)*/
+	priv->tx_stats[2].limit = 1; /* management frame queue */
+	priv->tx_stats[3].limit = 1; /* used to be the data queue */
+	priv->tx_stats[4].limit = 5; /* data queue */
+	priv->filter_type = P54_FILTER_TYPE_NONE;
+	priv->rx_filter = P54_RX_FILTER_NOTHING;
 	dev->queues = 1;
 
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
 				 sizeof(struct p54_tx_control_allocdata);
 
         priv->cached_vdcf = kzalloc(sizeof(struct p54_tx_control_vdcf) +
-              priv->tx_hdr_len + sizeof(struct p54_control_hdr), GFP_KERNEL);
-
-	if (!priv->cached_vdcf) {
+		priv->tx_hdr_len + sizeof(struct p54_control_hdr), GFP_KERNEL);
+	priv->stats.cached_stats = kzalloc(sizeof(struct p54_statistics) +
+		priv->tx_hdr_len + sizeof(struct p54_control_hdr), GFP_KERNEL);
+
+	if (!priv->cached_vdcf || !priv->stats.cached_stats) {
+		kfree(priv->cached_vdcf);
+		kfree(priv->stats.cached_stats);
 		ieee80211_free_hw(dev);
 		return NULL;
 	}
 
+	setup_timer(&priv->stats.timer, p54_stats_timer, (unsigned long)dev);
 	p54_init_vdcf(dev);
 
 	return dev;
@@ -1035,6 +1387,7 @@ void p54_free_common(struct ieee80211_hw
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
 	kfree(priv->cached_vdcf);
+	kfree(priv->stats.cached_stats);
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
 
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-03-29 16:05:32.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-04-08 14:10:37.000000000 +0200
@@ -1,11 +1,11 @@
-#ifndef PRISM54COMMON_H
-#define PRISM54COMMON_H
+#ifndef P54COMMON_H
+#define P54COMMON_H
 
 /*
  * Common code specific definitions for mac80211 Prism54 drivers
  *
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
- * Copyright (c) 2007, Christian Lamparter <chunkeey@web.de>
+ * Copyright (c) 2007, 2008, Christian Lamparter <chunkeey@web.de>
  *
  * Based on the islsm (softmac prism54) driver, which is:
  * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
@@ -89,14 +89,14 @@ struct pda_pa_curve_data_sample_rev1 {
 	u8 data_qpsk;
 	u8 data_16qam;
 	u8 data_64qam;
-	u8 padding;
+	u8 :8;
 } __attribute__ ((packed));
 
 struct pda_pa_curve_data {
 	u8 cal_method_rev;
 	u8 channels;
 	u8 points_per_channel;
-	u8 padding;
+	u8 :8;
 	u8 data[0];
 } __attribute__ ((packed));
 
@@ -161,6 +161,14 @@ struct p54_eeprom_lm86 {
 	u8 data[0];
 } __attribute__ ((packed));
 
+enum {
+	P54_KEY_TYPE_NONE = 0,
+	P54_KEY_TYPE_WEP,
+	P54_KEY_TYPE_EAPOL,
+	P54_KEY_TYPE_TKIP,
+	P54_KEY_TYPE_CCX = 6
+};
+
 struct p54_rx_hdr {
 	__le16 magic;
 	__le16 len;
@@ -169,7 +177,8 @@ struct p54_rx_hdr {
 	u8 rate;
 	u8 rssi;
 	u8 quality;
-	u16 unknown2;
+	u8 key_type;
+	u8 channel_activity;
 	__le64 timestamp;
 	u8 data[0];
 } __attribute__ ((packed));
@@ -182,34 +191,49 @@ struct p54_frame_sent_hdr {
 	u16 rate;
 } __attribute__ ((packed));
 
+#define P54_FILTER_TYPE_NONE 	0
+#define P54_FILTER_TYPE_STA	BIT(0)
+#define P54_FILTER_TYPE_ADHOC	BIT(1)
+#define P54_FILTER_TYPE_AP 	BIT(2)
+#define P54_FILTER_TYPE_PROMISC BIT(3)
+#define P54_FILTER_TYPE_MONITOR BIT(4)
+#define P54_FILTER_TYPE_SLEEP 	BIT(5)
+
+#define P54_RX_FILTER_NOTHING	0
+#define P54_RX_FILTER_FCSFAIL 	BIT(0)
+#define P54_RX_FILTER_OTHER_BSS	BIT(1)
+
 struct p54_tx_control_allocdata {
 	u8 rateset[8];
-	u16 padding;
-	u8 wep_key_present;
-	u8 wep_key_len;
-	u8 wep_key[16];
-	__le32 frame_type;
-	u32 padding2;
-	__le16 magic4;
+	u16 :16;
+	u8 key_type;
+	u8 key_len;
+	u8 key[16];
+	u8 frame_type;
+	u32 :24;
+	u32 :32;
+	u16 :16;
 	u8 antenna;
 	u8 output_power;
-	__le32 magic5;
+	u8 cts_rate;
+	u32 :24;
 	u8 align[0];
 } __attribute__ ((packed));
 
 struct p54_tx_control_filter {
-	__le16 filter_type;
-	u8 dst[ETH_ALEN];
-	u8 src[ETH_ALEN];
-	u8 antenna;
-	u8 debug;
-	__le32 magic3;
-	u8 rates[8];	// FIXME: what's this for?
+	u8 filter_type;
+	u8 :8;
+	u8 our_mac[ETH_ALEN];
+	u8 bss_filter_mac[ETH_ALEN];
+	u8 rx_antenna;
+	u8 rx_align;
+	__le32 bss_basic_rates;
+	u8 rts_rates[8];
 	__le32 rx_addr;
 	__le16 max_rx;
 	__le16 rxhw;
-	__le16 magic8;
-	__le16 magic9;
+	__le16 dtim_timer;
+	u16 :16;
 } __attribute__ ((packed));
 
 struct p54_tx_control_channel {
@@ -242,13 +266,44 @@ struct p54_tx_vdcf_queues {
 } __attribute__ ((packed));
 
 struct p54_tx_control_vdcf {
-	u8 padding;
+	u8 :8;
 	u8 slottime;
 	u8 magic1;
 	u8 magic2;
 	struct p54_tx_vdcf_queues queue[8];
-	u8 pad2[4];
+	u8 offset1;
+	u8 offset2;
+	u16 :16;
 	__le16 frameburst;
 } __attribute__ ((packed));
 
-#endif /* PRISM54COMMON_H */
+struct p54_statistics {
+	__le32 rx_success;
+	__le32 rx_errors;
+	__le32 rx_aborts;
+	__le32 rx_aborts_phy;
+	__le32 rx_rts_success;
+	__le32 rx_rts_failed;
+	__le32 tsf;
+	__le32 unknown_stat;	/* total air/duration time ?!*/
+	u8 noise_floor;
+	u32 :24;
+	u8 unknown[40];		/* CCA / CCQ / RADAR data */
+} __attribute__ ((packed));
+
+struct p54_tx_control_tim {
+	u8 count;
+	u32 :24;
+	__le16 entry[8];
+} __attribute__ ((packed));
+
+struct p54_tx_control_misc {
+	__le16 flags;
+	__le16 entry[8];
+	u16 :16;
+	__le16 flag2;
+	u8 flag3;
+	u8 data;
+} __attribute__ ((packed));
+
+#endif /* P54COMMON_H */
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-03-29 16:05:32.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2008-04-08 14:11:30.000000000 +0200
@@ -1,10 +1,11 @@
-#ifndef PRISM54_H
-#define PRISM54_H
+#ifndef P54_H
+#define P54_H
 
 /*
  * Shared defines for all mac80211 Prism54 code
  *
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
+ * Copyright (c) 2008, Christian Lamparter <chunkeey@web.de>
  *
  * Based on the islsm (softmac prism54) driver, which is:
  * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
@@ -14,18 +15,32 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/timer.h>
+
 enum control_frame_types {
 	P54_CONTROL_TYPE_FILTER_SET = 0,
 	P54_CONTROL_TYPE_CHANNEL_CHANGE,
 	P54_CONTROL_TYPE_FREQDONE,
 	P54_CONTROL_TYPE_DCFINIT,
-	P54_CONTROL_TYPE_FREEQUEUE = 7,
+	P54_CONTROL_TYPE_CRYPTO,
+	P54_CONTROL_TYPE_TIM,
+	P54_CONTROL_TYPE_MISCINIT,
+	P54_CONTROL_TYPE_FREEQUEUE,
 	P54_CONTROL_TYPE_TXDONE,
 	P54_CONTROL_TYPE_PING,
 	P54_CONTROL_TYPE_STAT_READBACK,
 	P54_CONTROL_TYPE_BBP,
 	P54_CONTROL_TYPE_EEPROM_READBACK,
-	P54_CONTROL_TYPE_LED
+	P54_CONTROL_TYPE_LED,
+	P54_CONTROL_TYPE_GPIO,
+	P54_CONTROL_TYPE_TIMERS,
+	P54_CONTROL_TYPE_MODULATION,
+	P54_CONTROL_TYPE_SYNTH_CONFIG,
+	P54_CONTROL_TYPE_DETECTOR_VALUE,
+	P54_CONTROL_TYPE_5GHZ_SYNTH,
+	P54_CONTROL_TYPE_CCE_QUIET,
+	P54_CONTROL_TYPE_STA_UNLOCK,
+	P54_CONTROL_TYPE_PCS
 };
 
 struct p54_control_hdr {
@@ -38,6 +53,19 @@ struct p54_control_hdr {
 	u8 data[0];
 } __attribute__ ((packed));
 
+struct p54_stats {
+	void *cached_stats;
+	struct timer_list timer;
+	u32 rx_success;
+	u32 rx_errors;
+	u32 rx_aborts;
+	u32 rx_aborts_phy;
+	u32 rx_rts_success;
+	u32 rx_rts_failed;
+	u32 tsf;
+	int noise_floor;
+};
+
 #define EEPROM_READBACK_LEN (sizeof(struct p54_control_hdr) + 4 /* p54_eeprom_lm86 */)
 #define MAX_RX_SIZE (IEEE80211_MAX_RTS_THRESHOLD + sizeof(struct p54_control_hdr) + 20 /* length of struct p54_rx_hdr */ + 16 )
 
@@ -60,11 +88,14 @@ struct p54_common {
 	unsigned int output_limit_len;
 	struct pda_pa_curve_data *curve_data;
 	__le16 rxhw;
+	u8 filter_type;
 	u8 version;
+	unsigned int rx_filter;
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
 	unsigned int fw_var;
-	struct ieee80211_tx_queue_stats tx_stats;
+	struct p54_stats stats;
+	struct ieee80211_tx_queue_stats_data tx_stats[8];
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
@@ -74,4 +105,4 @@ void p54_fill_eeprom_readback(struct p54
 struct ieee80211_hw *p54_init_common(size_t priv_data_len);
 void p54_free_common(struct ieee80211_hw *dev);
 
-#endif /* PRISM54_H */
+#endif /* P54_H */
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-03-29 16:05:32.000000000 +0100
+++ b/drivers/net/wireless/p54/p54pci.c	2008-04-08 14:17:40.000000000 +0200
@@ -3,6 +3,7 @@
  * Linux device driver for PCI based Prism54
  *
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
+ * Copyright (c) 2008, Christian Lamparter <chunkeey@web.de>
  *
  * Based on the islsm (softmac prism54) driver, which is:
  * Copyright 2004-2006 Jean-Baptiste Note <jean-baptiste.note@m4x.org>, et al.
@@ -24,9 +25,9 @@
 #include "p54pci.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
-MODULE_DESCRIPTION("Prism54 PCI wireless driver");
+MODULE_DESCRIPTION("softmac Prism54 PCI wireless driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("prism54pci");
+MODULE_ALIAS("p54pci");
 
 static struct pci_device_id p54p_table[] __devinitdata = {
 	/* Intersil PRISM Duette/Prism GT Wireless LAN adapter */
@@ -75,7 +76,7 @@ static int p54p_upload_firmware(struct i
 
 	err = request_firmware(&fw_entry, "isl3886", &priv->pdev->dev);
 	if (err) {
-		printk(KERN_ERR "%s (prism54pci): cannot find firmware "
+		printk(KERN_ERR "%s (p54pci): cannot find firmware "
 		       "(isl3886)\n", pci_name(priv->pdev));
 		return err;
 	}
@@ -150,16 +151,16 @@ static int p54p_read_eeprom(struct ieee8
 
 	init_completion(&priv->boot_comp);
 	err = request_irq(priv->pdev->irq, &p54p_simple_interrupt,
-			  IRQF_SHARED, "prism54pci", priv);
+			  IRQF_SHARED, "p54pci", priv);
 	if (err) {
-		printk(KERN_ERR "%s (prism54pci): failed to register IRQ handler\n",
+		printk(KERN_ERR "%s (p54pci): failed to register IRQ handler\n",
 		       pci_name(priv->pdev));
 		return err;
 	}
 
 	eeprom = kmalloc(0x2010 + EEPROM_READBACK_LEN, GFP_KERNEL);
 	if (!eeprom) {
-		printk(KERN_ERR "%s (prism54pci): no memory for eeprom!\n",
+		printk(KERN_ERR "%s (p54pci): no memory for eeprom!\n",
 		       pci_name(priv->pdev));
 		err = -ENOMEM;
 		goto out;
@@ -177,7 +178,7 @@ static int p54p_read_eeprom(struct ieee8
 	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
 
 	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
-		printk(KERN_ERR "%s (prism54pci): Cannot boot firmware!\n",
+		printk(KERN_ERR "%s (p54pci): Cannot boot firmware!\n",
 		       pci_name(priv->pdev));
 		err = -EINVAL;
 		goto out;
@@ -219,7 +220,7 @@ static int p54p_read_eeprom(struct ieee8
 	alen = le16_to_cpu(ring_control->rx_mgmt[0].len);
 	if (le32_to_cpu(ring_control->device_idx[2]) != 1 ||
 	    alen < 0x10) {
-		printk(KERN_ERR "%s (prism54pci): Cannot read eeprom!\n",
+		printk(KERN_ERR "%s (p54pci): Cannot read eeprom!\n",
 		       pci_name(priv->pdev));
 		err = -EINVAL;
 		goto out;
@@ -237,20 +238,22 @@ static int p54p_read_eeprom(struct ieee8
 	return err;
 }
 
-static void p54p_refill_rx_ring(struct ieee80211_hw *dev)
+static void p54p_refill_rx_ring(struct ieee80211_hw *dev,
+	int ring_index, struct p54p_desc *ring, u32 ring_limit,
+	struct sk_buff **rx_buf)
 {
 	struct p54p_priv *priv = dev->priv;
 	struct p54p_ring_control *ring_control = priv->ring_control;
-	u32 limit, host_idx, idx;
+	u32 limit, idx, i;
 
-	host_idx = le32_to_cpu(ring_control->host_idx[0]);
-	limit = host_idx;
-	limit -= le32_to_cpu(ring_control->device_idx[0]);
-	limit = ARRAY_SIZE(ring_control->rx_data) - limit;
+	idx = le32_to_cpu(ring_control->host_idx[ring_index]);
+	limit = idx;
+	limit -= le32_to_cpu(ring_control->device_idx[ring_index]);
+	limit = ring_limit - limit;
 
-	idx = host_idx % ARRAY_SIZE(ring_control->rx_data);
+	i = idx % ring_limit;
 	while (limit-- > 1) {
-		struct p54p_desc *desc = &ring_control->rx_data[idx];
+		struct p54p_desc *desc = &ring[i];
 
 		if (!desc->host_addr) {
 			struct sk_buff *skb;
@@ -267,16 +270,111 @@ static void p54p_refill_rx_ring(struct i
 			desc->device_addr = 0;	// FIXME: necessary?
 			desc->len = cpu_to_le16(MAX_RX_SIZE);
 			desc->flags = 0;
-			priv->rx_buf[idx] = skb;
+			rx_buf[i] = skb;
 		}
 
+		i++;
 		idx++;
-		host_idx++;
-		idx %= ARRAY_SIZE(ring_control->rx_data);
+		i %= ring_limit;
 	}
 
 	wmb();
-	ring_control->host_idx[0] = cpu_to_le32(host_idx);
+	ring_control->host_idx[ring_index] = cpu_to_le32(idx);
+}
+
+static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
+	int ring_index, struct p54p_desc *ring, u32 ring_limit,
+	struct sk_buff **rx_buf)
+{
+	struct p54p_priv *priv = dev->priv;
+	struct p54p_ring_control *ring_control = priv->ring_control;
+	struct p54p_desc *desc;
+	u32 idx, i;
+
+	i = (*index) % ring_limit;
+	(*index) = idx = le32_to_cpu(ring_control->device_idx[ring_index]);
+	idx %= ring_limit;
+	while (i != idx) {
+		u16 len;
+		struct sk_buff *skb;
+		desc = &ring[i];
+		len = le16_to_cpu(desc->len);
+		skb = rx_buf[i];
+
+		skb_put(skb, len);
+
+		if (p54_rx(dev, skb)) {
+			pci_unmap_single(priv->pdev,
+					 le32_to_cpu(desc->host_addr),
+					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+			/* TODO: refill queue here */
+			rx_buf[i] = NULL;
+			desc->host_addr = 0;
+		} else {
+			skb_trim(skb, 0);
+			desc->len = cpu_to_le16(MAX_RX_SIZE);
+		}
+
+		i++;
+		i %= ring_limit;
+	}
+
+	p54p_refill_rx_ring(dev, ring_index, ring, ring_limit, rx_buf);
+}
+
+/* caller must hold priv->tx_lock */
+static void p54p_check_tx_ring(struct ieee80211_hw *dev, u32 *index,
+	int ring_index, struct p54p_desc *ring, u32 ring_limit,
+	void **tx_buf)
+{
+	struct p54p_priv *priv = dev->priv;
+	struct p54p_ring_control *ring_control = priv->ring_control;
+	struct p54p_desc *desc;
+	u32 idx, i;
+
+	i = (*index) % ring_limit;
+	(*index) = idx = le32_to_cpu(ring_control->device_idx[1]);
+	idx %= ring_limit;
+
+	while (i != idx) {
+		desc = &ring[i];
+		if (tx_buf[i]) {
+			kfree(tx_buf[i]);
+			tx_buf[i] = NULL;
+		}
+
+		pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
+				 le16_to_cpu(desc->len), PCI_DMA_TODEVICE);
+
+		desc->host_addr = 0;
+		desc->device_addr = 0;
+		desc->len = 0;
+		desc->flags = 0;
+
+		i++;
+		i %= ring_limit;
+	}
+}
+
+static void p54p_rx_tasklet(unsigned long dev_id)
+{
+	struct ieee80211_hw *dev = (struct ieee80211_hw *)dev_id;
+	struct p54p_priv *priv = dev->priv;
+	struct p54p_ring_control *ring_control = priv->ring_control;
+
+	spin_lock(&priv->rx_lock);
+
+	p54p_check_rx_ring(dev, &priv->rx_idx_mgmt, 2, ring_control->rx_mgmt,
+		ARRAY_SIZE(ring_control->rx_mgmt), priv->rx_buf_mgmt);
+
+	p54p_check_rx_ring(dev, &priv->rx_idx_data, 0, ring_control->rx_data,
+		ARRAY_SIZE(ring_control->rx_data), priv->rx_buf_data);
+
+	spin_unlock(&priv->rx_lock);
+
+	wmb();
+	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
+
 }
 
 static irqreturn_t p54p_interrupt(int irq, void *dev_id)
@@ -286,10 +384,10 @@ static irqreturn_t p54p_interrupt(int ir
 	struct p54p_ring_control *ring_control = priv->ring_control;
 	__le32 reg;
 
-	spin_lock(&priv->lock);
+	spin_lock(&priv->tx_lock);
 	reg = P54P_READ(int_ident);
 	if (unlikely(reg == cpu_to_le32(0xFFFFFFFF))) {
-		spin_unlock(&priv->lock);
+		spin_unlock(&priv->tx_lock);
 		return IRQ_HANDLED;
 	}
 
@@ -298,69 +396,22 @@ static irqreturn_t p54p_interrupt(int ir
 	reg &= P54P_READ(int_enable);
 
 	if (reg & cpu_to_le32(ISL38XX_INT_IDENT_UPDATE)) {
-		struct p54p_desc *desc;
-		u32 idx, i;
-		i = priv->tx_idx;
-		i %= ARRAY_SIZE(ring_control->tx_data);
-		priv->tx_idx = idx = le32_to_cpu(ring_control->device_idx[1]);
-		idx %= ARRAY_SIZE(ring_control->tx_data);
-
-		while (i != idx) {
-			desc = &ring_control->tx_data[i];
-			if (priv->tx_buf[i]) {
-				kfree(priv->tx_buf[i]);
-				priv->tx_buf[i] = NULL;
-			}
-
-			pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
-					 le16_to_cpu(desc->len), PCI_DMA_TODEVICE);
-
-			desc->host_addr = 0;
-			desc->device_addr = 0;
-			desc->len = 0;
-			desc->flags = 0;
-
-			i++;
-			i %= ARRAY_SIZE(ring_control->tx_data);
-		}
-
-		i = priv->rx_idx;
-		i %= ARRAY_SIZE(ring_control->rx_data);
-		priv->rx_idx = idx = le32_to_cpu(ring_control->device_idx[0]);
-		idx %= ARRAY_SIZE(ring_control->rx_data);
-		while (i != idx) {
-			u16 len;
-			struct sk_buff *skb;
-			desc = &ring_control->rx_data[i];
-			len = le16_to_cpu(desc->len);
-			skb = priv->rx_buf[i];
-
-			skb_put(skb, len);
-
-			if (p54_rx(dev, skb)) {
-				pci_unmap_single(priv->pdev,
-						 le32_to_cpu(desc->host_addr),
-						 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
-
-				priv->rx_buf[i] = NULL;
-				desc->host_addr = 0;
-			} else {
-				skb_trim(skb, 0);
-				desc->len = cpu_to_le16(MAX_RX_SIZE);
-			}
-
-			i++;
-			i %= ARRAY_SIZE(ring_control->rx_data);
-		}
+		p54p_check_tx_ring(dev, &priv->tx_idx_mgmt,
+				   3, ring_control->tx_mgmt,
+				   ARRAY_SIZE(ring_control->tx_mgmt),
+				   priv->tx_buf_mgmt);
+
+		p54p_check_tx_ring(dev, &priv->tx_idx_data,
+				   1, ring_control->tx_data,
+				   ARRAY_SIZE(ring_control->tx_data),
+				   priv->tx_buf_data);
 
-		p54p_refill_rx_ring(dev);
+		tasklet_schedule(&priv->rx_tasklet);
 
-		wmb();
-		P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
 	} else if (reg & cpu_to_le32(ISL38XX_INT_IDENT_INIT))
 		complete(&priv->boot_comp);
 
-	spin_unlock(&priv->lock);
+	spin_unlock(&priv->tx_lock);
 
 	return reg ? IRQ_HANDLED : IRQ_NONE;
 }
@@ -375,7 +426,7 @@ static void p54p_tx(struct ieee80211_hw 
 	dma_addr_t mapping;
 	u32 device_idx, idx, i;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->tx_lock, flags);
 
 	device_idx = le32_to_cpu(ring_control->device_idx[1]);
 	idx = le32_to_cpu(ring_control->host_idx[1]);
@@ -392,9 +443,9 @@ static void p54p_tx(struct ieee80211_hw 
 	ring_control->host_idx[1] = cpu_to_le32(idx + 1);
 
 	if (free_on_tx)
-		priv->tx_buf[i] = data;
+		priv->tx_buf_data[i] = data;
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
 	P54P_READ(dev_int);
@@ -412,7 +463,7 @@ static int p54p_open(struct ieee80211_hw
 
 	init_completion(&priv->boot_comp);
 	err = request_irq(priv->pdev->irq, &p54p_interrupt,
-			  IRQF_SHARED, "prism54pci", dev);
+			  IRQF_SHARED, "p54pci", dev);
 	if (err) {
 		printk(KERN_ERR "%s: failed to register IRQ handler\n",
 		       wiphy_name(dev->wiphy));
@@ -420,8 +471,14 @@ static int p54p_open(struct ieee80211_hw
 	}
 
 	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
-	priv->rx_idx = priv->tx_idx = 0;
-	p54p_refill_rx_ring(dev);
+	priv->rx_idx_data = priv->tx_idx_data = 0;
+	priv->rx_idx_mgmt = priv->tx_idx_mgmt = 0;
+
+	p54p_refill_rx_ring(dev, 0, priv->ring_control->rx_data,
+		ARRAY_SIZE(priv->ring_control->rx_data), priv->rx_buf_data);
+
+	p54p_refill_rx_ring(dev, 2, priv->ring_control->rx_mgmt,
+		ARRAY_SIZE(priv->ring_control->rx_mgmt), priv->rx_buf_mgmt);
 
 	p54p_upload_firmware(dev);
 
@@ -465,6 +522,8 @@ static void p54p_stop(struct ieee80211_h
 	unsigned int i;
 	struct p54p_desc *desc;
 
+	tasklet_kill(&priv->rx_tasklet);
+
 	P54P_WRITE(int_enable, cpu_to_le32(0));
 	P54P_READ(int_enable);
 	udelay(10);
@@ -473,26 +532,51 @@ static void p54p_stop(struct ieee80211_h
 
 	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
 
-	for (i = 0; i < ARRAY_SIZE(priv->rx_buf); i++) {
+	for (i = 0; i < ARRAY_SIZE(priv->rx_buf_data); i++) {
 		desc = &ring_control->rx_data[i];
 		if (desc->host_addr)
-			pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
+			pci_unmap_single(priv->pdev,
+					 le32_to_cpu(desc->host_addr),
 					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
-		kfree_skb(priv->rx_buf[i]);
-		priv->rx_buf[i] = NULL;
+		kfree_skb(priv->rx_buf_data[i]);
+		priv->rx_buf_data[i] = NULL;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(priv->tx_buf); i++) {
+	for (i = 0; i < ARRAY_SIZE(priv->rx_buf_mgmt); i++) {
+		desc = &ring_control->rx_mgmt[i];
+		if (desc->host_addr)
+			pci_unmap_single(priv->pdev,
+					 le32_to_cpu(desc->host_addr),
+					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+		kfree_skb(priv->rx_buf_mgmt[i]);
+		priv->rx_buf_mgmt[i] = NULL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(priv->tx_buf_data); i++) {
 		desc = &ring_control->tx_data[i];
 		if (desc->host_addr)
-			pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
-					 le16_to_cpu(desc->len), PCI_DMA_TODEVICE);
+			pci_unmap_single(priv->pdev,
+					 le32_to_cpu(desc->host_addr),
+					 le16_to_cpu(desc->len),
+					 PCI_DMA_TODEVICE);
 
-		kfree(priv->tx_buf[i]);
-		priv->tx_buf[i] = NULL;
+		kfree(priv->tx_buf_data[i]);
+		priv->tx_buf_data[i] = NULL;
 	}
 
-	memset(ring_control, 0, sizeof(ring_control));
+	for (i = 0; i < ARRAY_SIZE(priv->tx_buf_mgmt); i++) {
+		desc = &ring_control->tx_mgmt[i];
+		if (desc->host_addr)
+			pci_unmap_single(priv->pdev,
+					 le32_to_cpu(desc->host_addr),
+					 le16_to_cpu(desc->len),
+					 PCI_DMA_TODEVICE);
+
+		kfree(priv->tx_buf_mgmt[i]);
+		priv->tx_buf_mgmt[i] = NULL;
+	}
+
+	memset(ring_control, 0, sizeof(*ring_control));
 }
 
 static int __devinit p54p_probe(struct pci_dev *pdev,
@@ -506,7 +590,7 @@ static int __devinit p54p_probe(struct p
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		printk(KERN_ERR "%s (prism54pci): Cannot enable new PCI device\n",
+		printk(KERN_ERR "%s (p54pci): Cannot enable new PCI device\n",
 		       pci_name(pdev));
 		return err;
 	}
@@ -514,22 +598,22 @@ static int __devinit p54p_probe(struct p
 	mem_addr = pci_resource_start(pdev, 0);
 	mem_len = pci_resource_len(pdev, 0);
 	if (mem_len < sizeof(struct p54p_csr)) {
-		printk(KERN_ERR "%s (prism54pci): Too short PCI resources\n",
+		printk(KERN_ERR "%s (p54pci): Too short PCI resources\n",
 		       pci_name(pdev));
 		pci_disable_device(pdev);
 		return err;
 	}
 
-	err = pci_request_regions(pdev, "prism54pci");
+	err = pci_request_regions(pdev, "p54pci");
 	if (err) {
-		printk(KERN_ERR "%s (prism54pci): Cannot obtain PCI resources\n",
+		printk(KERN_ERR "%s (p54pci): Cannot obtain PCI resources\n",
 		       pci_name(pdev));
 		return err;
 	}
 
 	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) ||
 	    pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
-		printk(KERN_ERR "%s (prism54pci): No suitable DMA available\n",
+		printk(KERN_ERR "%s (p54pci): No suitable DMA available\n",
 		       pci_name(pdev));
 		goto err_free_reg;
 	}
@@ -542,7 +626,7 @@ static int __devinit p54p_probe(struct p
 
 	dev = p54_init_common(sizeof(*priv));
 	if (!dev) {
-		printk(KERN_ERR "%s (prism54pci): ieee80211 alloc failed\n",
+		printk(KERN_ERR "%s (p54pci): ieee80211 alloc failed\n",
 		       pci_name(pdev));
 		err = -ENOMEM;
 		goto err_free_reg;
@@ -556,7 +640,7 @@ static int __devinit p54p_probe(struct p
 
 	priv->map = ioremap(mem_addr, mem_len);
 	if (!priv->map) {
-		printk(KERN_ERR "%s (prism54pci): Cannot map device memory\n",
+		printk(KERN_ERR "%s (p54pci): Cannot map device memory\n",
 		       pci_name(pdev));
 		err = -EINVAL;	// TODO: use a better error code?
 		goto err_free_dev;
@@ -565,7 +649,7 @@ static int __devinit p54p_probe(struct p
 	priv->ring_control = pci_alloc_consistent(pdev, sizeof(*priv->ring_control),
 						  &priv->ring_control_dma);
 	if (!priv->ring_control) {
-		printk(KERN_ERR "%s (prism54pci): Cannot allocate rings\n",
+		printk(KERN_ERR "%s (p54pci): Cannot allocate rings\n",
 		       pci_name(pdev));
 		err = -ENOMEM;
 		goto err_iounmap;
@@ -584,11 +668,13 @@ static int __devinit p54p_probe(struct p
 	priv->common.stop = p54p_stop;
 	priv->common.tx = p54p_tx;
 
-	spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->tx_lock);
+	spin_lock_init(&priv->rx_lock);
+	tasklet_init(&priv->rx_tasklet, p54p_rx_tasklet, (unsigned long)dev);
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
-		printk(KERN_ERR "%s (prism54pci): Cannot register netdevice\n",
+		printk(KERN_ERR "%s (p54pci): Cannot register netdevice\n",
 		       pci_name(pdev));
 		goto err_free_common;
 	}
@@ -673,7 +759,7 @@ static int p54p_resume(struct pci_dev *p
 #endif /* CONFIG_PM */
 
 static struct pci_driver p54p_driver = {
-	.name		= "prism54pci",
+	.name		= "p54pci",
 	.id_table	= p54p_table,
 	.probe		= p54p_probe,
 	.remove		= __devexit_p(p54p_remove),
diff -Nurp a/drivers/net/wireless/p54/p54pci.h b/drivers/net/wireless/p54/p54pci.h
--- a/drivers/net/wireless/p54/p54pci.h	2008-03-29 16:05:32.000000000 +0100
+++ b/drivers/net/wireless/p54/p54pci.h	2008-04-08 14:15:22.000000000 +0200
@@ -1,5 +1,5 @@
-#ifndef PRISM54PCI_H
-#define PRISM54PCI_H
+#ifndef P54PCI_H
+#define P54PCI_H
 
 /*
  * Defines for PCI based mac80211 Prism54 driver
@@ -68,7 +68,7 @@ struct p54p_csr {
 } __attribute__ ((packed));
 
 /* usb backend only needs the register defines above */
-#ifndef PRISM54USB_H
+#ifndef P54USB_H
 struct p54p_desc {
 	__le32 host_addr;
 	__le32 device_addr;
@@ -92,15 +92,20 @@ struct p54p_priv {
 	struct p54_common common;
 	struct pci_dev *pdev;
 	struct p54p_csr __iomem *map;
+	struct tasklet_struct rx_tasklet;
 
-	spinlock_t lock;
+	spinlock_t tx_lock;
+	spinlock_t rx_lock;
 	struct p54p_ring_control *ring_control;
 	dma_addr_t ring_control_dma;
-	u32 rx_idx, tx_idx;
-	struct sk_buff *rx_buf[8];
-	void *tx_buf[32];
+	u32 rx_idx_data, tx_idx_data;
+	u32 rx_idx_mgmt, tx_idx_mgmt;
+	struct sk_buff *rx_buf_data[8];
+	struct sk_buff *rx_buf_mgmt[4];
+	void *tx_buf_data[32];
+	void *tx_buf_mgmt[4];
 	struct completion boot_comp;
 };
 
-#endif /* PRISM54USB_H */
-#endif /* PRISM54PCI_H */
+#endif /* P54USB_H */
+#endif /* P54PCI_H */
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-03-29 16:05:32.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.c	2008-04-08 13:41:46.000000000 +0200
@@ -27,7 +27,7 @@
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_DESCRIPTION("Prism54 USB wireless driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("prism54usb");
+MODULE_ALIAS("p54usb");
 
 static struct usb_device_id p54u_table[] __devinitdata = {
 	/* Version 1 devices (pci chip + net2280) */
@@ -311,7 +311,7 @@ static int p54u_read_eeprom(struct ieee8
 
 	buf = kmalloc(0x2020, GFP_KERNEL);
 	if (!buf) {
-		printk(KERN_ERR "prism54usb: cannot allocate memory for "
+		printk(KERN_ERR "p54usb: cannot allocate memory for "
 		       "eeprom readback!\n");
 		return -ENOMEM;
 	}
@@ -320,7 +320,7 @@ static int p54u_read_eeprom(struct ieee8
 		*((u32 *) buf) = priv->common.rx_start;
 		err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, sizeof(u32));
 		if (err) {
-			printk(KERN_ERR "prism54usb: addr send failed\n");
+			printk(KERN_ERR "p54usb: addr send failed\n");
 			goto fail;
 		}
 	} else {
@@ -330,7 +330,7 @@ static int p54u_read_eeprom(struct ieee8
 		reg->val = cpu_to_le32(ISL38XX_DEV_INT_DATA);
 		err = p54u_bulk_msg(priv, P54U_PIPE_DEV, buf, sizeof(*reg));
 		if (err) {
-			printk(KERN_ERR "prism54usb: dev_int send failed\n");
+			printk(KERN_ERR "p54usb: dev_int send failed\n");
 			goto fail;
 		}
 	}
@@ -348,7 +348,7 @@ static int p54u_read_eeprom(struct ieee8
 	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf,
 			    EEPROM_READBACK_LEN + priv->common.tx_hdr_len);
 	if (err) {
-		printk(KERN_ERR "prism54usb: eeprom req send failed\n");
+		printk(KERN_ERR "p54usb: eeprom req send failed\n");
 		goto fail;
 	}
 
@@ -358,7 +358,7 @@ static int p54u_read_eeprom(struct ieee8
 	if (!err && alen > offset) {
 		p54_parse_eeprom(dev, (u8 *)buf + offset, alen - offset);
 	} else {
-		printk(KERN_ERR "prism54usb: eeprom read failed!\n");
+		printk(KERN_ERR "p54usb: eeprom read failed!\n");
 		err = -EINVAL;
 		goto fail;
 	}
@@ -446,7 +446,7 @@ static int p54u_upload_firmware_3887(str
 
 		err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, block_size);
 		if (err) {
-			printk(KERN_ERR "prism54usb: firmware upload failed!\n");
+			printk(KERN_ERR "p54usb: firmware upload failed!\n");
 			goto err_upload_failed;
 		}
 
@@ -457,7 +457,7 @@ static int p54u_upload_firmware_3887(str
 	*((__le32 *)buf) = cpu_to_le32(~crc32_le(~0, fw_entry->data, fw_entry->size));
 	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, sizeof(u32));
 	if (err) {
-		printk(KERN_ERR "prism54usb: firmware upload failed!\n");
+		printk(KERN_ERR "p54usb: firmware upload failed!\n");
 		goto err_upload_failed;
 	}
 
@@ -468,13 +468,13 @@ static int p54u_upload_firmware_3887(str
 			break;
 
 		if (alen > 5 && !memcmp(buf, "ERROR", 5)) {
-			printk(KERN_INFO "prism54usb: firmware upload failed!\n");
+			printk(KERN_INFO "p54usb: firmware upload failed!\n");
 			err = -EINVAL;
 			break;
 		}
 
 		if (time_after(jiffies, timeout)) {
-			printk(KERN_ERR "prism54usb: firmware boot timed out!\n");
+			printk(KERN_ERR "p54usb: firmware boot timed out!\n");
 			err = -ETIMEDOUT;
 			break;
 		}
@@ -486,7 +486,7 @@ static int p54u_upload_firmware_3887(str
 	buf[1] = '\r';
 	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, 2);
 	if (err) {
-		printk(KERN_ERR "prism54usb: firmware boot failed!\n");
+		printk(KERN_ERR "p54usb: firmware boot failed!\n");
 		goto err_upload_failed;
 	}
 
@@ -648,7 +648,7 @@ static int p54u_upload_firmware_net2280(
 
 		err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, block_len);
 		if (err) {
-			printk(KERN_ERR "prism54usb: firmware block upload "
+			printk(KERN_ERR "p54usb: firmware block upload "
 			       "failed\n");
 			goto fail;
 		}
@@ -682,7 +682,7 @@ static int p54u_upload_firmware_net2280(
 			  0x002C | (unsigned long)&devreg->direct_mem_win);
 		if (!(reg & cpu_to_le32(ISL38XX_DMA_STATUS_DONE)) ||
 		    !(reg & cpu_to_le32(ISL38XX_DMA_STATUS_READY))) {
-			printk(KERN_ERR "prism54usb: firmware DMA transfer "
+			printk(KERN_ERR "p54usb: firmware DMA transfer "
 			       "failed\n");
 			goto fail;
 		}
@@ -790,7 +790,7 @@ static int __devinit p54u_probe(struct u
 
 	dev = p54_init_common(sizeof(*priv));
 	if (!dev) {
-		printk(KERN_ERR "prism54usb: ieee80211 alloc failed\n");
+		printk(KERN_ERR "p54usb: ieee80211 alloc failed\n");
 		return -ENOMEM;
 	}
 
@@ -846,7 +846,7 @@ static int __devinit p54u_probe(struct u
 	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
 		u8 perm_addr[ETH_ALEN];
 
-		printk(KERN_WARNING "prism54usb: Invalid hwaddr! Using randomly generated MAC addr\n");
+		printk(KERN_WARNING "p54usb: Invalid hwaddr! Using randomly generated MAC addr\n");
 		random_ether_addr(perm_addr);
 		SET_IEEE80211_PERM_ADDR(dev, perm_addr);
 	}
@@ -855,7 +855,7 @@ static int __devinit p54u_probe(struct u
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
-		printk(KERN_ERR "prism54usb: Cannot register netdevice\n");
+		printk(KERN_ERR "p54usb: Cannot register netdevice\n");
 		goto err_free_dev;
 	}
 
@@ -890,7 +890,7 @@ static void __devexit p54u_disconnect(st
 }
 
 static struct usb_driver p54u_driver = {
-	.name	= "prism54usb",
+	.name	= "p54usb",
 	.id_table = p54u_table,
 	.probe = p54u_probe,
 	.disconnect = p54u_disconnect,
diff -Nurp a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
--- a/drivers/net/wireless/p54/p54usb.h	2008-03-29 16:05:32.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.h	2008-04-08 13:41:46.000000000 +0200
@@ -1,5 +1,5 @@
-#ifndef PRISM54USB_H
-#define PRISM54USB_H
+#ifndef P54USB_H
+#define P54USB_H
 
 /*
  * Defines for USB based mac80211 Prism54 driver
@@ -130,4 +130,4 @@ struct p54u_priv {
 	struct sk_buff_head rx_queue;
 };
 
-#endif /* PRISM54USB_H */
+#endif /* P54USB_H */

--Boundary-00=_Pm2+HLra7q2DoAa--
