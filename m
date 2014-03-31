Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:65060 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaCaKDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 06:03:32 -0400
Received: by mail-wg0-f43.google.com with SMTP id x13so5549675wgg.26
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 03:03:31 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 3/4] cfg80211: export interface stopping function
Date: Mon, 31 Mar 2014 11:57:20 +0200
Message-Id: <1396259841-6359-4-git-send-email-michal.kazior@tieto.com> (sfid-20140331_120343_045751_7CB4FB28)
In-Reply-To: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
References: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
 <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This exports a new cfg80211_stop_iface() function.

This is intended for driver internal interface
combination management and channel switching.

Due to locking issues (it re-enters driver) the
call is asynchronous and uses cfg80211 event
list/worker.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v3:
 * improve function comment [Luca]
 * add gfp_t argument [Luca]
 * remove redundant lockdep checks [Arend]

 include/net/cfg80211.h | 15 +++++++++++++++
 net/wireless/ap.c      |  4 ++--
 net/wireless/core.c    | 43 ++++++++++++++++++++++++++++++++++++-------
 net/wireless/core.h    |  7 +++++++
 net/wireless/mesh.c    |  4 ++--
 net/wireless/trace.h   | 15 +++++++++++++++
 net/wireless/util.c    |  3 +++
 7 files changed, 80 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fb8afce..b4ea653 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4715,6 +4715,21 @@ int cfg80211_check_combinations(struct wiphy *wiphy,
 				const u8 radar_detect,
 				const int iftype_num[NUM_NL80211_IFTYPES]);
 
+/*
+ * cfg80211_stop_iface - trigger interface disconnection
+ *
+ * @wiphy: the wiphy
+ * @wdev: wireless device
+ * @gfp: context flags
+ *
+ * Trigger interface to be stopped as if AP was stopped, IBSS/mesh left, STA
+ * disconnected.
+ *
+ * Note: This doesn't need any locks and is asynchronous.
+ */
+void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
+			 gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 3e02ade..bdad1f9 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -6,8 +6,8 @@
 #include "rdev-ops.h"
 
 
-static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
-			      struct net_device *dev, bool notify)
+int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev, bool notify)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5fc0df0..585b131 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -792,23 +792,23 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 		rdev->num_running_monitor_ifaces += num;
 }
 
-void cfg80211_leave(struct cfg80211_registered_device *rdev,
-		    struct wireless_dev *wdev)
+void __cfg80211_leave(struct cfg80211_registered_device *rdev,
+		      struct wireless_dev *wdev)
 {
 	struct net_device *dev = wdev->netdev;
 
 	ASSERT_RTNL();
+	ASSERT_WDEV_LOCK(wdev);
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_ADHOC:
-		cfg80211_leave_ibss(rdev, dev, true);
+		__cfg80211_leave_ibss(rdev, dev, true);
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
 		if (rdev->sched_scan_req && dev == rdev->sched_scan_req->dev)
 			__cfg80211_stop_sched_scan(rdev, false);
 
-		wdev_lock(wdev);
 #ifdef CONFIG_CFG80211_WEXT
 		kfree(wdev->wext.ie);
 		wdev->wext.ie = NULL;
@@ -817,14 +817,13 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 #endif
 		cfg80211_disconnect(rdev, dev,
 				    WLAN_REASON_DEAUTH_LEAVING, true);
-		wdev_unlock(wdev);
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
-		cfg80211_leave_mesh(rdev, dev);
+		__cfg80211_leave_mesh(rdev, dev);
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		cfg80211_stop_ap(rdev, dev, true);
+		__cfg80211_stop_ap(rdev, dev, true);
 		break;
 	default:
 		break;
@@ -833,6 +832,36 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 	wdev->beacon_interval = 0;
 }
 
+void cfg80211_leave(struct cfg80211_registered_device *rdev,
+		    struct wireless_dev *wdev)
+{
+	wdev_lock(wdev);
+	__cfg80211_leave(rdev, wdev);
+	wdev_unlock(wdev);
+}
+
+void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
+			 gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_event *ev;
+	unsigned long flags;
+
+	trace_cfg80211_stop_iface(wiphy, wdev);
+
+	ev = kzalloc(sizeof(*ev), gfp);
+	if (!ev)
+		return;
+
+	ev->type = EVENT_STOPPED;
+
+	spin_lock_irqsave(&wdev->event_lock, flags);
+	list_add_tail(&ev->list, &wdev->event_list);
+	spin_unlock_irqrestore(&wdev->event_lock, flags);
+	queue_work(cfg80211_wq, &rdev->event_work);
+}
+EXPORT_SYMBOL(cfg80211_stop_iface);
+
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state, void *ptr)
 {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5bee6cc..5876c8d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -185,6 +185,7 @@ enum cfg80211_event_type {
 	EVENT_ROAMED,
 	EVENT_DISCONNECTED,
 	EVENT_IBSS_JOINED,
+	EVENT_STOPPED,
 };
 
 struct cfg80211_event {
@@ -281,6 +282,8 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
 		       struct mesh_setup *setup,
 		       const struct mesh_config *conf);
+int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev);
 int cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 			struct net_device *dev);
 int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
@@ -288,6 +291,8 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 			      struct cfg80211_chan_def *chandef);
 
 /* AP */
+int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev, bool notify);
 int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		     struct net_device *dev, bool notify);
 
@@ -441,6 +446,8 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
 
+void __cfg80211_leave(struct cfg80211_registered_device *rdev,
+		      struct wireless_dev *wdev);
 void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		    struct wireless_dev *wdev);
 
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 3ddfb7c..092300b 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -238,8 +238,8 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
-static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
-				 struct net_device *dev)
+int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 47b499f..1ccb2a3 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2618,6 +2618,21 @@ TRACE_EVENT(cfg80211_ft_event,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(target_ap))
 );
 
+TRACE_EVENT(cfg80211_stop_iface,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT,
+		  WIPHY_PR_ARG, WDEV_PR_ARG)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/net/wireless/util.c b/net/wireless/util.c
index c5d0208..31b93b9 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -823,6 +823,9 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid,
 					       ev->ij.channel);
 			break;
+		case EVENT_STOPPED:
+			__cfg80211_leave(wiphy_to_dev(wdev->wiphy), wdev);
+			break;
 		}
 		wdev_unlock(wdev);
 
-- 
1.8.5.3

