Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34700 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaDUEzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:55:09 -0400
Received: by mail-pa0-f48.google.com with SMTP id hz1so3337700pad.21
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:55:08 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 06/12] cfg80211: some workqueue improvements
Date: Mon, 21 Apr 2014 12:53:01 +0800
Message-Id: <84aff9f5916be0f5cfaa4f145670d0ee06fcf4bf.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065515_531740_7779E343)
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Works rdev->rfkill_sync and rdev->sched_scan_results_wk are safely
stopped when unregistering wiphy.

Work reg_regdb_work is safely stopped in regulatory_exit(), if related
config option is enabled.

Queue work cfg80211_disconnect_work to workqueue cfg80211_wq, since
it's a work owned by cfg80211, and so it can be safely stopped in
destroy_workqueue(cfg80211_wq) in cfg80211_exit().

Change flush_work() to more robust cancel_work_sync().

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/core.c | 6 ++++--
 net/wireless/reg.c  | 4 ++++
 net/wireless/sme.c  | 2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 33d12e2..f7f71d9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -711,9 +711,11 @@ void wiphy_unregister(struct wiphy *wiphy)
 
 	rtnl_unlock();
 
-	flush_work(&rdev->scan_done_wk);
+	cancel_work_sync(&rdev->rfkill_sync);
+	cancel_work_sync(&rdev->scan_done_wk);
+	cancel_work_sync(&rdev->sched_scan_results_wk);
 	cancel_work_sync(&rdev->conn_work);
-	flush_work(&rdev->event_work);
+	cancel_work_sync(&rdev->event_work);
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
 	flush_work(&rdev->destroy_work);
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9d32633..45b61f0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2765,6 +2765,10 @@ void regulatory_exit(void)
 	cancel_work_sync(&reg_work);
 	cancel_delayed_work_sync(&reg_timeout);
 
+#ifdef CONFIG_CFG80211_INTERNAL_REGDB
+	cancel_work_sync(&reg_regdb_work);
+#endif
+
 	/* Lock to suppress warnings */
 	rtnl_lock();
 	reset_regdomains(true, NULL);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 998674f..0a96d67 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -872,7 +872,7 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 	wdev->wext.connect.ssid_len = 0;
 #endif
 
-	schedule_work(&cfg80211_disconnect_work);
+	queue_work(cfg80211_wq, &cfg80211_disconnect_work);
 }
 
 void cfg80211_disconnected(struct net_device *dev, u16 reason,
-- 
1.9.0

