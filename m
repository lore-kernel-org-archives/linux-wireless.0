Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251Ab0JAMEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 08:04:34 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/6] mac80211: merge ieee80211_scan_work() common code
Date: Fri,  1 Oct 2010 14:05:28 +0200
Message-Id: <1285934732-16087-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge common code using goto instruction. Except less LOC, one of
the benefit is decrease number of places where function
ieee80211_scan_completed() is called.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/scan.c |   40 ++++++++++++++++++----------------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 57b5e66..e9ab896 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -652,53 +652,43 @@ void ieee80211_scan_work(struct work_struct *work)
 		container_of(work, struct ieee80211_local, scan_work.work);
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 	unsigned long next_delay = 0;
+	int rc = 1;
+	bool aborted = true;
 
-	if (test_and_clear_bit(SCAN_COMPLETED, &local->scanning)) {
-		bool aborted;
+	mutex_lock(&local->mtx);
 
+	if (test_and_clear_bit(SCAN_COMPLETED, &local->scanning)) {
 		aborted = test_and_clear_bit(SCAN_ABORTED, &local->scanning);
-		__ieee80211_scan_completed(&local->hw, aborted);
-		return;
+		goto out_complete;
 	}
 
-	mutex_lock(&local->mtx);
 	if (!sdata || !local->scan_req) {
 		mutex_unlock(&local->mtx);
 		return;
 	}
 
 	if (local->hw_scan_req) {
-		int rc = drv_hw_scan(local, sdata, local->hw_scan_req);
-		mutex_unlock(&local->mtx);
-		if (rc)
-			__ieee80211_scan_completed(&local->hw, true);
-		return;
+		rc = drv_hw_scan(local, sdata, local->hw_scan_req);
+		goto out_complete;
 	}
 
 	if (local->scan_req && !local->scanning) {
 		struct cfg80211_scan_request *req = local->scan_req;
-		int rc;
 
 		local->scan_req = NULL;
 		local->scan_sdata = NULL;
 
 		rc = __ieee80211_start_scan(sdata, req);
-		mutex_unlock(&local->mtx);
-
-		if (rc)
-			__ieee80211_scan_completed(&local->hw, true);
-		return;
+		goto out_complete;
 	}
 
-	mutex_unlock(&local->mtx);
-
 	/*
 	 * Avoid re-scheduling when the sdata is going away.
 	 */
-	if (!ieee80211_sdata_running(sdata)) {
-		__ieee80211_scan_completed(&local->hw, true);
-		return;
-	}
+	if (!ieee80211_sdata_running(sdata))
+		goto out_complete;
+
+	mutex_unlock(&local->mtx);
 
 	/*
 	 * as long as no delay is required advance immediately
@@ -726,6 +716,12 @@ void ieee80211_scan_work(struct work_struct *work)
 	} while (next_delay == 0);
 
 	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, next_delay);
+	return;
+
+out_complete:
+	mutex_unlock(&local->mtx);
+	if (rc)
+		__ieee80211_scan_completed(&local->hw, true);
 }
 
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
-- 
1.7.1

