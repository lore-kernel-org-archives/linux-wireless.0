Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935355Ab3DJMnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 08:43:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/8] mac80211: unify CSA action frame/beacon processing
Date: Wed, 10 Apr 2013 14:43:36 +0200
Message-Id: <1365597822-27660-3-git-send-email-johannes@sipsolutions.net> (sfid-20130410_144406_770058_0DD921B8)
In-Reply-To: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
References: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

CSA action frame content should be processed as variable IEs
rather than fixed to make it extensible. Unify the code and
process them just like CSA in beacons to make it easier to
extend for HT/VHT.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h  |  4 +--
 net/mac80211/ieee80211_i.h |  4 ---
 net/mac80211/mlme.c        | 71 ++++++++++++++++++++++++++++------------------
 net/mac80211/rx.c          |  4 ---
 4 files changed, 44 insertions(+), 39 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index e46fea8..8f80b3a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -840,9 +840,7 @@ struct ieee80211_mgmt {
 				} __packed wme_action;
 				struct{
 					u8 action_code;
-					u8 element_id;
-					u8 length;
-					struct ieee80211_channel_sw_ie sw_elem;
+					u8 variable[0];
 				} __packed chan_switch;
 				struct{
 					u8 action_code;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8d5dcbf..373460f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1252,10 +1252,6 @@ void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata);
 int ieee80211_max_network_latency(struct notifier_block *nb,
 				  unsigned long data, void *dummy);
 int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata);
-void
-ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
-				 const struct ieee80211_channel_sw_ie *sw_elem,
-				 struct ieee80211_bss *bss, u64 timestamp);
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9979742..8cdf791 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1021,33 +1021,37 @@ static void ieee80211_chswitch_timer(unsigned long data)
 	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.chswitch_work);
 }
 
-void
+static void
 ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
-				 const struct ieee80211_channel_sw_ie *sw_elem,
-				 struct ieee80211_bss *bss, u64 timestamp)
+				 u64 timestamp, struct ieee802_11_elems *elems)
 {
-	struct cfg80211_bss *cbss =
-		container_of((void *)bss, struct cfg80211_bss, priv);
-	struct ieee80211_channel *new_ch;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num,
-						      cbss->channel->band);
+	struct cfg80211_bss *cbss = ifmgd->associated;
+	struct ieee80211_bss *bss;
+	struct ieee80211_channel *new_ch;
+	int new_freq;
 	struct ieee80211_chanctx *chanctx;
 
 	ASSERT_MGD_MTX(ifmgd);
 
-	if (!ifmgd->associated)
+	if (!cbss)
 		return;
 
 	if (sdata->local->scanning)
 		return;
 
-	/* Disregard subsequent beacons if we are already running a timer
-	   processing a CSA */
-
+	/* disregard subsequent announcements if we are already processing */
 	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
 		return;
 
+	if (!elems->ch_switch_ie)
+		return;
+
+	bss = (void *)cbss->priv;
+
+	new_freq = ieee80211_channel_to_frequency(
+			elems->ch_switch_ie->new_ch_num,
+			cbss->channel->band);
 	new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
 	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED) {
 		sdata_info(sdata,
@@ -1087,7 +1091,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	sdata->local->csa_channel = new_ch;
 
-	if (sw_elem->mode)
+	if (elems->ch_switch_ie->mode)
 		ieee80211_stop_queues_by_reason(&sdata->local->hw,
 				IEEE80211_MAX_QUEUE_MAP,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
@@ -1096,9 +1100,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		/* use driver's channel switch callback */
 		struct ieee80211_channel_switch ch_switch = {
 			.timestamp = timestamp,
-			.block_tx = sw_elem->mode,
+			.block_tx = elems->ch_switch_ie->mode,
 			.channel = new_ch,
-			.count = sw_elem->count,
+			.count = elems->ch_switch_ie->count,
 		};
 
 		drv_channel_switch(sdata->local, &ch_switch);
@@ -1106,11 +1110,11 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* channel switch handled in software */
-	if (sw_elem->count <= 1)
+	if (elems->ch_switch_ie->count <= 1)
 		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 	else
 		mod_timer(&ifmgd->chswitch_timer,
-			  TU_TO_EXP_TIME(sw_elem->count *
+			  TU_TO_EXP_TIME(elems->ch_switch_ie->count *
 					 cbss->beacon_interval));
 }
 
@@ -2656,7 +2660,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	if (bss)
 		ieee80211_rx_bss_put(local, bss);
 
-	if (!sdata->u.mgd.associated)
+	if (!sdata->u.mgd.associated ||
+	    !ether_addr_equal(mgmt->bssid, sdata->u.mgd.associated->bssid))
 		return;
 
 	if (need_ps) {
@@ -2665,10 +2670,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		mutex_unlock(&local->iflist_mtx);
 	}
 
-	if (elems->ch_switch_ie &&
-	    memcmp(mgmt->bssid, sdata->u.mgd.associated->bssid, ETH_ALEN) == 0)
-		ieee80211_sta_process_chanswitch(sdata, elems->ch_switch_ie,
-						 bss, rx_status->mactime);
+	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime, elems);
 }
 
 
@@ -3062,14 +3064,27 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		rma = ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len, &bss);
 		break;
 	case IEEE80211_STYPE_ACTION:
-		switch (mgmt->u.action.category) {
-		case WLAN_CATEGORY_SPECTRUM_MGMT:
+		if (mgmt->u.action.category == WLAN_CATEGORY_SPECTRUM_MGMT) {
+			struct ieee802_11_elems elems;
+			int ies_len = skb->len -
+				      offsetof(struct ieee80211_mgmt,
+					       u.action.u.chan_switch.variable);
+
+			if (ies_len < 0)
+				break;
+
+			ieee802_11_parse_elems(
+				mgmt->u.action.u.chan_switch.variable,
+				ies_len, &elems);
+
+			if (elems.parse_error)
+				break;
+
 			ieee80211_sta_process_chanswitch(sdata,
-					&mgmt->u.action.u.chan_switch.sw_elem,
-					(void *)ifmgd->associated->priv,
-					rx_status->mactime);
-			break;
+							 rx_status->mactime,
+							 &elems);
 		}
+		break;
 	}
 	mutex_unlock(&ifmgd->mtx);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5168f89..e9825f1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2507,10 +2507,6 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			ieee80211_process_measurement_req(sdata, mgmt, len);
 			goto handled;
 		case WLAN_ACTION_SPCT_CHL_SWITCH:
-			if (len < (IEEE80211_MIN_ACTION_SIZE +
-				   sizeof(mgmt->u.action.u.chan_switch)))
-				break;
-
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				break;
 
-- 
1.8.0

