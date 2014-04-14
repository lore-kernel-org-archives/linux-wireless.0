Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59166 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaDNJvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 05:51:54 -0400
Received: by mail-pa0-f42.google.com with SMTP id fb1so8115108pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 02:51:53 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/6] cfg80211: some workqueue improvements
Date: Mon, 14 Apr 2014 17:51:30 +0800
Message-Id: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com> (sfid-20140414_115401_907956_AE7DA262)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rdev->rfkill_sync and rdev->sched_scan_results_wk works are canceled
when unregistering wiphy.

Reg_regdb_work is canceled in regulatory_exit(), if related config
option is enabled.

Queue cfg80211_disconnect_work to cfg80211_wq, since it's a work used
by cfg80211.

Change flush_work() to more robust cancel_work_sync().

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/core.c | 6 ++++--
 net/wireless/reg.c  | 4 ++++
 net/wireless/sme.c  | 2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 276cf93..68a027c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -671,9 +671,11 @@ void wiphy_unregister(struct wiphy *wiphy)
 
 	rtnl_unlock();
 
-	flush_work(&rdev->scan_done_wk);
+	cancel_work_sync(&rdev->rfkill_sync);
+	cancel_work_sync(&rdev->scan_done_wk);
+	cancel_work_sync(&rdev->sched_scan_results_wk);
 	cancel_work_sync(&rdev->conn_work);
-	flush_work(&rdev->event_work);
+	cancel_work_sync(&rdev->event_work);
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
 
 #ifdef CONFIG_PM
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f59aaac..12d3194 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2666,6 +2666,10 @@ void regulatory_exit(void)
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
index acdcb4a8..11b2779 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -873,7 +873,7 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 	wdev->wext.connect.ssid_len = 0;
 #endif
 
-	schedule_work(&cfg80211_disconnect_work);
+	queue_work(cfg80211_wq, &cfg80211_disconnect_work);
 }
 
 void cfg80211_disconnected(struct net_device *dev, u16 reason,
-- 
1.9.0

