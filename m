Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3EPVDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 17:03:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/9] cfg80211: vastly simplify locking
Date: Thu, 16 May 2013 23:03:32 +0200
Message-Id: <1368738218-7597-4-git-send-email-johannes@sipsolutions.net> (sfid-20130516_230400_334263_6FC104F1)
In-Reply-To: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net>
References: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Virtually all code paths in cfg80211 already (need to) hold
the RTNL. As such, there's little point in having another
four mutexes for various parts of the code, they just cause
lock ordering issues (and much of the time, the RTNL and a
few of the others need thus be held.)

Simplify all this by getting rid of the extra four mutexes
and just use the RTNL throughout. Only a few code changes
were needed to do this and we can get rid of a work struct
for bonus points.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h     |   5 +-
 net/wireless/core.c        | 166 ++++++++----------------------------------
 net/wireless/core.h        |  32 +-------
 net/wireless/debugfs.c     |   4 +-
 net/wireless/ibss.c        |  10 +--
 net/wireless/mesh.c        |   2 -
 net/wireless/mlme.c        |  12 +--
 net/wireless/nl80211.c     | 178 +++++++++------------------------------------
 net/wireless/reg.c         |  36 +++------
 net/wireless/scan.c        |  42 +++++------
 net/wireless/sme.c         |  26 +------
 net/wireless/util.c        |  11 ---
 net/wireless/wext-compat.c |  22 +-----
 net/wireless/wext-sme.c    |  18 -----
 14 files changed, 117 insertions(+), 447 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 32a2f1b..d5a7063 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1257,6 +1257,7 @@ struct cfg80211_ssid {
  * @scan_start: time (in jiffies) when the scan started
  * @wdev: the wireless device to scan for
  * @aborted: (internal) scan request was notified as aborted
+ * @notified: (internal) scan request was notified as done or aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
  */
 struct cfg80211_scan_request {
@@ -1274,7 +1275,7 @@ struct cfg80211_scan_request {
 	/* internal */
 	struct wiphy *wiphy;
 	unsigned long scan_start;
-	bool aborted;
+	bool aborted, notified;
 	bool no_cck;
 
 	/* keep last */
@@ -2874,8 +2875,6 @@ struct wireless_dev {
 
 	struct mutex mtx;
 
-	struct work_struct cleanup_work;
-
 	bool use_4addr, p2p_started;
 
 	u8 address[ETH_ALEN] __aligned(sizeof(u16));
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9416b8f..5fc642d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -36,12 +36,10 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("wireless configuration support");
 MODULE_ALIAS_GENL_FAMILY(NL80211_GENL_NAME);
 
-/* RCU-protected (and cfg80211_mutex for writers) */
+/* RCU-protected (and RTNL for writers) */
 LIST_HEAD(cfg80211_rdev_list);
 int cfg80211_rdev_list_generation;
 
-DEFINE_MUTEX(cfg80211_mutex);
-
 /* for debugfs */
 static struct dentry *ieee80211_debugfs_dir;
 
@@ -53,12 +51,11 @@ module_param(cfg80211_disable_40mhz_24ghz, bool, 0644);
 MODULE_PARM_DESC(cfg80211_disable_40mhz_24ghz,
 		 "Disable 40MHz support in the 2.4GHz band");
 
-/* requires cfg80211_mutex to be held! */
 struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx)
 {
 	struct cfg80211_registered_device *result = NULL, *rdev;
 
-	assert_cfg80211_lock();
+	ASSERT_RTNL();
 
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		if (rdev->wiphy_idx == wiphy_idx) {
@@ -77,12 +74,11 @@ int get_wiphy_idx(struct wiphy *wiphy)
 	return rdev->wiphy_idx;
 }
 
-/* requires cfg80211_rdev_mutex to be held! */
 struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
 {
 	struct cfg80211_registered_device *rdev;
 
-	assert_cfg80211_lock();
+	ASSERT_RTNL();
 
 	rdev = cfg80211_rdev_by_wiphy_idx(wiphy_idx);
 	if (!rdev)
@@ -90,14 +86,13 @@ struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
 	return &rdev->wiphy;
 }
 
-/* requires cfg80211_mutex to be held */
 int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			char *newname)
 {
 	struct cfg80211_registered_device *rdev2;
 	int wiphy_idx, taken = -1, result, digits;
 
-	assert_cfg80211_lock();
+	ASSERT_RTNL();
 
 	/* prohibit calling the thing phy%d when %d is not its number */
 	sscanf(newname, PHY_NAME "%d%n", &wiphy_idx, &taken);
@@ -195,8 +190,7 @@ static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
 void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev)
 {
-	lockdep_assert_held(&rdev->devlist_mtx);
-	lockdep_assert_held(&rdev->sched_scan_mtx);
+	ASSERT_RTNL();
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_P2P_DEVICE))
 		return;
@@ -235,8 +229,6 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
 
 	rtnl_lock();
 
-	/* read-only iteration need not hold the devlist_mtx */
-
 	list_for_each_entry(wdev, &rdev->wdev_list, list) {
 		if (wdev->netdev) {
 			dev_close(wdev->netdev);
@@ -245,12 +237,7 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
 		/* otherwise, check iftype */
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_P2P_DEVICE:
-			/* but this requires it */
-			mutex_lock(&rdev->devlist_mtx);
-			mutex_lock(&rdev->sched_scan_mtx);
 			cfg80211_stop_p2p_device(rdev, wdev);
-			mutex_unlock(&rdev->sched_scan_mtx);
-			mutex_unlock(&rdev->devlist_mtx);
 			break;
 		default:
 			break;
@@ -278,10 +265,7 @@ static void cfg80211_event_work(struct work_struct *work)
 			    event_work);
 
 	rtnl_lock();
-	cfg80211_lock_rdev(rdev);
-
 	cfg80211_process_rdev_events(rdev);
-	cfg80211_unlock_rdev(rdev);
 	rtnl_unlock();
 }
 
@@ -323,9 +307,6 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	/* give it a proper name */
 	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
 
-	mutex_init(&rdev->mtx);
-	mutex_init(&rdev->devlist_mtx);
-	mutex_init(&rdev->sched_scan_mtx);
 	INIT_LIST_HEAD(&rdev->wdev_list);
 	INIT_LIST_HEAD(&rdev->beacon_registrations);
 	spin_lock_init(&rdev->beacon_registrations_lock);
@@ -573,11 +554,11 @@ int wiphy_register(struct wiphy *wiphy)
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
 
-	mutex_lock(&cfg80211_mutex);
+	rtnl_lock();
 
 	res = device_add(&rdev->wiphy.dev);
 	if (res) {
-		mutex_unlock(&cfg80211_mutex);
+		rtnl_unlock();
 		return res;
 	}
 
@@ -606,25 +587,18 @@ int wiphy_register(struct wiphy *wiphy)
 	}
 
 	cfg80211_debugfs_rdev_add(rdev);
-	mutex_unlock(&cfg80211_mutex);
 
-	/*
-	 * due to a locking dependency this has to be outside of the
-	 * cfg80211_mutex lock
-	 */
 	res = rfkill_register(rdev->rfkill);
 	if (res) {
 		device_del(&rdev->wiphy.dev);
 
-		mutex_lock(&cfg80211_mutex);
 		debugfs_remove_recursive(rdev->wiphy.debugfsdir);
 		list_del_rcu(&rdev->list);
 		wiphy_regulatory_deregister(wiphy);
-		mutex_unlock(&cfg80211_mutex);
+		rtnl_unlock();
 		return res;
 	}
 
-	rtnl_lock();
 	rdev->wiphy.registered = true;
 	rtnl_unlock();
 	return 0;
@@ -654,25 +628,19 @@ void wiphy_unregister(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	rtnl_lock();
-	rdev->wiphy.registered = false;
-	rtnl_unlock();
-
-	rfkill_unregister(rdev->rfkill);
-
-	/* protect the device list */
-	mutex_lock(&cfg80211_mutex);
-
 	wait_event(rdev->dev_wait, ({
 		int __count;
-		mutex_lock(&rdev->devlist_mtx);
+		rtnl_lock();
 		__count = rdev->opencount;
-		mutex_unlock(&rdev->devlist_mtx);
+		rtnl_unlock();
 		__count == 0; }));
 
-	mutex_lock(&rdev->devlist_mtx);
+	rtnl_lock();
+	rdev->wiphy.registered = false;
+
+	rfkill_unregister(rdev->rfkill);
+
 	BUG_ON(!list_empty(&rdev->wdev_list));
-	mutex_unlock(&rdev->devlist_mtx);
 
 	/*
 	 * First remove the hardware from everywhere, this makes
@@ -683,20 +651,6 @@ void wiphy_unregister(struct wiphy *wiphy)
 	synchronize_rcu();
 
 	/*
-	 * Try to grab rdev->mtx. If a command is still in progress,
-	 * hopefully the driver will refuse it since it's tearing
-	 * down the device already. We wait for this command to complete
-	 * before unlinking the item from the list.
-	 * Note: as codified by the BUG_ON above we cannot get here if
-	 * a virtual interface is still present. Hence, we can only get
-	 * to lock contention here if userspace issues a command that
-	 * identified the hardware by wiphy index.
-	 */
-	cfg80211_lock_rdev(rdev);
-	/* nothing */
-	cfg80211_unlock_rdev(rdev);
-
-	/*
 	 * If this device got a regulatory hint tell core its
 	 * free to listen now to a new shiny device regulatory hint
 	 */
@@ -705,7 +659,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	cfg80211_rdev_list_generation++;
 	device_del(&rdev->wiphy.dev);
 
-	mutex_unlock(&cfg80211_mutex);
+	rtnl_unlock();
 
 	flush_work(&rdev->scan_done_wk);
 	cancel_work_sync(&rdev->conn_work);
@@ -723,9 +677,6 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 	struct cfg80211_internal_bss *scan, *tmp;
 	struct cfg80211_beacon_registration *reg, *treg;
 	rfkill_destroy(rdev->rfkill);
-	mutex_destroy(&rdev->mtx);
-	mutex_destroy(&rdev->devlist_mtx);
-	mutex_destroy(&rdev->sched_scan_mtx);
 	list_for_each_entry_safe(reg, treg, &rdev->beacon_registrations, list) {
 		list_del(&reg->list);
 		kfree(reg);
@@ -750,36 +701,6 @@ void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked)
 }
 EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
 
-static void wdev_cleanup_work(struct work_struct *work)
-{
-	struct wireless_dev *wdev;
-	struct cfg80211_registered_device *rdev;
-
-	wdev = container_of(work, struct wireless_dev, cleanup_work);
-	rdev = wiphy_to_dev(wdev->wiphy);
-
-	mutex_lock(&rdev->sched_scan_mtx);
-
-	if (WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev)) {
-		rdev->scan_req->aborted = true;
-		___cfg80211_scan_done(rdev, true);
-	}
-
-	if (WARN_ON(rdev->sched_scan_req &&
-		    rdev->sched_scan_req->dev == wdev->netdev)) {
-		__cfg80211_stop_sched_scan(rdev, false);
-	}
-
-	mutex_unlock(&rdev->sched_scan_mtx);
-
-	mutex_lock(&rdev->devlist_mtx);
-	rdev->opencount--;
-	mutex_unlock(&rdev->devlist_mtx);
-	wake_up(&rdev->dev_wait);
-
-	dev_put(wdev->netdev);
-}
-
 void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -789,8 +710,6 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 	if (WARN_ON(wdev->netdev))
 		return;
 
