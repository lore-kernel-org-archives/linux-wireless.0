Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:41871 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYJPVQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 17:16:03 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 7/6] p54: integrate parts of lmac_longbow.h and other parts of stlc45xx
Date: Thu, 16 Oct 2008 23:20:12 +0200
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
References: <200810150408.44363.chunkeey@web.de> <48F761CA.5040102@lwfinger.net>
In-Reply-To: <48F761CA.5040102@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810162320.13106.chunkeey@web.de> (sfid-20081016_231623_566204_567EC43F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 16 October 2008 17:46:18 Larry Finger wrote:
> The following change of ack_rssi from __le16 to u8 generates the sparse warning
> "drivers/net/wireless/p54/p54common.c:660:5: warning: cast to restricted __le16":
> 
> > +struct p54_frame_sent {
> >  	u8 status;
> > -	u8 retries;
> > -	__le16 ack_rssi;
> > +	u8 tries;
> > +	u8 ack_rssi;
> > +	u8 quality;
> 
> The statement in question is:
> 
> info->status.ack_signal = p54_rssi_to_dbm(dev,
>                 le16_to_cpu(payload->ack_rssi));
> 
thanks! now I have to figure out why sparse doesn't work.?

BTW: I made a new diff for AP/AD-HOC, could you get it working with b43?

Regards,
	Chr
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-16 23:06:55.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-16 23:12:20.000000000 +0200
@@ -436,12 +436,12 @@ static int p54_parse_eeprom(struct ieee8
 		goto err;
 	}
 
-	priv->rxhw = synth & 0x07;
+	priv->rxhw = synth & PDR_SYNTH_FRONTEND_MASK;
 	if (priv->rxhw == 4)
 		p54_init_xbow_synth(dev);
-	if (!(synth & 0x40))
+	if (!(synth & PDR_SYNTH_24_GHZ_DISABLED))
 		dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
-	if (!(synth & 0x80))
+	if (!(synth & PDR_SYNTH_5_GHZ_DISABLED))
 		dev->wiphy->bands[IEEE80211_BAND_5GHZ] = &band_5GHz;
 
 	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
@@ -626,6 +626,12 @@ static void p54_rx_frame_sent(struct iee
 		__skb_unlink(entry, &priv->tx_queue);
 		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
+		if (unlikely(entry == priv->cached_beacon)) {
+			kfree_skb(entry);
+			priv->cached_beacon = NULL;
+			goto out;
+		}
+
 		/*
 		 * Clear manually, ieee80211_tx_info_clear_status would
 		 * clear the counts too and we need them.
@@ -711,6 +717,35 @@ static void p54_rx_stats(struct ieee8021
 	mod_timer(&priv->stats_timer, jiffies + 5 * HZ);
 }
 
+static void p54_rx_trap(struct ieee80211_hw *dev, struct sk_buff *skb)
+{
+	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
+	struct p54_trap *trap = (struct p54_trap *) hdr->data;
+	u16 event = le16_to_cpu(trap->event);
+	u16 freq = le16_to_cpu(trap->frequency);	
+
+	switch (event) {
+	case P54_TRAP_BEACON_TX:
+		break;
+	case P54_TRAP_RADAR:
+		printk(KERN_INFO "%s: radar (freq:%d MHz)\n",
+			wiphy_name(dev->wiphy), freq);
+		break;
+	case P54_TRAP_NO_BEACON:
+		break;
+	case P54_TRAP_SCAN:
+		break;
+	case P54_TRAP_TBTT:
+		break;
+	case P54_TRAP_TIMER:
+		break;
+	default:
+		printk(KERN_INFO "%s: received event:%x freq:%d\n",
+		       wiphy_name(dev->wiphy), event, freq);
+		break;
+	}
+}
+
 static int p54_rx_control(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
@@ -719,6 +754,9 @@ static int p54_rx_control(struct ieee802
 	case P54_CONTROL_TYPE_TXDONE:
 		p54_rx_frame_sent(dev, skb);
 		break;
+	case P54_CONTROL_TYPE_TRAP:
+		p54_rx_trap(dev, skb);
+		break;
 	case P54_CONTROL_TYPE_BBP:
 		break;
 	case P54_CONTROL_TYPE_STAT_READBACK:
@@ -739,9 +777,9 @@ static int p54_rx_control(struct ieee802
 /* returns zero if skb can be reused */
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
-	u8 type = le16_to_cpu(*((__le16 *)skb->data)) >> 8;
+	u16 type = le16_to_cpu(*((__le16 *)skb->data));
 
-	if (type == 0x80)
+	if (type & P54_HDR_FLAG_CONTROL)
 		return p54_rx_control(dev, skb);
 	else
 		return p54_rx_data(dev, skb);
@@ -902,41 +940,164 @@ free:
 }
 EXPORT_SYMBOL_GPL(p54_read_eeprom);
 
+static int p54_set_tim(struct ieee80211_hw *dev, struct ieee80211_sta *sta,
+		bool set)
+{
+	struct p54_common *priv = dev->priv;
+	struct sk_buff *skb;
+	struct p54_tim *tim;
+
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET,
+		      sizeof(struct p54_hdr) + sizeof(*tim),
+		      P54_CONTROL_TYPE_TIM, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	tim = (struct p54_tim *) skb_put(skb, sizeof(*tim));
+	tim->count = 1;
+	tim->entry[0] = cpu_to_le16(set ? (sta->aid | 0x8000) : sta->aid);
+	priv->tx(dev, skb, 1);
+	return 0;
+}
+
+#ifndef WLAN_FC_GET_TYPE
+#define WLAN_FC_GET_TYPE(fc) (fc & IEEE80211_FCTL_FTYPE)
+#define WLAN_FC_GET_STYPE(fc) (fc & IEEE80211_FCTL_STYPE)
+#endif
+
+static int p54_sta_unlock(struct ieee80211_hw *dev, u8 *addr)
+{
+	struct p54_common *priv = dev->priv;
+	struct sk_buff *skb;
+	struct p54_sta_unlock *sta;
+
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET,
+		sizeof(struct p54_hdr) + sizeof(*sta),
+		P54_CONTROL_TYPE_PSM_STA_UNLOCK, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	sta = (struct p54_sta_unlock *)skb_put(skb, sizeof(*sta));
+	memcpy(sta->addr, addr, ETH_ALEN);
+	priv->tx(dev, skb, 1);
+	return 0;
+}
+
+static int p54_tx_cancel(struct ieee80211_hw *dev, struct sk_buff *entry)
+{
+	struct p54_common *priv = dev->priv;
+	struct sk_buff *skb;
+	struct p54_hdr *hdr;
+	struct p54_txcancel *cancel;
+
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET,
+		sizeof(struct p54_hdr) + sizeof(*cancel),
+		P54_CONTROL_TYPE_TXCANCEL, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	hdr = (void *)entry->data;
+	cancel = (struct p54_txcancel *)skb_put(skb, sizeof(*cancel));
+	cancel->req_id = hdr->req_id;
+	priv->tx(dev, skb, 1);
+	return 0;
+}
+
+static int p54_tx_fill(struct ieee80211_hw *dev, struct sk_buff *skb,
+		struct ieee80211_tx_info* info, u8 *queue, size_t *extra_len,
+		u16 *flags, u16 *aid)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct p54_common *priv = dev->priv;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	int ret = 0;
+
+	if (unlikely(WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT)) {
+		switch (WLAN_FC_GET_STYPE(fc)) {
+		case IEEE80211_STYPE_BEACON:
+			*aid = 0;
+			*queue = 0;
+			*extra_len = IEEE80211_MAX_TIM_LEN;
+			*flags = P54_HDR_FLAG_DATA_OUT_TIMESTAMP;
+			return 0;
+		case IEEE80211_STYPE_PROBE_RESP:
+			*aid = 0;
+			*queue = 2;
+			*flags = P54_HDR_FLAG_DATA_OUT_TIMESTAMP |
+				 P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+			return 0;
+		default:
+			*queue = 2;
+			ret = 0;
+		}
+	} else {
+		*queue += 4;
+		ret = 1;
+	}
+	
+	switch (priv->mode) {
+	case NL80211_IFTYPE_STATION:
+		*aid = 1;
+		break;
+	case NL80211_IFTYPE_AP:
+		if (is_multicast_ether_addr(hdr->addr1)) {
+			*aid = 0;
+			*queue = 3;
+			return 0;
+		}
+	case NL80211_IFTYPE_ADHOC:
+		if (info->control.sta)
+			*aid = info->control.sta->aid;
+		else
+			*flags = P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+	}		
+	return ret;
+}
+
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_tx_queue_stats *current_queue;
+	struct ieee80211_tx_queue_stats *current_queue = NULL;
 	struct p54_common *priv = dev->priv;
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
-	size_t padding, len;
+	size_t padding, len, tim_len;
 	int i, j, ridx;
-	u8 rate;
+	u16 hdr_flags = 0, aid = 0;
+	u8 rate, queue;
 	u8 cts_rate = 0x20;
 	u8 rc_flags;
 	u8 calculated_tries[4];
 	u8 nrates = 0, nremaining = 8;
 
-	current_queue = &priv->tx_stats[skb_get_queue_mapping(skb) + 4];
-	if (unlikely(current_queue->len > current_queue->limit))
-		return NETDEV_TX_BUSY;
-	current_queue->len++;
-	current_queue->count++;
-	if (current_queue->len == current_queue->limit)
-		ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
+	queue = skb_get_queue_mapping(skb);
+
+	if (p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid)) {
+		current_queue = &priv->tx_stats[queue];
+		if (unlikely(current_queue->len > current_queue->limit))
+			return NETDEV_TX_BUSY;
+		current_queue->len++;
+		current_queue->count++;
+		if (current_queue->len == current_queue->limit)
+			ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
+        }
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
 
