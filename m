Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760409AbZEOJw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 05:52:58 -0400
Subject: [PATCH] mac80211: move channel switch code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 May 2009 11:52:31 +0200
Message-Id: <1242381151.5799.46.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel switch code is currently in the spectrum
management file, where arguably it belongs. However,
it is for managed mode only and uses the structures
for that mode only so having it in a more generic
file can be confusing. Additionally, my next patch
gets simpler with the code here.

When/if we ever implement this for IBSS or mesh then
we will need to rework the structures it uses anyway
at which point we could move the code back.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |   11 +---
 net/mac80211/mlme.c        |   99 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/rx.c          |    5 +-
 net/mac80211/spectmgmt.c   |  101 ---------------------------------------------
 4 files changed, 105 insertions(+), 111 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-05-15 11:13:09.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-05-15 11:28:34.000000000 +0200
@@ -938,6 +938,9 @@ void ieee80211_send_pspoll(struct ieee80
 void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency);
 int ieee80211_max_network_latency(struct notifier_block *nb,
 				  unsigned long data, void *dummy);
+void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_channel_sw_ie *sw_elem,
+				      struct ieee80211_bss *bss);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
@@ -1035,14 +1038,6 @@ int __ieee80211_stop_tx_ba_session(struc
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
 				       size_t len);
-void ieee80211_chswitch_timer(unsigned long data);
-void ieee80211_chswitch_work(struct work_struct *work);
-void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
-				  struct ieee80211_channel_sw_ie *sw_elem,
-				  struct ieee80211_bss *bss);
-void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
-				 u16 capab_info, u8 *pwr_constr_elem,
-				 u8 pwr_constr_elem_len);
 
 /* Suspend/resume and hw reconfiguration */
 int ieee80211_reconfig(struct ieee80211_local *local);
--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-15 11:14:27.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-15 11:28:34.000000000 +0200
@@ -482,6 +482,103 @@ void ieee80211_send_nullfunc(struct ieee
 	ieee80211_tx_skb(sdata, skb, 0);
 }
 
+/* spectrum management related things */
+static void ieee80211_chswitch_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
+	struct ieee80211_bss *bss;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	if (!netif_running(sdata->dev))
+		return;
+
+	bss = ieee80211_rx_bss_get(sdata->local, ifmgd->bssid,
+				   sdata->local->hw.conf.channel->center_freq,
+				   ifmgd->ssid, ifmgd->ssid_len);
+	if (!bss)
+		goto exit;
+
+	sdata->local->oper_channel = sdata->local->csa_channel;
+	/* XXX: shouldn't really modify cfg80211-owned data! */
+	if (!ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL))
+		bss->cbss.channel = sdata->local->oper_channel;
+
+	ieee80211_rx_bss_put(sdata->local, bss);
+exit:
+	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+}
+
+static void ieee80211_chswitch_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata =
+		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	queue_work(sdata->local->hw.workqueue, &ifmgd->chswitch_work);
+}
+
+void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_channel_sw_ie *sw_elem,
+				      struct ieee80211_bss *bss)
+{
+	struct ieee80211_channel *new_ch;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num);
+
+	if (ifmgd->state != IEEE80211_STA_MLME_ASSOCIATED)
+		return;
+
+	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
+		return;
+
+	/* Disregard subsequent beacons if we are already running a timer
+	   processing a CSA */
+
+	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
+		return;
+
+	new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
+	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED)
+		return;
+
+	sdata->local->csa_channel = new_ch;
+
+	if (sw_elem->count <= 1) {
+		queue_work(sdata->local->hw.workqueue, &ifmgd->chswitch_work);
+	} else {
+		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+		ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
+		mod_timer(&ifmgd->chswitch_timer,
+			  jiffies +
+			  msecs_to_jiffies(sw_elem->count *
+					   bss->cbss.beacon_interval));
+	}
+}
+
+static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
+					u16 capab_info, u8 *pwr_constr_elem,
+					u8 pwr_constr_elem_len)
+{
+	struct ieee80211_conf *conf = &sdata->local->hw.conf;
+
+	if (!(capab_info & WLAN_CAPABILITY_SPECTRUM_MGMT))
+		return;
+
+	/* Power constraint IE length should be 1 octet */
+	if (pwr_constr_elem_len != 1)
+		return;
+
+	if ((*pwr_constr_elem <= conf->channel->max_power) &&
+	    (*pwr_constr_elem != sdata->local->power_constr_level)) {
+		sdata->local->power_constr_level = *pwr_constr_elem;
+		ieee80211_hw_config(sdata->local, 0);
+	}
+}
+
 /* powersave */
 static void ieee80211_enable_ps(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
@@ -1739,7 +1836,7 @@ static void ieee80211_rx_bss_info(struct
 	    (memcmp(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN) == 0)) {
 		struct ieee80211_channel_sw_ie *sw_elem =
 			(struct ieee80211_channel_sw_ie *)elems->ch_switch_elem;
-		ieee80211_process_chanswitch(sdata, sw_elem, bss);
+		ieee80211_sta_process_chanswitch(sdata, sw_elem, bss);
 	}
 
 	ieee80211_rx_bss_put(local, bss);
--- wireless-testing.orig/net/mac80211/spectmgmt.c	2009-05-15 11:13:23.000000000 +0200
+++ wireless-testing/net/mac80211/spectmgmt.c	2009-05-15 11:15:40.000000000 +0200
@@ -84,104 +84,3 @@ void ieee80211_process_measurement_req(s
 			mgmt->sa, mgmt->bssid,
 			mgmt->u.action.u.measurement.dialog_token);
 }
