Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYIHPpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:45:38 -0400
Message-Id: <20080908154441.240689000@sipsolutions.net> (sfid-20080908_174542_464315_6AA49C8B)
References: <20080908154421.216772000@sipsolutions.net>
Date: Mon, 08 Sep 2008 17:44:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] mac80211: use sdata pointer for scan interface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we now use sdata pointers most of the time, using a netdev
pointer here is somewhat artificial, use an sdata pointer instead.
Replace a netdev-prefix in a few messages by a wiphy-prefix.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/main.c        |    2 +-
 net/mac80211/mlme.c        |   24 +++++++++++-------------
 3 files changed, 13 insertions(+), 15 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-08 15:37:15.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-08 15:42:38.000000000 +0200
@@ -636,7 +636,7 @@ struct ieee80211_local {
 	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
 	unsigned long last_scan_completed;
 	struct delayed_work scan_work;
-	struct net_device *scan_dev;
+	struct ieee80211_sub_if_data *scan_sdata;
 	struct ieee80211_channel *oper_channel, *scan_channel;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
--- everything.orig/net/mac80211/main.c	2008-09-08 15:37:15.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-08 15:42:38.000000000 +0200
@@ -551,7 +551,7 @@ static int ieee80211_stop(struct net_dev
 		synchronize_rcu();
 		skb_queue_purge(&sdata->u.sta.skb_queue);
 
-		if (local->scan_dev == sdata->dev) {
+		if (local->scan_sdata == sdata) {
 			if (!local->ops->hw_scan) {
 				local->sta_sw_scanning = 0;
 				cancel_delayed_work(&local->scan_work);
--- everything.orig/net/mac80211/mlme.c	2008-09-08 15:42:36.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 15:42:38.000000000 +0200
@@ -3508,19 +3508,18 @@ static void ieee80211_restart_sta_timer(
 void ieee80211_scan_completed(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct net_device *dev = local->scan_dev;
 	struct ieee80211_sub_if_data *sdata;
 	union iwreq_data wrqu;
 
 	local->last_scan_completed = jiffies;
 	memset(&wrqu, 0, sizeof(wrqu));
-	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
+	wireless_send_event(local->scan_sdata->dev, SIOCGIWSCAN, &wrqu, NULL);
 
 	if (local->sta_hw_scanning) {
 		local->sta_hw_scanning = 0;
 		if (ieee80211_hw_config(local))
 			printk(KERN_DEBUG "%s: failed to restore operational "
-			       "channel after scan\n", dev->name);
+			       "channel after scan\n", wiphy_name(local->hw.wiphy));
 		/* Restart STA timer for HW scan case */
 		rcu_read_lock();
 		list_for_each_entry_rcu(sdata, &local->interfaces, list)
@@ -3533,7 +3532,7 @@ void ieee80211_scan_completed(struct iee
 	local->sta_sw_scanning = 0;
 	if (ieee80211_hw_config(local))
 		printk(KERN_DEBUG "%s: failed to restore operational "
-		       "channel after scan\n", dev->name);
+		       "channel after scan\n", wiphy_name(local->hw.wiphy));
 
 
 	netif_tx_lock_bh(local->mdev);
@@ -3563,8 +3562,8 @@ void ieee80211_scan_completed(struct iee
 	}
 	rcu_read_unlock();
 
-done:
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+ done:
+	sdata = local->scan_sdata;
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
@@ -3579,8 +3578,7 @@ void ieee80211_sta_scan_work(struct work
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, scan_work.work);
-	struct net_device *dev = local->scan_dev;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 	int skip;
@@ -3628,7 +3626,7 @@ void ieee80211_sta_scan_work(struct work
 			local->scan_channel = chan;
 			if (ieee80211_hw_config(local)) {
 				printk(KERN_DEBUG "%s: failed to set freq to "
-				       "%d MHz for scan\n", dev->name,
+				       "%d MHz for scan\n", wiphy_name(local->hw.wiphy),
 				       chan->center_freq);
 				skip = 1;
 			}
@@ -3698,7 +3696,7 @@ static int ieee80211_sta_start_scan(stru
 	 */
 
 	if (local->sta_sw_scanning || local->sta_hw_scanning) {
-		if (local->scan_dev == scan_sdata->dev)
+		if (local->scan_sdata == scan_sdata)
 			return 0;
 		return -EBUSY;
 	}
@@ -3708,7 +3706,7 @@ static int ieee80211_sta_start_scan(stru
 					     ssid, ssid_len);
 		if (!rc) {
 			local->sta_hw_scanning = 1;
-			local->scan_dev = scan_sdata->dev;
+			local->scan_sdata = scan_sdata;
 		}
 		return rc;
 	}
@@ -3735,7 +3733,7 @@ static int ieee80211_sta_start_scan(stru
 	local->scan_state = SCAN_SET_CHANNEL;
 	local->scan_channel_idx = 0;
 	local->scan_band = IEEE80211_BAND_2GHZ;
-	local->scan_dev = scan_sdata->dev;
+	local->scan_sdata = scan_sdata;
 
 	netif_addr_lock_bh(local->mdev);
 	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
@@ -3763,7 +3761,7 @@ int ieee80211_sta_req_scan(struct ieee80
 		return ieee80211_sta_start_scan(sdata, ssid, ssid_len);
 
 	if (local->sta_sw_scanning || local->sta_hw_scanning) {
-		if (local->scan_dev == sdata->dev)
+		if (local->scan_sdata == sdata)
 			return 0;
 		return -EBUSY;
 	}

-- 

