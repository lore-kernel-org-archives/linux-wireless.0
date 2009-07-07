Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59730 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbZGGCAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:00:36 -0400
Message-Id: <20090707015709.385337733@sipsolutions.net>
References: <20090707015604.369008211@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:56:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/9] cfg80211: clean up naming once and for all
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've named the registered devices 'drv' sometimes,
thinking of "driver", which is not what it is, it's
the internal representation of a wiphy, i.e. a
device. Let's clean up the naming once and and use
'rdev' aka 'registered device' everywhere.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c    |  224 ++++++++++++++++----------------
 net/wireless/core.h    |   26 +--
 net/wireless/debugfs.c |   14 +-
 net/wireless/debugfs.h |    8 -
 net/wireless/nl80211.c |  340 ++++++++++++++++++++++++-------------------------
 net/wireless/reg.c     |   48 +++---
 net/wireless/sme.c     |   48 +++---
 7 files changed, 354 insertions(+), 354 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-07-07 03:37:06.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-07 03:37:06.000000000 +0200
@@ -30,10 +30,10 @@ MODULE_DESCRIPTION("wireless configurati
 /* RCU might be appropriate here since we usually
  * only read the list, and that can happen quite
  * often because we need to do it for each command */
-LIST_HEAD(cfg80211_drv_list);
+LIST_HEAD(cfg80211_rdev_list);
 
 /*
- * This is used to protect the cfg80211_drv_list, cfg80211_regdomain,
+ * This is used to protect the cfg80211_rdev_list, cfg80211_regdomain,
  * country_ie_regdomain, the reg_beacon_list and the the last regulatory
  * request receipt (last_request).
  */
@@ -43,18 +43,18 @@ DEFINE_MUTEX(cfg80211_mutex);
 static struct dentry *ieee80211_debugfs_dir;
 
 /* requires cfg80211_mutex to be held! */
-struct cfg80211_registered_device *cfg80211_drv_by_wiphy_idx(int wiphy_idx)
+struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx)
 {
-	struct cfg80211_registered_device *result = NULL, *drv;
+	struct cfg80211_registered_device *result = NULL, *rdev;
 
 	if (!wiphy_idx_valid(wiphy_idx))
 		return NULL;
 
 	assert_cfg80211_lock();
 
-	list_for_each_entry(drv, &cfg80211_drv_list, list) {
-		if (drv->wiphy_idx == wiphy_idx) {
-			result = drv;
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (rdev->wiphy_idx == wiphy_idx) {
+			result = rdev;
 			break;
 		}
 	}
@@ -64,32 +64,32 @@ struct cfg80211_registered_device *cfg80
 
 int get_wiphy_idx(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	if (!wiphy)
 		return WIPHY_IDX_STALE;
-	drv = wiphy_to_dev(wiphy);
-	return drv->wiphy_idx;
+	rdev = wiphy_to_dev(wiphy);
+	return rdev->wiphy_idx;
 }
 
-/* requires cfg80211_drv_mutex to be held! */
+/* requires cfg80211_rdev_mutex to be held! */
 struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 
 	if (!wiphy_idx_valid(wiphy_idx))
 		return NULL;
 
 	assert_cfg80211_lock();
 
-	drv = cfg80211_drv_by_wiphy_idx(wiphy_idx);
-	if (!drv)
+	rdev = cfg80211_rdev_by_wiphy_idx(wiphy_idx);
+	if (!rdev)
 		return NULL;
-	return &drv->wiphy;
+	return &rdev->wiphy;
 }
 
 /* requires cfg80211_mutex to be held! */
 struct cfg80211_registered_device *
-__cfg80211_drv_from_info(struct genl_info *info)
+__cfg80211_rdev_from_info(struct genl_info *info)
 {
 	int ifindex;
 	struct cfg80211_registered_device *bywiphyidx = NULL, *byifidx = NULL;
@@ -99,7 +99,7 @@ __cfg80211_drv_from_info(struct genl_inf
 	assert_cfg80211_lock();
 
 	if (info->attrs[NL80211_ATTR_WIPHY]) {
-		bywiphyidx = cfg80211_drv_by_wiphy_idx(
+		bywiphyidx = cfg80211_rdev_by_wiphy_idx(
 				nla_get_u32(info->attrs[NL80211_ATTR_WIPHY]));
 		err = -ENODEV;
 	}
@@ -134,26 +134,26 @@ __cfg80211_drv_from_info(struct genl_inf
 struct cfg80211_registered_device *
 cfg80211_get_dev_from_info(struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 
 	mutex_lock(&cfg80211_mutex);
-	drv = __cfg80211_drv_from_info(info);
+	rdev = __cfg80211_rdev_from_info(info);
 
 	/* if it is not an error we grab the lock on
 	 * it to assure it won't be going away while
 	 * we operate on it */
-	if (!IS_ERR(drv))
-		mutex_lock(&drv->mtx);
+	if (!IS_ERR(rdev))
+		mutex_lock(&rdev->mtx);
 
 	mutex_unlock(&cfg80211_mutex);
 
-	return drv;
+	return rdev;
 }
 
 struct cfg80211_registered_device *
 cfg80211_get_dev_from_ifindex(int ifindex)
 {
-	struct cfg80211_registered_device *drv = ERR_PTR(-ENODEV);
+	struct cfg80211_registered_device *rdev = ERR_PTR(-ENODEV);
 	struct net_device *dev;
 
 	mutex_lock(&cfg80211_mutex);
@@ -161,21 +161,21 @@ cfg80211_get_dev_from_ifindex(int ifinde
 	if (!dev)
 		goto out;
 	if (dev->ieee80211_ptr) {
-		drv = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
-		mutex_lock(&drv->mtx);
+		rdev = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
+		mutex_lock(&rdev->mtx);
 	} else
-		drv = ERR_PTR(-ENODEV);
+		rdev = ERR_PTR(-ENODEV);
 	dev_put(dev);
  out:
 	mutex_unlock(&cfg80211_mutex);
-	return drv;
+	return rdev;
 }
 
 /* requires cfg80211_mutex to be held */
 int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			char *newname)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev2;
 	int wiphy_idx, taken = -1, result, digits;
 
 	assert_cfg80211_lock();
@@ -201,8 +201,8 @@ int cfg80211_dev_rename(struct cfg80211_
 		return 0;
 
 	/* Ensure another device does not already have this name. */
-	list_for_each_entry(drv, &cfg80211_drv_list, list)
-		if (strcmp(newname, dev_name(&drv->wiphy.dev)) == 0)
+	list_for_each_entry(rdev2, &cfg80211_rdev_list, list)
+		if (strcmp(newname, dev_name(&rdev2->wiphy.dev)) == 0)
 			return -EINVAL;
 
 	result = device_rename(&rdev->wiphy.dev, newname);
@@ -224,26 +224,26 @@ int cfg80211_dev_rename(struct cfg80211_
 
 static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
 {
-	struct cfg80211_registered_device *drv = data;
+	struct cfg80211_registered_device *rdev = data;
 
-	drv->ops->rfkill_poll(&drv->wiphy);
+	rdev->ops->rfkill_poll(&rdev->wiphy);
 }
 
 static int cfg80211_rfkill_set_block(void *data, bool blocked)
 {
-	struct cfg80211_registered_device *drv = data;
+	struct cfg80211_registered_device *rdev = data;
 	struct wireless_dev *wdev;
 
 	if (!blocked)
 		return 0;
 
 	rtnl_lock();
-	mutex_lock(&drv->devlist_mtx);
+	mutex_lock(&rdev->devlist_mtx);
 
-	list_for_each_entry(wdev, &drv->netdev_list, list)
+	list_for_each_entry(wdev, &rdev->netdev_list, list)
 		dev_close(wdev->netdev);
 
-	mutex_unlock(&drv->devlist_mtx);
+	mutex_unlock(&rdev->devlist_mtx);
 	rtnl_unlock();
 
 	return 0;
@@ -251,10 +251,10 @@ static int cfg80211_rfkill_set_block(voi
 
 static void cfg80211_rfkill_sync_work(struct work_struct *work)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 
-	drv = container_of(work, struct cfg80211_registered_device, rfkill_sync);
-	cfg80211_rfkill_set_block(drv, rfkill_blocked(drv->rfkill));
+	rdev = container_of(work, struct cfg80211_registered_device, rfkill_sync);
+	cfg80211_rfkill_set_block(rdev, rfkill_blocked(rdev->rfkill));
 }
 
 static void cfg80211_process_events(struct wireless_dev *wdev)
@@ -328,79 +328,79 @@ struct wiphy *wiphy_new(const struct cfg
 {
 	static int wiphy_counter;
 
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int alloc_size;
 
 	WARN_ON(!ops->add_key && ops->del_key);
 	WARN_ON(ops->add_key && !ops->del_key);
 
-	alloc_size = sizeof(*drv) + sizeof_priv;
+	alloc_size = sizeof(*rdev) + sizeof_priv;
 
-	drv = kzalloc(alloc_size, GFP_KERNEL);
-	if (!drv)
+	rdev = kzalloc(alloc_size, GFP_KERNEL);
+	if (!rdev)
 		return NULL;
 
-	drv->ops = ops;
+	rdev->ops = ops;
 
 	mutex_lock(&cfg80211_mutex);
 
-	drv->wiphy_idx = wiphy_counter++;
+	rdev->wiphy_idx = wiphy_counter++;
 
-	if (unlikely(!wiphy_idx_valid(drv->wiphy_idx))) {
+	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx))) {
 		wiphy_counter--;
 		mutex_unlock(&cfg80211_mutex);
 		/* ugh, wrapped! */
-		kfree(drv);
+		kfree(rdev);
 		return NULL;
 	}
 
 	mutex_unlock(&cfg80211_mutex);
 
 	/* give it a proper name */
-	dev_set_name(&drv->wiphy.dev, PHY_NAME "%d", drv->wiphy_idx);
+	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
 
-	mutex_init(&drv->mtx);
-	mutex_init(&drv->devlist_mtx);
-	INIT_LIST_HEAD(&drv->netdev_list);
-	spin_lock_init(&drv->bss_lock);
-	INIT_LIST_HEAD(&drv->bss_list);
-	INIT_WORK(&drv->scan_done_wk, __cfg80211_scan_done);
-
-	device_initialize(&drv->wiphy.dev);
-	drv->wiphy.dev.class = &ieee80211_class;
-	drv->wiphy.dev.platform_data = drv;
-
-	drv->rfkill_ops.set_block = cfg80211_rfkill_set_block;
-	drv->rfkill = rfkill_alloc(dev_name(&drv->wiphy.dev),
-				   &drv->wiphy.dev, RFKILL_TYPE_WLAN,
-				   &drv->rfkill_ops, drv);
+	mutex_init(&rdev->mtx);
+	mutex_init(&rdev->devlist_mtx);
+	INIT_LIST_HEAD(&rdev->netdev_list);
+	spin_lock_init(&rdev->bss_lock);
+	INIT_LIST_HEAD(&rdev->bss_list);
+	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
+
+	device_initialize(&rdev->wiphy.dev);
+	rdev->wiphy.dev.class = &ieee80211_class;
+	rdev->wiphy.dev.platform_data = rdev;
+
+	rdev->rfkill_ops.set_block = cfg80211_rfkill_set_block;
+	rdev->rfkill = rfkill_alloc(dev_name(&rdev->wiphy.dev),
+				   &rdev->wiphy.dev, RFKILL_TYPE_WLAN,
+				   &rdev->rfkill_ops, rdev);
 
-	if (!drv->rfkill) {
-		kfree(drv);
+	if (!rdev->rfkill) {
+		kfree(rdev);
 		return NULL;
 	}
 
-	INIT_WORK(&drv->rfkill_sync, cfg80211_rfkill_sync_work);
-	INIT_WORK(&drv->conn_work, cfg80211_conn_work);
-	INIT_WORK(&drv->event_work, cfg80211_event_work);
+	INIT_WORK(&rdev->rfkill_sync, cfg80211_rfkill_sync_work);
+	INIT_WORK(&rdev->conn_work, cfg80211_conn_work);
+	INIT_WORK(&rdev->event_work, cfg80211_event_work);
 
 	/*
 	 * Initialize wiphy parameters to IEEE 802.11 MIB default values.
 	 * Fragmentation and RTS threshold are disabled by default with the
 	 * special -1 value.
 	 */
-	drv->wiphy.retry_short = 7;
-	drv->wiphy.retry_long = 4;
-	drv->wiphy.frag_threshold = (u32) -1;
-	drv->wiphy.rts_threshold = (u32) -1;
+	rdev->wiphy.retry_short = 7;
+	rdev->wiphy.retry_long = 4;
+	rdev->wiphy.frag_threshold = (u32) -1;
+	rdev->wiphy.rts_threshold = (u32) -1;
 
-	return &drv->wiphy;
+	return &rdev->wiphy;
 }
 EXPORT_SYMBOL(wiphy_new);
 
 int wiphy_register(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	int res;
 	enum ieee80211_band band;
 	struct ieee80211_supported_band *sband;
@@ -454,11 +454,11 @@ int wiphy_register(struct wiphy *wiphy)
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
 
-	res = device_add(&drv->wiphy.dev);
+	res = device_add(&rdev->wiphy.dev);
 	if (res)
 		return res;
 
-	res = rfkill_register(drv->rfkill);
+	res = rfkill_register(rdev->rfkill);
 	if (res)
 		goto out_rm_dev;
 
@@ -467,16 +467,16 @@ int wiphy_register(struct wiphy *wiphy)
 	/* set up regulatory info */
 	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
-	list_add(&drv->list, &cfg80211_drv_list);
+	list_add(&rdev->list, &cfg80211_rdev_list);
 
 	mutex_unlock(&cfg80211_mutex);
 
 	/* add to debugfs */
-	drv->wiphy.debugfsdir =
-		debugfs_create_dir(wiphy_name(&drv->wiphy),
+	rdev->wiphy.debugfsdir =
+		debugfs_create_dir(wiphy_name(&rdev->wiphy),
 				   ieee80211_debugfs_dir);
-	if (IS_ERR(drv->wiphy.debugfsdir))
-		drv->wiphy.debugfsdir = NULL;
+	if (IS_ERR(rdev->wiphy.debugfsdir))
+		rdev->wiphy.debugfsdir = NULL;
 
 	if (wiphy->custom_regulatory) {
 		struct regulatory_request request;
@@ -489,48 +489,48 @@ int wiphy_register(struct wiphy *wiphy)
 		nl80211_send_reg_change_event(&request);
 	}
 
-	cfg80211_debugfs_drv_add(drv);
+	cfg80211_debugfs_rdev_add(rdev);
 
 	return 0;
 
  out_rm_dev:
-	device_del(&drv->wiphy.dev);
+	device_del(&rdev->wiphy.dev);
 	return res;
 }
 EXPORT_SYMBOL(wiphy_register);
 
 void wiphy_rfkill_start_polling(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	if (!drv->ops->rfkill_poll)
+	if (!rdev->ops->rfkill_poll)
 		return;
-	drv->rfkill_ops.poll = cfg80211_rfkill_poll;
-	rfkill_resume_polling(drv->rfkill);
+	rdev->rfkill_ops.poll = cfg80211_rfkill_poll;
+	rfkill_resume_polling(rdev->rfkill);
 }
 EXPORT_SYMBOL(wiphy_rfkill_start_polling);
 
 void wiphy_rfkill_stop_polling(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	rfkill_pause_polling(drv->rfkill);
+	rfkill_pause_polling(rdev->rfkill);
 }
 EXPORT_SYMBOL(wiphy_rfkill_stop_polling);
 
 void wiphy_unregister(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	rfkill_unregister(drv->rfkill);
+	rfkill_unregister(rdev->rfkill);
 
 	/* protect the device list */
 	mutex_lock(&cfg80211_mutex);
 
-	BUG_ON(!list_empty(&drv->netdev_list));
+	BUG_ON(!list_empty(&rdev->netdev_list));
 
 	/*
-	 * Try to grab drv->mtx. If a command is still in progress,
+	 * Try to grab rdev->mtx. If a command is still in progress,
 	 * hopefully the driver will refuse it since it's tearing
 	 * down the device already. We wait for this command to complete
 	 * before unlinking the item from the list.
@@ -539,38 +539,38 @@ void wiphy_unregister(struct wiphy *wiph
 	 * get to lock contention here if userspace issues a command
 	 * that identified the hardware by wiphy index.
 	 */
-	mutex_lock(&drv->mtx);
+	mutex_lock(&rdev->mtx);
 	/* unlock again before freeing */
-	mutex_unlock(&drv->mtx);
+	mutex_unlock(&rdev->mtx);
 
-	cancel_work_sync(&drv->conn_work);
-	cancel_work_sync(&drv->scan_done_wk);
-	kfree(drv->scan_req);
-	flush_work(&drv->event_work);
+	cancel_work_sync(&rdev->conn_work);
+	cancel_work_sync(&rdev->scan_done_wk);
+	kfree(rdev->scan_req);
+	flush_work(&rdev->event_work);
 
-	cfg80211_debugfs_drv_del(drv);
+	cfg80211_debugfs_rdev_del(rdev);
 
 	/* If this device got a regulatory hint tell core its
 	 * free to listen now to a new shiny device regulatory hint */
 	reg_device_remove(wiphy);
 
-	list_del(&drv->list);
-	device_del(&drv->wiphy.dev);
-	debugfs_remove(drv->wiphy.debugfsdir);
+	list_del(&rdev->list);
+	device_del(&rdev->wiphy.dev);
+	debugfs_remove(rdev->wiphy.debugfsdir);
 
 	mutex_unlock(&cfg80211_mutex);
 }
 EXPORT_SYMBOL(wiphy_unregister);
 
-void cfg80211_dev_free(struct cfg80211_registered_device *drv)
+void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 {
 	struct cfg80211_internal_bss *scan, *tmp;
-	rfkill_destroy(drv->rfkill);
-	mutex_destroy(&drv->mtx);
-	mutex_destroy(&drv->devlist_mtx);
-	list_for_each_entry_safe(scan, tmp, &drv->bss_list, list)
+	rfkill_destroy(rdev->rfkill);
+	mutex_destroy(&rdev->mtx);
+	mutex_destroy(&rdev->devlist_mtx);
+	list_for_each_entry_safe(scan, tmp, &rdev->bss_list, list)
 		cfg80211_put_bss(&scan->pub);
-	kfree(drv);
+	kfree(rdev);
 }
 
 void wiphy_free(struct wiphy *wiphy)
@@ -581,10 +581,10 @@ EXPORT_SYMBOL(wiphy_free);
 
 void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked)
 {
-	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	if (rfkill_set_hw_state(drv->rfkill, blocked))
-		schedule_work(&drv->rfkill_sync);
+	if (rfkill_set_hw_state(rdev->rfkill, blocked))
+		schedule_work(&rdev->rfkill_sync);
 }
 EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
 
--- wireless-testing.orig/net/wireless/core.h	2009-07-07 03:37:06.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-07-07 03:37:06.000000000 +0200
@@ -97,13 +97,13 @@ bool wiphy_idx_valid(int wiphy_idx)
 }
 
 extern struct mutex cfg80211_mutex;
-extern struct list_head cfg80211_drv_list;
+extern struct list_head cfg80211_rdev_list;
 
 #define assert_cfg80211_lock() WARN_ON(!mutex_is_locked(&cfg80211_mutex))
 
 /*
  * You can use this to mark a wiphy_idx as not having an associated wiphy.
- * It guarantees cfg80211_drv_by_wiphy_idx(wiphy_idx) will return NULL
+ * It guarantees cfg80211_rdev_by_wiphy_idx(wiphy_idx) will return NULL
  */
 #define WIPHY_IDX_STALE -1
 
@@ -136,11 +136,11 @@ static inline void cfg80211_unhold_bss(s
 }
 
 
-struct cfg80211_registered_device *cfg80211_drv_by_wiphy_idx(int wiphy_idx);
+struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx);
 int get_wiphy_idx(struct wiphy *wiphy);
 
 struct cfg80211_registered_device *
-__cfg80211_drv_from_info(struct genl_info *info);
+__cfg80211_rdev_from_info(struct genl_info *info);
 
 /*
  * This function returns a pointer to the driver
@@ -153,7 +153,7 @@ __cfg80211_drv_from_info(struct genl_inf
  *
  * This is necessary because we need to lock the global
  * mutex to get an item off the list safely, and then
- * we lock the drv mutex so it doesn't go away under us.
+ * we lock the rdev mutex so it doesn't go away under us.
  *
  * We don't want to keep cfg80211_mutex locked
  * for all the time in order to allow requests on
@@ -165,22 +165,22 @@ __cfg80211_drv_from_info(struct genl_inf
 extern struct cfg80211_registered_device *
 cfg80211_get_dev_from_info(struct genl_info *info);
 
-/* requires cfg80211_drv_mutex to be held! */
+/* requires cfg80211_rdev_mutex to be held! */
 struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx);
 
 /* identical to cfg80211_get_dev_from_info but only operate on ifindex */
 extern struct cfg80211_registered_device *
 cfg80211_get_dev_from_ifindex(int ifindex);
 
-static inline void cfg80211_lock_rdev(struct cfg80211_registered_device *drv)
+static inline void cfg80211_lock_rdev(struct cfg80211_registered_device *rdev)
 {
-	mutex_lock(&drv->mtx);
+	mutex_lock(&rdev->mtx);
 }
 
-static inline void cfg80211_unlock_rdev(struct cfg80211_registered_device *drv)
+static inline void cfg80211_unlock_rdev(struct cfg80211_registered_device *rdev)
 {
-	BUG_ON(IS_ERR(drv) || !drv);
-	mutex_unlock(&drv->mtx);
+	BUG_ON(IS_ERR(rdev) || !rdev);
+	mutex_unlock(&rdev->mtx);
 }
 
 static inline void wdev_lock(struct wireless_dev *wdev)
@@ -240,9 +240,9 @@ struct cfg80211_event {
 
 
 /* free object */
-extern void cfg80211_dev_free(struct cfg80211_registered_device *drv);
+extern void cfg80211_dev_free(struct cfg80211_registered_device *rdev);
 
-extern int cfg80211_dev_rename(struct cfg80211_registered_device *drv,
+extern int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			       char *newname);
 
 void ieee80211_set_bitrate_flags(struct wiphy *wiphy);
--- wireless-testing.orig/net/wireless/debugfs.c	2009-07-07 03:25:42.000000000 +0200
+++ wireless-testing/net/wireless/debugfs.c	2009-07-07 03:37:06.000000000 +0200
@@ -104,15 +104,15 @@ static const struct file_operations ht40
 };
 
 #define DEBUGFS_ADD(name)						\
-	drv->debugfs.name = debugfs_create_file(#name, S_IRUGO, phyd,	\
-						  &drv->wiphy, &name## _ops);
+	rdev->debugfs.name = debugfs_create_file(#name, S_IRUGO, phyd,	\
+						  &rdev->wiphy, &name## _ops);
 #define DEBUGFS_DEL(name)						\
-	debugfs_remove(drv->debugfs.name);				\
-	drv->debugfs.name = NULL;
+	debugfs_remove(rdev->debugfs.name);				\
+	rdev->debugfs.name = NULL;
 
-void cfg80211_debugfs_drv_add(struct cfg80211_registered_device *drv)
+void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev)
 {
-	struct dentry *phyd = drv->wiphy.debugfsdir;
+	struct dentry *phyd = rdev->wiphy.debugfsdir;
 
 	DEBUGFS_ADD(rts_threshold);
 	DEBUGFS_ADD(fragmentation_threshold);
@@ -121,7 +121,7 @@ void cfg80211_debugfs_drv_add(struct cfg
 	DEBUGFS_ADD(ht40allow_map);
 }
 
-void cfg80211_debugfs_drv_del(struct cfg80211_registered_device *drv)
+void cfg80211_debugfs_rdev_del(struct cfg80211_registered_device *rdev)
 {
 	DEBUGFS_DEL(rts_threshold);
 	DEBUGFS_DEL(fragmentation_threshold);
--- wireless-testing.orig/net/wireless/debugfs.h	2009-07-07 03:25:42.000000000 +0200
+++ wireless-testing/net/wireless/debugfs.h	2009-07-07 03:37:06.000000000 +0200
@@ -2,13 +2,13 @@
 #define __CFG80211_DEBUGFS_H
 
 #ifdef CONFIG_CFG80211_DEBUGFS
-void cfg80211_debugfs_drv_add(struct cfg80211_registered_device *drv);
-void cfg80211_debugfs_drv_del(struct cfg80211_registered_device *drv);
+void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev);
+void cfg80211_debugfs_rdev_del(struct cfg80211_registered_device *rdev);
 #else
 static inline
-void cfg80211_debugfs_drv_add(struct cfg80211_registered_device *drv) {}
+void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev) {}
 static inline
-void cfg80211_debugfs_drv_del(struct cfg80211_registered_device *drv) {}
+void cfg80211_debugfs_rdev_del(struct cfg80211_registered_device *rdev) {}
 #endif
 
 #endif /* __CFG80211_DEBUGFS_H */
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-07 03:37:06.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-07 03:37:06.000000000 +0200
@@ -29,9 +29,9 @@ static struct genl_family nl80211_fam = 
 	.maxattr = NL80211_ATTR_MAX,
 };
 
-/* internal helper: get drv and dev */
-static int get_drv_dev_by_info_ifindex(struct nlattr **attrs,
-				       struct cfg80211_registered_device **drv,
+/* internal helper: get rdev and dev */
+static int get_rdev_dev_by_info_ifindex(struct nlattr **attrs,
+				       struct cfg80211_registered_device **rdev,
 				       struct net_device **dev)
 {
 	int ifindex;
@@ -44,10 +44,10 @@ static int get_drv_dev_by_info_ifindex(s
 	if (!*dev)
 		return -ENODEV;
 
-	*drv = cfg80211_get_dev_from_ifindex(ifindex);
-	if (IS_ERR(*drv)) {
+	*rdev = cfg80211_get_dev_from_ifindex(ifindex);
+	if (IS_ERR(*rdev)) {
 		dev_put(*dev);
-		return PTR_ERR(*drv);
+		return PTR_ERR(*rdev);
 	}
 
 	return 0;
@@ -378,7 +378,7 @@ static int nl80211_dump_wiphy(struct sk_
 	struct cfg80211_registered_device *dev;
 
 	mutex_lock(&cfg80211_mutex);
-	list_for_each_entry(dev, &cfg80211_drv_list, list) {
+	list_for_each_entry(dev, &cfg80211_rdev_list, list) {
 		if (++idx <= start)
 			continue;
 		if (nl80211_send_wiphy(skb, NETLINK_CB(cb->skb).pid,
@@ -460,7 +460,7 @@ static int nl80211_set_wiphy(struct sk_b
 
 	mutex_lock(&cfg80211_mutex);
 
-	rdev = __cfg80211_drv_from_info(info);
+	rdev = __cfg80211_rdev_from_info(info);
 	if (IS_ERR(rdev)) {
 		mutex_unlock(&cfg80211_mutex);
 		result = PTR_ERR(rdev);
@@ -683,7 +683,7 @@ static int nl80211_dump_interface(struct
 	struct wireless_dev *wdev;
 
 	mutex_lock(&cfg80211_mutex);
-	list_for_each_entry(dev, &cfg80211_drv_list, list) {
+	list_for_each_entry(dev, &cfg80211_rdev_list, list) {
 		if (wp_idx < wp_start) {
 			wp_idx++;
 			continue;
@@ -724,7 +724,7 @@ static int nl80211_get_interface(struct 
 	struct net_device *netdev;
 	int err;
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &dev, &netdev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &dev, &netdev);
 	if (err)
 		return err;
 
@@ -780,7 +780,7 @@ static int parse_monitor_flags(struct nl
 
 static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct vif_params params;
 	int err;
 	enum nl80211_iftype otype, ntype;
@@ -792,7 +792,7 @@ static int nl80211_set_interface(struct 
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -808,8 +808,8 @@ static int nl80211_set_interface(struct 
 		}
 	}
 
-	if (!drv->ops->change_virtual_intf ||
-	    !(drv->wiphy.interface_modes & (1 << ntype))) {
+	if (!rdev->ops->change_virtual_intf ||
+	    !(rdev->wiphy.interface_modes & (1 << ntype))) {
 		err = -EOPNOTSUPP;
 		goto unlock;
 	}
@@ -839,7 +839,7 @@ static int nl80211_set_interface(struct 
 	}
 
 	if (change)
-		err = drv->ops->change_virtual_intf(&drv->wiphy, dev,
+		err = rdev->ops->change_virtual_intf(&rdev->wiphy, dev,
 						    ntype, flags, &params);
 	else
 		err = 0;
@@ -853,7 +853,7 @@ static int nl80211_set_interface(struct 
 
  unlock:
 	dev_put(dev);
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
  unlock_rtnl:
 	rtnl_unlock();
 	return err;
@@ -861,7 +861,7 @@ static int nl80211_set_interface(struct 
 
 static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct vif_params params;
 	int err;
 	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
@@ -880,14 +880,14 @@ static int nl80211_new_interface(struct 
 
 	rtnl_lock();
 
-	drv = cfg80211_get_dev_from_info(info);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
+	rdev = cfg80211_get_dev_from_info(info);
+	if (IS_ERR(rdev)) {
+		err = PTR_ERR(rdev);
 		goto unlock_rtnl;
 	}
 
-	if (!drv->ops->add_virtual_intf ||
-	    !(drv->wiphy.interface_modes & (1 << type))) {
+	if (!rdev->ops->add_virtual_intf ||
+	    !(rdev->wiphy.interface_modes & (1 << type))) {
 		err = -EOPNOTSUPP;
 		goto unlock;
 	}
@@ -901,12 +901,12 @@ static int nl80211_new_interface(struct 
 	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
 				  &flags);
-	err = drv->ops->add_virtual_intf(&drv->wiphy,
+	err = rdev->ops->add_virtual_intf(&rdev->wiphy,
 		nla_data(info->attrs[NL80211_ATTR_IFNAME]),
 		type, err ? NULL : &flags, &params);
 
  unlock:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
  unlock_rtnl:
 	rtnl_unlock();
 	return err;
@@ -914,27 +914,27 @@ static int nl80211_new_interface(struct 
 
 static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int ifindex, err;
 	struct net_device *dev;
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 	ifindex = dev->ifindex;
 	dev_put(dev);
 
-	if (!drv->ops->del_virtual_intf) {
+	if (!rdev->ops->del_virtual_intf) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	err = drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
+	err = rdev->ops->del_virtual_intf(&rdev->wiphy, ifindex);
 
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
  unlock_rtnl:
 	rtnl_unlock();
 	return err;
@@ -968,7 +968,7 @@ static void get_key_callback(void *c, st
 
 static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	u8 key_idx = 0;
@@ -990,11 +990,11 @@ static int nl80211_get_key(struct sk_buf
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
-	if (!drv->ops->get_key) {
+	if (!rdev->ops->get_key) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1020,7 +1020,7 @@ static int nl80211_get_key(struct sk_buf
 	if (mac_addr)
 		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
 
-	err = drv->ops->get_key(&drv->wiphy, dev, key_idx, mac_addr,
+	err = rdev->ops->get_key(&rdev->wiphy, dev, key_idx, mac_addr,
 				&cookie, get_key_callback);
 
 	if (err)
@@ -1037,7 +1037,7 @@ static int nl80211_get_key(struct sk_buf
 	err = -ENOBUFS;
 	nlmsg_free(msg);
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  unlock_rtnl:
 	rtnl_unlock();
@@ -1047,7 +1047,7 @@ static int nl80211_get_key(struct sk_buf
 
 static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	u8 key_idx;
@@ -1072,24 +1072,24 @@ static int nl80211_set_key(struct sk_buf
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
 	if (info->attrs[NL80211_ATTR_KEY_DEFAULT])
-		func = drv->ops->set_default_key;
+		func = rdev->ops->set_default_key;
 	else
-		func = drv->ops->set_default_mgmt_key;
+		func = rdev->ops->set_default_mgmt_key;
 
 	if (!func) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	err = func(&drv->wiphy, dev, key_idx);
+	err = func(&rdev->wiphy, dev, key_idx);
 #ifdef CONFIG_WIRELESS_EXT
 	if (!err) {
-		if (func == drv->ops->set_default_key)
+		if (func == rdev->ops->set_default_key)
 			dev->ieee80211_ptr->wext.default_key = key_idx;
 		else
 			dev->ieee80211_ptr->wext.default_mgmt_key = key_idx;
@@ -1097,7 +1097,7 @@ static int nl80211_set_key(struct sk_buf
 #endif
 
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
 
  unlock_rtnl:
@@ -1108,7 +1108,7 @@ static int nl80211_set_key(struct sk_buf
 
 static int nl80211_new_key(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err, i;
 	struct net_device *dev;
 	struct key_params params;
@@ -1143,27 +1143,27 @@ static int nl80211_new_key(struct sk_buf
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
-	for (i = 0; i < drv->wiphy.n_cipher_suites; i++)
-		if (params.cipher == drv->wiphy.cipher_suites[i])
+	for (i = 0; i < rdev->wiphy.n_cipher_suites; i++)
+		if (params.cipher == rdev->wiphy.cipher_suites[i])
 			break;
-	if (i == drv->wiphy.n_cipher_suites) {
+	if (i == rdev->wiphy.n_cipher_suites) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	if (!drv->ops->add_key) {
+	if (!rdev->ops->add_key) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	err = drv->ops->add_key(&drv->wiphy, dev, key_idx, mac_addr, &params);
+	err = rdev->ops->add_key(&rdev->wiphy, dev, key_idx, mac_addr, &params);
 
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  unlock_rtnl:
 	rtnl_unlock();
@@ -1173,7 +1173,7 @@ static int nl80211_new_key(struct sk_buf
 
 static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	u8 key_idx = 0;
@@ -1190,16 +1190,16 @@ static int nl80211_del_key(struct sk_buf
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
-	if (!drv->ops->del_key) {
+	if (!rdev->ops->del_key) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	err = drv->ops->del_key(&drv->wiphy, dev, key_idx, mac_addr);
+	err = rdev->ops->del_key(&rdev->wiphy, dev, key_idx, mac_addr);
 
 #ifdef CONFIG_WIRELESS_EXT
 	if (!err) {
@@ -1211,7 +1211,7 @@ static int nl80211_del_key(struct sk_buf
 #endif
 
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
 
  unlock_rtnl:
@@ -1224,7 +1224,7 @@ static int nl80211_addset_beacon(struct 
 {
         int (*call)(struct wiphy *wiphy, struct net_device *dev,
 		    struct beacon_parameters *info);
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	struct beacon_parameters params;
@@ -1235,7 +1235,7 @@ static int nl80211_addset_beacon(struct 
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -1254,10 +1254,10 @@ static int nl80211_addset_beacon(struct 
 			goto out;
 		}
 
-		call = drv->ops->add_beacon;
+		call = rdev->ops->add_beacon;
 		break;
 	case NL80211_CMD_SET_BEACON:
-		call = drv->ops->set_beacon;
+		call = rdev->ops->set_beacon;
 		break;
 	default:
 		WARN_ON(1);
@@ -1303,10 +1303,10 @@ static int nl80211_addset_beacon(struct 
 		goto out;
 	}
 
-	err = call(&drv->wiphy, dev, &params);
+	err = call(&rdev->wiphy, dev, &params);
 
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  unlock_rtnl:
 	rtnl_unlock();
@@ -1316,17 +1316,17 @@ static int nl80211_addset_beacon(struct 
 
 static int nl80211_del_beacon(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
-	if (!drv->ops->del_beacon) {
+	if (!rdev->ops->del_beacon) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1335,10 +1335,10 @@ static int nl80211_del_beacon(struct sk_
 		err = -EOPNOTSUPP;
 		goto out;
 	}
-	err = drv->ops->del_beacon(&drv->wiphy, dev);
+	err = rdev->ops->del_beacon(&rdev->wiphy, dev);
 
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  unlock_rtnl:
 	rtnl_unlock();
@@ -1581,7 +1581,7 @@ static int nl80211_dump_station(struct s
 
 static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	struct station_info sinfo;
@@ -1597,16 +1597,16 @@ static int nl80211_get_station(struct sk
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	if (!drv->ops->get_station) {
+	if (!rdev->ops->get_station) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	err = drv->ops->get_station(&drv->wiphy, dev, mac_addr, &sinfo);
+	err = rdev->ops->get_station(&rdev->wiphy, dev, mac_addr, &sinfo);
 	if (err)
 		goto out;
 
@@ -1624,7 +1624,7 @@ static int nl80211_get_station(struct sk
  out_free:
 	nlmsg_free(msg);
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -1655,7 +1655,7 @@ static int get_vlan(struct nlattr *vlana
 
 static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	struct station_parameters params;
@@ -1697,11 +1697,11 @@ static int nl80211_set_station(struct sk
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &params.vlan);
+	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], rdev, &params.vlan);
 	if (err)
 		goto out;
 
@@ -1750,17 +1750,17 @@ static int nl80211_set_station(struct sk
 	if (err)
 		goto out;
 
-	if (!drv->ops->change_station) {
+	if (!rdev->ops->change_station) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	err = drv->ops->change_station(&drv->wiphy, dev, mac_addr, &params);
+	err = rdev->ops->change_station(&rdev->wiphy, dev, mac_addr, &params);
 
  out:
 	if (params.vlan)
 		dev_put(params.vlan);
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -1770,7 +1770,7 @@ static int nl80211_set_station(struct sk
 
 static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	struct station_parameters params;
@@ -1810,11 +1810,11 @@ static int nl80211_new_station(struct sk
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &params.vlan);
+	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], rdev, &params.vlan);
 	if (err)
 		goto out;
 
@@ -1850,7 +1850,7 @@ static int nl80211_new_station(struct sk
 	if (err)
 		goto out;
 
-	if (!drv->ops->add_station) {
+	if (!rdev->ops->add_station) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1860,12 +1860,12 @@ static int nl80211_new_station(struct sk
 		goto out;
 	}
 
-	err = drv->ops->add_station(&drv->wiphy, dev, mac_addr, &params);
+	err = rdev->ops->add_station(&rdev->wiphy, dev, mac_addr, &params);
 
  out:
 	if (params.vlan)
 		dev_put(params.vlan);
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -1875,7 +1875,7 @@ static int nl80211_new_station(struct sk
 
 static int nl80211_del_station(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	u8 *mac_addr = NULL;
@@ -1885,7 +1885,7 @@ static int nl80211_del_station(struct sk
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
@@ -1896,15 +1896,15 @@ static int nl80211_del_station(struct sk
 		goto out;
 	}
 
-	if (!drv->ops->del_station) {
+	if (!rdev->ops->del_station) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	err = drv->ops->del_station(&drv->wiphy, dev, mac_addr);
+	err = rdev->ops->del_station(&rdev->wiphy, dev, mac_addr);
 
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2044,7 +2044,7 @@ static int nl80211_dump_mpath(struct sk_
 
 static int nl80211_get_mpath(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	struct mpath_info pinfo;
@@ -2061,11 +2061,11 @@ static int nl80211_get_mpath(struct sk_b
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	if (!drv->ops->get_mpath) {
+	if (!rdev->ops->get_mpath) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -2075,7 +2075,7 @@ static int nl80211_get_mpath(struct sk_b
 		goto out;
 	}
 
-	err = drv->ops->get_mpath(&drv->wiphy, dev, dst, next_hop, &pinfo);
+	err = rdev->ops->get_mpath(&rdev->wiphy, dev, dst, next_hop, &pinfo);
 	if (err)
 		goto out;
 
@@ -2093,7 +2093,7 @@ static int nl80211_get_mpath(struct sk_b
  out_free:
 	nlmsg_free(msg);
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2103,7 +2103,7 @@ static int nl80211_get_mpath(struct sk_b
 
 static int nl80211_set_mpath(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	u8 *dst = NULL;
@@ -2120,11 +2120,11 @@ static int nl80211_set_mpath(struct sk_b
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	if (!drv->ops->change_mpath) {
+	if (!rdev->ops->change_mpath) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -2139,10 +2139,10 @@ static int nl80211_set_mpath(struct sk_b
 		goto out;
 	}
 
-	err = drv->ops->change_mpath(&drv->wiphy, dev, dst, next_hop);
+	err = rdev->ops->change_mpath(&rdev->wiphy, dev, dst, next_hop);
 
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2151,7 +2151,7 @@ static int nl80211_set_mpath(struct sk_b
 }
 static int nl80211_new_mpath(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	u8 *dst = NULL;
@@ -2168,11 +2168,11 @@ static int nl80211_new_mpath(struct sk_b
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	if (!drv->ops->add_mpath) {
+	if (!rdev->ops->add_mpath) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -2187,10 +2187,10 @@ static int nl80211_new_mpath(struct sk_b
 		goto out;
 	}
 
-	err = drv->ops->add_mpath(&drv->wiphy, dev, dst, next_hop);
+	err = rdev->ops->add_mpath(&rdev->wiphy, dev, dst, next_hop);
 
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2200,7 +2200,7 @@ static int nl80211_new_mpath(struct sk_b
 
 static int nl80211_del_mpath(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	u8 *dst = NULL;
@@ -2210,19 +2210,19 @@ static int nl80211_del_mpath(struct sk_b
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	if (!drv->ops->del_mpath) {
+	if (!rdev->ops->del_mpath) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	err = drv->ops->del_mpath(&drv->wiphy, dev, dst);
+	err = rdev->ops->del_mpath(&rdev->wiphy, dev, dst);
 
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2232,7 +2232,7 @@ static int nl80211_del_mpath(struct sk_b
 
 static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
 	struct bss_parameters params;
@@ -2261,11 +2261,11 @@ static int nl80211_set_bss(struct sk_buf
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	if (!drv->ops->change_bss) {
+	if (!rdev->ops->change_bss) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -2275,10 +2275,10 @@ static int nl80211_set_bss(struct sk_buf
 		goto out;
 	}
 
-	err = drv->ops->change_bss(&drv->wiphy, dev, &params);
+	err = rdev->ops->change_bss(&rdev->wiphy, dev, &params);
 
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2369,7 +2369,7 @@ static int nl80211_req_set_reg(struct sk
 static int nl80211_get_mesh_params(struct sk_buff *skb,
 	struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct mesh_config cur_params;
 	int err;
 	struct net_device *dev;
@@ -2380,17 +2380,17 @@ static int nl80211_get_mesh_params(struc
 	rtnl_lock();
 
 	/* Look up our device */
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	if (!drv->ops->get_mesh_params) {
+	if (!rdev->ops->get_mesh_params) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
 	/* Get the mesh params */
-	err = drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
+	err = rdev->ops->get_mesh_params(&rdev->wiphy, dev, &cur_params);
 	if (err)
 		goto out;
 
@@ -2444,7 +2444,7 @@ static int nl80211_get_mesh_params(struc
 	err = -EMSGSIZE;
  out:
 	/* Cleanup */
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2482,7 +2482,7 @@ static int nl80211_set_mesh_params(struc
 {
 	int err;
 	u32 mask;
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 	struct mesh_config cfg;
 	struct nlattr *tb[NL80211_MESHCONF_ATTR_MAX + 1];
@@ -2497,11 +2497,11 @@ static int nl80211_set_mesh_params(struc
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	if (!drv->ops->set_mesh_params) {
+	if (!rdev->ops->set_mesh_params) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -2546,11 +2546,11 @@ static int nl80211_set_mesh_params(struc
 			nla_get_u16);
 
 	/* Apply changes */
-	err = drv->ops->set_mesh_params(&drv->wiphy, dev, &cfg, mask);
+	err = rdev->ops->set_mesh_params(&rdev->wiphy, dev, &cfg, mask);
 
  out:
 	/* cleanup */
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2737,7 +2737,7 @@ static int validate_scan_freqs(struct nl
 
 static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 	struct cfg80211_scan_request *request;
 	struct cfg80211_ssid *ssid;
@@ -2753,13 +2753,13 @@ static int nl80211_trigger_scan(struct s
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	wiphy = &drv->wiphy;
+	wiphy = &rdev->wiphy;
 
-	if (!drv->ops->scan) {
+	if (!rdev->ops->scan) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -2769,7 +2769,7 @@ static int nl80211_trigger_scan(struct s
 		goto out;
 	}
 
-	if (drv->scan_req) {
+	if (rdev->scan_req) {
 		err = -EBUSY;
 		goto out;
 	}
@@ -2876,21 +2876,21 @@ static int nl80211_trigger_scan(struct s
 	}
 
 	request->ifidx = dev->ifindex;
-	request->wiphy = &drv->wiphy;
+	request->wiphy = &rdev->wiphy;
 
-	drv->scan_req = request;
-	err = drv->ops->scan(&drv->wiphy, dev, request);
+	rdev->scan_req = request;
+	err = rdev->ops->scan(&rdev->wiphy, dev, request);
 
 	if (!err)
-		nl80211_send_scan_start(drv, dev);
+		nl80211_send_scan_start(rdev, dev);
 
  out_free:
 	if (err) {
-		drv->scan_req = NULL;
+		rdev->scan_req = NULL;
 		kfree(request);
 	}
  out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -3043,7 +3043,7 @@ static bool nl80211_valid_cipher_suite(u
 
 static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 	struct ieee80211_channel *chan;
 	const u8 *bssid, *ssid, *ie = NULL;
@@ -3067,11 +3067,11 @@ static int nl80211_authenticate(struct s
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
-	if (!drv->ops->auth) {
+	if (!rdev->ops->auth) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -3087,7 +3087,7 @@ static int nl80211_authenticate(struct s
 	}
 
 	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
-	chan = ieee80211_get_channel(&drv->wiphy,
+	chan = ieee80211_get_channel(&rdev->wiphy,
 		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
 	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED)) {
 		err = -EINVAL;
@@ -3108,11 +3108,11 @@ static int nl80211_authenticate(struct s
 		goto out;
 	}
 
-	err = cfg80211_mlme_auth(drv, dev, chan, auth_type, bssid,
+	err = cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
 				 ssid, ssid_len, ie, ie_len);
 
 out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3202,7 +3202,7 @@ static int nl80211_associate(struct sk_b
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -3268,7 +3268,7 @@ unlock_rtnl:
 
 static int nl80211_deauthenticate(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 	const u8 *ie = NULL, *bssid;
 	int err, ie_len = 0;
@@ -3285,11 +3285,11 @@ static int nl80211_deauthenticate(struct
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
-	if (!drv->ops->deauth) {
+	if (!rdev->ops->deauth) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -3318,10 +3318,10 @@ static int nl80211_deauthenticate(struct
 		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	err = cfg80211_mlme_deauth(drv, dev, bssid, ie, ie_len, reason_code);
+	err = cfg80211_mlme_deauth(rdev, dev, bssid, ie, ie_len, reason_code);
 
 out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3330,7 +3330,7 @@ unlock_rtnl:
 
 static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 	const u8 *ie = NULL, *bssid;
 	int err, ie_len = 0;
@@ -3347,11 +3347,11 @@ static int nl80211_disassociate(struct s
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
-	if (!drv->ops->disassoc) {
+	if (!rdev->ops->disassoc) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -3380,10 +3380,10 @@ static int nl80211_disassociate(struct s
 		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	err = cfg80211_mlme_disassoc(drv, dev, bssid, ie, ie_len, reason_code);
+	err = cfg80211_mlme_disassoc(rdev, dev, bssid, ie, ie_len, reason_code);
 
 out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3392,7 +3392,7 @@ unlock_rtnl:
 
 static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 	struct cfg80211_ibss_params ibss;
 	struct wiphy *wiphy;
@@ -3419,11 +3419,11 @@ static int nl80211_join_ibss(struct sk_b
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
-	if (!drv->ops->join_ibss) {
+	if (!rdev->ops->join_ibss) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -3438,7 +3438,7 @@ static int nl80211_join_ibss(struct sk_b
 		goto out;
 	}
 
-	wiphy = &drv->wiphy;
+	wiphy = &rdev->wiphy;
 
 	if (info->attrs[NL80211_ATTR_MAC])
 		ibss.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
@@ -3461,10 +3461,10 @@ static int nl80211_join_ibss(struct sk_b
 
 	ibss.channel_fixed = !!info->attrs[NL80211_ATTR_FREQ_FIXED];
 
-	err = cfg80211_join_ibss(drv, dev, &ibss);
+	err = cfg80211_join_ibss(rdev, dev, &ibss);
 
 out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3473,17 +3473,17 @@ unlock_rtnl:
 
 static int nl80211_leave_ibss(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 	int err;
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
-	if (!drv->ops->leave_ibss) {
+	if (!rdev->ops->leave_ibss) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -3498,10 +3498,10 @@ static int nl80211_leave_ibss(struct sk_
 		goto out;
 	}
 
-	err = cfg80211_leave_ibss(drv, dev, false);
+	err = cfg80211_leave_ibss(rdev, dev, false);
 
 out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3632,7 +3632,7 @@ EXPORT_SYMBOL(cfg80211_testmode_event);
 
 static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 	struct cfg80211_connect_params connect;
 	struct wiphy *wiphy;
@@ -3663,7 +3663,7 @@ static int nl80211_connect(struct sk_buf
 		return err;
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -3677,7 +3677,7 @@ static int nl80211_connect(struct sk_buf
 		goto out;
 	}
 
-	wiphy = &drv->wiphy;
+	wiphy = &rdev->wiphy;
 
 	connect.bssid = NULL;
 	connect.channel = NULL;
@@ -3704,10 +3704,10 @@ static int nl80211_connect(struct sk_buf
 		}
 	}
 
-	err = cfg80211_connect(drv, dev, &connect);
+	err = cfg80211_connect(rdev, dev, &connect);
 
 out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3716,7 +3716,7 @@ unlock_rtnl:
 
 static int nl80211_disconnect(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 	int err;
 	u16 reason;
@@ -3731,7 +3731,7 @@ static int nl80211_disconnect(struct sk_
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -3745,10 +3745,10 @@ static int nl80211_disconnect(struct sk_
 		goto out;
 	}
 
-	err = cfg80211_disconnect(drv, dev, reason, true);
+	err = cfg80211_disconnect(rdev, dev, reason, true);
 
 out:
-	cfg80211_unlock_rdev(drv);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
--- wireless-testing.orig/net/wireless/reg.c	2009-07-07 03:25:42.000000000 +0200
+++ wireless-testing/net/wireless/reg.c	2009-07-07 03:37:06.000000000 +0200
@@ -1061,10 +1061,10 @@ static bool ignore_reg_update(struct wip
 
 static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 
-	list_for_each_entry(drv, &cfg80211_drv_list, list)
-		wiphy_update_regulatory(&drv->wiphy, initiator);
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list)
+		wiphy_update_regulatory(&rdev->wiphy, initiator);
 }
 
 static void handle_reg_beacon(struct wiphy *wiphy,
@@ -1614,7 +1614,7 @@ static void reg_process_pending_hints(vo
 /* Processes beacon hints -- this has nothing to do with country IEs */
 static void reg_process_pending_beacon_hints(void)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct reg_beacon *pending_beacon, *tmp;
 
 	mutex_lock(&cfg80211_mutex);
@@ -1633,8 +1633,8 @@ static void reg_process_pending_beacon_h
 		list_del_init(&pending_beacon->list);
 
 		/* Applies the beacon hint to current wiphys */
-		list_for_each_entry(drv, &cfg80211_drv_list, list)
-			wiphy_update_new_beacon(&drv->wiphy, pending_beacon);
+		list_for_each_entry(rdev, &cfg80211_rdev_list, list)
+			wiphy_update_new_beacon(&rdev->wiphy, pending_beacon);
 
 		/* Remembers the beacon hint for new wiphys or reg changes */
 		list_add_tail(&pending_beacon->list, &reg_beacon_list);
@@ -1814,23 +1814,23 @@ void regulatory_hint_11d(struct wiphy *w
 	if (likely(last_request->initiator ==
 	    NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    wiphy_idx_valid(last_request->wiphy_idx))) {
-		struct cfg80211_registered_device *drv_last_ie;
+		struct cfg80211_registered_device *rdev_last_ie;
 
-		drv_last_ie =
-			cfg80211_drv_by_wiphy_idx(last_request->wiphy_idx);
+		rdev_last_ie =
+			cfg80211_rdev_by_wiphy_idx(last_request->wiphy_idx);
 
 		/*
 		 * Lets keep this simple -- we trust the first AP
 		 * after we intersect with CRDA
 		 */
-		if (likely(&drv_last_ie->wiphy == wiphy)) {
+		if (likely(&rdev_last_ie->wiphy == wiphy)) {
 			/*
 			 * Ignore IEs coming in on this wiphy with
 			 * the same alpha2 and environment cap
 			 */
-			if (likely(alpha2_equal(drv_last_ie->country_ie_alpha2,
+			if (likely(alpha2_equal(rdev_last_ie->country_ie_alpha2,
 				  alpha2) &&
-				  env == drv_last_ie->env)) {
+				  env == rdev_last_ie->env)) {
 				goto out;
 			}
 			/*
@@ -1846,9 +1846,9 @@ void regulatory_hint_11d(struct wiphy *w
 			 * Ignore IEs coming in on two separate wiphys with
 			 * the same alpha2 and environment cap
 			 */
-			if (likely(alpha2_equal(drv_last_ie->country_ie_alpha2,
+			if (likely(alpha2_equal(rdev_last_ie->country_ie_alpha2,
 				  alpha2) &&
-				  env == drv_last_ie->env)) {
+				  env == rdev_last_ie->env)) {
 				goto out;
 			}
 			/* We could potentially intersect though */
@@ -1995,14 +1995,14 @@ static void print_regdomain(const struct
 
 		if (last_request->initiator ==
 		    NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-			struct cfg80211_registered_device *drv;
-			drv = cfg80211_drv_by_wiphy_idx(
+			struct cfg80211_registered_device *rdev;
+			rdev = cfg80211_rdev_by_wiphy_idx(
 				last_request->wiphy_idx);
-			if (drv) {
+			if (rdev) {
 				printk(KERN_INFO "cfg80211: Current regulatory "
 					"domain updated by AP to: %c%c\n",
-					drv->country_ie_alpha2[0],
-					drv->country_ie_alpha2[1]);
+					rdev->country_ie_alpha2[0],
+					rdev->country_ie_alpha2[1]);
 			} else
 				printk(KERN_INFO "cfg80211: Current regulatory "
 					"domain intersected: \n");
@@ -2063,7 +2063,7 @@ static inline void reg_country_ie_proces
 static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
 	const struct ieee80211_regdomain *intersected_rd = NULL;
-	struct cfg80211_registered_device *drv = NULL;
+	struct cfg80211_registered_device *rdev = NULL;
 	struct wiphy *request_wiphy;
 	/* Some basic sanity checks first */
 
@@ -2202,11 +2202,11 @@ static int __set_regdom(const struct iee
 	if (!intersected_rd)
 		return -EINVAL;
 
-	drv = wiphy_to_dev(request_wiphy);
+	rdev = wiphy_to_dev(request_wiphy);
 
-	drv->country_ie_alpha2[0] = rd->alpha2[0];
-	drv->country_ie_alpha2[1] = rd->alpha2[1];
-	drv->env = last_request->country_ie_env;
+	rdev->country_ie_alpha2[0] = rd->alpha2[0];
+	rdev->country_ie_alpha2[1] = rd->alpha2[1];
+	rdev->env = last_request->country_ie_env;
 
 	BUG_ON(intersected_rd == rd);
 
--- wireless-testing.orig/net/wireless/sme.c	2009-07-07 03:37:06.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-07-07 03:37:06.000000000 +0200
@@ -33,15 +33,15 @@ struct cfg80211_conn {
 
 static int cfg80211_conn_scan(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *drv = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_scan_request *request;
 	int n_channels, err;
 
 	ASSERT_RTNL();
-	ASSERT_RDEV_LOCK(drv);
+	ASSERT_RDEV_LOCK(rdev);
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (drv->scan_req)
+	if (rdev->scan_req)
 		return -EBUSY;
 
 	if (wdev->conn->params.channel) {
@@ -87,16 +87,16 @@ static int cfg80211_conn_scan(struct wir
 	request->ssids[0].ssid_len = wdev->conn->params.ssid_len;
 
 	request->ifidx = wdev->netdev->ifindex;
-	request->wiphy = &drv->wiphy;
+	request->wiphy = &rdev->wiphy;
 
-	drv->scan_req = request;
+	rdev->scan_req = request;
 
-	err = drv->ops->scan(wdev->wiphy, wdev->netdev, request);
+	err = rdev->ops->scan(wdev->wiphy, wdev->netdev, request);
 	if (!err) {
 		wdev->conn->state = CFG80211_CONN_SCANNING;
-		nl80211_send_scan_start(drv, wdev->netdev);
+		nl80211_send_scan_start(rdev, wdev->netdev);
 	} else {
-		drv->scan_req = NULL;
+		rdev->scan_req = NULL;
 		kfree(request);
 	}
 	return err;
@@ -104,7 +104,7 @@ static int cfg80211_conn_scan(struct wir
 
 static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *drv = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_connect_params *params;
 	int err;
 
@@ -119,15 +119,15 @@ static int cfg80211_conn_do_work(struct 
 	case CFG80211_CONN_SCAN_AGAIN:
 		return cfg80211_conn_scan(wdev);
 	case CFG80211_CONN_AUTHENTICATE_NEXT:
-		BUG_ON(!drv->ops->auth);
+		BUG_ON(!rdev->ops->auth);
 		wdev->conn->state = CFG80211_CONN_AUTHENTICATING;
-		return __cfg80211_mlme_auth(drv, wdev->netdev,
+		return __cfg80211_mlme_auth(rdev, wdev->netdev,
 					    params->channel, params->auth_type,
 					    params->bssid,
 					    params->ssid, params->ssid_len,
 					    NULL, 0);
 	case CFG80211_CONN_ASSOCIATE_NEXT:
-		BUG_ON(!drv->ops->assoc);
+		BUG_ON(!rdev->ops->assoc);
 		wdev->conn->state = CFG80211_CONN_ASSOCIATING;
 		/*
 		 * We could, later, implement roaming here and then actually
@@ -135,14 +135,14 @@ static int cfg80211_conn_do_work(struct 
 		 * that some APs don't like that -- so we'd need to retry
 		 * the association.
 		 */
-		err = __cfg80211_mlme_assoc(drv, wdev->netdev,
+		err = __cfg80211_mlme_assoc(rdev, wdev->netdev,
 					    params->channel, params->bssid,
 					    NULL,
 					    params->ssid, params->ssid_len,
 					    params->ie, params->ie_len,
 					    false, &params->crypto);
 		if (err)
-			__cfg80211_mlme_deauth(drv, wdev->netdev, params->bssid,
+			__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 					       NULL, 0,
 					       WLAN_REASON_DEAUTH_LEAVING);
 		return err;
@@ -153,15 +153,15 @@ static int cfg80211_conn_do_work(struct 
 
 void cfg80211_conn_work(struct work_struct *work)
 {
-	struct cfg80211_registered_device *drv =
+	struct cfg80211_registered_device *rdev =
 		container_of(work, struct cfg80211_registered_device, conn_work);
 	struct wireless_dev *wdev;
 
 	rtnl_lock();
-	cfg80211_lock_rdev(drv);
-	mutex_lock(&drv->devlist_mtx);
+	cfg80211_lock_rdev(rdev);
+	mutex_lock(&rdev->devlist_mtx);
 
-	list_for_each_entry(wdev, &drv->netdev_list, list) {
+	list_for_each_entry(wdev, &rdev->netdev_list, list) {
 		wdev_lock(wdev);
 		if (!netif_running(wdev->netdev)) {
 			wdev_unlock(wdev);
@@ -181,14 +181,14 @@ void cfg80211_conn_work(struct work_stru
 		wdev_unlock(wdev);
 	}
 
-	mutex_unlock(&drv->devlist_mtx);
-	cfg80211_unlock_rdev(drv);
+	mutex_unlock(&rdev->devlist_mtx);
+	cfg80211_unlock_rdev(rdev);
 	rtnl_unlock();
 }
 
 static bool cfg80211_get_conn_bss(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *drv = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_bss *bss;
 	u16 capa = WLAN_CAPABILITY_ESS;
 
@@ -209,7 +209,7 @@ static bool cfg80211_get_conn_bss(struct
 	wdev->conn->params.bssid = wdev->conn->bssid;
 	wdev->conn->params.channel = bss->channel;
 	wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
-	schedule_work(&drv->conn_work);
+	schedule_work(&rdev->conn_work);
 
 	cfg80211_put_bss(bss);
 	return true;
@@ -218,7 +218,7 @@ static bool cfg80211_get_conn_bss(struct
 static void __cfg80211_sme_scan_done(struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *drv = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -235,7 +235,7 @@ static void __cfg80211_sme_scan_done(str
 	if (!cfg80211_get_conn_bss(wdev)) {
 		/* not found */
 		if (wdev->conn->state == CFG80211_CONN_SCAN_AGAIN)
-			schedule_work(&drv->conn_work);
+			schedule_work(&rdev->conn_work);
 		else
 			__cfg80211_connect_result(
 					wdev->netdev,

-- 

