Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43746 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab1ASNiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 08:38:06 -0500
Received: by bwz15 with SMTP id 15so793760bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 05:38:04 -0800 (PST)
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: support for IEEE80211N in IBSS
Date: Wed, 19 Jan 2011 14:38:01 +0100
MIME-Version: 1.0
Message-Id: <201101191438.01161.alexander.simon@saxnet.de>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_5kuNNWiiSTk2Z0O"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_5kuNNWiiSTk2Z0O
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hey list,

finally i got my (in ath9ks list announced) patch for HT rates in ad-hoc=20
networks ready that has been requested quite often.
I took the initial patches from Beno=EEt Papillault and worked on them.
Beno=EEt already implemented setting the HT mode with iw, building and=20
receiving IEs.

I added processing of the IEs when a new station joins the network into the=
=20
internal station capabilities (struct sta_cap). This is necessary for eg. t=
he=20
rate algo to choose HT rates.

I had to change packet aggretation code to also work in ADHOC iftype.

As already said, the interface mode is set with iw. That mode will also be=
=20
advertised in the IEs, the additional HT capabilities are taken from the=20
interface capabilities. So there is no option to disable single capabilitie=
s=20
as in hostapd yet.

If a station is added through main receive path (ie. a third station sendin=
g=20
data to another station), HT is not threat yet. So there may be a initial=20
delay of maximum 100ms (beacon interval) running in legacy. It would=20
require disproportionally much work to implement this.

I tested this with with ath9k and iwlagn cards. Note that for ath9k i worke=
d=20
with minstrel_ht.

You will also need Beno=EEt's patch for iw to set HT mode.
http://ns3.spinics.net/lists/linux-wireless/msg50200.html
You would then be able to setup an IBSS with eg.:
iw wlan0 ibss join my_ht_ibss 2412 HT40+

Alex

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>

--Boundary-00=_5kuNNWiiSTk2Z0O
Content-Type: text/x-patch;
  charset="utf-8";
  name="enable_ieee80211_n_for_ibss.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="enable_ieee80211_n_for_ibss.patch"

