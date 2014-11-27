Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59061 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbaK0KVd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 05:21:33 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v8 2/2] nl80211: Convert sched_scan_req pointer to RCU pointer
Date: Thu, 27 Nov 2014 12:21:08 +0200
Message-Id: <1417083668-11958-3-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141127_112140_121468_F37E5F3F)
In-Reply-To: <1417083668-11958-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1417083668-11958-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of possible races when accessing sched_scan_req pointer in
rdev, the sched_scan_req is converted to RCU pointer.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 include/net/cfg80211.h |  1 +
 net/wireless/core.c    | 10 +++++++---
 net/wireless/core.h    |  2 +-
 net/wireless/nl80211.c | 27 ++++++++++++++++-----------
 net/wireless/scan.c    | 20 +++++++++++++++-----
 5 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5806c75..0e540fc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1538,6 +1538,7 @@ struct cfg80211_sched_scan_request {
 	struct net_device *dev;
 	unsigned long scan_start;
 	u32 owner_nlportid;
+	struct rcu_head rcu_head;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8236e2d..b612b71 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -860,6 +860,7 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev)
 {
 	struct net_device *dev = wdev->netdev;
+	struct cfg80211_sched_scan_request *sched_scan_req;
 
 	ASSERT_RTNL();
 	ASSERT_WDEV_LOCK(wdev);
@@ -870,7 +871,8 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-		if (rdev->sched_scan_req && dev == rdev->sched_scan_req->dev)
+		sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
+		if (sched_scan_req && dev == sched_scan_req->dev)
 			__cfg80211_stop_sched_scan(rdev, false);
 
 #ifdef CONFIG_CFG80211_WEXT
@@ -945,6 +947,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev;
+	struct cfg80211_sched_scan_request *sched_scan_req;
 
 	if (!wdev)
 		return NOTIFY_DONE;
@@ -1009,8 +1012,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
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
index 5327375..4e3630b 100644
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
index a5cc4d6..6cdb2ff 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6068,6 +6068,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_sched_scan_request *sched_scan_req;
 	int err;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
@@ -6077,30 +6078,34 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
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
+	rcu_assign_pointer(rdev->sched_scan_req, sched_scan_req);
+
+	err = rdev_sched_scan_start(rdev, dev, sched_scan_req);
 	if (err)
 		goto out_free;
 
-	rdev->sched_scan_req->dev = dev;
-	rdev->sched_scan_req->wiphy = &rdev->wiphy;
-
 	if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
-		rdev->sched_scan_req->owner_nlportid = info->snd_portid;
+		rtnl_dereference(rdev->sched_scan_req)->owner_nlportid =
+			info->snd_portid;
+
+	rtnl_dereference(rdev->sched_scan_req)->dev = dev;
+	rtnl_dereference(rdev->sched_scan_req)->wiphy = &rdev->wiphy;
 
 	nl80211_send_sched_scan(rdev, dev,
 				NL80211_CMD_START_SCHED_SCAN);
 	return 0;
 
 out_free:
-	kfree(rdev->sched_scan_req);
+	kfree_rcu(sched_scan_req, rcu_head);
+	rcu_assign_pointer(rdev->sched_scan_req, NULL);
 out_err:
-	rdev->sched_scan_req = NULL;
 	return err;
 }
 
@@ -12476,7 +12481,7 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 		bool schedule_destroy_work = false;
 		bool schedule_scan_stop = false;
 		struct cfg80211_sched_scan_request *sched_scan_req =
-			rdev->sched_scan_req;
+			rcu_dereference(rdev->sched_scan_req);
 
 		if (sched_scan_req && notify->portid &&
 		    sched_scan_req->owner_nlportid == notify->portid)
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index bda39f1..c508d30 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -257,7 +257,7 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 
 	rtnl_lock();
 
-	request = rdev->sched_scan_req;
+	request = rtnl_dereference(rdev->sched_scan_req);
 
 	/* we don't have sched_scan_req anymore if the scan is stopping */
 	if (request) {
@@ -277,9 +277,16 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 
 void cfg80211_sched_scan_results(struct wiphy *wiphy)
 {
+	struct cfg80211_sched_scan_request *sched_scan_req;
+
 	trace_cfg80211_sched_scan_results(wiphy);
 	/* ignore if we're not scanning */
-	if (wiphy_to_rdev(wiphy)->sched_scan_req)
+
+	rcu_read_lock();
+	sched_scan_req = rcu_dereference(wiphy_to_rdev(wiphy)->sched_scan_req);
+	rcu_read_unlock();
+
+	if (sched_scan_req)
 		queue_work(cfg80211_wq,
 			   &wiphy_to_rdev(wiphy)->sched_scan_results_wk);
 }
@@ -308,6 +315,7 @@ EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated)
 {
+	struct cfg80211_sched_scan_request *sched_scan_req;
 	struct net_device *dev;
 
 	ASSERT_RTNL();
@@ -315,7 +323,8 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	if (!rdev->sched_scan_req)
 		return -ENOENT;
 
-	dev = rdev->sched_scan_req->dev;
+	sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
+	dev = sched_scan_req->dev;
 
 	if (!driver_initiated) {
 		int err = rdev_sched_scan_stop(rdev, dev);
@@ -325,8 +334,9 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 
 	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_SCHED_SCAN_STOPPED);
 
-	kfree(rdev->sched_scan_req);
-	rdev->sched_scan_req = NULL;
+	kfree_rcu(sched_scan_req, rcu_head);
+
+	rcu_assign_pointer(rdev->sched_scan_req, NULL);
 
 	return 0;
 }
-- 
1.8.3.1

