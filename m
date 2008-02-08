Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207AbYBHLFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 06:05:54 -0500
Subject: [PATCH] mac80211: defer master netdev allocation to
	ieee80211_register_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 09:48:13 +0100
Message-Id: <1202460493.5718.28.camel@johannes.berg> (sfid-20080208_110559_952311_403BDA61)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we want to go multiqueue, we will need to know the number of
queues the hardware has for registering the master netdev. This
number is only available in ieee80211_register_hw() rather than
ieee80211_alloc_hw(), so defer allocation of the master device to
ieee80211_register_hw().

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211.c |   72 ++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

--- everything.orig/net/mac80211/ieee80211.c	2008-02-08 09:37:02.531263075 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-08 09:41:04.271263563 +0100
@@ -1372,9 +1372,7 @@ EXPORT_SYMBOL(ieee80211_tx_status);
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
-	struct net_device *mdev;
 	struct ieee80211_local *local;
-	struct ieee80211_sub_if_data *sdata;
 	int priv_size;
 	struct wiphy *wiphy;
 
@@ -1420,22 +1418,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	BUG_ON(!ops->configure_filter);
 	local->ops = ops;
 
-	/* for now, mdev needs sub_if_data :/ */
-	mdev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
-			    "wmaster%d", ether_setup);
-	if (!mdev) {
-		wiphy_free(wiphy);
-		return NULL;
-	}
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(mdev);
-	mdev->ieee80211_ptr = &sdata->wdev;
-	sdata->wdev.wiphy = wiphy;
-
 	local->hw.queues = 1; /* default */
 
-	local->mdev = mdev;
-
 	local->bridge_packets = 1;
 
 	local->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
@@ -1447,26 +1431,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	INIT_LIST_HEAD(&local->interfaces);
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
-	ieee80211_rx_bss_list_init(mdev);
 
 	sta_info_init(local);
 
-	mdev->hard_start_xmit = ieee80211_master_start_xmit;
-	mdev->open = ieee80211_master_open;
-	mdev->stop = ieee80211_master_stop;
-	mdev->type = ARPHRD_IEEE80211;
-	mdev->header_ops = &ieee80211_header_ops;
-	mdev->set_multicast_list = ieee80211_master_set_multicast_list;
-
-	sdata->vif.type = IEEE80211_IF_TYPE_AP;
-	sdata->dev = mdev;
-	sdata->local = local;
-	sdata->u.ap.force_unicast_rateidx = -1;
-	sdata->u.ap.max_ratectrl_rateidx = -1;
-	ieee80211_if_sdata_init(sdata);
-	/* no RCU needed since we're still during init phase */
-	list_add_tail(&sdata->list, &local->interfaces);
-
 	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
 		     (unsigned long)local);
 	tasklet_disable(&local->tx_pending_tasklet);
@@ -1489,6 +1456,8 @@ int ieee80211_register_hw(struct ieee802
 	const char *name;
 	int result;
 	enum ieee80211_band band;
+	struct net_device *mdev;
+	struct ieee80211_sub_if_data *sdata;
 
 	/*
 	 * generic code guarantees at least one band,
@@ -1512,6 +1481,37 @@ int ieee80211_register_hw(struct ieee802
 	if (result < 0)
 		return result;
 
+	/* for now, mdev needs sub_if_data :/ */
+	mdev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
+			    "wmaster%d", ether_setup);
+	if (!mdev)
+		goto fail_mdev_alloc;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(mdev);
+	mdev->ieee80211_ptr = &sdata->wdev;
+	sdata->wdev.wiphy = local->hw.wiphy;
+
+	local->mdev = mdev;
+
+	ieee80211_rx_bss_list_init(mdev);
+
+	mdev->hard_start_xmit = ieee80211_master_start_xmit;
+	mdev->open = ieee80211_master_open;
+	mdev->stop = ieee80211_master_stop;
+	mdev->type = ARPHRD_IEEE80211;
+	mdev->header_ops = &ieee80211_header_ops;
+	mdev->set_multicast_list = ieee80211_master_set_multicast_list;
+
+	sdata->vif.type = IEEE80211_IF_TYPE_AP;
+	sdata->dev = mdev;
+	sdata->local = local;
+	sdata->u.ap.force_unicast_rateidx = -1;
+	sdata->u.ap.max_ratectrl_rateidx = -1;
+	ieee80211_if_sdata_init(sdata);
+
+	/* no RCU needed since we're still during init phase */
+	list_add_tail(&sdata->list, &local->interfaces);
+
 	name = wiphy_dev(local->hw.wiphy)->driver->name;
 	local->hw.workqueue = create_singlethread_workqueue(name);
 	if (!local->hw.workqueue) {
@@ -1603,6 +1603,9 @@ fail_sta_info:
 	debugfs_hw_del(local);
 	destroy_workqueue(local->hw.workqueue);
 fail_workqueue:
+	ieee80211_if_free(local->mdev);
+	local->mdev = NULL;
+fail_mdev_alloc:
 	wiphy_unregister(local->hw.wiphy);
 	return result;
 }
@@ -1663,6 +1666,8 @@ void ieee80211_unregister_hw(struct ieee
 	wiphy_unregister(local->hw.wiphy);
 	ieee80211_wep_free(local);
 	ieee80211_led_exit(local);
+	ieee80211_if_free(local->mdev);
+	local->mdev = NULL;
 }
 EXPORT_SYMBOL(ieee80211_unregister_hw);
 
@@ -1670,7 +1675,6 @@ void ieee80211_free_hw(struct ieee80211_
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	ieee80211_if_free(local->mdev);
 	wiphy_free(local->hw.wiphy);
 }
 EXPORT_SYMBOL(ieee80211_free_hw);


