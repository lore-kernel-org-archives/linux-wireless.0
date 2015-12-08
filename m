Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24237 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964890AbbLHOGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:06:39 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 8/9] mac80211: run scan completed work on reconfig failure
Date: Tue,  8 Dec 2015 16:04:38 +0200
Message-Id: <1449583479-26658-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151208_150643_405278_2CF39CB5)
In-Reply-To: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When reconfiguration during resume fails while a scan is pending
for completion work, that work will never run, and the scan will
be stuck forever. Factor out the code to recover this and call it
also in ieee80211_handle_reconfig_failure().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4d6130b..1a26ebd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1644,6 +1644,29 @@ void ieee80211_stop_device(struct ieee80211_local *local)
 	drv_stop(local);
 }
 
+static void ieee80211_flush_completed_scan(struct ieee80211_local *local,
+					   bool aborted)
+{
+	/* It's possible that we don't handle the scan completion in
+	 * time during suspend, so if it's still marked as completed
+	 * here, queue the work and flush it to clean things up.
+	 * Instead of calling the worker function directly here, we
+	 * really queue it to avoid potential races with other flows
+	 * scheduling the same work.
+	 */
+	if (test_bit(SCAN_COMPLETED, &local->scanning)) {
+		/* If coming from reconfiguration failure, abort the scan so
+		 * we don't attempt to continue a partial HW scan - which is
+		 * possible otherwise if (e.g.) the 2.4 GHz portion was the
+		 * completed scan, and a 5 GHz portion is still pending.
+		 */
+		if (aborted)
+			set_bit(SCAN_ABORTED, &local->scanning);
+		ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
+		flush_delayed_work(&local->scan_work);
+	}
+}
+
 static void ieee80211_handle_reconfig_failure(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -1663,6 +1686,8 @@ static void ieee80211_handle_reconfig_failure(struct ieee80211_local *local)
 	local->suspended = false;
 	local->in_reconfig = false;
 
+	ieee80211_flush_completed_scan(local, true);
+
 	/* scheduled scan clearly can't be running any more, but tell
 	 * cfg80211 and clear local state
 	 */
@@ -2080,17 +2105,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mb();
 	local->resuming = false;
 
-	/* It's possible that we don't handle the scan completion in
-	 * time during suspend, so if it's still marked as completed
-	 * here, queue the work and flush it to clean things up.
-	 * Instead of calling the worker function directly here, we
-	 * really queue it to avoid potential races with other flows
-	 * scheduling the same work.
-	 */
-	if (test_bit(SCAN_COMPLETED, &local->scanning)) {
-		ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
-		flush_delayed_work(&local->scan_work);
-	}
+	ieee80211_flush_completed_scan(local, false);
 
 	if (local->open_count && !reconfig_due_to_wowlan)
 		drv_reconfig_complete(local, IEEE80211_RECONFIG_TYPE_SUSPEND);
-- 
2.5.0

