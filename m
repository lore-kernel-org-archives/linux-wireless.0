Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:44062 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeIMRV3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 13:21:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: combine duplicate wdev init code
Date: Thu, 13 Sep 2018 14:12:03 +0200
Message-Id: <20180913121203.10553-1-johannes@sipsolutions.net> (sfid-20180913_141220_210807_663EFC18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a bit of duplicated code to initialize a wdev, pull it out
into a separate function to call from both places.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    | 40 +++++++++++++++++++++++-----------------
 net/wireless/core.h    |  3 +++
 net/wireless/nl80211.c | 10 +---------
 3 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 1e5f7d4e4666..85724527bad9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1181,6 +1181,28 @@ void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_stop_iface);
 
+void cfg80211_init_wdev(struct cfg80211_registered_device *rdev,
+			struct wireless_dev *wdev)
+{
+	mutex_init(&wdev->mtx);
+	INIT_LIST_HEAD(&wdev->event_list);
+	spin_lock_init(&wdev->event_lock);
+	INIT_LIST_HEAD(&wdev->mgmt_registrations);
+	spin_lock_init(&wdev->mgmt_registrations_lock);
+
+	/*
+	 * We get here also when the interface changes network namespaces,
+	 * as it's registered into the new one, but we don't want it to
+	 * change ID in that case. Checking if the ID is already assigned
+	 * works, because 0 isn't considered a valid ID and the memory is
+	 * 0-initialized.
+	 */
+	if (!wdev->identifier)
+		wdev->identifier = ++rdev->wdev_id;
+	list_add_rcu(&wdev->list, &rdev->wiphy.wdev_list);
+	rdev->devlist_generation++;
+}
+
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state, void *ptr)
 {
@@ -1206,23 +1228,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 * called within code protected by it when interfaces
 		 * are added with nl80211.
 		 */
-		mutex_init(&wdev->mtx);
-		INIT_LIST_HEAD(&wdev->event_list);
-		spin_lock_init(&wdev->event_lock);
-		INIT_LIST_HEAD(&wdev->mgmt_registrations);
-		spin_lock_init(&wdev->mgmt_registrations_lock);
-
-		/*
-		 * We get here also when the interface changes network namespaces,
-		 * as it's registered into the new one, but we don't want it to
-		 * change ID in that case. Checking if the ID is already assigned
-		 * works, because 0 isn't considered a valid ID and the memory is
-		 * 0-initialized.
-		 */
-		if (!wdev->identifier)
-			wdev->identifier = ++rdev->wdev_id;
-		list_add_rcu(&wdev->list, &rdev->wiphy.wdev_list);
-		rdev->devlist_generation++;
+		cfg80211_init_wdev(rdev, wdev);
 		/* can only change netns with wiphy */
 		dev->features |= NETIF_F_NETNS_LOCAL;
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 7f52ef569320..45fd4e21dbda 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -187,6 +187,9 @@ struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx);
 int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			  struct net *net);
 
+void cfg80211_init_wdev(struct cfg80211_registered_device *rdev,
+			struct wireless_dev *wdev);
+
 static inline void wdev_lock(struct wireless_dev *wdev)
 	__acquires(wdev)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 271f3cd77066..79e1e4c7d5bf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3368,15 +3368,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		 * P2P Device and NAN do not have a netdev, so don't go
 		 * through the netdev notifier and must be added here
 		 */
-		mutex_init(&wdev->mtx);
-		INIT_LIST_HEAD(&wdev->event_list);
-		spin_lock_init(&wdev->event_lock);
-		INIT_LIST_HEAD(&wdev->mgmt_registrations);
-		spin_lock_init(&wdev->mgmt_registrations_lock);
-
-		wdev->identifier = ++rdev->wdev_id;
-		list_add_rcu(&wdev->list, &rdev->wiphy.wdev_list);
-		rdev->devlist_generation++;
+		cfg80211_init_wdev(rdev, wdev);
 		break;
 	default:
 		break;
-- 
2.14.4