diff -Nrup compat-wireless-2011-01-17.orig//include/net/cfg80211.h compat-wireless-2011-01-17/include/net/cfg80211.h
--- compat-wireless-2011-01-17.orig//include/net/cfg80211.h	2011-01-17 21:03:26.000000000 +0100
+++ compat-wireless-2011-01-17/include/net/cfg80211.h	2011-01-18 15:47:56.000000000 +0100
@@ -960,6 +960,7 @@ struct cfg80211_ibss_params {
 	u8 *ssid;
 	u8 *bssid;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
diff -Nrup compat-wireless-2011-01-17.orig//net/mac80211/agg-rx.c compat-wireless-2011-01-17/net/mac80211/agg-rx.c
--- compat-wireless-2011-01-17.orig//net/mac80211/agg-rx.c	2011-01-17 21:03:25.000000000 +0100
+++ compat-wireless-2011-01-17/net/mac80211/agg-rx.c	2011-01-18 15:47:56.000000000 +0100
@@ -160,6 +160,8 @@ static void ieee80211_send_addba_resp(st
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff -Nrup compat-wireless-2011-01-17.orig//net/mac80211/agg-tx.c compat-wireless-2011-01-17/net/mac80211/agg-tx.c
--- compat-wireless-2011-01-17.orig//net/mac80211/agg-tx.c	2011-01-17 21:03:25.000000000 +0100
+++ compat-wireless-2011-01-17/net/mac80211/agg-tx.c	2011-01-18 15:47:56.000000000 +0100
@@ -83,6 +83,8 @@ static void ieee80211_send_addba_request
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
@@ -376,7 +378,8 @@ int ieee80211_start_tx_ba_session(struct
 	 */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-	    sdata->vif.type != NL80211_IFTYPE_AP)
+	    sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return -EINVAL;
 
 	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
diff -Nrup compat-wireless-2011-01-17.orig//net/mac80211/ht.c compat-wireless-2011-01-17/net/mac80211/ht.c
--- compat-wireless-2011-01-17.orig//net/mac80211/ht.c	2011-01-17 21:03:25.000000000 +0100
+++ compat-wireless-2011-01-17/net/mac80211/ht.c	2011-01-18 15:47:56.000000000 +0100
@@ -179,6 +179,8 @@ void ieee80211_send_delba(struct ieee802
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff -Nrup compat-wireless-2011-01-17.orig//net/mac80211/ibss.c compat-wireless-2011-01-17/net/mac80211/ibss.c
--- compat-wireless-2011-01-17.orig//net/mac80211/ibss.c	2011-01-17 21:03:25.000000000 +0100
+++ compat-wireless-2011-01-17/net/mac80211/ibss.c	2011-01-18 15:47:56.000000000 +0100
@@ -66,6 +66,7 @@ static void ieee80211_rx_mgmt_auth_ibss(
 static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
 				      struct ieee80211_channel *chan,
+				      enum nl80211_channel_type channel_type,
 				      const u32 basic_rates,
 				      const u16 capability, u64 tsf)
 {
@@ -107,7 +108,7 @@ static void __ieee80211_sta_join_ibss(st
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
 	local->oper_channel = chan;
-	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
+	WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	sband = local->hw.wiphy->bands[chan->band];
@@ -173,6 +174,64 @@ static void __ieee80211_sta_join_ibss(st
 		memcpy(skb_put(skb, ifibss->ie_len),
 		       ifibss->ie, ifibss->ie_len);
 
+	if (channel_type != NL80211_CHAN_NO_HT && sband->ht_cap.ht_supported) {
+		u16 cap = sband->ht_cap.cap;
+		struct ieee80211_ht_cap *ht_cap;
+		struct ieee80211_ht_info *ht_info;
+
+		/* Build HT Capabilities */
+		if (ieee80211_disable_40mhz_24ghz &&
+		    sband->band == IEEE80211_BAND_2GHZ) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+
+		pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_cap));
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		ht_cap = (struct ieee80211_ht_cap *)pos;
+
+		ht_cap->cap_info = cpu_to_le16(cap);
+		ht_cap->ampdu_params_info = sband->ht_cap.ampdu_factor |
+			(sband->ht_cap.ampdu_density <<
+			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+		memcpy(&ht_cap->mcs, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
+		ht_cap->extended_ht_cap_info = 0x0000;
+		ht_cap->tx_BF_cap_info = 0x00000000;
+		ht_cap->antenna_selection_info = 0x00;
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
+		ht_info->operation_mode = 0x0000; //<-- is this correct?
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
@@ -221,6 +280,9 @@ static void ieee80211_sta_join_ibss(stru
 	u32 basic_rates;
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
+	const u8 *ht_info_ie;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+
 
 	lockdep_assert_held(&sdata->u.ibss.mtx);
 
@@ -244,9 +306,29 @@ static void ieee80211_sta_join_ibss(stru
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
@@ -310,7 +392,7 @@ static void ieee80211_rx_bss_info(struct
 				}
 			} else
 				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
-						mgmt->sa, supp_rates,
+						mgmt->sa, supp_rates, elems->ht_cap_elem,
 						GFP_ATOMIC);
 		}
 
@@ -409,7 +491,7 @@ static void ieee80211_rx_bss_info(struct
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-				       supp_rates, GFP_KERNEL);
+				       supp_rates, elems->ht_cap_elem, GFP_KERNEL);
 	}
 
  put_bss:
@@ -422,8 +504,8 @@ static void ieee80211_rx_bss_info(struct
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
@@ -463,6 +545,10 @@ struct sta_info *ieee80211_ibss_add_sta(
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
+	if (ht_cap)
+		ieee80211_ht_cap_ie_to_sta_ht_cap(local->hw.wiphy->bands[band],
+				ht_cap, &sta->sta.ht_cap);
+
 	rate_control_rate_init(sta);
 
 	/* If it fails, maybe we raced another insertion? */
@@ -565,7 +651,7 @@ static void ieee80211_sta_create_ibss(st
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, ifibss->basic_rates,
+				  ifibss->channel, ifibss->channel_type, ifibss->basic_rates,
 				  capability, 0);
 }
 
@@ -901,11 +987,16 @@ int ieee80211_ibss_join(struct ieee80211
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
 
@@ -925,13 +1016,14 @@ int ieee80211_ibss_join(struct ieee80211
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
diff -Nrup compat-wireless-2011-01-17.orig//net/mac80211/ieee80211_i.h compat-wireless-2011-01-17/net/mac80211/ieee80211_i.h
--- compat-wireless-2011-01-17.orig//net/mac80211/ieee80211_i.h	2011-01-17 21:03:26.000000000 +0100
+++ compat-wireless-2011-01-17/net/mac80211/ieee80211_i.h	2011-01-18 15:47:56.000000000 +0100
@@ -438,6 +438,7 @@ struct ieee80211_if_ibss {
 	u8 ssid_len, ie_len;
 	u8 *ie;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
@@ -1110,7 +1111,7 @@ void ieee80211_ibss_notify_scan_complete
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid, u8 *addr, u32 supp_rates,
-					gfp_t gfp);
+					struct ieee80211_ht_cap *ht_cap, gfp_t gfp);
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
diff -Nrup compat-wireless-2011-01-17.orig//net/mac80211/rx.c compat-wireless-2011-01-17/net/mac80211/rx.c
--- compat-wireless-2011-01-17.orig//net/mac80211/rx.c	2011-01-17 21:03:26.000000000 +0100
+++ compat-wireless-2011-01-17/net/mac80211/rx.c	2011-01-18 15:47:56.000000000 +0100
@@ -2063,7 +2063,8 @@ ieee80211_rx_h_action(struct ieee80211_r
 		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    sdata->vif.type != NL80211_IFTYPE_AP)
+		    sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			break;
 
 		/* verify action_code is present */
@@ -2618,7 +2619,7 @@ static int prepare_for_handlers(struct i
 			else
 				rate_idx = status->rate_idx;
 			rx->sta = ieee80211_ibss_add_sta(sdata, bssid,
-					hdr->addr2, BIT(rate_idx), GFP_ATOMIC);
+					hdr->addr2, BIT(rate_idx), NULL, GFP_ATOMIC);
 		}
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
diff -Nrup compat-wireless-2011-01-17.orig//net/wireless/nl80211.c compat-wireless-2011-01-17/net/wireless/nl80211.c
--- compat-wireless-2011-01-17.orig//net/wireless/nl80211.c	2011-01-17 21:03:26.000000000 +0100
+++ compat-wireless-2011-01-17/net/wireless/nl80211.c	2011-01-18 15:47:56.000000000 +0100
@@ -3907,8 +3907,24 @@ static int nl80211_join_ibss(struct sk_b
 		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	ibss.channel = ieee80211_get_channel(wiphy,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+		enum nl80211_channel_type channel_type;
+
+		channel_type = nla_get_u32(
+			info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+		if (channel_type != NL80211_CHAN_NO_HT &&
+				channel_type != NL80211_CHAN_HT20 &&
+				channel_type != NL80211_CHAN_HT40PLUS &&
+				channel_type != NL80211_CHAN_HT40MINUS)
+			return -EINVAL;
+		ibss.channel_type = channel_type;
+	} else {
+		ibss.channel_type = NL80211_CHAN_NO_HT;
+	}
+
+	ibss.channel = rdev_freq_to_chan(rdev,
+		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
+		ibss.channel_type);
 	if (!ibss.channel ||
 	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
 	    ibss.channel->flags & IEEE80211_CHAN_DISABLED)

--Boundary-00=_5kuNNWiiSTk2Z0O--
