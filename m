Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64608 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab1G2AiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 20:38:01 -0400
Received: by pzk37 with SMTP id 37so5389578pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 17:38:01 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2] mac80211: update mesh path selection frame format
Date: Thu, 28 Jul 2011 17:37:15 -0700
Message-Id: <1311899835-32080-1-git-send-email-thomas@cozybit.com> (sfid-20110729_023806_438532_849E4212)
In-Reply-To: <1311638357-28740-1-git-send-email-thomas@cozybit.com>
References: <1311638357-28740-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make mesh path selection frames Mesh Action category, remove outdated
Mesh Path Selection category and defines, use updated reason codes, add
mesh_action_is_path_sel macro for readability, and update/correct path
selection IEs.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

Previous version of this patch broke RANN IEs, fix this and perform other misc.
cleanups.

 include/linux/ieee80211.h   |    4 +--
 net/mac80211/mesh.c         |    9 ++----
 net/mac80211/mesh.h         |   19 ++++++++------
 net/mac80211/mesh_hwmp.c    |   59 +++++++++++++++++++++++++-----------------
 net/mac80211/mesh_pathtbl.c |    8 +++---
 net/mac80211/rx.c           |    5 +--
 6 files changed, 56 insertions(+), 48 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 311df71..db6c359 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -629,6 +629,7 @@ struct ieee80211_rann_ie {
 	u8 rann_ttl;
 	u8 rann_addr[6];
 	u32 rann_seq;
+	u32 rann_interval;
 	u32 rann_metric;
 } __attribute__ ((packed));
 
@@ -1267,9 +1268,6 @@ enum ieee80211_category {
 	WLAN_CATEGORY_MULTIHOP_ACTION = 14,
 	WLAN_CATEGORY_SELF_PROTECTED = 15,
 	WLAN_CATEGORY_WMM = 17,
-	/* TODO: remove MESH_PATH_SEL after mesh is updated
-	 * to current 802.11s draft  */
-	WLAN_CATEGORY_MESH_PATH_SEL = 32,
 	WLAN_CATEGORY_VENDOR_SPECIFIC_PROTECTED = 126,
 	WLAN_CATEGORY_VENDOR_SPECIFIC = 127,
 };
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a1bd372..7f3d43a 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -13,10 +13,6 @@
 #include "ieee80211_i.h"
 #include "mesh.h"
 
-#define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
-#define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
-#define IEEE80211_MESH_RANN_INTERVAL	     (1 * HZ)
-
 #define MESHCONF_CAPAB_ACCEPT_PLINKS 0x01
 #define MESHCONF_CAPAB_FORWARDING    0x08
 
@@ -671,8 +667,9 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
 			break;
 		}
 		break;
-	case WLAN_CATEGORY_MESH_PATH_SEL:
-		mesh_rx_path_sel_frame(sdata, mgmt, len);
+	case WLAN_CATEGORY_MESH_ACTION:
+		if (mesh_action_is_path_sel(mgmt))
+			mesh_rx_path_sel_frame(sdata, mgmt, len);
 		break;
 	}
 }
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 4c9113e..133d140 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -166,6 +166,9 @@ struct mesh_rmc {
 	u32 idx_mask;
 };
 
+#define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
+#define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
+#define IEEE80211_MESH_RANN_INTERVAL	     (1 * HZ)
 
 #define MESH_DEFAULT_BEACON_INTERVAL		1000 	/* in 1024 us units */
 
@@ -177,14 +180,6 @@ struct mesh_rmc {
 /* Maximum number of paths per interface */
 #define MESH_MAX_MPATHS		1024
 
-/* Pending ANA approval */
-#define MESH_PATH_SEL_ACTION	0
-
-/* PERR reason codes */
-#define PEER_RCODE_UNSPECIFIED  11
-#define PERR_RCODE_NO_ROUTE     12
-#define PERR_RCODE_DEST_UNREACH 13
-
 /* Public interfaces */
 /* Various */
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
@@ -303,6 +298,12 @@ static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 	return sdata->u.mesh.mesh_pp_id == IEEE80211_PATH_PROTOCOL_HWMP;
 }
 
