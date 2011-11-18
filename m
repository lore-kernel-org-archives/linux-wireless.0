Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33113 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab1KRPyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 10:54:55 -0500
Subject: [PATCH v2] cfg80211/mac80211: Revert "move information element
 parsing logic to cfg80211"
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Yogesh Ashok Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1321631520.10266.62.camel@jlt3.sipsolutions.net> (sfid-20111118_165216_664504_042C8D9F)
References: <1321631520.10266.62.camel@jlt3.sipsolutions.net>
	 (sfid-20111118_165216_664504_042C8D9F)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 16:54:50 +0100
Message-ID: <1321631690.10266.63.camel@jlt3.sipsolutions.net> (sfid-20111118_165459_241300_31D0D141)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

No other driver ever ended up using this, and
the commit forgot to move the prototype so no
driver could have used it. Revert it, if any
driver shows up and needs it it can be moved
again, but until then it's more efficient to
have it in mac80211 where the only user is.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: refresh patch to include necessary move of crc32.h include, sorry!

 include/net/cfg80211.h     |   63 ----------------
 net/mac80211/ieee80211_i.h |   63 ++++++++++++++++
 net/mac80211/util.c        |  167 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/util.c        |  168 ---------------------------------------------
 4 files changed, 230 insertions(+), 231 deletions(-)

--- a/include/net/cfg80211.h	2011-11-18 09:47:38.000000000 +0100
+++ b/include/net/cfg80211.h	2011-11-18 16:48:04.000000000 +0100
@@ -2391,69 +2391,6 @@ extern int ieee80211_radiotap_iterator_n
 extern const unsigned char rfc1042_header[6];
 extern const unsigned char bridge_tunnel_header[6];
 
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
-	u8 *peering;
-	u8 *preq;
-	u8 *prep;
-	u8 *perr;
-	struct ieee80211_rann_ie *rann;
-	u8 *ch_switch_elem;
-	u8 *country_elem;
-	u8 *pwr_constr_elem;
-	u8 *quiet_elem;	/* first quite element */
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
-	u8 peering_len;
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
 /**
  * ieee80211_get_hdrlen_from_skb - get header length from data
  *
--- a/net/mac80211/ieee80211_i.h	2011-11-18 09:46:41.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2011-11-18 16:47:17.000000000 +0100
@@ -1040,6 +1040,69 @@ struct ieee80211_ra_tid {
 	u16 tid;
 };
 
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
+	u8 *peering;
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
+	u8 peering_len;
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
 static inline struct ieee80211_local *hw_to_local(
 	struct ieee80211_hw *hw)
 {
--- a/net/mac80211/util.c	2011-11-18 09:46:41.000000000 +0100
+++ b/net/mac80211/util.c	2011-11-18 16:53:25.000000000 +0100
@@ -20,6 +20,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <linux/bitmap.h>
+#include <linux/crc32.h>
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
@@ -564,6 +565,172 @@ void ieee80211_queue_delayed_work(struct
 }
 EXPORT_SYMBOL(ieee80211_queue_delayed_work);
 
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
+		case WLAN_EID_PEER_MGMT:
+			elems->peering = pos;
+			elems->peering_len = elen;
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
+
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems)
 {
--- a/net/wireless/util.c	2011-11-18 16:42:05.000000000 +0100
+++ b/net/wireless/util.c	2011-11-18 16:53:26.000000000 +0100
@@ -7,7 +7,6 @@
 #include <linux/bitops.h>
 #include <linux/etherdevice.h>
 #include <linux/slab.h>
-#include <linux/crc32.h>
 #include <net/cfg80211.h>
 #include <net/ip.h>
 #include "core.h"
@@ -1052,170 +1051,3 @@ int ieee80211_get_ratemask(struct ieee80
 
 	return 0;
 }
-
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
-		case WLAN_EID_PEER_MGMT:
-			elems->peering = pos;
-			elems->peering_len = elen;
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
-EXPORT_SYMBOL(ieee802_11_parse_elems_crc);


