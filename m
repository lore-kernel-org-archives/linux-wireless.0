Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaBDI5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 03:57:11 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: order IEs in association request correctly
Date: Tue,  4 Feb 2014 09:57:03 +0100
Message-Id: <1391504223-12060-3-git-send-email-johannes@sipsolutions.net> (sfid-20140204_095716_626026_E8B26047)
In-Reply-To: <1391504223-12060-1-git-send-email-johannes@sipsolutions.net>
References: <1391504223-12060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In association request frames, there may be IEs passed from
userspace (such as interworking IEs) between HT and VHT, so
add code to insert those inbetween them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6c9ebca..6160483 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -756,6 +756,34 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		ieee80211_add_ht_ie(sdata, skb, assoc_data->ap_ht_param,
 				    sband, chan, sdata->smps_mode);
 
+	/* if present, add any custom IEs that go before VHT */
+	if (assoc_data->ie_len) {
+		static const u8 before_vht[] = {
+			WLAN_EID_SSID,
+			WLAN_EID_SUPP_RATES,
+			WLAN_EID_EXT_SUPP_RATES,
+			WLAN_EID_PWR_CAPABILITY,
+			WLAN_EID_SUPPORTED_CHANNELS,
+			WLAN_EID_RSN,
+			WLAN_EID_QOS_CAPA,
+			WLAN_EID_RRM_ENABLED_CAPABILITIES,
+			WLAN_EID_MOBILITY_DOMAIN,
+			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
+			WLAN_EID_HT_CAPABILITY,
+			WLAN_EID_BSS_COEX_2040,
+			WLAN_EID_EXT_CAPABILITY,
+			WLAN_EID_QOS_TRAFFIC_CAPA,
+			WLAN_EID_TIM_BCAST_REQ,
+			WLAN_EID_INTERWORKING,
+		};
+		noffset = ieee80211_ie_split(assoc_data->ie, assoc_data->ie_len,
+					     before_vht, ARRAY_SIZE(before_vht),
+					     offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, assoc_data->ie + offset, noffset - offset);
+		offset = noffset;
+	}
+
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 		ieee80211_add_vht_ie(sdata, skb, sband,
 				     &assoc_data->ap_vht_cap);
-- 
1.8.5.3