+static inline bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt)
+{
+	return (mgmt->u.action.u.mesh_action.action_code ==
+			WLAN_MESH_ACTION_HWMP_PATH_SELECTION);
+}
+
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
 
 void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata);
@@ -321,6 +322,8 @@ static inline void mesh_plink_quiesce(struct sta_info *sta) {}
 static inline void mesh_plink_restart(struct sta_info *sta) {}
 static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 { return false; }
+static inline bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt)
+{ return false; }
 #endif
 
 #endif /* IEEE80211S_H */
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 2b18053..2d3eb2f 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -68,12 +68,12 @@ static inline u32 u16_field_get(u8 *preq_elem, int offset, bool ae)
 #define PREP_IE_FLAGS(x)	PREQ_IE_FLAGS(x)
 #define PREP_IE_HOPCOUNT(x)	PREQ_IE_HOPCOUNT(x)
 #define PREP_IE_TTL(x)		PREQ_IE_TTL(x)
-#define PREP_IE_ORIG_ADDR(x)	(x + 3)
-#define PREP_IE_ORIG_SN(x)	u32_field_get(x, 9, 0);
+#define PREP_IE_ORIG_ADDR(x)	(AE_F_SET(x) ? x + 27 : x + 21)
+#define PREP_IE_ORIG_SN(x)	u32_field_get(x, 27, AE_F_SET(x));
 #define PREP_IE_LIFETIME(x)	u32_field_get(x, 13, AE_F_SET(x));
 #define PREP_IE_METRIC(x)	u32_field_get(x, 17, AE_F_SET(x));
-#define PREP_IE_TARGET_ADDR(x)	(AE_F_SET(x) ? x + 27 : x + 21)
-#define PREP_IE_TARGET_SN(x)	u32_field_get(x, 27, AE_F_SET(x));
+#define PREP_IE_TARGET_ADDR(x)	(x + 3)
+#define PREP_IE_TARGET_SN(x)	u32_field_get(x, 9, 0);
 
 #define PERR_IE_TTL(x)		(*(x))
 #define PERR_IE_TARGET_FLAGS(x)	(*(x + 2))
@@ -132,8 +132,8 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	/* BSSID == SA */
 	memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
