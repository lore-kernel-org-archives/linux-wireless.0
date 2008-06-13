Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:57075 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYFMQs7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 12:48:59 -0400
Message-Id: <20080613164809.909165412@localhost> (sfid-20080613_184901_726349_B3A77BE6)
References: <20080613164445.542630279@localhost>
Date: Fri, 13 Jun 2008 19:44:48 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211_hwsim: Shared TX code for received frames and Beacons
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a shared function for transmitting the frames instead of
duplicated code in two places.

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: wireless-testing/drivers/net/wireless/mac80211_hwsim.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c
@@ -144,31 +144,14 @@ static void mac80211_hwsim_monitor_rx(st
 }
 
 
-static int mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static int mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
+				   struct sk_buff *skb)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
-	struct ieee80211_rx_status rx_status;
 	int i, ack = 0;
-	struct ieee80211_hdr *hdr;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_tx_info *txi;
-
-	mac80211_hwsim_monitor_rx(hw, skb);
-
-	if (skb->len < 10) {
-		/* Should not happen; just a sanity check for addr1 use */
-		dev_kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
-
-	if (!data->radio_enabled) {
-		printk(KERN_DEBUG "%s: dropped TX frame since radio "
-		       "disabled\n", wiphy_name(hw->wiphy));
-		dev_kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
-
-	hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_rx_status rx_status;
 
 	memset(&rx_status, 0, sizeof(rx_status));
 	/* TODO: set mactime */
@@ -199,6 +182,33 @@ static int mac80211_hwsim_tx(struct ieee
 		ieee80211_rx_irqsafe(hwsim_radios[i], nskb, &rx_status);
 	}
 
+	return ack;
+}
+
+
+static int mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct mac80211_hwsim_data *data = hw->priv;
+	int ack;
+	struct ieee80211_tx_info *txi;
+
+	mac80211_hwsim_monitor_rx(hw, skb);
+
+	if (skb->len < 10) {
+		/* Should not happen; just a sanity check for addr1 use */
+		dev_kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	if (!data->radio_enabled) {
+		printk(KERN_DEBUG "%s: dropped TX frame since radio "
+		       "disabled\n", wiphy_name(hw->wiphy));
+		dev_kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	ack = mac80211_hwsim_tx_frame(hw, skb);
+
 	txi = IEEE80211_SKB_CB(skb);
 	memset(&txi->status, 0, sizeof(txi->status));
 	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK)) {
@@ -254,10 +264,7 @@ static void mac80211_hwsim_beacon_tx(voi
 				     struct ieee80211_vif *vif)
 {
 	struct ieee80211_hw *hw = arg;
-	struct mac80211_hwsim_data *data = hw->priv;
 	struct sk_buff *skb;
-	struct ieee80211_rx_status rx_status;
-	int i;
 	struct ieee80211_tx_info *info;
 
 	if (vif->type != IEEE80211_IF_TYPE_AP)
@@ -269,33 +276,7 @@ static void mac80211_hwsim_beacon_tx(voi
 	info = IEEE80211_SKB_CB(skb);
 
 	mac80211_hwsim_monitor_rx(hw, skb);
-
-	memset(&rx_status, 0, sizeof(rx_status));
-	/* TODO: set mactime */
-	rx_status.freq = data->channel->center_freq;
-	rx_status.band = data->channel->band;
-	rx_status.rate_idx = info->tx_rate_idx;
-	/* TODO: simulate signal strength (and optional packet drop) */
-
-	/* Copy skb to all enabled radios that are on the current frequency */
-	for (i = 0; i < hwsim_radio_count; i++) {
-		struct mac80211_hwsim_data *data2;
-		struct sk_buff *nskb;
-
-		if (hwsim_radios[i] == NULL || hwsim_radios[i] == hw)
-			continue;
-		data2 = hwsim_radios[i]->priv;
-		if (!data2->started || !data2->radio_enabled ||
-		    data->channel->center_freq != data2->channel->center_freq)
-			continue;
-
-		nskb = skb_copy(skb, GFP_ATOMIC);
-		if (nskb == NULL)
-			continue;
-
-		ieee80211_rx_irqsafe(hwsim_radios[i], nskb, &rx_status);
-	}
-
+	mac80211_hwsim_tx_frame(hw, skb);
 	dev_kfree_skb(skb);
 }
 

--

-- 
Jouni Malinen                                            PGP id EFC895FA
