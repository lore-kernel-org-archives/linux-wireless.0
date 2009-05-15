Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50356 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724AbZEOEsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 00:48:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: fix some unforgotten items on suspend
Date: Fri, 15 May 2009 00:48:39 -0400
Message-Id: <1242362919-9788-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We forgot to clear items which stuffed things into the our
station's workqueues. In particular we forgot to deal with
the dynamic_ps_timer, ifmgd->timer, ifmgd->chswitch_timer.

While at it we go ahead and add a warning in ieee80211_sta_work()
if its run while the suspend->resume cycle is in effect. This
should not happen and if it does it would indicate there is
a bug lurking in either mac80211 or mac80211 drivers.

With this now wpa_supplicant doesn't blink when I go to suspend
and resume where as before there where issues with any of the items
in the workqueue running during the suspend->resume cycle. This
caused a lot of incorrect assumptions and would at times bring
back the device in incoherent, but mostly recoverable, states.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/ieee80211_i.h |    9 +++++++++
 net/mac80211/mlme.c        |   28 ++++++++++++++++++++++++----
 net/mac80211/pm.c          |   19 +++++++++++++++++++
 net/mac80211/util.c        |   11 ++++++++++-
 4 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9d15147..3e60f46 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -609,6 +609,13 @@ struct ieee80211_local {
 	unsigned int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
 	bool tim_in_locked_section; /* see ieee80211_beacon_get() */
+	/*
+	 * suspended is true if we finished all the suspend _and_ we have
+	 * not yet come up from resume. This is to be used by mac80211
+	 * to ensure driver sanity during suspend and mac80211's own
+	 * sanity. It can eventually be used for WoW as well.
+	 */
+	bool suspended;
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
@@ -994,6 +1001,7 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
 void ieee80211_remove_interfaces(struct ieee80211_local *local);
 u32 __ieee80211_recalc_idle(struct ieee80211_local *local);
 void ieee80211_recalc_idle(struct ieee80211_local *local);
+void ieee80211_sta_setup_sdata_timers(struct ieee80211_sub_if_data *sdata);
 
 /* tx handling */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
@@ -1052,6 +1060,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw);
 
 static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 {
+	hw_to_local(hw)->suspended = false;
 	return ieee80211_reconfig(hw_to_local(hw));
 }
 #else
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ae03068..d891967 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2129,6 +2129,17 @@ static void ieee80211_sta_work(struct work_struct *work)
 
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
 		return;
+
+	/*
+	 * Nothing should have been stuffed into the workqueue during
+	 * the suspend->resume cycle. If this WARN is seen then there
+	 * is a bug with either the driver suspend or something in
+	 * mac80211 stuffing into the workqueue which we haven't yet
+	 * cleared during mac80211's suspend cycle.
+	 */
+	if (WARN_ON(local->suspended))
+		return;
+
 	ifmgd = &sdata->u.mgd;
 
 	while ((skb = skb_dequeue(&ifmgd->skb_queue)))
@@ -2196,6 +2207,18 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
+void ieee80211_sta_setup_sdata_timers(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd;
+
+	ifmgd = &sdata->u.mgd;
+
+	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
+		    (unsigned long) sdata);
+	setup_timer(&ifmgd->chswitch_timer, ieee80211_chswitch_timer,
+		    (unsigned long) sdata);
+}
+
 /* interface setup */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
@@ -2206,10 +2229,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	INIT_WORK(&ifmgd->work, ieee80211_sta_work);
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
 	INIT_WORK(&ifmgd->beacon_loss_work, ieee80211_beacon_loss_work);
-	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
-		    (unsigned long) sdata);
-	setup_timer(&ifmgd->chswitch_timer, ieee80211_chswitch_timer,
-		    (unsigned long) sdata);
+	ieee80211_sta_setup_sdata_timers(sdata);
 	skb_queue_head_init(&ifmgd->skb_queue);
 
 	ifmgd->capab = WLAN_CAPABILITY_ESS;
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 9d3d89a..20fc091 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -18,6 +18,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 
 	flush_workqueue(local->hw.workqueue);
 
+	/* Don't stuff our workqueue during suspend->resume cycle */
+	del_timer_sync(&local->dynamic_ps_timer);
+	cancel_work_sync(&local->dynamic_ps_enable_work);
+
 	/* disable keys */
 	list_for_each_entry(sdata, &local->interfaces, list)
 		ieee80211_disable_keys(sdata);
@@ -52,6 +56,18 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		/*
+		 * This prevents us from stuffing our workqueue during
+		 * during the suspend->resume cycle.
+		 */
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			struct ieee80211_if_managed *ifmgd;
+			ifmgd = &sdata->u.mgd;
+
+			del_timer_sync(&ifmgd->timer);
+			del_timer_sync(&ifmgd->chswitch_timer);
+		}
+
 		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
 		    netif_running(sdata->dev)) {
@@ -60,11 +76,14 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 			conf.mac_addr = sdata->dev->dev_addr;
 			drv_remove_interface(local, &conf);
 		}
+
 	}
 
 	/* flush again, in case driver queued work */
 	flush_workqueue(local->hw.workqueue);
 
+	local->suspended = true;
+
 	/* stop hardware */
 	if (local->open_count) {
 		ieee80211_led_radio(local, false);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0689a8f..8d3d6c8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1121,12 +1121,21 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	}
 
 	/* add back keys */
-	list_for_each_entry(sdata, &local->interfaces, list)
+	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (netif_running(sdata->dev))
 			ieee80211_enable_keys(sdata);
+		if (local->suspended &&
+		    sdata->vif.type == NL80211_IFTYPE_STATION)
+			ieee80211_sta_setup_sdata_timers(sdata);
+	}
 
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
+	if (local->suspended) {
+		setup_timer(&local->dynamic_ps_timer,
+			    ieee80211_dynamic_ps_timer, (unsigned long) local);
+	}
+
 	return 0;
 }
-- 
1.6.0.6

