Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYIFO4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 10:56:25 -0400
Subject: [PATCH] mac80211: move IE parsing to util file
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 06 Sep 2008 16:56:22 +0200
Message-Id: <1220712982.9900.2.camel@johannes.berg> (sfid-20080906_165628_731414_4705AA0E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since IE parsing is required for the mlme and mesh code, it's
not a static function anyway, and it's much better to have it
in util rather than the overly large mlme.c

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |  145 ----------------------------------------------------
 net/mac80211/util.c |  144 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 145 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-06 16:51:53.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-06 16:53:44.000000000 +0200
@@ -71,151 +71,6 @@
 #define IEEE80211_MIN_AMPDU_BUF 0x8
 #define IEEE80211_MAX_AMPDU_BUF 0x40
 
-void ieee802_11_parse_elems(u8 *start, size_t len,
-			    struct ieee802_11_elems *elems)
-{
-	size_t left = len;
-	u8 *pos = start;
-
-	memset(elems, 0, sizeof(*elems));
-	elems->ie_start = start;
-	elems->total_len = len;
-
-	while (left >= 2) {
-		u8 id, elen;
-
-		id = *pos++;
-		elen = *pos++;
-		left -= 2;
-
-		if (elen > left)
-			return;
-
-		switch (id) {
-		case WLAN_EID_SSID:
-			elems->ssid = pos;
-			elems->ssid_len = elen;
-			break;
-		case WLAN_EID_SUPP_RATES:
-			elems->supp_rates = pos;
-			elems->supp_rates_len = elen;
-			break;
-		case WLAN_EID_FH_PARAMS:
-			elems->fh_params = pos;
-			elems->fh_params_len = elen;
-			break;
-		case WLAN_EID_DS_PARAMS:
-			elems->ds_params = pos;
-			elems->ds_params_len = elen;
-			break;
-		case WLAN_EID_CF_PARAMS:
-			elems->cf_params = pos;
-			elems->cf_params_len = elen;
-			break;
-		case WLAN_EID_TIM:
-			elems->tim = pos;
-			elems->tim_len = elen;
-			break;
-		case WLAN_EID_IBSS_PARAMS:
-			elems->ibss_params = pos;
-			elems->ibss_params_len = elen;
-			break;
-		case WLAN_EID_CHALLENGE:
-			elems->challenge = pos;
-			elems->challenge_len = elen;
-			break;
-		case WLAN_EID_WPA:
-			if (elen >= 4 && pos[0] == 0x00 && pos[1] == 0x50 &&
-			    pos[2] == 0xf2) {
-				/* Microsoft OUI (00:50:F2) */
-				if (pos[3] == 1) {
-					/* OUI Type 1 - WPA IE */
-					elems->wpa = pos;
-					elems->wpa_len = elen;
-				} else if (elen >= 5 && pos[3] == 2) {
-					if (pos[4] == 0) {
-						elems->wmm_info = pos;
-						elems->wmm_info_len = elen;
-					} else if (pos[4] == 1) {
-						elems->wmm_param = pos;
-						elems->wmm_param_len = elen;
-					}
-				}
-			}
-			break;
-		case WLAN_EID_RSN:
-			elems->rsn = pos;
-			elems->rsn_len = elen;
-			break;
-		case WLAN_EID_ERP_INFO:
-			elems->erp_info = pos;
-			elems->erp_info_len = elen;
-			break;
-		case WLAN_EID_EXT_SUPP_RATES:
-			elems->ext_supp_rates = pos;
-			elems->ext_supp_rates_len = elen;
-			break;
-		case WLAN_EID_HT_CAPABILITY:
-			elems->ht_cap_elem = pos;
-			elems->ht_cap_elem_len = elen;
-			break;
-		case WLAN_EID_HT_EXTRA_INFO:
-			elems->ht_info_elem = pos;
-			elems->ht_info_elem_len = elen;
-			break;
-		case WLAN_EID_MESH_ID:
-			elems->mesh_id = pos;
-			elems->mesh_id_len = elen;
-			break;
-		case WLAN_EID_MESH_CONFIG:
-			elems->mesh_config = pos;
-			elems->mesh_config_len = elen;
-			break;
-		case WLAN_EID_PEER_LINK:
-			elems->peer_link = pos;
-			elems->peer_link_len = elen;
-			break;
-		case WLAN_EID_PREQ:
-			elems->preq = pos;
-			elems->preq_len = elen;
-			break;
-		case WLAN_EID_PREP:
-			elems->prep = pos;
-			elems->prep_len = elen;
-			break;
-		case WLAN_EID_PERR:
-			elems->perr = pos;
-			elems->perr_len = elen;
-			break;
-		case WLAN_EID_CHANNEL_SWITCH:
-			elems->ch_switch_elem = pos;
-			elems->ch_switch_elem_len = elen;
-			break;
-		case WLAN_EID_QUIET:
-			if (!elems->quiet_elem) {
-				elems->quiet_elem = pos;
-				elems->quiet_elem_len = elen;
-			}
-			elems->num_of_quiet_elem++;
-			break;
-		case WLAN_EID_COUNTRY:
-			elems->country_elem = pos;
-			elems->country_elem_len = elen;
-			break;
-		case WLAN_EID_PWR_CONSTRAINT:
-			elems->pwr_constr_elem = pos;
-			elems->pwr_constr_elem_len = elen;
-			break;
-		default:
-			break;
-		}
-
-		left -= elen;
-		pos += elen;
-	}
-}
-
-
 /* BSS handling */
 static struct ieee80211_sta_bss *
 ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
--- everything.orig/net/mac80211/util.c	2008-09-06 16:53:46.000000000 +0200
+++ everything/net/mac80211/util.c	2008-09-06 16:54:54.000000000 +0200
@@ -428,3 +428,147 @@ void ieee80211_iterate_active_interfaces
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
+
+void ieee802_11_parse_elems(u8 *start, size_t len,
+			    struct ieee802_11_elems *elems)
+{
+	size_t left = len;
+	u8 *pos = start;
+
+	memset(elems, 0, sizeof(*elems));
+	elems->ie_start = start;
+	elems->total_len = len;
+
+	while (left >= 2) {
+		u8 id, elen;
+
+		id = *pos++;
+		elen = *pos++;
+		left -= 2;
+
+		if (elen > left)
+			return;
+
+		switch (id) {
+		case WLAN_EID_SSID:
+			elems->ssid = pos;
+			elems->ssid_len = elen;
+			break;
+		case WLAN_EID_SUPP_RATES:
+			elems->supp_rates = pos;
+			elems->supp_rates_len = elen;
+			break;
+		case WLAN_EID_FH_PARAMS:
+			elems->fh_params = pos;
+			elems->fh_params_len = elen;
+			break;
+		case WLAN_EID_DS_PARAMS:
+			elems->ds_params = pos;
+			elems->ds_params_len = elen;
+			break;
+		case WLAN_EID_CF_PARAMS:
+			elems->cf_params = pos;
+			elems->cf_params_len = elen;
+			break;
+		case WLAN_EID_TIM:
+			elems->tim = pos;
+			elems->tim_len = elen;
+			break;
+		case WLAN_EID_IBSS_PARAMS:
+			elems->ibss_params = pos;
+			elems->ibss_params_len = elen;
+			break;
+		case WLAN_EID_CHALLENGE:
+			elems->challenge = pos;
+			elems->challenge_len = elen;
+			break;
+		case WLAN_EID_WPA:
+			if (elen >= 4 && pos[0] == 0x00 && pos[1] == 0x50 &&
+			    pos[2] == 0xf2) {
+				/* Microsoft OUI (00:50:F2) */
+				if (pos[3] == 1) {
+					/* OUI Type 1 - WPA IE */
+					elems->wpa = pos;
+					elems->wpa_len = elen;
+				} else if (elen >= 5 && pos[3] == 2) {
+					if (pos[4] == 0) {
+						elems->wmm_info = pos;
+						elems->wmm_info_len = elen;
+					} else if (pos[4] == 1) {
+						elems->wmm_param = pos;
+						elems->wmm_param_len = elen;
+					}
+				}
+			}
+			break;
+		case WLAN_EID_RSN:
+			elems->rsn = pos;
+			elems->rsn_len = elen;
+			break;
+		case WLAN_EID_ERP_INFO:
+			elems->erp_info = pos;
+			elems->erp_info_len = elen;
+			break;
+		case WLAN_EID_EXT_SUPP_RATES:
+			elems->ext_supp_rates = pos;
+			elems->ext_supp_rates_len = elen;
+			break;
+		case WLAN_EID_HT_CAPABILITY:
+			elems->ht_cap_elem = pos;
+			elems->ht_cap_elem_len = elen;
+			break;
+		case WLAN_EID_HT_EXTRA_INFO:
+			elems->ht_info_elem = pos;
+			elems->ht_info_elem_len = elen;
+			break;
+		case WLAN_EID_MESH_ID:
+			elems->mesh_id = pos;
+			elems->mesh_id_len = elen;
+			break;
+		case WLAN_EID_MESH_CONFIG:
+			elems->mesh_config = pos;
+			elems->mesh_config_len = elen;
+			break;
+		case WLAN_EID_PEER_LINK:
+			elems->peer_link = pos;
+			elems->peer_link_len = elen;
+			break;
+		case WLAN_EID_PREQ:
+			elems->preq = pos;
+			elems->preq_len = elen;
+			break;
+		case WLAN_EID_PREP:
+			elems->prep = pos;
+			elems->prep_len = elen;
+			break;
+		case WLAN_EID_PERR:
+			elems->perr = pos;
+			elems->perr_len = elen;
+			break;
+		case WLAN_EID_CHANNEL_SWITCH:
+			elems->ch_switch_elem = pos;
+			elems->ch_switch_elem_len = elen;
+			break;
+		case WLAN_EID_QUIET:
+			if (!elems->quiet_elem) {
+				elems->quiet_elem = pos;
+				elems->quiet_elem_len = elen;
+			}
+			elems->num_of_quiet_elem++;
+			break;
+		case WLAN_EID_COUNTRY:
+			elems->country_elem = pos;
+			elems->country_elem_len = elen;
+			break;
+		case WLAN_EID_PWR_CONSTRAINT:
+			elems->pwr_constr_elem = pos;
+			elems->pwr_constr_elem_len = elen;
+			break;
+		default:
+			break;
+		}
+
+		left -= elen;
+		pos += elen;
+	}
+}


