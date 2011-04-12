Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:60945 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab1DLLPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 07:15:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Q9bYn-0003bB-Cw
	for linux-wireless@vger.kernel.org; Tue, 12 Apr 2011 13:15:05 +0200
Received: from 89.204.153.111 ([89.204.153.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 13:15:05 +0200
Received: from alexander.simon by 89.204.153.111 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 13:15:05 +0200
To: linux-wireless@vger.kernel.org
From: Alexander Simon <alexander.simon@saxnet.de>
Subject: Re: [PATCH 4/4] mac80211: Add IEEE802.11n for IBSS
Date: Tue, 12 Apr 2011 11:07:11 +0000 (UTC)
Message-ID: <loom.20110412T130620-109@post.gmane.org>
References: <1302604964.2139.5.camel@alex-2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okay, here we go. Hopefully this meets your requirements.

* Use HT IEs from other stations for rate algo
* Parameter to set HT channel type for IBSS join
* Build HT IEs when joining an IBSS
* Allow frame aggregation sessions for IBSS

HT operation will only be started for a station after receiving a beacon.
So there may be a delay running in legacy when adding a station from a data
packet to a third station (prepare_for_handlers).

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---
 agg-rx.c      |    2 +
 agg-tx.c      |    5 ++-
 ht.c          |    2 +
 ibss.c        |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 ieee80211_i.h |    3 +
 rx.c          |    5 +--
 6 files changed, 95 insertions(+), 16 deletions(-)

diff -Nrup a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
--- a/net/mac80211/agg-rx.c	2011-03-31 21:04:01.000000000 +0200
+++ b/net/mac80211/agg-rx.c	2011-04-12 08:49:19.000000000 +0200
@@ -160,6 +160,8 @@ static void ieee80211_send_addba_resp(st
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff -Nrup a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
--- a/net/mac80211/agg-tx.c	2011-03-31 21:04:01.000000000 +0200
+++ b/net/mac80211/agg-tx.c	2011-04-12 08:49:19.000000000 +0200
@@ -83,6 +83,8 @@ static void ieee80211_send_addba_request
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
@@ -377,7 +379,8 @@ int ieee80211_start_tx_ba_session(struct
 	 */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-	    sdata->vif.type != NL80211_IFTYPE_AP)
+	    sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return -EINVAL;
 
 	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
diff -Nrup a/net/mac80211/ht.c b/net/mac80211/ht.c
--- a/net/mac80211/ht.c	2011-03-31 21:04:01.000000000 +0200
+++ b/net/mac80211/ht.c	2011-04-12 08:49:19.000000000 +0200
@@ -182,6 +182,8 @@ void ieee80211_send_delba(struct ieee802
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff -Nrup a/net/mac80211/ibss.c b/net/mac80211/ibss.c
--- a/net/mac80211/ibss.c	2011-03-31 21:04:01.000000000 +0200
+++ b/net/mac80211/ibss.c	2011-04-12 10:23:09.000000000 +0200
@@ -65,6 +65,7 @@ static void ieee80211_rx_mgmt_auth_ibss(
 static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
 				      struct ieee80211_channel *chan,
+				      enum nl80211_channel_type channel_type,
 				      const u32 basic_rates,
 				      const u16 capability, u64 tsf)
 {
@@ -78,6 +79,7 @@ static void __ieee80211_sta_join_ibss(st
 	struct cfg80211_bss *bss;
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
+	struct ieee80211_ht_info *ht_info;
 
 	lockdep_assert_held(&ifibss->mtx);
 
@@ -106,7 +108,7 @@ static void __ieee80211_sta_join_ibss(st
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
 	local->oper_channel = chan;
-	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
+	WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	sband = local->hw.wiphy->bands[chan->band];
@@ -172,6 +174,42 @@ static void __ieee80211_sta_join_ibss(st
 		memcpy(skb_put(skb, ifibss->ie_len),
 		       ifibss->ie, ifibss->ie_len);
 
+	if (channel_type != NL80211_CHAN_NO_HT && sband->ht_cap.ht_supported) {
+		pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_cap));
+		ieee80211_ie_build_ht_cap(pos, sband, sband->ht_cap.cap);
+
+		/* Build HT Information */
+		pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_info));
+		*pos++ = WLAN_EID_HT_INFORMATION;
+		*pos++ = sizeof(struct ieee80211_ht_info);
+		ht_info = (struct ieee80211_ht_info *)pos;
+
+		ht_info->control_chan = 
+			ieee80211_frequency_to_channel(chan->center_freq);
+		ht_info->ht_param = 0x00;
+		switch (local->_oper_channel_type) {
+			case NL80211_CHAN_HT40MINUS:
+				ht_info->ht_param |= IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+				break;
+			case NL80211_CHAN_HT40PLUS:
+				ht_info->ht_param |= IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+				break;
+			case NL80211_CHAN_HT20:
+			default:
+				ht_info->ht_param |= IEEE80211_HT_PARAM_CHA_SEC_NONE;
+				break;
+		}
+		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+			ht_info->ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
+		ht_info->operation_mode = 0x0000;
+		ht_info->stbc_param = 0x0000;
+
+		/* It seems that Basic MCS set and Supported MCS set
+		   are identical for the first 10 bytes */
+		memset(&ht_info->basic_set, 0, 16);
+		memcpy(&ht_info->basic_set, &sband->ht_cap.mcs, 10);
+	}
+
 	if (local->hw.queues >= 4) {
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
@@ -220,6 +258,8 @@ static void ieee80211_sta_join_ibss(stru
 	u32 basic_rates;
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+	const u8 *ht_info_ie;
 
 	lockdep_assert_held(&sdata->u.ibss.mtx);
 
@@ -243,9 +283,29 @@ static void ieee80211_sta_join_ibss(stru
 		}
 	}
 
+	/* parse HT Information IE, if present */
+	ht_info_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_INFORMATION);
+	if (ht_info_ie) {
+		const struct ieee80211_ht_info *ht_info = 
+				(const struct ieee80211_ht_info *)(ht_info_ie + 2);
+
+		switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+		case IEEE80211_HT_PARAM_CHA_SEC_NONE:
+			channel_type = NL80211_CHAN_HT20;
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+			channel_type = NL80211_CHAN_HT40PLUS;
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			channel_type = NL80211_CHAN_HT40MINUS;
+			break;
+		}
+	}
+
 	__ieee80211_sta_join_ibss(sdata, cbss->bssid,
 				  beacon_int,
 				  cbss->channel,
+				  channel_type,
 				  basic_rates,
 				  cbss->capability,
 				  cbss->tsf);
@@ -310,7 +370,7 @@ static void ieee80211_rx_bss_info(struct
 				}
 			} else
 				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
-						mgmt->sa, supp_rates,
+						mgmt->sa, supp_rates, elems->ht_cap_elem,
 						GFP_ATOMIC);
 		}
 
