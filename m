Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1DULiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 07:38:06 -0400
Subject: [PATCH] mac80211: tear down BA sessions properly on suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 13:38:00 +0200
Message-ID: <1303385880.3597.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, the code to tear down BA sessions will
execute after queues are stopped, but attempt to
send frames, so those frames will just get queued,
which isn't intended. Move this code to before to
tear down the sessions properly.

Additionally, after stopping queues, flush the TX
queues in the driver driver to make sure all the
frames went out.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/pm.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/net/mac80211/pm.c	2011-04-21 13:32:22.000000000 +0200
+++ b/net/mac80211/pm.c	2011-04-21 13:32:24.000000000 +0200
@@ -14,12 +14,23 @@ int __ieee80211_suspend(struct ieee80211
 
 	ieee80211_scan_cancel(local);
 
+	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+		mutex_lock(&local->sta_mtx);
+		list_for_each_entry(sta, &local->sta_list, list) {
+			set_sta_flags(sta, WLAN_STA_BLOCK_BA);
+			ieee80211_sta_tear_down_BA_sessions(sta, true);
+		}
+		mutex_unlock(&local->sta_mtx);
+	}
+
 	ieee80211_stop_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
 	/* flush out all packets */
 	synchronize_net();
 
+	drv_flush(local, false);
+
 	local->quiescing = true;
 	/* make quiescing visible to timers everywhere */
 	mb();
@@ -43,11 +54,6 @@ int __ieee80211_suspend(struct ieee80211
 	/* tear down aggregation sessions and remove STAs */
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
-		if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
-			set_sta_flags(sta, WLAN_STA_BLOCK_BA);
-			ieee80211_sta_tear_down_BA_sessions(sta, true);
-		}
-
 		if (sta->uploaded) {
 			sdata = sta->sdata;
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)