+	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) {
+		if (info->control.sta)
+			if (p54_sta_unlock(dev, info->control.sta->addr))
+				return -ENOMEM;
+	}
+
 	txhdr = (struct p54_tx_data *) skb_push(skb, sizeof(*txhdr) + padding);
 	hdr = (struct p54_hdr *) skb_push(skb, sizeof(*hdr));
 
 	if (padding)
-		hdr->flags = cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN);
-	else
-		hdr->flags = cpu_to_le16(0);
+		hdr_flags |= P54_HDR_FLAG_DATA_ALIGN;
 	hdr->len = cpu_to_le16(len);
-	hdr->type = (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cpu_to_le16(1);
+	hdr->type = cpu_to_le16(aid);
 	hdr->rts_tries = info->control.rates[0].count;
 
 	/*
@@ -1003,12 +1164,18 @@ static int p54_tx(struct ieee80211_hw *d
 			ridx++;
 		}
 	}
+
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+		hdr_flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
+
+	/* TODO: enable bursting */
+	hdr->flags = cpu_to_le16(hdr_flags);
 	hdr->tries = ridx;
 	txhdr->crypt_offset = 0;
 	txhdr->rts_rate_idx = 0;
 	txhdr->key_type = 0;
 	txhdr->key_len = 0;
-	txhdr->hw_queue = skb_get_queue_mapping(skb) + 4;
+	txhdr->hw_queue = queue;
 	txhdr->backlog = 32;
 	memset(txhdr->durations, 0, sizeof(txhdr->durations));
 	txhdr->tx_antenna = (info->antenna_sel_tx == 0) ?
@@ -1019,9 +1186,13 @@ static int p54_tx(struct ieee80211_hw *d
 		txhdr->align[0] = padding;
 
 	/* modifies skb->cb and with it info, so must be last! */
-	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len))) {
+	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len + tim_len))) {
 		skb_pull(skb, sizeof(*hdr) + sizeof(*txhdr) + padding);
-		return NETDEV_TX_BUSY;
+		if (current_queue) {
+			current_queue->len--;
+			current_queue->count--;
+		}
+		return -ENOMEM;
 	}
 	priv->tx(dev, skb, 0);
 	return 0;
