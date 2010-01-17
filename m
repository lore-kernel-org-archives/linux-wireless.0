Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab0AQOtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 09:49:10 -0500
Subject: [PATCH] cfg80211: rcu-ify rdev and wdev
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Jan 2010 15:49:02 +0100
Message-ID: <1263739742.28067.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Future code will need to look up rdev and wdev
within atomic sections, but currently we need
to lock a mutex for such lookups. Change the
list handling for both to be RCU-safe so that
we can look them up in rcu sections instead in
the future.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |   26 +++++++++++++++-----------
 net/wireless/core.h |    3 ++-
 2 files changed, 17 insertions(+), 12 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2010-01-17 01:58:02.000000000 +0100
+++ wireless-testing/net/wireless/core.c	2010-01-17 02:13:45.000000000 +0100
@@ -1,7 +1,7 @@
 /*
  * This is the linux wireless configuration interface.
  *
- * Copyright 2006-2009		Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  */
 
 #include <linux/if.h>
@@ -31,15 +31,10 @@ MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("wireless configuration support");
 
-/* RCU might be appropriate here since we usually
- * only read the list, and that can happen quite
- * often because we need to do it for each command */
+/* RCU-protected (and cfg80211_mutex for writers) */
 LIST_HEAD(cfg80211_rdev_list);
 int cfg80211_rdev_list_generation;
 
-/*
- * This is used to protect the cfg80211_rdev_list
- */
 DEFINE_MUTEX(cfg80211_mutex);
 
 /* for debugfs */
@@ -477,7 +472,7 @@ int wiphy_register(struct wiphy *wiphy)
 	/* set up regulatory info */
 	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
-	list_add(&rdev->list, &cfg80211_rdev_list);
+	list_add_rcu(&rdev->list, &cfg80211_rdev_list);
 	cfg80211_rdev_list_generation++;
 
 	mutex_unlock(&cfg80211_mutex);
@@ -554,7 +549,8 @@ void wiphy_unregister(struct wiphy *wiph
 	 * it impossible to find from userspace.
 	 */
 	debugfs_remove_recursive(rdev->wiphy.debugfsdir);
-	list_del(&rdev->list);
+	list_del_rcu(&rdev->list);
+	synchronize_rcu();
 
 	/*
 	 * Try to grab rdev->mtx. If a command is still in progress,
@@ -670,7 +666,7 @@ static int cfg80211_netdev_notifier_call
 		INIT_LIST_HEAD(&wdev->event_list);
 		spin_lock_init(&wdev->event_lock);
 		mutex_lock(&rdev->devlist_mtx);
-		list_add(&wdev->list, &rdev->netdev_list);
+		list_add_rcu(&wdev->list, &rdev->netdev_list);
 		rdev->devlist_generation++;
 		/* can only change netns with wiphy */
 		dev->features |= NETIF_F_NETNS_LOCAL;
@@ -782,13 +778,21 @@ static int cfg80211_netdev_notifier_call
 		 */
 		if (!list_empty(&wdev->list)) {
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
-			list_del_init(&wdev->list);
+			list_del_rcu(&wdev->list);
 			rdev->devlist_generation++;
 #ifdef CONFIG_CFG80211_WEXT
 			kfree(wdev->wext.keys);
 #endif
 		}
 		mutex_unlock(&rdev->devlist_mtx);
+		/*
+		 * synchronise (so that we won't find this netdev
+		 * from other code any more) and then clear the list
+		 * head so that the above code can safely check for
+		 * !list_empty() to avoid double-cleanup.
+		 */
+		synchronize_rcu();
+		INIT_LIST_HEAD(&wdev->list);
 		break;
 	case NETDEV_PRE_UP:
 		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
--- wireless-testing.orig/net/wireless/core.h	2010-01-17 01:58:02.000000000 +0100
+++ wireless-testing/net/wireless/core.h	2010-01-17 02:13:49.000000000 +0100
@@ -1,7 +1,7 @@
 /*
  * Wireless configuration interface internals.
  *
- * Copyright 2006-2009	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  */
 #ifndef __NET_WIRELESS_CORE_H
 #define __NET_WIRELESS_CORE_H
@@ -48,6 +48,7 @@ struct cfg80211_registered_device {
 
 	/* associate netdev list */
 	struct mutex devlist_mtx;
+	/* protected by devlist_mtx or RCU */
 	struct list_head netdev_list;
 	int devlist_generation;
 	int opencount; /* also protected by devlist_mtx */


