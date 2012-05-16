Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758718Ab2EPN1q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 09:27:46 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] mac80211: run scan after finish connection monitoring
Date: Wed, 16 May 2012 15:27:20 +0200
Message-Id: <1337174840-2658-1-git-send-email-sgruszka@redhat.com> (sfid-20120516_152749_914772_FB280421)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 133d40f9a22bdfd2617a446f1e3209537c5415ec
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Wed Mar 28 16:01:19 2012 +0200

    mac80211: do not scan and monitor connection in parallel

add bug, which make possible to start a scan and never finish it, so
make every new scanning request finish with -EBUSY error. This can
happen on code paths where we finish connection monitoring and clear
IEEE80211_STA_*_POLL flags, but do not check if scan was deferred.
This patch fixes those code paths.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/mlme.c |   36 +++++++++++++++++++++++++++---------
 1 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7f5a6c0..620a81e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1220,6 +1220,22 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	sdata->vif.bss_conf.qos = true;
 }
 
+static void __ieee80211_stop_poll(struct ieee80211_sub_if_data *sdata)
+{
+	lockdep_assert_held(&sdata->local->mtx);
+
+	sdata->u.mgd.flags &= ~(IEEE80211_STA_CONNECTION_POLL |
+				IEEE80211_STA_BEACON_POLL);
+	ieee80211_run_deferred_scan(sdata->local);
+}
+
+static void ieee80211_stop_poll(struct ieee80211_sub_if_data *sdata)
+{
+	mutex_lock(&sdata->local->mtx);
+	__ieee80211_stop_poll(sdata);
+	mutex_unlock(&sdata->local->mtx);
+}
+
 static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 					   u16 capab, bool erp_valid, u8 erp)
 {
@@ -1286,8 +1302,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	sdata->u.mgd.flags |= IEEE80211_STA_RESET_SIGNAL_AVE;
 
 	/* just to be sure */
-	sdata->u.mgd.flags &= ~(IEEE80211_STA_CONNECTION_POLL |
-				IEEE80211_STA_BEACON_POLL);
+	ieee80211_stop_poll(sdata);
 
 	ieee80211_led_assoc(local, 1);
 
@@ -1458,8 +1473,7 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 
-	ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
-			  IEEE80211_STA_BEACON_POLL);
+	__ieee80211_stop_poll(sdata);
 
 	mutex_lock(&local->iflist_mtx);
 	ieee80211_recalc_ps(local, -1);
@@ -1479,7 +1493,6 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 		  round_jiffies_up(jiffies +
 				   IEEE80211_CONNECTION_IDLE_TIME));
 out:
-	ieee80211_run_deferred_scan(local);
 	mutex_unlock(&local->mtx);
 }
 
@@ -2414,7 +2427,11 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			       "to a received beacon\n", sdata->name);
 		}
 #endif
+		mutex_lock(&local->mtx);
 		ifmgd->flags &= ~IEEE80211_STA_BEACON_POLL;
+		ieee80211_run_deferred_scan(local);
+		mutex_unlock(&local->mtx);
+
 		mutex_lock(&local->iflist_mtx);
 		ieee80211_recalc_ps(local, -1);
 		mutex_unlock(&local->iflist_mtx);
@@ -2601,8 +2618,7 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[DEAUTH_DISASSOC_LEN];
 
-	ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
-			  IEEE80211_STA_BEACON_POLL);
+	ieee80211_stop_poll(sdata);
 
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH, reason,
 			       false, frame_buf);
@@ -2880,8 +2896,7 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 	u32 flags;
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		sdata->u.mgd.flags &= ~(IEEE80211_STA_BEACON_POLL |
-					IEEE80211_STA_CONNECTION_POLL);
+		__ieee80211_stop_poll(sdata);
 
 		/* let's probe the connection once */
 		flags = sdata->local->hw.flags;
@@ -2950,7 +2965,10 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))
 		add_timer(&ifmgd->chswitch_timer);
 	ieee80211_sta_reset_beacon_monitor(sdata);
+
+	mutex_lock(&sdata->local->mtx);
 	ieee80211_restart_sta_timer(sdata);
+	mutex_unlock(&sdata->local->mtx);
 }
 #endif
 
-- 
1.7.1

