Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab2HAPVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 11:21:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 7/8] mac80211: support extended channel switch
Date: Wed,  1 Aug 2012 17:21:26 +0200
Message-Id: <1343834487-23737-8-git-send-email-johannes@sipsolutions.net> (sfid-20120801_172147_974221_8FCD5197)
In-Reply-To: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
References: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Support extended channel switch when the operating
class is one of the global operating classes as
defined in Annex E of 802.11-2012. If it isn't,
disconnect from the AP instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h  |   12 ++++++
 net/mac80211/ieee80211_i.h |    6 +--
 net/mac80211/mlme.c        |   93 +++++++++++++++++++++++++++++++-------------
 net/mac80211/util.c        |    7 ++++
 4 files changed, 87 insertions(+), 31 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index e02fc68..0c7190b 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -638,6 +638,18 @@ struct ieee80211_channel_sw_ie {
 } __attribute__ ((packed));
 
 /**
+ * struct ieee80211_ext_chansw_ie
+ *
+ * This structure represents the "Extended Channel Switch Announcement element"
+ */
+struct ieee80211_ext_chansw_ie {
+	u8 mode;
+	u8 new_operating_class;
+	u8 new_ch_num;
+	u8 count;
+} __packed;
+
+/**
  * struct ieee80211_tim
  *
  * This structure refers to "Traffic Indication Map information element"
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 585827e..a096d26 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -405,6 +405,7 @@ struct ieee80211_if_managed {
 	struct work_struct monitor_work;
 	struct work_struct chswitch_work;
 	struct work_struct beacon_connection_loss_work;
+	struct work_struct csa_connection_drop_work;
 
 	unsigned long beacon_timeout;
 	unsigned long probe_timeout;
@@ -1131,6 +1132,7 @@ struct ieee802_11_elems {
 	u8 *perr;
 	struct ieee80211_rann_ie *rann;
 	struct ieee80211_channel_sw_ie *ch_switch_ie;
+	struct ieee80211_ext_chansw_ie *ext_chansw_ie;
 	u8 *country_elem;
 	u8 *pwr_constr_elem;
 	u8 *quiet_elem;	/* first quite element */
@@ -1204,10 +1206,6 @@ void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata);
 int ieee80211_max_network_latency(struct notifier_block *nb,
 				  unsigned long data, void *dummy);
 int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata);
-void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
-				      struct ieee80211_channel_sw_ie *sw_elem,
-				      struct ieee80211_bss *bss,
-				      u64 timestamp);
 void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7451dd4..cc76481 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -757,17 +757,17 @@ static void ieee80211_chswitch_timer(unsigned long data)
 	ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 }
 
-void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
-				      struct ieee80211_channel_sw_ie *sw_elem,
-				      struct ieee80211_bss *bss,
-				      u64 timestamp)
+static void
+ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
+				 u8 new_chan_no, u8 count, u8 mode,
+				 enum ieee80211_band new_band,
+				 struct ieee80211_bss *bss, u64 timestamp)
 {
 	struct cfg80211_bss *cbss =
 		container_of((void *)bss, struct cfg80211_bss, priv);
 	struct ieee80211_channel *new_ch;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num,
-						      cbss->channel->band);
+	int new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
 
 	ASSERT_MGD_MTX(ifmgd);
 
@@ -791,7 +791,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
 
-	if (sw_elem->mode)
+	if (mode)
 		ieee80211_stop_queues_by_reason(&sdata->local->hw,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
 
@@ -799,9 +799,9 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		/* use driver's channel switch callback */
 		struct ieee80211_channel_switch ch_switch = {
 			.timestamp = timestamp,
-			.block_tx = sw_elem->mode,
+			.block_tx = mode,
 			.channel = new_ch,
-			.count = sw_elem->count,
+			.count = count,
 		};
 
 		drv_channel_switch(sdata->local, &ch_switch);
@@ -809,12 +809,11 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* channel switch handled in software */
-	if (sw_elem->count <= 1)
+	if (count <= 1)
 		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 	else
 		mod_timer(&ifmgd->chswitch_timer,
-			  TU_TO_EXP_TIME(sw_elem->count *
-					 cbss->beacon_interval));
+			  TU_TO_EXP_TIME(count * cbss->beacon_interval));
 }
 
 static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
@@ -1689,7 +1688,8 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_ap_probereq_get);
 