-	mutex_lock(&rdev->devlist_mtx);
-	mutex_lock(&rdev->sched_scan_mtx);
 	list_del_rcu(&wdev->list);
 	rdev->devlist_generation++;
 
@@ -802,8 +721,6 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 		WARN_ON_ONCE(1);
 		break;
 	}
-	mutex_unlock(&rdev->sched_scan_mtx);
-	mutex_unlock(&rdev->devlist_mtx);
 }
 EXPORT_SYMBOL(cfg80211_unregister_wdev);
 
@@ -822,7 +739,7 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 }
 
 void cfg80211_leave(struct cfg80211_registered_device *rdev,
-		   struct wireless_dev *wdev)
+		    struct wireless_dev *wdev)
 {
 	struct net_device *dev = wdev->netdev;
 
@@ -832,9 +749,7 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-		mutex_lock(&rdev->sched_scan_mtx);
 		__cfg80211_stop_sched_scan(rdev, false);
-		mutex_unlock(&rdev->sched_scan_mtx);
 
 		wdev_lock(wdev);
 #ifdef CONFIG_CFG80211_WEXT
@@ -887,13 +802,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 * are added with nl80211.
 		 */
 		mutex_init(&wdev->mtx);
-		INIT_WORK(&wdev->cleanup_work, wdev_cleanup_work);
 		INIT_LIST_HEAD(&wdev->event_list);
 		spin_lock_init(&wdev->event_lock);
 		INIT_LIST_HEAD(&wdev->mgmt_registrations);
 		spin_lock_init(&wdev->mgmt_registrations_lock);
 
-		mutex_lock(&rdev->devlist_mtx);
 		wdev->identifier = ++rdev->wdev_id;
 		list_add_rcu(&wdev->list, &rdev->wdev_list);
 		rdev->devlist_generation++;
@@ -906,7 +819,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		}
 		wdev->netdev = dev;
 		wdev->sme_state = CFG80211_SME_IDLE;
-		mutex_unlock(&rdev->devlist_mtx);
 #ifdef CONFIG_CFG80211_WEXT
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
@@ -932,26 +844,22 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		break;
 	case NETDEV_DOWN:
 		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
-		dev_hold(dev);
-		queue_work(cfg80211_wq, &wdev->cleanup_work);
+		if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
+			if (WARN_ON(!rdev->scan_req->notified))
+				rdev->scan_req->aborted = true;
+			___cfg80211_scan_done(rdev, true);
+		}
+
+		if (WARN_ON(rdev->sched_scan_req &&
+			    rdev->sched_scan_req->dev == wdev->netdev)) {
+			__cfg80211_stop_sched_scan(rdev, false);
+		}
+
+		rdev->opencount--;
+		wake_up(&rdev->dev_wait);
 		break;
 	case NETDEV_UP:
-		/*
-		 * If we have a really quick DOWN/UP succession we may
-		 * have this work still pending ... cancel it and see
-		 * if it was pending, in which case we need to account
-		 * for some of the work it would have done.
-		 */
-		if (cancel_work_sync(&wdev->cleanup_work)) {
-			mutex_lock(&rdev->devlist_mtx);
-			rdev->opencount--;
-			mutex_unlock(&rdev->devlist_mtx);
-			dev_put(dev);
-		}
 		cfg80211_update_iface_num(rdev, wdev->iftype, 1);
-		cfg80211_lock_rdev(rdev);
-		mutex_lock(&rdev->devlist_mtx);
-		mutex_lock(&rdev->sched_scan_mtx);
 		wdev_lock(wdev);
 		switch (wdev->iftype) {
 #ifdef CONFIG_CFG80211_WEXT
@@ -983,10 +891,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			break;
 		}
 		wdev_unlock(wdev);
-		mutex_unlock(&rdev->sched_scan_mtx);
 		rdev->opencount++;
