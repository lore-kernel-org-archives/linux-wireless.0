Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47150 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbZKIXr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:27 -0500
Received: by mail-ew0-f228.google.com with SMTP id 28so3974559ewy.18
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:33 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2 12/20] mac80211: update PERR frame format
Date: Mon,  9 Nov 2009 23:46:50 +0000
Message-Id: <1257810418-30075-13-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the PERR IE frame format according to latest draft (3.03).

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh.h         |    9 +++++-
 net/mac80211/mesh_hwmp.c    |   58 ++++++++++++++++++++++++++++++++++++------
 net/mac80211/mesh_pathtbl.c |    6 +++-
 3 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 2fd3e20..1d534c7 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -210,6 +210,11 @@ struct mesh_rmc {
 #define MESH_PATH_SEL_CATEGORY	32
 #define MESH_PATH_SEL_ACTION	0
 
+/* PERR reason codes */
+#define PEER_RCODE_UNSPECIFIED  11
+#define PERR_RCODE_NO_ROUTE     12
+#define PERR_RCODE_DEST_UNREACH 13
+
 /* Public interfaces */
 /* Various */
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
@@ -275,8 +280,8 @@ void mesh_mpp_table_grow(void);
 u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata,
 		struct mesh_table *tbl);
 /* Mesh paths */
-int mesh_path_error_tx(u8 *dest, __le32 dest_dsn, u8 *ra,
-		struct ieee80211_sub_if_data *sdata);
+int mesh_path_error_tx(u8 ttl, u8 *dest, __le32 dest_dsn, __le16 dest_rcode,
+		u8 *ra, struct ieee80211_sub_if_data *sdata);
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 555bd5a..c12cf5a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -27,6 +27,10 @@
 #define MP_F_DO	0x1
 /* Reply and forward */
 #define MP_F_RF	0x2
+/* Unknown Sequence Number */
+#define MP_F_USN    0x01
+/* Reason code Present */
+#define MP_F_RCODE  0x02
 
 static void mesh_queue_preq(struct mesh_path *, u8);
 
@@ -37,6 +41,13 @@ static inline u32 u32_field_get(u8 *preq_elem, int offset, bool ae)
 	return get_unaligned_le32(preq_elem + offset);
 }
 
+static inline u32 u16_field_get(u8 *preq_elem, int offset, bool ae)
+{
+	if (ae)
+		offset += 6;
+	return get_unaligned_le16(preq_elem + offset);
+}
+
 /* HWMP IE processing macros */
 #define AE_F			(1<<6)
 #define AE_F_SET(x)		(*x & AE_F)
@@ -63,8 +74,11 @@ static inline u32 u32_field_get(u8 *preq_elem, int offset, bool ae)
 #define PREP_IE_DST_ADDR(x)	(AE_F_SET(x) ? x + 27 : x + 21)
 #define PREP_IE_DST_DSN(x)	u32_field_get(x, 27, AE_F_SET(x));
 
-#define PERR_IE_DST_ADDR(x)	(x + 2)
-#define PERR_IE_DST_DSN(x)	u32_field_get(x, 8, 0);
+#define PERR_IE_TTL(x)		(*(x))
+#define PERR_IE_DST_FLAGS(x)	(*(x + 2))
+#define PERR_IE_DST_ADDR(x)	(x + 3)
+#define PERR_IE_DST_DSN(x)	u32_field_get(x, 9, 0);
+#define PERR_IE_DST_RCODE(x)	u16_field_get(x, 13, 0);
 
 #define MSEC_TO_TU(x) (x*1000/1024)
 #define DSN_GT(x, y) ((long) (y) - (long) (x) < 0)
@@ -181,8 +195,8 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
  * @dst_dsn: dsn of the broken destination
  * @ra: node this frame is addressed to
  */
