Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1CGNO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 08:14:57 -0500
Subject: Re: WARN_ON in ieee80211_scan_completed_finish triggered
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1299499400.3790.8.camel@jlt3.sipsolutions.net>
References: <1299443142.1292.6.camel@marge>
	 <1299491485.3790.2.camel@jlt3.sipsolutions.net>
	 (sfid-20110307_105130_457515_FFFFFFFF997C7B78)  <1299498147.5665.3.camel@marge>
	 <1299499400.3790.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 14:14:53 +0100
Message-ID: <1299503693.6739.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 13:03 +0100, Johannes Berg wrote:

> Actually ... It just looks like a race:

This should fix the race?

---
 net/mac80211/scan.c |   62 ++++++++++++++++++++--------------------------------
 1 file changed, 24 insertions(+), 38 deletions(-)

--- a/net/mac80211/scan.c	2011-03-07 14:04:40.000000000 +0100
+++ b/net/mac80211/scan.c	2011-03-07 14:12:40.000000000 +0100
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
@@ -295,26 +297,13 @@ static bool __ieee80211_scan_completed(s
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
 
 	WARN_ON(local->scanning & (SCAN_SW_SCANNING | SCAN_HW_SCANNING));
 
-	if (was_hw_scan || !on_oper_chan) {
-		if (WARN_ON(local->scan_channel))
-			local->scan_channel = NULL;
+	if (was_hw_scan || !on_oper_chan)
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-	} else
+	else
 		/* Set power back to normal operating levels. */
 		ieee80211_hw_config(local, 0);
 
@@ -332,7 +321,6 @@ static void __ieee80211_scan_completed_f
 	}
 
 	ieee80211_recalc_idle(local);
-	mutex_unlock(&local->mtx);
 
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
@@ -687,12 +675,14 @@ void ieee80211_scan_work(struct work_str
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
@@ -756,17 +746,11 @@ void ieee80211_scan_work(struct work_str
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
@@ -836,7 +820,6 @@ int ieee80211_request_internal_scan(stru
 void ieee80211_scan_cancel(struct ieee80211_local *local)
 {
 	bool abortscan;
-	bool finish = false;
 
 	/*
 	 * We are only canceling software scan, or deferred scan that was not
@@ -856,14 +839,17 @@ void ieee80211_scan_cancel(struct ieee80
 
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


