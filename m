Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7815 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbbJYI77 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 04:59:59 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/10] mac80211: don't reconfigure sched scan in case of wowlan
Date: Sun, 25 Oct 2015 10:59:33 +0200
Message-Id: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_100005_109671_E9CCDC99)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Scheduled scan has to be reconfigured only if wowlan wasn't
configured, since otherwise it should continue to run (with
the 'any' trigger) or be aborted.

The current code will end up asking the driver to start a new
scheduled scan without stopping the previous one, and leaking
some memory (from the previous request.)

Fix this by doing the abort/restart under the proper conditions.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c         |  6 +++---
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/pm.c          | 11 +++++++++++
 net/mac80211/scan.c        | 12 +++++++-----
 net/mac80211/util.c        | 49 ++++++++++++++++++++++------------------------
 5 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 713cdbf..c2bd1b6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2010,12 +2010,12 @@ ieee80211_sched_scan_start(struct wiphy *wiphy,
 static int
 ieee80211_sched_scan_stop(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
 
-	if (!sdata->local->ops->sched_scan_stop)
+	if (!local->ops->sched_scan_stop)
 		return -EOPNOTSUPP;
 
-	return ieee80211_request_sched_scan_stop(sdata);
+	return ieee80211_request_sched_scan_stop(local);
 }
 
 static int ieee80211_auth(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 62f2a97..68680ad 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1573,7 +1573,7 @@ __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 				     struct cfg80211_sched_scan_request *req);
 int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 				       struct cfg80211_sched_scan_request *req);
-int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
+int ieee80211_request_sched_scan_stop(struct ieee80211_local *local);
 void ieee80211_sched_scan_end(struct ieee80211_local *local);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index ad88ad4..00a43a7 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -6,6 +6,13 @@
 #include "driver-ops.h"
 #include "led.h"
 
+static void ieee80211_sched_scan_cancel(struct ieee80211_local *local)
+{
+	if (ieee80211_request_sched_scan_stop(local))
+		return;
+	cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy);
+}
+
 int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -34,6 +41,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		mutex_unlock(&local->sta_mtx);
 	}
 
+	/* keep sched_scan only in case of 'any' trigger */
+	if (!(wowlan && wowlan->any))
+		ieee80211_sched_scan_cancel(local);
+
 	ieee80211_stop_queues_by_reason(hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_SUSPEND,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b64fd2b..4aeca4b 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1140,10 +1140,10 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
-int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
+int ieee80211_request_sched_scan_stop(struct ieee80211_local *local)
 {
-	struct ieee80211_local *local = sdata->local;
-	int ret = 0;
+	struct ieee80211_sub_if_data *sched_scan_sdata;
+	int ret = -ENOENT;
 
 	mutex_lock(&local->mtx);
 
@@ -1155,8 +1155,10 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 	/* We don't want to restart sched scan anymore. */
 	RCU_INIT_POINTER(local->sched_scan_req, NULL);
 
-	if (rcu_access_pointer(local->sched_scan_sdata)) {
-		ret = drv_sched_scan_stop(local, sdata);
+	sched_scan_sdata = rcu_dereference_protected(local->sched_scan_sdata,
+						lockdep_is_held(&local->mtx));
+	if (sched_scan_sdata) {
+		ret = drv_sched_scan_stop(local, sched_scan_sdata);
 		if (!ret)
 			RCU_INIT_POINTER(local->sched_scan_sdata, NULL);
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8274c86..13b07ed 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1996,6 +1996,29 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_enable_keys(sdata);
 
+	/* Reconfigure sched scan if it was interrupted by FW restart */
+	mutex_lock(&local->mtx);
+	sched_scan_sdata = rcu_dereference_protected(local->sched_scan_sdata,
+						lockdep_is_held(&local->mtx));
+	sched_scan_req = rcu_dereference_protected(local->sched_scan_req,
+						lockdep_is_held(&local->mtx));
+	if (sched_scan_sdata && sched_scan_req)
+		/*
+		 * Sched scan stopped, but we don't want to report it. Instead,
+		 * we're trying to reschedule. However, if more than one scan
+		 * plan was set, we cannot reschedule since we don't know which
+		 * scan plan was currently running (and some scan plans may have
+		 * already finished).
+		 */
+		if (sched_scan_req->n_scan_plans > 1 ||
+		    __ieee80211_request_sched_scan_start(sched_scan_sdata,
+							 sched_scan_req))
+			sched_scan_stopped = true;
+	mutex_unlock(&local->mtx);
+
+	if (sched_scan_stopped)
+		cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy);
+
  wake_up:
 	local->in_reconfig = false;
 	barrier();
@@ -2031,32 +2054,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 					false);
 
 	/*
-	 * Reconfigure sched scan if it was interrupted by FW restart or
-	 * suspend.
-	 */
-	mutex_lock(&local->mtx);
-	sched_scan_sdata = rcu_dereference_protected(local->sched_scan_sdata,
-						lockdep_is_held(&local->mtx));
-	sched_scan_req = rcu_dereference_protected(local->sched_scan_req,
-						lockdep_is_held(&local->mtx));
-	if (sched_scan_sdata && sched_scan_req)
-		/*
-		 * Sched scan stopped, but we don't want to report it. Instead,
-		 * we're trying to reschedule. However, if more than one scan
-		 * plan was set, we cannot reschedule since we don't know which
-		 * scan plan was currently running (and some scan plans may have
-		 * already finished).
-		 */
-		if (sched_scan_req->n_scan_plans > 1 ||
-		    __ieee80211_request_sched_scan_start(sched_scan_sdata,
-							 sched_scan_req))
-			sched_scan_stopped = true;
-	mutex_unlock(&local->mtx);
-
-	if (sched_scan_stopped)
-		cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy);
-
-	/*
 	 * If this is for hw restart things are still running.
 	 * We may want to change that later, however.
 	 */
-- 
2.1.4

