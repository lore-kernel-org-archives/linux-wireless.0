Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab2HAPVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 11:21:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 8/8] mac80211: disconnect if channel switch fails
Date: Wed,  1 Aug 2012 17:21:27 +0200
Message-Id: <1343834487-23737-9-git-send-email-johannes@sipsolutions.net> (sfid-20120801_172148_668361_04AE7BFD)
In-Reply-To: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
References: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Disconnect from the AP if channel switching in the
driver failed or if the new channel is unavailable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cc76481..359ec2b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -730,16 +730,13 @@ void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 
 	trace_api_chswitch_done(sdata, success);
 	if (!success) {
-		/*
-		 * If the channel switch was not successful, stay
-		 * around on the old channel. We currently lack
-		 * good handling of this situation, possibly we
-		 * should just drop the association.
-		 */
-		sdata->local->csa_channel = sdata->local->oper_channel;
+		sdata_info(sdata,
+			   "driver channel switch failed, disconnecting\n");
+		ieee80211_queue_work(&sdata->local->hw,
+				     &ifmgd->csa_connection_drop_work);
+	} else {
+		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 	}
-
-	ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 }
 EXPORT_SYMBOL(ieee80211_chswitch_done);
 
@@ -784,8 +781,14 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
-	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED)
+	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED) {
+		sdata_info(sdata,
+			   "AP %pM switches to unsupported channel %d, disconnecting\n",
+			   ifmgd->associated->bssid, new_chan_no);
+		ieee80211_queue_work(&sdata->local->hw,
+				     &ifmgd->csa_connection_drop_work);
 		return;
+	}
 
 	sdata->local->csa_channel = new_ch;
 
@@ -1704,6 +1707,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata,
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
 			       transmit_frame, frame_buf);
+	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 	mutex_unlock(&ifmgd->mtx);
 
 	/*
@@ -1748,6 +1752,8 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.csa_connection_drop_work);
 
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
 	__ieee80211_disconnect(sdata, true);
 }
 
-- 
1.7.10.4

