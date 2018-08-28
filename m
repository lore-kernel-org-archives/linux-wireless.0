Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53032 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbeH1QL0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:11:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        Peng Xu <pxu@qti.qualcomm.com>,
        Sara Sharon <sara.sharon@intel.com>
Subject: [RFC 2/6] cfg80211: clean up the previous patch [SQUASH]
Date: Tue, 28 Aug 2018 14:13:49 +0200
Message-Id: <20180828121353.11193-3-johannes@sipsolutions.net> (sfid-20180828_142005_724503_9B0672E9)
In-Reply-To: <20180828121353.11193-1-johannes@sipsolutions.net>
References: <20180828121353.11193-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Rename functions.
Remove redundant assignments.
Add some comments

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 145 +++++++++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 70 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index a1c0f6af1d3c..75e1fc79a890 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1088,8 +1088,8 @@ cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
 	return channel;
 }
 
-static void gen_new_bssid(const u8 *bssid, u8 max_bssid, u8 mbssid_index,
-			  u8 *new_bssid_addr)
+static void cfg80211_gen_new_bssid(const u8 *bssid, u8 max_bssid,
+				   u8 mbssid_index, u8 *new_bssid_addr)
 {
 	u64 bssid_tmp, new_bssid = 0;
 	u64 lsb_n;
@@ -1104,8 +1104,9 @@ static void gen_new_bssid(const u8 *bssid, u8 max_bssid, u8 mbssid_index,
 	u64_to_ether_addr(new_bssid, new_bssid_addr);
 }
 
-static size_t gen_new_ie(const u8 *ie, size_t ielen, const u8 *subelement,
-			 size_t subie_len, u8 *new_ie, gfp_t gfp)
+static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
+				  const u8 *subelement, size_t subie_len,
+				  u8 *new_ie, gfp_t gfp)
 {
 	u8 *pos, *tmp;
 	const u8 *tmp_old, *tmp_new;
@@ -1201,8 +1202,9 @@ static size_t gen_new_ie(const u8 *ie, size_t ielen, const u8 *subelement,
 	return pos - new_ie;
 }
 
-static int add_nontrans_list(struct cfg80211_internal_bss *trans_bss,
-			     struct cfg80211_internal_bss *nontrans_bss)
+static int
+cfg80211_add_nontrans_list(struct cfg80211_internal_bss *trans_bss,
+			   struct cfg80211_internal_bss *nontrans_bss)
 {
 	const u8 *ssid;
 	size_t ssid_len;
@@ -1313,7 +1315,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 		trans_internal = container_of(trans_bss,
 					      struct cfg80211_internal_bss,
 					      pub);
-		if (add_nontrans_list(trans_internal, res)) {
+		if (cfg80211_add_nontrans_list(trans_internal, res)) {
 			if (__cfg80211_unlink_bss(rdev, res))
 				rdev->bss_generation++;
 		}
@@ -1324,13 +1326,14 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 	return &res->pub;
 }
 
-static void parse_mbssid_data(struct wiphy *wiphy,
-			      struct cfg80211_inform_bss *data,
-			      enum cfg80211_bss_frame_type ftype,
-			      const u8 *bssid, u64 tsf,
-			      u16 beacon_interval, const u8 *ie, size_t ielen,
-			      struct cfg80211_bss *trans_bss,
-			      gfp_t gfp)
+static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
+				       struct cfg80211_inform_bss *data,
+				       enum cfg80211_bss_frame_type ftype,
+				       const u8 *bssid, u64 tsf,
+				       u16 beacon_interval, const u8 *ie,
+				       size_t ielen,
+				       struct cfg80211_bss *trans_bss,
+				       gfp_t gfp)
 {
 	const u8 *pos, *subelement, *mbssid_end_pos;
 	const u8 *tmp, *mbssid_index_ie;
@@ -1390,11 +1393,14 @@ static void parse_mbssid_data(struct wiphy *wiphy,
 				continue;
 			}
 
-			gen_new_bssid(bssid, tmp[2], mbssid_index_ie[2],
-				      new_bssid);
+			cfg80211_gen_new_bssid(bssid, tmp[2],
+					       mbssid_index_ie[2],
+					       new_bssid);
 			memset(new_ie, 0, IEEE80211_MAX_DATA_LEN);
-			new_ie_len = gen_new_ie(ie, ielen, subelement + 2,
-						subie_len, new_ie, gfp);
+			new_ie_len = cfg80211_gen_new_ie(ie, ielen,
+							 subelement + 2,
+							 subie_len, new_ie,
+							 gfp);
 			if (!new_ie_len)
 				continue;
 
@@ -1431,17 +1437,18 @@ cfg80211_inform_bss_data(struct wiphy *wiphy,
 	res = cfg80211_inform_single_bss_data(wiphy, data, ftype, bssid, tsf,
 					      capability, beacon_interval, ie,
 					      ielen, NULL, gfp);
-	parse_mbssid_data(wiphy, data, ftype, bssid, tsf, beacon_interval,
-			  ie, ielen, res, gfp);
+	cfg80211_parse_mbssid_data(wiphy, data, ftype, bssid, tsf,
+				   beacon_interval, ie, ielen, res, gfp);
 	return res;
 }
 EXPORT_SYMBOL(cfg80211_inform_bss_data);
 
-static void parse_mbssid_frame_data(struct wiphy *wiphy,
-				    struct cfg80211_inform_bss *data,
-				    struct ieee80211_mgmt *mgmt, size_t len,
-				    struct cfg80211_bss *trans_bss,
-				    gfp_t gfp)
+static void
+cfg80211_parse_mbssid_frame_data(struct wiphy *wiphy,
+				 struct cfg80211_inform_bss *data,
+				 struct ieee80211_mgmt *mgmt, size_t len,
+				 struct cfg80211_bss *trans_bss,
+				 gfp_t gfp)
 {
 	enum cfg80211_bss_frame_type ftype;
 	const u8 *ie = mgmt->u.probe_resp.variable;
@@ -1451,42 +1458,43 @@ static void parse_mbssid_frame_data(struct wiphy *wiphy,
 	ftype = ieee80211_is_beacon(mgmt->frame_control) ?
 		CFG80211_BSS_FTYPE_BEACON : CFG80211_BSS_FTYPE_PRESP;
 
-	parse_mbssid_data(wiphy, data, ftype, mgmt->bssid,
-			  le64_to_cpu(mgmt->u.probe_resp.timestamp),
-			  le16_to_cpu(mgmt->u.probe_resp.beacon_int),
-			  ie, ielen, trans_bss, gfp);
+	cfg80211_parse_mbssid_data(wiphy, data, ftype, mgmt->bssid,
+				   le64_to_cpu(mgmt->u.probe_resp.timestamp),
+				   le16_to_cpu(mgmt->u.probe_resp.beacon_int),
+				   ie, ielen, trans_bss, gfp);
 }
 
-static void update_notlisted_nontrans(struct wiphy *wiphy,
-				      struct cfg80211_internal_bss
-				      *nontrans_bss,
-				      struct ieee80211_mgmt *mgmt, size_t len,
-				      gfp_t gfp)
+static void
+cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
+				   struct cfg80211_internal_bss *nontrans_bss,
+				   struct ieee80211_mgmt *mgmt, size_t len,
+				   gfp_t gfp)
 
 {
 	u8 *ie, *new_ie, *pos;
-	const u8 *tmp, *tmp1;
+	const u8 *nontrans_ssid, *trans_ssid, *mbssid;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
 	size_t new_ie_len;
 	struct cfg80211_bss_ies *new_ies;
 	const struct cfg80211_bss_ies *old;
+	u8 cpy_len;
 
-	ie =  mgmt->u.probe_resp.variable;
+	ie = mgmt->u.probe_resp.variable;
 
 	new_ie_len = ielen;
-	tmp = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
-	if (!tmp)
+	trans_ssid = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
+	if (!trans_ssid)
 		return;
-	new_ie_len -= tmp[1];
-	tmp = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen);
-	if (!tmp)
+	new_ie_len -= trans_ssid[1];
+	mbssid = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen);
+	if (!mbssid)
 		return;
-	new_ie_len -= tmp[1];
-	tmp = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
-	if (!tmp)
+	new_ie_len -= mbssid[1];
+	nontrans_ssid = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
+	if (!nontrans_ssid)
 		return;
-	new_ie_len += tmp[1];
+	new_ie_len += nontrans_ssid[1];
 
 	/* generate new ie for nontrans BSS
 	 * 1. replace SSID with nontrans BSS' SSID
@@ -1494,26 +1502,28 @@ static void update_notlisted_nontrans(struct wiphy *wiphy,
 	 */
 	new_ie = kzalloc(new_ie_len, gfp);
 	if (!new_ie)
-		goto error;
+		return;
+	new_ies = kzalloc(sizeof(*new_ies) + new_ie_len, gfp);
+	if (!new_ies) {
+		kfree(new_ie);
+		return;
+	}
+
 	pos = new_ie;
-	tmp = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
-	if (!tmp)
-		goto error;
-
-	memcpy(pos, tmp, tmp[1] + 2);
-	pos += tmp[1] + 2;
-	tmp = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen);
-	tmp1 = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
-	if (!tmp || !tmp1)
-		goto error;
-	memcpy(pos, (tmp1 + tmp1[1] + 2), (tmp - (tmp1 + tmp1[1] + 2)));
-	pos += (tmp - (tmp1 + tmp1[1] + 2));
-	memcpy(pos, tmp + tmp[1] + 2, ((ie + ielen) - (tmp + tmp[1] + 2)));
+
+	/* copy the nontransmitted SSID */
+	cpy_len = nontrans_ssid[1] + 2;
+	memcpy(pos, nontrans_ssid, cpy_len);
+	pos += cpy_len;
+	/* copy the IEs between SSID and MBSSID */
+	cpy_len = trans_ssid[1] + 2;
+	memcpy(pos, (trans_ssid + cpy_len), (mbssid - (trans_ssid + cpy_len)));
+	pos += (mbssid - (trans_ssid + cpy_len));
+	/* copy the IEs after MBSSID */
+	cpy_len = mbssid[1] + 2;
+	memcpy(pos, mbssid + cpy_len, ((ie + ielen) - (mbssid + cpy_len)));
 
 	/* update ie */
