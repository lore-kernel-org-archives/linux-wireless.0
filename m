Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34730 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbZFAM3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 08:29:52 -0400
Subject: [PATCH] mac80211_hwsim: remove deprecated radio_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 14:29:52 +0200
Message-Id: <1243859392.5299.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the use of the deprecated radio_enabled setting
and code associated with that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-06-01 14:26:51.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-06-01 14:28:40.000000000 +0200
@@ -280,7 +280,6 @@ struct mac80211_hwsim_data {
 	struct ieee80211_rate rates[ARRAY_SIZE(hwsim_rates)];
 
 	struct ieee80211_channel *channel;
-	int radio_enabled;
 	unsigned long beacon_int; /* in jiffies unit */
 	unsigned int rx_filter;
 	int started;
@@ -418,8 +417,7 @@ static bool mac80211_hwsim_tx_frame(stru
 		if (data == data2)
 			continue;
 
-		if (!data2->started || !data2->radio_enabled ||
-		    !hwsim_ps_rx_ok(data2, skb) ||
+		if (!data2->started || !hwsim_ps_rx_ok(data2, skb) ||
 		    data->channel->center_freq != data2->channel->center_freq ||
 		    !(data->group & data2->group))
 			continue;
@@ -441,7 +439,6 @@ static bool mac80211_hwsim_tx_frame(stru
 
 static int mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	struct mac80211_hwsim_data *data = hw->priv;
 	bool ack;
 	struct ieee80211_tx_info *txi;
 
@@ -453,13 +450,6 @@ static int mac80211_hwsim_tx(struct ieee
 		return NETDEV_TX_OK;
 	}
 
-	if (!data->radio_enabled) {
-		printk(KERN_DEBUG "%s: dropped TX frame since radio "
-		       "disabled\n", wiphy_name(hw->wiphy));
-		dev_kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
-
 	ack = mac80211_hwsim_tx_frame(hw, skb);
 
 	txi = IEEE80211_SKB_CB(skb);
@@ -546,7 +536,7 @@ static void mac80211_hwsim_beacon(unsign
 	struct ieee80211_hw *hw = (struct ieee80211_hw *) arg;
 	struct mac80211_hwsim_data *data = hw->priv;
 
-	if (!data->started || !data->radio_enabled)
+	if (!data->started)
 		return;
 
 	ieee80211_iterate_active_interfaces_atomic(
@@ -562,15 +552,14 @@ static int mac80211_hwsim_config(struct 
 	struct mac80211_hwsim_data *data = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 
-	printk(KERN_DEBUG "%s:%s (freq=%d radio_enabled=%d idle=%d ps=%d)\n",
+	printk(KERN_DEBUG "%s:%s (freq=%d idle=%d ps=%d)\n",
 	       wiphy_name(hw->wiphy), __func__,
-	       conf->channel->center_freq, conf->radio_enabled,
+	       conf->channel->center_freq,
 	       !!(conf->flags & IEEE80211_CONF_IDLE),
 	       !!(conf->flags & IEEE80211_CONF_PS));
 
 	data->channel = conf->channel;
-	data->radio_enabled = conf->radio_enabled;
-	if (!data->started || !data->radio_enabled || !data->beacon_int)
+	if (!data->started || !data->beacon_int)
 		del_timer(&data->beacon_timer);
 	else
 		mod_timer(&data->beacon_timer, jiffies + data->beacon_int);
@@ -787,8 +776,7 @@ static void hwsim_send_ps_poll(void *dat
 	pspoll->aid = cpu_to_le16(0xc000 | vp->aid);
 	memcpy(pspoll->bssid, vp->bssid, ETH_ALEN);
 	memcpy(pspoll->ta, mac, ETH_ALEN);
-	if (data->radio_enabled &&
-	    !mac80211_hwsim_tx_frame(data->hw, skb))
+	if (!mac80211_hwsim_tx_frame(data->hw, skb))
 		printk(KERN_DEBUG "%s: PS-Poll frame not ack'ed\n", __func__);
 	dev_kfree_skb(skb);
 }
@@ -819,8 +807,7 @@ static void hwsim_send_nullfunc(struct m
 	memcpy(hdr->addr1, vp->bssid, ETH_ALEN);
 	memcpy(hdr->addr2, mac, ETH_ALEN);
 	memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
-	if (data->radio_enabled &&
-	    !mac80211_hwsim_tx_frame(data->hw, skb))
+	if (!mac80211_hwsim_tx_frame(data->hw, skb))
 		printk(KERN_DEBUG "%s: nullfunc frame not ack'ed\n", __func__);
 	dev_kfree_skb(skb);
 }


