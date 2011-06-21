Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64125 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab1FUPxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 11:53:33 -0400
Received: by fxm17 with SMTP id 17so35574fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 08:53:32 -0700 (PDT)
Subject: [RFC v3 3/3] mac80211: HT operation in IBSS
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1308671129.2656.4.camel@alex-2>
References: <1308671129.2656.4.camel@alex-2>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 17:53:29 +0200
Message-ID: <1308671609.2656.10.camel@alex-2> (sfid-20110621_175338_716675_C53F4621)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My third try of an HT implementation for IBSS.

* HT mode is proposed by nl80211
* Allow frame aggregation to start for IBSS
* Build HT IEs

For fixed channel, HT mode is also fixed. Merge or join only if HT mode of some
other BSS is the same as set by nl80211.

For proposed channel, HT mode is also proposed. This means, if we join a HT
IBSS, its HT mode is taken.
nl80211 HT mode is taken when we join a non-HT ibss (then we "convert" it into
one).
If we see (from a beacon) that the IBSS has a different HT mode, we switch
(first beacon wins, as we all have the same TSF).


I tested this with the following scenario (using wireshark to confirm):
* opening a IBSS with a Realtek under Windows
* join with an ath9k station A without HT
  -> both stations joined, no HT beacons
* join a 2nd ath9k station B in HT40+
  -> station B sending HT beacons. Interpreted by A, ignored by windows
* A is switching to HT mode
  -> HT communication between A and B up and running. 11g with windows.

Todo:
* When switching HT mode, check if we are allow to do that.

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---
 agg-rx.c      |    2 
 agg-tx.c      |    5 +-
 ht.c          |    2 
 ibss.c        |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 ieee80211_i.h |    2 
 rx.c          |    6 +-
 6 files changed, 120 insertions(+), 19 deletions(-)

diff -Nrup a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
--- a/net/mac80211/agg-rx.c	2011-06-01 21:04:24.000000000 +0200
+++ b/net/mac80211/agg-rx.c	2011-06-21 13:21:38.000000000 +0200
@@ -161,6 +161,8 @@ static void ieee80211_send_addba_resp(st
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff -Nrup a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
--- a/net/mac80211/agg-tx.c	2011-06-01 21:04:33.000000000 +0200
+++ b/net/mac80211/agg-tx.c	2011-06-21 13:21:38.000000000 +0200
@@ -83,6 +83,8 @@ static void ieee80211_send_addba_request
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
@@ -398,7 +400,8 @@ int ieee80211_start_tx_ba_session(struct
 	 */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-	    sdata->vif.type != NL80211_IFTYPE_AP)
+	    sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return -EINVAL;
 
 	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
diff -Nrup a/net/mac80211/ht.c b/net/mac80211/ht.c
--- a/net/mac80211/ht.c	2011-06-01 21:04:24.000000000 +0200
+++ b/net/mac80211/ht.c	2011-06-21 13:21:38.000000000 +0200
@@ -197,6 +197,8 @@ void ieee80211_send_delba(struct ieee802
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff -Nrup a/net/mac80211/ibss.c b/net/mac80211/ibss.c
--- a/net/mac80211/ibss.c	2011-06-01 21:04:24.000000000 +0200
+++ b/net/mac80211/ibss.c	2011-06-21 13:21:38.000000000 +0200
@@ -64,6 +64,7 @@ static void ieee80211_rx_mgmt_auth_ibss(
 static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
 				      struct ieee80211_channel *chan,
+				      enum nl80211_channel_type channel_type,
 				      const u32 basic_rates,
 				      const u16 capability, u64 tsf)
 {
@@ -104,8 +105,12 @@ static void __ieee80211_sta_join_ibss(st
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
+	/* entering a legacy IBSS. Use given HT configuration. */
+	if (channel_type == NL80211_CHAN_NO_HT)
+		channel_type = ifibss->channel_type;
+
 	local->oper_channel = chan;
-	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
+	WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	sband = local->hw.wiphy->bands[chan->band];
@@ -171,6 +176,17 @@ static void __ieee80211_sta_join_ibss(st
 		memcpy(skb_put(skb, ifibss->ie_len),
 		       ifibss->ie, ifibss->ie_len);
 
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
@@ -219,6 +235,8 @@ static void ieee80211_sta_join_ibss(stru
 	u32 basic_rates;
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
+	const u8 *ht_info_ie;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 
 	lockdep_assert_held(&sdata->u.ibss.mtx);
 
@@ -242,9 +260,15 @@ static void ieee80211_sta_join_ibss(stru
 		}
 	}
 
+	ht_info_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_INFORMATION);
+	if (ht_info_ie)
+		channel_type = ieee80211_ht_info_to_channel_type(
+			(struct ieee80211_ht_info *) (ht_info_ie + 2));
+
 	__ieee80211_sta_join_ibss(sdata, cbss->bssid,
 				  beacon_int,
 				  cbss->channel,
+				  channel_type,
 				  basic_rates,
 				  cbss->capability,
 				  cbss->tsf);
@@ -310,11 +334,65 @@ static void ieee80211_rx_bss_info(struct
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
+			if (elems->ht_info_elem) {
+				struct ieee80211_supported_band *sband =
+					local->hw.wiphy->bands[channel->band];
+				enum nl80211_channel_type channel_type;
+
+				channel_type =
+					ieee80211_ht_info_to_channel_type(
+						elems->ht_info_elem);
+				if (channel_type != local->_oper_channel_type) {
+					struct sk_buff *skb =
+							sdata->u.ibss.presp;
+					struct sk_buff *nskb;
+					u8 *ht_ie;
+
+					nskb = skb_copy(skb, GFP_ATOMIC);
+					ht_ie = cfg80211_find_ie(
+						WLAN_EID_HT_CAPABILITY,
+						nskb->data + 24 +
+							sizeof(mgmt->u.beacon),
+						nskb->len - 24 -
+							sizeof(mgmt->u.beacon));
+
+					if (!ht_ie)
+						ht_ie = skb_put(nskb, 4 +
+					      sizeof(struct ieee80211_ht_cap) +
+					      sizeof(struct ieee80211_ht_info));
+					ht_ie = ieee80211_ie_build_ht_cap(ht_ie,
+							     sband,
+							     sband->ht_cap.cap);
+					ht_ie = ieee80211_ie_build_ht_info(
+								 ht_ie,
+								 &sband->ht_cap,
+								 channel,
+								 channel_type);
+					sdata->u.ibss.presp = nskb;
+					kfree_skb(skb);
+
+					local->_oper_channel_type =
+								channel_type;
+					WARN_ON(!ieee80211_set_channel_type(
+								local,
+								sdata,
+								channel_type));
+					ieee80211_hw_config(local,
+						IEEE80211_CONF_CHANGE_CHANNEL);
+				}
+				ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+							elems->ht_cap_elem,
+							&sta->sta.ht_cap);
+
+			}
+		}
 
 		rcu_read_unlock();
 	}
@@ -404,7 +482,7 @@ static void ieee80211_rx_bss_info(struct
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-				       supp_rates, GFP_KERNEL);
+				    supp_rates, elems->ht_cap_elem, GFP_KERNEL);
 	}
 
  put_bss:
