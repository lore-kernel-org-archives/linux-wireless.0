Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab3B1JzU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 04:55:20 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 1/6] cfg80211/mac80211: disconnect on suspend
Date: Thu, 28 Feb 2013 10:55:25 +0100
Message-Id: <1362045330-2018-1-git-send-email-sgruszka@redhat.com> (sfid-20130228_105524_609792_19A84D02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If possible that after suspend, cfg80211 will receive request to
disconnect what require action on interface that was removed during
suspend.

Problem can manifest itself by various warnings similar to below one:

WARNING: at net/mac80211/driver-ops.h:12 ieee80211_bss_info_change_notify+0x2f9/0x300 [mac80211]()
wlan0:  Failed check-sdata-in-driver check, flags: 0x4
Call Trace:
 [<c043e0b3>] warn_slowpath_fmt+0x33/0x40
 [<f83707c9>] ieee80211_bss_info_change_notify+0x2f9/0x300 [mac80211]
 [<f83a660a>] ieee80211_recalc_ps_vif+0x2a/0x30 [mac80211]
 [<f83a6706>] ieee80211_set_disassoc+0xf6/0x500 [mac80211]
 [<f83a9441>] ieee80211_mgd_deauth+0x1f1/0x280 [mac80211]
 [<f8381b36>] ieee80211_deauth+0x16/0x20 [mac80211]
 [<f8261e70>] cfg80211_mlme_down+0x70/0xc0 [cfg80211]
 [<f8264de1>] __cfg80211_disconnect+0x1b1/0x1d0 [cfg80211]

To fix the problem disconnect from any associated network before
suspend. User space is responsible to establish connection again
after resume. This basically need to be done by user space anyway,
because associated stations can go away during suspend (for example
NetworkManager disconnects on suspend and connect on resume by default).

Patch also handle situation when driver refuse to suspend with wowlan
configured and try to suspend again without it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/pm.c       |  2 +-
 net/wireless/core.c     | 73 +++++++++++++++++++++++++++----------------------
 net/wireless/core.h     |  3 ++
 net/wireless/rdev-ops.h |  7 +++--
 net/wireless/sysfs.c    | 25 +++++++++++++----
 5 files changed, 69 insertions(+), 41 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index d0275f3..4d105c7 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -93,7 +93,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			return err;
 		} else if (err > 0) {
 			WARN_ON(err != 1);
-			local->wowlan = false;
+			return err;
 		} else {
 			list_for_each_entry(sdata, &local->interfaces, list)
 				if (ieee80211_sdata_running(sdata))
diff --git a/net/wireless/core.c b/net/wireless/core.c
index ea4155f..f382cae 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -814,6 +814,46 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 		rdev->num_running_monitor_ifaces += num;
 }
 
+void cfg80211_leave(struct cfg80211_registered_device *rdev,
+		   struct wireless_dev *wdev)
+{
+	struct net_device *dev = wdev->netdev;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_ADHOC:
+		cfg80211_leave_ibss(rdev, dev, true);
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_STATION:
+		mutex_lock(&rdev->sched_scan_mtx);
+		__cfg80211_stop_sched_scan(rdev, false);
+		mutex_unlock(&rdev->sched_scan_mtx);
+
+		wdev_lock(wdev);
+#ifdef CONFIG_CFG80211_WEXT
+		kfree(wdev->wext.ie);
+		wdev->wext.ie = NULL;
+		wdev->wext.ie_len = 0;
+		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
+#endif
+		__cfg80211_disconnect(rdev, dev,
+				      WLAN_REASON_DEAUTH_LEAVING, true);
+		cfg80211_mlme_down(rdev, dev);
+		wdev_unlock(wdev);
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		cfg80211_leave_mesh(rdev, dev);
+		break;
+	case NL80211_IFTYPE_AP:
+		cfg80211_stop_ap(rdev, dev);
+		break;
+	default:
+		break;
+	}
+
+	wdev->beacon_interval = 0;
+}
+
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state,
 					 void *ndev)
