Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab1GNOYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 10:24:30 -0400
Subject: [PATCH] mac80211: be more careful in suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 16:24:26 +0200
Message-ID: <1310653466.3874.23.camel@jlt3.sipsolutions.net> (sfid-20110714_162435_452545_1D488BF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When suspending with all netdevs down, the device
is stopped but we still call a number of driver
callbacks that the driver might not expect. The
same happens during resume, we might call a few
callbacks without starting the driver. Fix this
by checking open_count around more things and
exiting quickly if it is 0.

Also, while at this I noticed that the coverage
class isn't reprogrammed after resume, so add
that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/pm.c   |    3 ++
 net/mac80211/util.c |   54 ++++++++++++++++++++++++++--------------------------
 2 files changed, 31 insertions(+), 26 deletions(-)

--- a/net/mac80211/pm.c	2011-07-14 16:21:12.000000000 +0200
+++ b/net/mac80211/pm.c	2011-07-14 16:21:28.000000000 +0200
@@ -34,6 +34,9 @@ int __ieee80211_suspend(struct ieee80211
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
+	if (!local->open_count)
+		goto suspend;
+
 	ieee80211_scan_cancel(local);
 
 	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
--- a/net/mac80211/util.c	2011-07-14 16:21:12.000000000 +0200
+++ b/net/mac80211/util.c	2011-07-14 16:21:28.000000000 +0200
@@ -1157,27 +1157,37 @@ int ieee80211_reconfig(struct ieee80211_
 	}
 #endif
 
-	/* restart hardware */
-	if (local->open_count) {
-		/*
-		 * Upon resume hardware can sometimes be goofy due to
-		 * various platform / driver / bus issues, so restarting
-		 * the device may at times not work immediately. Propagate
-		 * the error.
-		 */
-		res = drv_start(local);
-		if (res) {
-			WARN(local->suspended, "Hardware became unavailable "
-			     "upon resume. This could be a software issue "
-			     "prior to suspend or a hardware issue.\n");
-			return res;
-		}
+	/* setup fragmentation threshold */
+	drv_set_frag_threshold(local, hw->wiphy->frag_threshold);
+
+	/* setup RTS threshold */
+	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
+
+	/* reset coverage class */
+	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
 
-		ieee80211_led_radio(local, true);
-		ieee80211_mod_tpt_led_trig(local,
-					   IEEE80211_TPT_LEDTRIG_FL_RADIO, 0);
+	/* everything else happens only if HW was up & running */
+	if (!local->open_count)
+		goto wake_up;
+
+	/*
+	 * Upon resume hardware can sometimes be goofy due to
+	 * various platform / driver / bus issues, so restarting
+	 * the device may at times not work immediately. Propagate
+	 * the error.
+	 */
+	res = drv_start(local);
+	if (res) {
+		WARN(local->suspended, "Hardware became unavailable "
+		     "upon resume. This could be a software issue "
+		     "prior to suspend or a hardware issue.\n");
+		return res;
 	}
 
+	ieee80211_led_radio(local, true);
+	ieee80211_mod_tpt_led_trig(local,
+				   IEEE80211_TPT_LEDTRIG_FL_RADIO, 0);
+
 	/* add interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
@@ -1201,12 +1211,6 @@ int ieee80211_reconfig(struct ieee80211_
 	}
 	mutex_unlock(&local->sta_mtx);
 
-	/* setup fragmentation threshold */
-	drv_set_frag_threshold(local, hw->wiphy->frag_threshold);
-
-	/* setup RTS threshold */
-	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
-
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
 
@@ -1287,9 +1291,7 @@ int ieee80211_reconfig(struct ieee80211_
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_enable_keys(sdata);
 
-#ifdef CONFIG_PM
  wake_up:
-#endif
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 


