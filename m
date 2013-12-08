Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19469 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab3LHTuG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Dec 2013 14:50:06 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Subject: [PATCH] mac80211: reschedule sched scan after HW restart
Date: Sun,  8 Dec 2013 21:48:57 +0200
Message-Id: <1386532137-25099-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131208_205026_775984_7C39FF5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Keep the sched scan req when starting sched scan, and reschedule
it in case of HW restart during sched scan.
The upper layer don't have to know about the restart.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  4 ++++
 net/mac80211/main.c        |  8 ++-----
 net/mac80211/scan.c        | 53 ++++++++++++++++++++++++++++++++++------------
 net/mac80211/util.c        | 23 ++++++++++++++++++++
 4 files changed, 68 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ef96bb6..e85b86a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1122,6 +1122,7 @@ struct ieee80211_local {
 
 	struct work_struct sched_scan_stopped_work;
 	struct ieee80211_sub_if_data __rcu *sched_scan_sdata;
+	struct cfg80211_sched_scan_request *sched_scan_req;
 
 	unsigned long leave_oper_channel_time;
 	enum mac80211_scan_state next_scan_state;
@@ -1433,6 +1434,9 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss);
 
 /* scheduled scan handling */
+int
+__ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
+				     struct cfg80211_sched_scan_request *req);
 int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 				       struct cfg80211_sched_scan_request *req);
 int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 239271d..5d1904b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -254,12 +254,8 @@ static void ieee80211_restart_work(struct work_struct *work)
 	/* wait for scan work complete */
 	flush_workqueue(local->workqueue);
 
-	mutex_lock(&local->mtx);
-	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
-	     rcu_dereference_protected(local->sched_scan_sdata,
-				       lockdep_is_held(&local->mtx)),
-		"%s called with hardware scan in progress\n", __func__);
-	mutex_unlock(&local->mtx);
+	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
+	     "%s called with hardware scan in progress\n", __func__);
 
 	rtnl_lock();
 	ieee80211_scan_cancel(local);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 5031641..5452900 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -970,8 +970,8 @@ out:
 	mutex_unlock(&local->mtx);
 }
 
-int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
-				       struct cfg80211_sched_scan_request *req)
+int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
+					struct cfg80211_sched_scan_request *req)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sched_scan_ies sched_scan_ies = {};
@@ -981,17 +981,10 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	iebufsz = 2 + IEEE80211_MAX_SSID_LEN +
 		  local->scan_ies_len + req->ie_len;
 
-	mutex_lock(&local->mtx);
+	lockdep_assert_held(&local->mtx);
 
-	if (rcu_access_pointer(local->sched_scan_sdata)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	if (!local->ops->sched_scan_start) {
-		ret = -ENOTSUPP;
-		goto out;
-	}
+	if (!local->ops->sched_scan_start)
+		return -ENOTSUPP;
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		if (!local->hw.wiphy->bands[i])
@@ -1012,13 +1005,39 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ret = drv_sched_scan_start(local, sdata, req, &sched_scan_ies);
-	if (ret == 0)
+	if (ret == 0) {
 		rcu_assign_pointer(local->sched_scan_sdata, sdata);
+		local->sched_scan_req = req;
+	}
 
 out_free:
 	while (i > 0)
 		kfree(sched_scan_ies.ie[--i]);
-out:
+
+	if (ret) {
+		/* Clean in case of failure after HW restart or upon resume. */
+		rcu_assign_pointer(local->sched_scan_sdata, NULL);
+		local->sched_scan_req = NULL;
+	}
+
+	return ret;
+}
+
+int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
+				       struct cfg80211_sched_scan_request *req)
+{
+	struct ieee80211_local *local = sdata->local;
+	int ret;
+
+	mutex_lock(&local->mtx);
+
+	if (rcu_access_pointer(local->sched_scan_sdata)) {
+		mutex_unlock(&local->mtx);
+		return -EBUSY;
+	}
+
+	ret = __ieee80211_request_sched_scan_start(sdata, req);
+
 	mutex_unlock(&local->mtx);
 	return ret;
 }
@@ -1035,6 +1054,9 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 		goto out;
 	}
 
+	/* We don't want to restart sched scan anymore. */
+	local->sched_scan_req = NULL;
+
 	if (rcu_access_pointer(local->sched_scan_sdata))
 		drv_sched_scan_stop(local, sdata);
 
@@ -1069,6 +1091,9 @@ void ieee80211_sched_scan_stopped_work(struct work_struct *work)
 
 	rcu_assign_pointer(local->sched_scan_sdata, NULL);
 
+	/* If sched scan was aborted by the driver. */
+	local->sched_scan_req = NULL;
+
 	mutex_unlock(&local->mtx);
 
 	cfg80211_sched_scan_stopped(local->hw.wiphy);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index adf81f0..591b46b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1462,6 +1462,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	struct sta_info *sta;
 	int res, i;
 	bool reconfig_due_to_wowlan = false;
+	struct ieee80211_sub_if_data *sched_scan_sdata;
+	bool sched_scan_stopped = false;
 
 #ifdef CONFIG_PM
 	if (local->suspended)
@@ -1765,6 +1767,27 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 #else
 	WARN_ON(1);
 #endif
+
+	/*
+	 * Reconfigure sched scan if it was interrupted by FW restart or
+	 * suspend.
+	 */
+	mutex_lock(&local->mtx);
+	sched_scan_sdata = rcu_dereference_protected(local->sched_scan_sdata,
+						lockdep_is_held(&local->mtx));
+	if (sched_scan_sdata && local->sched_scan_req)
+		/*
+		 * Sched scan stopped, but we don't want to report it. Instead,
+		 * we're trying to reschedule.
+		 */
+		if (__ieee80211_request_sched_scan_start(sched_scan_sdata,
+							 local->sched_scan_req))
+			sched_scan_stopped = true;
+	mutex_unlock(&local->mtx);
+
+	if (sched_scan_stopped)
+		cfg80211_sched_scan_stopped(local->hw.wiphy);
+
 	return 0;
 }
 
-- 
1.8.3.2

