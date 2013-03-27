Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3C0NkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 09:40:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] mac80211: remove unused IE pointers from parser
Date: Wed, 27 Mar 2013 14:39:54 +0100
Message-Id: <1364391597-3977-2-git-send-email-johannes@sipsolutions.net> (sfid-20130327_144013_704226_47BA0D6D)
In-Reply-To: <1364391597-3977-1-git-send-email-johannes@sipsolutions.net>
References: <1364391597-3977-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to parse IEs that aren't used
so just remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  9 ---------
 net/mac80211/util.c        | 19 -------------------
 2 files changed, 28 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3cf89f7..207b4f3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1157,11 +1157,8 @@ struct ieee802_11_elems {
 	/* pointers to IEs */
 	const u8 *ssid;
 	const u8 *supp_rates;
-	const u8 *fh_params;
 	const u8 *ds_params;
-	const u8 *cf_params;
 	const struct ieee80211_tim_ie *tim;
-	const u8 *ibss_params;
 	const u8 *challenge;
 	const u8 *rsn;
 	const u8 *erp_info;
@@ -1185,7 +1182,6 @@ struct ieee802_11_elems {
 	const struct ieee80211_wide_bw_chansw_ie *wide_bw_chansw_ie;
 	const u8 *country_elem;
 	const u8 *pwr_constr_elem;
-	const u8 *quiet_elem;	/* first quite element */
 	const u8 *timeout_int;
 	const u8 *opmode_notif;
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
@@ -1193,11 +1189,8 @@ struct ieee802_11_elems {
 	/* length of them, respectively */
 	u8 ssid_len;
 	u8 supp_rates_len;
-	u8 fh_params_len;
 	u8 ds_params_len;
-	u8 cf_params_len;
 	u8 tim_len;
-	u8 ibss_params_len;
 	u8 challenge_len;
 	u8 rsn_len;
 	u8 erp_info_len;
@@ -1210,8 +1203,6 @@ struct ieee802_11_elems {
 	u8 prep_len;
 	u8 perr_len;
 	u8 country_elem_len;
-	u8 quiet_elem_len;
-	u8 num_of_quiet_elem;	/* can be more the one */
 	u8 timeout_int_len;
 
 	/* whether a parse error occurred while retrieving these elements */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d253bf4..83e213b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -740,18 +740,10 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			elems->supp_rates = pos;
 			elems->supp_rates_len = elen;
 			break;
-		case WLAN_EID_FH_PARAMS:
-			elems->fh_params = pos;
-			elems->fh_params_len = elen;
-			break;
 		case WLAN_EID_DS_PARAMS:
 			elems->ds_params = pos;
 			elems->ds_params_len = elen;
 			break;
-		case WLAN_EID_CF_PARAMS:
-			elems->cf_params = pos;
-			elems->cf_params_len = elen;
-			break;
 		case WLAN_EID_TIM:
 			if (elen >= sizeof(struct ieee80211_tim_ie)) {
 				elems->tim = (void *)pos;
@@ -759,10 +751,6 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			} else
 				elem_parse_failed = true;
 			break;
-		case WLAN_EID_IBSS_PARAMS:
-			elems->ibss_params = pos;
-			elems->ibss_params_len = elen;
-			break;
 		case WLAN_EID_CHALLENGE:
 			elems->challenge = pos;
 			elems->challenge_len = elen;
@@ -893,13 +881,6 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			}
 			elems->wide_bw_chansw_ie = (void *)pos;
 			break;
-		case WLAN_EID_QUIET:
-			if (!elems->quiet_elem) {
-				elems->quiet_elem = pos;
-				elems->quiet_elem_len = elen;
-			}
-			elems->num_of_quiet_elem++;
-			break;
 		case WLAN_EID_COUNTRY:
 			elems->country_elem = pos;
 			elems->country_elem_len = elen;
-- 
1.8.0

