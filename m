Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42960 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab1FPIsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 04:48:37 -0400
Received: by wya21 with SMTP id 21so867645wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2011 01:48:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: quiesce vif before suspending
Date: Thu, 16 Jun 2011 11:49:33 +0300
Message-Id: <1308214173-26950-1-git-send-email-eliad@wizery.com> (sfid-20110616_104841_327527_D531BBF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cancel all relevant timers/works before suspending (wowlan).

This patch handles the following warning:
WARNING: at net/mac80211/util.c:565 queueing ieee80211 work while going to suspend
Backtrace:
[<bf07b598>] (ieee80211_can_queue_work+0x0/0x4c [mac80211])
[<bf07c28c>] (ieee80211_queue_work+0x0/0x30 [mac80211])
[<bf0690dc>] (ieee80211_sta_timer+0x0/0x3c [mac80211])
[<c00a3008>] (run_timer_softirq+0x0/0x220)
[<c009e530>] (__do_softirq+0x0/0x130)
[<c009e660>] (irq_exit+0x0/0xb4)
[<c004c4a0>] (ipi_timer+0x0/0x4c)
[<c0046350>] (do_local_timer+0x0/0x88)
[<c00488ec>] (cpu_idle+0x0/0xe0)
[<c05294e8>] (rest_init+0x0/0xe0)
[<c0008958>] (start_kernel+0x0/0x314)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/pm.c |   43 +++++++++++++++++++++++++++----------------
 1 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 730778a..67839eb 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -6,6 +6,28 @@
 #include "driver-ops.h"
 #include "led.h"
 
+/* return value indicates whether the driver should be further notified */
+static bool ieee80211_quiesce(struct ieee80211_sub_if_data *sdata)
+{
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		ieee80211_sta_quiesce(sdata);
+		return true;
+	case NL80211_IFTYPE_ADHOC:
+		ieee80211_ibss_quiesce(sdata);
+		return true;
+	case NL80211_IFTYPE_MESH_POINT:
+		ieee80211_mesh_quiesce(sdata);
+		return true;
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_MONITOR:
+		/* don't tell driver about this */
+		return false;
+	default:
+		return true;
+	}
+}
+
 int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -54,6 +76,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			local->quiescing = false;
 			return err;
 		}
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			cancel_work_sync(&sdata->work);
+			ieee80211_quiesce(sdata);
+		}
 		goto suspend;
 	}
 
@@ -82,23 +108,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		cancel_work_sync(&sdata->work);
 
-		switch(sdata->vif.type) {
-		case NL80211_IFTYPE_STATION:
-			ieee80211_sta_quiesce(sdata);
-			break;
-		case NL80211_IFTYPE_ADHOC:
-			ieee80211_ibss_quiesce(sdata);
-			break;
-		case NL80211_IFTYPE_MESH_POINT:
-			ieee80211_mesh_quiesce(sdata);
-			break;
-		case NL80211_IFTYPE_AP_VLAN:
-		case NL80211_IFTYPE_MONITOR:
-			/* don't tell driver about this */
+		if (!ieee80211_quiesce(sdata))
 			continue;
-		default:
-			break;
-		}
 
 		if (!ieee80211_sdata_running(sdata))
 			continue;
-- 
1.7.0.4

