Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23976 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaBKK30 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 05:29:26 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Subject: [PATCH] mac80211: fix sched_scan restart on recovery
Date: Tue, 11 Feb 2014 12:27:19 +0200
Message-Id: <1392114439-26492-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140211_112942_973947_9F6330D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

In case we were not suspended, the reconfig function returns without
configuring the scheduled scan.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 net/mac80211/util.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 38813ed..13892ce 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1769,6 +1769,26 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
 	/*
+	 * Reconfigure sched scan if it was interrupted by FW restart or
+	 * suspend.
+	 */
+	mutex_lock(&local->mtx);
+	sched_scan_sdata = rcu_dereference_protected(local->sched_scan_sdata,
+						lockdep_is_held(&local->mtx));
+	if (sched_scan_sdata && local->sched_scan_req)
+		/*
+		 * Sched scan stopped, but we don't want to report it. Instead,
+		 * we're trying to reschedule.
+		 */
+		if (__ieee80211_request_sched_scan_start(sched_scan_sdata,
+							 local->sched_scan_req))
+			sched_scan_stopped = true;
+	mutex_unlock(&local->mtx);
+
+	if (sched_scan_stopped)
+		cfg80211_sched_scan_stopped(local->hw.wiphy);
+
+	/*
 	 * If this is for hw restart things are still running.
 	 * We may want to change that later, however.
 	 */
@@ -1796,26 +1816,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	WARN_ON(1);
 #endif
 
-	/*
-	 * Reconfigure sched scan if it was interrupted by FW restart or
-	 * suspend.
-	 */
-	mutex_lock(&local->mtx);
-	sched_scan_sdata = rcu_dereference_protected(local->sched_scan_sdata,
-						lockdep_is_held(&local->mtx));
-	if (sched_scan_sdata && local->sched_scan_req)
-		/*
-		 * Sched scan stopped, but we don't want to report it. Instead,
-		 * we're trying to reschedule.
-		 */
-		if (__ieee80211_request_sched_scan_start(sched_scan_sdata,
-							 local->sched_scan_req))
-			sched_scan_stopped = true;
-	mutex_unlock(&local->mtx);
-
-	if (sched_scan_stopped)
-		cfg80211_sched_scan_stopped(local->hw.wiphy);
-
 	return 0;
 }
 
-- 
1.8.3.2

