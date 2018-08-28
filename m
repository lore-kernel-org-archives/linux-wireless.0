Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53014 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbeH1QLK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:11:10 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        Peng Xu <pxu@qti.qualcomm.com>
Subject: [RFC 1/6] cfg80211: Implement Multiple BSSID capability in scanning
Date: Tue, 28 Aug 2018 14:13:48 +0200
Message-Id: <20180828121353.11193-2-johannes@sipsolutions.net> (sfid-20180828_141949_905942_29B06C87)
In-Reply-To: <20180828121353.11193-1-johannes@sipsolutions.net>
References: <20180828121353.11193-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peng Xu <pxu@qti.qualcomm.com>

This extends cfg80211 BSS table processing to be able to parse Multiple
BSSID element from Beacon and Probe Response frames and to update the
BSS profiles in internal database for non-transmitted BSSs.

Signed-off-by: Peng Xu <pxu@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 backport-include/linux/etherdevice.h     |  23 ++
 intc-scripts/chromeOS/hdrs/mac80211-bp.h |  23 ++
 net/wireless/core.h                      |   1 +
 net/wireless/scan.c                      | 449 +++++++++++++++++++++++++++++--
 4 files changed, 481 insertions(+), 15 deletions(-)

diff --git a/backport-include/linux/etherdevice.h b/backport-include/linux/etherdevice.h
index 92256e005169..0b96cc16e96e 100644
--- a/backport-include/linux/etherdevice.h
+++ b/backport-include/linux/etherdevice.h
@@ -193,4 +193,27 @@ static inline int eth_skb_pad(struct sk_buff *skb)
 }
 #endif /* LINUX_VERSION_IS_LESS(3,19,0) */
 
+#if LINUX_VERSION_IS_LESS(4,11,0)
+static inline u64 ether_addr_to_u64(const u8 *addr)
+{
+	u64 u = 0;
+	int i;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		u = u << 8 | addr[i];
+
+	return u;
+}
+
+static inline void u64_to_ether_addr(u64 u, u8 *addr)
+{
+	int i;
+
+	for (i = ETH_ALEN - 1; i >= 0; i--) {
+		addr[i] = u & 0xff;
+		u = u >> 8;
+	}
+}
+#endif /* LINUX_VERSION_IS_LESS(4,11,0) */
+
 #endif /* _BACKPORT_LINUX_ETHERDEVICE_H */
diff --git a/intc-scripts/chromeOS/hdrs/mac80211-bp.h b/intc-scripts/chromeOS/hdrs/mac80211-bp.h
index 31f28bd60ae4..99abc01eacee 100644
--- a/intc-scripts/chromeOS/hdrs/mac80211-bp.h
+++ b/intc-scripts/chromeOS/hdrs/mac80211-bp.h
@@ -243,3 +243,26 @@ static inline void timer_setup(struct timer_list *timer,
 #define from_timer(var, callback_timer, timer_fieldname) \
 	container_of(callback_timer, typeof(*var), timer_fieldname)
 #endif
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 11, 0)
+static inline u64 ether_addr_to_u64(const u8 *addr)
+{
+        u64 u = 0;
+        int i;
+
+        for (i = 0; i < ETH_ALEN; i++)
+                u = u << 8 | addr[i];
+
+        return u;
+}
+
+static inline void u64_to_ether_addr(u64 u, u8 *addr)
+{
+        int i;
+
+        for (i = ETH_ALEN - 1; i >= 0; i--) {
+                addr[i] = u & 0xff;
+                u = u >> 8;
+        }
+}
+#endif /* < 4,11,0 */
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 204cd19e9eba..625c59653ed6 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -144,6 +144,7 @@ extern int cfg80211_rdev_list_generation;
 struct cfg80211_internal_bss {
 	struct list_head list;
 	struct list_head hidden_list;
+	struct list_head nontrans_list;
 	struct rb_node rbn;
 	u64 ts_boottime;
 	unsigned long ts;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index c4327520ffed..a1c0f6af1d3c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3,7 +3,7 @@
  *
  * Copyright 2008 Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright 2016	Intel Deutschland GmbH
+ * Copyright 2016-2017	Intel Deutschland GmbH
  */
 #include <linux/kernel.h>
 #include <linux/slab.h>
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
@@ -1086,18 +1088,157 @@ cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
 	return channel;
 }
 
