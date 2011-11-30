Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:35006 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab1K3P4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 10:56:42 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCHv2 3/3] mac80211: Add HT operation modes for IBSS
Date: Wed, 30 Nov 2011 16:56:34 +0100
Message-Id: <1322668595-18836-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111130_165649_638439_D5366042)
In-Reply-To: <1322668595-18836-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1322668595-18836-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Simon <an.alexsimon@googlemail.com>

The HT mode is set by iw (previous patchsets).
The interface is set into the specified HT mode.
HT mode and capabilities are announced in beacons.

If we add a station that uses HT also, the fastest matching HT mode will
be used for transmission. That means if we are using HT40+ and we add a station
running on HT40-, we would transfer at HT20.

If we join an IBSS with HT40, but the secondary channel is not
available, we will fall back into HT20 as well.

Allow frame aggregation to start in IBSS mode.

Signed-off-by: Alexander Simon <an.alexsimon@googlemail.com>
[siwu@hrz.tu-chemnitz.de: Updates]
* remove implicit channel_type enum assumptions
* use rate_control_rate_init() if channel type changed
* remove channel flags check
* activate HT IBSS feature support
* slightly reword commit message
* rebase on wireless-testing

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/agg-rx.c      |    2 +
 net/mac80211/agg-tx.c      |    5 ++-
 net/mac80211/ht.c          |    2 +
 net/mac80211/ibss.c        |   83 +++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/main.c        |    3 +-
 net/mac80211/rx.c          |    3 +-
 7 files changed, 87 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 476b106..7571be2 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -182,6 +182,8 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 611b64e..aede794 100644
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
@@ -376,7 +378,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
 	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-	    sdata->vif.type != NL80211_IFTYPE_AP)
+	    sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return -EINVAL;
 
 	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 810cfbe..14c2893 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -282,6 +282,8 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a82f6b4..3f830ac 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -77,6 +77,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *bss;
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
+	enum nl80211_channel_type channel_type;
 
 	lockdep_assert_held(&ifibss->mtx);
 
@@ -105,8 +106,16 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	local->oper_channel = chan;
-	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
+	channel_type = ifibss->channel_type;
+	if (channel_type > NL80211_CHAN_HT20 &&
+	    !cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
+		channel_type = NL80211_CHAN_HT20;
+	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
+		/* can only fail due to HT40+/- mismatch */
+		channel_type = NL80211_CHAN_HT20;
+		WARN_ON(!ieee80211_set_channel_type(local, sdata,
+						    NL80211_CHAN_HT20));
+	}
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	sband = local->hw.wiphy->bands[chan->band];
@@ -172,6 +181,19 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		memcpy(skb_put(skb, ifibss->ie_len),
 		       ifibss->ie, ifibss->ie_len);
 
+	/* add HT capability and information IEs */
+	if (channel_type && sband->ht_cap.ht_supported) {
+		pos = skb_put(skb, 4 +
+				   sizeof(struct ieee80211_ht_cap) +
+				   sizeof(struct ieee80211_ht_info));
+		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
+						sband->ht_cap.cap);
+		pos = ieee80211_ie_build_ht_info(pos,
+						 &sband->ht_cap,
+						 chan,
+						 channel_type);
+	}
+
 	if (local->hw.queues >= 4) {
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
@@ -195,6 +217,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	bss_change |= BSS_CHANGED_BEACON;
 	bss_change |= BSS_CHANGED_BEACON_ENABLED;
 	bss_change |= BSS_CHANGED_BASIC_RATES;
+	bss_change |= BSS_CHANGED_HT;
 	bss_change |= BSS_CHANGED_IBSS;
 	sdata->vif.bss_conf.ibss_joined = true;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
@@ -268,6 +291,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	u64 beacon_timestamp, rx_timestamp;
 	u32 supp_rates = 0;
 	enum ieee80211_band band = rx_status->band;
+	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
+	bool rates_updated = false;
 
 	if (elems->ds_params && elems->ds_params_len == 1)
 		freq = ieee80211_channel_to_frequency(elems->ds_params[0],
@@ -307,7 +332,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 						prev_rates,
 						sta->sta.supp_rates[band]);
 #endif
-					rate_control_rate_init(sta);
+					rates_updated = true;
 				}
 			} else
 				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
@@ -318,6 +343,39 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		if (sta && elems->wmm_info)
 			set_sta_flag(sta, WLAN_STA_WME);
 
+		if (sta && elems->ht_info_elem && elems->ht_cap_elem &&
+		    sdata->u.ibss.channel_type != NL80211_CHAN_NO_HT) {
+			/* we both use HT */
+			struct ieee80211_sta_ht_cap sta_ht_cap_new;
+			enum nl80211_channel_type channel_type =
+				ieee80211_ht_info_to_channel_type(
+							elems->ht_info_elem);
+
+			ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
+							  elems->ht_cap_elem,
+							  &sta_ht_cap_new);
+
+			/*
+			 * fall back to HT20 if we don't use or use
+			 * the other extension channel
+			 */
+			if ((channel_type == NL80211_CHAN_HT40MINUS ||
+			     channel_type == NL80211_CHAN_HT40PLUS) &&
+			    channel_type != sdata->u.ibss.channel_type)
+				sta_ht_cap_new.cap &=
+					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+
+			if (memcmp(&sta->sta.ht_cap, &sta_ht_cap_new,
+				   sizeof(sta_ht_cap_new))) {
+				memcpy(&sta->sta.ht_cap, &sta_ht_cap_new,
+				       sizeof(sta_ht_cap_new));
+				rates_updated = true;
+			}
+		}
+
+		if (sta && rates_updated)
+			rate_control_rate_init(sta);
+
 		rcu_read_unlock();
 	}
 
@@ -899,10 +957,15 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	u32 changed = 0;
 
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
@@ -923,13 +986,15 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
 	sdata->u.ibss.channel = params->channel;
+	sdata->u.ibss.channel_type = params->channel_type;
 	sdata->u.ibss.fixed_channel = params->channel_fixed;
 
 	/* fix ourselves to that channel now already */
 	if (params->channel_fixed) {
 		sdata->local->oper_channel = params->channel;
-		WARN_ON(!ieee80211_set_channel_type(sdata->local, sdata,
-						    NL80211_CHAN_NO_HT));
+		if (!ieee80211_set_channel_type(sdata->local, sdata,
+					       params->channel_type))
+			return -EINVAL;
 	}
 
 	if (params->ie) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 762243e..c4af994 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -474,6 +474,7 @@ struct ieee80211_if_ibss {
 	u8 ssid_len, ie_len;
 	u8 *ie;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 3e15f75..62e3365 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -611,7 +611,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 			WIPHY_FLAG_OFFCHAN_TX |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
-	wiphy->features = NL80211_FEATURE_SK_TX_STATUS;
+	wiphy->features = NL80211_FEATURE_SK_TX_STATUS |
+			  NL80211_FEATURE_HT_IBSS;
 
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d1a8869..17d7aa3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2250,7 +2250,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
 		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    sdata->vif.type != NL80211_IFTYPE_AP)
+		    sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			break;
 
 		/* verify action_code is present */
-- 
1.7.7.3

