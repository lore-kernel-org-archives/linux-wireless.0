Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 844B6C282C2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 11:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 483AE218CD
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 11:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfAYLsk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 06:48:40 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55794 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbfAYLsd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 06:48:33 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gmzyH-0007S0-JP; Fri, 25 Jan 2019 12:48:29 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH 03/12] cfg80211: Parsing of Multiple BSSID information in scanning
Date:   Fri, 25 Jan 2019 12:48:16 +0100
Message-Id: <20190125114825.5872-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190125114825.5872-1-johannes@sipsolutions.net>
References: <20190125114825.5872-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

This extends cfg80211 BSS table processing to be able to parse Multiple
BSSID element from Beacon and Probe Response frames and to update the
BSS profiles in internal database for non-transmitted BSSs.

Signed-off-by: Peng Xu <pxu@codeaurora.org>
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.h |   3 +-
 net/wireless/scan.c | 508 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 472 insertions(+), 39 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index c5d6f3418601..a50b92ac77a1 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -3,7 +3,7 @@
  * Wireless configuration interface internals.
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  */
 #ifndef __NET_WIRELESS_CORE_H
 #define __NET_WIRELESS_CORE_H
@@ -152,6 +152,7 @@ extern int cfg80211_rdev_list_generation;
 struct cfg80211_internal_bss {
 	struct list_head list;
 	struct list_head hidden_list;
+	struct list_head nontrans_list;
 	struct rb_node rbn;
 	u64 ts_boottime;
 	unsigned long ts;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 5123667f4569..d50fee7da88b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -5,6 +5,7 @@
  * Copyright 2008 Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2016	Intel Deutschland GmbH
+ * Copyright (C) 2018-2019 Intel Corporation
  */
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -150,6 +151,7 @@ static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *rdev,
 	}
 
 	list_del_init(&bss->list);
+	list_del_init(&bss->nontrans_list);
 	rb_erase(&bss->rbn, &rdev->bss_tree);
 	rdev->bss_entries--;
 	WARN_ONCE((rdev->bss_entries == 0) ^ list_empty(&rdev->bss_list),
@@ -159,6 +161,172 @@ static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *rdev,
 	return true;
 }
 
