Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2704 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab0BBSym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 13:54:42 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] mac80211: fix deferred hardware scan requests
Date: Tue,  2 Feb 2010 10:54:37 -0800
Message-Id: <1265136878-5844-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

mac80211 will defer the handling of scan requests if it is busy
with management work at the time. The scan requests are
deferred and run after the work has completed. When this occurs
there are currently two problems.

* The scan request for hardware scan is not fully populated with
  the band and channels to scan not initialized.
* When the scan is queued the state is not correctly updated to
  reflect that a scan is in progress. The problem here is that when
  the driver completes the scan and calls ieee80211_scan_completed()
  a warning will be triggered since mac80211 was not aware that a scan
  was in progress.

Both issues are fixed here by first ensuring that scan request is fully
initialized before it is queued and next by setting the scanning state
correctly before it is queued for execution.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
* I would like to confirm one change I made in ieee80211_work_work. From
  what I can tell software scanning does not expect the scanning state to
  be set in ieee80211_scan_work, but hardware scanning does. Is this
  correct?

* This is a proposed fix for
  http://bugzilla.kernel.org/show_bug.cgi?id=15119, which is tracked as a
  regression. The user is having some system problems and is not able to
  test it.

* This is an important fix to get in, otherwise wireless will become a top
  performer on kerneloops.org.

 net/mac80211/scan.c |    8 +++++---
 net/mac80211/work.c |    9 ++++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index bc061f6..9cde4a8 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -369,6 +369,9 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	local->scan_req = req;
 	local->scan_sdata = sdata;
 
+	if (local->ops->hw_scan)
+		WARN_ON(!ieee80211_prep_hw_scan(local));
+
 	if (!list_empty(&local->work_list)) {
 		/* wait for the work to finish/time out */
 		return 0;
@@ -392,10 +395,9 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_idle(local);
 	mutex_unlock(&local->scan_mtx);
 
-	if (local->ops->hw_scan) {
-		WARN_ON(!ieee80211_prep_hw_scan(local));
+	if (local->ops->hw_scan)
 		rc = drv_hw_scan(local, local->hw_scan_req);
-	} else
+	else
 		rc = ieee80211_start_sw_scan(local);
 
 	mutex_lock(&local->scan_mtx);
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 7e708d5..e4c3fd4 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -918,10 +918,17 @@ static void ieee80211_work_work(struct work_struct *work)
 		run_again(local, jiffies + HZ/2);
 	}
 
-	if (list_empty(&local->work_list) && local->scan_req)
+	if (list_empty(&local->work_list) && local->scan_req) {
+		if (local->ops->hw_scan)
+			__set_bit(SCAN_HW_SCANNING, &local->scanning);
+		/*
+		 * For software scanning ieee80211_scan_work expects
+		 * to be called without local->scanning set.
+		 */
 		ieee80211_queue_delayed_work(&local->hw,
 					     &local->scan_work,
 					     round_jiffies_relative(0));
+	}
 
 	mutex_unlock(&local->work_mtx);
 
-- 
1.6.3.3

