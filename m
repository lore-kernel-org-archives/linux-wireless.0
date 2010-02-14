Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55881 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab0BNXhn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 18:37:43 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH 2/2] mac80211: Add HT IE to IBSS beacons and probe responses.
Date: Mon, 15 Feb 2010 00:37:33 +0100
Message-Id: <1266190653-2453-2-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
References: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The same code is also used for probe request generation

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/ibss.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/util.c |   23 +++++++------
 2 files changed, 93 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f3e9424..423befa 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -96,6 +96,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
 	local->oper_channel = chan;
+	/* FIXME : we can have HT channels here */
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
@@ -111,7 +112,10 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
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
@@ -158,6 +162,64 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		memcpy(pos, &supp_rates[8], rates);
 	}
 
+	if (sband->ht_cap.ht_supported) {
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
+		/* FIXME : local->oper_channel_type is set to a fixed value */
+		switch (local->oper_channel_type) {
+		case NL80211_CHAN_NO_HT:
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
@@ -903,11 +965,25 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
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
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c453226..591cc71 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -958,7 +958,7 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 
 	if (sband->ht_cap.ht_supported) {
 		u16 cap = sband->ht_cap.cap;
-		__le16 tmp;
+		struct ieee80211_ht_cap ht_cap;
 
 		if (ieee80211_disable_40mhz_24ghz &&
 		    sband->band == IEEE80211_BAND_2GHZ) {
@@ -966,18 +966,19 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
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