-
-void ieee80211_chswitch_work(struct work_struct *work)
-{
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
-	struct ieee80211_bss *bss;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-
-	if (!netif_running(sdata->dev))
-		return;
-
-	bss = ieee80211_rx_bss_get(sdata->local, ifmgd->bssid,
-				   sdata->local->hw.conf.channel->center_freq,
-				   ifmgd->ssid, ifmgd->ssid_len);
-	if (!bss)
-		goto exit;
-
-	sdata->local->oper_channel = sdata->local->csa_channel;
-	/* XXX: shouldn't really modify cfg80211-owned data! */
-	if (!ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL))
-		bss->cbss.channel = sdata->local->oper_channel;
-
-	ieee80211_rx_bss_put(sdata->local, bss);
-exit:
-	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
-	ieee80211_wake_queues_by_reason(&sdata->local->hw,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
-}
-
-void ieee80211_chswitch_timer(unsigned long data)
-{
-	struct ieee80211_sub_if_data *sdata =
-		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-
-	queue_work(sdata->local->hw.workqueue, &ifmgd->chswitch_work);
-}
-
-void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
-				  struct ieee80211_channel_sw_ie *sw_elem,
-				  struct ieee80211_bss *bss)
-{
-	struct ieee80211_channel *new_ch;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num);
-
-	/* FIXME: Handle ADHOC later */
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return;
-
-	if (ifmgd->state != IEEE80211_STA_MLME_ASSOCIATED)
-		return;
-
-	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
-		return;
-
-	/* Disregard subsequent beacons if we are already running a timer
-	   processing a CSA */
-
-	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
-		return;
-
-	new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
-	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED)
-		return;
-
-	sdata->local->csa_channel = new_ch;
-
-	if (sw_elem->count <= 1) {
-		queue_work(sdata->local->hw.workqueue, &ifmgd->chswitch_work);
-	} else {
-		ieee80211_stop_queues_by_reason(&sdata->local->hw,
-						IEEE80211_QUEUE_STOP_REASON_CSA);
-		ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
-		mod_timer(&ifmgd->chswitch_timer,
-			  jiffies +
-			  msecs_to_jiffies(sw_elem->count *
-					   bss->cbss.beacon_interval));
-	}
-}
-
-void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
-				 u16 capab_info, u8 *pwr_constr_elem,
-				 u8 pwr_constr_elem_len)
-{
-	struct ieee80211_conf *conf = &sdata->local->hw.conf;
-
-	if (!(capab_info & WLAN_CAPABILITY_SPECTRUM_MGMT))
-		return;
-
-	/* Power constraint IE length should be 1 octet */
-	if (pwr_constr_elem_len != 1)
-		return;
-
-	if ((*pwr_constr_elem <= conf->channel->max_power) &&
-	    (*pwr_constr_elem != sdata->local->power_constr_level)) {
-		sdata->local->power_constr_level = *pwr_constr_elem;
-		ieee80211_hw_config(sdata->local, 0);
-	}
-}
-
--- wireless-testing.orig/net/mac80211/rx.c	2009-05-15 11:18:11.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-05-15 11:20:04.000000000 +0200
@@ -1846,6 +1846,9 @@ ieee80211_rx_h_action(struct ieee80211_r
 				   sizeof(mgmt->u.action.u.chan_switch)))
 				return RX_DROP_MONITOR;
 
+			if (sdata->vif.type != NL80211_IFTYPE_STATION)
+				return RX_DROP_MONITOR;
+
 			if (memcmp(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN))
 				return RX_DROP_MONITOR;
 
@@ -1856,7 +1859,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 			if (!bss)
 				return RX_DROP_MONITOR;
 
-			ieee80211_process_chanswitch(sdata,
+			ieee80211_sta_process_chanswitch(sdata,
 				     &mgmt->u.action.u.chan_switch.sw_elem, bss);
 			ieee80211_rx_bss_put(local, bss);
 			break;


