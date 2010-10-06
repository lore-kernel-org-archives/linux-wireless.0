Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab0JFJUz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 05:20:55 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/6] mac80211: keep lock when calling __ieee80211_scan_completed()
Date: Wed,  6 Oct 2010 11:22:09 +0200
Message-Id: <1286356933-4076-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1286356933-4076-1-git-send-email-sgruszka@redhat.com>
References: <1286356933-4076-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are taking local->mtx inside __ieee80211_scan_completed(), but just
before call to that function we drop the lock. Dropping/taking lock is not
good, because can lead to hard to understand race conditions.

Patch split scan_completed() code into two functions, first must be called
with local->mtx taken and second without it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/scan.c |   75 ++++++++++++++++++++++++++------------------------
 1 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 1a115a5..5bb2254 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -250,12 +250,12 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	return true;
 }
 
-static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
+static bool __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
+				       bool was_hw_scan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	bool was_hw_scan;
 
-	mutex_lock(&local->mtx);
+	lockdep_assert_held(&local->mtx);
 
 	/*
 	 * It's ok to abort a not-yet-running scan (that
@@ -266,17 +266,13 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	if (WARN_ON(!local->scanning && !aborted))
 		aborted = true;
 
-	if (WARN_ON(!local->scan_req)) {
-		mutex_unlock(&local->mtx);
-		return;
-	}
+	if (WARN_ON(!local->scan_req))
+		return false;
 
-	was_hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
 	if (was_hw_scan && !aborted && ieee80211_prep_hw_scan(local)) {
 		ieee80211_queue_delayed_work(&local->hw,
 					     &local->scan_work, 0);
-		mutex_unlock(&local->mtx);
-		return;
+		return false;
 	}
 
 	kfree(local->hw_scan_req);
@@ -290,23 +286,25 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	local->scanning = 0;
 	local->scan_channel = NULL;
 
-	/* we only have to protect scan_req and hw/sw scan */
-	mutex_unlock(&local->mtx);
-
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-	if (was_hw_scan)
-		goto done;
-
-	ieee80211_configure_filter(local);
+	return true;
+}
 
-	drv_sw_scan_complete(local);
+static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
+					      bool was_hw_scan)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
 
-	ieee80211_offchannel_return(local, true);
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	if (!was_hw_scan) {
+		ieee80211_configure_filter(local);
+		drv_sw_scan_complete(local);
+		ieee80211_offchannel_return(local, true);
+	}
 
- done:
 	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
 	mutex_unlock(&local->mtx);
+
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
 	ieee80211_mesh_notify_scan_completed(local);
@@ -367,6 +365,8 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	int rc;
 
+	lockdep_assert_held(&local->mtx);
+
 	if (local->scan_req)
 		return -EBUSY;
 
@@ -448,8 +448,8 @@ ieee80211_scan_get_channel_time(struct ieee80211_channel *chan)
 	return IEEE80211_PROBE_DELAY + IEEE80211_CHANNEL_TIME;
 }
 
-static int ieee80211_scan_state_decision(struct ieee80211_local *local,
-					 unsigned long *next_delay)
+static void ieee80211_scan_state_decision(struct ieee80211_local *local,
+					  unsigned long *next_delay)
 {
 	bool associated = false;
 	bool tx_empty = true;
@@ -459,12 +459,6 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_channel *next_chan;
 
-	/* if no more bands/channels left, complete scan and advance to the idle state */
-	if (local->scan_channel_idx >= local->scan_req->n_channels) {
-		__ieee80211_scan_completed(&local->hw, false);
-		return 1;
-	}
-
 	/*
 	 * check if at least one STA interface is associated,
 	 * check if at least one STA interface has pending tx frames
@@ -536,7 +530,6 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 	}
 
 	*next_delay = 0;
-	return 0;
 }
 
 static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
@@ -652,7 +645,7 @@ void ieee80211_scan_work(struct work_struct *work)
 		container_of(work, struct ieee80211_local, scan_work.work);
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 	unsigned long next_delay = 0;
-	bool aborted;
+	bool aborted, hw_scan, finish;
 
 	mutex_lock(&local->mtx);
 
@@ -705,8 +698,12 @@ void ieee80211_scan_work(struct work_struct *work)
 	do {
 		switch (local->next_scan_state) {
 		case SCAN_DECISION:
-			if (ieee80211_scan_state_decision(local, &next_delay))
-				return;
+			/* if no more bands/channels left, complete scan */
+			if (local->scan_channel_idx >= local->scan_req->n_channels) {
+				aborted = false;
+				goto out_complete;
+			}
+			ieee80211_scan_state_decision(local, &next_delay);
 			break;
 		case SCAN_SET_CHANNEL:
 			ieee80211_scan_state_set_channel(local, &next_delay);
@@ -727,8 +724,11 @@ void ieee80211_scan_work(struct work_struct *work)
 	return;
 
 out_complete:
+	hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
+	finish = __ieee80211_scan_completed(&local->hw, aborted, hw_scan);
 	mutex_unlock(&local->mtx);
-	__ieee80211_scan_completed(&local->hw, aborted);
+	if (finish)
+		__ieee80211_scan_completed_finish(&local->hw, hw_scan);
 	return;
 
 out:
@@ -797,6 +797,7 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
 void ieee80211_scan_cancel(struct ieee80211_local *local)
 {
 	bool abortscan;
+	bool finish = false;
 
 	cancel_delayed_work_sync(&local->scan_work);
 
@@ -807,8 +808,10 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	mutex_lock(&local->mtx);
 	abortscan = test_bit(SCAN_SW_SCANNING, &local->scanning) ||
 		    (!local->scanning && local->scan_req);
+	if (abortscan)
+		finish = __ieee80211_scan_completed(&local->hw, true, false);
 	mutex_unlock(&local->mtx);
 
-	if (abortscan)
-		__ieee80211_scan_completed(&local->hw, true);
+	if (finish)
+		__ieee80211_scan_completed_finish(&local->hw, false);
 }
-- 
1.7.1

