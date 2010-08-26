Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47490 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0HZLfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 07:35:43 -0400
Message-Id: <20100826113438.523779120@sipsolutions.net>
Date: Thu, 26 Aug 2010 13:30:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: allow scan to complete from any context
References: <20100826113024.738612439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ieee80211_scan_completed() function was a frequent
source of potential deadlocks, since it is called by
drivers but may call back into drivers, so drivers had
to make sure to call it without any locks held, which
frequently lead to more complex code in drivers. Avoid
that problem by allowing the function to be called in
any context, and queueing the actual work it does.
Also update the documentation for it to indicate this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |    3 ++-
 net/mac80211/ieee80211_i.h |    6 ++++++
 net/mac80211/scan.c        |   34 ++++++++++++++++++++++++++--------
 3 files changed, 34 insertions(+), 9 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2010-08-26 13:29:57.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2010-08-26 13:30:01.000000000 +0200
@@ -249,13 +249,11 @@ static bool ieee80211_prep_hw_scan(struc
 	return true;
 }
 
-void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
+static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	bool was_hw_scan;
 
-	trace_api_scan_completed(local, aborted);
-
 	mutex_lock(&local->mtx);
 
 	/*
@@ -313,6 +311,18 @@ void ieee80211_scan_completed(struct iee
 	ieee80211_mesh_notify_scan_completed(local);
 	ieee80211_queue_work(&local->hw, &local->work_work);
 }
+
+void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	trace_api_scan_completed(local, aborted);
+
+	set_bit(SCAN_COMPLETED, &local->scanning);
+	if (aborted)
+		set_bit(SCAN_ABORTED, &local->scanning);
+	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
+}
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
 static int ieee80211_start_sw_scan(struct ieee80211_local *local)
@@ -450,7 +460,7 @@ static int ieee80211_scan_state_decision
 
 	/* if no more bands/channels left, complete scan and advance to the idle state */
 	if (local->scan_channel_idx >= local->scan_req->n_channels) {
-		ieee80211_scan_completed(&local->hw, false);
+		__ieee80211_scan_completed(&local->hw, false);
 		return 1;
 	}
 
@@ -642,6 +652,14 @@ void ieee80211_scan_work(struct work_str
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 	unsigned long next_delay = 0;
 
+	if (test_and_clear_bit(SCAN_COMPLETED, &local->scanning)) {
+		bool aborted;
+
+		aborted = test_and_clear_bit(SCAN_ABORTED, &local->scanning);
+		__ieee80211_scan_completed(&local->hw, aborted);
+		return;
+	}
+
 	mutex_lock(&local->mtx);
 	if (!sdata || !local->scan_req) {
 		mutex_unlock(&local->mtx);
@@ -652,7 +670,7 @@ void ieee80211_scan_work(struct work_str
 		int rc = drv_hw_scan(local, sdata, local->hw_scan_req);
 		mutex_unlock(&local->mtx);
 		if (rc)
-			ieee80211_scan_completed(&local->hw, true);
+			__ieee80211_scan_completed(&local->hw, true);
 		return;
 	}
 
@@ -667,7 +685,7 @@ void ieee80211_scan_work(struct work_str
 		mutex_unlock(&local->mtx);
 
 		if (rc)
-			ieee80211_scan_completed(&local->hw, true);
+			__ieee80211_scan_completed(&local->hw, true);
 		return;
 	}
 
@@ -677,7 +695,7 @@ void ieee80211_scan_work(struct work_str
 	 * Avoid re-scheduling when the sdata is going away.
 	 */
 	if (!ieee80211_sdata_running(sdata)) {
-		ieee80211_scan_completed(&local->hw, true);
+		__ieee80211_scan_completed(&local->hw, true);
 		return;
 	}
 
@@ -784,5 +802,5 @@ void ieee80211_scan_cancel(struct ieee80
 	mutex_unlock(&local->mtx);
 
 	if (abortscan)
-		ieee80211_scan_completed(&local->hw, true);
+		__ieee80211_scan_completed(&local->hw, true);
 }
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-08-26 13:30:00.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-08-26 13:30:01.000000000 +0200
@@ -596,11 +596,17 @@ enum queue_stop_reason {
  *	determine if we are on the operating channel or not
  * @SCAN_OFF_CHANNEL: We're off our operating channel for scanning,
  *	gets only set in conjunction with SCAN_SW_SCANNING
+ * @SCAN_COMPLETED: Set for our scan work function when the driver reported
+ *	that the scan completed.
+ * @SCAN_ABORTED: Set for our scan work function when the driver reported
+ *	a scan complete for an aborted scan.
  */
 enum {
 	SCAN_SW_SCANNING,
 	SCAN_HW_SCANNING,
 	SCAN_OFF_CHANNEL,
+	SCAN_COMPLETED,
+	SCAN_ABORTED,
 };
 
 /**
--- wireless-testing.orig/include/net/mac80211.h	2010-08-26 13:29:58.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-08-26 13:30:01.000000000 +0200
@@ -2268,7 +2268,8 @@ void ieee80211_wake_queues(struct ieee80
  *
  * When hardware scan offload is used (i.e. the hw_scan() callback is
  * assigned) this function needs to be called by the driver to notify
- * mac80211 that the scan finished.
+ * mac80211 that the scan finished. This function can be called from
+ * any context, including hardirq context.
  *
  * @hw: the hardware that finished the scan
  * @aborted: set to true if scan was aborted


