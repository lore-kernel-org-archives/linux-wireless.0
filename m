Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40024 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1HHMKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 08:10:31 -0400
Received: by fxh19 with SMTP id 19so5310037fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 05:10:30 -0700 (PDT)
From: Alexander Simon <an.alexsimon@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mac80211: Add HT operation modes for IBSS
Date: Mon, 08 Aug 2011 14:10:27 +0200
Message-ID: <3091493.N5vzNRrbMZ@alex-1> (sfid-20110808_141034_452490_4BA26D5D)
In-Reply-To: <1888623.Vt5VZUN2cU@alex-1>
References: <1888623.Vt5VZUN2cU@alex-1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This means setting channel into HT mode and adding HT IEs in beacons.
Check if regdom allows this first.

If joining another HT network, use its HT mode.
If joining a non-HT network, use HT mode given by iw.
Join as legacy if neither iw nor remote beacon set an HT mode.
The same applies when merging with an older BSSID
(as it is basically leaving the current and joining the older BSSID).

If we receive a beacon from another station within our BSSID with a different HT
mode than us, we switch to its HT mode. If there are several stations with
different HT modes, it may take some time until all will have the same mode.
There is no way we can distinguish the "older" station.

Except for fixed channel mode, HT mode is also fixed. Join or merge ONLY if
channel AND HT mode matches.

And finally, allow frame aggregation in IBSS mode.

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---
 net/mac80211/agg-rx.c      |    2 +
 net/mac80211/agg-tx.c      |    5 +-
 net/mac80211/ht.c          |    2 +
 net/mac80211/ibss.c        |  166 +++++++++++++++++++++++++++++++++++++++----
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/rx.c          |    6 +-
 6 files changed, 164 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index fd1aaf2..057c2a1 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -184,6 +184,8 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index c8be8ef..247fb82 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -83,6 +83,8 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
@@ -380,7 +382,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	 */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-	    sdata->vif.type != NL80211_IFTYPE_AP)
+	    sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return -EINVAL;
 
 	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 7cfc286..211ebaf 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -203,6 +203,8 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 56c24ca..9f88183 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -35,6 +35,76 @@
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
+static bool ieee80211_can_use_ext_chan(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_channel *channel,
+				       enum nl80211_channel_type channel_type)
+{
+	/* check if we are legally allowed to use HT extension channel */
+	if ((channel_type == NL80211_CHAN_HT40PLUS) ||
+			(channel_type == NL80211_CHAN_HT40MINUS)) {
+		int sec_freq = channel->center_freq +
+			     (channel_type == NL80211_CHAN_HT40PLUS ? 20 : -20);
+		struct ieee80211_channel *sec_chan =
+			     ieee80211_get_channel(sdata->wdev.wiphy, sec_freq);
+		if (!sec_chan || sec_chan->flags & (IEEE80211_CHAN_DISABLED |
+					   IEEE80211_CHAN_PASSIVE_SCAN |
+					   IEEE80211_CHAN_NO_IBSS |
+					   IEEE80211_CHAN_RADAR)) {
+			return false;
+		}
+	}
+	return true;
+}
+
+static void ieee80211_update_ht_elems(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_mgmt *mgmt,
+				      struct ieee80211_ht_info *ht_info)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband =
+			local->hw.wiphy->bands[local->oper_channel->band];
+	enum nl80211_channel_type channel_type =
+			ieee80211_ht_info_to_channel_type(ht_info);
+
+	if (!ieee80211_can_use_ext_chan(sdata, local->oper_channel, channel_type))
+		channel_type = NL80211_CHAN_HT20;
+
+	if (channel_type != local->_oper_channel_type) {
+		struct sk_buff *skb = rcu_dereference_protected(
+				sdata->u.ibss.presp,
+				lockdep_is_held(&ifibss->mtx));
+		struct sk_buff *nskb;
+		u8 *ht_ie;
+
+		/* update HT IE. If not yet existing, create one */
+		nskb = skb_copy(skb, GFP_ATOMIC);
+		ht_ie = (u8 *)cfg80211_find_ie(WLAN_EID_HT_CAPABILITY,
+					       (const u8 *)(nskb->data + 24 +
+							sizeof(mgmt->u.beacon)),
+					       nskb->len - 24 -
+							sizeof(mgmt->u.beacon));
+		if (!ht_ie)
+			ht_ie = skb_put(nskb, 4 +
+					      sizeof(struct ieee80211_ht_cap) +
+					      sizeof(struct ieee80211_ht_info));
+
+		ht_ie = ieee80211_ie_build_ht_cap(ht_ie, sband,
+						  sband->ht_cap.cap);
+		ht_ie = ieee80211_ie_build_ht_info(ht_ie, &sband->ht_cap,
+					     local->oper_channel, channel_type);
+		rcu_assign_pointer(sdata->u.ibss.presp, nskb);
+		kfree_skb(skb);
+
+		if(!ieee80211_set_channel_type(local, sdata, channel_type)) {
+			channel_type = NL80211_CHAN_HT20;
+			WARN_ON(!ieee80211_set_channel_type(local, sdata,
+							    channel_type));
+		}
+
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	}
+
+}
 
 static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_mgmt *mgmt,
