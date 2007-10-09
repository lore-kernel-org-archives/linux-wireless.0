Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4228 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbXJJAIp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 20:08:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC PATCH 1/2] mac80211: store channel info in sta_bss_list
Date: Tue,  9 Oct 2007 19:49:58 -0400
Message-Id: <11919737992212-git-send-email-linville@tuxdriver.com> (sfid-20071010_010850_632016_D90D894D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some AP equipment "in the wild" uses the same BSSID on multiple channels
(particularly "a" vs. "b/g").  This patch changes the key of sta_bss_list
to include both the BSSID and the channel so as to prevent a BSSID on
one channel from eclipsing the same BSSID on another channel.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_sta.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 7c93f29..bd11775 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -61,7 +61,7 @@
 static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
 				     u8 *ssid, size_t ssid_len);
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid);
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel);
 static void ieee80211_rx_bss_put(struct net_device *dev,
 				 struct ieee80211_sta_bss *bss);
 static int ieee80211_sta_find_ibss(struct net_device *dev,
@@ -426,7 +426,8 @@ static void ieee80211_set_associated(struct net_device *dev,
 		if (sdata->type != IEEE80211_IF_TYPE_STA)
 			return;
 
-		bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
+		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+					   local->hw.conf.channel);
 		if (bss) {
 			if (bss->has_erp_value)
 				ieee80211_handle_erp_ie(dev, bss->erp_value);
@@ -571,7 +572,7 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME |
 			WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
+	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel);
 	if (bss) {
 		if (bss->capability & WLAN_CAPABILITY_PRIVACY)
 			capab |= WLAN_CAPABILITY_PRIVACY;
@@ -719,6 +720,7 @@ static void ieee80211_send_disassoc(struct net_device *dev,
 static int ieee80211_privacy_mismatch(struct net_device *dev,
 				      struct ieee80211_if_sta *ifsta)
 {
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 	int res = 0;
 
@@ -726,7 +728,7 @@ static int ieee80211_privacy_mismatch(struct net_device *dev,
 	    ifsta->key_management_enabled)
 		return 0;
 
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
+	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel);
 	if (!bss)
 		return 0;
 
@@ -1231,7 +1233,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 	 * update our stored copy */
 	if (elems.erp_info && elems.erp_info_len >= 1) {
 		struct ieee80211_sta_bss *bss
-			= ieee80211_rx_bss_get(dev, ifsta->bssid);
+			= ieee80211_rx_bss_get(dev, ifsta->bssid,
+					       local->hw.conf.channel);
 		if (bss) {
 			bss->erp_value = elems.erp_info[0];
 			bss->has_erp_value = 1;
@@ -1261,7 +1264,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 			       " AP\n", dev->name);
 			return;
 		}
-		bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
+		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+					   local->hw.conf.channel);
 		if (bss) {
 			sta->last_rssi = bss->rssi;
 			sta->last_signal = bss->signal;
@@ -1337,7 +1341,7 @@ static void __ieee80211_rx_bss_hash_del(struct net_device *dev,
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid)
+ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int channel)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
@@ -1348,6 +1352,7 @@ ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid)
 	atomic_inc(&bss->users);
 	atomic_inc(&bss->users);
 	memcpy(bss->bssid, bssid, ETH_ALEN);
+	bss->channel = channel;
 
 	spin_lock_bh(&local->sta_bss_lock);
 	/* TODO: order by RSSI? */
@@ -1359,7 +1364,7 @@ ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid)
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid)
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
@@ -1367,7 +1372,8 @@ ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid)
 	spin_lock_bh(&local->sta_bss_lock);
 	bss = local->sta_bss_hash[STA_HASH(bssid)];
 	while (bss) {
-		if (memcmp(bss->bssid, bssid, ETH_ALEN) == 0) {
+		if (memcmp(bss->bssid, bssid, ETH_ALEN) == 0 &&
+		    bss->channel == channel) {
 			atomic_inc(&bss->users);
 			break;
 		}
@@ -1533,9 +1539,9 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	else
 		channel = rx_status->channel;
 
-	bss = ieee80211_rx_bss_get(dev, mgmt->bssid);
+	bss = ieee80211_rx_bss_get(dev, mgmt->bssid, channel);
 	if (!bss) {
-		bss = ieee80211_rx_bss_add(dev, mgmt->bssid);
+		bss = ieee80211_rx_bss_add(dev, mgmt->bssid, channel);
 		if (!bss)
 			return;
 	} else {
@@ -1635,7 +1641,6 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 
 
 	bss->hw_mode = rx_status->phymode;
-	bss->channel = channel;
 	bss->freq = rx_status->freq;
 	if (channel != rx_status->channel &&
 	    (bss->hw_mode == MODE_IEEE80211G ||
@@ -2379,7 +2384,7 @@ static int ieee80211_sta_create_ibss(struct net_device *dev,
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID " MAC_FMT "\n",
 	       dev->name, MAC_ARG(bssid));
 
-	bss = ieee80211_rx_bss_add(dev, bssid);
+	bss = ieee80211_rx_bss_add(dev, bssid, local->hw.conf.channel);
 	if (!bss)
 		return -ENOMEM;
 
@@ -2390,7 +2395,6 @@ static int ieee80211_sta_create_ibss(struct net_device *dev,
 		local->hw.conf.beacon_int = 100;
 	bss->beacon_int = local->hw.conf.beacon_int;
 	bss->hw_mode = local->hw.conf.phymode;
-	bss->channel = local->hw.conf.channel;
 	bss->freq = local->hw.conf.freq;
 	bss->last_update = jiffies;
 	bss->capability = WLAN_CAPABILITY_IBSS;
@@ -2448,7 +2452,7 @@ static int ieee80211_sta_find_ibss(struct net_device *dev,
 	       MAC_FMT "\n", MAC_ARG(bssid), MAC_ARG(ifsta->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
-	    (bss = ieee80211_rx_bss_get(dev, bssid))) {
+	    (bss = ieee80211_rx_bss_get(dev, bssid, local->hw.conf.channel))) {
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID " MAC_FMT
 		       " based on configured SSID\n",
 		       dev->name, MAC_ARG(bssid));
-- 
1.5.2.4

