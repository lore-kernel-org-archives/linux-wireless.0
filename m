Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47429 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3CUVMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 17:12:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 3.9] cfg80211: always check for scan end on P2P device
Date: Thu, 21 Mar 2013 22:12:47 +0100
Message-Id: <1363900367-12036-1-git-send-email-johannes@sipsolutions.net> (sfid-20130321_221258_670247_07D207DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a P2P device wdev is removed while it has a scan, then the
scan completion might crash later as it is already freed by
that time. To avoid the crash always check the scan completion
when the P2P device is being removed for some reason. If the
driver already canceled it, don't want and free it, otherwise
warn and leak it to avoid later crashes.

In order to do this, locking needs to be changed away from the
rdev mutex (which can't always be guaranteed). For now, use
the sched_scan_mtx instead, I'll rename it to just scan_mtx in
a later patch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    | 55 ++++++++++++++++++++++++++++++++++++--------------
 net/wireless/core.h    |  3 +++
 net/wireless/nl80211.c | 52 ++++++++++++++++++++++++-----------------------
 net/wireless/scan.c    |  8 +++++---
 net/wireless/sme.c     | 16 +++++++++++----
 5 files changed, 87 insertions(+), 47 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9220021..dfbd063 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -212,6 +212,39 @@ static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
 	rdev_rfkill_poll(rdev);
 }
 
+void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
+			      struct wireless_dev *wdev)
+{
+	lockdep_assert_held(&rdev->devlist_mtx);
+	lockdep_assert_held(&rdev->sched_scan_mtx);
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_P2P_DEVICE))
+		return;
+
+	if (!wdev->p2p_started)
+		return;
+
+	rdev_stop_p2p_device(rdev, wdev);
+	wdev->p2p_started = false;
+
+	rdev->opencount--;
+
+	if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
+		bool busy = work_busy(&rdev->scan_done_wk);
+
+		/*
+		 * If the work isn't pending or running (in which case it would
+		 * be waiting for the lock we hold) the driver didn't properly
+		 * cancel the scan when the interface was removed. In this case
+		 * warn and leak the scan request object to not crash later.
+		 */
+		WARN_ON(!busy);
+
+		rdev->scan_req->aborted = true;
+		___cfg80211_scan_done(rdev, !busy);
+	}
+}
+
 static int cfg80211_rfkill_set_block(void *data, bool blocked)
 {
 	struct cfg80211_registered_device *rdev = data;
@@ -221,6 +254,7 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
 		return 0;
 
 	rtnl_lock();
+	mutex_lock(&rdev->sched_scan_mtx);
 	mutex_lock(&rdev->devlist_mtx);
 
 	list_for_each_entry(wdev, &rdev->wdev_list, list) {
@@ -231,11 +265,7 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
 		/* otherwise, check iftype */
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_P2P_DEVICE:
-			if (!wdev->p2p_started)
-				break;
-			rdev_stop_p2p_device(rdev, wdev);
-			wdev->p2p_started = false;
-			rdev->opencount--;
+			cfg80211_stop_p2p_device(rdev, wdev);
 			break;
 		default:
 			break;
@@ -243,6 +273,7 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
 	}
 
 	mutex_unlock(&rdev->devlist_mtx);
+	mutex_unlock(&rdev->sched_scan_mtx);
 	rtnl_unlock();
 
 	return 0;
@@ -745,17 +776,13 @@ static void wdev_cleanup_work(struct work_struct *work)
 	wdev = container_of(work, struct wireless_dev, cleanup_work);
 	rdev = wiphy_to_dev(wdev->wiphy);
 
-	cfg80211_lock_rdev(rdev);
+	mutex_lock(&rdev->sched_scan_mtx);
 
 	if (WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev)) {
 		rdev->scan_req->aborted = true;
 		___cfg80211_scan_done(rdev, true);
 	}
 
-	cfg80211_unlock_rdev(rdev);
-
-	mutex_lock(&rdev->sched_scan_mtx);
-
 	if (WARN_ON(rdev->sched_scan_req &&
 		    rdev->sched_scan_req->dev == wdev->netdev)) {
 		__cfg80211_stop_sched_scan(rdev, false);
@@ -780,23 +807,21 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 	if (WARN_ON(wdev->netdev))
 		return;
 
+	mutex_lock(&rdev->sched_scan_mtx);
 	mutex_lock(&rdev->devlist_mtx);
 	list_del_rcu(&wdev->list);
 	rdev->devlist_generation++;
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		if (!wdev->p2p_started)
-			break;
-		rdev_stop_p2p_device(rdev, wdev);
-		wdev->p2p_started = false;
-		rdev->opencount--;
+		cfg80211_stop_p2p_device(rdev, wdev);
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
 	}
 	mutex_unlock(&rdev->devlist_mtx);
+	mutex_unlock(&rdev->sched_scan_mtx);
 }
 EXPORT_SYMBOL(cfg80211_unregister_wdev);
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3aec0e4..5845c2b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -503,6 +503,9 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
 
+void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
+			      struct wireless_dev *wdev);
+
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d44ab21..58e13a8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4702,14 +4702,19 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->scan)
 		return -EOPNOTSUPP;
 
