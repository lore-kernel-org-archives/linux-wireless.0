Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55924 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1GZAAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 20:00:14 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so9320498pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 17:00:14 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 6/6] mac80211: update mesh path selection frame format
Date: Mon, 25 Jul 2011 16:59:17 -0700
Message-Id: <1311638357-28740-7-git-send-email-thomas@cozybit.com> (sfid-20110726_020020_546456_02B2F4FE)
In-Reply-To: <1311638357-28740-1-git-send-email-thomas@cozybit.com>
References: <1311638357-28740-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make mesh path selection frames Mesh Action category, remove outdated
Mesh Path Selection category, and update/correct IEs.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/ieee80211.h |    3 ---
 net/mac80211/mesh.c       |    6 ++++--
 net/mac80211/mesh_hwmp.c  |   43 ++++++++++++++++++++++++++-----------------
 net/mac80211/rx.c         |    2 --
 4 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 08b1093..f43d6b0 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1267,9 +1267,6 @@ enum ieee80211_category {
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
index a1bd372..34bb99d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -671,8 +671,10 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
 			break;
 		}
 		break;
-	case WLAN_CATEGORY_MESH_PATH_SEL:
-		mesh_rx_path_sel_frame(sdata, mgmt, len);
+	case WLAN_CATEGORY_MESH_ACTION:
+		if (mgmt->u.action.u.mesh_action.action_code ==
+		    WLAN_MESH_ACTION_HWMP_PATH_SELECTION)
+			mesh_rx_path_sel_frame(sdata, mgmt, len);
 		break;
 	}
 }
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 2b18053..b9be6e9 100644
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
@@ -166,11 +166,16 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	if (action == MPATH_PREQ) {
 		memcpy(pos, &preq_id, 4);
 		pos += 4;
+		memcpy(pos, orig_addr, ETH_ALEN);
+		pos += ETH_ALEN;
+		memcpy(pos, &orig_sn, 4);
+		pos += 4;
+	} else if (action == MPATH_PREP) {
+		memcpy(pos, target, ETH_ALEN);
+		pos += ETH_ALEN;
+		memcpy(pos, &target_sn, 4);
+		pos += 4;
 	}
-	memcpy(pos, orig_addr, ETH_ALEN);
-	pos += ETH_ALEN;
-	memcpy(pos, &orig_sn, 4);
-	pos += 4;
 	if (action != MPATH_RANN) {
 		memcpy(pos, &lifetime, 4);
 		pos += 4;
@@ -178,14 +183,17 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
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
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3fb6dea..46aa303 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2241,8 +2241,6 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	case WLAN_CATEGORY_MESH_ACTION:
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
-		goto queue;
-	case WLAN_CATEGORY_MESH_PATH_SEL:
 		if (!mesh_path_sel_is_hwmp(sdata))
 			break;
 		goto queue;
-- 
1.7.6

