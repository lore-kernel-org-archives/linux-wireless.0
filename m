Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208Ab3B0PAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 10:00:49 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 4/8] mac80211: cleanup suspend/resume on managed mode
Date: Wed, 27 Feb 2013 16:00:38 +0100
Message-Id: <1361977242-17344-4-git-send-email-sgruszka@redhat.com> (sfid-20130227_160053_719518_9E3050E2)
In-Reply-To: <1361977242-17344-1-git-send-email-sgruszka@redhat.com>
References: <1361977242-17344-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove not used any longer suspend/resume code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/ieee80211_i.h |  3 --
 net/mac80211/mlme.c        | 84 ++--------------------------------------------
 2 files changed, 2 insertions(+), 85 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cc917a7..5230694 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -400,7 +400,6 @@ struct ieee80211_if_managed {
 
 	u16 aid;
 
-	unsigned long timers_running; /* used for quiesce/restart */
 	bool powersave; /* powersave requested for this iface */
 	bool broken_ap; /* AP is broken -- turn off powersave */
 	u8 dtim_period;
@@ -1279,8 +1278,6 @@ void
 ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				 const struct ieee80211_channel_sw_ie *sw_elem,
 				 struct ieee80211_bss *bss, u64 timestamp);
-void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata);
-void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9f6464f..410470f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -87,9 +87,6 @@ MODULE_PARM_DESC(probe_wait_ms,
  */
 #define IEEE80211_SIGNAL_AVE_MIN_COUNT	4
 
-#define TMR_RUNNING_TIMER	0
-#define TMR_RUNNING_CHANSW	1
-
 /*
  * All cfg80211 functions have to be called outside a locked
  * section so that they can acquire a lock themselves... This
@@ -1035,14 +1032,8 @@ static void ieee80211_chswitch_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-
-	if (sdata->local->quiescing) {
-		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
-		return;
-	}
 
-	ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.chswitch_work);
 }
 
 void
@@ -1827,8 +1818,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.timer);
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
 
-	sdata->u.mgd.timers_running = 0;
-
 	sdata->vif.bss_conf.dtim_period = 0;
 
 	ifmgd->flags = 0;
@@ -3137,15 +3126,8 @@ static void ieee80211_sta_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_local *local = sdata->local;
-
-	if (local->quiescing) {
-		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
-		return;
-	}
 
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 }
 
 static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
@@ -3497,68 +3479,6 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-#ifdef CONFIG_PM
-void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-
-	/*
-	 * we need to use atomic bitops for the running bits
-	 * only because both timers might fire at the same
-	 * time -- the code here is properly synchronised.
-	 */
-
-	cancel_work_sync(&ifmgd->request_smps_work);
-
-	cancel_work_sync(&ifmgd->monitor_work);
-	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
-	cancel_work_sync(&ifmgd->csa_connection_drop_work);
-	if (del_timer_sync(&ifmgd->timer))
-		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
-
-	cancel_work_sync(&ifmgd->chswitch_work);
-	if (del_timer_sync(&ifmgd->chswitch_timer))
-		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
-
-	/* these will just be re-established on connection */
-	del_timer_sync(&ifmgd->conn_mon_timer);
-	del_timer_sync(&ifmgd->bcn_mon_timer);
-}
-
-void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-
-	mutex_lock(&ifmgd->mtx);
-	if (!ifmgd->associated) {
-		mutex_unlock(&ifmgd->mtx);
-		return;
-	}
-
-	if (sdata->flags & IEEE80211_SDATA_DISCONNECT_RESUME) {
-		sdata->flags &= ~IEEE80211_SDATA_DISCONNECT_RESUME;
-		mlme_dbg(sdata, "driver requested disconnect after resume\n");
-		ieee80211_sta_connection_lost(sdata,
-					      ifmgd->associated->bssid,
-					      WLAN_REASON_UNSPECIFIED,
-					      true);
-		mutex_unlock(&ifmgd->mtx);
-		return;
-	}
-	mutex_unlock(&ifmgd->mtx);
-
-	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
-		add_timer(&ifmgd->timer);
-	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))
-		add_timer(&ifmgd->chswitch_timer);
-	ieee80211_sta_reset_beacon_monitor(sdata);
-
-	mutex_lock(&sdata->local->mtx);
-	ieee80211_restart_sta_timer(sdata);
-	mutex_unlock(&sdata->local->mtx);
-}
-#endif
-
 /* interface setup */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
-- 
1.7.11.7

