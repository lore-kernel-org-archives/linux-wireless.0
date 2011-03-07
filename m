Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1CGOss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 09:48:48 -0500
Subject: [PATCH] mac80211: fix scan race, simplify code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 15:48:41 +0100
Message-ID: <1299509321.6739.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The scan code has a race that Michael reported
he ran into, but it's easy to fix while at the
same time simplifying the code.

The race resulted in the following warning:

------------[ cut here ]------------
WARNING: at net/mac80211/scan.c:310 ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211]()
Modules linked in: [...]
[<c0033edc>] (unwind_backtrace+0x0/0xe0) from [<c004f2a4>] (warn_slowpath_common+0x4c/0x64)
[... backtrace wasn't useful ...]

Reported-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c |   64 +++++++++++++++++++---------------------------------
 1 file changed, 24 insertions(+), 40 deletions(-)

--- a/net/mac80211/scan.c	2011-03-07 14:04:40.000000000 +0100
+++ b/net/mac80211/scan.c	2011-03-07 14:23:35.000000000 +0100
@@ -259,10 +259,12 @@ static bool ieee80211_prep_hw_scan(struc
 	return true;
 }
 
-static bool __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
+static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 				       bool was_hw_scan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	bool on_oper_chan;
+	bool enable_beacons = false;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -276,12 +278,12 @@ static bool __ieee80211_scan_completed(s
 		aborted = true;
 
 	if (WARN_ON(!local->scan_req))
-		return false;
+		return;
 
 	if (was_hw_scan && !aborted && ieee80211_prep_hw_scan(local)) {
 		int rc = drv_hw_scan(local, local->scan_sdata, local->hw_scan_req);
 		if (rc == 0)
-			return false;
+			return;
 	}
 
 	kfree(local->hw_scan_req);
@@ -295,26 +297,11 @@ static bool __ieee80211_scan_completed(s
 	local->scanning = 0;
 	local->scan_channel = NULL;
 
-	return true;
-}
-
-static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
-					      bool was_hw_scan)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	bool on_oper_chan;
-	bool enable_beacons = false;
-
-	mutex_lock(&local->mtx);
 	on_oper_chan = ieee80211_cfg_on_oper_channel(local);
 
-	WARN_ON(local->scanning & (SCAN_SW_SCANNING | SCAN_HW_SCANNING));
-
-	if (was_hw_scan || !on_oper_chan) {
-		if (WARN_ON(local->scan_channel))
-			local->scan_channel = NULL;
+	if (was_hw_scan || !on_oper_chan)
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-	} else
+	else
 		/* Set power back to normal operating levels. */
 		ieee80211_hw_config(local, 0);
 
@@ -332,7 +319,6 @@ static void __ieee80211_scan_completed_f
 	}
 
 	ieee80211_recalc_idle(local);
-	mutex_unlock(&local->mtx);
 
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
@@ -687,12 +673,14 @@ void ieee80211_scan_work(struct work_str
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, scan_work.work);
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+	struct ieee80211_sub_if_data *sdata;
 	unsigned long next_delay = 0;
-	bool aborted, hw_scan, finish;
+	bool aborted, hw_scan;
 
 	mutex_lock(&local->mtx);
 
+	sdata = local->scan_sdata;
+
 	if (test_and_clear_bit(SCAN_COMPLETED, &local->scanning)) {
 		aborted = test_and_clear_bit(SCAN_ABORTED, &local->scanning);
 		goto out_complete;
@@ -756,17 +744,11 @@ void ieee80211_scan_work(struct work_str
 	} while (next_delay == 0);
 
 	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, next_delay);
-	mutex_unlock(&local->mtx);
-	return;
+	goto out;
 
 out_complete:
 	hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
-	finish = __ieee80211_scan_completed(&local->hw, aborted, hw_scan);
-	mutex_unlock(&local->mtx);
-	if (finish)
-		__ieee80211_scan_completed_finish(&local->hw, hw_scan);
-	return;
-
+	__ieee80211_scan_completed(&local->hw, aborted, hw_scan);
 out:
 	mutex_unlock(&local->mtx);
 }
@@ -836,7 +818,6 @@ int ieee80211_request_internal_scan(stru
 void ieee80211_scan_cancel(struct ieee80211_local *local)
 {
 	bool abortscan;
-	bool finish = false;
 
 	/*
 	 * We are only canceling software scan, or deferred scan that was not
@@ -856,14 +837,17 @@ void ieee80211_scan_cancel(struct ieee80
 
 	mutex_lock(&local->mtx);
 	abortscan = local->scan_req && !test_bit(SCAN_HW_SCANNING, &local->scanning);
-	if (abortscan)
-		finish = __ieee80211_scan_completed(&local->hw, true, false);
-	mutex_unlock(&local->mtx);
-
 	if (abortscan) {
-		/* The scan is canceled, but stop work from being pending */
-		cancel_delayed_work_sync(&local->scan_work);
+		/*
+		 * The scan is canceled, but stop work from being pending.
+		 *
+		 * If the work is currently running, it must be blocked on
+		 * the mutex, but we'll set scan_sdata = NULL and it'll
+		 * simply exit once it acquires the mutex.
+		 */
+		cancel_delayed_work(&local->scan_work);
+		/* and clean up */
+		__ieee80211_scan_completed(&local->hw, true, false);
 	}
-	if (finish)
-		__ieee80211_scan_completed_finish(&local->hw, false);
+	mutex_unlock(&local->mtx);
 }


