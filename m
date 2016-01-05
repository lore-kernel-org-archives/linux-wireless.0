Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5897 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbcAEO2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:28:09 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: handle sched_scan_stopped vs. hw restart race
Date: Tue,  5 Jan 2016 16:28:06 +0200
Message-Id: <1452004086-11480-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160105_152813_210252_FCEDDFF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

On hw restart, mac80211 might try to reconfigure already
stopped sched scan, if ieee80211_sched_scan_stopped_work()
wasn't scheduled yet.

This in turn will keep the device driver with scheduled scan
configured, while both mac80211 and cfg80211 will clear
their sched scan state once the work is scheduled.

Fix it by ignoring ieee80211_sched_scan_stopped() calls
while in hw restart, and flush the work before starting
the reconfiguration.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/main.c | 1 +
 net/mac80211/scan.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ed4c8e6..8190bf2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -248,6 +248,7 @@ static void ieee80211_restart_work(struct work_struct *work)
 
 	/* wait for scan work complete */
 	flush_workqueue(local->workqueue);
+	flush_work(&local->sched_scan_stopped_work);
 
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
 	     "%s called with hardware scan in progress\n", __func__);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a413e52..8eb68ef 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1213,6 +1213,14 @@ void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw)
 
 	trace_api_sched_scan_stopped(local);
 
+	/*
+	 * this shouldn't really happen, so for simplicity
+	 * simply ignore it, and let mac80211 reconfigure
+	 * the sched scan later on.
+	 */
+	if (local->in_reconfig)
+		return;
+
 	schedule_work(&local->sched_scan_stopped_work);
 }
 EXPORT_SYMBOL(ieee80211_sched_scan_stopped);
-- 
2.5.0