-		mutex_unlock(&rdev->devlist_mtx);
-		cfg80211_unlock_rdev(rdev);
 
 		/*
 		 * Configure power management to the driver here so that its
@@ -1003,12 +908,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		break;
 	case NETDEV_UNREGISTER:
 		/*
-		 * NB: cannot take rdev->mtx here because this may be
-		 * called within code protected by it when interfaces
-		 * are removed with nl80211.
-		 */
-		mutex_lock(&rdev->devlist_mtx);
-		/*
 		 * It is possible to get NETDEV_UNREGISTER
 		 * multiple times. To detect that, check
 		 * that the interface is still on the list
@@ -1024,7 +923,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			kfree(wdev->wext.keys);
 #endif
 		}
-		mutex_unlock(&rdev->devlist_mtx);
 		/*
 		 * synchronise (so that we won't find this netdev
 		 * from other code any more) and then clear the list
@@ -1044,9 +942,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			return notifier_from_errno(-EOPNOTSUPP);
 		if (rfkill_blocked(rdev->rfkill))
 			return notifier_from_errno(-ERFKILL);
-		mutex_lock(&rdev->devlist_mtx);
 		ret = cfg80211_can_add_interface(rdev, wdev->iftype);
-		mutex_unlock(&rdev->devlist_mtx);
 		if (ret)
 			return notifier_from_errno(ret);
 		break;
@@ -1064,12 +960,10 @@ static void __net_exit cfg80211_pernet_exit(struct net *net)
 	struct cfg80211_registered_device *rdev;
 
 	rtnl_lock();
-	mutex_lock(&cfg80211_mutex);
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		if (net_eq(wiphy_net(&rdev->wiphy), net))
 			WARN_ON(cfg80211_switch_netns(rdev, &init_net));
 	}
-	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 }
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 95b2907..d21a0fc 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -5,7 +5,6 @@
  */
 #ifndef __NET_WIRELESS_CORE_H
 #define __NET_WIRELESS_CORE_H
-#include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/rbtree.h>
@@ -23,11 +22,6 @@
 struct cfg80211_registered_device {
 	const struct cfg80211_ops *ops;
 	struct list_head list;
-	/* we hold this mutex during any call so that
-	 * we cannot do multiple calls at once, and also
-	 * to avoid the deregister call to proceed while
-	 * any call is in progress */
-	struct mutex mtx;
 
 	/* rfkill support */
 	struct rfkill_ops rfkill_ops;
@@ -49,9 +43,7 @@ struct cfg80211_registered_device {
 	/* wiphy index, internal only */
 	int wiphy_idx;
 
-	/* associated wireless interfaces */
-	struct mutex devlist_mtx;
-	/* protected by devlist_mtx or RCU */
+	/* associated wireless interfaces, protected by rtnl or RCU */
 	struct list_head wdev_list;
 	int devlist_generation, wdev_id;
 	int opencount; /* also protected by devlist_mtx */
@@ -75,8 +67,6 @@ struct cfg80211_registered_device {
 	struct work_struct scan_done_wk;
 	struct work_struct sched_scan_results_wk;
 
-	struct mutex sched_scan_mtx;
-
 #ifdef CONFIG_NL80211_TESTMODE
 	struct genl_info *testmode_info;
 #endif
@@ -120,15 +110,9 @@ cfg80211_rdev_free_wowlan(struct cfg80211_registered_device *rdev)
 }
 
 extern struct workqueue_struct *cfg80211_wq;
-extern struct mutex cfg80211_mutex;
 extern struct list_head cfg80211_rdev_list;
 extern int cfg80211_rdev_list_generation;
 
-static inline void assert_cfg80211_lock(void)
-{
-	lockdep_assert_held(&cfg80211_mutex);
-}
-
 struct cfg80211_internal_bss {
 	struct list_head list;
 	struct list_head hidden_list;
@@ -161,23 +145,11 @@ static inline void cfg80211_unhold_bss(struct cfg80211_internal_bss *bss)
 struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx);
 int get_wiphy_idx(struct wiphy *wiphy);
 
-/* requires cfg80211_rdev_mutex to be held! */
 struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx);
 
 int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			  struct net *net);
 
-static inline void cfg80211_lock_rdev(struct cfg80211_registered_device *rdev)
-{
-	mutex_lock(&rdev->mtx);
-}
-
-static inline void cfg80211_unlock_rdev(struct cfg80211_registered_device *rdev)
-{
-	BUG_ON(IS_ERR(rdev) || !rdev);
-	mutex_unlock(&rdev->mtx);
-}
-
 static inline void wdev_lock(struct wireless_dev *wdev)
 	__acquires(wdev)
 {
@@ -192,7 +164,7 @@ static inline void wdev_unlock(struct wireless_dev *wdev)
 	mutex_unlock(&wdev->mtx);
 }
 
-#define ASSERT_RDEV_LOCK(rdev) lockdep_assert_held(&(rdev)->mtx)
+#define ASSERT_RDEV_LOCK(rdev) ASSERT_RTNL()
 #define ASSERT_WDEV_LOCK(wdev) lockdep_assert_held(&(wdev)->mtx)
 
 static inline bool cfg80211_has_monitors_only(struct cfg80211_registered_device *rdev)
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 920cabe..90d0500 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -74,7 +74,7 @@ static ssize_t ht40allow_map_read(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	mutex_lock(&cfg80211_mutex);
+	rtnl_lock();
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		sband = wiphy->bands[band];
@@ -85,7 +85,7 @@ static ssize_t ht40allow_map_read(struct file *file,
 						buf, buf_size, offset);
 	}
 
-	mutex_unlock(&cfg80211_mutex);
+	rtnl_unlock();
 
 	r = simple_read_from_buffer(user_buf, count, ppos, buf, offset);
 
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index d80e471..5449c5a 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -152,11 +152,11 @@ int cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
-	mutex_lock(&rdev->devlist_mtx);
+	ASSERT_RTNL();
+
 	wdev_lock(wdev);
 	err = __cfg80211_join_ibss(rdev, dev, params, connkeys);
 	wdev_unlock(wdev);
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
@@ -359,11 +359,9 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 		wdev->wext.ibss.channel_fixed = false;
 	}
 
-	mutex_lock(&rdev->devlist_mtx);
 	wdev_lock(wdev);
 	err = cfg80211_ibss_wext_join(rdev, wdev);
 	wdev_unlock(wdev);
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
@@ -429,11 +427,9 @@ int cfg80211_ibss_wext_siwessid(struct net_device *dev,
 	memcpy(wdev->wext.ibss.ssid, ssid, len);
 	wdev->wext.ibss.ssid_len = len;
 
-	mutex_lock(&rdev->devlist_mtx);
 	wdev_lock(wdev);
 	err = cfg80211_ibss_wext_join(rdev, wdev);
 	wdev_unlock(wdev);
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
@@ -512,11 +508,9 @@ int cfg80211_ibss_wext_siwap(struct net_device *dev,
 	} else
 		wdev->wext.ibss.bssid = NULL;
 
-	mutex_lock(&rdev->devlist_mtx);
 	wdev_lock(wdev);
 	err = cfg80211_ibss_wext_join(rdev, wdev);
 	wdev_unlock(wdev);
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 9546ad2..5dfb289 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -186,11 +186,9 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
-	mutex_lock(&rdev->devlist_mtx);
 	wdev_lock(wdev);
 	err = __cfg80211_join_mesh(rdev, dev, setup, conf);
 	wdev_unlock(wdev);
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index c21e32f..68b40f2 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -313,14 +313,14 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 {
 	int err;
 
-	mutex_lock(&rdev->devlist_mtx);
+	ASSERT_RTNL();
+
 	wdev_lock(dev->ieee80211_ptr);
 	err = __cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
 				   ssid, ssid_len, ie, ie_len,
 				   key, key_len, key_idx,
 				   sae_data, sae_data_len);
 	wdev_unlock(dev->ieee80211_ptr);
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
@@ -424,12 +424,12 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
-	mutex_lock(&rdev->devlist_mtx);
+	ASSERT_RTNL();
+
 	wdev_lock(wdev);
 	err = __cfg80211_mlme_assoc(rdev, dev, chan, bssid,
 				    ssid, ssid_len, req);
 	wdev_unlock(wdev);
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
@@ -844,7 +844,7 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 			    dfs_update_channels_wk);
 	wiphy = &rdev->wiphy;
 
