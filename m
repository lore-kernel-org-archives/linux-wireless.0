Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbZLDOvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 09:51:38 -0500
Message-Id: <20091204143702.661741216@sipsolutions.net>
Date: Fri, 04 Dec 2009 15:35:45 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 1/4] mac80211: Generalize off-channel operation helpers
 from scan code
References: <20091204143544.034718060@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jouni Malinen <jouni.malinen@atheros.com>

The off-channel operations for going into power save mode (station
mode) or stop beaconing (AP/IBSS) are not limited to scanning. Move
these into a separate file and allow them to be used for other
purposes, too.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Makefile      |    2 
 net/mac80211/ieee80211_i.h |    6 +
 net/mac80211/offchannel.c  |  152 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/scan.c        |  144 +-----------------------------------------
 4 files changed, 165 insertions(+), 139 deletions(-)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/mac80211/offchannel.c	2009-12-04 13:01:32.000000000 +0100
@@ -0,0 +1,152 @@
+/*
+ * Off-channel operation helpers
+ *
+ * Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright 2004, Instant802 Networks, Inc.
+ * Copyright 2005, Devicescape Software, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
+ * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+
+/*
+ * inform AP that we will go to sleep so that it will buffer the frames
+ * while we scan
+ */
+static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	bool ps = false;
+
+	/* FIXME: what to do when local->pspolling is true? */
+
+	del_timer_sync(&local->dynamic_ps_timer);
+	cancel_work_sync(&local->dynamic_ps_enable_work);
+
+	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+		ps = true;
+		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
+
+	if (!ps || !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
+		/*
+		 * If power save was enabled, no need to send a nullfunc
+		 * frame because AP knows that we are sleeping. But if the
+		 * hardware is creating the nullfunc frame for power save
+		 * status (ie. IEEE80211_HW_PS_NULLFUNC_STACK is not
+		 * enabled) and power save was enabled, the firmware just
+		 * sent a null frame with power save disabled. So we need
+		 * to send a new nullfunc frame to inform the AP that we
+		 * are again sleeping.
+		 */
+		ieee80211_send_nullfunc(local, sdata, 1);
+}
+
+/* inform AP that we are awake again, unless power save is enabled */
+static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	if (!local->ps_sdata)
+		ieee80211_send_nullfunc(local, sdata, 0);
+	else {
+		/*
+		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
+		 * will send a nullfunc frame with the powersave bit set
+		 * even though the AP already knows that we are sleeping.
+		 * This could be avoided by sending a null frame with power
+		 * save bit disabled before enabling the power save, but
+		 * this doesn't gain anything.
+		 *
+		 * When IEEE80211_HW_PS_NULLFUNC_STACK is enabled, no need
+		 * to send a nullfunc frame because AP already knows that
+		 * we are sleeping, let's just enable power save mode in
+		 * hardware.
+		 */
+		local->hw.conf.flags |= IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
+}
+
+void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		/* disable beaconing */
+		if (sdata->vif.type == NL80211_IFTYPE_AP ||
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+			ieee80211_bss_info_change_notify(
+				sdata, BSS_CHANGED_BEACON_ENABLED);
+
+		/*
+		 * only handle non-STA interfaces here, STA interfaces
+		 * are handled in ieee80211_offchannel_stop_station(),
+		 * e.g., from the background scan state machine
+		 */
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			netif_stop_queue(sdata->dev);
+	}
+	mutex_unlock(&local->iflist_mtx);
+}
+
+void ieee80211_offchannel_stop_station(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	/*
+	 * notify the AP about us leaving the channel and stop all STA interfaces
+	 */
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			netif_stop_queue(sdata->dev);
+			if (sdata->u.mgd.associated)
+				ieee80211_offchannel_ps_enable(sdata);
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+}
+
+void ieee80211_offchannel_return(struct ieee80211_local *local,
+				 bool enable_beaconing)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		/* Tell AP we're back */
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			if (sdata->u.mgd.associated)
+				ieee80211_offchannel_ps_disable(sdata);
+			netif_wake_queue(sdata->dev);
+		}
+
+		/* re-enable beaconing */
+		if (enable_beaconing &&
+		    (sdata->vif.type == NL80211_IFTYPE_AP ||
+		     sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+		     sdata->vif.type == NL80211_IFTYPE_MESH_POINT))
+			ieee80211_bss_info_change_notify(
+				sdata, BSS_CHANGED_BEACON_ENABLED);
+	}
+	mutex_unlock(&local->iflist_mtx);
+}
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-12-04 12:44:37.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-12-04 13:01:32.000000000 +0100
@@ -980,6 +980,12 @@ ieee80211_rx_bss_get(struct ieee80211_lo
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss);
 
+/* off-channel helpers */
+void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local);
+void ieee80211_offchannel_stop_station(struct ieee80211_local *local);
+void ieee80211_offchannel_return(struct ieee80211_local *local,
+				 bool enable_beaconing);
+
 /* interface handling */
 int ieee80211_iface_init(void);
 void ieee80211_iface_exit(void);
--- wireless-testing.orig/net/mac80211/scan.c	2009-12-04 12:44:37.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-12-04 13:01:24.000000000 +0100
@@ -227,70 +227,9 @@ static bool ieee80211_prep_hw_scan(struc
 	return true;
 }
 