-static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
+static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata,
+				   bool transmit_frame)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
@@ -1701,12 +1701,9 @@ static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 
-	sdata_info(sdata, "Connection to AP %pM lost\n",
-		   ifmgd->associated->bssid);
-
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
-			       false, frame_buf);
+			       transmit_frame, frame_buf);
 	mutex_unlock(&ifmgd->mtx);
 
 	/*
@@ -1736,10 +1733,22 @@ static void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 		rcu_read_unlock();
 	}
 
-	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
-		__ieee80211_connection_loss(sdata);
-	else
+	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR) {
+		sdata_info(sdata, "Connection to AP %pM lost\n",
+			   ifmgd->bssid);
+		__ieee80211_disconnect(sdata, false);
+	} else {
 		ieee80211_mgd_probe_ap(sdata, true);
+	}
+}
+
+static void ieee80211_csa_connection_drop_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.csa_connection_drop_work);
+
+	__ieee80211_disconnect(sdata, true);
 }
 
 void ieee80211_beacon_loss(struct ieee80211_vif *vif)
@@ -2230,10 +2239,14 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  bool beacon)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	int freq;
 	struct ieee80211_bss *bss;
 	struct ieee80211_channel *channel;
 	bool need_ps = false;
+	enum ieee80211_band band;
+
+	lockdep_assert_held(&sdata->u.mgd.mtx);
 
 	if (sdata->u.mgd.associated &&
 	    ether_addr_equal(mgmt->bssid, sdata->u.mgd.associated->bssid)) {
@@ -2267,10 +2280,30 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		mutex_unlock(&local->iflist_mtx);
 	}
 
-	if (elems->ch_switch_ie &&
-	    memcmp(mgmt->bssid, sdata->u.mgd.associated->bssid, ETH_ALEN) == 0)
-		ieee80211_sta_process_chanswitch(sdata, elems->ch_switch_ie,
-						 bss, rx_status->mactime);
+	if (memcmp(mgmt->bssid, sdata->u.mgd.associated->bssid, ETH_ALEN))
+		return;
+
+	if (elems->ext_chansw_ie) {
+		if (ieee80211_operating_class_to_band(
+				elems->ext_chansw_ie->new_operating_class,
+				&band)) {
+			ieee80211_sta_process_chanswitch(sdata,
+				elems->ext_chansw_ie->new_ch_num,
+				elems->ext_chansw_ie->count,
+				elems->ext_chansw_ie->mode,
+				band, bss, rx_status->mactime);
+		} else {
+			sdata_info(sdata,
+				   "cannot understand ECSA IE, disconnecting\n");
+			ieee80211_queue_work(&local->hw,
+					     &ifmgd->csa_connection_drop_work);
+		}
+	} else if (elems->ch_switch_ie)
+		ieee80211_sta_process_chanswitch(sdata,
+			elems->ch_switch_ie->new_ch_num,
+			elems->ch_switch_ie->count,
+			elems->ch_switch_ie->mode,
+			channel->band, bss, rx_status->mactime);
 }
 
 
@@ -2580,9 +2613,12 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		switch (mgmt->u.action.category) {
 		case WLAN_CATEGORY_SPECTRUM_MGMT:
 			ieee80211_sta_process_chanswitch(sdata,
-					&mgmt->u.action.u.chan_switch.sw_elem,
-					(void *)ifmgd->associated->priv,
-					rx_status->mactime);
+				mgmt->u.action.u.chan_switch.sw_elem.new_ch_num,
+				mgmt->u.action.u.chan_switch.sw_elem.count,
+				mgmt->u.action.u.chan_switch.sw_elem.mode,
+				rx_status->band,
+				(void *)ifmgd->associated->priv,
+				rx_status->mactime);
 			break;
 		}
 	}
@@ -2925,6 +2961,7 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 
 	cancel_work_sync(&ifmgd->monitor_work);
 	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+	cancel_work_sync(&ifmgd->csa_connection_drop_work);
 	if (del_timer_sync(&ifmgd->timer))
 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
 
@@ -2981,6 +3018,8 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
 	INIT_WORK(&ifmgd->beacon_connection_loss_work,
 		  ieee80211_beacon_connection_loss_work);
+	INIT_WORK(&ifmgd->csa_connection_drop_work,
+		  ieee80211_csa_connection_drop_work);
 	INIT_WORK(&ifmgd->request_smps_work, ieee80211_request_smps_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7dff94e..f7f6cc5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -774,6 +774,13 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			}
 			elems->ch_switch_ie = (void *)pos;
 			break;
+		case WLAN_EID_EXT_CHANSWITCH_ANN:
+			if (elen != sizeof(struct ieee80211_ext_chansw_ie)) {
+				elem_parse_failed = true;
+				break;
+			}
+			elems->ext_chansw_ie = (void *)pos;
+			break;
 		case WLAN_EID_QUIET:
 			if (!elems->quiet_elem) {
 				elems->quiet_elem = pos;
-- 
1.7.10.4

