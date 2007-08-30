Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbXH3Nae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 09:30:34 -0400
Subject: [PATCH net-2.6.24] cfg80211: use idr layer for wiphy indizes
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 15:31:44 +0200
Message-Id: <1188480704.2963.41.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes cfg80211 use the idr layer instead of keeping
an own list of registered devices. One side effect is that
reloading a module will possibly assign it the same wiphy
index again, but they are obviously not guaranteed to be
stable. Another positive side effect for the code is that
some variables no longer need to be exported and can now
be made static.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
This is the corresponding patch to the one I sent previously but made
apply to net-2.6.24 by removing everything that nl80211 has.

 net/wireless/core.c |   46 ++++++++++++++++++++++++----------------------
 net/wireless/core.h |    7 +++----
 2 files changed, 27 insertions(+), 26 deletions(-)

--- netdev-2.6.orig/net/wireless/core.c	2007-08-22 20:35:27.421906163 +0200
+++ netdev-2.6/net/wireless/core.c	2007-08-30 15:28:08.692051253 +0200
@@ -13,6 +13,7 @@
 #include <linux/debugfs.h>
 #include <linux/notifier.h>
 #include <linux/device.h>
+#include <linux/idr.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include <net/wireless.h>
@@ -26,12 +27,8 @@ MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("wireless configuration support");
 
-/* RCU might be appropriate here since we usually
- * only read the list, and that can happen quite
- * often because we need to do it for each command */
-LIST_HEAD(cfg80211_drv_list);
-DEFINE_MUTEX(cfg80211_drv_mutex);
-static int wiphy_counter;
+static DEFINE_MUTEX(cfg80211_drv_mutex);
+static struct idr cfg80211_drivers;
 
 /* for debugfs */
 static struct dentry *ieee80211_debugfs_dir;
@@ -42,6 +39,7 @@ struct wiphy *wiphy_new(struct cfg80211_
 {
 	struct cfg80211_registered_device *drv;
 	int alloc_size;
+	int res;
 
 	alloc_size = sizeof(*drv) + sizeof_priv;
 
@@ -50,20 +48,14 @@ struct wiphy *wiphy_new(struct cfg80211_
 		return NULL;
 
 	drv->ops = ops;
+	drv->alive = 0;
 
 	mutex_lock(&cfg80211_drv_mutex);
-
-	drv->idx = wiphy_counter;
-
-	/* now increase counter for the next device unless
-	 * it has wrapped previously */
-	if (wiphy_counter >= 0)
-		wiphy_counter++;
-
+	idr_pre_get(&cfg80211_drivers, GFP_KERNEL);
+	res = idr_get_new(&cfg80211_drivers, drv, &drv->idx);
 	mutex_unlock(&cfg80211_drv_mutex);
-
-	if (unlikely(drv->idx < 0)) {
-		/* ugh, wrapped! */
+	if (res) {
+		printk(KERN_ERR "cfg80211: failed to allocate wiphy index\n");
 		kfree(drv);
 		return NULL;
 	}
@@ -95,15 +87,14 @@ int wiphy_register(struct wiphy *wiphy)
 	if (res)
 		goto out_unlock;
 
-	list_add(&drv->list, &cfg80211_drv_list);
-
 	/* add to debugfs */
 	drv->wiphy.debugfsdir =
 		debugfs_create_dir(wiphy_name(&drv->wiphy),
 				   ieee80211_debugfs_dir);
 
+	drv->alive = 1;
 	res = 0;
-out_unlock:
+ out_unlock:
 	mutex_unlock(&cfg80211_drv_mutex);
 	return res;
 }
@@ -113,7 +104,10 @@ void wiphy_unregister(struct wiphy *wiph
 {
 	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
 
-	/* protect the device list */
+	/*
+	 * protect the device list, or here
+	 * rather just the ->alive variable
+	 */
 	mutex_lock(&cfg80211_drv_mutex);
 
 	BUG_ON(!list_empty(&drv->netdev_list));
@@ -132,7 +126,7 @@ void wiphy_unregister(struct wiphy *wiph
 	/* unlock again before freeing */
 	mutex_unlock(&drv->mtx);
 
-	list_del(&drv->list);
+	drv->alive = 0;
 	device_del(&drv->wiphy.dev);
 	debugfs_remove(drv->wiphy.debugfsdir);
 
@@ -142,6 +136,10 @@ EXPORT_SYMBOL(wiphy_unregister);
 
 void cfg80211_dev_free(struct cfg80211_registered_device *drv)
 {
+	mutex_lock(&cfg80211_drv_mutex);
+	idr_remove(&cfg80211_drivers, drv->idx);
+	mutex_unlock(&cfg80211_drv_mutex);
+
 	mutex_destroy(&drv->mtx);
 	mutex_destroy(&drv->devlist_mtx);
 	kfree(drv);
@@ -197,6 +195,7 @@ static struct notifier_block cfg80211_ne
 static int cfg80211_init(void)
 {
 	int err = wiphy_sysfs_init();
+
 	if (err)
 		goto out_fail_sysfs;
 
@@ -206,6 +205,8 @@ static int cfg80211_init(void)
 
 	ieee80211_debugfs_dir = debugfs_create_dir("ieee80211", NULL);
 
+	idr_init(&cfg80211_drivers);
+
 	return 0;
 
 out_fail_notifier:
@@ -220,5 +221,6 @@ static void cfg80211_exit(void)
 	debugfs_remove(ieee80211_debugfs_dir);
 	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
 	wiphy_sysfs_exit();
+	idr_destroy(&cfg80211_drivers);
 }
 module_exit(cfg80211_exit);
--- netdev-2.6.orig/net/wireless/core.h	2007-08-22 20:35:27.421906163 +0200
+++ netdev-2.6/net/wireless/core.h	2007-08-30 15:29:48.182051253 +0200
@@ -14,7 +14,6 @@
 
 struct cfg80211_registered_device {
 	struct cfg80211_ops *ops;
-	struct list_head list;
 	/* we hold this mutex during any call so that
 	 * we cannot do multiple calls at once, and also
 	 * to avoid the deregister call to proceed while
@@ -24,6 +23,9 @@ struct cfg80211_registered_device {
 	/* wiphy index, internal only */
 	int idx;
 
+	/* alive? internal! */
+	bool alive;
+
 	/* associate netdev list */
 	struct mutex devlist_mtx;
 	struct list_head netdev_list;
@@ -40,9 +42,6 @@ struct cfg80211_registered_device *wiphy
 	return container_of(wiphy, struct cfg80211_registered_device, wiphy);
 }
 
-extern struct mutex cfg80211_drv_mutex;
-extern struct list_head cfg80211_drv_list;
-
 /* free object */
 extern void cfg80211_dev_free(struct cfg80211_registered_device *drv);
 


