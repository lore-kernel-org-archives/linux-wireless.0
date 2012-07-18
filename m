Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab2GRSkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 14:40:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't react to beacon loss if HW monitoring
Date: Wed, 18 Jul 2012 20:40:34 +0200
Message-Id: <1342636834-5166-1-git-send-email-johannes@sipsolutions.net> (sfid-20120718_204039_311363_FABADB0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the HW is monitoring connection loss (as advertised
by IEEE80211_HW_CONNECTION_MONITOR) but not filtering
beacons (IEEE80211_VIF_BEACON_FILTER) then mac80211 will
still start the beacon loss timer and if a few beacons
are lost, e.g. due to scanning, drop the connection.

If the hardware doesn't advertise connection monitoring,
then it won't drop the connection right away but probe
the AP, which is intended, but due to the logic in the
timer when connection monitoring is done it assumes the
connection was actually lost.

Fix this problem by not starting the timer when the HW
does connection monitoring.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7c0613c..b7975be 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -146,6 +146,9 @@ void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata)
 	if (sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)
 		return;
 
+	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+		return;
+
 	mod_timer(&sdata->u.mgd.bcn_mon_timer,
 		  round_jiffies_up(jiffies + sdata->u.mgd.beacon_timeout));
 }
-- 
1.7.10.4

