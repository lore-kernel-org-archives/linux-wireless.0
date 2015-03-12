Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbbCLGxg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 02:53:36 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/7] mac80211: refactor drop connection/unlock in CSA processing
Date: Thu, 12 Mar 2015 08:53:25 +0200
Message-Id: <1426143210-25635-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_075347_329794_84993BE0)
In-Reply-To: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The schedule_work()/mutex unlocking code is duplicated many times,
refactor that to a common place in the function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 539d6a9..1999bc0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1157,11 +1157,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (!conf) {
 		sdata_info(sdata,
 			   "no channel context assigned to vif?, disconnecting\n");
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		mutex_unlock(&local->chanctx_mtx);
-		mutex_unlock(&local->mtx);
-		return;
+		goto drop_connection;
 	}
 
 	chanctx = container_of(conf, struct ieee80211_chanctx, conf);
@@ -1170,11 +1166,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	    !(local->hw.flags & IEEE80211_HW_CHANCTX_STA_CSA)) {
 		sdata_info(sdata,
 			   "driver doesn't support chan-switch with channel contexts\n");
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		mutex_unlock(&local->chanctx_mtx);
-		mutex_unlock(&local->mtx);
-		return;
+		goto drop_connection;
 	}
 
 	ch_switch.timestamp = timestamp;
@@ -1186,11 +1178,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (drv_pre_channel_switch(sdata, &ch_switch)) {
 		sdata_info(sdata,
 			   "preparing for channel switch failed, disconnecting\n");
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		mutex_unlock(&local->chanctx_mtx);
-		mutex_unlock(&local->mtx);
-		return;
+		goto drop_connection;
 	}
 
 	res = ieee80211_vif_reserve_chanctx(sdata, &csa_ie.chandef,
@@ -1199,11 +1187,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		sdata_info(sdata,
 			   "failed to reserve channel context for channel switch, disconnecting (err=%d)\n",
 			   res);
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		mutex_unlock(&local->chanctx_mtx);
-		mutex_unlock(&local->mtx);
-		return;
+		goto drop_connection;
 	}
 	mutex_unlock(&local->chanctx_mtx);
 
@@ -1232,6 +1216,11 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		mod_timer(&ifmgd->chswitch_timer,
 			  TU_TO_EXP_TIME((csa_ie.count - 1) *
 					 cbss->beacon_interval));
+	return;
+ drop_connection:
+	ieee80211_queue_work(&local->hw, &ifmgd->csa_connection_drop_work);
+	mutex_unlock(&local->chanctx_mtx);
+	mutex_unlock(&local->mtx);
 }
 
 static bool
-- 
1.9.1

