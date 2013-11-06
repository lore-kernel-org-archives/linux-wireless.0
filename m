Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3KFJnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 04:43:17 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliadx.peller@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix scheduled scan rtnl deadlock
Date: Wed,  6 Nov 2013 10:43:13 +0100
Message-Id: <1383730993-18259-1-git-send-email-johannes@sipsolutions.net> (sfid-20131106_104320_884172_2DC34946)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When changing cfg80211 to use RTNL locking, this caused a
deadlock in mac80211 as it calls cfg80211_sched_scan_stopped()
from a work item that's on a workqueue that is flushed with
the RTNL held.

Fix this by simply using schedule_work(), the work only needs
to finish running before the wiphy is unregistered, no other
synchronisation (e.g. with suspend) is really required since
for suspend userspace is already blocked anyway when we flush
the workqueue so will only pick up the event after resume.

Cc: stable@vger.kernel.org
Fixes: 5fe231e87372 ("cfg80211: vastly simplify locking")
Reported-and-tested-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 1 +
 net/mac80211/scan.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 21d5d44..e765f77 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1047,6 +1047,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	cancel_work_sync(&local->restart_work);
 	cancel_work_sync(&local->reconfig_filter);
+	flush_work(&local->sched_scan_stopped_work);
 
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a0b78b1..01fdf20 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1069,6 +1069,6 @@ void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw)
 
 	trace_api_sched_scan_stopped(local);
 
-	ieee80211_queue_work(&local->hw, &local->sched_scan_stopped_work);
+	schedule_work(&local->sched_scan_stopped_work);
 }
 EXPORT_SYMBOL(ieee80211_sched_scan_stopped);
-- 
1.8.4.rc3

