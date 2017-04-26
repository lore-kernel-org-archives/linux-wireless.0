Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43160 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1956204AbdDZGnm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 02:43:42 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: simplify netlink socket owner interface deletion
Date: Wed, 26 Apr 2017 08:43:35 +0200
Message-Id: <20170426064335.13005-1-johannes@sipsolutions.net> (sfid-20170426_084349_625783_DD19358D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to allocate a portid structure and then, for
each of those, walk the interfaces - we can just add a flag
to each interface and walk those directly. Due to padding in
the struct, we can even do it without any memory cost, and
it even simplifies the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  5 +++--
 net/wireless/core.c    | 26 ++++----------------------
 net/wireless/core.h    |  8 --------
 net/wireless/nl80211.c | 22 +++++-----------------
 4 files changed, 12 insertions(+), 49 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2a200b964b7a..999ec24afbe7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4037,12 +4037,13 @@ struct wireless_dev {
 
 	u32 ap_unexpected_nlportid;
 
+	u32 owner_nlportid;
+	bool nl_owner_dead;
+
 	bool cac_started;
 	unsigned long cac_start_time;
 	unsigned int cac_time_ms;
 
-	u32 owner_nlportid;
-
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
diff --git a/net/wireless/core.c b/net/wireless/core.c
index b0d6761f0cdd..4ea28de3a636 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -305,30 +305,14 @@ static void cfg80211_event_work(struct work_struct *work)
 
 void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev)
 {
-	struct cfg80211_iface_destroy *item;
+	struct wireless_dev *wdev, *tmp;
 
 	ASSERT_RTNL();
 
-	spin_lock_irq(&rdev->destroy_list_lock);
-	while ((item = list_first_entry_or_null(&rdev->destroy_list,
-						struct cfg80211_iface_destroy,
-						list))) {
-		struct wireless_dev *wdev, *tmp;
-		u32 nlportid = item->nlportid;
-
-		list_del(&item->list);
-		kfree(item);
-		spin_unlock_irq(&rdev->destroy_list_lock);
-
-		list_for_each_entry_safe(wdev, tmp,
-					 &rdev->wiphy.wdev_list, list) {
-			if (nlportid == wdev->owner_nlportid)
-				rdev_del_virtual_intf(rdev, wdev);
-		}
-
-		spin_lock_irq(&rdev->destroy_list_lock);
+	list_for_each_entry_safe(wdev, tmp, &rdev->wiphy.wdev_list, list) {
+		if (wdev->nl_owner_dead)
+			rdev_del_virtual_intf(rdev, wdev);
 	}
-	spin_unlock_irq(&rdev->destroy_list_lock);
 }
 
 static void cfg80211_destroy_iface_wk(struct work_struct *work)
@@ -484,8 +468,6 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	rdev->wiphy.dev.platform_data = rdev;
 	device_enable_async_suspend(&rdev->wiphy.dev);
 
-	INIT_LIST_HEAD(&rdev->destroy_list);
-	spin_lock_init(&rdev->destroy_list_lock);
 	INIT_WORK(&rdev->destroy_work, cfg80211_destroy_iface_wk);
 	INIT_WORK(&rdev->sched_scan_stop_wk, cfg80211_sched_scan_stop_wk);
 	INIT_WORK(&rdev->propagate_radar_detect_wk,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5d27eca57d3b..f9b748e3425a 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -91,10 +91,7 @@ struct cfg80211_registered_device {
 
 	struct cfg80211_coalesce *coalesce;
 
-	spinlock_t destroy_list_lock;
-	struct list_head destroy_list;
 	struct work_struct destroy_work;
-
 	struct work_struct sched_scan_stop_wk;
 
 	struct cfg80211_chan_def radar_chandef;
@@ -264,11 +261,6 @@ struct cfg80211_beacon_registration {
 	u32 nlportid;
 };
 
-struct cfg80211_iface_destroy {
-	struct list_head list;
-	u32 nlportid;
-};
-
 struct cfg80211_cqm_config {
 	u32 rssi_hyst;
 	s32 last_rssi_event_value;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 50c35affccad..45f5f418e562 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14883,7 +14883,6 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
-		bool schedule_destroy_work = false;
 		struct cfg80211_sched_scan_request *sched_scan_req =
 			rcu_dereference(rdev->sched_scan_req);
 
@@ -14899,10 +14898,12 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 		list_for_each_entry_rcu(wdev, &rdev->wiphy.wdev_list, list) {
 			cfg80211_mlme_unregister_socket(wdev, notify->portid);
 
-			if (wdev->owner_nlportid == notify->portid)
-				schedule_destroy_work = true;
-			else if (wdev->conn_owner_nlportid == notify->portid)
+			if (wdev->owner_nlportid == notify->portid) {
+				wdev->nl_owner_dead = true;
+				schedule_work(&rdev->destroy_work);
+			} else if (wdev->conn_owner_nlportid == notify->portid) {
 				schedule_work(&wdev->disconnect_wk);
+			}
 		}
 
 		spin_lock_bh(&rdev->beacon_registrations_lock);
@@ -14915,19 +14916,6 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 			}
 		}
 		spin_unlock_bh(&rdev->beacon_registrations_lock);
-
-		if (schedule_destroy_work) {
-			struct cfg80211_iface_destroy *destroy;
-
-			destroy = kzalloc(sizeof(*destroy), GFP_ATOMIC);
-			if (destroy) {
-				destroy->nlportid = notify->portid;
-				spin_lock(&rdev->destroy_list_lock);
-				list_add(&destroy->list, &rdev->destroy_list);
-				spin_unlock(&rdev->destroy_list_lock);
-				schedule_work(&rdev->destroy_work);
-			}
-		}
 	}
 
 	rcu_read_unlock();
-- 
2.11.0
