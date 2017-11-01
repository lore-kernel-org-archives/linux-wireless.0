Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:10685 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbdKAQjv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 12:39:51 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, Peng Xu <pxu@qti.qualcomm.com>,
        "Jouni Malinen" <jouni@qca.qualcomm.com>
Subject: [RFC] cfg80211: Implement Multiple BSSID capability in scanning
Date: Wed, 1 Nov 2017 18:39:18 +0200
Message-ID: <1509554358-10473-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20171101_173955_338839_7C7BC17F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peng Xu <pxu@qti.qualcomm.com>

This extends cfg80211 BSS table processing to be able to parse Multiple
BSSID element from Beacon and Probe Response frames and to update the
BSS profiles in internal database for non-transmitted BSSs.

Signed-off-by: Peng Xu <pxu@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/core.h |   1 +
 net/wireless/scan.c | 537 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 526 insertions(+), 12 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 35165f4..3b4a566 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -139,6 +139,7 @@ extern int cfg80211_rdev_list_generation;
 struct cfg80211_internal_bss {
 	struct list_head list;
 	struct list_head hidden_list;
+	struct list_head nontrans_list;
 	struct rb_node rbn;
 	u64 ts_boottime;
 	unsigned long ts;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9f0901f..a9e3b31 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -149,6 +149,7 @@ static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *rdev,
 	}
 
 	list_del_init(&bss->list);
