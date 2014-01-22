Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaAVJQf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:16:35 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] cfg80211: send scan results from work queue [BUGFIX]
Date: Wed, 22 Jan 2014 11:14:19 +0200
Message-Id: <1390382059-16689-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140122_101645_159172_C2FBF92E)
In-Reply-To: <1390382059-16689-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1390382059-16689-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to the previous commit, when a scan finishes, it is in theory
possible to hit the following sequence:
 1. interface starts being removed
 2. scan is cancelled by driver and cfg80211 is notified
 3. scan done work is scheduled
 4. interface is removed completely, rdev->scan_req is freed,
    event sent to userspace but scan done work remains pending
 5. new scan is requested on another virtual interface
 6. scan done work runs, freeing the still-running scan

To fix this situation, hang on to the scan done message and block
new scans while that is the case, and only send the message from
the work function, regardless of whether the scan_req is already
freed from interface removal. This makes step 5 above impossible
and changes step 6 to be
 5. scan done work runs, sending the scan done message

As this can't work for wext, so we send the message immediately,
but this shouldn't be an issue since we still return -EBUSY.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    |  4 ++--
 net/wireless/core.h    |  4 +++-
 net/wireless/nl80211.c | 29 ++++++++++-------------------
 net/wireless/nl80211.h |  8 ++++----
 net/wireless/scan.c    | 40 +++++++++++++++++++++++++---------------
 net/wireless/sme.c     |  2 +-
 6 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 98eefd3..d68c762 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -212,7 +212,7 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
 		if (WARN_ON(!rdev->scan_req->notified))
 			rdev->scan_req->aborted = true;
-		___cfg80211_scan_done(rdev);
+		___cfg80211_scan_done(rdev, false);
 	}
 }
 
@@ -905,7 +905,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
 			if (WARN_ON(!rdev->scan_req->notified))
 				rdev->scan_req->aborted = true;
-			___cfg80211_scan_done(rdev);
+			___cfg80211_scan_done(rdev, false);
 		}
 
 		if (WARN_ON(rdev->sched_scan_req &&
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 9262349..58309f2 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -62,6 +62,7 @@ struct cfg80211_registered_device {
 	struct rb_root bss_tree;
 	u32 bss_generation;
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
+	struct sk_buff *scan_msg;
 	struct cfg80211_sched_scan_request *sched_scan_req;
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
@@ -361,7 +362,8 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr);
 void __cfg80211_scan_done(struct work_struct *wk);
-void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev);
+void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
+			   bool send_message);
 void __cfg80211_sched_scan_results(struct work_struct *wk);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4604e5a..af8e67c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5293,7 +5293,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->scan)
 		return -EOPNOTSUPP;
 
-	if (rdev->scan_req) {
+	if (rdev->scan_req || rdev->scan_msg) {
 		err = -EBUSY;
 		goto unlock;
 	}
@@ -10088,40 +10088,31 @@ void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
 				NL80211_MCGRP_SCAN, GFP_KERNEL);
 }
 
-void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
-			    struct wireless_dev *wdev)
+struct sk_buff *nl80211_build_scan_msg(struct cfg80211_registered_device *rdev,
+				       struct wireless_dev *wdev, bool aborted)
 {
 	struct sk_buff *msg;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
-		return;
+		return NULL;
 
 	if (nl80211_send_scan_msg(msg, rdev, wdev, 0, 0, 0,
-				  NL80211_CMD_NEW_SCAN_RESULTS) < 0) {
+				  aborted ? NL80211_CMD_SCAN_ABORTED :
+					    NL80211_CMD_NEW_SCAN_RESULTS) < 0) {
 		nlmsg_free(msg);
-		return;
+		return NULL;
 	}
 
-	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
-				NL80211_MCGRP_SCAN, GFP_KERNEL);
+	return msg;
 }
 
