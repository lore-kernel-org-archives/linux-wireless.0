Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32058 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbaLNJKz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2014 04:10:55 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/4] mac80211: avoid reconfig if no interfaces are up
Date: Sun, 14 Dec 2014 11:05:53 +0200
Message-Id: <1418547953-17699-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141214_101112_532629_7CC93D96)
In-Reply-To: <1418547953-17699-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1418547953-17699-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

If there are no interfaces up, there is no reason
to continue the reconfig flow.

The current code might end up calling driver
callbacks (e.g. resume(), reconfig_complete())
while the driver is already stopped.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 974ebe7..0f9bf47 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1735,6 +1735,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	struct cfg80211_sched_scan_request *sched_scan_req;
 	bool sched_scan_stopped = false;
 
+	/* nothing to do if HW shouldn't run */
+	if (!local->open_count)
+		goto wake_up;
+
 #ifdef CONFIG_PM
 	if (local->suspended)
 		local->resuming = true;
@@ -1756,9 +1760,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		reconfig_due_to_wowlan = true;
 	}
 #endif
-	/* everything else happens only if HW was up & running */
-	if (!local->open_count)
-		goto wake_up;
 
 	/*
 	 * Upon resume hardware can sometimes be goofy due to
@@ -2042,7 +2043,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 * If this is for hw restart things are still running.
 	 * We may want to change that later, however.
 	 */
-	if (!local->suspended || reconfig_due_to_wowlan)
+	if (local->open_count && (!local->suspended || reconfig_due_to_wowlan))
 		drv_reconfig_complete(local, IEEE80211_RECONFIG_TYPE_RESTART);
 
 	if (!local->suspended)
@@ -2054,7 +2055,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mb();
 	local->resuming = false;
 
-	if (!reconfig_due_to_wowlan)
+	if (local->open_count && !reconfig_due_to_wowlan)
 		drv_reconfig_complete(local, IEEE80211_RECONFIG_TYPE_SUSPEND);
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
-- 
1.9.1

