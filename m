Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55535 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851AbZHRRw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 13:52:28 -0400
Subject: [PATCH] cfg80211: fix dangling scan request checking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 19:51:57 +0200
Message-Id: <1250617917.9886.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My patch "cfg80211: fix deadlock" broke the code it
was supposed to fix, the scan request checking. But
it's not trivial to put it back the way it was, since
the original patch had a deadlock.

Now do it in a completely new way: queue the check
off to a work struct, where we can freely lock. But
that has some more complications, like needing to
wait for it to be done before the wiphy/rdev can be
destroyed, so some code is required to handle that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    2 +
 net/wireless/core.c    |   76 ++++++++++++++++++++++++++++++++++++++++---------
 net/wireless/core.h    |    2 +
 3 files changed, 67 insertions(+), 13 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-08-18 19:38:28.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-08-18 19:38:37.000000000 +0200
@@ -1325,6 +1325,8 @@ struct wireless_dev {
 
 	struct mutex mtx;
 
+	struct work_struct cleanup_work;
+
 	/* currently used for IBSS and SME - might be rearranged later */
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len;
--- wireless-testing.orig/net/wireless/core.c	2009-08-18 19:38:28.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-08-18 19:38:29.000000000 +0200
@@ -430,6 +430,8 @@ struct wiphy *wiphy_new(const struct cfg
 	INIT_WORK(&rdev->conn_work, cfg80211_conn_work);
 	INIT_WORK(&rdev->event_work, cfg80211_event_work);
 
+	init_waitqueue_head(&rdev->dev_wait);
+
 	/*
 	 * Initialize wiphy parameters to IEEE 802.11 MIB default values.
 	 * Fragmentation and RTS threshold are disabled by default with the
@@ -574,7 +576,23 @@ void wiphy_unregister(struct wiphy *wiph
 	/* protect the device list */
 	mutex_lock(&cfg80211_mutex);
 
+	wait_event(rdev->dev_wait, ({
+		int __count;
+		mutex_lock(&rdev->devlist_mtx);
+		__count = rdev->opencount;
+		mutex_unlock(&rdev->devlist_mtx);
+		__count == 0;}));
+
+	mutex_lock(&rdev->devlist_mtx);
 	BUG_ON(!list_empty(&rdev->netdev_list));
+	mutex_unlock(&rdev->devlist_mtx);
+
+	/*
+	 * First remove the hardware from everywhere, this makes
+	 * it impossible to find from userspace.
+	 */
+	cfg80211_debugfs_rdev_del(rdev);
+	list_del(&rdev->list);
 
 	/*
 	 * Try to grab rdev->mtx. If a command is still in progress,
@@ -582,26 +600,18 @@ void wiphy_unregister(struct wiphy *wiph
 	 * down the device already. We wait for this command to complete
 	 * before unlinking the item from the list.
 	 * Note: as codified by the BUG_ON above we cannot get here if
-	 * a virtual interface is still associated. Hence, we can only
-	 * get to lock contention here if userspace issues a command
-	 * that identified the hardware by wiphy index.
+	 * a virtual interface is still present. Hence, we can only get
+	 * to lock contention here if userspace issues a command that
+	 * identified the hardware by wiphy index.
 	 */
 	cfg80211_lock_rdev(rdev);
-
-	if (WARN_ON(rdev->scan_req)) {
-		rdev->scan_req->aborted = true;
-		___cfg80211_scan_done(rdev);
-	}
-
+	/* nothing */
 	cfg80211_unlock_rdev(rdev);
 
-	cfg80211_debugfs_rdev_del(rdev);
-
 	/* If this device got a regulatory hint tell core its
 	 * free to listen now to a new shiny device regulatory hint */
 	reg_device_remove(wiphy);
 
-	list_del(&rdev->list);
 	cfg80211_rdev_list_generation++;
 	device_del(&rdev->wiphy.dev);
 	debugfs_remove(rdev->wiphy.debugfsdir);
@@ -640,6 +650,31 @@ void wiphy_rfkill_set_hw_state(struct wi
 }
 EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
 
+static void wdev_cleanup_work(struct work_struct *work)
+{
+	struct wireless_dev *wdev;
+	struct cfg80211_registered_device *rdev;
+
+	wdev = container_of(work, struct wireless_dev, cleanup_work);
+	rdev = wiphy_to_dev(wdev->wiphy);
+
+	cfg80211_lock_rdev(rdev);
+
+	if (WARN_ON(rdev->scan_req && rdev->scan_req->dev == wdev->netdev)) {
+		rdev->scan_req->aborted = true;
+		___cfg80211_scan_done(rdev);
+	}
+
+	cfg80211_unlock_rdev(rdev);
+
+	mutex_lock(&rdev->devlist_mtx);
+	rdev->opencount--;
+	mutex_unlock(&rdev->devlist_mtx);
+	wake_up(&rdev->dev_wait);
+
+	dev_put(wdev->netdev);
+}
+
 static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 					 unsigned long state,
 					 void *ndev)
@@ -663,6 +698,7 @@ static int cfg80211_netdev_notifier_call
 		 * are added with nl80211.
 		 */
 		mutex_init(&wdev->mtx);
+		INIT_WORK(&wdev->cleanup_work, wdev_cleanup_work);
 		INIT_LIST_HEAD(&wdev->event_list);
 		spin_lock_init(&wdev->event_lock);
 		mutex_lock(&rdev->devlist_mtx);
@@ -717,8 +753,22 @@ static int cfg80211_netdev_notifier_call
 		default:
 			break;
 		}
+		dev_hold(dev);
+		schedule_work(&wdev->cleanup_work);
 		break;
 	case NETDEV_UP:
+		/*
+		 * If we have a really quick DOWN/UP succession we may
+		 * have this work still pending ... cancel it and see
+		 * if it was pending, in which case we need to account
+		 * for some of the work it would have done.
+		 */
+		if (cancel_work_sync(&wdev->cleanup_work)) {
+			mutex_lock(&rdev->devlist_mtx);
+			rdev->opencount--;
+			mutex_unlock(&rdev->devlist_mtx);
+			dev_put(dev);
+		}
 #ifdef CONFIG_WIRELESS_EXT
 		cfg80211_lock_rdev(rdev);
 		mutex_lock(&rdev->devlist_mtx);
@@ -734,6 +784,7 @@ static int cfg80211_netdev_notifier_call
 			break;
 		}
 		wdev_unlock(wdev);
+		rdev->opencount++;
 		mutex_unlock(&rdev->devlist_mtx);
 		cfg80211_unlock_rdev(rdev);
 #endif
@@ -756,7 +807,6 @@ static int cfg80211_netdev_notifier_call
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
 			list_del_init(&wdev->list);
 			rdev->devlist_generation++;
-			mutex_destroy(&wdev->mtx);
 #ifdef CONFIG_WIRELESS_EXT
 			kfree(wdev->wext.keys);
 #endif
--- wireless-testing.orig/net/wireless/core.h	2009-08-18 19:38:28.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-08-18 19:38:29.000000000 +0200
@@ -50,6 +50,8 @@ struct cfg80211_registered_device {
 	struct mutex devlist_mtx;
 	struct list_head netdev_list;
 	int devlist_generation;
+	int opencount; /* also protected by devlist_mtx */
+	wait_queue_head_t dev_wait;
 
 	/* BSSes/scanning */
 	spinlock_t bss_lock;


