Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946785Ab3BHRZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:25:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 09/14] mac80211: handle operating mode notification in beacons
Date: Fri,  8 Feb 2013 18:25:39 +0100
Message-Id: <1360344344-15742-10-git-send-email-johannes@sipsolutions.net> (sfid-20130208_182938_961640_DFFBDB6D)
In-Reply-To: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In beacons, an AP may include an operating mode notification
element to advertise changes in the number of spatial streams
it can receive. Handle this using the existing function that
handles the action frame, but only handle NSS changes, not
bandwidth changes which aren't allowed here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  3 ++-
 net/mac80211/mlme.c        | 11 ++++++++---
 net/mac80211/rx.c          |  3 ++-
 net/mac80211/util.c        |  6 ++++++
 net/mac80211/vht.c         |  6 +++++-
 5 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 78b27e0..9ee9e63 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1196,6 +1196,7 @@ struct ieee802_11_elems {
 	u8 *pwr_constr_elem;
 	u8 *quiet_elem;	/* first quite element */
 	u8 *timeout_int;
+	u8 *vht_opmode;
 
 	/* length of them, respectively */
 	u8 ssid_len;
@@ -1431,7 +1432,7 @@ enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band);
+				 enum ieee80211_band band, bool nss_only);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 23c3604..1ef3efe 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2494,6 +2494,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
+	struct sta_info *sta;
 	u32 changed = 0;
 	bool erp_valid;
 	u8 erp_value = 0;
@@ -2732,14 +2733,18 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
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
+	if (sta && elems.vht_opmode)
+		ieee80211_vht_handle_opmode(sdata, sta, *elems.vht_opmode,
+					    rx_status->band, true);
 	mutex_unlock(&local->sta_mtx);
 
 	if (elems.country_elem && elems.pwr_constr_elem &&
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bef2a58..12a968b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2451,7 +2451,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			opmode = mgmt->u.action.u.vht_opmode_notif.operating_mode;
 
 			ieee80211_vht_handle_opmode(rx->sdata, rx->sta,
-						    opmode, status->band);
+						    opmode, status->band,
+						    false);
 			goto handled;
 		}
 		default:
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index b177b5a..c151ba2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -791,6 +791,12 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			else
 				elem_parse_failed = true;
 			break;
+		case WLAN_EID_VHT_OPMODE_NOTIF:
+			if (elen > 0)
+				elems->vht_opmode = pos;
+			else
+				elem_parse_failed = true;
+			break;
 		case WLAN_EID_MESH_ID:
 			elems->mesh_id = pos;
 			elems->mesh_id_len = elen;
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index a7d0d6d..3bb0eae 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -131,7 +131,7 @@ void ieee80211_sta_set_rx_nss(struct sta_info *sta)
 
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band)
+				 enum ieee80211_band band, bool nss_only)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -153,6 +153,9 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 		changed |= IEEE80211_RC_NSS_CHANGED;
 	}
 
+	if (nss_only)
+		goto change;
+
 	switch (opmode & IEEE80211_VHT_OPMODE_CHANWIDTH_MASK) {
 	case IEEE80211_VHT_OPMODE_CHANWIDTH_20MHZ:
 		sta->vht_opmode_bandwidth = IEEE80211_STA_RX_BW_20;
@@ -174,6 +177,7 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 		changed |= IEEE80211_RC_NSS_CHANGED;
 	}
 
+ change:
 	if (changed)
 		rate_control_rate_update(local, sband, sta, changed);
 }
-- 
1.8.0