-	mutex_lock(&cfg80211_mutex);
+	rtnl_lock();
 	for (bandid = 0; bandid < IEEE80211_NUM_BANDS; bandid++) {
 		sband = wiphy->bands[bandid];
 		if (!sband)
@@ -877,7 +877,7 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 			check_again = true;
 		}
 	}
-	mutex_unlock(&cfg80211_mutex);
+	rtnl_unlock();
 
 	/* reschedule if there are other channels waiting to be cleared again */
 	if (check_again)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3327083..638b1cb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -59,7 +59,7 @@ __cfg80211_wdev_from_attrs(struct net *netns, struct nlattr **attrs)
 	int wiphy_idx = -1;
 	int ifidx = -1;
 
-	assert_cfg80211_lock();
+	ASSERT_RTNL();
 
 	if (!have_ifidx && !have_wdev_id)
 		return ERR_PTR(-EINVAL);
@@ -80,7 +80,6 @@ __cfg80211_wdev_from_attrs(struct net *netns, struct nlattr **attrs)
 		if (have_wdev_id && rdev->wiphy_idx != wiphy_idx)
 			continue;
 
-		mutex_lock(&rdev->devlist_mtx);
 		list_for_each_entry(wdev, &rdev->wdev_list, list) {
 			if (have_ifidx && wdev->netdev &&
 			    wdev->netdev->ifindex == ifidx) {
@@ -92,7 +91,6 @@ __cfg80211_wdev_from_attrs(struct net *netns, struct nlattr **attrs)
 				break;
 			}
 		}
-		mutex_unlock(&rdev->devlist_mtx);
 
 		if (result)
 			break;
@@ -109,7 +107,7 @@ __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 	struct cfg80211_registered_device *rdev = NULL, *tmp;
 	struct net_device *netdev;
 
-	assert_cfg80211_lock();
+	ASSERT_RTNL();
 
 	if (!attrs[NL80211_ATTR_WIPHY] &&
 	    !attrs[NL80211_ATTR_IFINDEX] &&
@@ -128,14 +126,12 @@ __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 		tmp = cfg80211_rdev_by_wiphy_idx(wdev_id >> 32);
 		if (tmp) {
 			/* make sure wdev exists */
-			mutex_lock(&tmp->devlist_mtx);
 			list_for_each_entry(wdev, &tmp->wdev_list, list) {
 				if (wdev->identifier != (u32)wdev_id)
 					continue;
 				found = true;
 				break;
 			}
-			mutex_unlock(&tmp->devlist_mtx);
 
 			if (!found)
 				tmp = NULL;
@@ -182,19 +178,6 @@ __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 /*
  * This function returns a pointer to the driver
  * that the genl_info item that is passed refers to.
- * If successful, it returns non-NULL and also locks
- * the driver's mutex!
- *
- * This means that you need to call cfg80211_unlock_rdev()
- * before being allowed to acquire &cfg80211_mutex!
- *
- * This is necessary because we need to lock the global
- * mutex to get an item off the list safely, and then
- * we lock the rdev mutex so it doesn't go away under us.
- *
- * We don't want to keep cfg80211_mutex locked
- * for all the time in order to allow requests on
- * other interfaces to go through at the same time.
  *
  * The result of this can be a PTR_ERR and hence must
  * be checked with IS_ERR() for errors.
@@ -202,20 +185,7 @@ __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 static struct cfg80211_registered_device *
 cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
 {
-	struct cfg80211_registered_device *rdev;
-
-	mutex_lock(&cfg80211_mutex);
-	rdev = __cfg80211_rdev_from_attrs(netns, info->attrs);
-
-	/* if it is not an error we grab the lock on
-	 * it to assure it won't be going away while
-	 * we operate on it */
-	if (!IS_ERR(rdev))
-		mutex_lock(&rdev->mtx);
-
-	mutex_unlock(&cfg80211_mutex);
-
-	return rdev;
+	return __cfg80211_rdev_from_attrs(netns, info->attrs);
 }
 
 /* policy for the attributes */
@@ -455,7 +425,6 @@ static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 	int err;
 
 	rtnl_lock();
-	mutex_lock(&cfg80211_mutex);
 
 	if (!cb->args[0]) {
 		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
@@ -484,14 +453,12 @@ static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 		*rdev = wiphy_to_dev(wiphy);
 		*wdev = NULL;
 
-		mutex_lock(&(*rdev)->devlist_mtx);
 		list_for_each_entry(tmp, &(*rdev)->wdev_list, list) {
 			if (tmp->identifier == cb->args[1]) {
 				*wdev = tmp;
 				break;
 			}
 		}
-		mutex_unlock(&(*rdev)->devlist_mtx);
 
 		if (!*wdev) {
 			err = -ENODEV;
@@ -499,19 +466,14 @@ static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 		}
 	}
 
-	cfg80211_lock_rdev(*rdev);
-
-	mutex_unlock(&cfg80211_mutex);
 	return 0;
  out_unlock:
-	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 	return err;
 }
 
 static void nl80211_finish_wdev_dump(struct cfg80211_registered_device *rdev)
 {
-	cfg80211_unlock_rdev(rdev);
 	rtnl_unlock();
 }
 
@@ -1567,7 +1529,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nlattr **tb = nl80211_fam.attrbuf;
 	int res;
 
-	mutex_lock(&cfg80211_mutex);
+	rtnl_lock();
 	res = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
 			  tb, nl80211_fam.maxattr, nl80211_policy);
 	if (res == 0) {
@@ -1581,10 +1543,8 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 			int ifidx = nla_get_u32(tb[NL80211_ATTR_IFINDEX]);
 
 			netdev = dev_get_by_index(sock_net(skb->sk), ifidx);
-			if (!netdev) {
-				mutex_unlock(&cfg80211_mutex);
+			if (!netdev)
 				return -ENODEV;
-			}
 			if (netdev->ieee80211_ptr) {
 				dev = wiphy_to_dev(
 					netdev->ieee80211_ptr->wiphy);
@@ -1628,7 +1588,6 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 				    !skb->len &&
 				    cb->min_dump_alloc < 4096) {
 					cb->min_dump_alloc = 4096;
-					mutex_unlock(&cfg80211_mutex);
 					return 1;
 				}
 				idx--;
@@ -1637,7 +1596,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 		} while (cb->args[1] > 0);
 		break;
 	}
-	mutex_unlock(&cfg80211_mutex);
+	rtnl_unlock();
 
 	cb->args[0] = idx;
 
@@ -1792,7 +1751,6 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 	if (result)
 		return result;
 
-	mutex_lock(&rdev->devlist_mtx);
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
@@ -1816,7 +1774,6 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 	default:
 		result = -EINVAL;
 	}
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return result;
 }
@@ -1865,6 +1822,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	u32 frag_threshold = 0, rts_threshold = 0;
 	u8 coverage_class = 0;
 
+	ASSERT_RTNL();
+
 	/*
 	 * Try to find the wiphy and netdev. Normally this
 	 * function shouldn't need the netdev, but this is
@@ -1874,31 +1833,25 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	 * also passed a netdev to set_wiphy, so that it is
 	 * possible to let that go to the right netdev!
 	 */
-	mutex_lock(&cfg80211_mutex);
 
 	if (info->attrs[NL80211_ATTR_IFINDEX]) {
 		int ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
 
 		netdev = dev_get_by_index(genl_info_net(info), ifindex);
-		if (netdev && netdev->ieee80211_ptr) {
+		if (netdev && netdev->ieee80211_ptr)
 			rdev = wiphy_to_dev(netdev->ieee80211_ptr->wiphy);
-			mutex_lock(&rdev->mtx);
-		} else
+		else
 			netdev = NULL;
 	}
 
 	if (!netdev) {
 		rdev = __cfg80211_rdev_from_attrs(genl_info_net(info),
 						  info->attrs);
-		if (IS_ERR(rdev)) {
-			mutex_unlock(&cfg80211_mutex);
+		if (IS_ERR(rdev))
 			return PTR_ERR(rdev);
-		}
 		wdev = NULL;
 		netdev = NULL;
 		result = 0;
-
-		mutex_lock(&rdev->mtx);
 	} else
 		wdev = netdev->ieee80211_ptr;
 
