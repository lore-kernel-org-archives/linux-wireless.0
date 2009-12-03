Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZLCWgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 17:36:51 -0500
Subject: [PATCH] mac80211: split up and insert custom IEs correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 23:36:53 +0100
Message-ID: <1259879813.20064.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, we insert all user-specified IEs before the HT
IE for association, and after the HT IE for probe requests.
For association, that's correct only if the user-specified
IEs are RSN only, incorrect in all other cases including
WPA. Change this to split apart the user-specified IEs in
two places for association: before the HT IE (e.g. RSN),
after the HT IE (generally empty right now I think?) and
after WMM (all other vendor-specific IEs). For probes,
split the IEs in different places to be correct according
to the spec.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h  |   39 ++++++++++---
 net/mac80211/ieee80211_i.h |    4 +
 net/mac80211/util.c        |  132 ++++++++++++++++++++++++++++++++++++++-------
 net/mac80211/work.c        |   43 ++++++++++++--
 4 files changed, 183 insertions(+), 35 deletions(-)

--- wireless-testing.orig/net/mac80211/util.c	2009-12-03 23:28:42.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-12-03 23:31:14.000000000 +0100
@@ -881,30 +881,66 @@ int ieee80211_build_preq_ies(struct ieee
 			     enum ieee80211_band band)
 {
 	struct ieee80211_supported_band *sband;
-	u8 *pos, *supp_rates_len, *esupp_rates_len = NULL;
-	int i;
+	u8 *pos;
+	size_t offset = 0, noffset;
+	int supp_rates_len, i;
 
 	sband = local->hw.wiphy->bands[band];
 
 	pos = buffer;
 
-	*pos++ = WLAN_EID_SUPP_RATES;
-	supp_rates_len = pos;
-	*pos++ = 0;
+	supp_rates_len = min_t(int, sband->n_bitrates, 8);
 
-	for (i = 0; i < sband->n_bitrates; i++) {
-		struct ieee80211_rate *rate = &sband->bitrates[i];
+	*pos++ = WLAN_EID_SUPP_RATES;
+	*pos++ = supp_rates_len;
 
-		if (esupp_rates_len) {
-			*esupp_rates_len += 1;
-		} else if (*supp_rates_len == 8) {
-			*pos++ = WLAN_EID_EXT_SUPP_RATES;
-			esupp_rates_len = pos;
-			*pos++ = 1;
-		} else
-			*supp_rates_len += 1;
+	for (i = 0; i < supp_rates_len; i++) {
+		int rate = sband->bitrates[i].bitrate;
+		*pos++ = (u8) (rate / 5);
+	}
+
+	/* insert "request information" if in custom IEs */
+	if (ie && ie_len) {
+		static const u8 before_extrates[] = {
+			WLAN_EID_SSID,
+			WLAN_EID_SUPP_RATES,
+			WLAN_EID_REQUEST,
+		};
+		noffset = ieee80211_ie_split(ie, ie_len,
+					     before_extrates,
+					     ARRAY_SIZE(before_extrates),
+					     offset);
+		memcpy(pos, ie + offset, noffset - offset);
+		pos += noffset - offset;
+		offset = noffset;
+	}
+
+	if (sband->n_bitrates > i) {
+		*pos++ = WLAN_EID_EXT_SUPP_RATES;
+		*pos++ = sband->n_bitrates - i;
+
+		for (; i < sband->n_bitrates; i++) {
+			int rate = sband->bitrates[i].bitrate;
+			*pos++ = (u8) (rate / 5);
+		}
+	}
 
-		*pos++ = rate->bitrate / 5;
+	/* insert custom IEs that go before HT */
+	if (ie && ie_len) {
+		static const u8 before_ht[] = {
+			WLAN_EID_SSID,
+			WLAN_EID_SUPP_RATES,
+			WLAN_EID_REQUEST,
+			WLAN_EID_EXT_SUPP_RATES,
+			WLAN_EID_DS_PARAMS,
+			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
+		};
+		noffset = ieee80211_ie_split(ie, ie_len,
+					     before_ht, ARRAY_SIZE(before_ht),
+					     offset);
+		memcpy(pos, ie + offset, noffset - offset);
+		pos += noffset - offset;
+		offset = noffset;
 	}
 
 	if (sband->ht_cap.ht_supported) {
@@ -936,9 +972,11 @@ int ieee80211_build_preq_ies(struct ieee
 	 * that calculates local->scan_ies_len.
 	 */
 
-	if (ie) {
-		memcpy(pos, ie, ie_len);
-		pos += ie_len;
+	/* add any remaining custom IEs */
+	if (ie && ie_len) {
+		noffset = ie_len;
+		memcpy(pos, ie + offset, noffset - offset);
+		pos += noffset - offset;
 	}
 
 	return pos - buffer;
@@ -1252,3 +1290,59 @@ void ieee80211_recalc_smps(struct ieee80
  	/* changed flag is auto-detected for this */
 	ieee80211_hw_config(local, 0);
 }
+
+static bool ieee80211_id_in_list(const u8 *ids, int n_ids, u8 id)
+{
+	int i;
+
+	for (i = 0; i < n_ids; i++)
+		if (ids[i] == id)
+			return true;
+	return false;
+}
+
+/**
+ * ieee80211_ie_split - split an IE buffer according to ordering
+ *
+ * @ies: the IE buffer
+ * @ielen: the length of the IE buffer
+ * @ids: an array with element IDs that are allowed before
+ *	the split
+ * @n_ids: the size of the element ID array
+ * @offset: offset where to start splitting in the buffer
+ *
+ * This function splits an IE buffer by updating the @offset
+ * variable to point to the location where the buffer should be
+ * split.
+ *
+ * It assumes that the given IE buffer is well-formed, this
+ * has to be guaranteed by the caller!
+ *
+ * It also assumes that the IEs in the buffer are ordered
+ * correctly, if not the result of using this function will not
+ * be ordered correctly either, i.e. it does no reordering.
+ *
+ * The function returns the offset where the next part of the
+ * buffer starts, which may be @ielen if the entire (remainder)
+ * of the buffer should be used.
+ */
+size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
+			  const u8 *ids, int n_ids, size_t offset)
+{
+	size_t pos = offset;
+
+	while (pos < ielen && ieee80211_id_in_list(ids, n_ids, ies[pos]))
+		pos += 2 + ies[pos + 1];
+
+	return pos;
+}
+
+size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset)
+{
+	size_t pos = offset;
+
+	while (pos < ielen && ies[pos] != WLAN_EID_VENDOR_SPECIFIC)
+		pos += 2 + ies[pos + 1];
+
+	return pos;
+}
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-12-03 23:28:42.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-12-03 23:31:14.000000000 +0100
@@ -1147,6 +1147,10 @@ int __ieee80211_request_smps(struct ieee
 void ieee80211_recalc_smps(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *forsdata);
 
+size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
+			  const u8 *ids, int n_ids, size_t offset);
+size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
+
 /* internal work items */
 void ieee80211_work_init(struct ieee80211_local *local);
 void ieee80211_add_work(struct ieee80211_work *wk);
--- wireless-testing.orig/net/mac80211/work.c	2009-12-03 23:28:42.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2009-12-03 23:31:14.000000000 +0100
@@ -204,6 +204,7 @@ static void ieee80211_send_assoc(struct 
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
 	const u8 *ies;
+	size_t offset = 0, noffset;
 	int i, len, count, rates_len, supp_rates_len;
 	u16 capab;
 	struct ieee80211_supported_band *sband;
@@ -337,14 +338,26 @@ static void ieee80211_send_assoc(struct 
 		}
 	}
 
-	/*
-	 * XXX:	These IEs could contain (vendor-specified)
-	 *	IEs that belong after HT -- the buffer may
-	 *	need to be split up.
-	 */
+	/* if present, add any custom IEs that go before HT */
 	if (wk->ie_len && wk->ie) {
-		pos = skb_put(skb, wk->ie_len);
-		memcpy(pos, wk->ie, wk->ie_len);
+		static const u8 before_ht[] = {
+			WLAN_EID_SSID,
+			WLAN_EID_SUPP_RATES,
+			WLAN_EID_EXT_SUPP_RATES,
+			WLAN_EID_PWR_CAPABILITY,
+			WLAN_EID_SUPPORTED_CHANNELS,
+			WLAN_EID_RSN,
+			WLAN_EID_QOS_CAPA,
+			WLAN_EID_RRM_ENABLED_CAPABILITIES,
+			WLAN_EID_MOBILITY_DOMAIN,
+			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
+		};
+		noffset = ieee80211_ie_split(wk->ie, wk->ie_len,
+					     before_ht, ARRAY_SIZE(before_ht),
+					     offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, wk->ie + offset, noffset - offset);
+		offset = noffset;
 	}
 
 	if (wk->assoc.use_11n && wk->assoc.wmm_used &&
@@ -352,6 +365,15 @@ static void ieee80211_send_assoc(struct 
 		ieee80211_add_ht_ie(skb, wk->assoc.ht_information_ie,
 				    sband, wk->chan, wk->assoc.smps);
 
+	/* if present, add any custom non-vendor IEs that go after HT */
+	if (wk->ie_len && wk->ie) {
+		noffset = ieee80211_ie_split_vendor(wk->ie, wk->ie_len,
+						    offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, wk->ie + offset, noffset - offset);
+		offset = noffset;
+	}
+
 	if (wk->assoc.wmm_used && local->hw.queues >= 4) {
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
@@ -365,6 +387,13 @@ static void ieee80211_send_assoc(struct 
 		*pos++ = 0;
 	}
 
+	/* add any remaining custom (i.e. vendor specific here) IEs */
+	if (wk->ie_len && wk->ie) {
+		noffset = wk->ie_len;
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, wk->ie + offset, noffset - offset);
+	}
+
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);
 }
--- wireless-testing.orig/include/linux/ieee80211.h	2009-12-03 23:28:42.000000000 +0100
+++ wireless-testing/include/linux/ieee80211.h	2009-12-03 23:31:14.000000000 +0100
@@ -1082,12 +1082,12 @@ enum ieee80211_eid {
 	WLAN_EID_TIM = 5,
 	WLAN_EID_IBSS_PARAMS = 6,
 	WLAN_EID_CHALLENGE = 16,
-	/* 802.11d */
+
 	WLAN_EID_COUNTRY = 7,
 	WLAN_EID_HP_PARAMS = 8,
 	WLAN_EID_HP_TABLE = 9,
 	WLAN_EID_REQUEST = 10,
-	/* 802.11e */
+
 	WLAN_EID_QBSS_LOAD = 11,
 	WLAN_EID_EDCA_PARAM_SET = 12,
 	WLAN_EID_TSPEC = 13,
@@ -1110,7 +1110,7 @@ enum ieee80211_eid {
 	WLAN_EID_PREP = 69,
 	WLAN_EID_PERR = 70,
 	WLAN_EID_RANN = 49,	/* compatible with FreeBSD */
-	/* 802.11h */
+
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,
 	WLAN_EID_TPC_REQUEST = 34,
@@ -1121,20 +1121,41 @@ enum ieee80211_eid {
 	WLAN_EID_MEASURE_REPORT = 39,
 	WLAN_EID_QUIET = 40,
 	WLAN_EID_IBSS_DFS = 41,
-	/* 802.11g */
+
 	WLAN_EID_ERP_INFO = 42,
 	WLAN_EID_EXT_SUPP_RATES = 50,
-	/* 802.11n */
+
 	WLAN_EID_HT_CAPABILITY = 45,
 	WLAN_EID_HT_INFORMATION = 61,
-	/* 802.11i */
+
 	WLAN_EID_RSN = 48,
-	WLAN_EID_TIMEOUT_INTERVAL = 56,
-	WLAN_EID_MMIE = 76 /* 802.11w */,
+	WLAN_EID_MMIE = 76,
 	WLAN_EID_WPA = 221,
 	WLAN_EID_GENERIC = 221,
 	WLAN_EID_VENDOR_SPECIFIC = 221,
-	WLAN_EID_QOS_PARAMETER = 222
+	WLAN_EID_QOS_PARAMETER = 222,
+
+	WLAN_EID_AP_CHAN_REPORT = 51,
+	WLAN_EID_NEIGHBOR_REPORT = 52,
+	WLAN_EID_RCPI = 53,
+	WLAN_EID_BSS_AVG_ACCESS_DELAY = 63,
+	WLAN_EID_ANTENNA_INFO = 64,
+	WLAN_EID_RSNI = 65,
+	WLAN_EID_MEASUREMENT_PILOT_TX_INFO = 66,
+	WLAN_EID_BSS_AVAILABLE_CAPACITY = 67,
+	WLAN_EID_BSS_AC_ACCESS_DELAY = 68,
+	WLAN_EID_RRM_ENABLED_CAPABILITIES = 70,
+	WLAN_EID_MULTIPLE_BSSID = 71,
+
+	WLAN_EID_MOBILITY_DOMAIN = 54,
+	WLAN_EID_FAST_BSS_TRANSITION = 55,
+	WLAN_EID_TIMEOUT_INTERVAL = 56,
+	WLAN_EID_RIC_DATA = 57,
+	WLAN_EID_RIC_DESCRIPTOR = 75,
+
+	WLAN_EID_DSE_REGISTERED_LOCATION = 58,
+	WLAN_EID_SUPPORTED_REGULATORY_CLASSES = 59,
+	WLAN_EID_EXT_CHANSWITCH_ANN = 60,
 };
 
 /* Action category code */


