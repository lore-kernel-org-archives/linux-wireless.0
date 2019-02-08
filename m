Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2081AC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E50AE217D8
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfBHNPv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:15:51 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48698 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfBHNPq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:15:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs60N-0008Jb-Mf; Fri, 08 Feb 2019 14:15:43 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH v8 06/15] cfg80211: Move Multiple BSS info to struct cfg80211_bss to be visible
Date:   Fri,  8 Feb 2019 14:15:30 +0100
Message-Id: <20190208131539.6813-6-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208131539.6813-1-johannes@sipsolutions.net>
References: <20190208131539.6813-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Previously the transmitted BSS and the non-trasmitted BSS list were
defined in struct cfg80211_internal_bss. Move them to struct cfg80211_bss
since mac80211 needs this info.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  4 ++-
 net/wireless/core.h    | 10 +++---
 net/wireless/scan.c    | 80 ++++++++++++++++++++----------------------
 3 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c077de7fbd8a..86de6b62a44b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6,7 +6,7 @@
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014 Intel Mobile Communications GmbH
  * Copyright 2015-2017	Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -2049,6 +2049,8 @@ struct cfg80211_bss {
 	const struct cfg80211_bss_ies __rcu *proberesp_ies;
 
 	struct cfg80211_bss *hidden_beacon_bss;
+	struct cfg80211_bss *transmitted_bss;
+	struct list_head nontrans_list;
 
 	s32 signal;
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index c20c75df60f5..f257a2b32ba4 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -152,8 +152,6 @@ extern int cfg80211_rdev_list_generation;
 struct cfg80211_internal_bss {
 	struct list_head list;
 	struct list_head hidden_list;
-	struct list_head nontrans_list;
-	struct cfg80211_bss *transmitted_bss;
 	struct rb_node rbn;
 	u64 ts_boottime;
 	unsigned long ts;
@@ -184,8 +182,8 @@ static inline struct cfg80211_internal_bss *bss_from_pub(struct cfg80211_bss *pu
 static inline void cfg80211_hold_bss(struct cfg80211_internal_bss *bss)
 {
 	atomic_inc(&bss->hold);
-	if (bss->transmitted_bss) {
-		bss = container_of(bss->transmitted_bss,
+	if (bss->pub.transmitted_bss) {
+		bss = container_of(bss->pub.transmitted_bss,
 				   struct cfg80211_internal_bss, pub);
 		atomic_inc(&bss->hold);
 	}
@@ -195,8 +193,8 @@ static inline void cfg80211_unhold_bss(struct cfg80211_internal_bss *bss)
 {
 	int r = atomic_dec_return(&bss->hold);
 	WARN_ON(r < 0);
-	if (bss->transmitted_bss) {
-		bss = container_of(bss->transmitted_bss,
+	if (bss->pub.transmitted_bss) {
+		bss = container_of(bss->pub.transmitted_bss,
 				   struct cfg80211_internal_bss, pub);
 		r = atomic_dec_return(&bss->hold);
 		WARN_ON(r < 0);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d5950a23e619..325323a842d8 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -110,8 +110,8 @@ static inline void bss_ref_get(struct cfg80211_registered_device *rdev,
 				   pub);
 		bss->refcount++;
 	}
-	if (bss->transmitted_bss) {
-		bss = container_of(bss->transmitted_bss,
+	if (bss->pub.transmitted_bss) {
+		bss = container_of(bss->pub.transmitted_bss,
 				   struct cfg80211_internal_bss,
 				   pub);
 		bss->refcount++;
@@ -133,10 +133,10 @@ static inline void bss_ref_put(struct cfg80211_registered_device *rdev,
 			bss_free(hbss);
 	}
 
-	if (bss->transmitted_bss) {
+	if (bss->pub.transmitted_bss) {
 		struct cfg80211_internal_bss *tbss;
 
-		tbss = container_of(bss->transmitted_bss,
+		tbss = container_of(bss->pub.transmitted_bss,
 				    struct cfg80211_internal_bss,
 				    pub);
 		tbss->refcount--;
@@ -169,7 +169,7 @@ static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *rdev,
 	}
 
 	list_del_init(&bss->list);
-	list_del_init(&bss->nontrans_list);
+	list_del_init(&bss->pub.nontrans_list);
 	rb_erase(&bss->rbn, &rdev->bss_tree);
 	rdev->bss_entries--;
 	WARN_ONCE((rdev->bss_entries == 0) ^ list_empty(&rdev->bss_list),
@@ -317,15 +317,15 @@ static bool is_bss(struct cfg80211_bss *a, const u8 *bssid,
 }
 
 static int
-cfg80211_add_nontrans_list(struct cfg80211_internal_bss *trans_bss,
-			   struct cfg80211_internal_bss *nontrans_bss)
+cfg80211_add_nontrans_list(struct cfg80211_bss *trans_bss,
+			   struct cfg80211_bss *nontrans_bss)
 {
 	const u8 *ssid;
 	size_t ssid_len;
-	struct cfg80211_internal_bss *bss = NULL;
+	struct cfg80211_bss *bss = NULL;
 
 	rcu_read_lock();
-	ssid = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
+	ssid = ieee80211_bss_get_ie(nontrans_bss, WLAN_EID_SSID);
 	if (!ssid) {
 		rcu_read_unlock();
 		return -EINVAL;
@@ -336,7 +336,7 @@ cfg80211_add_nontrans_list(struct cfg80211_internal_bss *trans_bss,
 
 	/* check if nontrans_bss is in the list */
 	list_for_each_entry(bss, &trans_bss->nontrans_list, nontrans_list) {
-		if (is_bss(&bss->pub, nontrans_bss->pub.bssid, ssid, ssid_len))
+		if (is_bss(bss, nontrans_bss->bssid, ssid, ssid_len))
 			return 0;
 	}
 
@@ -1166,7 +1166,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		memcpy(new, tmp, sizeof(*new));
 		new->refcount = 1;
 		INIT_LIST_HEAD(&new->hidden_list);
-		INIT_LIST_HEAD(&new->nontrans_list);
+		INIT_LIST_HEAD(&new->pub.nontrans_list);
 
 		if (rcu_access_pointer(tmp->pub.proberesp_ies)) {
 			hidden = rb_find_bss(rdev, tmp, BSS_CMP_HIDE_ZLEN);
@@ -1207,7 +1207,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 					     struct cfg80211_internal_bss,
 					     pub);
 
-			new->transmitted_bss = trans_bss;
+			new->pub.transmitted_bss = trans_bss;
 			bss_ref_get(rdev, pbss);
 		}
 
@@ -1311,7 +1311,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_bss_ies *ies;
 	struct ieee80211_channel *channel;
-	struct cfg80211_internal_bss tmp = {}, *res, *trans_internal;
+	struct cfg80211_internal_bss tmp = {}, *res;
 	int bss_type;
 	bool signal_valid;
 
@@ -1385,10 +1385,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 		/* this is a nontransmitting bss, we need to add it to
 		 * transmitting bss' list if it is not there
 		 */
-		trans_internal = container_of(trans_bss,
-					      struct cfg80211_internal_bss,
-					      pub);
-		if (cfg80211_add_nontrans_list(trans_internal, res)) {
+		if (cfg80211_add_nontrans_list(trans_bss, &res->pub)) {
 			if (__cfg80211_unlink_bss(rdev, res))
 				rdev->bss_generation++;
 		}
@@ -1523,7 +1520,7 @@ cfg80211_parse_mbssid_frame_data(struct wiphy *wiphy,
 
 static void
 cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
-				   struct cfg80211_internal_bss *nontrans_bss,
+				   struct cfg80211_bss *nontrans_bss,
 				   struct ieee80211_mgmt *mgmt, size_t len,
 				   gfp_t gfp)
 {
@@ -1548,7 +1545,7 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 		return;
 	new_ie_len -= mbssid[1];
 	rcu_read_lock();
-	nontrans_ssid = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
+	nontrans_ssid = ieee80211_bss_get_ie(nontrans_bss, WLAN_EID_SSID);
 	if (!nontrans_ssid) {
 		rcu_read_unlock();
 		return;
@@ -1589,15 +1586,15 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 	new_ies->from_beacon = ieee80211_is_beacon(mgmt->frame_control);
 	memcpy(new_ies->data, new_ie, new_ie_len);
 	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
-		old = rcu_access_pointer(nontrans_bss->pub.proberesp_ies);
-		rcu_assign_pointer(nontrans_bss->pub.proberesp_ies, new_ies);
-		rcu_assign_pointer(nontrans_bss->pub.ies, new_ies);
+		old = rcu_access_pointer(nontrans_bss->proberesp_ies);
+		rcu_assign_pointer(nontrans_bss->proberesp_ies, new_ies);
+		rcu_assign_pointer(nontrans_bss->ies, new_ies);
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
 	} else {
-		old = rcu_access_pointer(nontrans_bss->pub.beacon_ies);
-		rcu_assign_pointer(nontrans_bss->pub.beacon_ies, new_ies);
-		rcu_assign_pointer(nontrans_bss->pub.ies, new_ies);
+		old = rcu_access_pointer(nontrans_bss->beacon_ies);
+		rcu_assign_pointer(nontrans_bss->beacon_ies, new_ies);
+		rcu_assign_pointer(nontrans_bss->ies, new_ies);
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
 	}
@@ -1696,8 +1693,7 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 			       struct ieee80211_mgmt *mgmt, size_t len,
 			       gfp_t gfp)
 {
-	struct cfg80211_bss *res;
-	struct cfg80211_internal_bss *trans_bss, *tmp_bss;
+	struct cfg80211_bss *res, *tmp_bss;
 	const u8 *ie = mgmt->u.probe_resp.variable;
 	const struct cfg80211_bss_ies *ies1, *ies2;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
@@ -1715,17 +1711,14 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	 * in MBSSID IE
 	 */
 	ies1 = rcu_access_pointer(res->ies);
-	trans_bss = container_of(res, struct cfg80211_internal_bss, pub);
-	if (!trans_bss)
-		return res;
 
 	/* go through nontrans_list, if the timestamp of the BSS is
 	 * earlier than the timestamp of the transmitting BSS then
 	 * update it
 	 */
-	list_for_each_entry(tmp_bss, &trans_bss->nontrans_list,
+	list_for_each_entry(tmp_bss, &res->nontrans_list,
 			    nontrans_list) {
-		ies2 = rcu_access_pointer(tmp_bss->pub.ies);
+		ies2 = rcu_access_pointer(tmp_bss->ies);
 		if (ies2->tsf < ies1->tsf)
 			cfg80211_update_notlisted_nontrans(wiphy, tmp_bss,
 							   mgmt, len, gfp);
@@ -1770,7 +1763,8 @@ EXPORT_SYMBOL(cfg80211_put_bss);
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
-	struct cfg80211_internal_bss *bss, *nontrans_bss, *tmp;
+	struct cfg80211_internal_bss *bss, *tmp1;
+	struct cfg80211_bss *nontrans_bss, *tmp;
 
 	if (WARN_ON(!pub))
 		return;
@@ -1778,17 +1772,21 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
 
 	spin_lock_bh(&rdev->bss_lock);
-	if (!list_empty(&bss->list)) {
-		list_for_each_entry_safe(nontrans_bss, tmp,
-					 &bss->nontrans_list,
-					 nontrans_list) {
-			if (__cfg80211_unlink_bss(rdev, nontrans_bss))
-				rdev->bss_generation++;
-		}
+	if (list_empty(&bss->list))
+		goto out;
 
-		if (__cfg80211_unlink_bss(rdev, bss))
+	list_for_each_entry_safe(nontrans_bss, tmp,
+				 &pub->nontrans_list,
+				 nontrans_list) {
+		tmp1 = container_of(nontrans_bss,
+				    struct cfg80211_internal_bss, pub);
+		if (__cfg80211_unlink_bss(rdev, tmp1))
 			rdev->bss_generation++;
 	}
+
+	if (__cfg80211_unlink_bss(rdev, bss))
+		rdev->bss_generation++;
+out:
 	spin_unlock_bh(&rdev->bss_lock);
 }
 EXPORT_SYMBOL(cfg80211_unlink_bss);
-- 
2.17.2