-/*
- * inform AP that we will go to sleep so that it will buffer the frames
- * while we scan
- */
-static void ieee80211_scan_ps_enable(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_local *local = sdata->local;
-	bool ps = false;
-
-	/* FIXME: what to do when local->pspolling is true? */
-
-	del_timer_sync(&local->dynamic_ps_timer);
-	cancel_work_sync(&local->dynamic_ps_enable_work);
-
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-		ps = true;
-		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	}
-
-	if (!ps || !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
-		/*
-		 * If power save was enabled, no need to send a nullfunc
-		 * frame because AP knows that we are sleeping. But if the
-		 * hardware is creating the nullfunc frame for power save
-		 * status (ie. IEEE80211_HW_PS_NULLFUNC_STACK is not
-		 * enabled) and power save was enabled, the firmware just
-		 * sent a null frame with power save disabled. So we need
-		 * to send a new nullfunc frame to inform the AP that we
-		 * are again sleeping.
-		 */
-		ieee80211_send_nullfunc(local, sdata, 1);
-}
-
-/* inform AP that we are awake again, unless power save is enabled */
-static void ieee80211_scan_ps_disable(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_local *local = sdata->local;
-
-	if (!local->ps_sdata)
-		ieee80211_send_nullfunc(local, sdata, 0);
-	else {
-		/*
-		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
-		 * will send a nullfunc frame with the powersave bit set
-		 * even though the AP already knows that we are sleeping.
-		 * This could be avoided by sending a null frame with power
-		 * save bit disabled before enabling the power save, but
-		 * this doesn't gain anything.
-		 *
-		 * When IEEE80211_HW_PS_NULLFUNC_STACK is enabled, no need
-		 * to send a nullfunc frame because AP already knows that
-		 * we are sleeping, let's just enable power save mode in
-		 * hardware.
-		 */
-		local->hw.conf.flags |= IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	}
-}
-
 void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
 	bool was_hw_scan;
 
 	mutex_lock(&local->scan_mtx);
@@ -339,28 +278,7 @@ void ieee80211_scan_completed(struct iee
 
 	drv_sw_scan_complete(local);
 
-	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		/* Tell AP we're back */
-		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			if (sdata->u.mgd.associated) {
-				ieee80211_scan_ps_disable(sdata);
-				netif_wake_queue(sdata->dev);
-			}
-		} else
-			netif_wake_queue(sdata->dev);
-
-		/* re-enable beaconing */
-		if (sdata->vif.type == NL80211_IFTYPE_AP ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
-			ieee80211_bss_info_change_notify(
-				sdata, BSS_CHANGED_BEACON_ENABLED);
-	}
-	mutex_unlock(&local->iflist_mtx);
+	ieee80211_offchannel_return(local, true);
 
  done:
 	ieee80211_recalc_idle(local);
@@ -372,8 +290,6 @@ EXPORT_SYMBOL(ieee80211_scan_completed);
 
 static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata;
-
 	/*
 	 * Hardware/driver doesn't support hw_scan, so use software
 	 * scanning instead. First send a nullfunc frame with power save
@@ -389,26 +305,7 @@ static int ieee80211_start_sw_scan(struc
 	 */
 	drv_sw_scan_start(local);
 
-	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		/* disable beaconing */
-		if (sdata->vif.type == NL80211_IFTYPE_AP ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
-			ieee80211_bss_info_change_notify(
-				sdata, BSS_CHANGED_BEACON_ENABLED);
-
-		/*
-		 * only handle non-STA interfaces here, STA interfaces
-		 * are handled in the scan state machine
-		 */
-		if (sdata->vif.type != NL80211_IFTYPE_STATION)
-			netif_stop_queue(sdata->dev);
-	}
-	mutex_unlock(&local->iflist_mtx);
+	ieee80211_offchannel_stop_beaconing(local);
 
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
@@ -556,23 +453,7 @@ static int ieee80211_scan_state_decision
 static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
 						    unsigned long *next_delay)
 {
-	struct ieee80211_sub_if_data *sdata;
-
-	/*
-	 * notify the AP about us leaving the channel and stop all STA interfaces
-	 */
-	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			netif_stop_queue(sdata->dev);
-			if (sdata->u.mgd.associated)
-				ieee80211_scan_ps_enable(sdata);
-		}
-	}
-	mutex_unlock(&local->iflist_mtx);
+	ieee80211_offchannel_stop_station(local);
 
 	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
 
@@ -592,28 +473,15 @@ static void ieee80211_scan_state_leave_o
 static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *local,
 						    unsigned long *next_delay)
 {
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
-
 	/* switch back to the operating channel */
 	local->scan_channel = NULL;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	/*
-	 * notify the AP about us being back and restart all STA interfaces
+	 * Only re-enable station mode interface now; beaconing will be
+	 * re-enabled once the full scan has been completed.
 	 */
-	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		/* Tell AP we're back */
-		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			if (sdata->u.mgd.associated)
-				ieee80211_scan_ps_disable(sdata);
-			netif_wake_queue(sdata->dev);
-		}
-	}
-	mutex_unlock(&local->iflist_mtx);
+	ieee80211_offchannel_return(local, false);
 
 	__clear_bit(SCAN_OFF_CHANNEL, &local->scanning);
 
--- wireless-testing.orig/net/mac80211/Makefile	2009-12-04 12:44:35.000000000 +0100
+++ wireless-testing/net/mac80211/Makefile	2009-12-04 13:01:24.000000000 +0100
@@ -6,7 +6,7 @@ mac80211-y := \
 	sta_info.o \
 	wep.o \
 	wpa.o \
-	scan.o \
+	scan.o offchannel.o \
 	ht.o agg-tx.o agg-rx.o \
 	ibss.o \
 	mlme.o work.o \


