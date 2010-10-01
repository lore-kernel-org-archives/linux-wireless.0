Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394Ab0JAMES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 08:04:18 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/6] mac80211: keep lock when calling __ieee80211_scan_completed()
Date: Fri,  1 Oct 2010 14:05:29 +0200
Message-Id: <1285934732-16087-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are taking local->mtx inside __ieee80211_scan_completed(), but just
before call to that function we drop the lock. Dropping/taking lock is not
good, because can lead to hard to understand race conditions.

Patch split scan_completed() code into two functions, first must be called
with local->mtx taken and second without it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/scan.c |   85 +++++++++++++++++++++++++++------------------------
 1 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index e9ab896..44deb05 100644
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
 
@@ -432,7 +432,6 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		local->scan_req = NULL;
 		local->scan_sdata = NULL;
 	}
-
 	return rc;
 }
 
@@ -448,8 +447,8 @@ ieee80211_scan_get_channel_time(struct ieee80211_channel *chan)
 	return IEEE80211_PROBE_DELAY + IEEE80211_CHANNEL_TIME;
 }
 
-static int ieee80211_scan_state_decision(struct ieee80211_local *local,
-					 unsigned long *next_delay)
+static void ieee80211_scan_state_decision(struct ieee80211_local *local,
+					  unsigned long *next_delay)
 {
 	bool associated = false;
 	bool tx_empty = true;
@@ -459,12 +458,6 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
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
@@ -536,7 +529,6 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 	}
 
 	*next_delay = 0;
-	return 0;
 }
 
 static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
@@ -654,6 +646,7 @@ void ieee80211_scan_work(struct work_struct *work)
 	unsigned long next_delay = 0;
 	int rc = 1;
 	bool aborted = true;
+	bool finish, hw_scan;
 
 	mutex_lock(&local->mtx);
 
@@ -697,8 +690,12 @@ void ieee80211_scan_work(struct work_struct *work)
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
@@ -719,9 +716,16 @@ void ieee80211_scan_work(struct work_struct *work)
 	return;
 
 out_complete:
+	finish = false;
+	if (rc) {
+		hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
+		finish = __ieee80211_scan_completed(&local->hw, aborted, hw_scan);
+	}
+
 	mutex_unlock(&local->mtx);
-	if (rc)
-		__ieee80211_scan_completed(&local->hw, true);
+
+	if (finish)
+		__ieee80211_scan_completed_finish(&local->hw, hw_scan);
 }
 
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
@@ -785,7 +789,7 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_scan_cancel(struct ieee80211_local *local)
 {
-	bool abortscan;
+	bool finish = false;
 
 	cancel_delayed_work_sync(&local->scan_work);
 
@@ -794,10 +798,11 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	 * queued -- mostly at suspend under RTNL.
 	 */
 	mutex_lock(&local->mtx);
-	abortscan = test_bit(SCAN_SW_SCANNING, &local->scanning) ||
-		    (!local->scanning && local->scan_req);
+	if (test_bit(SCAN_SW_SCANNING, &local->scanning) ||
+	    (!local->scanning && local->scan_req))
+		finish = __ieee80211_scan_completed(&local->hw, true, false);
 	mutex_unlock(&local->mtx);
 
-	if (abortscan)
-		__ieee80211_scan_completed(&local->hw, true);
+	if (finish)
+		__ieee80211_scan_completed_finish(&local->hw, false);
 }
-- 
1.7.1

