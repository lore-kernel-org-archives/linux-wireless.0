Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60533 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1JTSaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 14:30:14 -0400
Received: by pzk36 with SMTP id 36so7654640pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 11:30:13 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 1/2] mac80211: comment allocation of mesh frames
Date: Thu, 20 Oct 2011 11:30:06 -0700
Message-Id: <1319135408-6370-1-git-send-email-thomas@cozybit.com> (sfid-20111020_203021_875777_356CD2CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove most references to magic numbers, save a few bytes and hopefully
improve readability.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_hwmp.c  |   36 ++++++++++++++++++------------------
 net/mac80211/mesh_plink.c |   28 +++++++++++++++++-----------
 net/mac80211/tx.c         |   19 +++++++++++++------
 3 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 174040a..9a1f8bb 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -113,20 +113,20 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
+	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	u8 *pos;
-	int ie_len;
+	u8 *pos, ie_len;
+	int hdr_len = offsetof(struct ieee80211_mgmt, u.action.u.mesh_action) +
+		      sizeof(mgmt->u.action.u.mesh_action);
 
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    hdr_len +
+			    2 + 37); /* max HWMP IE */
 	if (!skb)
 		return -1;
 	skb_reserve(skb, local->hw.extra_tx_headroom);
-	/* 25 is the size of the common mgmt part (24) plus the size of the
-	 * common action part (1)
-	 */
-	mgmt = (struct ieee80211_mgmt *)
-		skb_put(skb, 25 + sizeof(mgmt->u.action.u.mesh_action));
-	memset(mgmt, 0, 25 + sizeof(mgmt->u.action.u.mesh_action));
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
+	memset(mgmt, 0, hdr_len);
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
 
@@ -240,20 +240,20 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 		       struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
+	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	u8 *pos;
-	int ie_len;
+	u8 *pos, ie_len;
+	int hdr_len = offsetof(struct ieee80211_mgmt, u.action.u.mesh_action) +
+		      sizeof(mgmt->u.action.u.mesh_action);
 
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    hdr_len +
+			    2 + 15 /* PERR IE */);
 	if (!skb)
 		return -1;
 	skb_reserve(skb, local->tx_headroom + local->hw.extra_tx_headroom);
-	/* 25 is the size of the common mgmt part (24) plus the size of the
-	 * common action part (1)
-	 */
-	mgmt = (struct ieee80211_mgmt *)
-		skb_put(skb, 25 + sizeof(mgmt->u.action.u.mesh_action));
-	memset(mgmt, 0, 25 + sizeof(mgmt->u.action.u.mesh_action));
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
+	memset(mgmt, 0, hdr_len);
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
 
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 7e57f5d..351e48c 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -153,23 +153,29 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		enum ieee80211_self_protected_actioncode action,
 		u8 *da, __le16 llid, __le16 plid, __le16 reason) {
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400 +
-			sdata->u.mesh.ie_len);
+	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	bool include_plid = false;
-	int ie_len = 4;
 	u16 peering_proto = 0;
-	u8 *pos;
-
+	u8 *pos, ie_len = 4;
+	int hdr_len = offsetof(struct ieee80211_mgmt, u.action.u.self_prot) +
+		      sizeof(mgmt->u.action.u.self_prot);
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    hdr_len +
+			    2 + /* capability info */
+			    2 + /* AID */
+			    2 + 8 + /* supported rates */
+			    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
+			    2 + sdata->u.mesh.mesh_id_len +
+			    2 + sizeof(struct ieee80211_meshconf_ie) +
+			    2 + 8 + /* peering IE */
+			    sdata->u.mesh.ie_len);
 	if (!skb)
 		return -1;
 	skb_reserve(skb, local->hw.extra_tx_headroom);
-	/* 25 is the size of the common mgmt part (24) plus the size of the
-	 * common action part (1)
-	 */
-	mgmt = (struct ieee80211_mgmt *)
-		skb_put(skb, 25 + sizeof(mgmt->u.action.u.self_prot));
-	memset(mgmt, 0, 25 + sizeof(mgmt->u.action.u.self_prot));
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
+	memset(mgmt, 0, hdr_len);
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
 	memcpy(mgmt->da, da, ETH_ALEN);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 48bbb96..f4dd339 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2278,22 +2278,29 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		struct ieee80211_mgmt *mgmt;
 		u8 *pos;
+		int hdr_len = offsetof(struct ieee80211_mgmt, u.beacon) +
+			      sizeof(mgmt->u.beacon);
 
 #ifdef CONFIG_MAC80211_MESH
 		if (!sdata->u.mesh.mesh_id_len)
 			goto out;
 #endif
 
-		/* headroom, head length, tail length and maximum TIM length */
-		skb = dev_alloc_skb(local->tx_headroom + 400 +
-				sdata->u.mesh.ie_len);
+		skb = dev_alloc_skb(local->tx_headroom +
+				    hdr_len +
+				    2 + /* NULL SSID */
+				    2 + 8 + /* supported rates */
+				    2 + 3 + /* DS params */
+				    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
+				    2 + sdata->u.mesh.mesh_id_len +
+				    2 + sizeof(struct ieee80211_meshconf_ie) +
+				    sdata->u.mesh.ie_len);
 		if (!skb)
 			goto out;
 
 		skb_reserve(skb, local->hw.extra_tx_headroom);
-		mgmt = (struct ieee80211_mgmt *)
-			skb_put(skb, 24 + sizeof(mgmt->u.beacon));
-		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
+		mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
+		memset(mgmt, 0, hdr_len);
 		mgmt->frame_control =
 		    cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
 		memset(mgmt->da, 0xff, ETH_ALEN);
-- 
1.7.5.4

