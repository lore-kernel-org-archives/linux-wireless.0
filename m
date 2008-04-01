Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:36075 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547AbYDAVj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 17:39:57 -0400
From: Chr <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][PATCH 4/4] p54: Accesspoint mode
Cc: Michael Wu <flamingice@sourmilk.net>
MIME-Version: 1.0
Date: Tue, 1 Apr 2008 23:39:54 +0200
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ruq8HfKkzeK/Wz4"
Message-Id: <200804012339.55010.chunkeey@web.de> (sfid-20080401_224000_141150_1F578129)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_ruq8HfKkzeK/Wz4
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch finally makes an Accesspoint out of p54.
(Johannes' patch and my mac80211 patch is necessary!)

Signed-off-by: Christian Lamparter <chunkeey@web.de>

--Boundary-00=_ruq8HfKkzeK/Wz4
Content-Type: text/x-diff;
  charset="us-ascii";
  name="p54-ap-v1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-ap-v1.diff"

diff -Nurp a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
--- a/drivers/net/wireless/p54common.c	2008-04-01 23:23:44.000000000 +0200
+++ b/drivers/net/wireless/p54common.c	2008-04-01 23:16:29.000000000 +0200
@@ -145,10 +145,11 @@ void p54_parse_firmware(struct ieee80211
 
 	if (priv->fw_var >= 0x300) {
 		/* Firmware supports QoS, use it! */
-		priv->tx_stats.data[0].limit = 3;
-		priv->tx_stats.data[1].limit = 4;
-		priv->tx_stats.data[2].limit = 3;
-		priv->tx_stats.data[3].limit = 1;
+		printk(KERN_INFO "p54: enable QoS\n");
+		priv->tx_stats[4].limit = 3;
+		priv->tx_stats[5].limit = 4;
+		priv->tx_stats[6].limit = 3;
+		priv->tx_stats[7].limit = 1;
 		dev->queues = 4;
 	}
 }
@@ -393,7 +394,7 @@ static void inline p54_wake_free_queues(
 	 * But, what if some are full? */
 
 	for (i = 0; i < dev->queues; i++)
-		if (priv->tx_stats.data[i].len < priv->tx_stats.data[i].limit)
+		if (priv->tx_stats[i + 4].len < priv->tx_stats[i + 4].limit)
 			ieee80211_wake_queue(dev, i);
 }
 
@@ -436,21 +437,20 @@ static void p54_rx_frame_sent(struct iee
 			memcpy(&status.control, range->control,
 			       sizeof(status.control));
 			kfree(range->control);
-			priv->tx_stats.data[status.control.queue].len--;
 
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
 				pad = entry_data->align[0];
 
-			if (!(status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
-				if (!(payload->status & 0x01))
-					status.flags |= IEEE80211_TX_STATUS_ACK;
-				else
-					status.excessive_retries = 1;
-			}
+			priv->tx_stats[entry_data->frame_type].len--;
 			status.retry_count = payload->retries - 1;
 			status.ack_signal = le16_to_cpu(payload->ack_rssi);
+			if (!(payload->status & 0x01))
+				status.flags |= IEEE80211_TX_STATUS_ACK;
+			else
+			  if (!(status.control.flags & IEEE80211_TXCTL_NO_ACK))
+				status.excessive_retries = 1;
 			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
 			ieee80211_tx_status_irqsafe(dev, entry, &status);
 			goto out;
@@ -590,6 +590,51 @@ static void p54_assign_address(struct ie
 	data->req_id = cpu_to_le32(target_addr + 0x70);
 }
 
+#ifndef WLAN_FC_GET_TYPE
+#define WLAN_FC_GET_TYPE(fc) (fc & IEEE80211_FCTL_FTYPE)
+#define WLAN_FC_GET_STYPE(fc) (fc & IEEE80211_FCTL_STYPE)
+#endif
+
+static int p54_tx_fill_header(struct ieee80211_hw *dev, u16 fc,
+	struct ieee80211_tx_control *control, u8 *retry1, u8 *retry2,
+	u8 *frame_type, u16 *magic, u16 *aid)
+{
+	*retry2 = *retry1 = control->retry_limit;
+
+	if (unlikely(WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT))
+		switch (WLAN_FC_GET_STYPE(fc)) {
+		case IEEE80211_STYPE_PROBE_REQ:
+		case IEEE80211_STYPE_PROBE_RESP:
+			*aid = 0;
+			*frame_type = 2;
+			*magic = 0x32;
+			return 0;
+		case IEEE80211_STYPE_BEACON:
+			*aid = 0;
+			*frame_type = 0;
+			*magic = 0x02;
+			return 0;
+		default:
+			*frame_type = 6;
+			*aid = control->aid + 1; /* AID 1 is reserved */
+			if (!(control->flags & (IEEE80211_TXCTL_USE_RTS_CTS |
+			   IEEE80211_TXCTL_USE_CTS_PROTECT)))
+				*magic = 0x10;
+			*retry2 = *retry1 = control->retry_limit;
+			break;
+		}
+	else {
+		/* FIXME: broadcast frames */
+		*frame_type = control->queue + 4;
+		*aid = control->aid + 1;
+		if (!(control->flags & (IEEE80211_TXCTL_USE_RTS_CTS |
+		   IEEE80211_TXCTL_USE_CTS_PROTECT)))
+			*magic = 0x10;
+		*retry1 = *retry2 = control->retry_limit;
+	}
+	return 1;
+}
+
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control)
 {
@@ -598,16 +643,21 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_allocdata *txhdr;
 	struct ieee80211_tx_control *control_copy;
+	struct ieee80211_hdr *ieeehdr = (struct ieee80211_hdr *)skb->data;
+	u16 aid, magic, fc = le16_to_cpu(ieeehdr->frame_control);
 	size_t padding, len;
-	u8 rate;
+	u8 rate, retry1, retry2, frame_type;
 
-	current_queue = &priv->tx_stats.data[control->queue];
-	if (unlikely(current_queue->len > current_queue->limit))
-		return NETDEV_TX_BUSY;
-	current_queue->len++;
-	current_queue->count++;
-	if (current_queue->len == current_queue->limit)
-		ieee80211_stop_queue(dev, control->queue);
+	if (p54_tx_fill_header(dev, fc, control, &retry1,
+	    &retry2, &frame_type, &magic, &aid)) {
+		current_queue = &priv->tx_stats[frame_type];
+		if (unlikely(current_queue->len > current_queue->limit))
+			return NETDEV_TX_BUSY;
+		current_queue->len++;
+		current_queue->count++;
+		if (current_queue->len == current_queue->limit)
+			ieee80211_stop_queue(dev, control->queue);
+	}
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
@@ -621,26 +671,25 @@ static int p54_tx(struct ieee80211_hw *d
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
 
 	/* TODO: add support for alternate retry TX rates */
 	rate = control->tx_rate->hw_value;
-	if (control->flags & IEEE80211_TXCTL_SHORT_PREAMBLE)
-		rate |= 0x10;
-	else if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
+	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
 		rate |= 0x40;
 	else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		rate |= 0x20;
 	memset(txhdr->rateset, rate, 8);
 	txhdr->key_type = 0;
 	txhdr->key_len = 0;
-	txhdr->frame_type = cpu_to_le32(control->queue + 4);
+	txhdr->frame_type = frame_type;
 	txhdr->antenna = (control->antenna_sel_tx == 0) ?
 		2 : control->antenna_sel_tx - 1;
 	txhdr->output_power = 0x7f; /* 0.25 dbm / unit */
@@ -688,9 +737,14 @@ static int p54_set_filter(struct ieee802
 	 * = 0000000101011111b
 	 * = 24MBits 12MBits 6MBit 11MBit 5.5MBits 2MBits 1Mbit */
 	filter->bss_basic_rates = cpu_to_le32(0x15F);
-	memcpy(filter->rts_rates, p54_client_rts_rates, 8);
 	memset(filter->bss_filter_mac, ~0, ETH_ALEN);
 
+	if (filter_type == P54_FILTER_TYPE_AP)
+		memcpy(filter->rts_rates, p54_ap_rts_rates, 8);
+	else
+		memcpy(filter->rts_rates, p54_client_rts_rates, 8);
+
+
 	filter->rx_antenna = (dev->conf.antenna_sel_rx == 0) ? 2 :
 		dev->conf.antenna_sel_rx - 1;
 	filter->rx_addr = cpu_to_le32(priv->rx_end);
@@ -706,6 +760,39 @@ static int p54_set_filter(struct ieee802
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
@@ -779,6 +866,7 @@ static int p54_set_freq(struct ieee80211
 	memcpy(hdr->data + payload_len - 4, &chan->val_bpsk, 4);
 
 	priv->tx(dev, hdr, sizeof(*hdr) + payload_len, 1);
+	udelay(25);
 	return 0;
 
  err:
@@ -908,6 +996,8 @@ static int p54_add_interface(struct ieee
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_AP:
+	/* case IEEE80211_IF_TYPE_IBSS: - disabled for now*/
 		priv->mode = conf->type;
 		break;
 	default:
@@ -922,13 +1012,18 @@ static int p54_add_interface(struct ieee
 	case IEEE80211_IF_TYPE_STA:
 		priv->filter_type = P54_FILTER_TYPE_STA;
 		break;
+	case IEEE80211_IF_TYPE_AP:
+		priv->filter_type = P54_FILTER_TYPE_AP;
+		break;
+	case IEEE80211_IF_TYPE_IBSS:
+		priv->filter_type = P54_FILTER_TYPE_ADHOC;
+		break;
 	default:
 		BUG();	/* impossible */
 		break;
 	}
 
-	p54_set_filter(dev, priv->filter_type);
-
+	p54_init_misc(dev);
 	p54_set_leds(dev, 1, 0, 0);
 
 	/* start statistics readback timer */
@@ -958,6 +1053,54 @@ static int p54_config(struct ieee80211_h
 	return ret;
 }
 
+static void p54_beacon_tim(struct sk_buff *skb)
+{
+	/*
+	 * the good excuse for this mess is ... the firmware.
+	 * The dummy TIM MUST be at the end of the beacon frame,
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
+			u8 *next = pos + 2 + dtim_len;
+
+			memmove(pos, next, end - next);
+
+			if (dtim_len > 3)
+			   skb_trim(skb, skb->len - (dtim_len - 3));
+			if (dtim_len < 3)
+			   skb_put(skb, skb->len + (3 - dtim_len));
+
+			pos = end - (dtim_len + 2);
+
+			/* add the dummy at the end */
+			pos[0] = WLAN_EID_TIM;
+			pos[1] = 3;
+			pos[2] = 0;
+			pos[3] = 1; /* FIX MAC80211: get the real dtim period
+				       from the bss struct... */
+			pos[4] = 0;
+			return ;
+		}
+		pos += 2 + pos[1];
+	}
+}
+
 static int p54_config_interface(struct ieee80211_hw *dev,
 				struct ieee80211_vif *vif,
 				struct ieee80211_if_conf *conf)
@@ -970,6 +1113,16 @@ static int p54_config_interface(struct i
 		p54_set_filter(dev, P54_FILTER_TYPE_STA);
 		p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
 		break;
+	case IEEE80211_IF_TYPE_AP:
+		if (conf->beacon && conf->beacon_control) {
+			p54_set_freq(dev, dev->conf.channel->center_freq);
+			p54_set_filter(dev, priv->filter_type);
+			p54_beacon_tim(conf->beacon);
+			p54_tx(dev, conf->beacon, conf->beacon_control);
+			p54_set_vdcf(dev);
+			p54_set_leds(dev, 1, 1, 0);
+		}
+		break;
 	}
 
 	return 0;
@@ -1071,11 +1224,36 @@ static int p54_get_tx_stats(struct ieee8
 			    struct ieee80211_tx_queue_stats *stats)
 {
 	struct p54_common *priv = dev->priv;
-	unsigned int i;
 
-	for (i = 0; i < dev->queues; i++)
-		memcpy(&stats->data[i], &priv->tx_stats.data[i],
-			sizeof(stats->data[i]));
+	memcpy(&stats->data, &priv->tx_stats[4],
+		sizeof(priv->tx_stats[0]) * dev->queues);
+
+	return 0;
+}
+
+static int p54_set_tim(struct ieee80211_hw *dev, int aid, int set)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr;
+	struct p54_tx_control_tim *tim;
+
+	hdr = kzalloc(sizeof(*hdr) + sizeof(*tim) +
+		      priv->tx_hdr_len, GFP_KERNEL);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr = (void *)hdr + priv->tx_hdr_len;
+	hdr->magic1 = cpu_to_le16(0x8001);
+	hdr->len = cpu_to_le16(sizeof(*tim));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_TIM);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*tim), NULL);
+
+	aid++; /* AID 1 is reserved */
+	tim = (struct p54_tx_control_tim *) hdr->data;
+	tim->count = 1;	/* just one entry */
+	tim->entry[0] = set ? cpu_to_le16(aid | 0x8000) : cpu_to_le16(aid);
+
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*tim), 1);
 
 	return 0;
 }
