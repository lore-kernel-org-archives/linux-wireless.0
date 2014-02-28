Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:38301 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaB1PDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 10:03:19 -0500
Received: by mail-ee0-f52.google.com with SMTP id c41so2339982eek.11
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 07:03:18 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] cfg80211: fix cfg80211_leave() locking
Date: Fri, 28 Feb 2014 15:58:00 +0100
Message-Id: <1393599480-27908-1-git-send-email-michal.kazior@tieto.com> (sfid-20140228_160329_016663_0BC2BB43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon_interval was set unprotected by
wdev.mtx. This could possibly lead to inconsistent
cfg80211 states.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/ap.c   |  4 ++--
 net/wireless/core.c | 10 +++++-----
 net/wireless/core.h |  4 ++++
 net/wireless/mesh.c |  4 ++--
 4 files changed, 13 insertions(+), 9 deletions(-)

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
index 276cf93..55599f7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -758,16 +758,16 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 
 	ASSERT_RTNL();
 
+	wdev_lock(wdev);
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
@@ -776,20 +776,20 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
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
 	}
 
 	wdev->beacon_interval = 0;
+	wdev_unlock(wdev);
 }
 
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3975ffa..912d822 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -275,6 +275,8 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
 		       struct mesh_setup *setup,
 		       const struct mesh_config *conf);
+int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev);
 int cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 			struct net_device *dev);
 int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
@@ -282,6 +284,8 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 			      struct cfg80211_chan_def *chandef);
 
 /* AP */
+int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev, bool notify);
 int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		     struct net_device *dev, bool notify);
 
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 5af5cc6..b5c304e 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -262,8 +262,8 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
-static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
-				 struct net_device *dev)
+int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
-- 
1.8.5.3

