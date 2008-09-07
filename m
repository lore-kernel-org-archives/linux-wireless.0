Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:36226 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbYIGAW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 20:22:29 -0400
From: Chr <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] p54usb: support LM87 firmwares
Date: Sun, 7 Sep 2008 02:25:40 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>, Tomas Winkler <tomasw@gmail.com>
References: <200809022139.12969.chunkeey@web.de> <200809070119.45720.chunkeey@web.de> <48C31349.7060401@lwfinger.net>
In-Reply-To: <48C31349.7060401@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809070225.41177.chunkeey@web.de> (sfid-20080907_022233_396399_5377CA8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 07 September 2008 01:33:29 Larry Finger wrote:
> Chr wrote:
> > But, for newer firmwares you'll need "p54: better firmware support"
> > (cc4b0cbf4ab) as well. This changes were merged about 25-26 hours ago
> > into wireless-testing, the only thing that isn't in yet is 802.11a
> > support....
> >
> > the LM87 firmware is this one:
> > http://daemonizer.de/prism54/prism54-fw/fw-usb/2.13.1.0.arm.1
> >
> > This link can be found on the driver's site too:
> > http://linuxwireless.org/en/users/Drivers/p54
>
> Thanks. That one fixed the ping problem. I had the latest
> wireless-testing, and have added the patches you posted earlier today.
>
Well, since you already do some testing here.  Want more? ;-)

I will be off for about 4-5 weeks and it would be very nice if someone with lots of broadcom
hardware can test if the p54 works ADHOC & AP mode with them.

i've already (successfully) tested Intel's 2915 & 4965, several atheros chipsets and another prism54
on different operating systems.

But there could be problems with some broadcom chips.

Regards,
	Chr
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-09-06 14:09:16.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-09-07 02:04:31.000000000 +0200
@@ -589,10 +589,19 @@ static void p54_rx_frame_sent(struct iee
 				else
 					info->status.excessive_retries = 1;
 			}
+			if (payload->status & 0x04)
+				info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
+			info->status.retry_count = payload->retries - 1;
 			info->status.retry_count = payload->retries - 1;
 			info->status.ack_signal = p54_rssi_to_dbm(dev,
 					le16_to_cpu(payload->ack_rssi));
 			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
+			if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+				struct ieee80211_hdr *ieee80211hdr =
+					(struct ieee80211_hdr *)entry->data;
+				ieee80211hdr->seq_ctrl |=
+					cpu_to_le16(payload->seq);
+			}
 			ieee80211_tx_status_irqsafe(dev, entry);
 			goto out;
 		} else
@@ -803,25 +812,130 @@ free:
 }
 EXPORT_SYMBOL_GPL(p54_read_eeprom);
 
+static int p54_sta_unlock(struct ieee80211_hw *dev, u8 *addr)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr;
+	struct p54_tx_control_sta_unlock *sta;
+
+	if (is_multicast_ether_addr(addr))
+		return 0;
+
+	hdr = kmalloc(sizeof(*hdr) + sizeof(*sta) +
+		      priv->tx_hdr_len, GFP_ATOMIC);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr = (void *)hdr + priv->tx_hdr_len;
+	hdr->magic1 = cpu_to_le16(0x8001);
+	hdr->len = cpu_to_le16(sizeof(*sta));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_PSM_STA_UNLOCK);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*sta));
+
+	sta = (struct p54_tx_control_sta_unlock *) hdr->data;
+	memcpy(sta->addr, addr, ETH_ALEN);
+
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*sta), 1);
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
+	hdr = kmalloc(sizeof(*hdr) + sizeof(*tim) +
+		      priv->tx_hdr_len, GFP_KERNEL);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr = (void *)hdr + priv->tx_hdr_len;
+	hdr->magic1 = cpu_to_le16(0x8001);
+	hdr->len = cpu_to_le16(sizeof(*tim));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_TIM);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*tim));
+
+	tim = (struct p54_tx_control_tim *) hdr->data;
+	tim->count = 1;
+	tim->entry[0] = cpu_to_le16(set ? (aid | 0x8000) : aid);
+
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*tim), 1);
+
+	return 0;
+}
+
+static int p54_tx_fill_header(struct ieee80211_hw *dev,
+	struct ieee80211_hdr *hdr, struct ieee80211_tx_info *info,
+	u8 *queue, u16 *flags, u16 *aid)
+{
+	struct p54_common *priv = dev->priv;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	int ret = 1;
+
+	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)
+		switch (fc & IEEE80211_FCTL_STYPE) {
+		case IEEE80211_STYPE_PROBE_RESP:
+			*aid = 0;
+			*queue = 2;
+			*flags = 0x22;
+			return 0;
+		case IEEE80211_STYPE_BEACON:
+			*aid = 0;
+			*queue = 0;
+			*flags = 0x02;
+			return 0;
+		default:
+			*queue = 2;
+			ret = 0;
+		}
+	else
+		*queue += 4;
+
+	if (is_multicast_ether_addr(hdr->addr1)) {
+		*queue = 3;
+		*aid = 0;
+		return 0;
+	}
+
+	if (priv->mode != IEEE80211_IF_TYPE_STA) {
+		*aid = info->control.aid;
+		if (!info->control.aid)
+			*flags = 0x20;
+	} else
+		*aid = 1;
+
+	return ret;
+}
+
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_queue_stats *current_queue;
+	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	struct p54_tx_control_allocdata *txhdr;
 	size_t padding, len;
