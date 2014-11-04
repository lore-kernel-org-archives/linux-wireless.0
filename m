Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52561 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaKDJ5G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 04:57:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: handle RIC data element in reassociation request
Date: Tue,  4 Nov 2014 10:56:59 +0100
Message-Id: <1415095019-14193-1-git-send-email-johannes@sipsolutions.net> (sfid-20141104_105716_793531_35BE1356)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the RIC data element (RDE) is included in the IEs coming
from userspace for an association request, its handling is
currently broken as any IEs that are contained within it would
be split off from it and inserted again after all the IEs that
mac80211 generates (e.g. HT, VHT.)

To fix this, treat the RIC element specially, and stop after
it only when we find something that doesn't actually belong to
it. This assumes userspace is actually correctly building it,
directly after the fast BSS transition IE and before all the
others like extended capabilities.

This leaves as a potential problem the case where userspace is
building the following IEs:

[RDE] [vendor resource description] [vendor non-resource IE]

In this case, we'd erroneously consider all three IEs to be
part of the RIC data together, and not split them between the
two vendor IEs. Unfortunately, it isn't easily possible to
distinguish vendor IEs, so this isn't easy to fix. Luckily,
this case is rare as normally wpa_supplicant will include an
extended capabilities IE in the IEs, and that certainly will
break the two vendor IEs apart correctly.

Reviewed-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  4 ++++
 net/mac80211/mlme.c        | 27 ++++++++++++++++++++++++---
 net/mac80211/util.c        | 26 ++++++++++++++++++++++----
 3 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index fbd6bee9c959..a51c993ece73 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1903,6 +1903,10 @@ int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
 void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_min_chandef(struct ieee80211_sub_if_data *sdata);
 
+size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
+			      const u8 *ids, int n_ids,
+			      const u8 *after_ric, int n_after_ric,
+			      size_t offset);
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
 u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			      u16 cap);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c078cd344ca4..213a420704a6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -775,11 +775,30 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			WLAN_EID_QOS_CAPA,
 			WLAN_EID_RRM_ENABLED_CAPABILITIES,
 			WLAN_EID_MOBILITY_DOMAIN,
+			WLAN_EID_FAST_BSS_TRANSITION,	/* reassoc only */
+			WLAN_EID_RIC_DATA,		/* reassoc only */
 			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
 		};
-		noffset = ieee80211_ie_split(assoc_data->ie, assoc_data->ie_len,
-					     before_ht, ARRAY_SIZE(before_ht),
-					     offset);
+		static const u8 after_ric[] = {
+			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
+			WLAN_EID_HT_CAPABILITY,
+			WLAN_EID_BSS_COEX_2040,
+			WLAN_EID_EXT_CAPABILITY,
+			WLAN_EID_QOS_TRAFFIC_CAPA,
+			WLAN_EID_TIM_BCAST_REQ,
+			WLAN_EID_INTERWORKING,
+			/* 60GHz doesn't happen right now */
+			WLAN_EID_VHT_CAPABILITY,
+			WLAN_EID_OPMODE_NOTIF,
+		};
+
+		noffset = ieee80211_ie_split_ric(assoc_data->ie,
+						 assoc_data->ie_len,
+						 before_ht,
+						 ARRAY_SIZE(before_ht),
+						 after_ric,
+						 ARRAY_SIZE(after_ric),
+						 offset);
 		pos = skb_put(skb, noffset - offset);
 		memcpy(pos, assoc_data->ie + offset, noffset - offset);
 		offset = noffset;
@@ -813,6 +832,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			WLAN_EID_TIM_BCAST_REQ,
 			WLAN_EID_INTERWORKING,
 		};
+
+		/* RIC already taken above, so no need to handle here anymore */
 		noffset = ieee80211_ie_split(assoc_data->ie, assoc_data->ie_len,
 					     before_vht, ARRAY_SIZE(before_vht),
 					     offset);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 91e16b4d4e3c..5f7b0e935b65 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2101,16 +2101,34 @@ static bool ieee80211_id_in_list(const u8 *ids, int n_ids, u8 id)
 	return false;
 }
 
-size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
-			  const u8 *ids, int n_ids, size_t offset)
+size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
+			      const u8 *ids, int n_ids,
+			      const u8 *after_ric, int n_after_ric,
+			      size_t offset)
 {
 	size_t pos = offset;
 
-	while (pos < ielen && ieee80211_id_in_list(ids, n_ids, ies[pos]))
-		pos += 2 + ies[pos + 1];
+	while (pos < ielen && ieee80211_id_in_list(ids, n_ids, ies[pos])) {
+		if (ies[pos] == WLAN_EID_RIC_DATA && n_after_ric) {
+			pos += 2 + ies[pos + 1];
+
+			while (pos < ielen &&
+			       !ieee80211_id_in_list(after_ric, n_after_ric,
+						     ies[pos]))
+				pos += 2 + ies[pos + 1];
+		} else {
+			pos += 2 + ies[pos + 1];
+		}
+	}
 
 	return pos;
 }
+
+size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
+			  const u8 *ids, int n_ids, size_t offset)
+{
+	return ieee80211_ie_split_ric(ies, ielen, ids, n_ids, NULL, 0, offset);
+}
 EXPORT_SYMBOL(ieee80211_ie_split);
 
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset)
-- 
2.1.1