-int mesh_path_error_tx(u8 *dst, __le32 dst_dsn, u8 *ra,
-		struct ieee80211_sub_if_data *sdata)
+int mesh_path_error_tx(u8 ttl, u8 *dst, __le32 dst_dsn, __le16 dst_rcode,
+		u8 *ra, struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
@@ -207,17 +221,29 @@ int mesh_path_error_tx(u8 *dst, __le32 dst_dsn, u8 *ra,
 	/* BSSID is left zeroed, wildcard value */
 	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
 	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
-	ie_len = 12;
+	ie_len = 15;
 	pos = skb_put(skb, 2 + ie_len);
 	*pos++ = WLAN_EID_PERR;
 	*pos++ = ie_len;
-	/* mode flags, reserved */
-	*pos++ = 0;
+	/* ttl */
+	*pos++ = MESH_TTL;
 	/* number of destinations */
 	*pos++ = 1;
+	/*
+	 * flags bit, bit 1 is unset if we know the sequence number and
+	 * bit 2 is set if we have a reason code
+	 */
+	*pos = 0;
+	if (!dst_dsn)
+		*pos |= MP_F_USN;
+	if (dst_rcode)
+		*pos |= MP_F_RCODE;
+	pos++;
 	memcpy(pos, dst, ETH_ALEN);
 	pos += ETH_ALEN;
 	memcpy(pos, &dst_dsn, 4);
+	pos += 4;
+	memcpy(pos, &dst_rcode, 2);
 
 	ieee80211_tx_skb(sdata, skb, 1);
 	return 0;
@@ -598,13 +624,26 @@ fail:
 static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_mgmt *mgmt, u8 *perr_elem)
 {
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
+	u8 ttl;
 	u8 *ta, *dst_addr;
+	u8 dst_flags;
 	u32 dst_dsn;
+	u16 dst_rcode;
 
 	ta = mgmt->sa;
+	ttl = PERR_IE_TTL(perr_elem);
+	if (ttl <= 1) {
+		ifmsh->mshstats.dropped_frames_ttl++;
+		return;
+	}
+	ttl--;
+	dst_flags = PERR_IE_DST_FLAGS(perr_elem);
 	dst_addr = PERR_IE_DST_ADDR(perr_elem);
 	dst_dsn = PERR_IE_DST_DSN(perr_elem);
+	dst_rcode = PERR_IE_DST_RCODE(perr_elem);
+
 	rcu_read_lock();
 	mpath = mesh_path_lookup(dst_addr, sdata);
 	if (mpath) {
@@ -616,7 +655,8 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			mpath->dsn = dst_dsn;
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_error_tx(dst_addr, cpu_to_le32(dst_dsn),
+			mesh_path_error_tx(ttl, dst_addr, cpu_to_le32(dst_dsn),
+					   cpu_to_le16(dst_rcode),
 					   sdata->dev->broadcast, sdata);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
@@ -711,7 +751,7 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 						last_hop_metric);
 	}
 	if (elems.perr) {
-		if (elems.perr_len != 12)
+		if (elems.perr_len != 15)
 			/* Right now we support only one destination per PERR */
 			return;
 		hwmp_perr_frame_process(sdata, mgmt, elems.perr);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 751c4d0..5d54123 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -465,8 +465,9 @@ void mesh_plink_broken(struct sta_info *sta)
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			++mpath->dsn;
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_error_tx(mpath->dst,
+			mesh_path_error_tx(MESH_TTL, mpath->dst,
 					cpu_to_le32(mpath->dsn),
+					PERR_RCODE_DEST_UNREACH,
 					sdata->dev->broadcast, sdata);
 		} else
 		spin_unlock_bh(&mpath->state_lock);
@@ -611,7 +612,8 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 		mpath = mesh_path_lookup(da, sdata);
 		if (mpath)
 			dsn = ++mpath->dsn;
-		mesh_path_error_tx(skb->data, cpu_to_le32(dsn), ra, sdata);
+		mesh_path_error_tx(MESH_TTL, skb->data, cpu_to_le32(dsn),
+				   PERR_RCODE_NO_ROUTE, ra, sdata);
 	}
 
 	kfree_skb(skb);
-- 
1.5.6.5