-	u8 rate;
-	u8 cts_rate = 0x20;
+	u16 aid, hdr_flags = 0x0000;
+	u8 queue, rate, cts_rate = 0x20;
+
+	queue = skb_get_queue_mapping(skb);
 
-	current_queue = &priv->tx_stats[skb_get_queue_mapping(skb) + 4];
-	if (unlikely(current_queue->len > current_queue->limit))
-		return NETDEV_TX_BUSY;
-	current_queue->len++;
-	current_queue->count++;
-	if (current_queue->len == current_queue->limit)
-		ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
+	if (likely(p54_tx_fill_header(dev, ieee80211hdr, info,
+				      &queue, &hdr_flags, &aid))) {
+		current_queue = &priv->tx_stats[queue];
+		if (unlikely(current_queue->len > current_queue->limit))
+			return NETDEV_TX_BUSY;
+		current_queue->len++;
+		current_queue->count++;
+		if (current_queue->len == current_queue->limit)
+			ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
+	}
+
+	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
+		p54_sta_unlock(dev, ieee80211hdr->addr1);
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
@@ -831,13 +945,12 @@ static int p54_tx(struct ieee80211_hw *d
 	hdr = (struct p54_control_hdr *) skb_push(skb, sizeof(*hdr));
 
 	if (padding)
-		hdr->magic1 = cpu_to_le16(0x4010);
-	else
-		hdr->magic1 = cpu_to_le16(0x0010);
+		hdr_flags = 0x4000;
+
+	hdr->magic1 = cpu_to_le16(hdr_flags);
 	hdr->len = cpu_to_le16(len);
-	hdr->type = (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cpu_to_le16(1);
+	hdr->type = cpu_to_le16(aid);
 	hdr->retry1 = hdr->retry2 = info->control.retry_limit;
-
 	/* TODO: add support for alternate retry TX rates */
 	rate = ieee80211_get_tx_rate(dev, info)->hw_value;
 	if (info->flags & IEEE80211_TX_CTL_SHORT_PREAMBLE) {
@@ -854,7 +967,7 @@ static int p54_tx(struct ieee80211_hw *d
 	memset(txhdr->rateset, rate, 8);
 	txhdr->key_type = 0;
 	txhdr->key_len = 0;
-	txhdr->hw_queue = skb_get_queue_mapping(skb) + 4;
+	txhdr->hw_queue = queue;
 	txhdr->tx_antenna = (info->antenna_sel_tx == 0) ?
 		2 : info->antenna_sel_tx - 1;
 	txhdr->output_power = priv->output_power;
@@ -870,17 +983,12 @@ static int p54_tx(struct ieee80211_hw *d
 	 * patch places the sequence number in the hardware state, which
 	 * limits us to a single virtual state.
 	 */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			priv->seqno += 0x10;
-		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
-	}
 	/* modifies skb->cb and with it info, so must be last! */
 	p54_assign_address(dev, skb, hdr, skb->len);
 
 	priv->tx(dev, hdr, skb->len, 0);
 	return 0;
+
 }
 
 static int p54_set_filter(struct ieee80211_hw *dev, u16 filter_type,
@@ -1170,6 +1278,9 @@ static int p54_add_interface(struct ieee
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_AP:
+	case IEEE80211_IF_TYPE_MNTR:
+	case IEEE80211_IF_TYPE_IBSS:
 		priv->mode = conf->type;
 		break;
 	default:
@@ -1184,6 +1295,15 @@ static int p54_add_interface(struct ieee
 	case IEEE80211_IF_TYPE_STA:
 		p54_set_filter(dev, 1, NULL);
 		break;
+	case IEEE80211_IF_TYPE_IBSS:
+		p54_set_filter(dev, 0x02, NULL);
+		break;
+	case IEEE80211_IF_TYPE_MNTR:
+		p54_set_filter(dev, 0x10, NULL);
+		break;
+	case IEEE80211_IF_TYPE_AP:
+		p54_set_filter(dev, 0x04, NULL);
+		break;
 	default:
 		BUG();	/* impossible */
 		break;
@@ -1211,25 +1331,114 @@ static int p54_config(struct ieee80211_h
 	mutex_lock(&priv->conf_mutex);
 	priv->rx_antenna = (conf->antenna_sel_rx == 0) ?
 		2 : conf->antenna_sel_tx - 1;
-	priv->output_power = conf->power_level << 2;
+	priv->output_power = (conf->power_level << 2) & ~0x80;
 	ret = p54_set_freq(dev, cpu_to_le16(conf->channel->center_freq));
 	p54_set_vdcf(dev);
 	mutex_unlock(&priv->conf_mutex);
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
+				skb_trim(skb, skb->len - (dtim_len - 3));
+			if (dtim_len < 3)
+				skb_put(skb, skb->len + (3 - dtim_len));
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
+static int p54_beacon_update(struct ieee80211_hw *dev,
+			struct ieee80211_vif *vif)
+{
+	struct p54_common *priv = dev->priv;
+	struct sk_buff *beacon = ieee80211_beacon_get(dev, vif);
+
+	if (!beacon)
+		return -ENOMEM;
+
+	p54_beacon_tim(beacon);
+	p54_tx(dev, beacon);
+	priv->tsf_high32 = 0;
+	priv->tsf_low32 = 0;
+
+	return 0;
+}
+
 static int p54_config_interface(struct ieee80211_hw *dev,
 				struct ieee80211_vif *vif,
 				struct ieee80211_if_conf *conf)
 {
 	struct p54_common *priv = dev->priv;
+	int ret = 0;
 
-	mutex_lock(&priv->conf_mutex);
-	p54_set_filter(dev, 0, conf->bssid);
-	p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
-	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
-	mutex_unlock(&priv->conf_mutex);
-	return 0;
+	switch (priv->mode) {
+	case IEEE80211_IF_TYPE_STA:
+		mutex_lock(&priv->conf_mutex);
+		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+		p54_set_filter(dev, 0x1, conf->bssid);
+		p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
+		mutex_unlock(&priv->conf_mutex);
+		break;
+	case IEEE80211_IF_TYPE_AP:
+	case IEEE80211_IF_TYPE_IBSS:
+		mutex_lock(&priv->conf_mutex);
+		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+		p54_set_freq(dev, dev->conf.channel->center_freq);
+		p54_set_filter(dev, priv->filter_type, priv->bssid);
+		mutex_unlock(&priv->conf_mutex);
+
+		if (conf->changed & IEEE80211_IFCC_BEACON) {
+			ret = p54_beacon_update(dev, vif);
+			if (ret)
+				return ret;
+
+			mutex_lock(&priv->conf_mutex);
+			p54_set_vdcf(dev);
+			mutex_unlock(&priv->conf_mutex);
+		}
+		break;
+	}
+
+	return ret;
 }
 
 static void p54_configure_filter(struct ieee80211_hw *dev,
@@ -1366,6 +1575,7 @@ static const struct ieee80211_ops p54_op
 	.config_interface	= p54_config_interface,
 	.configure_filter	= p54_configure_filter,
 	.conf_tx		= p54_conf_tx,
+	.set_tim		= p54_set_tim,
 	.get_stats		= p54_get_stats,
 	.get_tx_stats		= p54_get_tx_stats
 };
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-09-06 13:57:06.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-09-07 01:55:21.000000000 +0200
@@ -321,4 +321,15 @@ struct p54_tx_control_xbow_synth {
 	u32 padding[5];
 } __attribute__ ((packed));
 
+struct p54_tx_control_sta_unlock {
+	u8 addr[ETH_ALEN];
+	u16 padding;
+} __attribute__ ((packed));
+
+struct p54_tx_control_tim {
+	u8 count;
+	u8 unalloc0[3];
+	__le16 entry[8];
+} __attribute__ ((packed));
+
 #endif /* P54COMMON_H */