+	list_del_init(&bss->nontrans_list);
 	rb_erase(&bss->rbn, &rdev->bss_tree);
 	rdev->bss_entries--;
 	WARN_ONCE((rdev->bss_entries == 0) ^ list_empty(&rdev->bss_list),
@@ -1005,6 +1006,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		memcpy(new, tmp, sizeof(*new));
 		new->refcount = 1;
 		INIT_LIST_HEAD(&new->hidden_list);
+		INIT_LIST_HEAD(&new->nontrans_list);
 
 		if (rcu_access_pointer(tmp->pub.proberesp_ies)) {
 			hidden = rb_find_bss(rdev, tmp, BSS_CMP_HIDE_ZLEN);
@@ -1086,18 +1088,235 @@ cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
 	return channel;
 }
 
+u8 *gen_new_bssid(const u8 *bssid, u8 max_bssid, u8 mbssid_index, gfp_t gfp)
+{
+	int i;
+	u64 bssid_a, bssid_b, bssid_tmp = 0;
+	u64 lsb_n;
+	u8 *new_bssid;
+
+	for (i = 0; i < 5; i++) {
+		bssid_tmp = bssid_tmp | bssid[i];
+		bssid_tmp = bssid_tmp << 8;
+	}
+	bssid_tmp = bssid_tmp | bssid[5];
+
+	lsb_n = bssid_tmp & ((1 << max_bssid) - 1);
+	bssid_b = (lsb_n + mbssid_index) % (1 <<  max_bssid);
+	bssid_a = bssid_tmp & ~((1 << max_bssid) - 1);
+	bssid_tmp = bssid_a | bssid_b;
+
+	new_bssid = kzalloc(6, gfp);
+	if (!new_bssid)
+		return NULL;
+	for (i = 0; i < 6; i++) {
+		new_bssid[5 - i] = bssid_tmp & 0xFF;
+		bssid_tmp >>= 8;
+	}
+
+	return new_bssid;
+}
+
+size_t calculate_new_ie_len(const u8 *ie, size_t ielen, const u8 *subelement,
+			    size_t subie_len)
+{
+	size_t new_ie_len;
+	const u8 *old_ie, *new_ie;
+	int delta;
+
+	new_ie_len = ielen;
+
+	/* calculate length difference between ssid ie */
+	old_ie = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
+	new_ie = cfg80211_find_ie(WLAN_EID_SSID, subelement, subie_len);
+	if (old_ie && new_ie) {
+		delta = new_ie[1] - old_ie[1];
+		new_ie_len += delta;
+	}
+
+	/* calculate length difference between FMS Descriptor ie */
+	old_ie = cfg80211_find_ie(WLAN_EID_FMS_DESCRIPTOR, ie, ielen);
+	new_ie = cfg80211_find_ie(WLAN_EID_FMS_DESCRIPTOR, subelement,
+				  subie_len);
+	if (!old_ie && new_ie)
+		new_ie_len += new_ie[1];
+	else if (old_ie && new_ie)
+		new_ie_len += (new_ie[1] - old_ie[1]);
+
+	/* calculate length difference for same vendor ie */
+	new_ie = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC, subelement,
+				  subie_len);
+	while (new_ie && (new_ie - subelement) < subie_len) {
+		old_ie = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC, ie, ielen);
+		while (old_ie && ((old_ie - ie) < ielen)) {
+			if (!memcmp(new_ie + 2, old_ie + 2, 5)) {
+				/* same vendor ie, calculate length difference*/
+				new_ie_len += (new_ie[1] - old_ie[1]);
+				break;
+			}
+			old_ie = cfg80211_find_ie(
+					WLAN_EID_VENDOR_SPECIFIC,
+					old_ie + old_ie[1] + 2,
+					ielen - (old_ie + old_ie[1] + 2 - ie));
+		}
+		new_ie = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC,
+					  new_ie + new_ie[1] + 2,
+					  subie_len -
+					  (new_ie + new_ie[1] + 2 -
+					  subelement));
+	}
+
+	/* check other ie in subelement */
+	new_ie = cfg80211_find_ie(WLAN_EID_NON_TX_BSSID_CAP, subelement,
+				  subie_len);
+	while (new_ie && (new_ie - subelement < subie_len)) {
+		if (new_ie[0] == WLAN_EID_NON_TX_BSSID_CAP ||
+		    new_ie[0] == WLAN_EID_SSID ||
+		    new_ie[0] == WLAN_EID_FMS_DESCRIPTOR ||
+		    new_ie[0] == WLAN_EID_MULTI_BSSID_IDX) {
+			if ((new_ie + 2 + new_ie[1] - subelement) ==
+			     subie_len) {
+				/* new_ie is the last ie */
+				break;
+			}
+			new_ie += new_ie[1] + 2;
+			continue;
+		}
+		new_ie_len += (new_ie[1] + 2);
+		if ((new_ie + 2 + new_ie[1] - subelement) == subie_len) {
+			/* new_ie is the last ie */
+			break;
+		}
+		new_ie += new_ie[1] + 2;
+	}
+
+	return new_ie_len;
+}
+
+u8 *gen_new_ie(const u8 *ie, size_t ielen, const u8 *subelement,
+	       size_t subie_len, size_t new_ie_len, bool is_beacon,
+	       gfp_t gfp)
+{
+	u8 *new_ie, *pos;
+	const u8 *tmp_old, *tmp_new, *tmp;
+	size_t left_len;
+
+	new_ie = kzalloc(new_ie_len, gfp);
+	if (!new_ie)
+		return NULL;
+
+	pos = new_ie;
+
+	/* set new ssid */
+	tmp_new = cfg80211_find_ie(WLAN_EID_SSID, subelement, subie_len);
+	if (tmp_new) {
+		memcpy(pos, tmp_new, tmp_new[1] + 2);
+		pos += (tmp_new[1] + 2);
+	}
+
+	/* go through IEs in ie and subelement, merge them into new_ie */
+	tmp_old = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
+	if (!tmp_old)
+		return NULL;
+	tmp_old += tmp_old[1] + 2;
+	tmp_new = cfg80211_find_ie(WLAN_EID_SSID, subelement, subie_len);
+	left_len = subie_len - tmp_new[1];
+	tmp_new += tmp_new[1] + 2;
+
+	while ((tmp_old - ie) < ielen) {
+		if (tmp_old[0] == 0) {
+			tmp_old++;
+			continue;
+		}
+
+		tmp = cfg80211_find_ie(tmp_old[0], tmp_new, left_len);
+		if (!tmp) {
+			/* ie in old ie but not in subelement */
+			memcpy(pos, tmp_old, tmp_old[1] + 2);
+			pos += tmp_old[1] + 2;
+		} else {
+			if (tmp_old[0] == WLAN_EID_MULTIPLE_BSSID)
+				continue;
+
+			if (tmp_old[0] == WLAN_EID_VENDOR_SPECIFIC) {
+				if (!memcmp(tmp_old + 2, tmp + 2, 5)) {
+					/* same vendor ie, copy from new ie */
+					memcpy(pos, tmp, tmp[1] + 2);
+					pos += tmp[1] + 2;
+				} else {
+					memcpy(pos, tmp_old, tmp_old[1] + 2);
+					pos += tmp_old[1] + 2;
+				}
+				tmp_old += tmp_old[1] + 2;
+				continue;
+			}
+
+			/* copy ie from subelement into new ie */
+			memcpy(pos, tmp, tmp[1] + 2);
+			pos += tmp[1] + 2;
+		}
+		tmp_old += tmp_old[1] + 2;
+	}
+
+	while ((tmp_new - subelement) < subie_len) {
+		tmp = cfg80211_find_ie(tmp_new[0], new_ie, pos - new_ie);
+		if (!tmp && tmp_new[0] != WLAN_EID_MULTI_BSSID_IDX) {
+			/* ie is new ie but not in new_ie */
+			memcpy(pos, tmp_new, tmp_new[1] + 2);
+			pos += tmp_new[1] + 2;
+		} else {
+			if (tmp && tmp_new[0] == WLAN_EID_VENDOR_SPECIFIC)
+				if (memcmp(tmp_new + 2, tmp + 2, 5)) {
+					memcpy(pos, tmp_new, tmp_new[1] + 2);
+					pos += tmp_new[1] + 2;
+				}
+		}
+		tmp_new += tmp_new[1] + 2;
+	}
+
+	return new_ie;
+}
+
+void add_nontrans_list(struct cfg80211_internal_bss *trans_bss,
+		       struct cfg80211_internal_bss *nontrans_bss)
+{
+	const u8 *ssid;
+	size_t ssid_len;
+	struct cfg80211_internal_bss *bss = NULL;
+
+	ssid = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
+	if (!ssid)
+		return;
+	ssid_len = ssid[1];
+	ssid = ssid + 2;
+
+	/* check if nontrans_bss is in the list */
+	if (!list_empty(&trans_bss->nontrans_list)) {
+		list_for_each_entry(bss, &trans_bss->nontrans_list,
+				    nontrans_list) {
+			if (is_bss(&bss->pub, nontrans_bss->pub.bssid,
+				   ssid, ssid_len))
+				return;
+		}
+	}
+
+	/* add to the list */
+	list_add_tail(&nontrans_bss->nontrans_list, &trans_bss->nontrans_list);
+}
+
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 struct cfg80211_bss *
-cfg80211_inform_bss_data(struct wiphy *wiphy,
-			 struct cfg80211_inform_bss *data,
-			 enum cfg80211_bss_frame_type ftype,
-			 const u8 *bssid, u64 tsf, u16 capability,
-			 u16 beacon_interval, const u8 *ie, size_t ielen,
-			 gfp_t gfp)
+cfg80211_inform_single_bss_data(struct wiphy *wiphy,
+				struct cfg80211_inform_bss *data,
+				enum cfg80211_bss_frame_type ftype,
+				const u8 *bssid, u64 tsf, u16 capability,
+				u16 beacon_interval, const u8 *ie, size_t ielen,
+				struct cfg80211_bss *trans_bss,
+				gfp_t gfp)
 {
 	struct cfg80211_bss_ies *ies;
 	struct ieee80211_channel *channel;
-	struct cfg80211_internal_bss tmp = {}, *res;
+	struct cfg80211_internal_bss tmp = {}, *res, *trans_internal;
 	int bss_type;
 	bool signal_valid;
 
@@ -1165,20 +1384,249 @@ cfg80211_inform_bss_data(struct wiphy *wiphy,
 			regulatory_hint_found_beacon(wiphy, channel, gfp);
 	}
 
+	if (trans_bss) {
+		/* this is a nontransmitting bss, we need to add it to
+		 * transmitting bss' list if it is not there
+		 */
+		trans_internal = container_of(trans_bss,
+					      struct cfg80211_internal_bss,
+					      pub);
+		add_nontrans_list(trans_internal, res);
+	}
+
 	trace_cfg80211_return_bss(&res->pub);
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
-EXPORT_SYMBOL(cfg80211_inform_bss_data);
 
-/* cfg80211_inform_bss_width_frame helper */
+void proc_mbssid_data(struct wiphy *wiphy,
+		      struct cfg80211_inform_bss *data,
+		      enum cfg80211_bss_frame_type ftype,
+		      const u8 *bssid, u64 tsf, u16 capability,
+		      u16 beacon_interval, const u8 *ie, size_t ielen,
+		      struct cfg80211_bss *trans_bss,
+		      gfp_t gfp)
+{
+	const u8 *pos, *subelement, *new_ie, *new_bssid, *mbssid_end_pos;
+	const u8 *tmp, *mbssid_index_ie;
+	size_t subie_len, new_ie_len;
+	bool is_beacon = false;
+
+	pos = ie;
+	if (ftype == CFG80211_BSS_FTYPE_BEACON)
+		is_beacon = true;
+
+	while (pos < ie + ielen + 2) {
+		tmp = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, pos,
+				       ielen - (pos - ie));
+		if (!tmp)
+			break;
+
+		mbssid_end_pos = tmp + tmp[1] + 2;
+		if (tmp[1] > 3) {
+			subelement = tmp + 3;
+			subie_len = subelement[1];
+			while (subelement < mbssid_end_pos) {
+				if (subelement[0] != 0) {
+					/* not a BSS profile */
+					subelement += subelement[1] + 2;
+					continue;
+				}
+
+				/* found a bss profile */
+				mbssid_index_ie = cfg80211_find_ie(
+						WLAN_EID_MULTI_BSSID_IDX,
+						subelement + 2, subie_len);
+				if (!mbssid_index_ie) {
+					subelement += subelement[1] + 2;
+					continue;
+				}
+
+				new_bssid = gen_new_bssid(bssid, tmp[2],
+							  mbssid_index_ie[2],
+							  gfp);
+				new_ie_len = calculate_new_ie_len(ie, ielen,
+								  subelement +
+								  2,
+								  subie_len);
+				new_ie = gen_new_ie(ie, ielen, subelement + 2,
+						    subie_len, new_ie_len,
+						    is_beacon, gfp);
+				if (!new_ie) {
+					subelement += subelement[1] + 2;
+					continue;
+				}
+
+				memcpy((u8 *)&capability, subelement + 2, 2);
+				cfg80211_inform_single_bss_data(wiphy, data,
+								ftype,
+								new_bssid, tsf,
+								capability,
+								beacon_interval,
+								new_ie,
+								new_ie_len,
+								trans_bss,
+								gfp);
+				subelement += subelement[1] + 2;
+				subie_len = subelement[1];
+			}
+		} else {
+			break;
+		}
+
+		pos  = mbssid_end_pos;
+	}
+}
+
 struct cfg80211_bss *
-cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
-			       struct cfg80211_inform_bss *data,
+cfg80211_inform_bss_data(struct wiphy *wiphy,
+			 struct cfg80211_inform_bss *data,
+			 enum cfg80211_bss_frame_type ftype,
+			 const u8 *bssid, u64 tsf, u16 capability,
+			 u16 beacon_interval, const u8 *ie, size_t ielen,
+			 gfp_t gfp)
+{
+	bool mbssid_present = false;
+	struct cfg80211_bss *res;
+	const u8 *tmp;
+
+	tmp = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen);
+	if (tmp)
+		mbssid_present = true;
+
+	res = cfg80211_inform_single_bss_data(wiphy, data, ftype, bssid, tsf,
+					      capability, beacon_interval, ie,
+					      ielen, NULL, gfp);
+	if (!mbssid_present)
+		return res;
+
+	/* process each non-transmitting bss */
+	if (tmp[1] == 1)
+		return res;
+
+	proc_mbssid_data(wiphy, data, ftype, bssid, tsf, capability,
+			 beacon_interval, ie, ielen, res, gfp);
+
+	return res;
+}
+EXPORT_SYMBOL(cfg80211_inform_bss_data);
+
+void proc_mbssid_frame_data(struct wiphy *wiphy,
+			    struct cfg80211_inform_bss *data,
+			    struct ieee80211_mgmt *mgmt, size_t len,
+			    struct cfg80211_bss *trans_bss,
+			    gfp_t gfp)
+{
+	enum cfg80211_bss_frame_type ftype;
+	u8 *ie;
+	size_t ielen = len - offsetof(struct ieee80211_mgmt,
+			u.probe_resp.variable);
+
+	ie =  mgmt->u.probe_resp.variable;
+
+	ftype = ieee80211_is_beacon(mgmt->frame_control) ?
+			CFG80211_BSS_FTYPE_BEACON : CFG80211_BSS_FTYPE_PRESP;
+
+	proc_mbssid_data(wiphy, data,
+			 ftype, mgmt->bssid,
+			 le64_to_cpu(mgmt->u.probe_resp.timestamp),
+			 le16_to_cpu(mgmt->u.probe_resp.capab_info),
+			 le16_to_cpu(mgmt->u.probe_resp.beacon_int),
+			 ie, ielen, trans_bss, gfp);
+}
+
+void update_notlisted_nontrans(struct wiphy *wiphy,
+			       struct cfg80211_internal_bss *nontrans_bss,
 			       struct ieee80211_mgmt *mgmt, size_t len,
 			       gfp_t gfp)
 
 {
+	enum cfg80211_bss_frame_type ftype;
+	u8 *ie, *new_ie, *pos;
+	const u8 *tmp, *tmp1;
+	size_t ielen = len - offsetof(struct ieee80211_mgmt,
+				u.probe_resp.variable);
+	size_t new_ie_len;
+	struct cfg80211_bss_ies *new_ies;
+	const struct cfg80211_bss_ies *old;
+
+	ie =  mgmt->u.probe_resp.variable;
+	ftype = ieee80211_is_beacon(mgmt->frame_control) ?
+			CFG80211_BSS_FTYPE_BEACON : CFG80211_BSS_FTYPE_PRESP;
+
+	new_ie_len = ielen;
+	tmp = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
+	if (!tmp)
+		return;
+	new_ie_len -= tmp[1];
+	tmp = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen);
+	if (!tmp)
+		return;
+	new_ie_len -= tmp[1];
+	tmp = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
+	if (!tmp)
+		return;
+	new_ie_len += tmp[1];
+
+	/* generate new ie for nontrans BSS
+	 * 1. replace SSID with nontrans BSS' SSID
+	 * 2. skip MBSSID IE
+	 */
+	new_ie = kzalloc(new_ie_len, gfp);
+	if (!new_ie)
+		goto error;
+	pos = new_ie;
+	tmp = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
+	if (!tmp)
+		goto error;
+
+	memcpy(pos, tmp, tmp[1] + 2);
+	pos += tmp[1] + 2;
+	tmp = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen);
+	tmp1 = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
+	if (!tmp || !tmp1)
+		goto error;
+	memcpy(pos, (tmp1 + tmp1[1] + 2), (tmp - (tmp1 + tmp1[1] + 2)));
+	pos += (tmp - (tmp1 + tmp1[1] + 2));
+	memcpy(pos, tmp + tmp[1] + 2, ((ie + ielen) - (tmp + tmp[1] + 2)));
+
+	/* update ie */
+	new_ies = kzalloc(sizeof(*new_ies) + new_ie_len, gfp);
+	if (!new_ies)
+		goto error;
+	new_ies->len = new_ie_len;
+	new_ies->tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
+	new_ies->from_beacon = ieee80211_is_beacon(mgmt->frame_control);
+	memcpy(new_ies->data, new_ie, new_ie_len);
+	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
+		old = rcu_access_pointer(nontrans_bss->pub.proberesp_ies);
+		rcu_assign_pointer(nontrans_bss->pub.proberesp_ies, new_ies);
+		rcu_assign_pointer(nontrans_bss->pub.ies, new_ies);
+		if (old)
+			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
+	} else {
+		old = rcu_access_pointer(nontrans_bss->pub.beacon_ies);
+		rcu_assign_pointer(nontrans_bss->pub.beacon_ies, new_ies);
+		rcu_assign_pointer(nontrans_bss->pub.ies, new_ies);
+		if (old)
+			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
+	}
+
+	return;
+
+error:
+	kfree(new_ie);
+}
+
+/* cfg80211_inform_bss_width_frame helper */
+struct cfg80211_bss *
+cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
+				      struct cfg80211_inform_bss *data,
+				      struct ieee80211_mgmt *mgmt, size_t len,
+				      struct cfg80211_bss *trans_bss,
+				      gfp_t gfp)
+
+{
 	struct cfg80211_internal_bss tmp = {}, *res;
 	struct cfg80211_bss_ies *ies;
 	struct ieee80211_channel *channel;
@@ -1254,6 +1702,63 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
+EXPORT_SYMBOL(cfg80211_inform_single_bss_frame_data);
+
+struct cfg80211_bss *
+cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
+			       struct cfg80211_inform_bss *data,
+			       struct ieee80211_mgmt *mgmt, size_t len,
+			       gfp_t gfp)
+{
+	bool mbssid_present = false;
+	struct cfg80211_bss *res;
+	struct cfg80211_internal_bss *trans_bss, *tmp_bss;
+	const u8 *tmp;
+	u8 *ie;
+	const struct cfg80211_bss_ies *ies1, *ies2;
+	size_t ielen = len - offsetof(struct ieee80211_mgmt,
+			u.probe_resp.variable);
+
+	ie =  mgmt->u.probe_resp.variable;
+
+	tmp = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen);
+	if (tmp)
+		mbssid_present = true;
+
+	res = cfg80211_inform_single_bss_frame_data(wiphy, data, mgmt,
+						    len, NULL, gfp);
+	if (!mbssid_present)
+		return res;
+
+	/* process each non-transmitting bss */
+	if (tmp[1] == 1)
+		return res;
+
+	proc_mbssid_frame_data(wiphy, data, mgmt, len, res, gfp);
+
+	/* check if the res has other nontransmitting bss which is not
+	 * in MBSSID IE
+	 */
+	ies1 = rcu_access_pointer(res->ies);
+	trans_bss = container_of(res, struct cfg80211_internal_bss, pub);
+	if (!trans_bss)
+		return res;
+	if (!list_empty(&trans_bss->nontrans_list)) {
+		/* go through nontrans_list, if the timestamp of the BSS is
+		 * earlier than the timestamp of the transmitting BSS then
+		 * update it
+		 */
+		list_for_each_entry(tmp_bss, &trans_bss->nontrans_list,
+				    nontrans_list) {
+			ies2 = rcu_access_pointer(tmp_bss->pub.ies);
+			if (ies2->tsf < ies1->tsf)
+				update_notlisted_nontrans(wiphy, tmp_bss, mgmt,
+							  len, gfp);
+		}
+	}
+
+	return res;
+}
 EXPORT_SYMBOL(cfg80211_inform_bss_frame_data);
 
 void cfg80211_ref_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
@@ -1291,7 +1796,7 @@ EXPORT_SYMBOL(cfg80211_put_bss);
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
-	struct cfg80211_internal_bss *bss;
+	struct cfg80211_internal_bss *bss, *nontrans_bss, *tmp;
 
 	if (WARN_ON(!pub))
 		return;
@@ -1300,6 +1805,14 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 
 	spin_lock_bh(&rdev->bss_lock);
 	if (!list_empty(&bss->list)) {
+		if (!list_empty(&bss->nontrans_list)) {
+			list_for_each_entry_safe(nontrans_bss, tmp,
+						 &bss->nontrans_list,
+						 nontrans_list) {
+				if (__cfg80211_unlink_bss(rdev, nontrans_bss))
+					rdev->bss_generation++;
+			}
+		}
 		if (__cfg80211_unlink_bss(rdev, bss))
 			rdev->bss_generation++;
 	}
-- 
2.7.4
