Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37138 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbbAWOvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 09:51:47 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: support beacon statistics
Date: Fri, 23 Jan 2015 15:51:43 +0100
Message-Id: <1422024703-27225-1-git-send-email-johannes@sipsolutions.net> (sfid-20150123_155151_748135_47DE0A89)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For drivers without beacon filtering, support beacon statistics
entirely, i.e. report the number of beacons and average signal.

For drivers with beacon filtering, give them the number of beacons
received by mac80211 -- in case the device reports only the number
of filtered beacons then driver doesn't have to count all beacons
again as mac80211 already does.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 79383ef0c264..00ca8dcc2bcf 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1764,6 +1764,13 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 	sinfo->generation = sdata->local->sta_generation;
 
+	/* do before driver, so beacon filtering drivers have a
+	 * chance to e.g. just add the number of filtered beacons
+	 * (or just modify the value entirely, of course)
+	 */
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		sinfo->rx_beacon = sdata->u.mgd.count_beacon_signal;
+
 	drv_sta_statistics(local, sdata, &sta->sta, sinfo);
 
 	sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME) |
@@ -1816,6 +1823,13 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	sinfo->rx_dropped_misc = sta->rx_dropped;
 	sinfo->beacon_loss_count = sta->beacon_loss_count;
 
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !(sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_RX) |
+				 BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG);
+		sinfo->rx_beacon_signal_avg = ieee80211_ave_rssi(&sdata->vif);
+	}
+
 	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
 	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
 		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL))) {
-- 
2.1.4

