Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:58915 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1HJA43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 20:56:29 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] cfg80211/mac80211: move information element parsing logic to cfg80211
Date: Tue,  9 Aug 2011 18:02:26 -0700
Message-Id: <1312938146-18704-1-git-send-email-bzhao@marvell.com> (sfid-20110810_025634_441510_07F0CAA5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Moving the parsing logic for retrieving the information elements
stored in management frames, e.g. beacons or probe responses,
and making it available to other cfg80211 drivers.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/net/cfg80211.h     |   63 ++++++++++++++++
 net/mac80211/ieee80211_i.h |   63 ----------------
 net/mac80211/util.c        |  167 -------------------------------------------
 net/wireless/util.c        |  168 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 231 insertions(+), 230 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 44e72cc..b71941a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2225,6 +2225,69 @@ extern int ieee80211_radiotap_iterator_next(
 extern const unsigned char rfc1042_header[6];
 extern const unsigned char bridge_tunnel_header[6];
 
+/* Parsed Information Elements */
+struct ieee802_11_elems {
+	u8 *ie_start;
+	size_t total_len;
+
+	/* pointers to IEs */
+	u8 *ssid;
+	u8 *supp_rates;
+	u8 *fh_params;
+	u8 *ds_params;
+	u8 *cf_params;
+	struct ieee80211_tim_ie *tim;
+	u8 *ibss_params;
+	u8 *challenge;
+	u8 *wpa;
+	u8 *rsn;
+	u8 *erp_info;
+	u8 *ext_supp_rates;
+	u8 *wmm_info;
+	u8 *wmm_param;
+	struct ieee80211_ht_cap *ht_cap_elem;
+	struct ieee80211_ht_info *ht_info_elem;
+	struct ieee80211_meshconf_ie *mesh_config;
+	u8 *mesh_id;
+	u8 *peer_link;
+	u8 *preq;
+	u8 *prep;
+	u8 *perr;
+	struct ieee80211_rann_ie *rann;
+	u8 *ch_switch_elem;
+	u8 *country_elem;
+	u8 *pwr_constr_elem;
+	u8 *quiet_elem;	/* first quite element */
+	u8 *timeout_int;
+
+	/* length of them, respectively */
+	u8 ssid_len;
+	u8 supp_rates_len;
+	u8 fh_params_len;
+	u8 ds_params_len;
+	u8 cf_params_len;
+	u8 tim_len;
+	u8 ibss_params_len;
+	u8 challenge_len;
+	u8 wpa_len;
+	u8 rsn_len;
+	u8 erp_info_len;
+	u8 ext_supp_rates_len;
+	u8 wmm_info_len;
+	u8 wmm_param_len;
+	u8 mesh_id_len;
+	u8 peer_link_len;
+	u8 preq_len;
+	u8 prep_len;
+	u8 perr_len;
+	u8 ch_switch_elem_len;
+	u8 country_elem_len;
+	u8 pwr_constr_elem_len;
+	u8 quiet_elem_len;
+	u8 num_of_quiet_elem;	/* can be more the one */
+	u8 timeout_int_len;
+};
+
 /**
  * ieee80211_get_hdrlen_from_skb - get header length from data
  *
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 286ac5d..ea74190 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1021,69 +1021,6 @@ struct ieee80211_ra_tid {
 	u16 tid;
 };
 
-/* Parsed Information Elements */
-struct ieee802_11_elems {
-	u8 *ie_start;
-	size_t total_len;
-
-	/* pointers to IEs */
-	u8 *ssid;
-	u8 *supp_rates;
-	u8 *fh_params;
-	u8 *ds_params;
-	u8 *cf_params;
-	struct ieee80211_tim_ie *tim;
-	u8 *ibss_params;
-	u8 *challenge;
-	u8 *wpa;
-	u8 *rsn;
-	u8 *erp_info;
-	u8 *ext_supp_rates;
-	u8 *wmm_info;
-	u8 *wmm_param;
-	struct ieee80211_ht_cap *ht_cap_elem;
-	struct ieee80211_ht_info *ht_info_elem;
-	struct ieee80211_meshconf_ie *mesh_config;
-	u8 *mesh_id;
-	u8 *peer_link;
-	u8 *preq;
-	u8 *prep;
-	u8 *perr;
-	struct ieee80211_rann_ie *rann;
-	u8 *ch_switch_elem;
-	u8 *country_elem;
-	u8 *pwr_constr_elem;
-	u8 *quiet_elem; 	/* first quite element */
-	u8 *timeout_int;
-
-	/* length of them, respectively */
-	u8 ssid_len;
-	u8 supp_rates_len;
-	u8 fh_params_len;
-	u8 ds_params_len;
-	u8 cf_params_len;
-	u8 tim_len;
-	u8 ibss_params_len;
-	u8 challenge_len;
-	u8 wpa_len;
-	u8 rsn_len;
-	u8 erp_info_len;
-	u8 ext_supp_rates_len;
-	u8 wmm_info_len;
-	u8 wmm_param_len;
-	u8 mesh_id_len;
-	u8 peer_link_len;
-	u8 preq_len;
-	u8 prep_len;
-	u8 perr_len;
-	u8 ch_switch_elem_len;
-	u8 country_elem_len;
-	u8 pwr_constr_elem_len;
-	u8 quiet_elem_len;
-	u8 num_of_quiet_elem;	/* can be more the one */
-	u8 timeout_int_len;
-};
-
 static inline struct ieee80211_local *hw_to_local(
 	struct ieee80211_hw *hw)
 {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ddeb1b9..7d582fd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -19,7 +19,6 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <linux/bitmap.h>
-#include <linux/crc32.h>
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
@@ -573,172 +572,6 @@ void ieee802_11_parse_elems(u8 *start, size_t len,
 	ieee802_11_parse_elems_crc(start, len, elems, 0, 0);
 }
 
-u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
-			       struct ieee802_11_elems *elems,
-			       u64 filter, u32 crc)
-{
-	size_t left = len;
-	u8 *pos = start;
-	bool calc_crc = filter != 0;
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
-			break;
-
-		if (calc_crc && id < 64 && (filter & (1ULL << id)))
-			crc = crc32_be(crc, pos - 2, elen + 2);
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
-			if (elen >= sizeof(struct ieee80211_tim_ie)) {
-				elems->tim = (void *)pos;
-				elems->tim_len = elen;
-			}
-			break;
-		case WLAN_EID_IBSS_PARAMS:
-			elems->ibss_params = pos;
-			elems->ibss_params_len = elen;
-			break;
-		case WLAN_EID_CHALLENGE:
-			elems->challenge = pos;
-			elems->challenge_len = elen;
-			break;
-		case WLAN_EID_VENDOR_SPECIFIC:
-			if (elen >= 4 && pos[0] == 0x00 && pos[1] == 0x50 &&
-			    pos[2] == 0xf2) {
-				/* Microsoft OUI (00:50:F2) */
-
-				if (calc_crc)
-					crc = crc32_be(crc, pos - 2, elen + 2);
-
-				if (pos[3] == 1) {
-					/* OUI Type 1 - WPA IE */
-					elems->wpa = pos;
-					elems->wpa_len = elen;
-				} else if (elen >= 5 && pos[3] == 2) {
-					/* OUI Type 2 - WMM IE */
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
-			if (elen >= sizeof(struct ieee80211_ht_cap))
-				elems->ht_cap_elem = (void *)pos;
-			break;
-		case WLAN_EID_HT_INFORMATION:
-			if (elen >= sizeof(struct ieee80211_ht_info))
-				elems->ht_info_elem = (void *)pos;
-			break;
-		case WLAN_EID_MESH_ID:
-			elems->mesh_id = pos;
-			elems->mesh_id_len = elen;
-			break;
-		case WLAN_EID_MESH_CONFIG:
-			if (elen >= sizeof(struct ieee80211_meshconf_ie))
-				elems->mesh_config = (void *)pos;
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
-		case WLAN_EID_RANN:
-			if (elen >= sizeof(struct ieee80211_rann_ie))
-				elems->rann = (void *)pos;
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
-		case WLAN_EID_TIMEOUT_INTERVAL:
-			elems->timeout_int = pos;
-			elems->timeout_int_len = elen;
-			break;
-		default:
-			break;
-		}
-
-		left -= elen;
-		pos += elen;
-	}
-
-	return crc;
-}
-
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index be75a3a..844ddb0 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -6,6 +6,7 @@
 #include <linux/bitops.h>
 #include <linux/etherdevice.h>
 #include <linux/slab.h>
+#include <linux/crc32.h>
 #include <net/cfg80211.h>
 #include <net/ip.h>
 #include "core.h"
@@ -1044,3 +1045,170 @@ int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 
 	return 0;
 }
+
+u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
+			       struct ieee802_11_elems *elems,
+			       u64 filter, u32 crc)
+{
+	size_t left = len;
+	u8 *pos = start;
+	bool calc_crc = filter != 0;
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
+			break;
+
+		if (calc_crc && id < 64 && (filter & (1ULL << id)))
+			crc = crc32_be(crc, pos - 2, elen + 2);
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
+			if (elen >= sizeof(struct ieee80211_tim_ie)) {
+				elems->tim = (void *)pos;
+				elems->tim_len = elen;
+			}
+			break;
+		case WLAN_EID_IBSS_PARAMS:
+			elems->ibss_params = pos;
+			elems->ibss_params_len = elen;
+			break;
+		case WLAN_EID_CHALLENGE:
+			elems->challenge = pos;
+			elems->challenge_len = elen;
+			break;
+		case WLAN_EID_VENDOR_SPECIFIC:
+			if (elen >= 4 && pos[0] == 0x00 && pos[1] == 0x50 &&
+			    pos[2] == 0xf2) {
+				/* Microsoft OUI (00:50:F2) */
+
+				if (calc_crc)
+					crc = crc32_be(crc, pos - 2, elen + 2);
+
+				if (pos[3] == 1) {
+					/* OUI Type 1 - WPA IE */
+					elems->wpa = pos;
+					elems->wpa_len = elen;
+				} else if (elen >= 5 && pos[3] == 2) {
+					/* OUI Type 2 - WMM IE */
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
+			if (elen >= sizeof(struct ieee80211_ht_cap))
+				elems->ht_cap_elem = (void *)pos;
+			break;
+		case WLAN_EID_HT_INFORMATION:
+			if (elen >= sizeof(struct ieee80211_ht_info))
+				elems->ht_info_elem = (void *)pos;
+			break;
+		case WLAN_EID_MESH_ID:
+			elems->mesh_id = pos;
+			elems->mesh_id_len = elen;
+			break;
+		case WLAN_EID_MESH_CONFIG:
+			if (elen >= sizeof(struct ieee80211_meshconf_ie))
+				elems->mesh_config = (void *)pos;
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
+		case WLAN_EID_RANN:
+			if (elen >= sizeof(struct ieee80211_rann_ie))
+				elems->rann = (void *)pos;
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
+		case WLAN_EID_TIMEOUT_INTERVAL:
+			elems->timeout_int = pos;
+			elems->timeout_int_len = elen;
+			break;
+		default:
+			break;
+		}
+
+		left -= elen;
+		pos += elen;
+	}
+
+	return crc;
+}
+EXPORT_SYMBOL(ieee802_11_parse_elems_crc);
-- 
1.7.0.2

