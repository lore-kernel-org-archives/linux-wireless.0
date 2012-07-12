Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47489 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161280Ab2GLQHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 12:07:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3] cfg80211: fix set_monitor_enabled
Date: Thu, 12 Jul 2012 18:07:19 +0200
Message-Id: <1342109239-29169-1-git-send-email-johannes@sipsolutions.net> (sfid-20120712_180724_777058_A1E5D134)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When bringing monitor mode up with a driver using the
mac80211 virtual monitor interface this resulted in a
warning because cfg80211_update_iface_num() is called
from PRE_UP, which causes it to call mac80211 and the
low-level driver before the device is started.

For the case that another interface is added and the
monitor interface should be removed, this is correct.
However, in the case where a monitor interface is
added, it's not correct as the above.

To fix this, we need to split up the cases and track
whether or not "only monitor" is active so that the
code can correctly call into the driver when things
change.

Reported-by: Mohammed Shafi <shafi.wireless@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c |   62 ++++++++++++++++++++++++++++++++++++++-------------
 net/wireless/core.h |   10 ++++++++-
 net/wireless/util.c |    8 +++++--
 3 files changed, 61 insertions(+), 19 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 0557bb1..b63c450 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -766,30 +766,56 @@ static void cfg80211_init_mon_chan(struct cfg80211_registered_device *rdev)
 }
 
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
-			       enum nl80211_iftype iftype, int num)
+			       enum nl80211_iftype iftype,
+			       enum cfg80211_iface_action action)
 {
-	bool has_monitors_only_old = cfg80211_has_monitors_only(rdev);
-	bool has_monitors_only_new;
+	bool monitors_only;
+	int num;
 
 	ASSERT_RTNL();
 
+	switch (action) {
+	case CFG80211_IFACE_DOWN:
+		num = -1;
+		break;
+	case CFG80211_IFACE_PRE_UP:
+		num = 1;
+		break;
+	case CFG80211_IFACE_UP:
+		num = 0;
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
 	rdev->num_running_ifaces += num;
 	if (iftype == NL80211_IFTYPE_MONITOR)
 		rdev->num_running_monitor_ifaces += num;
 
-	has_monitors_only_new = cfg80211_has_monitors_only(rdev);
-	if (has_monitors_only_new != has_monitors_only_old) {
+	monitors_only = cfg80211_has_monitors_only(rdev);
+
+	if (monitors_only && rdev->monitor_only_enabled)
+		return;
+
+	if (!monitors_only && !rdev->monitor_only_enabled)
+		return;
+
+	if (monitors_only) {
+		/* Do it in CFG80211_IFACE_UP instead */
+		if (action == CFG80211_IFACE_PRE_UP)
+			return;
 		if (rdev->ops->set_monitor_enabled)
-			rdev->ops->set_monitor_enabled(&rdev->wiphy,
-						       has_monitors_only_new);
-
-		if (!has_monitors_only_new) {
-			rdev->monitor_channel = NULL;
-			rdev->monitor_channel_type = NL80211_CHAN_NO_HT;
-		} else {
-			cfg80211_init_mon_chan(rdev);
-		}
+			rdev->ops->set_monitor_enabled(&rdev->wiphy, true);
+		cfg80211_init_mon_chan(rdev);
+	} else {
+		rdev->monitor_channel = NULL;
+		rdev->monitor_channel_type = NL80211_CHAN_NO_HT;
+		if (rdev->ops->set_monitor_enabled)
+			rdev->ops->set_monitor_enabled(&rdev->wiphy, false);
 	}
+
+	rdev->monitor_only_enabled = monitors_only;
 }
 
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
@@ -895,7 +921,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		wdev->beacon_interval = 0;
 		break;
 	case NETDEV_DOWN:
-		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
+		cfg80211_update_iface_num(rdev, wdev->iftype,
+					  CFG80211_IFACE_DOWN);
 		dev_hold(dev);
 		queue_work(cfg80211_wq, &wdev->cleanup_work);
 		break;
@@ -912,6 +939,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			mutex_unlock(&rdev->devlist_mtx);
 			dev_put(dev);
 		}
+		cfg80211_update_iface_num(rdev, wdev->iftype,
+					  CFG80211_IFACE_UP);
 		cfg80211_lock_rdev(rdev);
 		mutex_lock(&rdev->devlist_mtx);
 		wdev_lock(wdev);
@@ -1006,7 +1035,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		mutex_unlock(&rdev->devlist_mtx);
 		if (ret)
 			return notifier_from_errno(ret);
-		cfg80211_update_iface_num(rdev, wdev->iftype, 1);
+		cfg80211_update_iface_num(rdev, wdev->iftype,
+					  CFG80211_IFACE_PRE_UP);
 		break;
 	}
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index bac97da..b2b1db3 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -60,6 +60,7 @@ struct cfg80211_registered_device {
 	/* protected by RTNL only */
 	int num_running_ifaces;
 	int num_running_monitor_ifaces;
+	bool monitor_only_enabled;
 
 	struct ieee80211_channel *monitor_channel;
 	enum nl80211_channel_type monitor_channel_type;
@@ -480,8 +481,15 @@ int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 				 u32 beacon_int);
 
+enum cfg80211_iface_action {
+	CFG80211_IFACE_DOWN,
+	CFG80211_IFACE_PRE_UP,
+	CFG80211_IFACE_UP,
+};
+
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
-			       enum nl80211_iftype iftype, int num);
+			       enum nl80211_iftype iftype,
+			       enum cfg80211_iface_action action);
 
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 26f8cd3..a5399f8 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -893,8 +893,12 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	}
 
 	if (!err && ntype != otype && netif_running(dev)) {
-		cfg80211_update_iface_num(rdev, ntype, 1);
-		cfg80211_update_iface_num(rdev, otype, -1);
+		cfg80211_update_iface_num(rdev, ntype,
+					  CFG80211_IFACE_PRE_UP);
+		cfg80211_update_iface_num(rdev, ntype,
+					  CFG80211_IFACE_UP);
+		cfg80211_update_iface_num(rdev, otype,
+					  CFG80211_IFACE_DOWN);
 	}
 
 	return err;
-- 
1.7.10.4