@@ -882,38 +922,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			dev->priv_flags |= IFF_DONT_BRIDGE;
 		break;
 	case NETDEV_GOING_DOWN:
-		switch (wdev->iftype) {
-		case NL80211_IFTYPE_ADHOC:
-			cfg80211_leave_ibss(rdev, dev, true);
-			break;
-		case NL80211_IFTYPE_P2P_CLIENT:
-		case NL80211_IFTYPE_STATION:
-			mutex_lock(&rdev->sched_scan_mtx);
-			__cfg80211_stop_sched_scan(rdev, false);
-			mutex_unlock(&rdev->sched_scan_mtx);
-
-			wdev_lock(wdev);
-#ifdef CONFIG_CFG80211_WEXT
-			kfree(wdev->wext.ie);
-			wdev->wext.ie = NULL;
-			wdev->wext.ie_len = 0;
-			wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
-#endif
-			__cfg80211_disconnect(rdev, dev,
-					      WLAN_REASON_DEAUTH_LEAVING, true);
-			cfg80211_mlme_down(rdev, dev);
-			wdev_unlock(wdev);
-			break;
-		case NL80211_IFTYPE_MESH_POINT:
-			cfg80211_leave_mesh(rdev, dev);
-			break;
-		case NL80211_IFTYPE_AP:
-			cfg80211_stop_ap(rdev, dev);
-			break;
-		default:
-			break;
-		}
-		wdev->beacon_interval = 0;
+		cfg80211_leave(rdev, wdev);
 		break;
 	case NETDEV_DOWN:
 		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3aec0e4..e159755 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -503,6 +503,9 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
 
+void cfg80211_leave(struct cfg80211_registered_device *rdev,
+		    struct wireless_dev *wdev);
+
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 422d382..f800168 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -6,11 +6,12 @@
 #include "core.h"
 #include "trace.h"
 
-static inline int rdev_suspend(struct cfg80211_registered_device *rdev)
+static inline int rdev_suspend(struct cfg80211_registered_device *rdev,
+			       struct cfg80211_wowlan *wowlan)
 {
 	int ret;
-	trace_rdev_suspend(&rdev->wiphy, rdev->wowlan);
-	ret = rdev->ops->suspend(&rdev->wiphy, rdev->wowlan);
+	trace_rdev_suspend(&rdev->wiphy, wowlan);
+	ret = rdev->ops->suspend(&rdev->wiphy, wowlan);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 238ee49..99e72a7 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -83,6 +83,14 @@ static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
+static void cfg80211_leave_all(struct cfg80211_registered_device *rdev)
+{
+	struct wireless_dev *wdev;
+
+	list_for_each_entry_rcu(wdev, &rdev->wdev_list, list)
+		cfg80211_leave(rdev, wdev);
+}
+
 static int wiphy_suspend(struct device *dev, pm_message_t state)
 {
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
@@ -90,12 +98,19 @@ static int wiphy_suspend(struct device *dev, pm_message_t state)
 
 	rdev->suspend_at = get_seconds();
 
-	if (rdev->ops->suspend) {
-		rtnl_lock();
-		if (rdev->wiphy.registered)
-			ret = rdev_suspend(rdev);
-		rtnl_unlock();
+	rtnl_lock();
+	if (rdev->wiphy.registered) {
+		if (!rdev->wowlan)
+			cfg80211_leave_all(rdev);
+		if (rdev->ops->suspend)
+			ret = rdev_suspend(rdev, rdev->wowlan);
+		if (ret == 1) {
+			/* Driver refuse to configure wowlan */
+			cfg80211_leave_all(rdev);
+			ret = rdev_suspend(rdev, NULL);
+		}
 	}
+	rtnl_unlock();
 
 	return ret;
 }
-- 
1.7.11.7

