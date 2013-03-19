Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab3CSTSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 15:18:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] cfg80211: always check for scan end on P2P device
Date: Tue, 19 Mar 2013 20:18:40 +0100
Message-Id: <1363720720-24753-1-git-send-email-johannes@sipsolutions.net> (sfid-20130319_201852_446064_21EEBDEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a P2P device wdev is removed while it has a scan, then the
scan completion might crash later as it is already freed by
that time. To avoid the crash always check the scan completion
when the P2P device is being removed for some reason. If the
driver already canceled it, don't want and free it, otherwise
warn and leak it to avoid later crashes.

In order to do this, locking needs to be changed from the rdev
mutex (which can't always be guaranteed) to the RTNL.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    | 49 +++++++++++++++++++++++++++++++++++++------------
 net/wireless/core.h    |  3 +++
 net/wireless/nl80211.c | 17 ++---------------
 net/wireless/scan.c    |  6 +++---
 4 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index f382cae..c977349 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -212,6 +212,39 @@ static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
 	rdev_rfkill_poll(rdev);
 }
 
+void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
+			      struct wireless_dev *wdev)
+{
+	ASSERT_RTNL();
+	lockdep_assert_held(&rdev->devlist_mtx);
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_P2P_DEVICE))
+		return;
+
+	if (!wdev->p2p_started)
+		return;
+
+	rdev_stop_p2p_device(rdev, wdev);
+	wdev->p2p_started = false;
+
+	rdev->opencount--;
+
+	if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
+		bool busy = work_busy(&rdev->scan_done_wk);
+
+		/*
+		 * If the work isn't pending or running (in which case it would
+		 * be waiting for the lock we hold) the driver didn't properly
+		 * cancel the scan when the interface was removed. In this case
+		 * warn and leak the scan request object to not crash later.
+		 */
+		WARN_ON(!busy);
+
+		rdev->scan_req->aborted = true;
+		___cfg80211_scan_done(rdev, !busy);
+	}
+}
+
 static int cfg80211_rfkill_set_block(void *data, bool blocked)
 {
 	struct cfg80211_registered_device *rdev = data;
@@ -231,11 +264,7 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
 		/* otherwise, check iftype */
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_P2P_DEVICE:
-			if (!wdev->p2p_started)
-				break;
-			rdev_stop_p2p_device(rdev, wdev);
-			wdev->p2p_started = false;
-			rdev->opencount--;
+			cfg80211_stop_p2p_device(rdev, wdev);
 			break;
 		default:
 			break;
@@ -745,14 +774,14 @@ static void wdev_cleanup_work(struct work_struct *work)
 	wdev = container_of(work, struct wireless_dev, cleanup_work);
 	rdev = wiphy_to_dev(wdev->wiphy);
 
-	cfg80211_lock_rdev(rdev);
+	rtnl_lock();
 
 	if (WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev)) {
 		rdev->scan_req->aborted = true;
 		___cfg80211_scan_done(rdev, true);
 	}
 
-	cfg80211_unlock_rdev(rdev);
+	rtnl_unlock();
 
 	mutex_lock(&rdev->sched_scan_mtx);
 
@@ -786,11 +815,7 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		if (!wdev->p2p_started)
-			break;
-		rdev_stop_p2p_device(rdev, wdev);
-		wdev->p2p_started = false;
-		rdev->opencount--;
+		cfg80211_stop_p2p_device(rdev, wdev);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index d5d06fd..124e5e7 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -503,6 +503,9 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		    struct wireless_dev *wdev);
 
+void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
+			      struct wireless_dev *wdev);
+
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f924d45..724360c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8130,20 +8130,7 @@ static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->stop_p2p_device)
 		return -EOPNOTSUPP;
 
-	if (!wdev->p2p_started)
-		return 0;
-
-	rdev_stop_p2p_device(rdev, wdev);
-	wdev->p2p_started = false;
-
-	mutex_lock(&rdev->devlist_mtx);
-	rdev->opencount--;
-	mutex_unlock(&rdev->devlist_mtx);
-
-	if (WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev)) {
-		rdev->scan_req->aborted = true;
-		___cfg80211_scan_done(rdev, true);
-	}
+	cfg80211_stop_p2p_device(rdev, wdev);
 
 	return 0;
 }
@@ -8929,7 +8916,7 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	struct nlattr *nest;
 	int i;
 
-	ASSERT_RDEV_LOCK(rdev);
+	ASSERT_RTNL();
 
 	if (WARN_ON(!req))
 		return 0;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 674aadc..ced066d 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -169,7 +169,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 	union iwreq_data wrqu;
 #endif
 
-	ASSERT_RDEV_LOCK(rdev);
+	ASSERT_RTNL();
 
 	request = rdev->scan_req;
 
@@ -230,9 +230,9 @@ void __cfg80211_scan_done(struct work_struct *wk)
 	rdev = container_of(wk, struct cfg80211_registered_device,
 			    scan_done_wk);
 
-	cfg80211_lock_rdev(rdev);
+	rtnl_lock();
 	___cfg80211_scan_done(rdev, false);
-	cfg80211_unlock_rdev(rdev);
+	rtnl_unlock();
 }
 
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
-- 
1.8.0