-void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
-			       struct wireless_dev *wdev)
+void nl80211_send_scan_result(struct cfg80211_registered_device *rdev,
+			      struct sk_buff *msg)
 {
-	struct sk_buff *msg;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return;
 
-	if (nl80211_send_scan_msg(msg, rdev, wdev, 0, 0, 0,
-				  NL80211_CMD_SCAN_ABORTED) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
-
 	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
 				NL80211_MCGRP_SCAN, GFP_KERNEL);
 }
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index b1b2313..7579974 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -8,10 +8,10 @@ void nl80211_exit(void);
 void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev);
 void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
 			     struct wireless_dev *wdev);
-void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
-			    struct wireless_dev *wdev);
-void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
-			       struct wireless_dev *wdev);
+struct sk_buff *nl80211_build_scan_msg(struct cfg80211_registered_device *rdev,
+				       struct wireless_dev *wdev, bool aborted);
+void nl80211_send_scan_result(struct cfg80211_registered_device *rdev,
+			      struct sk_buff *msg);
 void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, u32 cmd);
 void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 911dc9a..beb3abd 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -161,18 +161,25 @@ static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
 		dev->bss_generation++;
 }
 
-void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev)
+void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
+			   bool send_message)
 {
 	struct cfg80211_scan_request *request;
 	struct wireless_dev *wdev;
+	struct sk_buff *msg;
 #ifdef CPTCFG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
 
 	ASSERT_RTNL();
 
-	request = rdev->scan_req;
+	if (rdev->scan_msg) {
+		nl80211_send_scan_result(rdev, rdev->scan_msg);
+		rdev->scan_msg = NULL;
+		return;
+	}
 
+	request = rdev->scan_req;
 	if (!request)
 		return;
 
@@ -186,18 +193,16 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev)
 	if (wdev->netdev)
 		cfg80211_sme_scan_done(wdev->netdev);
 
-	if (request->aborted) {
-		nl80211_send_scan_aborted(rdev, wdev);
-	} else {
-		if (request->flags & NL80211_SCAN_FLAG_FLUSH) {
-			/* flush entries from previous scans */
-			spin_lock_bh(&rdev->bss_lock);
-			__cfg80211_bss_expire(rdev, request->scan_start);
-			spin_unlock_bh(&rdev->bss_lock);
-		}
-		nl80211_send_scan_done(rdev, wdev);
+	if (!request->aborted &&
+	    request->flags & NL80211_SCAN_FLAG_FLUSH) {
+		/* flush entries from previous scans */
+		spin_lock_bh(&rdev->bss_lock);
+		__cfg80211_bss_expire(rdev, request->scan_start);
+		spin_unlock_bh(&rdev->bss_lock);
 	}
 
+	msg = nl80211_build_scan_msg(rdev, wdev, request->aborted);
+
 #ifdef CPTCFG_CFG80211_WEXT
 	if (wdev->netdev && !request->aborted) {
 		memset(&wrqu, 0, sizeof(wrqu));
@@ -211,6 +216,11 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev)
 
 	rdev->scan_req = NULL;
 	kfree(request);
+
+	if (!send_message)
+		rdev->scan_msg = msg;
+	else
+		nl80211_send_scan_result(rdev, msg);
 }
 
 void __cfg80211_scan_done(struct work_struct *wk)
@@ -221,7 +231,7 @@ void __cfg80211_scan_done(struct work_struct *wk)
 			    scan_done_wk);
 
 	rtnl_lock();
-	___cfg80211_scan_done(rdev);
+	___cfg80211_scan_done(rdev, true);
 	rtnl_unlock();
 }
 
@@ -1079,7 +1089,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
-	if (rdev->scan_req) {
+	if (rdev->scan_req || rdev->scan_msg) {
 		err = -EBUSY;
 		goto out;
 	}
@@ -1481,7 +1491,7 @@ int cfg80211_wext_giwscan(struct net_device *dev,
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
-	if (rdev->scan_req)
+	if (rdev->scan_req || rdev->scan_msg)
 		return -EAGAIN;
 
 	res = ieee80211_scan_results(rdev, info, extra, data->length);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index c6d1dbe..0f420fb 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -67,7 +67,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	ASSERT_RDEV_LOCK(rdev);
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (rdev->scan_req)
+	if (rdev->scan_req || rdev->scan_msg)
 		return -EBUSY;
 
 	if (wdev->conn->params.channel)
-- 
1.8.3.2