@@ -64,6 +134,7 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
 				      struct ieee80211_channel *chan,
+				      enum nl80211_channel_type channel_type,
 				      const u32 basic_rates,
 				      const u16 capability, u64 tsf)
 {
@@ -104,8 +175,17 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
+	/* entering a legacy IBSS. Use given HT configuration. */
+	if (channel_type == NL80211_CHAN_NO_HT)
+		channel_type = ifibss->channel_type;
 	local->oper_channel = chan;
-	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
+
+	/* if phy is on a different extension channel, setting ht40 will fail */
+	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
+		channel_type = NL80211_CHAN_HT20;
+		WARN_ON(!ieee80211_set_channel_type(local, sdata,
+				                                 channel_type));
+	}
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	sband = local->hw.wiphy->bands[chan->band];
@@ -171,6 +251,18 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		memcpy(skb_put(skb, ifibss->ie_len),
 		       ifibss->ie, ifibss->ie_len);
 
+	/* add HT capability and information IEs */
+	if (channel_type != NL80211_CHAN_NO_HT && sband->ht_cap.ht_supported) {
+		pos = skb_put(skb, 4 +
+				   sizeof(struct ieee80211_ht_cap) +
+				   sizeof(struct ieee80211_ht_info));
+		pos = ieee80211_ie_build_ht_cap(pos, sband, sband->ht_cap.cap);
+		pos = ieee80211_ie_build_ht_info(pos,
+						 &sband->ht_cap,
+						 chan,
+						 channel_type);
+	}
+
 	if (local->hw.queues >= 4) {
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
@@ -219,6 +311,8 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 basic_rates;
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
+	const u8 *ht_info_ie;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 
 	lockdep_assert_held(&sdata->u.ibss.mtx);
 
@@ -242,9 +336,23 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	ht_info_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_INFORMATION);
+	if (ht_info_ie)
+		channel_type = ieee80211_ht_info_to_channel_type(
+			(struct ieee80211_ht_info *) (ht_info_ie + 2));
+
+	if (!ieee80211_can_use_ext_chan(sdata, cbss->channel, channel_type)) {
+		channel_type = NL80211_CHAN_HT20;
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+		printk(KERN_DEBUG "%s: IBSS not allowed on secondary channel\n",
+		       sdata->name);
+#endif
+	}
+
 	__ieee80211_sta_join_ibss(sdata, cbss->bssid,
 				  beacon_int,
 				  cbss->channel,
+				  channel_type,
 				  basic_rates,
 				  cbss->capability,
 				  cbss->tsf);
@@ -310,11 +418,24 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			} else
 				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
 						mgmt->sa, supp_rates,
-						GFP_ATOMIC);
+						elems->ht_cap_elem, GFP_ATOMIC);
 		}
 
-		if (sta && elems->wmm_info)
-			set_sta_flags(sta, WLAN_STA_WME);
+		if (sta) {
+			if (elems->wmm_info)
+				set_sta_flags(sta, WLAN_STA_WME);
+
+			/* remote station uses ht */
+			if (elems->ht_info_elem) {
+				ieee80211_update_ht_elems(sdata, mgmt,
+							  elems->ht_info_elem);
+				ieee80211_ht_cap_ie_to_sta_ht_cap(
+						local->hw.wiphy->bands[
+						     local->oper_channel->band],
+						elems->ht_cap_elem,
+						&sta->sta.ht_cap);
+			}
+		}
 
 		rcu_read_unlock();
 	}
