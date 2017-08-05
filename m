Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42276 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751425AbdHEIpX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 04:45:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Sat,  5 Aug 2017 11:44:32 +0300
Message-Id: <20170805084438.12550-5-luca@coelho.fi> (sfid-20170805_104529_070222_4774147F)
In-Reply-To: <20170805084438.12550-1-luca@coelho.fi>
References: <20170805084438.12550-1-luca@coelho.fi>
Subject: [PATCH 04/10] mac80211: simplify and clarify IE splitting
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to split off IEs from the ones obtained
from userspace, if they were already split off, so for
example IEs that went before HT don't have to be listed
again to go before VHT. Simplify the code here so it's
clearer.

While at it, also clarify the comments regarding the DMG
(60 GHz) elements.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 19 +++++++------------
 net/mac80211/util.c | 21 +++++++++------------
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7be7917e1541..5bb570643494 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -780,11 +780,12 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
 			WLAN_EID_HT_CAPABILITY,
 			WLAN_EID_BSS_COEX_2040,
+			/* luckily this is almost always there */
 			WLAN_EID_EXT_CAPABILITY,
 			WLAN_EID_QOS_TRAFFIC_CAPA,
 			WLAN_EID_TIM_BCAST_REQ,
 			WLAN_EID_INTERWORKING,
-			/* 60GHz doesn't happen right now */
+			/* 60 GHz (Multi-band, DMG, MMS) can't happen */
 			WLAN_EID_VHT_CAPABILITY,
 			WLAN_EID_OPMODE_NOTIF,
 		};
@@ -812,22 +813,16 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	/* if present, add any custom IEs that go before VHT */
 	if (assoc_data->ie_len) {
 		static const u8 before_vht[] = {
-			WLAN_EID_SSID,
-			WLAN_EID_SUPP_RATES,
-			WLAN_EID_EXT_SUPP_RATES,
-			WLAN_EID_PWR_CAPABILITY,
-			WLAN_EID_SUPPORTED_CHANNELS,
-			WLAN_EID_RSN,
-			WLAN_EID_QOS_CAPA,
-			WLAN_EID_RRM_ENABLED_CAPABILITIES,
-			WLAN_EID_MOBILITY_DOMAIN,
-			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
-			WLAN_EID_HT_CAPABILITY,
+			/*
+			 * no need to list the ones split off before HT
+			 * or generated here
+			 */
 			WLAN_EID_BSS_COEX_2040,
 			WLAN_EID_EXT_CAPABILITY,
 			WLAN_EID_QOS_TRAFFIC_CAPA,
 			WLAN_EID_TIM_BCAST_REQ,
 			WLAN_EID_INTERWORKING,
+			/* 60 GHz (Multi-band, DMG, MMS) can't happen */
 		};
 
 		/* RIC already taken above, so no need to handle here anymore */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6aef6793d052..bfecc3e86318 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1392,10 +1392,10 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 	/* insert custom IEs that go before HT */
 	if (ie && ie_len) {
 		static const u8 before_ht[] = {
-			WLAN_EID_SSID,
-			WLAN_EID_SUPP_RATES,
-			WLAN_EID_REQUEST,
-			WLAN_EID_EXT_SUPP_RATES,
+			/*
+			 * no need to list the ones split off already
+			 * (or generated here)
+			 */
 			WLAN_EID_DS_PARAMS,
 			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
 		};
@@ -1424,20 +1424,17 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 	/* insert custom IEs that go before VHT */
 	if (ie && ie_len) {
 		static const u8 before_vht[] = {
-			WLAN_EID_SSID,
-			WLAN_EID_SUPP_RATES,
-			WLAN_EID_REQUEST,
-			WLAN_EID_EXT_SUPP_RATES,
-			WLAN_EID_DS_PARAMS,
-			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
-			WLAN_EID_HT_CAPABILITY,
+			/*
+			 * no need to list the ones split off already
+			 * (or generated here)
+			 */
 			WLAN_EID_BSS_COEX_2040,
 			WLAN_EID_EXT_CAPABILITY,
 			WLAN_EID_SSID_LIST,
 			WLAN_EID_CHANNEL_USAGE,
 			WLAN_EID_INTERWORKING,
 			WLAN_EID_MESH_ID,
-			/* 60 GHz can't happen here right now */
+			/* 60 GHz (Multi-band, DMG, MMS) can't happen */
 		};
 		noffset = ieee80211_ie_split(ie, ie_len,
 					     before_vht, ARRAY_SIZE(before_vht),
-- 
2.13.2
