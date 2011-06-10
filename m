Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51088 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1FJHpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 03:45:18 -0400
Received: by wwk4 with SMTP id 4so498117wwk.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 00:45:17 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: add cancel_hw_scan() callback
Date: Fri, 10 Jun 2011 10:45:52 +0300
Message-Id: <1307691952-10980-1-git-send-email-eliad@wizery.com> (sfid-20110610_094522_790829_9093B713)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When suspending, __ieee80211_suspend() calls ieee80211_scan_cancel(),
which will only cancel sw scan. In order to cancel hw scan, the
low-level driver has to cancel it in the suspend() callback. however,
this is too late, as a new scan_work will be enqueued (while the driver
is going into suspend).

Add a new cancel_hw_scan() callback, asking the driver to cancel an
active hw scan, and call it in ieee80211_scan_cancel().

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/net/mac80211.h      |   10 ++++++++++
 net/mac80211/driver-ops.h   |   13 +++++++++++++
 net/mac80211/driver-trace.h |    6 ++++++
 net/mac80211/scan.c         |   33 +++++++++++++++++++--------------
 4 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8c7189c..91c42c6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1708,6 +1708,14 @@ enum ieee80211_ampdu_mlme_action {
  *	any error unless this callback returned a negative error code.
  *	The callback can sleep.
  *
+ * @cancel_hw_scan: Ask the low-level tp cancel the active hw scan.
+ *	The driver should ask the hardware to cancel the scan (if possible),
+ *	but the scan will be completed only after the driver will call
+ *	ieee80211_scan_completed().
+ *	This callback is needed for wowlan, to prevent enqueueing a new
+ *	scan_work after the low-level driver was already suspended.
+ *	The callback can sleep.
+ *
  * @sched_scan_start: Ask the hardware to start scanning repeatedly at
  *	specific intervals.  The driver must call the
  *	ieee80211_sched_scan_results() function whenever it finds results.
@@ -1899,6 +1907,8 @@ struct ieee80211_ops {
 				u32 iv32, u16 *phase1key);
 	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct cfg80211_scan_request *req);
+	int (*cancel_hw_scan)(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif);
 	int (*sched_scan_start)(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct cfg80211_sched_scan_request *req,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index eebf7a6..7b94058 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -218,6 +218,19 @@ static inline int drv_hw_scan(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_cancel_hw_scan(struct ieee80211_local *local,
+				     struct ieee80211_sub_if_data *sdata)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_cancel_hw_scan(local, sdata);
+	ret = local->ops->cancel_hw_scan(&local->hw, &sdata->vif);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int
 drv_sched_scan_start(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index ed9edcb..3cb6795 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -460,6 +460,12 @@ DEFINE_EVENT(local_sdata_evt, drv_hw_scan,
 	TP_ARGS(local, sdata)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_cancel_hw_scan,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
+);
+
 DEFINE_EVENT(local_sdata_evt, drv_sched_scan_start,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 27af672..65eaae0 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -822,8 +822,6 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
  */
 void ieee80211_scan_cancel(struct ieee80211_local *local)
 {
-	bool abortscan;
-
 	/*
 	 * We are only canceling software scan, or deferred scan that was not
 	 * yet really started (see __ieee80211_start_scan ).
@@ -841,19 +839,26 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	 */
 
 	mutex_lock(&local->mtx);
-	abortscan = local->scan_req && !test_bit(SCAN_HW_SCANNING, &local->scanning);
-	if (abortscan) {
-		/*
-		 * The scan is canceled, but stop work from being pending.
-		 *
-		 * If the work is currently running, it must be blocked on
-		 * the mutex, but we'll set scan_sdata = NULL and it'll
-		 * simply exit once it acquires the mutex.
-		 */
-		cancel_delayed_work(&local->scan_work);
-		/* and clean up */
-		__ieee80211_scan_completed(&local->hw, true, false);
+	if (!local->scan_req)
+		goto out;
+
+	if (test_bit(SCAN_HW_SCANNING, &local->scanning)) {
+		if (local->ops->cancel_hw_scan)
+			drv_cancel_hw_scan(local, local->scan_sdata);
+		goto out;
 	}
+
+	/*
+	 * The scan is canceled, but stop work from being pending.
+	 *
+	 * If the work is currently running, it must be blocked on
+	 * the mutex, but we'll set scan_sdata = NULL and it'll
+	 * simply exit once it acquires the mutex.
+	 */
+	cancel_delayed_work(&local->scan_work);
+	/* and clean up */
+	__ieee80211_scan_completed(&local->hw, true, false);
+out:
 	mutex_unlock(&local->mtx);
 }
 
-- 
1.7.0.4