+static void cfg80211_gen_new_bssid(const u8 *bssid, u8 max_bssid,
+				   u8 mbssid_index, u8 *new_bssid_addr)
+{
+	u64 bssid_tmp, new_bssid = 0;
+	u64 lsb_n;
+
+	bssid_tmp = ether_addr_to_u64(bssid);
+
+	lsb_n = bssid_tmp & ((1 << max_bssid) - 1);
+	new_bssid = bssid_tmp;
+	new_bssid &= ~((1 << max_bssid) - 1);
+	new_bssid |= (lsb_n + mbssid_index) % (1 << max_bssid);
+
+	u64_to_ether_addr(new_bssid, new_bssid_addr);
+}
+
+static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
+				  const u8 *subelement, size_t subie_len,
+				  u8 *new_ie, gfp_t gfp)
+{
+	u8 *pos, *tmp;
+	const u8 *tmp_old, *tmp_new;
+	u8 *sub_copy;
+
+	/* copy subelement as we need to change its content to
+	 * mark an ie after it is processed.
+	 */
+	sub_copy = kmalloc(subie_len, gfp);
+	if (!sub_copy)
+		return 0;
+	memcpy(sub_copy, subelement, subie_len);
+
+	pos = &new_ie[0];
+
+	/* set new ssid */
+	tmp_new = cfg80211_find_ie(WLAN_EID_SSID, sub_copy, subie_len);
+	if (tmp_new) {
+		memcpy(pos, tmp_new, tmp_new[1] + 2);
+		pos += (tmp_new[1] + 2);
+	}
+
+	/* go through IEs in ie (skip SSID) and subelement,
+	 * merge them into new_ie
+	 */
+	tmp_old = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
+	tmp_old = (tmp_old) ? tmp_old + tmp_old[1] + 2 : ie;
+
+	while (tmp_old + tmp_old[1] + 2 - ie <= ielen) {
+		if (tmp_old[0] == 0) {
+			tmp_old++;
+			continue;
+		}
+
+		tmp = (u8 *)cfg80211_find_ie(tmp_old[0], sub_copy, subie_len);
+		if (!tmp) {
+			/* ie in old ie but not in subelement */
+			if (tmp_old[0] != WLAN_EID_MULTIPLE_BSSID) {
+				memcpy(pos, tmp_old, tmp_old[1] + 2);
+				pos += tmp_old[1] + 2;
+			}
+		} else {
+			/* ie in transmitting ie also in subelement,
+			 * copy from subelement and flag the ie in subelement
+			 * as copied (by setting eid field to 0xff). For
+			 * vendor ie, compare OUI + type + subType to
+			 * determine if they are the same ie.
+			 */
+			if (tmp_old[0] == WLAN_EID_VENDOR_SPECIFIC) {
+				if (!memcmp(tmp_old + 2, tmp + 2, 5)) {
+					/* same vendor ie, copy from
+					 * subelement
+					 */
+					memcpy(pos, tmp, tmp[1] + 2);
+					pos += tmp[1] + 2;
+					tmp[0] = 0xff;
+				} else {
+					memcpy(pos, tmp_old, tmp_old[1] + 2);
+					pos += tmp_old[1] + 2;
+				}
+			} else {
+				/* copy ie from subelement into new ie */
+				memcpy(pos, tmp, tmp[1] + 2);
+				pos += tmp[1] + 2;
+				tmp[0] = 0xff;
+			}
+		}
+
+		if (tmp_old + tmp_old[1] + 2 - ie == ielen)
+			break;
+
+		tmp_old += tmp_old[1] + 2;
+	}
+
+	/* go through subelement again to check if there is any ie not
+	 * copied to new ie, skip ssid, capability, bssid-index ie
+	 */
+	tmp_new = sub_copy;
+	while (tmp_new + tmp_new[1] + 2 - sub_copy <= subie_len) {
+		if (!(tmp_new[0] == WLAN_EID_NON_TX_BSSID_CAP ||
+		      tmp_new[0] == WLAN_EID_SSID ||
+		      tmp_new[0] == WLAN_EID_MULTI_BSSID_IDX ||
+		      tmp_new[0] == 0xff)) {
+			memcpy(pos, tmp_new, tmp_new[1] + 2);
+			pos += tmp_new[1] + 2;
+		}
+		if (tmp_new + tmp_new[1] + 2 - sub_copy == subie_len)
+			break;
+		tmp_new += tmp_new[1] + 2;
+	}
+
+	kfree(sub_copy);
+	return pos - new_ie;
+}
+
+static bool is_bss(struct cfg80211_bss *a, const u8 *bssid,
+		   const u8 *ssid, size_t ssid_len)
+{
+	const struct cfg80211_bss_ies *ies;
+	const u8 *ssidie;
+
+	if (bssid && !ether_addr_equal(a->bssid, bssid))
+		return false;
+
+	if (!ssid)
+		return true;
+
+	ies = rcu_access_pointer(a->ies);
+	if (!ies)
+		return false;
+	ssidie = cfg80211_find_ie(WLAN_EID_SSID, ies->data, ies->len);
+	if (!ssidie)
+		return false;
+	if (ssidie[1] != ssid_len)
+		return false;
+	return memcmp(ssidie + 2, ssid, ssid_len) == 0;
+}
+
+static int
+cfg80211_add_nontrans_list(struct cfg80211_internal_bss *trans_bss,
+			   struct cfg80211_internal_bss *nontrans_bss)
+{
+	const u8 *ssid;
+	size_t ssid_len;
+	struct cfg80211_internal_bss *bss = NULL;
+
+	rcu_read_lock();
+	ssid = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
+	if (!ssid) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	ssid_len = ssid[1];
+	ssid = ssid + 2;
+	rcu_read_unlock();
+
+	/* check if nontrans_bss is in the list */
+	list_for_each_entry(bss, &trans_bss->nontrans_list, nontrans_list) {
+		if (is_bss(&bss->pub, nontrans_bss->pub.bssid, ssid, ssid_len))
+			return 0;
+	}
+
+	/* add to the list */
+	list_add_tail(&nontrans_bss->nontrans_list, &trans_bss->nontrans_list);
+	return 0;
+}
+
 static void __cfg80211_bss_expire(struct cfg80211_registered_device *rdev,
 				  unsigned long expire_time)
 {
@@ -525,29 +693,6 @@ const u8 *cfg80211_find_vendor_ie(unsigned int oui, int oui_type,
 }
 EXPORT_SYMBOL(cfg80211_find_vendor_ie);
 
-static bool is_bss(struct cfg80211_bss *a, const u8 *bssid,
-		   const u8 *ssid, size_t ssid_len)
-{
-	const struct cfg80211_bss_ies *ies;
-	const u8 *ssidie;
-
-	if (bssid && !ether_addr_equal(a->bssid, bssid))
-		return false;
-
-	if (!ssid)
-		return true;
-
-	ies = rcu_access_pointer(a->ies);
-	if (!ies)
-		return false;
-	ssidie = cfg80211_find_ie(WLAN_EID_SSID, ies->data, ies->len);
-	if (!ssidie)
-		return false;
-	if (ssidie[1] != ssid_len)
-		return false;
-	return memcmp(ssidie + 2, ssid, ssid_len) == 0;
-}
-
 /**
  * enum bss_compare_mode - BSS compare mode
  * @BSS_CMP_REGULAR: regular compare mode (for insertion and normal find)
@@ -1009,6 +1154,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		memcpy(new, tmp, sizeof(*new));
 		new->refcount = 1;
 		INIT_LIST_HEAD(&new->hidden_list);
+		INIT_LIST_HEAD(&new->nontrans_list);
 
 		if (rcu_access_pointer(tmp->pub.proberesp_ies)) {
 			hidden = rb_find_bss(rdev, tmp, BSS_CMP_HIDE_ZLEN);
@@ -1130,17 +1276,19 @@ cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
 }
 
 /* Returned bss is reference counted and must be cleaned up appropriately. */
-struct cfg80211_bss *
-cfg80211_inform_bss_data(struct wiphy *wiphy,
-			 struct cfg80211_inform_bss *data,
-			 enum cfg80211_bss_frame_type ftype,
-			 const u8 *bssid, u64 tsf, u16 capability,
-			 u16 beacon_interval, const u8 *ie, size_t ielen,
-			 gfp_t gfp)
+static struct cfg80211_bss *
+cfg80211_inform_single_bss_data(struct wiphy *wiphy,
+				struct cfg80211_inform_bss *data,
+				enum cfg80211_bss_frame_type ftype,
+				const u8 *bssid, u64 tsf, u16 capability,
+				u16 beacon_interval, const u8 *ie, size_t ielen,
+				struct cfg80211_bss *trans_bss,
+				gfp_t gfp)
 {
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_bss_ies *ies;
 	struct ieee80211_channel *channel;
-	struct cfg80211_internal_bss tmp = {}, *res;
+	struct cfg80211_internal_bss tmp = {}, *res, *trans_internal;
 	int bss_type;
 	bool signal_valid;
 
@@ -1209,19 +1357,252 @@ cfg80211_inform_bss_data(struct wiphy *wiphy,
 			regulatory_hint_found_beacon(wiphy, channel, gfp);
 	}
 
+	if (trans_bss) {
+		/* this is a nontransmitting bss, we need to add it to
+		 * transmitting bss' list if it is not there
+		 */
+		trans_internal = container_of(trans_bss,
+					      struct cfg80211_internal_bss,
+					      pub);
+		if (cfg80211_add_nontrans_list(trans_internal, res)) {
+			if (__cfg80211_unlink_bss(rdev, res))
+				rdev->bss_generation++;
+		}
+	}
+
 	trace_cfg80211_return_bss(&res->pub);
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
-EXPORT_SYMBOL(cfg80211_inform_bss_data);
 
-/* cfg80211_inform_bss_width_frame helper */
+static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
+				       struct cfg80211_inform_bss *data,
+				       enum cfg80211_bss_frame_type ftype,
+				       const u8 *bssid, u64 tsf,
+				       u16 beacon_interval, const u8 *ie,
+				       size_t ielen,
+				       struct cfg80211_bss *trans_bss,
+				       gfp_t gfp)
+{
+	const u8 *pos, *subelement, *mbssid_end_pos;
+	const u8 *tmp, *mbssid_index_ie;
+	size_t subie_len, new_ie_len;
+	u8 new_bssid[ETH_ALEN];
+	u8 *new_ie;
+	u16 capability;
+	struct cfg80211_bss *bss;
+
+	if (!trans_bss)
+		return;
+	if (!cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
+		return;
+
+	pos = ie;
+
+	new_ie = kmalloc(IEEE80211_MAX_DATA_LEN, gfp);
+	if (!new_ie)
+		return;
+
+	while (pos < ie + ielen + 2) {
+		tmp = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, pos,
+				       ielen - (pos - ie));
+		if (!tmp)
+			break;
+
+		mbssid_end_pos = tmp + tmp[1] + 2;
+		/* Skip Element ID, Len, MaxBSSID Indicator */
+		if (tmp[1] < 4)
+			break;
+		for (subelement = tmp + 3; subelement < mbssid_end_pos - 1;
+		     subelement += 2 + subelement[1]) {
+			subie_len = subelement[1];
+			if (mbssid_end_pos - subelement < 2 + subie_len)
+				break;
+			if (subelement[0] != 0 || subelement[1] < 4) {
+				/* not a valid BSS profile */
+				continue;
+			}
+
+			if (subelement[2] != WLAN_EID_NON_TX_BSSID_CAP ||
+			    subelement[3] != 2) {
+				/* The first element within the Nontransmitted
+				 * BSSID Profile is not the Nontransmitted
+				 * BSSID Capability element.
+				 */
+				continue;
+			}
+
+			/* found a Nontransmitted BSSID Profile */
+			mbssid_index_ie = cfg80211_find_ie
+				(WLAN_EID_MULTI_BSSID_IDX,
+				 subelement + 2, subie_len);
+			if (!mbssid_index_ie || mbssid_index_ie[1] < 1 ||
+			    mbssid_index_ie[2] == 0) {
+				/* No valid Multiple BSSID-Index element */
+				continue;
+			}
+
+			cfg80211_gen_new_bssid(bssid, tmp[2],
+					       mbssid_index_ie[2],
+					       new_bssid);
+			memset(new_ie, 0, IEEE80211_MAX_DATA_LEN);
+			new_ie_len = cfg80211_gen_new_ie(ie, ielen,
+							 subelement + 2,
+							 subie_len, new_ie,
+							 gfp);
+			if (!new_ie_len)
+				continue;
+
+			capability = le16_to_cpup((const __le16 *)
+						  &subelement[4]);
+			bss = cfg80211_inform_single_bss_data(wiphy, data,
+							      ftype,
+							      new_bssid, tsf,
+							      capability,
+							      beacon_interval,
+							      new_ie,
+							      new_ie_len,
+							      trans_bss, gfp);
+			if (!bss)
+				break;
+			cfg80211_put_bss(wiphy, bss);
+		}
+
+		pos = mbssid_end_pos;
+	}
+
+	kfree(new_ie);
+}
+
 struct cfg80211_bss *
-cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
-			       struct cfg80211_inform_bss *data,
-			       struct ieee80211_mgmt *mgmt, size_t len,
-			       gfp_t gfp)
+cfg80211_inform_bss_data(struct wiphy *wiphy,
+			 struct cfg80211_inform_bss *data,
+			 enum cfg80211_bss_frame_type ftype,
+			 const u8 *bssid, u64 tsf, u16 capability,
+			 u16 beacon_interval, const u8 *ie, size_t ielen,
+			 gfp_t gfp)
+{
+	struct cfg80211_bss *res;
+
+	res = cfg80211_inform_single_bss_data(wiphy, data, ftype, bssid, tsf,
+					      capability, beacon_interval, ie,
+					      ielen, NULL, gfp);
+	cfg80211_parse_mbssid_data(wiphy, data, ftype, bssid, tsf,
+				   beacon_interval, ie, ielen, res, gfp);
+	return res;
+}
+EXPORT_SYMBOL(cfg80211_inform_bss_data);
 
