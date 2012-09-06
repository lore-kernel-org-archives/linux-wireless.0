Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49178 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab2IFPEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 11:04:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: disconnect if channel switch fails
Date: Thu,  6 Sep 2012 17:04:37 +0200
Message-Id: <1346943877-24194-1-git-send-email-johannes@sipsolutions.net> (sfid-20120906_170407_756731_24F5E2E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Disconnect from the AP if channel switching in the
driver failed or if the new channel is unavailable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   55 +++++++++++++++++++++++++++++---------------
 2 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0a983fb..e2ab03c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -411,6 +411,7 @@ struct ieee80211_if_managed {
 	struct work_struct monitor_work;
 	struct work_struct chswitch_work;
 	struct work_struct beacon_connection_loss_work;
+	struct work_struct csa_connection_drop_work;
 
 	unsigned long beacon_timeout;
 	unsigned long probe_timeout;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5d77650..6e374cb 100644
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
 
@@ -784,8 +781,14 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
-	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED)
+	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED) {
+		sdata_info(sdata,
+			   "AP %pM switches to unsupported channel (%d MHz), disconnecting\n",
+			   ifmgd->associated->bssid, new_freq);
+		ieee80211_queue_work(&sdata->local->hw,
+				     &ifmgd->csa_connection_drop_work);
 		return;
+	}
 
 	sdata->local->csa_channel = new_ch;
 
@@ -1692,7 +1695,8 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_ap_probereq_get);
 
-static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
+static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata,
+				   bool transmit_frame)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
@@ -1704,12 +1708,10 @@ static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 
-	sdata_info(sdata, "Connection to AP %pM lost\n",
-		   ifmgd->associated->bssid);
-
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
-			       false, frame_buf);
+			       transmit_frame, frame_buf);
+	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 	mutex_unlock(&ifmgd->mtx);
 
 	/*
@@ -1739,10 +1741,24 @@ static void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 		rcu_read_unlock();
 	}
 
-	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
-		__ieee80211_connection_loss(sdata);
-	else
+	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR) {
+		sdata_info(sdata, "Connection to AP %pM lost\n",
+			   ifmgd->bssid);
+		__ieee80211_disconnect(sdata, false);
+	} else {
 		ieee80211_mgd_probe_ap(sdata, true);
+	}
+}
+
+static void ieee80211_csa_connection_drop_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.csa_connection_drop_work);
+
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+	__ieee80211_disconnect(sdata, true);
 }
 
 void ieee80211_beacon_loss(struct ieee80211_vif *vif)
@@ -2929,6 +2945,7 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 
 	cancel_work_sync(&ifmgd->monitor_work);
 	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+	cancel_work_sync(&ifmgd->csa_connection_drop_work);
 	if (del_timer_sync(&ifmgd->timer))
 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
 
@@ -2985,6 +3002,8 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
 	INIT_WORK(&ifmgd->beacon_connection_loss_work,
 		  ieee80211_beacon_connection_loss_work);
+	INIT_WORK(&ifmgd->csa_connection_drop_work,
+		  ieee80211_csa_connection_drop_work);
 	INIT_WORK(&ifmgd->request_smps_work, ieee80211_request_smps_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
-- 
1.7.10.4