@@ -1911,8 +1864,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		result = cfg80211_dev_rename(
 			rdev, nla_data(info->attrs[NL80211_ATTR_WIPHY_NAME]));
 
-	mutex_unlock(&cfg80211_mutex);
-
 	if (result)
 		goto bad_res;
 
@@ -2119,7 +2070,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	}
 
  bad_res:
-	mutex_unlock(&rdev->mtx);
 	if (netdev)
 		dev_put(netdev);
 	return result;
@@ -2217,7 +2167,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
 
-	mutex_lock(&cfg80211_mutex);
+	rtnl_lock();
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		if (!net_eq(wiphy_net(&rdev->wiphy), sock_net(skb->sk)))
 			continue;
@@ -2227,7 +2177,6 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 		}
 		if_idx = 0;
 
-		mutex_lock(&rdev->devlist_mtx);
 		list_for_each_entry(wdev, &rdev->wdev_list, list) {
 			if (if_idx < if_start) {
 				if_idx++;
@@ -2236,17 +2185,15 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 			if (nl80211_send_iface(skb, NETLINK_CB(cb->skb).portid,
 					       cb->nlh->nlmsg_seq, NLM_F_MULTI,
 					       rdev, wdev) < 0) {
-				mutex_unlock(&rdev->devlist_mtx);
 				goto out;
 			}
 			if_idx++;
 		}
-		mutex_unlock(&rdev->devlist_mtx);
 
 		wp_idx++;
 	}
  out:
-	mutex_unlock(&cfg80211_mutex);
+	rtnl_unlock();
 
 	cb->args[0] = wp_idx;
 	cb->args[1] = if_idx;
@@ -2479,11 +2426,9 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		INIT_LIST_HEAD(&wdev->mgmt_registrations);
 		spin_lock_init(&wdev->mgmt_registrations_lock);
 
-		mutex_lock(&rdev->devlist_mtx);
 		wdev->identifier = ++rdev->wdev_id;
 		list_add_rcu(&wdev->list, &rdev->wdev_list);
 		rdev->devlist_generation++;
-		mutex_unlock(&rdev->devlist_mtx);
 		break;
 	default:
 		break;
@@ -2992,8 +2937,6 @@ static bool nl80211_get_ap_channel(struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev;
 	bool ret = false;
 
-	mutex_lock(&rdev->devlist_mtx);
-
 	list_for_each_entry(wdev, &rdev->wdev_list, list) {
 		if (wdev->iftype != NL80211_IFTYPE_AP &&
 		    wdev->iftype != NL80211_IFTYPE_P2P_GO)
@@ -3007,8 +2950,6 @@ static bool nl80211_get_ap_channel(struct cfg80211_registered_device *rdev,
 		break;
 	}
 
-	mutex_unlock(&rdev->devlist_mtx);
-
 	return ret;
 }
 
@@ -3170,13 +3111,10 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		params.radar_required = true;
 	}
 
-	mutex_lock(&rdev->devlist_mtx);
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   params.chandef.chan,
 					   CHAN_MODE_SHARED,
 					   radar_detect_width);
-	mutex_unlock(&rdev->devlist_mtx);
-
 	if (err)
 		return err;
 
@@ -4907,18 +4845,13 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 	void *hdr = NULL;
 	struct nlattr *nl_reg_rules;
 	unsigned int i;
-	int err = -EINVAL;
-
-	mutex_lock(&cfg80211_mutex);
 
 	if (!cfg80211_regdomain)
-		goto out;
+		return -EINVAL;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg) {
-		err = -ENOBUFS;
-		goto out;
-	}
+	if (!msg)
+		return -ENOBUFS;
 
 	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
 			     NL80211_CMD_GET_REG);
@@ -4977,8 +4910,7 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 	nla_nest_end(msg, nl_reg_rules);
 
 	genlmsg_end(msg, hdr);
-	err = genlmsg_reply(msg, info);
-	goto out;
+	return genlmsg_reply(msg, info);
 
 nla_put_failure_rcu:
 	rcu_read_unlock();
@@ -4986,10 +4918,7 @@ nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 put_failure:
 	nlmsg_free(msg);
-	err = -EMSGSIZE;
-out:
-	mutex_unlock(&cfg80211_mutex);
-	return err;
+	return -EMSGSIZE;
 }
 
 static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
@@ -5055,12 +4984,9 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	mutex_lock(&cfg80211_mutex);
-
 	r = set_regdom(rd);
 	/* set_regdom took ownership */
 	rd = NULL;
-	mutex_unlock(&cfg80211_mutex);
 
  bad_reg:
 	kfree(rd);
@@ -5110,7 +5036,6 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->scan)
 		return -EOPNOTSUPP;
 
-	mutex_lock(&rdev->sched_scan_mtx);
 	if (rdev->scan_req) {
 		err = -EBUSY;
 		goto unlock;
@@ -5296,7 +5221,6 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	}
 
  unlock:
-	mutex_unlock(&rdev->sched_scan_mtx);
 	return err;
 }
 
@@ -5368,8 +5292,6 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (ie_len > wiphy->max_sched_scan_ie_len)
 		return -EINVAL;
 
-	mutex_lock(&rdev->sched_scan_mtx);
-
 	if (rdev->sched_scan_req) {
 		err = -EINPROGRESS;
 		goto out;
@@ -5537,7 +5459,6 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 out_free:
 	kfree(request);
 out:
-	mutex_unlock(&rdev->sched_scan_mtx);
 	return err;
 }
 
@@ -5545,17 +5466,12 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
 				   struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	int err;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
 	    !rdev->ops->sched_scan_stop)
 		return -EOPNOTSUPP;
 
-	mutex_lock(&rdev->sched_scan_mtx);
-	err = __cfg80211_stop_sched_scan(rdev, false);
-	mutex_unlock(&rdev->sched_scan_mtx);
-
-	return err;
+	return __cfg80211_stop_sched_scan(rdev, false);
 }
 
 static int nl80211_start_radar_detection(struct sk_buff *skb,
@@ -5587,12 +5503,11 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (!rdev->ops->start_radar_detection)
 		return -EOPNOTSUPP;
 
-	mutex_lock(&rdev->devlist_mtx);
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   chandef.chan, CHAN_MODE_SHARED,
 					   BIT(chandef.width));
 	if (err)
-		goto err_locked;
+		return err;
 
 	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
 	if (!err) {
@@ -5600,9 +5515,6 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 		wdev->cac_started = true;
 		wdev->cac_start_time = jiffies;
 	}
-err_locked:
-	mutex_unlock(&rdev->devlist_mtx);
-
 	return err;
 }
 
@@ -6465,6 +6377,8 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 	void *data = NULL;
 	int data_len = 0;
 
+	rtnl_lock();
+
 	if (cb->args[0]) {
 		/*
 		 * 0 is a valid index, but not valid for args[0],
@@ -6476,18 +6390,16 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 				  nl80211_fam.attrbuf, nl80211_fam.maxattr,
 				  nl80211_policy);
 		if (err)
-			return err;
+			goto out_err;
 
-		mutex_lock(&cfg80211_mutex);
 		rdev = __cfg80211_rdev_from_attrs(sock_net(skb->sk),
 						  nl80211_fam.attrbuf);
 		if (IS_ERR(rdev)) {
-			mutex_unlock(&cfg80211_mutex);
-			return PTR_ERR(rdev);
+			err = PTR_ERR(rdev);
+			goto out_err;
 		}
 		phy_idx = rdev->wiphy_idx;
 		rdev = NULL;
-		mutex_unlock(&cfg80211_mutex);
 
 		if (nl80211_fam.attrbuf[NL80211_ATTR_TESTDATA])
 			cb->args[1] =
@@ -6499,14 +6411,11 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 		data_len = nla_len((void *)cb->args[1]);
 	}
 
-	mutex_lock(&cfg80211_mutex);
 	rdev = cfg80211_rdev_by_wiphy_idx(phy_idx);
 	if (!rdev) {
-		mutex_unlock(&cfg80211_mutex);
-		return -ENOENT;
+		err = -ENOENT;
+		goto out_err;
 	}
-	cfg80211_lock_rdev(rdev);
-	mutex_unlock(&cfg80211_mutex);
 
 	if (!rdev->ops->testmode_dump) {
 		err = -EOPNOTSUPP;
@@ -6547,7 +6456,7 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 	/* see above */
 	cb->args[0] = phy_idx + 1;
  out_err:
-	cfg80211_unlock_rdev(rdev);
+	rtnl_unlock();
 	return err;
 }
 
