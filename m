Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab2LTNl2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 08:41:28 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] mac80211: synchronize scan off/on-channel and PS states
Date: Thu, 20 Dec 2012 14:41:18 +0100
Message-Id: <1356010879-10054-1-git-send-email-sgruszka@redhat.com> (sfid-20121220_144134_118128_819CDDCC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since:

commit b23b025fe246f3acc2988eb6d400df34c27cb8ae
Author: Ben Greear <greearb@candelatech.com>
Date:   Fri Feb 4 11:54:17 2011 -0800

    mac80211: Optimize scans on current operating channel.

we do not disable PS while going back to operational channel (on
ieee80211_scan_state_suspend) and deffer that until scan finish.
But since we are allowed to send frames, we can send a frame to AP
without PM bit set, so disable PS on AP side. Then when we switch
to off-channel (in ieee80211_scan_state_resume) we do not enable PS.
Hence we are off-channel with PS disabled, frames are not buffered
by AP.

To fix remove offchannel_ps_disable argument and always enable PS when
going off-channel and disable it when going on-channel, like it was
before.

Cc: stable@vger.kernel.org # 2.6.39+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/ieee80211_i.h |    6 ++----
 net/mac80211/offchannel.c  |   19 +++++++------------
 net/mac80211/scan.c        |   15 +++++----------
 3 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 42d0d02..63c5d9f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1357,10 +1357,8 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
-				    bool offchannel_ps_enable);
-void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool offchannel_ps_disable);
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local);
+void ieee80211_offchannel_return(struct ieee80211_local *local);
 void ieee80211_roc_setup(struct ieee80211_local *local);
 void ieee80211_start_next_roc(struct ieee80211_local *local);
 void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index a5379ae..a3ad4c3 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -102,8 +102,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
-				    bool offchannel_ps_enable)
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -134,8 +133,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 			netif_tx_stop_all_queues(sdata->dev);
-			if (offchannel_ps_enable &&
-			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
+			if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 			    sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_enable(sdata);
 		}
@@ -143,8 +141,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
-void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool offchannel_ps_disable)
+void ieee80211_offchannel_return(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -163,11 +160,9 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 			continue;
 
 		/* Tell AP we're back */
-		if (offchannel_ps_disable &&
-		    sdata->vif.type == NL80211_IFTYPE_STATION) {
-			if (sdata->u.mgd.associated)
-				ieee80211_offchannel_ps_disable(sdata);
-		}
+		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+		    sdata->u.mgd.associated)
+			ieee80211_offchannel_ps_disable(sdata);
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 			/*
@@ -385,7 +380,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 			local->tmp_channel = NULL;
 			ieee80211_hw_config(local, 0);
 
-			ieee80211_offchannel_return(local, true);
+			ieee80211_offchannel_return(local);
 		}
 
 		ieee80211_recalc_idle(local);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8ed83dc..2ac129a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -304,7 +304,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	if (!was_hw_scan) {
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
-		ieee80211_offchannel_return(local, true);
+		ieee80211_offchannel_return(local);
 	}
 
 	ieee80211_recalc_idle(local);
@@ -353,7 +353,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
-	ieee80211_offchannel_stop_vifs(local, true);
+	ieee80211_offchannel_stop_vifs(local);
 
 	ieee80211_configure_filter(local);
 
@@ -690,12 +690,8 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 	local->scan_channel = NULL;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
-	/*
-	 * Re-enable vifs and beaconing.  Leave PS
-	 * in off-channel state..will put that back
-	 * on-channel at the end of scanning.
-	 */
-	ieee80211_offchannel_return(local, false);
+	/* disable PS */
+	ieee80211_offchannel_return(local);
 
 	*next_delay = HZ / 5;
 	/* afterwards, resume scan & go to next channel */
@@ -705,8 +701,7 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 					unsigned long *next_delay)
 {
-	/* PS already is in off-channel mode */
-	ieee80211_offchannel_stop_vifs(local, false);
+	ieee80211_offchannel_stop_vifs(local);
 
 	if (local->ops->flush) {
 		drv_flush(local, false);
-- 
1.7.1

