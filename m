Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab0JAMER (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 08:04:17 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/6] mac80211: perform scan cancel in hw reset work
Date: Fri,  1 Oct 2010 14:05:27 +0200
Message-Id: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move ieee80211_scan_cancel() and all other related code to
ieee80211_restart_work() as ieee80211_restart_hw() is intended to be
callable from any context.

Fix a bug that RTNL lock is not taken during ieee80211_cancel_scan().

Take local->mtx before WARN(test_bit(SCAN_HW_SCANNING, &local->scanning)
to prevent the race condition with __ieee80211_start_scan() described
here: http://marc.info/?l=linux-wireless&m=128516716810537&w=2

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/main.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e24fa5b..494dba1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -295,7 +295,17 @@ static void ieee80211_restart_work(struct work_struct *work)
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, restart_work);
 
+	/* wait for scan work complete */
+	flush_workqueue(local->workqueue);
+
+	mutex_lock(&local->mtx);
+	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
+		"%s called with hardware scan in progress\n", __func__);
+	mutex_unlock(&local->mtx);
+
 	rtnl_lock();
+	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)))
+		ieee80211_scan_cancel(local);
 	ieee80211_reconfig(local);
 	rtnl_unlock();
 }
@@ -306,15 +316,6 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
 
 	trace_api_restart_hw(local);
 
-	/* wait for scan work complete */
-	flush_workqueue(local->workqueue);
-
-	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
-		"%s called with hardware scan in progress\n", __func__);
-
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)))
-		ieee80211_scan_cancel(local);
-
 	/* use this reason, ieee80211_reconfig will unblock it */
 	ieee80211_stop_queues_by_reason(hw,
 		IEEE80211_QUEUE_STOP_REASON_SUSPEND);
-- 
1.7.1

