Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43156 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab3BKMi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 07:38:28 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/14] mac80211: handle operating mode notif in beacon/assoc response
Date: Mon, 11 Feb 2013 13:38:13 +0100
Message-Id: <1360586298-15028-10-git-send-email-johannes@sipsolutions.net> (sfid-20130211_134130_597819_915272A6)
In-Reply-To: <1360586298-15028-1-git-send-email-johannes@sipsolutions.net>
References: <[PATCH 00/14] mac80211: HT/VHT handling>
 <1360586298-15028-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In beacons and association response frames an AP may include an
operating mode notification element to advertise changes in the
number of spatial streams it can receive. Handle this using the
existing function that handles the action frame, but only handle
NSS changes, not bandwidth changes which aren't allowed here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  3 ++-
 net/mac80211/mlme.c        | 26 +++++++++++++++++++++++---
 net/mac80211/rx.c          |  3 ++-
 net/mac80211/util.c        |  6 ++++++
 net/mac80211/vht.c         | 22 +++++++++++++---------
 5 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5206b2d..c1bb491 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1189,6 +1189,7 @@ struct ieee802_11_elems {
 	u8 *pwr_constr_elem;
 	u8 *quiet_elem;	/* first quite element */
 	u8 *timeout_int;
+	u8 *opmode_notif;
 
 	/* length of them, respectively */
 	u8 ssid_len;
@@ -1424,7 +1425,7 @@ enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band);
+				 enum ieee80211_band band, bool nss_only);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bc9f464..2d8deaa 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2200,6 +2200,21 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 						  elems.ht_operation,
 						  cbss->bssid, false);
 
+	/*
+	 * If an operating mode notification IE is present, override the
+	 * NSS calculation (that would be done in rate_control_rate_init())
+	 * and use the # of streams from that element.
+	 */
+	if (elems.opmode_notif &&
+	    !(*elems.opmode_notif & IEEE80211_OPMODE_NOTIF_RX_NSS_TYPE_BF)) {
+		u8 nss;
+
+		nss = *elems.opmode_notif & IEEE80211_OPMODE_NOTIF_RX_NSS_MASK;
+		nss >>= IEEE80211_OPMODE_NOTIF_RX_NSS_SHIFT;
+		nss += 1;
+		sta->sta.rx_nss = nss;
+	}
+
 	rate_control_rate_init(sta);
 
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
@@ -2494,6 +2509,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
+	struct sta_info *sta;
 	u32 changed = 0;
 	bool erp_valid;
 	u8 erp_value = 0;
@@ -2732,14 +2748,18 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			le16_to_cpu(mgmt->u.beacon.capab_info),
 			erp_valid, erp_value);
 
-
 	mutex_lock(&local->sta_mtx);
+	sta = sta_info_get(sdata, bssid);
+
 	if (elems.ht_cap_elem && elems.ht_operation && elems.wmm_param &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
-		changed |= ieee80211_config_ht_tx(sdata,
-						  sta_info_get(sdata, bssid),
+		changed |= ieee80211_config_ht_tx(sdata, sta,
 						  elems.ht_operation,
 						  bssid, true);
+
+	if (sta && elems.opmode_notif)
+		ieee80211_vht_handle_opmode(sdata, sta, *elems.opmode_notif,
+					    rx_status->band, true);
 	mutex_unlock(&local->sta_mtx);
 
 	if (elems.country_elem && elems.pwr_constr_elem &&
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1617e0b..30f1ba6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2459,7 +2459,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			opmode = mgmt->u.action.u.vht_opmode_notif.operating_mode;
 
 			ieee80211_vht_handle_opmode(rx->sdata, rx->sta,
-						    opmode, status->band);
+						    opmode, status->band,
+						    false);
 			goto handled;
 		}
 		default:
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index b177b5a..7fca949 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -791,6 +791,12 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			else
 				elem_parse_failed = true;
 			break;
+		case WLAN_EID_OPMODE_NOTIF:
+			if (elen > 0)
+				elems->opmode_notif = pos;
+			else
+				elem_parse_failed = true;
+			break;
 		case WLAN_EID_MESH_ID:
 			elems->mesh_id = pos;
 			elems->mesh_id_len = elen;
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index c9bfbd7..a9549fc 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -141,7 +141,7 @@ void ieee80211_sta_set_rx_nss(struct sta_info *sta)
 
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band)
+				 enum ieee80211_band band, bool nss_only)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -152,11 +152,11 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	sband = local->hw.wiphy->bands[band];
 
 	/* ignore - no support for BF yet */
-	if (opmode & IEEE80211_VHT_OPMODE_RX_NSS_TYPE_BF)
+	if (opmode & IEEE80211_OPMODE_NOTIF_RX_NSS_TYPE_BF)
 		return;
 
-	nss = opmode & IEEE80211_VHT_OPMODE_RX_NSS_MASK;
-	nss >>= IEEE80211_VHT_OPMODE_RX_NSS_SHIFT;
+	nss = opmode & IEEE80211_OPMODE_NOTIF_RX_NSS_MASK;
+	nss >>= IEEE80211_OPMODE_NOTIF_RX_NSS_SHIFT;
 	nss += 1;
 
 	if (sta->sta.rx_nss != nss) {
@@ -164,17 +164,20 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 		changed |= IEEE80211_RC_NSS_CHANGED;
 	}
 
-	switch (opmode & IEEE80211_VHT_OPMODE_CHANWIDTH_MASK) {
-	case IEEE80211_VHT_OPMODE_CHANWIDTH_20MHZ:
+	if (nss_only)
+		goto change;
+
+	switch (opmode & IEEE80211_OPMODE_NOTIF_CHANWIDTH_MASK) {
+	case IEEE80211_OPMODE_NOTIF_CHANWIDTH_20MHZ:
 		sta->cur_max_bandwidth = IEEE80211_STA_RX_BW_20;
 		break;
-	case IEEE80211_VHT_OPMODE_CHANWIDTH_40MHZ:
+	case IEEE80211_OPMODE_NOTIF_CHANWIDTH_40MHZ:
 		sta->cur_max_bandwidth = IEEE80211_STA_RX_BW_40;
 		break;
-	case IEEE80211_VHT_OPMODE_CHANWIDTH_80MHZ:
+	case IEEE80211_OPMODE_NOTIF_CHANWIDTH_80MHZ:
 		sta->cur_max_bandwidth = IEEE80211_STA_RX_BW_80;
 		break;
-	case IEEE80211_VHT_OPMODE_CHANWIDTH_160MHZ:
+	case IEEE80211_OPMODE_NOTIF_CHANWIDTH_160MHZ:
 		sta->cur_max_bandwidth = IEEE80211_STA_RX_BW_160;
 		break;
 	}
@@ -185,6 +188,7 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 		changed |= IEEE80211_RC_NSS_CHANGED;
 	}
 
+ change:
 	if (changed)
 		rate_control_rate_update(local, sband, sta, changed);
 }
-- 
1.8.0

