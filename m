Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab3B0PAp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 10:00:45 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 1/8] cfg80211: disconnect on suspend
Date: Wed, 27 Feb 2013 16:00:35 +0100
Message-Id: <1361977242-17344-1-git-send-email-sgruszka@redhat.com> (sfid-20130227_160049_704537_5C2F12D8)
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

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/wireless/core.c  | 73 +++++++++++++++++++++++++++++-----------------------
 net/wireless/core.h  |  3 +++
 net/wireless/sysfs.c | 14 +++++++---
 3 files changed, 54 insertions(+), 36 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5ffff03..5a4dc09 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -815,6 +815,46 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
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
@@ -883,38 +923,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
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
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 238ee49..7de8092 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -86,16 +86,22 @@ static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
 static int wiphy_suspend(struct device *dev, pm_message_t state)
 {
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
+	struct wireless_dev *wdev;
 	int ret = 0;
 
 	rdev->suspend_at = get_seconds();
 
-	if (rdev->ops->suspend) {
-		rtnl_lock();
-		if (rdev->wiphy.registered)
+	rtnl_lock();
+	if (rdev->wiphy.registered) {
+		if (!rdev->wowlan) {
+			list_for_each_entry_rcu(wdev, &rdev->wdev_list, list)
+				cfg80211_leave(rdev, wdev);
+		}
+
+		if (rdev->ops->suspend)
 			ret = rdev_suspend(rdev);
-		rtnl_unlock();
 	}
+	rtnl_unlock();
 
 	return ret;
 }
-- 
1.7.11.7

