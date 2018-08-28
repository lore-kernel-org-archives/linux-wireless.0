Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53020 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbeH1QLS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:11:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        Peng Xu <pxu@qti.qualcomm.com>,
        Sara Sharon <sara.sharon@intel.com>
Subject: [RFC 5/6] cfg80211: move the multiple BSSID data to the visible part
Date: Tue, 28 Aug 2018 14:13:52 +0200
Message-Id: <20180828121353.11193-6-johannes@sipsolutions.net> (sfid-20180828_141957_216853_1382F9DA)
In-Reply-To: <20180828121353.11193-1-johannes@sipsolutions.net>
References: <20180828121353.11193-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Mac80211 needs this info.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  2 ++
 net/wireless/core.h    | 10 +++----
 net/wireless/scan.c    | 80 ++++++++++++++++++++++++--------------------------
 3 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 45ea649fe88c..40b9ce8b3301 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1935,6 +1935,8 @@ struct cfg80211_bss {
 	const struct cfg80211_bss_ies __rcu *proberesp_ies;
 
 	struct cfg80211_bss *hidden_beacon_bss;
+	struct cfg80211_bss *transmitted_bss;
+	struct list_head nontrans_list;
 
 	s32 signal;
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index f9f0b9cdac6c..05e552c65f9c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -144,8 +144,6 @@ extern int cfg80211_rdev_list_generation;
 struct cfg80211_internal_bss {
 	struct list_head list;
 	struct list_head hidden_list;
-	struct list_head nontrans_list;
-	struct cfg80211_bss *transmitted_bss;
 	struct rb_node rbn;
 	u64 ts_boottime;
 	unsigned long ts;
@@ -176,8 +174,8 @@ static inline struct cfg80211_internal_bss *bss_from_pub(struct cfg80211_bss *pu
 static inline void cfg80211_hold_bss(struct cfg80211_internal_bss *bss)
 {
 	atomic_inc(&bss->hold);
-	if (bss->transmitted_bss)
-		cfg80211_hold_bss(container_of(bss->transmitted_bss,
+	if (bss->pub.transmitted_bss)
+		cfg80211_hold_bss(container_of(bss->pub.transmitted_bss,
 					       struct cfg80211_internal_bss,
 					       pub));
 }
@@ -186,8 +184,8 @@ static inline void cfg80211_unhold_bss(struct cfg80211_internal_bss *bss)
 {
 	int r = atomic_dec_return(&bss->hold);
 	WARN_ON(r < 0);
-	if (bss->transmitted_bss)
-		cfg80211_unhold_bss(container_of(bss->transmitted_bss,
+	if (bss->pub.transmitted_bss)
+		cfg80211_unhold_bss(container_of(bss->pub.transmitted_bss,
 						 struct cfg80211_internal_bss,
 						 pub));
 }
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 87526940178b..543551e3c44a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -108,8 +108,8 @@ static inline void bss_ref_get(struct cfg80211_registered_device *rdev,
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
@@ -131,10 +131,10 @@ static inline void bss_ref_put(struct cfg80211_registered_device *rdev,
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
@@ -167,7 +167,7 @@ static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *rdev,
 	}
 
 	list_del_init(&bss->list);
-	list_del_init(&bss->nontrans_list);
+	list_del_init(&bss->pub.nontrans_list);
 	rb_erase(&bss->rbn, &rdev->bss_tree);
 	rdev->bss_entries--;
 	WARN_ONCE((rdev->bss_entries == 0) ^ list_empty(&rdev->bss_list),
@@ -1025,7 +1025,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		memcpy(new, tmp, sizeof(*new));
 		new->refcount = 1;
 		INIT_LIST_HEAD(&new->hidden_list);
-		INIT_LIST_HEAD(&new->nontrans_list);
+		INIT_LIST_HEAD(&new->pub.nontrans_list);
 
 		if (rcu_access_pointer(tmp->pub.proberesp_ies)) {
 			hidden = rb_find_bss(rdev, tmp, BSS_CMP_HIDE_ZLEN);
@@ -1066,7 +1066,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 					     struct cfg80211_internal_bss,
 					     pub);
 
-			new->transmitted_bss = trans_bss;
+			new->pub.transmitted_bss = trans_bss;
 			bss_ref_get(rdev, pbss);
 		}
 
@@ -1233,14 +1233,14 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
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
 
-	ssid = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
+	ssid = ieee80211_bss_get_ie(nontrans_bss, WLAN_EID_SSID);
 	if (!ssid)
 		return -EINVAL;
 	ssid_len = ssid[1];
@@ -1248,7 +1248,7 @@ cfg80211_add_nontrans_list(struct cfg80211_internal_bss *trans_bss,
 
 	/* check if nontrans_bss is in the list */
 	list_for_each_entry(bss, &trans_bss->nontrans_list, nontrans_list) {
-		if (is_bss(&bss->pub, nontrans_bss->pub.bssid, ssid, ssid_len))
+		if (is_bss(bss, nontrans_bss->bssid, ssid, ssid_len))
 			return 0;
 	}
 
@@ -1270,7 +1270,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_bss_ies *ies;
 	struct ieee80211_channel *channel;
-	struct cfg80211_internal_bss tmp = {}, *res, *trans_internal;
+	struct cfg80211_internal_bss tmp = {}, *res;
 	int bss_type;
 	bool signal_valid;
 
@@ -1343,10 +1343,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
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
@@ -1497,7 +1494,7 @@ cfg80211_parse_mbssid_frame_data(struct wiphy *wiphy,
 
 static void
 cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
-				   struct cfg80211_internal_bss *nontrans_bss,
+				   struct cfg80211_bss *nontrans_bss,
 				   struct ieee80211_mgmt *mgmt, size_t len,
 				   gfp_t gfp)
 
@@ -1522,7 +1519,7 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 	if (!mbssid)
 		return;
 	new_ie_len -= mbssid[1];
-	nontrans_ssid = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
+	nontrans_ssid = ieee80211_bss_get_ie(nontrans_bss, WLAN_EID_SSID);
 	if (!nontrans_ssid)
 		return;
 	new_ie_len += nontrans_ssid[1];
@@ -1560,15 +1557,15 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
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
@@ -1666,8 +1663,7 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 			       struct ieee80211_mgmt *mgmt, size_t len,
 			       gfp_t gfp)
 {
-	struct cfg80211_bss *res;
-	struct cfg80211_internal_bss *trans_bss, *tmp_bss;
+	struct cfg80211_bss *res, *tmp_bss;
 	const u8 *ie = mgmt->u.probe_resp.variable;
 	const struct cfg80211_bss_ies *ies1, *ies2;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
@@ -1685,17 +1681,14 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
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
@@ -1740,7 +1733,8 @@ EXPORT_SYMBOL(cfg80211_put_bss);
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
-	struct cfg80211_internal_bss *bss, *nontrans_bss, *tmp;
+	struct cfg80211_internal_bss *bss, *tmp1;
+	struct cfg80211_bss *nontrans_bss, *tmp;
 
 	if (WARN_ON(!pub))
 		return;
@@ -1748,17 +1742,21 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
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
2.14.4
