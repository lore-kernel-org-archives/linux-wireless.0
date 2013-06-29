Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47106 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3F2W7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jun 2013 18:59:49 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [WT PATCH 6/6] mac80211: Tell user why beacons fail to parse.
Date: Sat, 29 Jun 2013 15:58:58 -0700
Message-Id: <1372546738-25827-6-git-send-email-greearb@candelatech.com> (sfid-20130630_005952_096446_C7F6AD26)
In-Reply-To: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Should help better debug dodgy APs and such.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/mlme.c        |    4 +-
 net/mac80211/scan.c        |    6 +++
 net/mac80211/util.c        |   79 +++++++++++++++++++++++++++++++++++++++----
 4 files changed, 81 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f36f120..809c9a5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -110,6 +110,7 @@ struct ieee80211_bss {
 
 	/* Keep track of what bits of information we have valid info for. */
 	u8 valid_data;
+	char corrupt_elems_msg[80];
 };
 
 /**
@@ -1258,6 +1259,7 @@ struct ieee802_11_elems {
 
 	/* whether a parse error occurred while retrieving these elements */
 	bool parse_error;
+	char parse_err_msg[80];
 };
 
 static inline struct ieee80211_local *hw_to_local(
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ae31968..42edd6c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4341,8 +4341,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 				corrupt_type = "beacon";
 		} else if (bss->corrupt_data & IEEE80211_BSS_CORRUPT_PROBE_RESP)
 			corrupt_type = "probe response";
-		sdata_info(sdata, "associating with AP with corrupt %s\n",
-			   corrupt_type);
+		sdata_info(sdata, "associating with AP with corrupt %s, reason: %s\n",
+			   corrupt_type, bss->corrupt_elems_msg);
 	}
 
 	return 0;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 1b122a7..9dc9c98 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -86,6 +86,8 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		bss->device_ts_presp = rx_status->device_timestamp;
 
 	if (elems->parse_error) {
+		strncpy(bss->corrupt_elems_msg, elems->parse_err_msg,
+			sizeof(bss->corrupt_elems_msg));
 		if (beacon)
 			bss->corrupt_data |= IEEE80211_BSS_CORRUPT_BEACON;
 		else
@@ -95,6 +97,10 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 			bss->corrupt_data &= ~IEEE80211_BSS_CORRUPT_BEACON;
 		else
 			bss->corrupt_data &= ~IEEE80211_BSS_CORRUPT_PROBE_RESP;
+		if (!(bss->corrupt_data &
+		      (IEEE80211_BSS_CORRUPT_BEACON |
+		       IEEE80211_BSS_CORRUPT_PROBE_RESP)))
+			bss->corrupt_elems_msg[0] = 0;
 	}
 
 	/* save the ERP value so that it is available at association time */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2265445..7e6a4f3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -692,6 +692,10 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 
 		if (elen > left) {
 			elems->parse_error = true;
+			snprintf(elems->parse_err_msg,
+				 sizeof(elems->parse_err_msg),
+				 "elen: %hhu > left: %zu",
+				 elen, left);
 			break;
 		}
 
@@ -731,6 +735,9 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		 */
 			if (test_bit(id, seen_elems)) {
 				elems->parse_error = true;
+				snprintf(elems->parse_err_msg,
+					 sizeof(elems->parse_err_msg),
+					 "seen id: %i already", id);
 				left -= elen;
 				pos += elen;
 				continue;
@@ -762,8 +769,14 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			if (elen >= sizeof(struct ieee80211_tim_ie)) {
 				elems->tim = (void *)pos;
 				elems->tim_len = elen;
-			} else
+			} else {
 				elem_parse_failed = true;
+				snprintf(elems->parse_err_msg,
+					 sizeof(elems->parse_err_msg),
+					 "EID_TIM size wrong, elen: %hhu  sizeof(tim_ie): %zu",
+					 elen,
+					 sizeof(struct ieee80211_tim_ie));
+			}
 			break;
 		case WLAN_EID_CHALLENGE:
 			elems->challenge = pos;
@@ -806,32 +819,61 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		case WLAN_EID_HT_CAPABILITY:
 			if (elen >= sizeof(struct ieee80211_ht_cap))
 				elems->ht_cap_elem = (void *)pos;