+static void
+cfg80211_parse_mbssid_frame_data(struct wiphy *wiphy,
+				 struct cfg80211_inform_bss *data,
+				 struct ieee80211_mgmt *mgmt, size_t len,
+				 struct cfg80211_bss *trans_bss,
+				 gfp_t gfp)
+{
+	enum cfg80211_bss_frame_type ftype;
+	const u8 *ie = mgmt->u.probe_resp.variable;
+	size_t ielen = len - offsetof(struct ieee80211_mgmt,
+				      u.probe_resp.variable);
+
+	ftype = ieee80211_is_beacon(mgmt->frame_control) ?
+		CFG80211_BSS_FTYPE_BEACON : CFG80211_BSS_FTYPE_PRESP;
+
+	cfg80211_parse_mbssid_data(wiphy, data, ftype, mgmt->bssid,
+				   le64_to_cpu(mgmt->u.probe_resp.timestamp),
+				   le16_to_cpu(mgmt->u.probe_resp.beacon_int),
+				   ie, ielen, trans_bss, gfp);
+}
+
+static void
+cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
+				   struct cfg80211_internal_bss *nontrans_bss,
+				   struct ieee80211_mgmt *mgmt, size_t len,
+				   gfp_t gfp)
+{
+	u8 *ie, *new_ie, *pos;
+	const u8 *nontrans_ssid, *trans_ssid, *mbssid;
+	size_t ielen = len - offsetof(struct ieee80211_mgmt,
+				      u.probe_resp.variable);
+	size_t new_ie_len;
+	struct cfg80211_bss_ies *new_ies;
+	const struct cfg80211_bss_ies *old;
+	u8 cpy_len;
+
+	ie = mgmt->u.probe_resp.variable;
+
+	new_ie_len = ielen;
+	trans_ssid = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
+	if (!trans_ssid)
+		return;
+	new_ie_len -= trans_ssid[1];
+	mbssid = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen);
+	if (!mbssid)
+		return;
+	new_ie_len -= mbssid[1];
+	rcu_read_lock();
+	nontrans_ssid = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
+	if (!nontrans_ssid) {
+		rcu_read_unlock();
+		return;
+	}
+	new_ie_len += nontrans_ssid[1];
+	rcu_read_unlock();
+
+	/* generate new ie for nontrans BSS
+	 * 1. replace SSID with nontrans BSS' SSID
+	 * 2. skip MBSSID IE
+	 */
+	new_ie = kzalloc(new_ie_len, gfp);
+	if (!new_ie)
+		return;
+	new_ies = kzalloc(sizeof(*new_ies) + new_ie_len, gfp);
+	if (!new_ies) {
+		kfree(new_ie);
+		return;
+	}
+
+	pos = new_ie;
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
+
+	/* update ie */
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
+}
+
+/* cfg80211_inform_bss_width_frame helper */
+static struct cfg80211_bss *
+cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
+				      struct cfg80211_inform_bss *data,
+				      struct ieee80211_mgmt *mgmt, size_t len,
+				      struct cfg80211_bss *trans_bss,
+				      gfp_t gfp)
 {
 	struct cfg80211_internal_bss tmp = {}, *res;
 	struct cfg80211_bss_ies *ies;
@@ -1300,6 +1681,50 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
+
+struct cfg80211_bss *
+cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
+			       struct cfg80211_inform_bss *data,
+			       struct ieee80211_mgmt *mgmt, size_t len,
+			       gfp_t gfp)
+{
+	struct cfg80211_bss *res;
+	struct cfg80211_internal_bss *trans_bss, *tmp_bss;
+	const u8 *ie = mgmt->u.probe_resp.variable;
+	const struct cfg80211_bss_ies *ies1, *ies2;
+	size_t ielen = len - offsetof(struct ieee80211_mgmt,
+				      u.probe_resp.variable);
+
+	res = cfg80211_inform_single_bss_frame_data(wiphy, data, mgmt,
+						    len, NULL, gfp);
+	if (!res || !cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
+		return res;
+
+	/* process each non-transmitting bss */
+	cfg80211_parse_mbssid_frame_data(wiphy, data, mgmt, len, res, gfp);
+
+	/* check if the res has other nontransmitting bss which is not
+	 * in MBSSID IE
+	 */
+	ies1 = rcu_access_pointer(res->ies);
+	trans_bss = container_of(res, struct cfg80211_internal_bss, pub);
+	if (!trans_bss)
+		return res;
+
+	/* go through nontrans_list, if the timestamp of the BSS is
+	 * earlier than the timestamp of the transmitting BSS then
+	 * update it
+	 */
+	list_for_each_entry(tmp_bss, &trans_bss->nontrans_list,
+			    nontrans_list) {
+		ies2 = rcu_access_pointer(tmp_bss->pub.ies);
+		if (ies2->tsf < ies1->tsf)
+			cfg80211_update_notlisted_nontrans(wiphy, tmp_bss,
+							   mgmt, len, gfp);
+	}
+
+	return res;
+}
 EXPORT_SYMBOL(cfg80211_inform_bss_frame_data);
 
 void cfg80211_ref_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
@@ -1337,7 +1762,7 @@ EXPORT_SYMBOL(cfg80211_put_bss);
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
-	struct cfg80211_internal_bss *bss;
+	struct cfg80211_internal_bss *bss, *nontrans_bss, *tmp;
 
 	if (WARN_ON(!pub))
 		return;
@@ -1346,6 +1771,13 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 
 	spin_lock_bh(&rdev->bss_lock);
 	if (!list_empty(&bss->list)) {
+		list_for_each_entry_safe(nontrans_bss, tmp,
+					 &bss->nontrans_list,
+					 nontrans_list) {
+			if (__cfg80211_unlink_bss(rdev, nontrans_bss))
+				rdev->bss_generation++;
+		}
+
 		if (__cfg80211_unlink_bss(rdev, bss))
 			rdev->bss_generation++;
 	}
-- 
2.17.2

