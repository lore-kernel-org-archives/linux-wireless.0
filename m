Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab3A3Ogt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 09:36:49 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -stable 3.4] mac80211: synchronize scan off/on-channel and PS states
Date: Wed, 30 Jan 2013 15:36:47 +0100
Message-Id: <1359556607-2515-1-git-send-email-sgruszka@redhat.com> (sfid-20130130_153654_323198_5A421E47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit aacde9ee45225f7e0b90960f479aef83c66bfdc0 upstream

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
Tested-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    6 ++----
 net/mac80211/offchannel.c  |   17 ++++++-----------
 net/mac80211/scan.c        |   15 +++++----------
 net/mac80211/work.c        |    4 ++--
 4 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f8b5e75..05160db 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1264,10 +1264,8 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
-				    bool offchannel_ps_enable);
-void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool offchannel_ps_disable);
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local);
+void ieee80211_offchannel_return(struct ieee80211_local *local);
 void ieee80211_hw_roc_setup(struct ieee80211_local *local);
 
 /* interface handling */
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 935aa4b..c22f074 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -103,8 +103,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
-				    bool offchannel_ps_enable)
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -129,8 +128,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 			netif_tx_stop_all_queues(sdata->dev);
-			if (offchannel_ps_enable &&
-			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
+			if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 			    sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_enable(sdata, true);
 		}
@@ -138,8 +136,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
-void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool offchannel_ps_disable)
+void ieee80211_offchannel_return(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -152,11 +149,9 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
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
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index e95d494..bcc57f9 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -329,7 +329,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	if (!was_hw_scan) {
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
-		ieee80211_offchannel_return(local, true);
+		ieee80211_offchannel_return(local);
 	}
 
 	ieee80211_recalc_idle(local);
@@ -374,7 +374,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
-	ieee80211_offchannel_stop_vifs(local, true);
+	ieee80211_offchannel_stop_vifs(local);
 
 	ieee80211_configure_filter(local);
 
@@ -629,12 +629,8 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
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
@@ -644,8 +640,7 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 					unsigned long *next_delay)
 {
-	/* PS already is in off-channel mode */
-	ieee80211_offchannel_stop_vifs(local, false);
+	ieee80211_offchannel_stop_vifs(local);
 
 	if (local->ops->flush) {
 		drv_flush(local, false);
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index c6e230e..a74f538 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -148,7 +148,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		}
 
 		if (!started && !local->tmp_channel) {
-			ieee80211_offchannel_stop_vifs(local, true);
+			ieee80211_offchannel_stop_vifs(local);
 
 			local->tmp_channel = wk->chan;
 			local->tmp_channel_type = wk->chan_type;
@@ -220,7 +220,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		local->tmp_channel = NULL;
 		ieee80211_hw_config(local, 0);
 
-		ieee80211_offchannel_return(local, true);
+		ieee80211_offchannel_return(local);
 
 		/* give connection some time to breathe */
 		run_again(local, jiffies + HZ/2);
-- 
1.7.1

