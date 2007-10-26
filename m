Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3984 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbXJZVHa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:07:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: store channel info in sta_bss_list
Date: Fri, 26 Oct 2007 17:04:31 -0400
Message-Id: <11934326812028-git-send-email-linville@tuxdriver.com> (sfid-20071026_220734_124257_1753A2D4)
In-Reply-To: <1193432681145-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
 <11934326803330-git-send-email-linville@tuxdriver.com>
 <11934326811535-git-send-email-linville@tuxdriver.com>
 <11934326813508-git-send-email-linville@tuxdriver.com>
 <1193432681145-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@tuxdriver.com>

Some AP equipment "in the wild" uses the same BSSID on multiple channels
(particularly "a" vs. "b/g").  This patch changes the key of sta_bss_list
to include both the BSSID and the channel so as to prevent a BSSID on
one channel from eclipsing the same BSSID on another channel.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_sta.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index ae74c79..1991daa 100644
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
@@ -387,6 +387,7 @@ static void ieee80211_set_associated(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta, int assoc)
 {
 	union iwreq_data wrqu;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (ifsta->associated == assoc)
@@ -401,7 +402,8 @@ static void ieee80211_set_associated(struct net_device *dev,
 		if (sdata->type != IEEE80211_IF_TYPE_STA)
 			return;
 
-		bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
+		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+					   local->hw.conf.channel);
 		if (bss) {
 			if (bss->has_erp_value)
 				ieee80211_handle_erp_ie(dev, bss->erp_value);
@@ -543,7 +545,7 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME |
 			WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
+	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel);
 	if (bss) {
 		if (bss->capability & WLAN_CAPABILITY_PRIVACY)
 			capab |= WLAN_CAPABILITY_PRIVACY;
@@ -695,6 +697,7 @@ static void ieee80211_send_disassoc(struct net_device *dev,
 static int ieee80211_privacy_mismatch(struct net_device *dev,
 				      struct ieee80211_if_sta *ifsta)
 {
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 	int res = 0;
 
@@ -702,7 +705,7 @@ static int ieee80211_privacy_mismatch(struct net_device *dev,
 	    ifsta->key_mgmt != IEEE80211_KEY_MGMT_NONE)
 		return 0;
 
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
+	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel);
 	if (!bss)
 		return 0;
 
@@ -1211,7 +1214,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 	 * update our stored copy */
 	if (elems.erp_info && elems.erp_info_len >= 1) {
 		struct ieee80211_sta_bss *bss
-			= ieee80211_rx_bss_get(dev, ifsta->bssid);
+			= ieee80211_rx_bss_get(dev, ifsta->bssid,
+					       local->hw.conf.channel);
 		if (bss) {
 			bss->erp_value = elems.erp_info[0];
 			bss->has_erp_value = 1;
@@ -1241,7 +1245,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 			       " AP\n", dev->name);
 			return;
 		}
-		bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
+		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+					   local->hw.conf.channel);
 		if (bss) {
 			sta->last_rssi = bss->rssi;
 			sta->last_signal = bss->signal;
@@ -1322,7 +1327,7 @@ static void __ieee80211_rx_bss_hash_del(struct net_device *dev,
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid)
+ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int channel)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
@@ -1333,6 +1338,7 @@ ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid)
 	atomic_inc(&bss->users);
 	atomic_inc(&bss->users);
 	memcpy(bss->bssid, bssid, ETH_ALEN);
+	bss->channel = channel;
 
 	spin_lock_bh(&local->sta_bss_lock);
 	/* TODO: order by RSSI? */
@@ -1344,7 +1350,7 @@ ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid)
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid)
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
@@ -1352,7 +1358,8 @@ ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid)
 	spin_lock_bh(&local->sta_bss_lock);
 	bss = local->sta_bss_hash[STA_HASH(bssid)];
 	while (bss) {
-		if (memcmp(bss->bssid, bssid, ETH_ALEN) == 0) {
+		if (memcmp(bss->bssid, bssid, ETH_ALEN) == 0 &&
+		    bss->channel == channel) {
 			atomic_inc(&bss->users);
 			break;
 		}
@@ -1520,9 +1527,9 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
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
@@ -1622,7 +1629,6 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 
 
 	bss->hw_mode = rx_status->phymode;
-	bss->channel = channel;
 	bss->freq = rx_status->freq;
 	if (channel != rx_status->channel &&
 	    (bss->hw_mode == MODE_IEEE80211G ||
@@ -2355,7 +2361,7 @@ static int ieee80211_sta_create_ibss(struct net_device *dev,
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID " MAC_FMT "\n",
 	       dev->name, MAC_ARG(bssid));
 
-	bss = ieee80211_rx_bss_add(dev, bssid);
+	bss = ieee80211_rx_bss_add(dev, bssid, local->hw.conf.channel);
 	if (!bss)
 		return -ENOMEM;
 
@@ -2366,7 +2372,6 @@ static int ieee80211_sta_create_ibss(struct net_device *dev,
 		local->hw.conf.beacon_int = 100;
 	bss->beacon_int = local->hw.conf.beacon_int;
 	bss->hw_mode = local->hw.conf.phymode;
-	bss->channel = local->hw.conf.channel;
 	bss->freq = local->hw.conf.freq;
 	bss->last_update = jiffies;
 	bss->capability = WLAN_CAPABILITY_IBSS;
@@ -2426,7 +2431,7 @@ static int ieee80211_sta_find_ibss(struct net_device *dev,
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