@@ -417,7 +495,8 @@ static void ieee80211_rx_bss_info(struct
  * must be callable in atomic context.
  */
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid,u8 *addr, u32 supp_rates,
+					u8 *bssid, u8 *addr, u32 supp_rates,
+					struct ieee80211_ht_cap *ht_cap,
 					gfp_t gfp)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
@@ -458,6 +537,11 @@ struct sta_info *ieee80211_ibss_add_sta(
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
+	/* fill in ht rates */
+	if (ht_cap)
+		ieee80211_ht_cap_ie_to_sta_ht_cap(local->hw.wiphy->bands[band],
+				ht_cap, &sta->sta.ht_cap);
+
 	rate_control_rate_init(sta);
 
 	/* If it fails, maybe we raced another insertion? */
@@ -556,8 +640,8 @@ static void ieee80211_sta_create_ibss(st
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, ifibss->basic_rates,
-				  capability, 0);
+				  ifibss->channel, ifibss->channel_type,
+				  ifibss->basic_rates, capability, 0);
 }
 
 /*
@@ -594,10 +678,10 @@ static void ieee80211_sta_find_ibss(stru
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
@@ -896,11 +980,16 @@ int ieee80211_ibss_join(struct ieee80211
 	struct sk_buff *skb;
 
 	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
-			    36 /* bitrates */ +
-			    34 /* SSID */ +
-			    3  /* DS params */ +
-			    4  /* IBSS params */ +
-			    params->ie_len);
+			    sizeof(struct ieee80211_hdr_3addr) +
+			    12 /* struct ieee80211_mgmt.u.beacon */ +
+			    2 + IEEE80211_MAX_SSID_LEN /* max SSID */ +
+			    2 + 8 /* max Supported Rates */ +
+			    3 /* max DS params */ +
+			    4 /* IBSS params */ +
+			    2 + (IEEE80211_MAX_SUPP_RATES - 8)
+			    2 + sizeof(struct ieee80211_ht_cap) +
+			    2 + sizeof(struct ieee80211_ht_info) +
+			    params->ie_len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -920,13 +1009,14 @@ int ieee80211_ibss_join(struct ieee80211
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
 	sdata->u.ibss.channel = params->channel;
+	sdata->u.ibss.channel_type = params->channel_type;
 	sdata->u.ibss.fixed_channel = params->channel_fixed;
 
 	/* fix ourselves to that channel now already */
 	if (params->channel_fixed) {
 		sdata->local->oper_channel = params->channel;
 		WARN_ON(!ieee80211_set_channel_type(sdata->local, sdata,
-						    NL80211_CHAN_NO_HT));
+						    params->channel_type));
 	}
 
 	if (params->ie) {
diff -Nrup a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
--- a/net/mac80211/ieee80211_i.h	2011-06-01 21:04:32.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-06-21 13:21:38.000000000 +0200
@@ -439,6 +439,7 @@ struct ieee80211_if_ibss {
 	u8 ssid_len, ie_len;
 	u8 *ie;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
@@ -1124,6 +1125,7 @@ void ieee80211_ibss_notify_scan_complete
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid, u8 *addr, u32 supp_rates,
+					struct ieee80211_ht_cap *ht_cap,
 					gfp_t gfp);
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
diff -Nrup a/net/mac80211/rx.c b/net/mac80211/rx.c
--- a/net/mac80211/rx.c	2011-06-01 21:04:32.000000000 +0200
+++ b/net/mac80211/rx.c	2011-06-21 13:21:38.000000000 +0200
@@ -2137,7 +2137,8 @@ ieee80211_rx_h_action(struct ieee80211_r
 		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    sdata->vif.type != NL80211_IFTYPE_AP)
+		    sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			break;
 
 		/* verify action_code is present */
@@ -2652,7 +2653,8 @@ static int prepare_for_handlers(struct i
 			else
 				rate_idx = status->rate_idx;
 			rx->sta = ieee80211_ibss_add_sta(sdata, bssid,
-					hdr->addr2, BIT(rate_idx), GFP_ATOMIC);
+					hdr->addr2, BIT(rate_idx), NULL,
+								GFP_ATOMIC);
 		}
 		break;
 	case NL80211_IFTYPE_MESH_POINT:



