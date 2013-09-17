Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3IQFtA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 01:49:00 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC] mac80211: correctly close cancelled scans
Date: Tue, 17 Sep 2013 08:48:38 +0300
Message-Id: <1379396919-11983-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130917_074903_860444_E605037C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

__ieee80211_scan_completed is called from a worker. This
means that the following flow is possible.

 * driver calls ieee80211_scan_completed
 * mac80211 cancels the scan (that is already complete)
 * __ieee80211_scan_complete runs

When scan_work will finally run, it will see that the scan
hasn't been aborted and might even trigger another scan on
another band. This leads to a situation where cfg80211's
scan is not done and no further scan can be issued.

Fix this by setting a new flag when a HW scan is being
cancelled so that no other scan will be triggered.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/scan.c        |   22 +++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d604e16..a523e5a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -893,6 +893,8 @@ struct tpt_led_trigger {
  *	that the scan completed.
  * @SCAN_ABORTED: Set for our scan work function when the driver reported
  *	a scan complete for an aborted scan.
+ * @SCAN_HW_CANCELLED: Set for our scan work function when the scan is being
+ *	cancelled.
  */
 enum {
 	SCAN_SW_SCANNING,
@@ -900,6 +902,7 @@ enum {
 	SCAN_ONCHANNEL_SCANNING,
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
+	SCAN_HW_CANCELLED,
 };
 
 /**
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 08afe74..67f81a4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -238,6 +238,9 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	enum ieee80211_band band;
 	int i, ielen, n_chans;
 
+	if (test_bit(SCAN_HW_CANCELLED, &local->scanning))
+		return false;
+
 	do {
 		if (local->hw_scan_band == IEEE80211_NUM_BANDS)
 			return false;
@@ -940,11 +943,28 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	if (!local->scan_req)
 		goto out;
 
+	/*
+	 * We have a scan running and the driver already reported completion,
+	 * but the worker hasn't run yet or is stuck on the mutex - mark it as
+	 * cancelled.
+	 */
+	if (test_bit(SCAN_HW_SCANNING, &local->scanning) &&
+	    test_bit(SCAN_COMPLETED, &local->scanning)) {
+		set_bit(SCAN_HW_CANCELLED, &local->scanning);
+		goto out;
+	}
+
 	if (test_bit(SCAN_HW_SCANNING, &local->scanning)) {
-		if (local->ops->cancel_hw_scan)
+		/*
+		 * Make sure that __ieee80211_scan_completed doesn't trigger a
+		 * scan on another band.
+		 */
+		set_bit(SCAN_HW_CANCELLED, &local->scanning);
+		if (local->ops->cancel_hw_scan) {
 			drv_cancel_hw_scan(local,
 				rcu_dereference_protected(local->scan_sdata,
 						lockdep_is_held(&local->mtx)));
+		}
 		goto out;
 	}
 
-- 
1.7.10.4

