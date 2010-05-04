Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:51210 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940Ab0EDGrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 02:47:11 -0400
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] mac80211: Add HT IE to IBSS beacons and probe responses.
Date: Tue,  4 May 2010 08:47:02 +0200
Message-Id: <1272955622-6987-3-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1272955622-6987-2-git-send-email-benoit.papillault@free.fr>
References: <1272955622-6987-1-git-send-email-benoit.papillault@free.fr>
 <1272955622-6987-2-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an HT IBSS is configured, we add HT Information and HT Capabilities
IE to beacon & probe responses. This is done according to channel_type
transmitted by iw/cfg80211.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/ibss.c        |  114 +++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/util.c        |   23 +++++----
 3 files changed, 120 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f657854..c501d3b 100644
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
-	local->oper_channel_type = NL80211_CHAN_NO_HT;
+	local->oper_channel_type = channel_type;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	sband = local->hw.wiphy->bands[chan->band];
@@ -118,7 +119,10 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		*pos++ = basic | (u8) (rate / 5);
 	}
 
-	/* Build IBSS probe response */
+	/* 
+	 * Build IBSS probe response template (also used for beacon template
+	 * in ieee80211_beacon_get_tim())
+	 */
 	mgmt = (void *) skb_put(skb, 24 + sizeof(mgmt->u.beacon));
 	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
@@ -165,6 +169,64 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		memcpy(pos, &supp_rates[8], rates);
 	}
 
+	if (channel_type != NL80211_CHAN_NO_HT &&
+	    sband->ht_cap.ht_supported) {
+		u16 cap = sband->ht_cap.cap;
+		struct ieee80211_ht_cap ht_cap;
+		struct ieee80211_ht_info ht_info;
+
+		if (ieee80211_disable_40mhz_24ghz &&
+		    sband->band == IEEE80211_BAND_2GHZ) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+
+		ht_cap.cap_info = cpu_to_le16(cap);
+		ht_cap.ampdu_params_info = sband->ht_cap.ampdu_factor |
+			(sband->ht_cap.ampdu_density <<
+			 IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+		ht_cap.mcs = sband->ht_cap.mcs;
+		ht_cap.extended_ht_cap_info = cpu_to_le16(0);
+		ht_cap.tx_BF_cap_info = cpu_to_le32(0);
+		ht_cap.antenna_selection_info = 0;
+
+		/* HT Capabilities element */
+		pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_cap));
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		memcpy(pos, &ht_cap, sizeof(struct ieee80211_ht_cap));
+
+		ht_info.control_chan = 
+			ieee80211_frequency_to_channel(chan->center_freq);
+		ht_info.ht_param = 0;
+		switch (local->oper_channel_type) {
+		case NL80211_CHAN_NO_HT: /* to make compiler happy */
+		case NL80211_CHAN_HT20:
+			ht_info.ht_param |= IEEE80211_HT_PARAM_CHA_SEC_NONE;
+			break;
+		case NL80211_CHAN_HT40MINUS:
+			ht_info.ht_param |= IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+			break;
+		case NL80211_CHAN_HT40PLUS:
+			ht_info.ht_param |= IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+			break;
+		}
+		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+			ht_info.ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
+		ht_info.operation_mode = cpu_to_le16(0);
+		ht_info.stbc_param = cpu_to_le16(0);
+		/* It seems that Basic MCS set and Supported MCS set
+		   are identical for the first 10 bytes */
+		memset(&ht_info.basic_set, 0, 16);
+		memcpy(&ht_info.basic_set, &ht_cap.mcs, 10);
+
+		/* HT Information element */
+		pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_info));
+		*pos++ = WLAN_EID_HT_INFORMATION;
+		*pos++ = sizeof(struct ieee80211_ht_info);
+		memcpy(pos, &ht_info, sizeof(struct ieee80211_ht_info));
+	}
+	  
 	if (ifibss->ie_len)
 		memcpy(skb_put(skb, ifibss->ie_len),
 		       ifibss->ie, ifibss->ie_len);
@@ -202,6 +264,9 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 basic_rates;
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
+	const u8 * ht_info_ie;
+	const struct ieee80211_ht_info *ht_info;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 
 	if (beacon_int < 10)
 		beacon_int = 10;
@@ -223,9 +288,28 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	/* parse HT Information IE, if present */
+	ht_info_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_INFORMATION);
+	if (ht_info_ie) {
+		ht_info = (const struct ieee80211_ht_info *)(ht_info_ie + 2);
+		switch (ht_info->ht_param
+			& IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
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
@@ -529,7 +613,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, 3, /* first two are basic */
+				  ifibss->channel, ifibss->channel_type,
+				  3, /* first two are basic */
 				  capability, 0);
 }
 
@@ -906,6 +991,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
 	sdata->u.ibss.channel = params->channel;
+	sdata->u.ibss.channel_type = params->channel_type;
 	sdata->u.ibss.fixed_channel = params->channel_fixed;
 
 	if (params->ie) {
@@ -915,11 +1001,25 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
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
+			    2 + (IEEE80211_MAX_SUPP_RATES-8) /* max Ext Rates */ +
+			    2 + sizeof(struct ieee80211_ht_cap) +
+			    2 + sizeof(struct ieee80211_ht_info) +
 			    params->ie_len);
 	if (!skb)
 		return -ENOMEM;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c8077a3..30876f3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -404,6 +404,7 @@ struct ieee80211_if_ibss {
 	u8 ssid_len, ie_len;
 	u8 *ie;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2b75b4f..b83f264 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -967,7 +967,7 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 
 	if (sband->ht_cap.ht_supported) {
 		u16 cap = sband->ht_cap.cap;
-		__le16 tmp;
+		struct ieee80211_ht_cap ht_cap;
 
 		if (ieee80211_disable_40mhz_24ghz &&
 		    sband->band == IEEE80211_BAND_2GHZ) {
@@ -975,18 +975,19 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			cap &= ~IEEE80211_HT_CAP_SGI_40;
 		}
 
+		ht_cap.cap_info = cpu_to_le16(cap);
+		ht_cap.ampdu_params_info = sband->ht_cap.ampdu_factor |
+			(sband->ht_cap.ampdu_density <<
+			 IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+		ht_cap.mcs = sband->ht_cap.mcs;
+		ht_cap.extended_ht_cap_info = cpu_to_le16(0);
+		ht_cap.tx_BF_cap_info = cpu_to_le32(0);
+		ht_cap.antenna_selection_info = 0;
+
 		*pos++ = WLAN_EID_HT_CAPABILITY;
 		*pos++ = sizeof(struct ieee80211_ht_cap);
-		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
-		tmp = cpu_to_le16(cap);
-		memcpy(pos, &tmp, sizeof(u16));
-		pos += sizeof(u16);
-		*pos++ = sband->ht_cap.ampdu_factor |
-			 (sband->ht_cap.ampdu_density <<
-				IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
-		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-		pos += sizeof(sband->ht_cap.mcs);
-		pos += 2 + 4 + 1; /* ext info, BF cap, antsel */
+		memcpy(pos, &ht_cap, sizeof(struct ieee80211_ht_cap));
+		pos += sizeof(struct ieee80211_ht_cap);
 	}
 
 	/*
-- 
1.5.6.5

