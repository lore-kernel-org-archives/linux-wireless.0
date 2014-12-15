Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9812 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaLOLZo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 06:25:44 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v9 1/2] nl80211: Convert sched_scan_req pointer to RCU pointer
Date: Mon, 15 Dec 2014 13:25:38 +0200
Message-Id: <1418642739-11016-2-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141215_122550_422352_19063DBD)
In-Reply-To: <1418642739-11016-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1418642739-11016-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of possible races when accessing sched_scan_req pointer in
rdev, the sched_scan_req is converted to RCU pointer.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 include/net/cfg80211.h |  1 +
 net/wireless/core.c    | 10 +++++++---
 net/wireless/core.h    |  2 +-
 net/wireless/nl80211.c | 19 +++++++++++--------
 net/wireless/scan.c    | 13 ++++++++-----
 5 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb748c4..8ea8b94 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1537,6 +1537,7 @@ struct cfg80211_sched_scan_request {
 	struct wiphy *wiphy;
 	struct net_device *dev;
 	unsigned long scan_start;
+	struct rcu_head rcu_head;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 4c2e501..9b43438 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -844,6 +844,7 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev)
 {
 	struct net_device *dev = wdev->netdev;
+	struct cfg80211_sched_scan_request *sched_scan_req;
 
 	ASSERT_RTNL();
 	ASSERT_WDEV_LOCK(wdev);
@@ -854,7 +855,8 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-		if (rdev->sched_scan_req && dev == rdev->sched_scan_req->dev)
+		sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
+		if (sched_scan_req && dev == sched_scan_req->dev)
 			__cfg80211_stop_sched_scan(rdev, false);
 
 #ifdef CONFIG_CFG80211_WEXT
@@ -929,6 +931,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev;
+	struct cfg80211_sched_scan_request *sched_scan_req;
 
 	if (!wdev)
 		return NOTIFY_DONE;
@@ -993,8 +996,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			___cfg80211_scan_done(rdev, false);
 		}
 
-		if (WARN_ON(rdev->sched_scan_req &&
-			    rdev->sched_scan_req->dev == wdev->netdev)) {
+		sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
+		if (WARN_ON(sched_scan_req &&
+			    sched_scan_req->dev == wdev->netdev)) {
 			__cfg80211_stop_sched_scan(rdev, false);
 		}
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index faa5b16..6cded4d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -63,7 +63,7 @@ struct cfg80211_registered_device {
 	u32 bss_generation;
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	struct sk_buff *scan_msg;
-	struct cfg80211_sched_scan_request *sched_scan_req;
+	struct cfg80211_sched_scan_request __rcu *sched_scan_req;
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
 	struct work_struct sched_scan_results_wk;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b5e3c48..be2654b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6068,6 +6068,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_sched_scan_request *sched_scan_req;
 	int err;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
@@ -6077,27 +6078,29 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (rdev->sched_scan_req)
 		return -EINPROGRESS;
 
-	rdev->sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy, wdev,
-							info->attrs);
-	err = PTR_ERR_OR_ZERO(rdev->sched_scan_req);
+	sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy, wdev,
+						  info->attrs);
+
+	err = PTR_ERR_OR_ZERO(sched_scan_req);
 	if (err)
 		goto out_err;
 
-	err = rdev_sched_scan_start(rdev, dev, rdev->sched_scan_req);
+	err = rdev_sched_scan_start(rdev, dev, sched_scan_req);
 	if (err)
 		goto out_free;
 
-	rdev->sched_scan_req->dev = dev;
-	rdev->sched_scan_req->wiphy = &rdev->wiphy;
+	sched_scan_req->dev = dev;
+	sched_scan_req->wiphy = &rdev->wiphy;
+
+	rcu_assign_pointer(rdev->sched_scan_req, sched_scan_req);
 
 	nl80211_send_sched_scan(rdev, dev,
 				NL80211_CMD_START_SCHED_SCAN);
 	return 0;
 
 out_free:
-	kfree(rdev->sched_scan_req);
+	kfree(sched_scan_req);
 out_err:
-	rdev->sched_scan_req = NULL;
 	return err;
 }
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index bda39f1..c705c3e 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -257,7 +257,7 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 
 	rtnl_lock();
 
-	request = rdev->sched_scan_req;
+	request = rtnl_dereference(rdev->sched_scan_req);
 
 	/* we don't have sched_scan_req anymore if the scan is stopping */
 	if (request) {
@@ -279,7 +279,8 @@ void cfg80211_sched_scan_results(struct wiphy *wiphy)
 {
 	trace_cfg80211_sched_scan_results(wiphy);
 	/* ignore if we're not scanning */
-	if (wiphy_to_rdev(wiphy)->sched_scan_req)
+
+	if (rcu_access_pointer(wiphy_to_rdev(wiphy)->sched_scan_req))
 		queue_work(cfg80211_wq,
 			   &wiphy_to_rdev(wiphy)->sched_scan_results_wk);
 }
@@ -308,6 +309,7 @@ EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated)
 {
+	struct cfg80211_sched_scan_request *sched_scan_req;
 	struct net_device *dev;
 
 	ASSERT_RTNL();
@@ -315,7 +317,8 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	if (!rdev->sched_scan_req)
 		return -ENOENT;
 
-	dev = rdev->sched_scan_req->dev;
+	sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
+	dev = sched_scan_req->dev;
 
 	if (!driver_initiated) {
 		int err = rdev_sched_scan_stop(rdev, dev);
@@ -325,8 +328,8 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 
 	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_SCHED_SCAN_STOPPED);
 
-	kfree(rdev->sched_scan_req);
-	rdev->sched_scan_req = NULL;
+	RCU_INIT_POINTER(rdev->sched_scan_req, NULL);
+	kfree_rcu(sched_scan_req, rcu_head);
 
 	return 0;
 }
-- 
1.8.3.1

