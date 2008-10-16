Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:42568 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbYJPXMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 19:12:55 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] p54: AP & Ad-hoc testing
Date: Fri, 17 Oct 2008 01:17:07 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810170117.07236.chunkeey@web.de> (sfid-20081017_011259_791114_F944BF11)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this patch one can finally test Ad-hoc & AP mode.
The station unlocking should work now, so the card doesn't have
to be rebooted anymore.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Larry,

This patch series is a drop-in replacement [PATCH 7/6].
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-17 00:32:53.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-17 00:34:17.000000000 +0200
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
@@ -902,6 +940,64 @@ free:
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
 #ifndef WLAN_FC_GET_TYPE
 #define WLAN_FC_GET_TYPE(fc) (fc & IEEE80211_FCTL_FTYPE)
 #define WLAN_FC_GET_STYPE(fc) (fc & IEEE80211_FCTL_STYPE)
@@ -989,6 +1085,12 @@ static int p54_tx(struct ieee80211_hw *d
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
 
@@ -1302,6 +1404,88 @@ static int p54_init_stats(struct ieee802
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
+				skb_trim(skb, skb->len - (dtim_len - 3));
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
+		/* wait for the last beacon the be freed */
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
@@ -1332,9 +1516,14 @@ static void p54_stop(struct ieee80211_hw
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
@@ -1354,6 +1543,8 @@ static int p54_add_interface(struct ieee
 
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_AP:
 		priv->mode = conf->type;
 		break;
 	default:
@@ -1369,6 +1560,12 @@ static int p54_add_interface(struct ieee
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
@@ -1386,6 +1583,8 @@ static void p54_remove_interface(struct 
 	struct p54_common *priv = dev->priv;
 
 	mutex_lock(&priv->conf_mutex);
+	if (priv->cached_beacon)
+		p54_tx_cancel(dev, priv->cached_beacon);
 	p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
 	priv->mode = NL80211_IFTYPE_MONITOR;
 	memset(priv->mac_addr, 0, ETH_ALEN);
@@ -1401,7 +1600,7 @@ static int p54_config(struct ieee80211_h
 	mutex_lock(&priv->conf_mutex);
 	priv->rx_antenna = 2; /* automatic */
 	priv->output_power = conf->power_level << 2;
-	ret = p54_set_freq(dev, cpu_to_le16(conf->channel->center_freq));
+	ret = p54_set_freq(dev, conf->channel->center_freq);
 	if (!ret)
 		ret = p54_set_edcf(dev);
 	mutex_unlock(&priv->conf_mutex);
@@ -1413,13 +1612,41 @@ static int p54_config_interface(struct i
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
@@ -1548,6 +1775,7 @@ static const struct ieee80211_ops p54_op
 	.stop			= p54_stop,
 	.add_interface		= p54_add_interface,
 	.remove_interface	= p54_remove_interface,
+	.set_tim		= p54_set_tim,
 	.config			= p54_config,
 	.config_interface	= p54_config_interface,
 	.bss_info_changed	= p54_bss_info_changed,
@@ -1569,12 +1797,13 @@ struct ieee80211_hw *p54_init_common(siz
 	priv = dev->priv;
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 	skb_queue_head_init(&priv->tx_queue);
-	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
-		     IEEE80211_HW_RX_INCLUDES_FCS |
+	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_NOISE_DBM;
 
-	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION |
+					  NL80211_IFTYPE_ADHOC |
+					  NL80211_IFTYPE_AP);
 
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	priv->tx_stats[0].limit = 1;		/* Beacon queue */
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-10-17 00:12:22.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-10-16 23:12:48.000000000 +0200
@@ -108,6 +108,7 @@ struct p54_common {
 	struct timer_list stats_timer;
 	struct completion stats_comp;
 	struct sk_buff *cached_stats;
+	struct sk_buff *cached_beacon;
 	int noise;
 	void *eeprom;
 	struct completion eeprom_comp;
