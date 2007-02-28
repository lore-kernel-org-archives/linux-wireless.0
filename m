Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbXB1OKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:10:31 -0500
Subject: [PATCH] fix cfg80211 deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 28 Feb 2007 15:10:01 +0100
Message-Id: <1172671802.5015.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My patch titled

	[PATCH] make cfg80211 manage wiphy netdev list

introduced a deadlock in cfg80211 when adding or removing interfaces.
The deadlock happens because I used the same mutex for making sure that
no two calls are in progress as for managing the list. This patch fixes
it by using a separate mutex for the list.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/wireless/core.c    |   10 ++++++----
 net/wireless/core.h    |    1 +
 net/wireless/nl80211.c |   11 +++++++++--
 3 files changed, 16 insertions(+), 6 deletions(-)

--- wireless-dev.orig/net/wireless/core.c	2007-02-28 14:55:22.406381760 +0100
+++ wireless-dev/net/wireless/core.c	2007-02-28 14:55:28.646381760 +0100
@@ -170,6 +170,7 @@ struct wiphy *wiphy_new(struct cfg80211_
 	mutex_unlock(&cfg80211_drv_mutex);
 
 	mutex_init(&drv->mtx);
+	mutex_init(&drv->devlist_mtx);
 	INIT_LIST_HEAD(&drv->netdev_list);
 
 	device_initialize(&drv->wiphy.dev);
@@ -228,6 +229,7 @@ EXPORT_SYMBOL(wiphy_unregister);
 void cfg80211_dev_free(struct cfg80211_registered_device *drv)
 {
 	mutex_destroy(&drv->mtx);
+	mutex_destroy(&drv->devlist_mtx);
 	kfree(drv);
 }
 
@@ -251,20 +253,20 @@ static int cfg80211_netdev_notifier_call
 
 	switch (state) {
 	case NETDEV_REGISTER:
-		mutex_lock(&rdev->mtx);
+		mutex_lock(&rdev->devlist_mtx);
 		list_add(&dev->ieee80211_ptr->list, &rdev->netdev_list);
 		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
 				      "phy80211")) {
 			printk(KERN_ERR "wireless: failed to add phy80211 symlink to netdev!\n");
 		}
 		dev->ieee80211_ptr->netdev = dev;
-		mutex_unlock(&rdev->mtx);
+		mutex_unlock(&rdev->devlist_mtx);
 		break;
 	case NETDEV_UNREGISTER:
-		mutex_lock(&rdev->mtx);
+		mutex_lock(&rdev->devlist_mtx);
 		sysfs_remove_link(&dev->dev.kobj, "phy80211");
 		list_del(&dev->ieee80211_ptr->list);
-		mutex_unlock(&rdev->mtx);
+		mutex_unlock(&rdev->devlist_mtx);
 		break;
 	}
 
--- wireless-dev.orig/net/wireless/core.h	2007-02-28 14:55:22.436381760 +0100
+++ wireless-dev/net/wireless/core.h	2007-02-28 14:55:28.646381760 +0100
@@ -25,6 +25,7 @@ struct cfg80211_registered_device {
 	int idx;
 
 	/* associate netdev list */
+	struct mutex devlist_mtx;
 	struct list_head netdev_list;
 
 	/* must be last because of the way we do wiphy_priv(),
--- wireless-dev.orig/net/wireless/nl80211.c	2007-02-28 14:55:22.376381760 +0100
+++ wireless-dev/net/wireless/nl80211.c	2007-02-28 14:55:28.646381760 +0100
@@ -248,10 +248,17 @@ static int nl80211_get_intfs(struct sk_b
 	}
 
 	array_idx = 1;
+	err = 0;
+	mutex_lock(&drv->devlist_mtx);
 	list_for_each_entry(wdev, &drv->netdev_list, list) {
-		if (addifidx(wdev->netdev, msg, &array_idx))
-			goto msg_free;
+		err = addifidx(wdev->netdev, msg, &array_idx);
+		if (err)
+			break;
 	}
+	mutex_unlock(&drv->devlist_mtx);
+	if (err)
+		goto msg_free;
+
 	nla_nest_end(msg, start);
 
 	genlmsg_end(msg, hdr);


