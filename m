Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371Ab0JFJVD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 05:21:03 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/6] mac80211: assure we also cancel deferred scan request
Date: Wed,  6 Oct 2010 11:22:10 +0200
Message-Id: <1286356933-4076-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1286356933-4076-1-git-send-email-sgruszka@redhat.com>
References: <1286356933-4076-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is partial revert and fix for commit
85f72bc839705294b32b6c16b491c0422f0a71b3 "mac80211: only cancel
software-based scans on suspend"

When cfg80211 request the scan and mac80211 perform some management work,
we defer the scan request. We do not canceling such requests when calling
ieee80211_scan_cancel(), because of SCAN_SW_SCANNING bit check just
before the call. So fix that problem.

Another problem, which commit 85f72bc839705294b32b6c16b491c0422f0a71b3
tries to solve, is we can not cancel HW scan. Hence patch make
ieee80211_scan_cancel() ignore HW scan (see code comments). Keeping
local->mtx lock assures that the deferred scan will not become
"working" HW scan.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/main.c |    3 +--
 net/mac80211/pm.c   |    3 +--
 net/mac80211/scan.c |   35 +++++++++++++++++++++++++----------
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 494dba1..8ba09ff 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -304,8 +304,7 @@ static void ieee80211_restart_work(struct work_struct *work)
 	mutex_unlock(&local->mtx);
 
 	rtnl_lock();
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)))
-		ieee80211_scan_cancel(local);
+	ieee80211_scan_cancel(local);
 	ieee80211_reconfig(local);
 	rtnl_unlock();
 }
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index ce671df..d287fde 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -12,8 +12,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)))
-		ieee80211_scan_cancel(local);
+	ieee80211_scan_cancel(local);
 
 	ieee80211_stop_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 5bb2254..d35003a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -794,24 +794,39 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
+/*
+ * Only call this function when a scan can't be queued -- under RTNL.
+ */
 void ieee80211_scan_cancel(struct ieee80211_local *local)
 {
-	bool abortscan;
-	bool finish = false;
-
-	cancel_delayed_work_sync(&local->scan_work);
+	bool abortscan, finish;
 
 	/*
-	 * Only call this function when a scan can't be
-	 * queued -- mostly at suspend under RTNL.
+	 * We are only canceling software scan, or deferred scan that was not
+	 * yet really started (see __ieee80211_start_scan ).
+	 *
+	 * Regarding hardware scan:
+	 * - we can not call  __ieee80211_scan_completed() as when
+	 *   SCAN_HW_SCANNING bit is set this function change
+	 *   local->hw_scan_req to operate on 5G band, what race with
+	 *   driver which can use local->hw_scan_req
+	 *
+	 * - we can not cancel scan_work since driver can schedule it
+	 *   by ieee80211_scan_completed(..., true) to finish scan
+	 *
+	 * Hence low lever driver is responsible for canceling HW scan.
 	 */
+
 	mutex_lock(&local->mtx);
-	abortscan = test_bit(SCAN_SW_SCANNING, &local->scanning) ||
-		    (!local->scanning && local->scan_req);
+	abortscan = local->scan_req && !test_bit(SCAN_HW_SCANNING, &local->scanning);
 	if (abortscan)
 		finish = __ieee80211_scan_completed(&local->hw, true, false);
 	mutex_unlock(&local->mtx);
 
-	if (finish)
-		__ieee80211_scan_completed_finish(&local->hw, false);
+	if (abortscan) {
+		/* The scan is canceled, but stop work from being pending */
+		cancel_delayed_work_sync(&local->scan_work);
+		if (finish)
+			__ieee80211_scan_completed_finish(&local->hw, false);
+	}
 }
-- 
1.7.1

