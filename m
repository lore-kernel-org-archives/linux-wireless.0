Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab3IMKiJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 06:38:09 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 3/5] Revert "mac80211: cleanup suspend/resume on managed mode"
Date: Fri, 13 Sep 2013 12:36:06 +0200
Message-Id: <1379068568-27552-4-git-send-email-sgruszka@redhat.com> (sfid-20130913_123822_022657_9E53EEF5)
In-Reply-To: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
References: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 9b7d72c1041ec5b20b24af487a98f71d8ff1555e.

Conflicts:
	net/mac80211/ieee80211_i.h
	net/mac80211/mlme.c
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/mlme.c        | 63 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 96ac8f8..c5878af 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -402,6 +402,7 @@ struct ieee80211_if_managed {
 
 	u16 aid;
 
+	unsigned long timers_running; /* used for quiesce/restart */
 	bool powersave; /* powersave requested for this iface */
 	bool broken_ap; /* AP is broken -- turn off powersave */
 	bool have_beacon;
@@ -1313,6 +1314,8 @@ void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata);
 int ieee80211_max_network_latency(struct notifier_block *nb,
 				  unsigned long data, void *dummy);
 int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 86e4ad5..b308855 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -92,6 +92,9 @@ MODULE_PARM_DESC(probe_wait_ms,
  */
 #define IEEE80211_SIGNAL_AVE_MIN_COUNT	4
 
+#define TMR_RUNNING_TIMER	0
+#define TMR_RUNNING_CHANSW	1
+
 /*
  * We can have multiple work items (and connection probing)
  * scheduling this timer, but we need to take care to only
@@ -988,8 +991,14 @@ static void ieee80211_chswitch_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	if (sdata->local->quiescing) {
+		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
+		return;
+	}
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.chswitch_work);
+	ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 }
 
 static void
@@ -1922,6 +1931,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.timer);
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
 
+	sdata->u.mgd.timers_running = 0;
+
 	sdata->vif.bss_conf.dtim_period = 0;
 	sdata->vif.bss_conf.beacon_rate = NULL;
 
@@ -3315,8 +3326,15 @@ static void ieee80211_sta_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_local *local = sdata->local;
+
+	if (local->quiescing) {
+		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
+		return;
+	}
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
 static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
@@ -3661,6 +3679,37 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 }
 
 #ifdef CONFIG_PM
+void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	/*
+	 * Stop timers before deleting work items, as timers
+	 * could race and re-add the work-items. They will be
+	 * re-established on connection.
+	 */
+	del_timer_sync(&ifmgd->conn_mon_timer);
+	del_timer_sync(&ifmgd->bcn_mon_timer);
+
+	/*
+	 * we need to use atomic bitops for the running bits
+	 * only because both timers might fire at the same
+	 * time -- the code here is properly synchronised.
+	 */
+
+	cancel_work_sync(&ifmgd->request_smps_work);
+
+	cancel_work_sync(&ifmgd->monitor_work);
+	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+	cancel_work_sync(&ifmgd->csa_connection_drop_work);
+	if (del_timer_sync(&ifmgd->timer))
+		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
+
+	if (del_timer_sync(&ifmgd->chswitch_timer))
+		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
+	cancel_work_sync(&ifmgd->chswitch_work);
+}
+
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -3682,6 +3731,16 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 	sdata_unlock(sdata);
+
+	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
+		add_timer(&ifmgd->timer);
+	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))
+		add_timer(&ifmgd->chswitch_timer);
+	ieee80211_sta_reset_beacon_monitor(sdata);
+
+	mutex_lock(&sdata->local->mtx);
+	ieee80211_restart_sta_timer(sdata);
+	mutex_unlock(&sdata->local->mtx);
 }
 #endif
 
-- 
1.8.3.1

