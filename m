Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab2CBO5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 09:57:04 -0500
Subject: [PATCH] mac80211: combine QoS with other BSS changes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 15:56:59 +0100
Message-ID: <1330700219.8542.19.camel@jlt3.sipsolutions.net> (sfid-20120302_155708_155170_5AF956E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When associating and particularly when disassociating
there's no need to notify the driver about changes
with multiple calls to bss_info_changed, we should
combine the QoS enabling/disabling into the same call
as otherwise the driver could get confused about QoS
suddenly getting disabled while connected.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/iface.c       |    2 +-
 net/mac80211/mlme.c        |   12 ++++++++----
 net/mac80211/util.c        |    9 ++++++---
 4 files changed, 17 insertions(+), 9 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2012-03-02 13:28:10.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2012-03-02 15:56:06.000000000 +0100
@@ -1348,7 +1348,8 @@ int ieee80211_frame_duration(struct ieee
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
 				     gfp_t gfp);
-void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
+void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
+			       bool bss_notify);
 void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 
 void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
--- a/net/mac80211/iface.c	2012-02-29 11:02:37.000000000 +0100
+++ b/net/mac80211/iface.c	2012-03-02 15:56:06.000000000 +0100
@@ -304,7 +304,7 @@ static int ieee80211_do_open(struct net_
 		 * need to initialise the hardware if the hardware
 		 * doesn't start up with sane defaults
 		 */
-		ieee80211_set_wmm_default(sdata);
+		ieee80211_set_wmm_default(sdata, true);
 	}
 
 	set_bit(SDATA_STATE_RUNNING, &sdata->state);
--- a/net/mac80211/mlme.c	2012-03-02 13:28:10.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-02 15:56:06.000000000 +0100
@@ -1277,7 +1277,6 @@ static void ieee80211_sta_wmm_params(str
 
 	/* enable WMM or activate new settings */
 	sdata->vif.bss_conf.qos = true;
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
 }
 
 static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
@@ -1455,8 +1454,6 @@ static void ieee80211_set_disassoc(struc
 	changed |= BSS_CHANGED_ASSOC;
 	sdata->vif.bss_conf.assoc = false;
 
-	ieee80211_set_wmm_default(sdata);
-
 	/* channel(_type) changes are handled by ieee80211_hw_config */
 	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
 
@@ -1484,10 +1481,16 @@ static void ieee80211_set_disassoc(struc
 		changed |= BSS_CHANGED_ARP_FILTER;
 	}
 
+	sdata->vif.bss_conf.qos = false;
+	changed |= BSS_CHANGED_QOS;
+
 	/* The BSSID (not really interesting) and HT changed */
 	changed |= BSS_CHANGED_BSSID | BSS_CHANGED_HT;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
+	/* disassociated - set to defaults now */
+	ieee80211_set_wmm_default(sdata, false);
+
 	del_timer_sync(&sdata->u.mgd.conn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.timer);
@@ -2155,7 +2158,8 @@ static bool ieee80211_assoc_success(stru
 		ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
 					 elems.wmm_param_len);
 	else
-		ieee80211_set_wmm_default(sdata);
+		ieee80211_set_wmm_default(sdata, false);
+	changed |= BSS_CHANGED_QOS;
 
 	if (elems.ht_info_elem && elems.wmm_param &&
 	    (sdata->local->hw.queues >= 4) &&
--- a/net/mac80211/util.c	2012-02-29 11:02:37.000000000 +0100
+++ b/net/mac80211/util.c	2012-03-02 15:56:06.000000000 +0100
@@ -737,7 +737,8 @@ void ieee802_11_parse_elems(u8 *start, s
 	ieee802_11_parse_elems_crc(start, len, elems, 0, 0);
 }
 
-void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
+void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
+			       bool bss_notify)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_queue_params qparam;
@@ -807,7 +808,9 @@ void ieee80211_set_wmm_default(struct ie
 	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 		sdata->vif.bss_conf.qos =
 			sdata->vif.type != NL80211_IFTYPE_STATION;
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
+		if (bss_notify)
+			ieee80211_bss_info_change_notify(sdata,
+							 BSS_CHANGED_QOS);
 	}
 }
 
@@ -829,7 +832,7 @@ void ieee80211_sta_def_wmm_params(struct
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
-	ieee80211_set_wmm_default(sdata);
+	ieee80211_set_wmm_default(sdata, true);
 }
 
 u32 ieee80211_mandatory_rates(struct ieee80211_local *local,


