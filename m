Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462Ab3BSQrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 11:47:12 -0500
Date: Tue, 19 Feb 2013 17:47:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 1/2] mac80211: disconnect on suspend in managed mode
Message-ID: <20130219164714.GA27140@redhat.com> (sfid-20130219_174716_168117_0E664C8C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If possible that after suspend cfg80211 receive request to disconnect
what require action on interface that was removed during suspend.
Problem can manifest itself by various warnings similar to below one:

WARNING: at net/mac80211/driver-ops.h:12 ieee80211_bss_info_change_notify+0x2f9/0x300 [mac80211]()
wlan0:  Failed check-sdata-in-driver check, flags: 0x4
Call Trace:
 [<c043e0b3>] warn_slowpath_fmt+0x33/0x40
 [<f83707c9>] ieee80211_bss_info_change_notify+0x2f9/0x300 [mac80211]
 [<f83a660a>] ieee80211_recalc_ps_vif+0x2a/0x30 [mac80211]
 [<f83a6706>] ieee80211_set_disassoc+0xf6/0x500 [mac80211]
 [<f83a9441>] ieee80211_mgd_deauth+0x1f1/0x280 [mac80211]
 [<f8381b36>] ieee80211_deauth+0x16/0x20 [mac80211]
 [<f8261e70>] cfg80211_mlme_down+0x70/0xc0 [cfg80211]
 [<f8264de1>] __cfg80211_disconnect+0x1b1/0x1d0 [cfg80211]

To fix the problem disconnect from AP during suspend.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/mlme.c | 58 +++++++++--------------------------------------------
 1 file changed, 10 insertions(+), 48 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9f6464f..19c926d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2060,7 +2060,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_ap_probereq_get);
 
-static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
+void ieee80211_disconnect(struct ieee80211_sub_if_data *sdata, u8 reason)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
@@ -2071,8 +2071,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 
-	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
-			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
+	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH, reason,
 			       true, frame_buf);
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
@@ -2105,7 +2104,8 @@ static void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 	if (ifmgd->connection_loss) {
 		sdata_info(sdata, "Connection to AP %pM lost\n",
 			   ifmgd->bssid);
-		__ieee80211_disconnect(sdata);
+		ieee80211_disconnect(sdata,
+				     WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
 	} else {
 		ieee80211_mgd_probe_ap(sdata, true);
 	}
@@ -2117,7 +2117,7 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.csa_connection_drop_work);
 
-	__ieee80211_disconnect(sdata);
+	ieee80211_disconnect(sdata, WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
 }
 
 void ieee80211_beacon_loss(struct ieee80211_vif *vif)
@@ -3502,60 +3502,22 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	ieee80211_disconnect(sdata, WLAN_REASON_DISASSOC_STA_HAS_LEFT);
+
 	/*
-	 * we need to use atomic bitops for the running bits
-	 * only because both timers might fire at the same
-	 * time -- the code here is properly synchronised.
+	 * As we disassociate all timers are canceled and pending works will
+	 * perform no action, but we need to wait until works will finish,
+	 * before we can freeze.
 	 */
-
 	cancel_work_sync(&ifmgd->request_smps_work);
-
 	cancel_work_sync(&ifmgd->monitor_work);
 	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
 	cancel_work_sync(&ifmgd->csa_connection_drop_work);
-	if (del_timer_sync(&ifmgd->timer))
-		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
-
 	cancel_work_sync(&ifmgd->chswitch_work);
-	if (del_timer_sync(&ifmgd->chswitch_timer))
-		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
-
-	/* these will just be re-established on connection */
-	del_timer_sync(&ifmgd->conn_mon_timer);
-	del_timer_sync(&ifmgd->bcn_mon_timer);
 }
 
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
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
 }
 #endif
 
-- 
1.7.11.7

