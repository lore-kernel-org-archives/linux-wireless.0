Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2GEHrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 03:47:39 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix locking regression in monitor channel tracking
Date: Thu,  5 Jul 2012 09:47:32 +0200
Message-Id: <1341474452-5812-1-git-send-email-johannes@sipsolutions.net> (sfid-20120705_094742_766702_1D707C51)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Michal's monitor channel tracking introduce a locking problem
as it locked the rdev lock inside the netdev notifier which
isn't allowed as we might already hold it if we get there by
removing an interface that is up.

Fix this by relying only on the RTNL to protect the interface
counters, the RTNL is always held in these code paths anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c |    8 ++------
 net/wireless/core.h |    4 +++-
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index e13365f..eb60410 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -766,7 +766,7 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 	bool has_monitors_only_old = cfg80211_has_monitors_only(rdev);
 	bool has_monitors_only_new;
 
-	ASSERT_RDEV_LOCK(rdev);
+	ASSERT_RTNL();
 
 	rdev->num_running_ifaces += num;
 	if (iftype == NL80211_IFTYPE_MONITOR)
@@ -888,10 +888,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		wdev->beacon_interval = 0;
 		break;
 	case NETDEV_DOWN:
-		dev_hold(dev);
-		cfg80211_lock_rdev(rdev);
 		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
-		cfg80211_unlock_rdev(rdev);
+		dev_hold(dev);
 		queue_work(cfg80211_wq, &wdev->cleanup_work);
 		break;
 	case NETDEV_UP:
@@ -1001,9 +999,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		mutex_unlock(&rdev->devlist_mtx);
 		if (ret)
 			return notifier_from_errno(ret);
-		cfg80211_lock_rdev(rdev);
 		cfg80211_update_iface_num(rdev, wdev->iftype, 1);
-		cfg80211_unlock_rdev(rdev);
 		break;
 	}
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 81fef3d..377dc39 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -13,6 +13,7 @@
 #include <linux/debugfs.h>
 #include <linux/rfkill.h>
 #include <linux/workqueue.h>
+#include <linux/rtnetlink.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include "reg.h"
@@ -56,6 +57,7 @@ struct cfg80211_registered_device {
 
 	u32 ap_beacons_nlpid;
 
+	/* protected by RTNL only */
 	int num_running_ifaces;
 	int num_running_monitor_ifaces;
 
@@ -205,7 +207,7 @@ static inline void wdev_unlock(struct wireless_dev *wdev)
 
 static inline bool cfg80211_has_monitors_only(struct cfg80211_registered_device *rdev)
 {
-	ASSERT_RDEV_LOCK(rdev);
+	ASSERT_RTNL();
 
 	return rdev->num_running_ifaces == rdev->num_running_monitor_ifaces &&
 	       rdev->num_running_ifaces > 0;
-- 
1.7.10