-	if (rdev->scan_req)
-		return -EBUSY;
+	mutex_lock(&rdev->sched_scan_mtx);
+	if (rdev->scan_req) {
+		err = -EBUSY;
+		goto unlock;
+	}
 
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		n_channels = validate_scan_freqs(
 				info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
-		if (!n_channels)
-			return -EINVAL;
+		if (!n_channels) {
+			err = -EINVAL;
+			goto unlock;
+		}
 	} else {
 		enum ieee80211_band band;
 		n_channels = 0;
@@ -4723,23 +4728,29 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp)
 			n_ssids++;
 
-	if (n_ssids > wiphy->max_scan_ssids)
-		return -EINVAL;
+	if (n_ssids > wiphy->max_scan_ssids) {
+		err = -EINVAL;
+		goto unlock;
+	}
 
 	if (info->attrs[NL80211_ATTR_IE])
 		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	else
 		ie_len = 0;
 
-	if (ie_len > wiphy->max_scan_ie_len)
-		return -EINVAL;
+	if (ie_len > wiphy->max_scan_ie_len) {
+		err = -EINVAL;
+		goto unlock;
+	}
 
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*request->ssids) * n_ssids
 			+ sizeof(*request->channels) * n_channels
 			+ ie_len, GFP_KERNEL);
-	if (!request)
-		return -ENOMEM;
+	if (!request) {
+		err = -ENOMEM;
+		goto unlock;
+	}
 
 	if (n_ssids)
 		request->ssids = (void *)&request->channels[n_channels];
@@ -4876,6 +4887,8 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		kfree(request);
 	}
 
+ unlock:
+	mutex_unlock(&rdev->sched_scan_mtx);
 	return err;
 }
 
@@ -7749,20 +7762,9 @@ static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->stop_p2p_device)
 		return -EOPNOTSUPP;
 
-	if (!wdev->p2p_started)
-		return 0;
-
-	rdev_stop_p2p_device(rdev, wdev);
-	wdev->p2p_started = false;
-
-	mutex_lock(&rdev->devlist_mtx);
-	rdev->opencount--;
-	mutex_unlock(&rdev->devlist_mtx);
-
-	if (WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev)) {
-		rdev->scan_req->aborted = true;
-		___cfg80211_scan_done(rdev, true);
-	}
+	mutex_lock(&rdev->sched_scan_mtx);
+	cfg80211_stop_p2p_device(rdev, wdev);
+	mutex_unlock(&rdev->sched_scan_mtx);
 
 	return 0;
 }
@@ -8486,7 +8488,7 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	struct nlattr *nest;
 	int i;
 
-	ASSERT_RDEV_LOCK(rdev);
+	lockdep_assert_held(&rdev->sched_scan_mtx);
 
 	if (WARN_ON(!req))
 		return 0;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index e93bd31..fd99ea4 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -169,7 +169,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 	union iwreq_data wrqu;
 #endif
 
-	ASSERT_RDEV_LOCK(rdev);
+	lockdep_assert_held(&rdev->sched_scan_mtx);
 
 	request = rdev->scan_req;
 
@@ -230,9 +230,9 @@ void __cfg80211_scan_done(struct work_struct *wk)
 	rdev = container_of(wk, struct cfg80211_registered_device,
 			    scan_done_wk);
 
-	cfg80211_lock_rdev(rdev);
+	mutex_lock(&rdev->sched_scan_mtx);
 	___cfg80211_scan_done(rdev, false);
-	cfg80211_unlock_rdev(rdev);
+	mutex_unlock(&rdev->sched_scan_mtx);
 }
 
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
@@ -1062,6 +1062,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
+	mutex_lock(&rdev->sched_scan_mtx);
 	if (rdev->scan_req) {
 		err = -EBUSY;
 		goto out;
@@ -1168,6 +1169,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 		dev_hold(dev);
 	}
  out:
+	mutex_unlock(&rdev->sched_scan_mtx);
 	kfree(creq);
 	cfg80211_unlock_rdev(rdev);
 	return err;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index f432bd3..fbb1a57 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -86,8 +86,12 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	ASSERT_RDEV_LOCK(rdev);
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (rdev->scan_req)
-		return -EBUSY;
+	mutex_lock(&rdev->sched_scan_mtx);
+
+	if (rdev->scan_req) {
+		err = -EBUSY;
+		goto unlock;
+	}
 
 	if (wdev->conn->params.channel) {
 		n_channels = 1;
@@ -104,8 +108,10 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	request = kzalloc(sizeof(*request) + sizeof(request->ssids[0]) +
 			  sizeof(request->channels[0]) * n_channels,
 			  GFP_KERNEL);
-	if (!request)
-		return -ENOMEM;
+	if (!request) {
+		err = -ENOMEM;
+		goto unlock;
+	}
 
 	if (wdev->conn->params.channel)
 		request->channels[0] = wdev->conn->params.channel;
@@ -152,6 +158,8 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 		rdev->scan_req = NULL;
 		kfree(request);
 	}
+ unlock:
+	mutex_unlock(&rdev->sched_scan_mtx);
 	return err;
 }
 
-- 
1.8.0