-			else
+			else {
 				elem_parse_failed = true;
+				snprintf(elems->parse_err_msg,
+					 sizeof(elems->parse_err_msg),
+					 "HT_CAPAB size wrong, elen: %hhu  sizeof(ht_cap): %zu",
+					 elen,
+					 sizeof(struct ieee80211_ht_cap));
+			}
 			break;
 		case WLAN_EID_HT_OPERATION:
 			if (elen >= sizeof(struct ieee80211_ht_operation))
 				elems->ht_operation = (void *)pos;
-			else
+			else {
 				elem_parse_failed = true;
+				snprintf(elems->parse_err_msg,
+					 sizeof(elems->parse_err_msg),
+					 "HT_OPER size wrong, elen: %hhu  sizeof(ht_oper): %zu",
+					 elen,
+					 sizeof(struct ieee80211_ht_operation));
+			}
 			break;
 		case WLAN_EID_VHT_CAPABILITY:
 			if (elen >= sizeof(struct ieee80211_vht_cap))
 				elems->vht_cap_elem = (void *)pos;
-			else
+			else {
 				elem_parse_failed = true;
+				snprintf(elems->parse_err_msg,
+					 sizeof(elems->parse_err_msg),
+					 "EID_VHT size wrong, elen: %hhu  sizeof(vht_cap): %zu",
+					 elen,
+					 sizeof(struct ieee80211_vht_cap));
+			}
 			break;
 		case WLAN_EID_VHT_OPERATION:
 			if (elen >= sizeof(struct ieee80211_vht_operation))
 				elems->vht_operation = (void *)pos;
-			else
+			else {
 				elem_parse_failed = true;
+				snprintf(elems->parse_err_msg,
+					 sizeof(elems->parse_err_msg),
+					 "VHT_OPER size wrong, elen: %hhu  sizeof(vht_oper): %zu",
+					 elen,
+					 sizeof(struct ieee80211_vht_operation));
+			}
 			break;
 		case WLAN_EID_OPMODE_NOTIF:
 			if (elen > 0)
 				elems->opmode_notif = pos;
-			else
+			else {
 				elem_parse_failed = true;
+				snprintf(elems->parse_err_msg,
+					 sizeof(elems->parse_err_msg),
+					 "OPMODE_NOTIF has elen > 0: %hhu",
+					 elen);
+			}
 			break;
 		case WLAN_EID_MESH_ID:
 			elems->mesh_id = pos;
@@ -840,8 +882,14 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		case WLAN_EID_MESH_CONFIG:
 			if (elen >= sizeof(struct ieee80211_meshconf_ie))
 				elems->mesh_config = (void *)pos;
-			else
+			else {
 				elem_parse_failed = true;
+				snprintf(elems->parse_err_msg,
+					 sizeof(elems->parse_err_msg),
+					 "MESH_CONFIG size wrong, elen: %hhu  sizeof(meshconf_ie): %zu",
+					 elen,
+					 sizeof(struct ieee80211_meshconf_ie));
+			}
 			break;
 		case WLAN_EID_PEER_MGMT:
 			elems->peering = pos;
@@ -866,12 +914,23 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		case WLAN_EID_RANN:
 			if (elen >= sizeof(struct ieee80211_rann_ie))
 				elems->rann = (void *)pos;
-			else
+			else {
 				elem_parse_failed = true;
+				snprintf(elems->parse_err_msg,
+					 sizeof(elems->parse_err_msg),
+					 "EID_RANN size wrong, elen: %hhu  sizeof(rann_ie): %zu",
+					 elen,
+					 sizeof(struct ieee80211_rann_ie));
+			}
 			break;
 		case WLAN_EID_CHANNEL_SWITCH:
 			if (elen != sizeof(struct ieee80211_channel_sw_ie)) {
 				elem_parse_failed = true;
+				snprintf(elems->parse_err_msg,
+					 sizeof(elems->parse_err_msg),
+					 "CH_SWITCH size wrong, elen: %hhu  sizeof(sw_ie): %zu",
+					 elen,
+					 sizeof(struct ieee80211_channel_sw_ie));
 				break;
 			}
 			elems->ch_switch_ie = (void *)pos;
@@ -925,6 +984,10 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		case WLAN_EID_PWR_CONSTRAINT:
 			if (elen != 1) {
 				elem_parse_failed = true;
+				snprintf(elems->parse_err_msg,
+					 sizeof(elems->parse_err_msg),
+					 "PWR_CONSTRAINT size not 1, elen: %hhu",
+					 elen);
 				break;
 			}
 			elems->pwr_constr_elem = pos;
-- 
1.7.3.4