@@ -405,7 +465,7 @@ static void ieee80211_rx_bss_info(struct
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-				       supp_rates, GFP_KERNEL);
+				       supp_rates, elems->ht_cap_elem, GFP_KERNEL);
 	}
 
  put_bss:
@@ -418,8 +478,8 @@ static void ieee80211_rx_bss_info(struct
  * must be callable in atomic context.
  */
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid,u8 *addr, u32 supp_rates,
-					gfp_t gfp)
+					u8 *bssid, u8 *addr, u32 supp_rates,
+					struct ieee80211_ht_cap *ht_cap, gfp_t gfp)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
@@ -459,6 +519,10 @@ struct sta_info *ieee80211_ibss_add_sta(
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
+	if (ht_cap)
+		ieee80211_ht_cap_ie_to_sta_ht_cap(local->hw.wiphy->bands[band],
+				ht_cap, &sta->sta.ht_cap);
+
 	rate_control_rate_init(sta);
 
 	/* If it fails, maybe we raced another insertion? */
@@ -561,7 +625,7 @@ static void ieee80211_sta_create_ibss(st
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, ifibss->basic_rates,
+				  ifibss->channel, ifibss->channel_type, ifibss->basic_rates,
 				  capability, 0);
 }
 
@@ -898,11 +962,16 @@ int ieee80211_ibss_join(struct ieee80211
 	struct sk_buff *skb;
 
 	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
-			    36 /* bitrates */ +
-			    34 /* SSID */ +
-			    3  /* DS params */ +
-			    4  /* IBSS params */ +
-			    params->ie_len);
+				sizeof(struct ieee80211_hdr_3addr) + 
+				12 /* struct ieee80211_mgmt.u.beacon */ +
+				2 + IEEE80211_MAX_SSID_LEN /* max SSID */ +
+				2 + 8 /* max Supported Rates */ +
+				3 /* max DS params */ +
+				4 /* IBSS params */ +
+				2 + (IEEE80211_MAX_SUPP_RATES - 8) /* max Ext Rates */ +
+				2 + sizeof(struct ieee80211_ht_cap) +
+				2 + sizeof(struct ieee80211_ht_info) +
+				params->ie_len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -922,13 +991,14 @@ int ieee80211_ibss_join(struct ieee80211
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
--- a/net/mac80211/ieee80211_i.h	2011-03-31 21:04:02.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-04-12 09:55:16.000000000 +0200
@@ -439,6 +439,7 @@ struct ieee80211_if_ibss {
 	u8 ssid_len, ie_len;
 	u8 *ie;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
@@ -1107,7 +1108,7 @@ void ieee80211_ibss_notify_scan_complete
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid, u8 *addr, u32 supp_rates,
-					gfp_t gfp);
+					struct ieee80211_ht_cap *ht_cap, gfp_t gfp);
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
diff -Nrup a/net/mac80211/rx.c b/net/mac80211/rx.c
--- a/net/mac80211/rx.c	2011-03-31 21:04:01.000000000 +0200
+++ b/net/mac80211/rx.c	2011-04-12 08:49:19.000000000 +0200
@@ -2118,7 +2118,8 @@ ieee80211_rx_h_action(struct ieee80211_r
 		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    sdata->vif.type != NL80211_IFTYPE_AP)
+		    sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			break;
 
 		/* verify action_code is present */
@@ -2674,7 +2675,7 @@ static int prepare_for_handlers(struct i
 			else
 				rate_idx = status->rate_idx;
 			rx->sta = ieee80211_ibss_add_sta(sdata, bssid,
-					hdr->addr2, BIT(rate_idx), GFP_ATOMIC);
+					hdr->addr2, BIT(rate_idx), NULL, GFP_ATOMIC);
 		}
 		break;
 	case NL80211_IFTYPE_MESH_POINT:


