Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbXHVJZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 05:25:10 -0400
Subject: [PATCH] cfg80211: use idr layer for wiphy indizes
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 22:13:40 +0200
Message-Id: <1187727220.9267.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes cfg80211 use the idr layer instead of keeping
an own list of registered devices. One side effect is that
reloading a module will possibly assign it the same wiphy
index again, but they are obviously not guaranteed to be
stable. Another positive side effect for the code is that
some variables no longer need to be exported and can now
be made static, a list walker function is provided instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/wireless/core.c    |   88 +++++++++++++++++++++++++++++++------------------
 net/wireless/core.h    |    9 +++--
 net/wireless/nl80211.c |   44 +++++++++++++++---------
 3 files changed, 90 insertions(+), 51 deletions(-)

--- wireless-dev.orig/net/wireless/core.c	2007-08-21 21:36:44.179502183 +0200
+++ wireless-dev/net/wireless/core.c	2007-08-21 22:00:29.939502183 +0200
@@ -13,6 +13,7 @@
 #include <linux/debugfs.h>
 #include <linux/notifier.h>
 #include <linux/device.h>
+#include <linux/idr.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include <net/wireless.h>
@@ -27,29 +28,47 @@ MODULE_AUTHOR("Johannes Berg");
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
 
-/* requires cfg80211_drv_mutex to be held! */
-static struct cfg80211_registered_device *cfg80211_drv_by_wiphy(int wiphy)
+struct for_each_ctx {
+	void *data;
+	int (*fn)(struct cfg80211_registered_device *dev, void *data);
+};
+
+int for_each_fn(int id, void *p, void *data)
 {
-	struct cfg80211_registered_device *result = NULL, *drv;
+	struct for_each_ctx *ctx = data;
+	struct cfg80211_registered_device *dev = p;
 
-	list_for_each_entry(drv, &cfg80211_drv_list, list) {
-		if (drv->idx == wiphy) {
-			result = drv;
-			break;
-		}
-	}
+	if (!dev->alive)
+		return 0;
+
+	return ctx->fn(dev, ctx->data);
+}
+
+int cfg80211_for_each_driver(
+	int (*fn)(struct cfg80211_registered_device *dev, void *data),
+	void *data)
+{
+	int res;
+	struct for_each_ctx ctx = {
+		.fn = fn,
+		.data = data,
+	};
+	mutex_lock(&cfg80211_drv_mutex);
+	res = idr_for_each(&cfg80211_drivers, for_each_fn, &ctx);
+	mutex_unlock(&cfg80211_drv_mutex);
+	return res;
+}
 
-	return result;
+/* requires cfg80211_drv_mutex to be held! */
+static struct cfg80211_registered_device *cfg80211_drv_by_wiphy(int wiphy)
+{
+	return idr_find(&cfg80211_drivers, wiphy);
 }
 
 /* requires cfg80211_drv_mutex to be held! */
@@ -183,6 +202,7 @@ struct wiphy *wiphy_new(struct cfg80211_
 {
 	struct cfg80211_registered_device *drv;
 	int alloc_size;
+	int res;
 
 	alloc_size = sizeof(*drv) + sizeof_priv;
 
@@ -191,20 +211,14 @@ struct wiphy *wiphy_new(struct cfg80211_
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
@@ -236,15 +250,14 @@ int wiphy_register(struct wiphy *wiphy)
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
@@ -254,7 +267,10 @@ void wiphy_unregister(struct wiphy *wiph
 {
 	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
 
-	/* protect the device list */
+	/*
+	 * protect the device list, or here
+	 * rather just the ->alive variable
+	 */
 	mutex_lock(&cfg80211_drv_mutex);
 
 	BUG_ON(!list_empty(&drv->netdev_list));
@@ -273,7 +289,7 @@ void wiphy_unregister(struct wiphy *wiph
 	/* unlock again before freeing */
 	mutex_unlock(&drv->mtx);
 
-	list_del(&drv->list);
+	drv->alive = 0;
 	device_del(&drv->wiphy.dev);
 	debugfs_remove(drv->wiphy.debugfsdir);
 
@@ -283,6 +299,10 @@ EXPORT_SYMBOL(wiphy_unregister);
 
 void cfg80211_dev_free(struct cfg80211_registered_device *drv)
 {
+	mutex_lock(&cfg80211_drv_mutex);
+	idr_remove(&cfg80211_drivers, drv->idx);
+	mutex_unlock(&cfg80211_drv_mutex);
+
 	mutex_destroy(&drv->mtx);
 	mutex_destroy(&drv->devlist_mtx);
 	kfree(drv);
@@ -338,6 +358,7 @@ static struct notifier_block cfg80211_ne
 static int cfg80211_init(void)
 {
 	int err = wiphy_sysfs_init();
+
 	if (err)
 		goto out_fail_sysfs;
 
@@ -351,6 +372,8 @@ static int cfg80211_init(void)
 
 	ieee80211_debugfs_dir = debugfs_create_dir("ieee80211", NULL);
 
+	idr_init(&cfg80211_drivers);
+
 	return 0;
 
 out_fail_nl80211:
@@ -368,5 +391,6 @@ static void cfg80211_exit(void)
 	nl80211_exit();
 	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
 	wiphy_sysfs_exit();
+	idr_destroy(&cfg80211_drivers);
 }
 module_exit(cfg80211_exit);
--- wireless-dev.orig/net/wireless/core.h	2007-08-21 21:36:01.549502183 +0200
+++ wireless-dev/net/wireless/core.h	2007-08-21 21:52:18.359502183 +0200
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
@@ -40,8 +42,9 @@ struct cfg80211_registered_device *wiphy
 	return container_of(wiphy, struct cfg80211_registered_device, wiphy);
 }
 
-extern struct mutex cfg80211_drv_mutex;
-extern struct list_head cfg80211_drv_list;
+extern int cfg80211_for_each_driver(
+	int (*fn)(struct cfg80211_registered_device *dev, void *data),
+	void *data);
 
 /*
  * This function returns a pointer to the driver
--- wireless-dev.orig/net/wireless/nl80211.c	2007-08-21 21:44:13.749502183 +0200
+++ wireless-dev/net/wireless/nl80211.c	2007-08-21 22:08:14.129502183 +0200
@@ -171,13 +171,32 @@ static int nl80211_get_cmdlist(struct sk
 }
 #undef CHECK_CMD
 
+struct add_wiphy_ctx {
+	struct sk_buff *msg;
+	int idx;
+};
+
+int add_wiphy_fn(struct cfg80211_registered_device *dev, void *data)
+{
+	struct add_wiphy_ctx *ctx = data;
+	struct nlattr *indexstart;
+
+	indexstart = nla_nest_start(ctx->msg, ctx->idx++);
+	if (!indexstart)
+		goto nla_put_failure;
+	NLA_PUT_U32(ctx->msg, NL80211_ATTR_WIPHY, dev->idx);
+	nla_nest_end(ctx->msg, indexstart);
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
 static int nl80211_get_wiphys(struct sk_buff *skb, struct genl_info *info)
 {
 	struct sk_buff *msg;
 	void *hdr;
-	struct nlattr *start, *indexstart;
-	struct cfg80211_registered_device *drv;
-	int idx = 1;
+	struct nlattr *start;
+	struct add_wiphy_ctx ctx;
 
 	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
 			     NL80211_CMD_NEW_WIPHYS);
@@ -186,17 +205,12 @@ static int nl80211_get_wiphys(struct sk_
 
 	start = nla_nest_start(msg, NL80211_ATTR_WIPHY_LIST);
 	if (!start)
-		goto nla_outer_nest_failure;
+		goto failure;
 
-	mutex_lock(&cfg80211_drv_mutex);
-	list_for_each_entry(drv, &cfg80211_drv_list, list) {
-		indexstart = nla_nest_start(msg, idx++);
-		if (!indexstart)
-			goto nla_put_failure;
-		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->idx);
-		nla_nest_end(msg, indexstart);
-	}
-	mutex_unlock(&cfg80211_drv_mutex);
+	ctx.idx = 1;
+	ctx.msg = msg;
+	if (cfg80211_for_each_driver(add_wiphy_fn, &ctx))
+		goto failure;
 
 	nla_nest_end(msg, start);
 
@@ -204,9 +218,7 @@ static int nl80211_get_wiphys(struct sk_
 
 	return genlmsg_unicast(msg, info->snd_pid);
 
- nla_put_failure:
-	mutex_unlock(&cfg80211_drv_mutex);
- nla_outer_nest_failure:
+ failure:
 	nlmsg_free(msg);
 	return -ENOBUFS;
 }