@@ -8182,9 +8091,7 @@ static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (wdev->p2p_started)
 		return 0;
 
-	mutex_lock(&rdev->devlist_mtx);
 	err = cfg80211_can_add_interface(rdev, wdev->iftype);
-	mutex_unlock(&rdev->devlist_mtx);
 	if (err)
 		return err;
 
@@ -8193,9 +8100,7 @@ static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
 		return err;
 
 	wdev->p2p_started = true;
-	mutex_lock(&rdev->devlist_mtx);
 	rdev->opencount++;
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return 0;
 }
@@ -8211,11 +8116,7 @@ static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->stop_p2p_device)
 		return -EOPNOTSUPP;
 
-	mutex_lock(&rdev->devlist_mtx);
-	mutex_lock(&rdev->sched_scan_mtx);
 	cfg80211_stop_p2p_device(rdev, wdev);
-	mutex_unlock(&rdev->sched_scan_mtx);
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return 0;
 }
@@ -8358,11 +8259,11 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 		info->user_ptr[0] = rdev;
 	} else if (ops->internal_flags & NL80211_FLAG_NEED_NETDEV ||
 		   ops->internal_flags & NL80211_FLAG_NEED_WDEV) {
-		mutex_lock(&cfg80211_mutex);
+		ASSERT_RTNL();
+
 		wdev = __cfg80211_wdev_from_attrs(genl_info_net(info),
 						  info->attrs);
 		if (IS_ERR(wdev)) {
-			mutex_unlock(&cfg80211_mutex);
 			if (rtnl)
 				rtnl_unlock();
 			return PTR_ERR(wdev);
@@ -8373,7 +8274,6 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 
 		if (ops->internal_flags & NL80211_FLAG_NEED_NETDEV) {
 			if (!dev) {
-				mutex_unlock(&cfg80211_mutex);
 				if (rtnl)
 					rtnl_unlock();
 				return -EINVAL;
@@ -8387,7 +8287,6 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 		if (dev) {
 			if (ops->internal_flags & NL80211_FLAG_CHECK_NETDEV_UP &&
 			    !netif_running(dev)) {
-				mutex_unlock(&cfg80211_mutex);
 				if (rtnl)
 					rtnl_unlock();
 				return -ENETDOWN;
@@ -8396,17 +8295,12 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 			dev_hold(dev);
 		} else if (ops->internal_flags & NL80211_FLAG_CHECK_NETDEV_UP) {
 			if (!wdev->p2p_started) {
-				mutex_unlock(&cfg80211_mutex);
 				if (rtnl)
 					rtnl_unlock();
 				return -ENETDOWN;
 			}
 		}
 
-		cfg80211_lock_rdev(rdev);
-
-		mutex_unlock(&cfg80211_mutex);
-
 		info->user_ptr[0] = rdev;
 	}
 
@@ -8416,8 +8310,6 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 static void nl80211_post_doit(struct genl_ops *ops, struct sk_buff *skb,
 			      struct genl_info *info)
 {
-	if (info->user_ptr[0])
-		cfg80211_unlock_rdev(info->user_ptr[0]);
 	if (info->user_ptr[1]) {
 		if (ops->internal_flags & NL80211_FLAG_NEED_WDEV) {
 			struct wireless_dev *wdev = info->user_ptr[1];
@@ -8439,7 +8331,8 @@ static struct genl_ops nl80211_ops[] = {
 		.dumpit = nl80211_dump_wiphy,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
-		.internal_flags = NL80211_FLAG_NEED_WIPHY,
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
+				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
 		.cmd = NL80211_CMD_SET_WIPHY,
@@ -8454,7 +8347,8 @@ static struct genl_ops nl80211_ops[] = {
 		.dumpit = nl80211_dump_interface,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
-		.internal_flags = NL80211_FLAG_NEED_WDEV,
+		.internal_flags = NL80211_FLAG_NEED_WDEV |
+				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
 		.cmd = NL80211_CMD_SET_INTERFACE,
@@ -8613,6 +8507,7 @@ static struct genl_ops nl80211_ops[] = {
 		.cmd = NL80211_CMD_GET_REG,
 		.doit = nl80211_get_reg,
 		.policy = nl80211_policy,
+		.internal_flags = NL80211_FLAG_NEED_RTNL,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -8620,6 +8515,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_set_reg,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_RTNL,
 	},
 	{
 		.cmd = NL80211_CMD_REQ_SET_REG,
@@ -9075,8 +8971,6 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	struct nlattr *nest;
 	int i;
 
-	lockdep_assert_held(&rdev->sched_scan_mtx);
-
 	if (WARN_ON(!req))
 		return 0;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e713051..5ceadbb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -387,7 +387,7 @@ static void reg_regdb_search(struct work_struct *work)
 	const struct ieee80211_regdomain *curdom, *regdom = NULL;
 	int i;
 
-	mutex_lock(&cfg80211_mutex);
+	rtnl_lock();
 
 	mutex_lock(&reg_regdb_search_mutex);
 	while (!list_empty(&reg_regdb_search_list)) {
@@ -412,7 +412,7 @@ static void reg_regdb_search(struct work_struct *work)
 	if (!IS_ERR_OR_NULL(regdom))
 		set_regdom(regdom);
 
-	mutex_unlock(&cfg80211_mutex);
+	rtnl_unlock();
 }
 
 static DECLARE_WORK(reg_regdb_work, reg_regdb_search);
@@ -1235,7 +1235,7 @@ static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 	struct cfg80211_registered_device *rdev;
 	struct wiphy *wiphy;
 
-	assert_cfg80211_lock();
+	ASSERT_RTNL();
 
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		wiphy = &rdev->wiphy;
@@ -1580,21 +1580,19 @@ static void reg_process_pending_hints(void)
 {
 	struct regulatory_request *reg_request, *lr;
 
-	mutex_lock(&cfg80211_mutex);
-	mutex_lock(&reg_mutex);
 	lr = get_last_request();
 
 	/* When last_request->processed becomes true this will be rescheduled */
 	if (lr && !lr->processed) {
 		REG_DBG_PRINT("Pending regulatory request, waiting for it to be processed...\n");
-		goto out;
+		return;
 	}
 
 	spin_lock(&reg_requests_lock);
 
 	if (list_empty(&reg_requests_list)) {
 		spin_unlock(&reg_requests_lock);
-		goto out;
+		return;
 	}
 
 	reg_request = list_first_entry(&reg_requests_list,
@@ -1605,10 +1603,6 @@ static void reg_process_pending_hints(void)
 	spin_unlock(&reg_requests_lock);
 
 	reg_process_hint(reg_request, reg_request->initiator);
-
-out:
-	mutex_unlock(&reg_mutex);
-	mutex_unlock(&cfg80211_mutex);
 }
 
 /* Processes beacon hints -- this has nothing to do with country IEs */
@@ -1617,9 +1611,6 @@ static void reg_process_pending_beacon_hints(void)
 	struct cfg80211_registered_device *rdev;
 	struct reg_beacon *pending_beacon, *tmp;
 
-	mutex_lock(&cfg80211_mutex);
-	mutex_lock(&reg_mutex);
-
 	/* This goes through the _pending_ beacon list */
 	spin_lock_bh(&reg_pending_beacons_lock);
 
@@ -1636,14 +1627,16 @@ static void reg_process_pending_beacon_hints(void)
 	}
 
 	spin_unlock_bh(&reg_pending_beacons_lock);
-	mutex_unlock(&reg_mutex);
-	mutex_unlock(&cfg80211_mutex);
 }
 
 static void reg_todo(struct work_struct *work)
 {
+	rtnl_lock();
+	mutex_lock(&reg_mutex);
 	reg_process_pending_hints();
 	reg_process_pending_beacon_hints();
+	mutex_unlock(&reg_mutex);
+	rtnl_unlock();
 }
 
 static void queue_regulatory_request(struct regulatory_request *request)
@@ -1727,10 +1720,6 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 }
 EXPORT_SYMBOL(regulatory_hint);
 
-/*
- * We hold wdev_lock() here so we cannot hold cfg80211_mutex() and
- * therefore cannot iterate over the rdev list here.
- */
 void regulatory_hint_11d(struct wiphy *wiphy, enum ieee80211_band band,
 			 const u8 *country_ie, u8 country_ie_len)
 {
@@ -1762,7 +1751,7 @@ void regulatory_hint_11d(struct wiphy *wiphy, enum ieee80211_band band,
 	/*
 	 * We will run this only upon a successful connection on cfg80211.
 	 * We leave conflict resolution to the workqueue, where can hold
-	 * cfg80211_mutex.
+	 * the RTNL.
 	 */
 	if (lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    lr->wiphy_idx != WIPHY_IDX_INVALID)
@@ -1868,7 +1857,8 @@ static void restore_regulatory_settings(bool reset_user)
 	LIST_HEAD(tmp_reg_req_list);
 	struct cfg80211_registered_device *rdev;
 
-	mutex_lock(&cfg80211_mutex);
+	ASSERT_RTNL();
+
 	mutex_lock(&reg_mutex);
 
 	reset_regdomains(true, &world_regdom);
@@ -1925,7 +1915,6 @@ static void restore_regulatory_settings(bool reset_user)
 	spin_unlock(&reg_requests_lock);
 
 	mutex_unlock(&reg_mutex);
-	mutex_unlock(&cfg80211_mutex);
 
 	REG_DBG_PRINT("Kicking the queue\n");
 
@@ -2307,7 +2296,6 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 	mutex_unlock(&reg_mutex);
 }
 
-/* Caller must hold cfg80211_mutex */
 void wiphy_regulatory_deregister(struct wiphy *wiphy)
 {
 	struct wiphy *request_wiphy = NULL;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2ce44a7..dd01b58 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -169,7 +169,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 	union iwreq_data wrqu;
 #endif
 
-	lockdep_assert_held(&rdev->sched_scan_mtx);
+	ASSERT_RTNL();
 
 	request = rdev->scan_req;
 
@@ -230,9 +230,9 @@ void __cfg80211_scan_done(struct work_struct *wk)
 	rdev = container_of(wk, struct cfg80211_registered_device,
 			    scan_done_wk);
 
-	mutex_lock(&rdev->sched_scan_mtx);
+	rtnl_lock();
 	___cfg80211_scan_done(rdev, false);
-	mutex_unlock(&rdev->sched_scan_mtx);
+	rtnl_unlock();
 }
 
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
@@ -241,6 +241,7 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
 
 	request->aborted = aborted;
+	request->notified = true;
 	queue_work(cfg80211_wq, &wiphy_to_dev(request->wiphy)->scan_done_wk);
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
@@ -255,7 +256,7 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 
 	request = rdev->sched_scan_req;
 
-	mutex_lock(&rdev->sched_scan_mtx);
+	rtnl_lock();
 
 	/* we don't have sched_scan_req anymore if the scan is stopping */
 	if (request) {
@@ -270,7 +271,7 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 		nl80211_send_sched_scan_results(rdev, request->dev);
 	}
 
-	mutex_unlock(&rdev->sched_scan_mtx);
+	rtnl_unlock();
 }
 
 void cfg80211_sched_scan_results(struct wiphy *wiphy)
@@ -289,9 +290,9 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
 
 	trace_cfg80211_sched_scan_stopped(wiphy);
 
-	mutex_lock(&rdev->sched_scan_mtx);
+	rtnl_lock();
 	__cfg80211_stop_sched_scan(rdev, true);
-	mutex_unlock(&rdev->sched_scan_mtx);
+	rtnl_unlock();
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
 
@@ -300,7 +301,7 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 {
 	struct net_device *dev;
 
-	lockdep_assert_held(&rdev->sched_scan_mtx);
+	ASSERT_RTNL();
 
 	if (!rdev->sched_scan_req)
 		return -ENOENT;
@@ -1043,21 +1044,19 @@ EXPORT_SYMBOL(cfg80211_unlink_bss);
 static struct cfg80211_registered_device *
 cfg80211_get_dev_from_ifindex(struct net *net, int ifindex)
 {
-	struct cfg80211_registered_device *rdev = ERR_PTR(-ENODEV);
+	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 
-	mutex_lock(&cfg80211_mutex);
+	ASSERT_RTNL();
+
 	dev = dev_get_by_index(net, ifindex);
 	if (!dev)
-		goto out;
-	if (dev->ieee80211_ptr) {
+		return ERR_PTR(-ENODEV);
+	if (dev->ieee80211_ptr)
 		rdev = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
-		mutex_lock(&rdev->mtx);
-	} else
+	else
 		rdev = ERR_PTR(-ENODEV);
 	dev_put(dev);
- out:
-	mutex_unlock(&cfg80211_mutex);
 	return rdev;
 }
 
@@ -1083,7 +1082,6 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
-	mutex_lock(&rdev->sched_scan_mtx);
 	if (rdev->scan_req) {
 		err = -EBUSY;
 		goto out;
@@ -1190,9 +1188,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 		dev_hold(dev);
 	}
  out:
-	mutex_unlock(&rdev->sched_scan_mtx);
 	kfree(creq);
-	cfg80211_unlock_rdev(rdev);
 	return err;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwscan);
@@ -1491,10 +1487,8 @@ int cfg80211_wext_giwscan(struct net_device *dev,
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
-	if (rdev->scan_req) {
-		res = -EAGAIN;
-		goto out;
-	}
+	if (rdev->scan_req)
+		return -EAGAIN;
 
 	res = ieee80211_scan_results(rdev, info, extra, data->length);
 	data->length = 0;
@@ -1503,8 +1497,6 @@ int cfg80211_wext_giwscan(struct net_device *dev,
 		res = 0;
 	}
 
- out:
-	cfg80211_unlock_rdev(rdev);
 	return res;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwscan);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 8b5eddf..3925064 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -43,35 +43,29 @@ static bool cfg80211_is_all_idle(void)
 	struct wireless_dev *wdev;
 	bool is_all_idle = true;
 
-	mutex_lock(&cfg80211_mutex);
-
 	/*
 	 * All devices must be idle as otherwise if you are actively
 	 * scanning some new beacon hints could be learned and would
 	 * count as new regulatory hints.
 	 */
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
-		cfg80211_lock_rdev(rdev);
 		list_for_each_entry(wdev, &rdev->wdev_list, list) {
 			wdev_lock(wdev);
 			if (wdev->sme_state != CFG80211_SME_IDLE)
 				is_all_idle = false;
 			wdev_unlock(wdev);
 		}
-		cfg80211_unlock_rdev(rdev);
 	}
 
-	mutex_unlock(&cfg80211_mutex);
-
 	return is_all_idle;
 }
 
 static void disconnect_work(struct work_struct *work)
 {
-	if (!cfg80211_is_all_idle())
-		return;
-
-	regulatory_hint_disconnect();
+	rtnl_lock();
+	if (cfg80211_is_all_idle())
+		regulatory_hint_disconnect();
+	rtnl_unlock();
 }
 
 static DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
@@ -85,7 +79,6 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	ASSERT_RTNL();
 	ASSERT_RDEV_LOCK(rdev);
 	ASSERT_WDEV_LOCK(wdev);
-	lockdep_assert_held(&rdev->sched_scan_mtx);
 
 	if (rdev->scan_req)
 		return -EBUSY;
@@ -226,9 +219,6 @@ void cfg80211_conn_work(struct work_struct *work)
 	u8 bssid_buf[ETH_ALEN], *bssid = NULL;
 
 	rtnl_lock();
-	cfg80211_lock_rdev(rdev);
-	mutex_lock(&rdev->devlist_mtx);
-	mutex_lock(&rdev->sched_scan_mtx);
 
 	list_for_each_entry(wdev, &rdev->wdev_list, list) {
 		wdev_lock(wdev);
@@ -253,9 +243,6 @@ void cfg80211_conn_work(struct work_struct *work)
 		wdev_unlock(wdev);
 	}
 
-	mutex_unlock(&rdev->sched_scan_mtx);
-	mutex_unlock(&rdev->devlist_mtx);
-	cfg80211_unlock_rdev(rdev);
 	rtnl_unlock();
 }
 
@@ -928,14 +915,9 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 {
 	int err;
 
-	mutex_lock(&rdev->devlist_mtx);
-	/* might request scan - scan_mtx -> wdev_mtx dependency */
-	mutex_lock(&rdev->sched_scan_mtx);
 	wdev_lock(dev->ieee80211_ptr);
 	err = __cfg80211_connect(rdev, dev, connect, connkeys, NULL);
 	wdev_unlock(dev->ieee80211_ptr);
-	mutex_unlock(&rdev->sched_scan_mtx);
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
diff --git a/net/wireless/util.c b/net/wireless/util.c
index b11052b..a694c61 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -785,12 +785,8 @@ void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev)
 	ASSERT_RTNL();
 	ASSERT_RDEV_LOCK(rdev);
 
-	mutex_lock(&rdev->devlist_mtx);
-
 	list_for_each_entry(wdev, &rdev->wdev_list, list)
 		cfg80211_process_wdev_events(wdev);
-
-	mutex_unlock(&rdev->devlist_mtx);
 }
 
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
@@ -822,10 +818,8 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		return -EBUSY;
 
 	if (ntype != otype && netif_running(dev)) {
-		mutex_lock(&rdev->devlist_mtx);
 		err = cfg80211_can_change_interface(rdev, dev->ieee80211_ptr,
 						    ntype);
-		mutex_unlock(&rdev->devlist_mtx);
 		if (err)
 			return err;
 
@@ -1187,8 +1181,6 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	if (!beacon_int)
 		return -EINVAL;
 
-	mutex_lock(&rdev->devlist_mtx);
-
 	list_for_each_entry(wdev, &rdev->wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
@@ -1198,8 +1190,6 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 		}
 	}
 
-	mutex_unlock(&rdev->devlist_mtx);
-
 	return res;
 }
 
@@ -1223,7 +1213,6 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	int i, j;
 
 	ASSERT_RTNL();
-	lockdep_assert_held(&rdev->devlist_mtx);
 
 	if (WARN_ON(hweight32(radar_detect) > 1))
 		return -EINVAL;
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index d997d0f..e7c6e86 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -72,7 +72,6 @@ int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
 	struct cfg80211_registered_device *rdev;
 	struct vif_params vifparams;
 	enum nl80211_iftype type;
-	int ret;
 
 	rdev = wiphy_to_dev(wdev->wiphy);
 
@@ -98,11 +97,7 @@ int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
 
 	memset(&vifparams, 0, sizeof(vifparams));
 
-	cfg80211_lock_rdev(rdev);
-	ret = cfg80211_change_iface(rdev, dev, type, NULL, &vifparams);
-	cfg80211_unlock_rdev(rdev);
-
-	return ret;
+	return cfg80211_change_iface(rdev, dev, type, NULL, &vifparams);
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwmode);
 
@@ -579,13 +574,10 @@ static int cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 {
 	int err;
 
-	/* devlist mutex needed for possible IBSS re-join */
-	mutex_lock(&rdev->devlist_mtx);
 	wdev_lock(dev->ieee80211_ptr);
 	err = __cfg80211_set_encryption(rdev, dev, pairwise, addr,
 					remove, tx_key, idx, params);
 	wdev_unlock(dev->ieee80211_ptr);
-	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
@@ -787,7 +779,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 	struct cfg80211_chan_def chandef = {
 		.width = NL80211_CHAN_WIDTH_20_NOHT,
 	};
-	int freq, err;
+	int freq;
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
@@ -804,10 +796,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 		chandef.chan = ieee80211_get_channel(&rdev->wiphy, freq);
 		if (!chandef.chan)
 			return -EINVAL;
-		mutex_lock(&rdev->devlist_mtx);
-		err = cfg80211_set_monitor_channel(rdev, &chandef);
-		mutex_unlock(&rdev->devlist_mtx);
-		return err;
+		return cfg80211_set_monitor_channel(rdev, &chandef);
 	case NL80211_IFTYPE_MESH_POINT:
 		freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
 		if (freq < 0)
@@ -818,10 +807,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 		chandef.chan = ieee80211_get_channel(&rdev->wiphy, freq);
 		if (!chandef.chan)
 			return -EINVAL;
-		mutex_lock(&rdev->devlist_mtx);
-		err = cfg80211_set_mesh_channel(rdev, wdev, &chandef);
-		mutex_unlock(&rdev->devlist_mtx);
-		return err;
+		return cfg80211_set_mesh_channel(rdev, wdev, &chandef);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index e79cb5c..aeefd68 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -87,9 +87,6 @@ int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 			return -EINVAL;
 	}
 
-	cfg80211_lock_rdev(rdev);
-	mutex_lock(&rdev->devlist_mtx);
-	mutex_lock(&rdev->sched_scan_mtx);
 	wdev_lock(wdev);
 
 	if (wdev->sme_state != CFG80211_SME_IDLE) {
@@ -136,9 +133,6 @@ int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 	err = cfg80211_mgd_wext_connect(rdev, wdev);
  out:
 	wdev_unlock(wdev);
-	mutex_unlock(&rdev->sched_scan_mtx);
-	mutex_unlock(&rdev->devlist_mtx);
-	cfg80211_unlock_rdev(rdev);
 	return err;
 }
 
@@ -190,9 +184,6 @@ int cfg80211_mgd_wext_siwessid(struct net_device *dev,
 	if (len > 0 && ssid[len - 1] == '\0')
 		len--;
 
-	cfg80211_lock_rdev(rdev);
-	mutex_lock(&rdev->devlist_mtx);
-	mutex_lock(&rdev->sched_scan_mtx);
 	wdev_lock(wdev);
 
 	err = 0;
@@ -226,9 +217,6 @@ int cfg80211_mgd_wext_siwessid(struct net_device *dev,
 	err = cfg80211_mgd_wext_connect(rdev, wdev);
  out:
 	wdev_unlock(wdev);
-	mutex_unlock(&rdev->sched_scan_mtx);
-	mutex_unlock(&rdev->devlist_mtx);
-	cfg80211_unlock_rdev(rdev);
 	return err;
 }
 
@@ -287,9 +275,6 @@ int cfg80211_mgd_wext_siwap(struct net_device *dev,
 	if (is_zero_ether_addr(bssid) || is_broadcast_ether_addr(bssid))
 		bssid = NULL;
 
-	cfg80211_lock_rdev(rdev);
-	mutex_lock(&rdev->devlist_mtx);
-	mutex_lock(&rdev->sched_scan_mtx);
 	wdev_lock(wdev);
 
 	if (wdev->sme_state != CFG80211_SME_IDLE) {
@@ -318,9 +303,6 @@ int cfg80211_mgd_wext_siwap(struct net_device *dev,
 	err = cfg80211_mgd_wext_connect(rdev, wdev);
  out:
 	wdev_unlock(wdev);
-	mutex_unlock(&rdev->sched_scan_mtx);
-	mutex_unlock(&rdev->devlist_mtx);
-	cfg80211_unlock_rdev(rdev);
 	return err;
 }
 
-- 
1.8.0