@@ -1089,6 +1267,7 @@ static const struct ieee80211_ops p54_op
 	.config			= p54_config,
 	.config_interface	= p54_config_interface,
 	.configure_filter	= p54_configure_filter,
+	.set_tim		= p54_set_tim,
 	.conf_tx		= p54_conf_tx,
 	.get_stats		= p54_get_stats,
 	.get_tx_stats		= p54_get_tx_stats
@@ -1116,7 +1295,11 @@ struct ieee80211_hw *p54_init_common(siz
 	dev->max_rssi = -36;
 	dev->max_noise = -36;
 
-	priv->tx_stats.data[0].limit = 5;
+	priv->tx_stats[0].limit = 1; /* beacon queue */
+	priv->tx_stats[1].limit = 1; /* broadcasts / probes (passive scan)*/
+	priv->tx_stats[2].limit = 1; /* management frame queue */
+	priv->tx_stats[3].limit = 1; /* used to be the data queue */
+	priv->tx_stats[4].limit = 5; /* data queue */
 	priv->filter_type = P54_FILTER_TYPE_NONE;
 	priv->rx_filter = P54_RX_FILTER_NOTHING;
 	dev->queues = 1;
diff -Nurp a/drivers/net/wireless/p54common.h b/drivers/net/wireless/p54common.h
--- a/drivers/net/wireless/p54common.h	2008-04-01 22:32:37.000000000 +0200
+++ b/drivers/net/wireless/p54common.h	2008-04-01 22:36:32.000000000 +0200
@@ -291,4 +291,23 @@ struct p54_statistics {
 	u8 unknown[40];		/* CCA / CCQ / RADAR data */
 } __attribute__ ((packed));
 
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
+struct p54_tx_control_free_queue {
+	__le32 req_id;
+} __attribute__ ((packed));
+
 #endif /* P54COMMON_H */
diff -Nurp a/drivers/net/wireless/p54.h b/drivers/net/wireless/p54.h
--- a/drivers/net/wireless/p54.h	2008-04-01 22:33:15.000000000 +0200
+++ b/drivers/net/wireless/p54.h	2008-04-01 22:36:43.000000000 +0200
@@ -92,7 +92,7 @@ struct p54_common {
 	void *cached_vdcf;
 	unsigned int fw_var;
 	struct p54_stats stats;
-	struct ieee80211_tx_queue_stats tx_stats;
+	struct ieee80211_tx_queue_stats_data tx_stats[8];
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);

--Boundary-00=_ruq8HfKkzeK/Wz4--
