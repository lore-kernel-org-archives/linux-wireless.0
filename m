Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45319 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab1CAUgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:36:52 -0500
Received: by wwb22 with SMTP id 22so4952627wwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:36:50 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 4/9] mac80211: don't remove/add interfaces when WoW is enabled
Date: Tue,  1 Mar 2011 22:36:39 +0200
Message-Id: <1299011804-13899-5-git-send-email-eliad@wizery.com>
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When WoW triggers are enabled, we shouldn't remove the interfaces
on suspend, as we need them in order to get the triggers.
Consequently, we shouldn't add them back when resuming.

TODO:
what settings should we configure when going to WoW (ps,
rx_filtering, etc.)?
whose responsibility is it - the mac80211 or the lower driver?
(the lower driver may implement some features that are not known
to the mac80211)
should they be configurable by the user?

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/pm.c   |   63 +++++++++++++++++++++++++++---------------------
 net/mac80211/util.c |   66 +++++++++++++++++++++++++++++++--------------------
 2 files changed, 76 insertions(+), 53 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 6d135ea..f687606 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -6,36 +6,11 @@
 #include "driver-ops.h"
 #include "led.h"
 
-int __ieee80211_suspend(struct ieee80211_hw *hw,
-			struct cfg80211_wow *wow)
+static void ieee80211_clear_interfaces(struct ieee80211_local *local)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
-
-	ieee80211_scan_cancel(local);
-
-	ieee80211_stop_queues_by_reason(hw,
-			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
-
-	/* flush out all packets */
-	synchronize_net();
-
-	local->quiescing = true;
-	/* make quiescing visible to timers everywhere */
-	mb();
-
-	flush_workqueue(local->workqueue);
-
-	/* Don't try to run timers while suspended. */
-	del_timer_sync(&local->sta_cleanup);
-
-	 /*
-	 * Note that this particular timer doesn't need to be
-	 * restarted at resume.
-	 */
-	cancel_work_sync(&local->dynamic_ps_enable_work);
-	del_timer_sync(&local->dynamic_ps_timer);
+	struct ieee80211_hw *hw = &local->hw;
 
 	/* disable keys */
 	list_for_each_entry(sdata, &local->interfaces, list)
@@ -94,6 +69,40 @@ int __ieee80211_suspend(struct ieee80211_hw *hw,
 
 		drv_remove_interface(local, &sdata->vif);
 	}
+}
+int __ieee80211_suspend(struct ieee80211_hw *hw,
+			struct cfg80211_wow *wow)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	bool wow_enabled = wow && wow->enabled_triggers;
+
+	ieee80211_scan_cancel(local);
+
+	ieee80211_stop_queues_by_reason(hw,
+			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+
+	/* flush out all packets */
+	synchronize_net();
+
+	local->quiescing = true;
+	/* make quiescing visible to timers everywhere */
+	mb();
+
+	flush_workqueue(local->workqueue);
+
+	/* Don't try to run timers while suspended. */
+	del_timer_sync(&local->sta_cleanup);
+
+	 /*
+	 * Note that this particular timer doesn't need to be
+	 * restarted at resume.
+	 */
+	cancel_work_sync(&local->dynamic_ps_enable_work);
+	del_timer_sync(&local->dynamic_ps_timer);
+
+	/* in case of wow, we want to leave the interfaces up */
+	if (!wow_enabled)
+		ieee80211_clear_interfaces(local);
 
 	/* stop hardware - this must stop RX */
 	if (local->open_count)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 627175a..d640ffd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1119,38 +1119,13 @@ void ieee80211_stop_device(struct ieee80211_local *local,
 	drv_stop(local, wow);
 }
 
-int ieee80211_reconfig(struct ieee80211_local *local,
-		       struct cfg80211_wow *wow)
+static void ieee80211_reconfig_interface(struct ieee80211_local *local)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	int res;
 
-	if (local->suspended)
-		local->resuming = true;
-
-	/* restart hardware */
-	if (local->open_count) {
-		/*
-		 * Upon resume hardware can sometimes be goofy due to
-		 * various platform / driver / bus issues, so restarting
-		 * the device may at times not work immediately. Propagate
-		 * the error.
-		 */
-		res = drv_start(local, wow);
-		if (res) {
-			WARN(local->suspended, "Hardware became unavailable "
-			     "upon resume. This could be a software issue "
-			     "prior to suspend or a hardware issue.\n");
-			return res;
-		}
-
-		ieee80211_led_radio(local, true);
-		ieee80211_mod_tpt_led_trig(local,
-					   IEEE80211_TPT_LEDTRIG_FL_RADIO, 0);
-	}
-
 	/* add interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
@@ -1259,7 +1234,46 @@ int ieee80211_reconfig(struct ieee80211_local *local,
 	list_for_each_entry(sdata, &local->interfaces, list)
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_enable_keys(sdata);
+}
+
+int ieee80211_reconfig(struct ieee80211_local *local,
+		       struct cfg80211_wow *wow)
+{
+	struct ieee80211_hw *hw = &local->hw;
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+	bool wow_enabled = wow && wow->enabled_triggers;
+	int res;
+
+	if (local->suspended)
+		local->resuming = true;
+
+	/* restart hardware */
+	if (local->open_count) {
+		/*
+		 * Upon resume hardware can sometimes be goofy due to
+		 * various platform / driver / bus issues, so restarting
+		 * the device may at times not work immediately. Propagate
+		 * the error.
+		 */
+		res = drv_start(local, wow);
+		if (res) {
+			WARN(local->suspended, "Hardware became unavailable "
+			     "upon resume. This could be a software issue "
+			     "prior to suspend or a hardware issue.\n");
+			return res;
+		}
+
+		ieee80211_led_radio(local, true);
+		ieee80211_mod_tpt_led_trig(local,
+					   IEEE80211_TPT_LEDTRIG_FL_RADIO, 0);
+	}
+
+	/* reconfig interface only if they were removed */
+	if (!wow_enabled)
+		ieee80211_reconfig_interface(local);
 
+	/* should we do it anyway? */
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
-- 
1.7.0.4

