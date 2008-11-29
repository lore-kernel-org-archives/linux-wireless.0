Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:49256 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYK2Vhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 16:37:34 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] p54: refactoring
Date: Sat, 29 Nov 2008 22:37:31 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811292237.32261.chunkeey@web.de> (sfid-20081129_223738_003950_58439873)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks to the introduction of "changed" flags, we no longer 
have to do the bookkeeping of p54's firmware state for everything.
Thus we can cut down redundancy code.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-29 21:34:12.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-29 21:34:26.000000000 +0100
@@ -1335,11 +1335,12 @@ static int p54_tx(struct ieee80211_hw *d
 	return NETDEV_TX_BUSY;
 }
 
-static int p54_setup_mac(struct ieee80211_hw *dev, u16 mode, const u8 *bssid)
+static int p54_setup_mac(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
 	struct p54_setup_mac *setup;
+	u16 mode;
 
 	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*setup) +
 			    sizeof(struct p54_hdr), P54_CONTROL_TYPE_SETUP,
@@ -1348,14 +1349,31 @@ static int p54_setup_mac(struct ieee8021
 		return -ENOMEM;
 
 	setup = (struct p54_setup_mac *) skb_put(skb, sizeof(*setup));
-	priv->mac_mode = mode;
+	if (dev->conf.radio_enabled) {
+		switch (priv->mode) {
+		case NL80211_IFTYPE_STATION:
+			mode = P54_FILTER_TYPE_STATION;
+			break;
+		case NL80211_IFTYPE_AP:
+			mode = P54_FILTER_TYPE_AP;
+			break;
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_MESH_POINT:
+			mode = P54_FILTER_TYPE_IBSS;
+			break;
+		default:
+			mode = P54_FILTER_TYPE_NONE;
+			break;
+		}
+		if (priv->filter_flags & FIF_PROMISC_IN_BSS)
+			mode |= P54_FILTER_TYPE_TRANSPARENT;
+	} else
+		mode = P54_FILTER_TYPE_RX_DISABLED;
+
 	setup->mac_mode = cpu_to_le16(mode);
 	memcpy(setup->mac_addr, priv->mac_addr, ETH_ALEN);
-	if (!bssid)
-		memset(setup->bssid, ~0, ETH_ALEN);
-	else
-		memcpy(setup->bssid, bssid, ETH_ALEN);
-	setup->rx_antenna = priv->rx_antenna;
+	memcpy(setup->bssid, priv->bssid, ETH_ALEN);
+	setup->rx_antenna = 2; /* automatic */
 	setup->rx_align = 0;
 	if (priv->fw_var < 0x500) {
 		setup->v1.basic_rate_mask = cpu_to_le32(priv->basic_rate_mask);
@@ -1384,7 +1402,8 @@ static int p54_setup_mac(struct ieee8021
 	return 0;
 }
 
-static int p54_set_freq(struct ieee80211_hw *dev, u16 frequency)
+static int p54_scan(struct ieee80211_hw *dev, u16 mode, u16 dwell,
+		    u16 frequency)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
@@ -1401,8 +1420,8 @@ static int p54_set_freq(struct ieee80211
 
 	chan = (struct p54_scan *) skb_put(skb, sizeof(*chan));
 	memset(chan->padding1, 0, sizeof(chan->padding1));
-	chan->mode = cpu_to_le16(P54_SCAN_EXIT);
-	chan->dwell = cpu_to_le16(0x0);
+	chan->mode = cpu_to_le16(mode);
+	chan->dwell = cpu_to_le16(dwell);
 
 	for (i = 0; i < priv->iq_autocal_len; i++) {
 		if (priv->iq_autocal[i].freq != freq)
@@ -1645,10 +1664,14 @@ static int p54_start(struct ieee80211_hw
 	err = p54_init_stats(dev);
 	if (err)
 		goto out;
-	err = p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
-	if (err)
-		goto out;
+
+	memset(priv->bssid, ~0, ETH_ALEN);
 	priv->mode = NL80211_IFTYPE_MONITOR;
+	err = p54_setup_mac(dev);
+	if (err) {
+		priv->mode = NL80211_IFTYPE_UNSPECIFIED;
+		goto out;
+	}
 
 out:
 	mutex_unlock(&priv->conf_mutex);
@@ -1701,27 +1724,8 @@ static int p54_add_interface(struct ieee
 	}
 
 	memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
-
-	p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
-
-	switch (conf->type) {
-	case NL80211_IFTYPE_STATION:
-		p54_setup_mac(dev, P54_FILTER_TYPE_STATION, NULL);
-		break;
-	case NL80211_IFTYPE_AP:
-		p54_setup_mac(dev, P54_FILTER_TYPE_AP, priv->mac_addr);
-		break;
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
-		p54_setup_mac(dev, P54_FILTER_TYPE_IBSS, NULL);
-		break;
-	default:
-		BUG();	/* impossible */
-		break;
-	}
-
+	p54_setup_mac(dev);
 	p54_set_leds(dev, 1, 0, 0);
-
 	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
@@ -1734,9 +1738,10 @@ static void p54_remove_interface(struct 
 	mutex_lock(&priv->conf_mutex);
 	if (priv->cached_beacon)
 		p54_tx_cancel(dev, priv->cached_beacon);
-	p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
 	priv->mode = NL80211_IFTYPE_MONITOR;
 	memset(priv->mac_addr, 0, ETH_ALEN);
+	memset(priv->bssid, 0, ETH_ALEN);
+	p54_setup_mac(dev);
 	mutex_unlock(&priv->conf_mutex);
 }
 
@@ -1747,11 +1752,21 @@ static int p54_config(struct ieee80211_h
 	struct ieee80211_conf *conf = &dev->conf;
 
 	mutex_lock(&priv->conf_mutex);
-	priv->rx_antenna = 2; /* automatic */
-	priv->output_power = conf->power_level << 2;
-	ret = p54_set_freq(dev, conf->channel->center_freq);
-	if (!ret)
-		ret = p54_set_edcf(dev);
+	if (changed & IEEE80211_CONF_CHANGE_POWER)
+		priv->output_power = conf->power_level << 2;
+	if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED) {
+		ret = p54_setup_mac(dev);
+		if (ret)
+			goto out;
+	}
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		ret = p54_scan(dev, P54_SCAN_EXIT, 0,
+			       conf->channel->center_freq);
+		if (ret)
+			goto out;
+	}
+
+out:
 	mutex_unlock(&priv->conf_mutex);
 	return ret;
 }
@@ -1764,36 +1779,31 @@ static int p54_config_interface(struct i
 	int ret = 0;
 
 	mutex_lock(&priv->conf_mutex);
-	switch (priv->mode) {
-	case NL80211_IFTYPE_STATION:
-		ret = p54_setup_mac(dev, P54_FILTER_TYPE_STATION, conf->bssid);
+	if (conf->changed & IEEE80211_IFCC_BSSID) {
+		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+		ret = p54_setup_mac(dev);
 		if (ret)
 			goto out;
-		ret = p54_set_leds(dev, 1,
-				   !is_multicast_ether_addr(conf->bssid), 0);
+	}
+
+	if (conf->changed & IEEE80211_IFCC_BEACON) {
+		ret = p54_scan(dev, P54_SCAN_EXIT, 0,
+			       dev->conf.channel->center_freq);
 		if (ret)
 			goto out;
-		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
-		break;
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
-		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
-		ret = p54_set_freq(dev, dev->conf.channel->center_freq);
+		ret = p54_setup_mac(dev);
 		if (ret)
 			goto out;
-		ret = p54_setup_mac(dev, priv->mac_mode, priv->bssid);
+		ret = p54_beacon_update(dev, vif);
+		if (ret)
+			goto out;
+		ret = p54_set_edcf(dev);
 		if (ret)
 			goto out;
-		if (conf->changed & IEEE80211_IFCC_BEACON) {
-			ret = p54_beacon_update(dev, vif);
-			if (ret)
-				goto out;
-			ret = p54_set_edcf(dev);
-			if (ret)
-				goto out;
-		}
 	}
+
+	ret = p54_set_leds(dev, 1, !is_multicast_ether_addr(priv->bssid), 0);
+
 out:
 	mutex_unlock(&priv->conf_mutex);
 	return ret;
@@ -1806,25 +1816,14 @@ static void p54_configure_filter(struct 
 {
 	struct p54_common *priv = dev->priv;
 
-	*total_flags &= FIF_BCN_PRBRESP_PROMISC |
-			FIF_PROMISC_IN_BSS |
-			FIF_FCSFAIL;
+	*total_flags &= FIF_PROMISC_IN_BSS |
+			(*total_flags & FIF_PROMISC_IN_BSS) ?
+				FIF_FCSFAIL : 0;
 
 	priv->filter_flags = *total_flags;
 
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			p54_setup_mac(dev, priv->mac_mode, NULL);
-		else
-			p54_setup_mac(dev, priv->mac_mode, priv->bssid);
-	}
-
-	if (changed_flags & FIF_PROMISC_IN_BSS) {
-		if (*total_flags & FIF_PROMISC_IN_BSS)
-			p54_setup_mac(dev, priv->mac_mode | 0x8, NULL);
-		else
-			p54_setup_mac(dev, priv->mac_mode & ~0x8, priv->bssid);
-	}
+	if (changed_flags & FIF_PROMISC_IN_BSS)
+		p54_setup_mac(dev);
 }
 
 static int p54_conf_tx(struct ieee80211_hw *dev, u16 queue,
@@ -1921,16 +1920,17 @@ static void p54_bss_info_changed(struct 
 			priv->basic_rate_mask = (info->basic_rates << 4);
 		else
 			priv->basic_rate_mask = info->basic_rates;
-		p54_setup_mac(dev, priv->mac_mode, priv->bssid);
+		p54_setup_mac(dev);
 		if (priv->fw_var >= 0x500)
-			p54_set_freq(dev, dev->conf.channel->center_freq);
+			p54_scan(dev, P54_SCAN_EXIT, 0,
+				 dev->conf.channel->center_freq);
 	}
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (info->assoc) {
 			priv->aid = info->aid;
 			priv->wakeup_timer = info->beacon_int *
 					     info->dtim_period * 5;
-			p54_setup_mac(dev, priv->mac_mode, priv->bssid);
+			p54_setup_mac(dev);
 		}
 	}
 
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-11-26 14:45:57.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2008-11-26 21:32:21.000000000 +0100
@@ -85,7 +85,6 @@ struct p54_common {
 	struct mutex conf_mutex;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
-	u16 mac_mode;
 	struct pda_iq_autocal_entry *iq_autocal;
 	unsigned int iq_autocal_len;
 	struct pda_channel_output_limit *output_limit;
@@ -95,7 +94,6 @@ struct p54_common {
 	bool use_short_slot;
 	u16 rxhw;
 	u8 version;
-	u8 rx_antenna;
 	unsigned int tx_hdr_len;
 	unsigned int fw_var;
 	unsigned int fw_interface;
