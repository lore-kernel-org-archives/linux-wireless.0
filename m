Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab0JFJUu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 05:20:50 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/6] mac80211: reduce number of __ieee80211_scan_completed calls
Date: Wed,  6 Oct 2010 11:22:08 +0200
Message-Id: <1286356933-4076-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use goto instruction to call __ieee80211_scan_completed only ones in
ieee80211_scan_work. This is prepare for the next patch.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/scan.c |   51 +++++++++++++++++++++++++++++----------------------
 1 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 57b5e66..1a115a5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -652,27 +652,25 @@ void ieee80211_scan_work(struct work_struct *work)
 		container_of(work, struct ieee80211_local, scan_work.work);
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 	unsigned long next_delay = 0;
+	bool aborted;
 
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
-	if (!sdata || !local->scan_req) {
-		mutex_unlock(&local->mtx);
-		return;
-	}
+	if (!sdata || !local->scan_req)
+		goto out;
 
 	if (local->hw_scan_req) {
 		int rc = drv_hw_scan(local, sdata, local->hw_scan_req);
-		mutex_unlock(&local->mtx);
-		if (rc)
-			__ieee80211_scan_completed(&local->hw, true);
-		return;
+		if (rc) {
+			aborted = true;
+			goto out_complete;
+		} else
+			goto out;
 	}
 
 	if (local->scan_req && !local->scanning) {
@@ -683,23 +681,23 @@ void ieee80211_scan_work(struct work_struct *work)
 		local->scan_sdata = NULL;
 
 		rc = __ieee80211_start_scan(sdata, req);
-		mutex_unlock(&local->mtx);
-
-		if (rc)
-			__ieee80211_scan_completed(&local->hw, true);
-		return;
+		if (rc) {
+			aborted = true;
+			goto out_complete;
+		} else
+			goto out;
 	}
 
-	mutex_unlock(&local->mtx);
-
 	/*
 	 * Avoid re-scheduling when the sdata is going away.
 	 */
 	if (!ieee80211_sdata_running(sdata)) {
-		__ieee80211_scan_completed(&local->hw, true);
-		return;
+		aborted = true;
+		goto out_complete;
 	}
 
+	mutex_unlock(&local->mtx);
+
 	/*
 	 * as long as no delay is required advance immediately
 	 * without scheduling a new work
@@ -726,6 +724,15 @@ void ieee80211_scan_work(struct work_struct *work)
 	} while (next_delay == 0);
 
 	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, next_delay);
+	return;
+
+out_complete:
+	mutex_unlock(&local->mtx);
+	__ieee80211_scan_completed(&local->hw, aborted);
+	return;
+
+out:
+	mutex_unlock(&local->mtx);
 }
 
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
-- 
1.7.1

