Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbYJGRbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 13:31:18 -0400
Subject: [PATCH] mac80211: fix HT information element parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 19:31:17 +0200
Message-Id: <1223400677.7328.56.camel@johannes.berg> (sfid-20081007_193122_775937_E30C2F72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no checking that the HT IEs are of the right length
which can be used by an attacker to cause an out-of-bounds
access by sending a too short HT information/capability IE.
Fix it by simply pretending those IEs didn't exist when too
short.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    6 ++----
 net/mac80211/mlme.c        |    3 ---
 net/mac80211/util.c        |    8 ++++----
 3 files changed, 6 insertions(+), 11 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-10-07 16:52:04.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-10-07 16:53:04.000000000 +0200
@@ -816,8 +816,8 @@ struct ieee802_11_elems {
 	u8 *ext_supp_rates;
 	u8 *wmm_info;
 	u8 *wmm_param;
-	u8 *ht_cap_elem;
-	u8 *ht_info_elem;
+	struct ieee80211_ht_cap *ht_cap_elem;
+	struct ieee80211_ht_addt_info *ht_info_elem;
 	u8 *mesh_config;
 	u8 *mesh_id;
 	u8 *peer_link;
@@ -844,8 +844,6 @@ struct ieee802_11_elems {
 	u8 ext_supp_rates_len;
 	u8 wmm_info_len;
 	u8 wmm_param_len;
-	u8 ht_cap_elem_len;
-	u8 ht_info_elem_len;
 	u8 mesh_config_len;
 	u8 mesh_id_len;
 	u8 peer_link_len;
--- everything.orig/net/mac80211/mlme.c	2008-10-07 16:52:45.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-10-07 16:54:01.000000000 +0200
@@ -1347,10 +1347,8 @@ static void ieee80211_rx_mgmt_assoc_resp
 	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
 		struct ieee80211_ht_bss_info bss_info;
 		ieee80211_ht_cap_ie_to_ht_info(
-				(struct ieee80211_ht_cap *)
 				elems.ht_cap_elem, &sta->sta.ht_info);
 		ieee80211_ht_addt_info_ie_to_ht_bss_info(
-				(struct ieee80211_ht_addt_info *)
 				elems.ht_info_elem, &bss_info);
 		ieee80211_handle_ht(local, 1, &sta->sta.ht_info, &bss_info);
 	}
@@ -1713,7 +1711,6 @@ static void ieee80211_rx_mgmt_beacon(str
 		struct ieee80211_ht_bss_info bss_info;
 
 		ieee80211_ht_addt_info_ie_to_ht_bss_info(
-				(struct ieee80211_ht_addt_info *)
 				elems.ht_info_elem, &bss_info);
 		changed |= ieee80211_handle_ht(local, 1, &conf->ht_conf,
 					       &bss_info);
--- everything.orig/net/mac80211/util.c	2008-10-07 16:51:56.000000000 +0200
+++ everything/net/mac80211/util.c	2008-10-07 16:54:57.000000000 +0200
@@ -529,12 +529,12 @@ void ieee802_11_parse_elems(u8 *start, s
 			elems->ext_supp_rates_len = elen;
 			break;
 		case WLAN_EID_HT_CAPABILITY:
-			elems->ht_cap_elem = pos;
-			elems->ht_cap_elem_len = elen;
+			if (elen >= sizeof(struct ieee80211_ht_cap))
+				elems->ht_cap_elem = (void *)pos;
 			break;
 		case WLAN_EID_HT_EXTRA_INFO:
-			elems->ht_info_elem = pos;
-			elems->ht_info_elem_len = elen;
+			if (elen >= sizeof(struct ieee80211_ht_addt_info))
+				elems->ht_info_elem = (void *)pos;
 			break;
 		case WLAN_EID_MESH_ID:
 			elems->mesh_id = pos;


