Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36596 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab3ANOWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 09:22:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: call restart complete at wowlan resume time
Date: Mon, 14 Jan 2013 15:22:29 +0100
Message-Id: <1358173349-18398-1-git-send-email-johannes@sipsolutions.net> (sfid-20130114_152208_845146_4878B9DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the driver's resume function can't completely
restore the configuration in the device, it returns
1 from the callback which will be treated like a HW
restart request, but done directly.

In this case, also call the driver's restart_complete()
function so it can finish the reconfiguration there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 4 +++-
 net/mac80211/util.c    | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3af3ab8..cea5c81 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2494,7 +2494,9 @@ enum ieee80211_rate_control_changed {
  *
  * @restart_complete: Called after a call to ieee80211_restart_hw(), when the
  *	reconfiguration has completed. This can help the driver implement the
- *	reconfiguration step. This callback may sleep.
+ *	reconfiguration step. Also called when reconfiguring because the
+ *	driver's resume function returned 1, as this is just like an "inline"
+ *	hardware restart. This callback may sleep.
  *
  * @ipv6_addr_change: IPv6 address assignment on the given interface changed.
  *	Currently, this is only called for managed or P2P client interfaces.
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2ba21e3..622aa1f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1663,10 +1663,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 * If this is for hw restart things are still running.
 	 * We may want to change that later, however.
 	 */
-	if (!local->suspended) {
+	if (!local->suspended || reconfig_due_to_wowlan)
 		drv_restart_complete(local);
+
+	if (!local->suspended)
 		return 0;
-	}
 
 #ifdef CONFIG_PM
 	/* first set suspended false, then resuming */
-- 
1.8.0

