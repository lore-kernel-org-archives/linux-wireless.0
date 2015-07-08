Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58373 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607AbbGHMmL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 08:42:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/10] mac80211: clear local->suspended before calling drv_resume()
Date: Wed,  8 Jul 2015 15:41:47 +0300
Message-Id: <1436359312-26533-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144255_488596_A0AA8758)
In-Reply-To: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Currently, mac80211 calls drv_resume() on wowlan resume,
but drops any incoming frame until local->suspended is
cleared later on.

This requires the low-level driver to support a new state,
in which it is expected to fully work (as it was resumed)
but not passing rx frames yet (as they will be dropped).

iwlwifi (and probably other drivers as well) has issues
supporting such mode.

Since in the wowlan case we already short-circuit
ieee80211_reconfig, there's nothing that prevents us from
clearing local->suspend before calling drv_resume(),
and letting the low-level driver work normally.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e54596f9..1104421 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1716,16 +1716,24 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sched_scan_sdata;
 	struct cfg80211_sched_scan_request *sched_scan_req;
 	bool sched_scan_stopped = false;
+	bool suspended = local->suspended;
 
 	/* nothing to do if HW shouldn't run */
 	if (!local->open_count)
 		goto wake_up;
 
 #ifdef CONFIG_PM
-	if (local->suspended)
+	if (suspended)
 		local->resuming = true;
 
 	if (local->wowlan) {
+		/*
+		 * In the wowlan case, both mac80211 and the device
+		 * are functional when the resume op is called, so
+		 * clear local->suspended so the device could operate
+		 * normally (e.g. pass rx frames).
+		 */
+		local->suspended = false;
 		res = drv_resume(local);
 		local->wowlan = false;
 		if (res < 0) {
@@ -1738,8 +1746,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		/*
 		 * res is 1, which means the driver requested
 		 * to go through a regular reset on wakeup.
+		 * restore local->suspended in this case.
 		 */
 		reconfig_due_to_wowlan = true;
+		local->suspended = true;
 	}
 #endif
 
@@ -1751,7 +1761,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 */
 	res = drv_start(local);
 	if (res) {
-		if (local->suspended)
+		if (suspended)
 			WARN(1, "Hardware became unavailable upon resume. This could be a software issue prior to suspend or a hardware issue.\n");
 		else
 			WARN(1, "Hardware became unavailable during restart.\n");
@@ -2045,10 +2055,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 * If this is for hw restart things are still running.
 	 * We may want to change that later, however.
 	 */
-	if (local->open_count && (!local->suspended || reconfig_due_to_wowlan))
+	if (local->open_count && (!suspended || reconfig_due_to_wowlan))
 		drv_reconfig_complete(local, IEEE80211_RECONFIG_TYPE_RESTART);
 
-	if (!local->suspended)
+	if (!suspended)
 		return 0;
 
 #ifdef CONFIG_PM
-- 
2.1.4