-	mgmt->u.action.category = WLAN_CATEGORY_MESH_PATH_SEL;
-	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
+	mgmt->u.action.category = WLAN_CATEGORY_MESH_ACTION;
+	mgmt->u.action.u.mesh_action.action_code = WLAN_MESH_ACTION_HWMP_PATH_SELECTION;
 
 	switch (action) {
 	case MPATH_PREQ:
@@ -163,29 +163,37 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	*pos++ = flags;
 	*pos++ = hop_count;
 	*pos++ = ttl;
-	if (action == MPATH_PREQ) {
-		memcpy(pos, &preq_id, 4);
+	if (action == MPATH_PREP) {
+		memcpy(pos, target, ETH_ALEN);
+		pos += ETH_ALEN;
+		memcpy(pos, &target_sn, 4);
 		pos += 4;
-	}
-	memcpy(pos, orig_addr, ETH_ALEN);
-	pos += ETH_ALEN;
-	memcpy(pos, &orig_sn, 4);
-	pos += 4;
-	if (action != MPATH_RANN) {
-		memcpy(pos, &lifetime, 4);
+	} else {
+		if (action == MPATH_PREQ) {
+			memcpy(pos, &preq_id, 4);
+			pos += 4;
+		}
+		memcpy(pos, orig_addr, ETH_ALEN);
+		pos += ETH_ALEN;
+		memcpy(pos, &orig_sn, 4);
 		pos += 4;
 	}
+	memcpy(pos, &lifetime, 4);	/* interval for RANN */
+	pos += 4;
 	memcpy(pos, &metric, 4);
 	pos += 4;
 	if (action == MPATH_PREQ) {
-		/* destination count */
-		*pos++ = 1;
+		*pos++ = 1; /* destination count */
 		*pos++ = target_flags;
-	}
-	if (action != MPATH_RANN) {
 		memcpy(pos, target, ETH_ALEN);
 		pos += ETH_ALEN;
 		memcpy(pos, &target_sn, 4);
+		pos += 4;
+	} else if (action == MPATH_PREP) {
+		memcpy(pos, orig_addr, ETH_ALEN);
+		pos += ETH_ALEN;
+		memcpy(pos, &orig_sn, 4);
+		pos += 4;
 	}
 
 	ieee80211_tx_skb(sdata, skb);
@@ -224,9 +232,10 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 
 	memcpy(mgmt->da, ra, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
-	/* BSSID is left zeroed, wildcard value */
-	mgmt->u.action.category = WLAN_CATEGORY_MESH_PATH_SEL;
-	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
+	/* BSSID == SA */
+	memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
+	mgmt->u.action.category = WLAN_CATEGORY_MESH_ACTION;
+	mgmt->u.action.u.mesh_action.action_code = WLAN_MESH_ACTION_HWMP_PATH_SELECTION;
 	ie_len = 15;
 	pos = skb_put(skb, 2 + ie_len);
 	*pos++ = WLAN_EID_PERR;
@@ -684,6 +693,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	u8 ttl, flags, hopcount;
 	u8 *orig_addr;
 	u32 orig_sn, metric;
+	u32 interval = cpu_to_le32(IEEE80211_MESH_RANN_INTERVAL);
 
 	ttl = rann->rann_ttl;
 	if (ttl <= 1) {
@@ -716,7 +726,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
 				       cpu_to_le32(orig_sn),
 				       0, NULL, 0, broadcast_addr,
-				       hopcount, ttl, 0,
+				       hopcount, ttl, interval,
 				       cpu_to_le32(metric + mpath->metric),
 				       0, sdata);
 		mpath->sn = orig_sn;
@@ -1007,10 +1017,11 @@ void
 mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u32 interval = cpu_to_le32(IEEE80211_MESH_RANN_INTERVAL);
 
 	mesh_path_sel_frame_tx(MPATH_RANN, 0, sdata->vif.addr,
 			       cpu_to_le32(++ifmsh->sn),
 			       0, NULL, 0, broadcast_addr,
 			       0, sdata->u.mesh.mshcfg.element_ttl,
-			       0, 0, 0, sdata);
+			       interval, 0, 0, sdata);
 }
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 068ee65..3ef6ad4 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -539,6 +539,7 @@ void mesh_plink_broken(struct sta_info *sta)
 	struct hlist_node *p;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	int i;
+	u16 reason = cpu_to_le16(WLAN_REASON_MESH_PATH_DEST_UNREACHABLE);
 
 	rcu_read_lock();
 	tbl = rcu_dereference(mesh_paths);
@@ -553,8 +554,7 @@ void mesh_plink_broken(struct sta_info *sta)
 			spin_unlock_bh(&mpath->state_lock);
 			mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl,
 					mpath->dst, cpu_to_le32(mpath->sn),
-					cpu_to_le16(PERR_RCODE_DEST_UNREACH),
-					bcast, sdata);
+					reason, bcast, sdata);
 		} else
 		spin_unlock_bh(&mpath->state_lock);
 	}
@@ -699,6 +699,7 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct mesh_path *mpath;
 	u32 sn = 0;
+	u16 reason = cpu_to_le16(WLAN_REASON_MESH_PATH_NOFORWARD);
 
 	if (memcmp(hdr->addr4, sdata->vif.addr, ETH_ALEN) != 0) {
 		u8 *ra, *da;
@@ -709,8 +710,7 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 		if (mpath)
 			sn = ++mpath->sn;
 		mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl, skb->data,
-				   cpu_to_le32(sn),
-				   cpu_to_le16(PERR_RCODE_NO_ROUTE), ra, sdata);
+				   cpu_to_le32(sn), reason, ra, sdata);
 	}
 
 	kfree_skb(skb);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3fb6dea..c4453fd 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2241,9 +2241,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	case WLAN_CATEGORY_MESH_ACTION:
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
-		goto queue;
-	case WLAN_CATEGORY_MESH_PATH_SEL:
-		if (!mesh_path_sel_is_hwmp(sdata))
+		if (mesh_action_is_path_sel(mgmt) &&
+		  (!mesh_path_sel_is_hwmp(sdata)))
 			break;
 		goto queue;
 	}
-- 
1.7.6

