Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50221 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758283Ab2CTOkP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:40:15 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Mar 2012 13:11:03 +0100
Subject: [RFC 11/12] mac80211: split offchannel functions to per-vif
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <ccb26d54-38f2-478e-95d9-85fa1aea62c2@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_154026_591857_E0DB8EEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for multi-channel operation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/ieee80211_i.h |    4 ++
 net/mac80211/offchannel.c  |  122 ++++++++++++++++++++++++--------------------
 2 files changed, 70 insertions(+), 56 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4ceedff..58ee794 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1280,8 +1280,12 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
+void ieee80211_offchannel_stop_vif(struct ieee80211_sub_if_data *sdata,
+				   bool offchannel_ps_enable);
 void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 				    bool offchannel_ps_enable);
+void ieee80211_offchannel_return_vif(struct ieee80211_sub_if_data *sdata,
+				     bool offchannel_ps_disable);
 void ieee80211_offchannel_return_vifs(struct ieee80211_local *local,
 				      bool offchannel_ps_disable);
 void ieee80211_hw_roc_setup(struct ieee80211_local *local);
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 06a809d..a5a5f1d 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -103,6 +103,31 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
+void ieee80211_offchannel_stop_vif(struct ieee80211_sub_if_data *sdata,
+				   bool offchannel_ps_enable)
+{
+	if (!ieee80211_sdata_running(sdata))
+		return;
+
+	if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
+		set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
+
+	/* Check to see if we should disable beaconing. */
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+	    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+		ieee80211_bss_info_change_notify(
+			sdata, BSS_CHANGED_BEACON_ENABLED);
+
+	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
+		netif_tx_stop_all_queues(sdata->dev);
+		if (offchannel_ps_enable &&
+		    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
+		    sdata->u.mgd.associated)
+			ieee80211_offchannel_ps_enable(sdata, true);
+	}
+}
+
 void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 				    bool offchannel_ps_enable)
 {
@@ -113,71 +138,56 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 	 * STA interfaces.
 	 */
 	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
-			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
-
-		/* Check to see if we should disable beaconing. */
-		if (sdata->vif.type == NL80211_IFTYPE_AP ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
-			ieee80211_bss_info_change_notify(
-				sdata, BSS_CHANGED_BEACON_ENABLED);
-
-		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
-			netif_tx_stop_all_queues(sdata->dev);
-			if (offchannel_ps_enable &&
-			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
-			    sdata->u.mgd.associated)
-				ieee80211_offchannel_ps_enable(sdata, true);
-		}
-	}
+	list_for_each_entry(sdata, &local->interfaces, list)
+		ieee80211_offchannel_stop_vif(sdata, offchannel_ps_enable);
 	mutex_unlock(&local->iflist_mtx);
 }
 
+void ieee80211_offchannel_return_vif(struct ieee80211_sub_if_data *sdata,
+				     bool offchannel_ps_disable)
+{
+	if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
+		clear_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
+
+	if (!ieee80211_sdata_running(sdata))
+		return;
+
+	/* Tell AP we're back */
+	if (offchannel_ps_disable &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION) {
+		if (sdata->u.mgd.associated)
+			ieee80211_offchannel_ps_disable(sdata);
+	}
+
+	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
+		/*
+		 * This may wake up queues even though the driver
+		 * currently has them stopped. This is not very
+		 * likely, since the driver won't have gotten any
+		 * (or hardly any) new packets while we weren't
+		 * on the right channel, and even if it happens
+		 * it will at most lead to queueing up one more
+		 * packet per queue in mac80211 rather than on
+		 * the interface qdisc.
+		 */
+		netif_tx_wake_all_queues(sdata->dev);
+	}
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+	    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+		ieee80211_bss_info_change_notify(
+			sdata, BSS_CHANGED_BEACON_ENABLED);
+}
+
 void ieee80211_offchannel_return_vifs(struct ieee80211_local *local,
 				      bool offchannel_ps_disable)
 {
 	struct ieee80211_sub_if_data *sdata;
 
 	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
-			clear_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
-
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		/* Tell AP we're back */
-		if (offchannel_ps_disable &&
-		    sdata->vif.type == NL80211_IFTYPE_STATION) {
-			if (sdata->u.mgd.associated)
-				ieee80211_offchannel_ps_disable(sdata);
-		}
-
-		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
-			/*
-			 * This may wake up queues even though the driver
-			 * currently has them stopped. This is not very
-			 * likely, since the driver won't have gotten any
-			 * (or hardly any) new packets while we weren't
-			 * on the right channel, and even if it happens
-			 * it will at most lead to queueing up one more
-			 * packet per queue in mac80211 rather than on
-			 * the interface qdisc.
-			 */
-			netif_tx_wake_all_queues(sdata->dev);
-		}
-
-		if (sdata->vif.type == NL80211_IFTYPE_AP ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
-			ieee80211_bss_info_change_notify(
-				sdata, BSS_CHANGED_BEACON_ENABLED);
-	}
+	list_for_each_entry(sdata, &local->interfaces, list)
+		ieee80211_offchannel_return_vif(sdata, offchannel_ps_disable);
 	mutex_unlock(&local->iflist_mtx);
 }
 
-- 
1.7.0.4