-	new_ies = kzalloc(sizeof(*new_ies) + new_ie_len, gfp);
-	if (!new_ies)
-		goto error;
 	new_ies->len = new_ie_len;
 	new_ies->tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
 	new_ies->from_beacon = ieee80211_is_beacon(mgmt->frame_control);
@@ -1531,11 +1541,6 @@ static void update_notlisted_nontrans(struct wiphy *wiphy,
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
 	}
-
-	return;
-
-error:
-	kfree(new_ie);
 }
 
 /* cfg80211_inform_bss_width_frame helper */
@@ -1642,7 +1647,7 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 		return res;
 
 	/* process each non-transmitting bss */
-	parse_mbssid_frame_data(wiphy, data, mgmt, len, res, gfp);
+	cfg80211_parse_mbssid_frame_data(wiphy, data, mgmt, len, res, gfp);
 
 	/* check if the res has other nontransmitting bss which is not
 	 * in MBSSID IE
@@ -1660,8 +1665,8 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 			    nontrans_list) {
 		ies2 = rcu_access_pointer(tmp_bss->pub.ies);
 		if (ies2->tsf < ies1->tsf)
-			update_notlisted_nontrans(wiphy, tmp_bss, mgmt,
-						  len, gfp);
+			cfg80211_update_notlisted_nontrans(wiphy, tmp_bss,
+							   mgmt, len, gfp);
 	}
 
 	return res;
-- 
2.14.4
