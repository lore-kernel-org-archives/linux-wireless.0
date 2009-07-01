Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbZGATfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:35:38 -0400
Message-Id: <20090701193419.085720059@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/20 v4] cfg80211: move break statement to correct place
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move a break statement to the correct place _after_ the
#endif, otherwise w/o WIRELESS_EXT things break badly.
Also, while touching this code, do a cleanup and assign
dev->ieee80211_ptr to a new variable.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-07-01 08:55:08.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-01 08:59:44.000000000 +0200
@@ -526,52 +526,53 @@ static int cfg80211_netdev_notifier_call
 					 void *ndev)
 {
 	struct net_device *dev = ndev;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev;
 
-	if (!dev->ieee80211_ptr)
+	if (!wdev)
 		return NOTIFY_DONE;
 
-	rdev = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
+	rdev = wiphy_to_dev(wdev->wiphy);
 
-	WARN_ON(dev->ieee80211_ptr->iftype == NL80211_IFTYPE_UNSPECIFIED);
+	WARN_ON(wdev->iftype == NL80211_IFTYPE_UNSPECIFIED);
 
 	switch (state) {
 	case NETDEV_REGISTER:
 		mutex_lock(&rdev->devlist_mtx);
-		list_add(&dev->ieee80211_ptr->list, &rdev->netdev_list);
+		list_add(&wdev->list, &rdev->netdev_list);
 		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
 				      "phy80211")) {
 			printk(KERN_ERR "wireless: failed to add phy80211 "
 				"symlink to netdev!\n");
 		}
-		dev->ieee80211_ptr->netdev = dev;
+		wdev->netdev = dev;
 #ifdef CONFIG_WIRELESS_EXT
-		dev->ieee80211_ptr->wext.default_key = -1;
-		dev->ieee80211_ptr->wext.default_mgmt_key = -1;
+		wdev->wext.default_key = -1;
+		wdev->wext.default_mgmt_key = -1;
 #endif
 		mutex_unlock(&rdev->devlist_mtx);
 		break;
 	case NETDEV_GOING_DOWN:
-		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC)
+		if (wdev->iftype != NL80211_IFTYPE_ADHOC)
 			break;
-		if (!dev->ieee80211_ptr->ssid_len)
+		if (!wdev->ssid_len)
 			break;
 		cfg80211_leave_ibss(rdev, dev, true);
 		break;
 	case NETDEV_UP:
 #ifdef CONFIG_WIRELESS_EXT
-		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC)
+		if (wdev->iftype != NL80211_IFTYPE_ADHOC)
 			break;
-		if (!dev->ieee80211_ptr->wext.ibss.ssid_len)
+		if (!wdev->wext.ibss.ssid_len)
 			break;
-		cfg80211_join_ibss(rdev, dev, &dev->ieee80211_ptr->wext.ibss);
-		break;
+		cfg80211_join_ibss(rdev, dev, &wdev->wext.ibss);
 #endif
+		break;
 	case NETDEV_UNREGISTER:
 		mutex_lock(&rdev->devlist_mtx);
-		if (!list_empty(&dev->ieee80211_ptr->list)) {
+		if (!list_empty(&wdev->list)) {
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
-			list_del_init(&dev->ieee80211_ptr->list);
+			list_del_init(&wdev->list);
 		}
 		mutex_unlock(&rdev->devlist_mtx);
 		break;

-- 

