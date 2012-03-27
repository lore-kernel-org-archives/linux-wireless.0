Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58737 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2C0Gpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 02:45:38 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC] mac80211: inform offchannel status to AP
Date: Tue, 27 Mar 2012 12:16:14 +0530
Message-ID: <1332830774-27947-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120327_084542_916040_83637172)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The powersave notification was coded based on initial scan mechanism
where the station visits all channels then come back to oper channel.
Thats why the nullfunc notification was issued only at the start and end
of the scan. But recently the scan logic was optimized to revisit the
home channel based on pending frames in tx queue, listen interval etc.,

During the background scan, when the station is in powersave mode and
revists the home channel, it tries to get the buffered frames from AP
by pspoll when it receives the beacon with TIM IE. But the station *can
not* use the pspoll if powersave is disabled. So in such cases, the STA
has to use nullfunc with appropriate PS bit to receive frames from AP.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/ieee80211_i.h |    6 ++----
 net/mac80211/offchannel.c  |   17 ++++++-----------
 net/mac80211/scan.c        |   13 +++++--------
 net/mac80211/work.c        |    4 ++--
 4 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d9798a3..cc2c894 100644
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
index f054e94..4141f19 100644
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
+			if ((sdata->vif.type == NL80211_IFTYPE_STATION) &&
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
+		if ((sdata->vif.type == NL80211_IFTYPE_STATION) &&
+		    sdata->u.mgd.associated)
+			ieee80211_offchannel_ps_disable(sdata);
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 			/*
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index c70e176..9045294 100644
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
 
@@ -630,11 +630,9 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	/*
-	 * Re-enable vifs and beaconing.  Leave PS
-	 * in off-channel state..will put that back
-	 * on-channel at the end of scanning.
+	 * Re-enable vifs and beaconing and PS.
 	 */
-	ieee80211_offchannel_return(local, false);
+	ieee80211_offchannel_return(local);
 
 	*next_delay = HZ / 5;
 	/* afterwards, resume scan & go to next channel */
@@ -644,8 +642,7 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
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
1.7.9.4