+static void gen_new_bssid(const u8 *bssid, u8 max_bssid, u8 mbssid_index,
+			  u8 *new_bssid_addr)
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
+static size_t gen_new_ie(const u8 *ie, size_t ielen, const u8 *subelement,
+			 size_t subie_len, u8 *new_ie, gfp_t gfp)
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
+static int add_nontrans_list(struct cfg80211_internal_bss *trans_bss,
+			     struct cfg80211_internal_bss *nontrans_bss)
+{
+	const u8 *ssid;
+	size_t ssid_len;
+	struct cfg80211_internal_bss *bss = NULL;
+
+	ssid = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
+	if (!ssid)
+		return -EINVAL;
+	ssid_len = ssid[1];
+	ssid = ssid + 2;
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
 
@@ -1165,18 +1306,245 @@ cfg80211_inform_bss_data(struct wiphy *wiphy,
 			regulatory_hint_found_beacon(wiphy, channel, gfp);
 	}
 
+	if (trans_bss) {
+		/* this is a nontransmitting bss, we need to add it to
+		 * transmitting bss' list if it is not there
+		 */
+		trans_internal = container_of(trans_bss,
+					      struct cfg80211_internal_bss,
+					      pub);
+		if (add_nontrans_list(trans_internal, res)) {
+			if (__cfg80211_unlink_bss(rdev, res))
+				rdev->bss_generation++;
+		}
+	}
+
 	trace_cfg80211_return_bss(&res->pub);
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
+
+static void parse_mbssid_data(struct wiphy *wiphy,
+			      struct cfg80211_inform_bss *data,
+			      enum cfg80211_bss_frame_type ftype,
+			      const u8 *bssid, u64 tsf,
+			      u16 beacon_interval, const u8 *ie, size_t ielen,
+			      struct cfg80211_bss *trans_bss,
+			      gfp_t gfp)
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
+			mbssid_index_ie = cfg80211_find_ie(
+				WLAN_EID_MULTI_BSSID_IDX,
+				subelement + 2, subie_len);
+			if (!mbssid_index_ie || mbssid_index_ie[1] < 1 ||
+			    mbssid_index_ie[2] == 0) {
+				/* No valid Multiple BSSID-Index element */
+				continue;
+			}
+
+			gen_new_bssid(bssid, tmp[2], mbssid_index_ie[2],
+				      new_bssid);
+			memset(new_ie, 0, IEEE80211_MAX_DATA_LEN);
+			new_ie_len = gen_new_ie(ie, ielen, subelement + 2,
+						subie_len, new_ie, gfp);
+			if (!new_ie_len)
+				continue;
+
+			capability = le16_to_cpup((const __le16 *)&subelement[4]);
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
+struct cfg80211_bss *
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
+	parse_mbssid_data(wiphy, data, ftype, bssid, tsf, beacon_interval,
+			  ie, ielen, res, gfp);
+	return res;
+}
 EXPORT_SYMBOL(cfg80211_inform_bss_data);
 
+static void parse_mbssid_frame_data(struct wiphy *wiphy,
+				    struct cfg80211_inform_bss *data,
+				    struct ieee80211_mgmt *mgmt, size_t len,
+				    struct cfg80211_bss *trans_bss,
+				    gfp_t gfp)
+{
+	enum cfg80211_bss_frame_type ftype;
+	const u8 *ie = mgmt->u.probe_resp.variable;
+	size_t ielen = len - offsetof(struct ieee80211_mgmt,
+				      u.probe_resp.variable);
+
+	ftype = ieee80211_is_beacon(mgmt->frame_control) ?
+		CFG80211_BSS_FTYPE_BEACON : CFG80211_BSS_FTYPE_PRESP;
+
+	parse_mbssid_data(wiphy, data, ftype, mgmt->bssid,
+			  le64_to_cpu(mgmt->u.probe_resp.timestamp),
+			  le16_to_cpu(mgmt->u.probe_resp.beacon_int),
+			  ie, ielen, trans_bss, gfp);
+}
+
+static void update_notlisted_nontrans(struct wiphy *wiphy,
+				      struct cfg80211_internal_bss
+				      *nontrans_bss,
+				      struct ieee80211_mgmt *mgmt, size_t len,
+				      gfp_t gfp)
+
+{
+	u8 *ie, *new_ie, *pos;
+	const u8 *tmp, *tmp1;
+	size_t ielen = len - offsetof(struct ieee80211_mgmt,
+				      u.probe_resp.variable);
+	size_t new_ie_len;
+	struct cfg80211_bss_ies *new_ies;
+	const struct cfg80211_bss_ies *old;
+
+	ie =  mgmt->u.probe_resp.variable;
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
 /* cfg80211_inform_bss_width_frame helper */
-struct cfg80211_bss *
-cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
-			       struct cfg80211_inform_bss *data,
-			       struct ieee80211_mgmt *mgmt, size_t len,
-			       gfp_t gfp)
+static struct cfg80211_bss *
+cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
+				      struct cfg80211_inform_bss *data,
+				      struct ieee80211_mgmt *mgmt, size_t len,
+				      struct cfg80211_bss *trans_bss,
+				      gfp_t gfp)
 
 {
 	struct cfg80211_internal_bss tmp = {}, *res;
@@ -1254,6 +1622,50 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
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
+	if (!cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
+		return res;
+
+	/* process each non-transmitting bss */
+	parse_mbssid_frame_data(wiphy, data, mgmt, len, res, gfp);
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
+			update_notlisted_nontrans(wiphy, tmp_bss, mgmt,
+						  len, gfp);
+	}
+
+	return res;
+}
 EXPORT_SYMBOL(cfg80211_inform_bss_frame_data);
 
 void cfg80211_ref_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
@@ -1291,7 +1703,7 @@ EXPORT_SYMBOL(cfg80211_put_bss);
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
-	struct cfg80211_internal_bss *bss;
+	struct cfg80211_internal_bss *bss, *nontrans_bss, *tmp;
 
 	if (WARN_ON(!pub))
 		return;
@@ -1300,6 +1712,13 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 
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
2.14.4
