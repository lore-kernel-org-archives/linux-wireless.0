Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3ARUjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 15:39:02 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove redundant check
Date: Fri, 18 Jan 2013 21:39:23 +0100
Message-Id: <1358541563-14448-1-git-send-email-johannes@sipsolutions.net> (sfid-20130118_213906_219300_3BEE8B84)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to have two checks for "associated"
in ieee80211_sta_restart(), make the first one locked
to not race (unlikely at this point during resume)
and remove the second check.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d6112b0..99ce4eb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3191,23 +3191,22 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	if (!ifmgd->associated)
+	mutex_lock(&ifmgd->mtx);
+	if (!ifmgd->associated) {
+		mutex_unlock(&ifmgd->mtx);
 		return;
+	}
 
 	if (sdata->flags & IEEE80211_SDATA_DISCONNECT_RESUME) {
 		sdata->flags &= ~IEEE80211_SDATA_DISCONNECT_RESUME;
-		mutex_lock(&ifmgd->mtx);
-		if (ifmgd->associated) {
-			mlme_dbg(sdata,
-				 "driver requested disconnect after resume\n");
-			ieee80211_sta_connection_lost(sdata,
-				ifmgd->associated->bssid,
-				WLAN_REASON_UNSPECIFIED);
-			mutex_unlock(&ifmgd->mtx);
-			return;
-		}
+		mlme_dbg(sdata, "driver requested disconnect after resume\n");
+		ieee80211_sta_connection_lost(sdata,
+					      ifmgd->associated->bssid,
+					      WLAN_REASON_UNSPECIFIED);
 		mutex_unlock(&ifmgd->mtx);
+		return;
 	}
+	mutex_unlock(&ifmgd->mtx);
 
 	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
 		add_timer(&ifmgd->timer);
-- 
1.8.0