@@ -1232,11 +1403,93 @@ static int p54_init_stats(struct ieee802
 	return 0;
 }
 
+static int p54_beacon_tim(struct sk_buff *skb)
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
+	if (skb->len <= sizeof(mgmt)) {
+		printk(KERN_ERR "p54: beacon is too short!\n");
+		return -EINVAL;
+	}
+
+	pos = (u8 *)mgmt->u.beacon.variable;
+	end = skb->data + skb->len;
+	while (pos < end) {
+		if (pos + 2 + pos[1] > end) {
+			printk(KERN_ERR "p54: parsing beacon failed\n");
+			return -EINVAL;
+		}
+
+		if (pos[0] == WLAN_EID_TIM) {
+			u8 dtim_len = pos[1];
+			u8 dtim_period = pos[3];
+			u8 *next = pos + 2 + dtim_len;
+
+			if (dtim_len < 3) {
+				printk(KERN_ERR "p54: invalid dtim len!\n");
+				return -EINVAL;
+			}
+			memmove(pos, next, end - next);
+
+			if (dtim_len > 3)
+			   skb_trim(skb, skb->len - (dtim_len - 3));
+
+			pos = end - (dtim_len + 2);
+
+			/* add the dummy at the end */
+			pos[0] = WLAN_EID_TIM;
+			pos[1] = 3;
+			pos[2] = 0;
+			pos[3] = dtim_period;
+			pos[4] = 0;
+			return 0;
+		}
+		pos += 2 + pos[1];
+	}
+	return 0;
+}
+
+static int p54_beacon_update(struct ieee80211_hw *dev,
+			struct ieee80211_vif *vif)
+{
+	struct p54_common *priv = dev->priv;
+	struct sk_buff *beacon;
+	int ret;	
+
+	if (priv->cached_beacon) {
+		p54_tx_cancel(dev, priv->cached_beacon);
+		msleep(10);
+	}		
+
+	beacon = ieee80211_beacon_get(dev, vif);
+	if (!beacon)
+		return -ENOMEM;
+	ret = p54_beacon_tim(beacon);
+	if (ret)
+		return ret;
+	ret = p54_tx(dev, beacon);
+	if (ret)
+		return ret;
+	priv->cached_beacon = beacon;
+	priv->tsf_high32 = 0;
+	priv->tsf_low32 = 0;
+
+	return 0;
+}
+
 static int p54_start(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
 	int err;
 
+	mutex_lock(&priv->conf_mutex);
 	err = priv->open(dev);
 	if (!err)
 		priv->mode = NL80211_IFTYPE_MONITOR;
@@ -1247,7 +1500,7 @@ static int p54_start(struct ieee80211_hw
 	err = p54_set_edcf(dev);
 	if (!err)
 		err = p54_init_stats(dev);
-
+	mutex_unlock(&priv->conf_mutex);
 	return err;
 }
 
@@ -1256,15 +1509,22 @@ static void p54_stop(struct ieee80211_hw
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
 
+	mutex_lock(&priv->conf_mutex);
 	del_timer(&priv->stats_timer);
 	p54_free_skb(dev, priv->cached_stats);
 	priv->cached_stats = NULL;
+	if (priv->cached_beacon)
+		p54_tx_cancel(dev, priv->cached_beacon);
+
 	while ((skb = skb_dequeue(&priv->tx_queue)))
 		kfree_skb(skb);
 
+	kfree(priv->cached_beacon);
+	priv->cached_beacon = NULL;
 	priv->stop(dev);
 	priv->tsf_high32 = priv->tsf_low32 = 0;
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
+	mutex_unlock(&priv->conf_mutex);
 }
 
 static int p54_add_interface(struct ieee80211_hw *dev,
@@ -1272,14 +1532,20 @@ static int p54_add_interface(struct ieee
 {
 	struct p54_common *priv = dev->priv;
 
-	if (priv->mode != NL80211_IFTYPE_MONITOR)
+	mutex_lock(&priv->conf_mutex);
+	if (priv->mode != NL80211_IFTYPE_MONITOR) {
+		mutex_unlock(&priv->conf_mutex);
 		return -EOPNOTSUPP;
+	}
 
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_AP:
 		priv->mode = conf->type;
 		break;
 	default:
+		mutex_unlock(&priv->conf_mutex);
 		return -EOPNOTSUPP;
 	}
 
@@ -1291,6 +1557,12 @@ static int p54_add_interface(struct ieee
 	case NL80211_IFTYPE_STATION:
 		p54_setup_mac(dev, P54_FILTER_TYPE_STATION, NULL);
 		break;
+	case NL80211_IFTYPE_AP:
+		p54_setup_mac(dev, P54_FILTER_TYPE_AP, priv->mac_addr);
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		p54_setup_mac(dev, P54_FILTER_TYPE_IBSS, NULL);
+		break;
 	default:
 		BUG();	/* impossible */
 		break;
@@ -1298,6 +1570,7 @@ static int p54_add_interface(struct ieee
 
 	p54_set_leds(dev, 1, 0, 0);
 
+	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
 
@@ -1305,9 +1578,14 @@ static void p54_remove_interface(struct 
 				 struct ieee80211_if_init_conf *conf)
 {
 	struct p54_common *priv = dev->priv;
+
+	mutex_lock(&priv->conf_mutex);
+	if (priv->cached_beacon)
+		p54_tx_cancel(dev, priv->cached_beacon);
+	p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
 	priv->mode = NL80211_IFTYPE_MONITOR;
 	memset(priv->mac_addr, 0, ETH_ALEN);
-	p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
+	mutex_unlock(&priv->conf_mutex);
 }
 
 static int p54_config(struct ieee80211_hw *dev, u32 changed)
@@ -1331,13 +1609,41 @@ static int p54_config_interface(struct i
 				struct ieee80211_if_conf *conf)
 {
 	struct p54_common *priv = dev->priv;
+	int ret = 0;
 
 	mutex_lock(&priv->conf_mutex);
-	p54_setup_mac(dev, P54_FILTER_TYPE_STATION, conf->bssid);
-	p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
-	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+	switch (priv->mode) {
+	case NL80211_IFTYPE_STATION:
+		ret = p54_setup_mac(dev, P54_FILTER_TYPE_STATION, conf->bssid);
+		if (ret)
+			goto out;
+		ret = p54_set_leds(dev, 1, 
+				   !is_multicast_ether_addr(conf->bssid), 0);
+		if (ret)
+			goto out;
+		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+		break;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+		ret = p54_set_freq(dev, dev->conf.channel->center_freq);
+		if (ret)
+			goto out;
+		ret = p54_setup_mac(dev, priv->mac_mode, priv->bssid);
+		if (ret)
+			goto out;
+		if (conf->changed & IEEE80211_IFCC_BEACON) {
+			ret = p54_beacon_update(dev, vif);
+			if (ret)
+				goto out;
+			ret = p54_set_edcf(dev);
+			if (ret)
+				goto out;
+		}
+	}
+out:
 	mutex_unlock(&priv->conf_mutex);
-	return 0;
+	return ret;
 }
 
 static void p54_configure_filter(struct ieee80211_hw *dev,
@@ -1372,14 +1678,17 @@ static int p54_conf_tx(struct ieee80211_
 		       const struct ieee80211_tx_queue_params *params)
 {
 	struct p54_common *priv = dev->priv;
+	int ret;
 
+	mutex_lock(&priv->conf_mutex);
 	if ((params) && !(queue > 4)) {
 		P54_SET_QUEUE(priv->qos_params[queue], params->aifs,
 			params->cw_min, params->cw_max, params->txop);
 	} else
 		return -EINVAL;
-
-	return p54_set_edcf(dev);
+	ret = p54_set_edcf(dev);
+	mutex_unlock(&priv->conf_mutex);
+	return ret;
 }
 
 static int p54_init_xbow_synth(struct ieee80211_hw *dev)
@@ -1462,6 +1771,7 @@ static const struct ieee80211_ops p54_op
 	.stop			= p54_stop,
 	.add_interface		= p54_add_interface,
 	.remove_interface	= p54_remove_interface,
+	.set_tim		= p54_set_tim,
 	.config			= p54_config,
 	.config_interface	= p54_config_interface,
 	.bss_info_changed	= p54_bss_info_changed,
@@ -1483,8 +1793,7 @@ struct ieee80211_hw *p54_init_common(siz
 	priv = dev->priv;
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 	skb_queue_head_init(&priv->tx_queue);
-	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
-		     IEEE80211_HW_RX_INCLUDES_FCS |
+	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_NOISE_DBM;
 
@@ -1493,14 +1802,16 @@ struct ieee80211_hw *p54_init_common(siz
 	 *	requires beacons (AP, MESH, IBSS) then it must
 	 *	implement IEEE80211_TX_CTL_ASSIGN_SEQ.
 	 */
-	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION |
+					  NL80211_IFTYPE_ADHOC |
+					  NL80211_IFTYPE_AP);
 
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
-	priv->tx_stats[0].limit = 1;
-	priv->tx_stats[1].limit = 1;
-	priv->tx_stats[2].limit = 1;
-	priv->tx_stats[3].limit = 1;
-	priv->tx_stats[4].limit = 5;
+	priv->tx_stats[0].limit = 1;		/* Beacon queue */
+	priv->tx_stats[1].limit = 1;		/* Probe queue for HW scan */
+	priv->tx_stats[2].limit = 3;		/* queue for MLMEs */
+	priv->tx_stats[3].limit = 3;		/* Broadcast / MC queue */
+	priv->tx_stats[4].limit = 5;		/* Data */
 	dev->queues = 1;
 	priv->noise = -94;
 	/*
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-10-15 19:24:42.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-10-16 22:56:34.000000000 +0200
@@ -25,6 +25,22 @@ struct bootrec {
 	u32 data[10];
 } __attribute__((packed));
 
+#define PDR_SYNTH_FRONTEND_MASK		0x0007
+#define PDR_SYNTH_IQ_CAL_MASK		0x0018
+#define PDR_SYNTH_IQ_CAL_PA_DETECTOR	0x0000
+#define PDR_SYNTH_IQ_CAL_DISABLED	0x0008
+#define PDR_SYNTH_IQ_CAL_ZIF		0x0010
+#define PDR_SYNTH_FAA_SWITCH_MASK	0x0020
+#define PDR_SYNTH_FAA_SWITCH_ENABLED	0x0001
+#define PDR_SYNTH_24_GHZ_MASK		0x0040
+#define PDR_SYNTH_24_GHZ_DISABLED	0x0040
+#define PDR_SYNTH_5_GHZ_MASK		0x0080
+#define PDR_SYNTH_5_GHZ_DISABLED	0x0080
+#define PDR_SYNTH_RX_DIV_MASK		0x0100
+#define PDR_SYNTH_RX_DIV_SUPPORTED	0x0100
+#define PDR_SYNTH_TX_DIV_MASK		0x0200
+#define PDR_SYNTH_TX_DIV_SUPPORTED	0x0200
+
 struct bootrec_exp_if {
 	__le16 role;
 	__le16 if_id;
@@ -210,6 +226,19 @@ struct pda_pa_curve_data {
 #define PDR_BASEBAND_REGISTERS			0x8000
 #define PDR_PER_CHANNEL_BASEBAND_REGISTERS	0x8001
 
+/* PDR definitions for default country & country list */
+#define PDR_COUNTRY_CERT_CODE		0x80
+#define PDR_COUNTRY_CERT_CODE_REAL	0x00
+#define PDR_COUNTRY_CERT_CODE_PSEUDO	0x80
+#define PDR_COUNTRY_CERT_BAND		0x40
+#define PDR_COUNTRY_CERT_BAND_2GHZ	0x00
+#define PDR_COUNTRY_CERT_BAND_5GHZ	0x40
+#define PDR_COUNTRY_CERT_IODOOR		0x30
+#define PDR_COUNTRY_CERT_IODOOR_BOTH	0x00
+#define PDR_COUNTRY_CERT_IODOOR_INDOOR	0x20
+#define PDR_COUNTRY_CERT_IODOOR_OUTDOOR	0x30
+#define PDR_COUNTRY_CERT_INDEX		0x0F
+
 /* stored in skb->cb */
 struct memrecord {
 	u32 start_addr;
@@ -507,7 +536,7 @@ struct p54_sta_unlock {
 } __attribute__ ((packed));
 
 #define P54_TIM_CLEAR BIT(15)
-struct p54_tx_control_tim {
+struct p54_tim {
 	u8 count;
 	u8 padding[3];
 	__le16 entry[8];
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-10-15 19:24:42.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-10-16 23:12:48.000000000 +0200
@@ -108,6 +108,7 @@ struct p54_common {
 	struct timer_list stats_timer;
 	struct completion stats_comp;
 	struct sk_buff *cached_stats;
+	struct sk_buff *cached_beacon;
 	int noise;
 	void *eeprom;
 	struct completion eeprom_comp;
