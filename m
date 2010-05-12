Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:53953 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826Ab0ELVQJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 17:16:09 -0400
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] mac80211: Add HT IE to IBSS beacons and probe responses
Date: Wed, 12 May 2010 23:07:40 +0200
Message-Id: <1273698460-18061-4-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1273698460-18061-3-git-send-email-benoit.papillault@free.fr>
References: <1273698460-18061-1-git-send-email-benoit.papillault@free.fr>
 <1273698460-18061-2-git-send-email-benoit.papillault@free.fr>
 <1273698460-18061-3-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an HT IBSS is configured, we add HT Capabilities and HT Operation
IE to beacons and probe responses. This is done according to
channel_type transmitted by iw/cfg80211.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/ibss.c        |   67 ++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/ieee80211_i.h |   14 +++++++++
 net/mac80211/util.c        |   40 ++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b2cc1fd..288f512 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -64,6 +64,7 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
 				      struct ieee80211_channel *chan,
+				      enum nl80211_channel_type channel_type,
 				      const u32 basic_rates,
 				      const u16 capability, u64 tsf)
 {
@@ -103,7 +104,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
 	local->oper_channel = chan;
-	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
+	WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	sband = local->hw.wiphy->bands[chan->band];
@@ -118,7 +119,10 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		*pos++ = basic | (u8) (rate / 5);
 	}
 
-	/* Build IBSS probe response */
+	/*
+	 * Build IBSS probe response template (this template is also used
+	 * when sending beacon, see ieee80211_beacon_get_tim())
+	 */
 	mgmt = (void *) skb_put(skb, 24 + sizeof(mgmt->u.beacon));
 	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
@@ -165,6 +169,17 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		memcpy(pos, &supp_rates[8], rates);
 	}
 
+	if (sband->ht_cap.ht_supported) {
+		pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_cap));
+		ieee80211_add_ht_cap(pos, sband);
+	}
+
+	if (channel_type != NL80211_CHAN_NO_HT &&
+	    sband->ht_cap.ht_supported) {
+		pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_info));
+		ieee80211_add_ht_info(pos, sband, chan, channel_type);
+	}
+
 	if (ifibss->ie_len)
 		memcpy(skb_put(skb, ifibss->ie_len),
 		       ifibss->ie, ifibss->ie_len);
@@ -202,6 +217,8 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 basic_rates;
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
+	const u8 *ht_cap_ie, *ht_info_ie;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 
 	if (beacon_int < 10)
 		beacon_int = 10;
@@ -223,9 +240,27 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	/* parse HT Capabilities & Information IE, if present */
+	ht_cap_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_CAPABILITY);
+	ht_info_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_INFORMATION);
+	if (ht_cap_ie && ht_info_ie) {
+		struct ieee80211_ht_cap *ht_cap;
+		struct ieee80211_ht_info *ht_info;
+		struct ieee80211_sta_ht_cap sta_ht_cap;
+
+		ht_cap = (struct ieee80211_ht_cap *)(ht_cap_ie + 2);
+		ht_info = (struct ieee80211_ht_info *)(ht_info_ie + 2);
+
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sband, ht_cap, &sta_ht_cap);
+
+		channel_type = ieee80211_channel_type_from_ht_info(
+					sdata->local, ht_info, sta_ht_cap.cap);
+	}
+
 	__ieee80211_sta_join_ibss(sdata, cbss->bssid,
 				  beacon_int,
 				  cbss->channel,
+				  channel_type,
 				  basic_rates,
 				  cbss->capability,
 				  cbss->tsf);
@@ -529,7 +564,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, 3, /* first two are basic */
+				  ifibss->channel, ifibss->channel_type,
+				  3, /* first two are basic */
 				  capability, 0);
 }
 
@@ -906,13 +942,14 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
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
@@ -922,11 +959,25 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			sdata->u.ibss.ie_len = params->ie_len;
 	}
 
+	/*
+	 * Allocate IBSS probe response template (see
+	 * __ieee80211_sta_join_ibss for the needed size). According to IEEE
+	 * 802.11-2007 10.4.4.2, there is only 20 possibles values. We
+	 * support up IEEE80211_MAX_SUPP_RATES (currently 32) : so 8 for
+	 * Supported Rates and IEEE80211_MAX_SUPP_RATES-8 for Extended
+	 * Supported Rates
+	 */
+
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
+			    2 + IEEE80211_MAX_SUPP_RATES-8 /* max Ext Rates */ +
+			    2 + sizeof(struct ieee80211_ht_cap) +
+			    2 + sizeof(struct ieee80211_ht_info) +
 			    params->ie_len);
 	if (!skb)
 		return -ENOMEM;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 742e12b..78c4716 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -404,6 +404,7 @@ struct ieee80211_if_ibss {
 	u8 ssid_len, ie_len;
 	u8 *ie;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
@@ -1193,6 +1194,19 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
 			 u8 *extra, size_t extra_len, const u8 *bssid,
 			 const u8 *key, u8 key_len, u8 key_idx);
+
+u8 *ieee80211_add_ht_cap(u8 *pos,
+			 struct ieee80211_supported_band *sband);
+
+u8 *ieee80211_add_ht_info(u8 *pos,
+			  struct ieee80211_supported_band *sband,
+			  struct ieee80211_channel *channel,
+			  enum nl80211_channel_type channel_type);
+
+enum nl80211_channel_type ieee80211_channel_type_from_ht_info(
+	struct ieee80211_local *local,
+	struct ieee80211_ht_info *hti, u16 ap_ht_cap_flags);
+
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 047acb8..78c43b8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -898,6 +898,46 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 }
 
+u8 *ieee80211_add_ht_info(u8 *pos,
+			  struct ieee80211_supported_band *sband,
+			  struct ieee80211_channel *channel,
+			  enum nl80211_channel_type channel_type)
+{
+	struct ieee80211_ht_info ht_info;
+
+	ht_info.control_chan =
+		ieee80211_frequency_to_channel(channel->center_freq);
+	ht_info.ht_param = 0;
+	switch (channel_type) {
+	case NL80211_CHAN_NO_HT: /* to make compiler happy */
+	case NL80211_CHAN_HT20:
+		ht_info.ht_param |= IEEE80211_HT_PARAM_CHA_SEC_NONE;
+		break;
+	case NL80211_CHAN_HT40MINUS:
+		ht_info.ht_param |= IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+		break;
+	case NL80211_CHAN_HT40PLUS:
+		ht_info.ht_param |= IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		break;
+	}
+	if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+		ht_info.ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
+	ht_info.operation_mode = cpu_to_le16(0);
+	ht_info.stbc_param = cpu_to_le16(0);
+	/* It seems that Basic MCS set and Supported MCS set are identical
+	 * for the first 10 bytes */
+	memset(&ht_info.basic_set, 0, 16);
+	memcpy(&ht_info.basic_set, &sband->ht_cap.mcs, 10);
+
+	/* HT Information element */
+	*pos++ = WLAN_EID_HT_INFORMATION;
+	*pos++ = sizeof(struct ieee80211_ht_info);
+	memcpy(pos, &ht_info, sizeof(struct ieee80211_ht_info));
+	pos += sizeof(struct ieee80211_ht_info);
+
+	return pos;
+}
+
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band)
-- 
1.5.6.5

