Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:33560 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaB1PMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 10:12:03 -0500
Received: by mail-ee0-f42.google.com with SMTP id d17so2329859eek.15
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 07:12:01 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 3/3] cfg80211: export interface stopping function
Date: Fri, 28 Feb 2014 16:06:47 +0100
Message-Id: <1393600007-28766-4-git-send-email-michal.kazior@tieto.com> (sfid-20140228_161210_684820_D5628619)
In-Reply-To: <1393600007-28766-1-git-send-email-michal.kazior@tieto.com>
References: <1393600007-28766-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This exports a new cfg80211_stop_iface() function.

This is intended for driver internal interface
combination management and channel switching. This
is probably most useful for AP or provide a
unified way to stopping interface operation from a
driver.

Due to locking issues (it re-enters driver) the
call is asynchronous and uses cfg80211 even
list/worker.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h | 14 ++++++++++++++
 net/wireless/core.c    | 36 +++++++++++++++++++++++++++++++++---
 net/wireless/core.h    |  3 +++
 net/wireless/trace.h   | 15 +++++++++++++++
 net/wireless/util.c    |  5 +++++
 5 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f3411c9..15376c0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4732,6 +4732,20 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 					    void *data),
 			       void *data);
 
+/**
+ * cfg80211_stop_iface - stop operation on given interface
+ *
+ * @wiphy: the wiphy
+ * @wdev: wireless device
+ *
+ * Cease operation of the given interface as if the interface was brought down.
+ * This stops beaconing or disconnects for a BSS.
+ *
+ * This doesn't need any locks and is asynchronous. This is intended for
+ * channel switching and internal driver interface combination management.
+ */
+void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index afd0f08..b2f064f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -748,14 +748,14 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
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
 
-	wdev_lock(wdev);
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_ADHOC:
 		__cfg80211_leave_ibss(rdev, dev, true);
@@ -786,9 +786,39 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 	}
 
 	wdev->beacon_interval = 0;
+}
+
+void cfg80211_leave(struct cfg80211_registered_device *rdev,
+		    struct wireless_dev *wdev)
+{
+	ASSERT_RTNL();
+
+	wdev_lock(wdev);
+	__cfg80211_leave(rdev, wdev);
 	wdev_unlock(wdev);
 }
 
+void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_event *ev;
+	unsigned long flags;
+
+	trace_cfg80211_stop_iface(wiphy, wdev);
+
+	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
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
index 78e6847..402a653 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -182,6 +182,7 @@ enum cfg80211_event_type {
 	EVENT_ROAMED,
 	EVENT_DISCONNECTED,
 	EVENT_IBSS_JOINED,
+	EVENT_STOPPED,
 };
 
 struct cfg80211_event {
@@ -439,6 +440,8 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
 
+void __cfg80211_leave(struct cfg80211_registered_device *rdev,
+		      struct wireless_dev *wdev);
 void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		    struct wireless_dev *wdev);
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index aabccf1..24acf96 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2615,6 +2615,21 @@ TRACE_EVENT(cfg80211_ft_event,
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
index 486b604..2236c08 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -789,6 +789,8 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 	unsigned long flags;
 	const u8 *bssid = NULL;
 
+	ASSERT_RTNL();
+
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	while (!list_empty(&wdev->event_list)) {
 		ev = list_first_entry(&wdev->event_list,
@@ -823,6 +825,9 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
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