@@ -404,7 +525,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-				       supp_rates, GFP_KERNEL);
+				    supp_rates, elems->ht_cap_elem, GFP_KERNEL);
 	}
 
  put_bss:
@@ -417,7 +538,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
  * must be callable in atomic context.
  */
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid,u8 *addr, u32 supp_rates,
+					u8 *bssid, u8 *addr, u32 supp_rates,
+					struct ieee80211_ht_cap *ht_cap,
 					gfp_t gfp)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
@@ -458,6 +580,11 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
+	/* fill in ht rates */
+	if (ht_cap)
+		ieee80211_ht_cap_ie_to_sta_ht_cap(local->hw.wiphy->bands[band],
+				ht_cap, &sta->sta.ht_cap);
+
 	rate_control_rate_init(sta);
 
 	/* If it fails, maybe we raced another insertion? */
@@ -556,8 +683,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, ifibss->basic_rates,
-				  capability, 0);
+				  ifibss->channel, ifibss->channel_type,
+				  ifibss->basic_rates, capability, 0);
 }
 
 /*
@@ -594,10 +721,10 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		chan = ifibss->channel;
 	if (!is_zero_ether_addr(ifibss->bssid))
 		bssid = ifibss->bssid;
-	cbss = cfg80211_get_bss(local->hw.wiphy, chan, bssid,
+	cbss = cfg80211_get_bss_ht(local->hw.wiphy, chan, bssid,
 				ifibss->ssid, ifibss->ssid_len,
 				WLAN_CAPABILITY_IBSS | WLAN_CAPABILITY_PRIVACY,
-				capability);
+				capability, ifibss->channel_type);
 
 	if (cbss) {
 		struct ieee80211_bss *bss;
@@ -896,10 +1023,15 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb;
 
 	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
-			    36 /* bitrates */ +
-			    34 /* SSID */ +
-			    3  /* DS params */ +
-			    4  /* IBSS params */ +
+			    sizeof(struct ieee80211_hdr_3addr) +
+			    12 /* struct ieee80211_mgmt.u.beacon */ +
+			    2 + IEEE80211_MAX_SSID_LEN /* max SSID */ +
+			    2 + 8 /* max Supported Rates */ +
+			    3 /* max DS params */ +
+			    4 /* IBSS params */ +
+			    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
+			    2 + sizeof(struct ieee80211_ht_cap) +
+			    2 + sizeof(struct ieee80211_ht_info) +
 			    params->ie_len);
 	if (!skb)
 		return -ENOMEM;
@@ -920,13 +1052,15 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
 	sdata->u.ibss.channel = params->channel;
+	sdata->u.ibss.channel_type = params->channel_type;
 	sdata->u.ibss.fixed_channel = params->channel_fixed;
 
 	/* fix ourselves to that channel now already */
 	if (params->channel_fixed) {
 		sdata->local->oper_channel = params->channel;
-		WARN_ON(!ieee80211_set_channel_type(sdata->local, sdata,
-						    NL80211_CHAN_NO_HT));
+		if(!ieee80211_set_channel_type(sdata->local, sdata,
+					       params->channel_type))
+			return -EINVAL;
 	}
 
 	if (params->ie) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bfb820c..1384928 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -464,6 +464,7 @@ struct ieee80211_if_ibss {
 	u8 ssid_len, ie_len;
 	u8 *ie;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
@@ -1147,6 +1148,7 @@ void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid, u8 *addr, u32 supp_rates,
+					struct ieee80211_ht_cap *ht_cap,
 					gfp_t gfp);
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fe2c2a7..fc31191 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2147,7 +2147,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    sdata->vif.type != NL80211_IFTYPE_AP)
+		    sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			break;
 
 		/* verify action_code is present */
@@ -2664,7 +2665,8 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			else
 				rate_idx = status->rate_idx;
 			rx->sta = ieee80211_ibss_add_sta(sdata, bssid,
-					hdr->addr2, BIT(rate_idx), GFP_ATOMIC);
+					hdr->addr2, BIT(rate_idx), NULL,
+								GFP_ATOMIC);
 		}
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
-- 
1.7.3.4

