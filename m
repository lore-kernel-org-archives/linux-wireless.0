Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:33509 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbZKIXrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:39 -0500
Received: by ewy3 with SMTP id 3so3717779ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:44 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2 17/20] mac80211: replace "destination" with "target" to follow the spec
Date: Mon,  9 Nov 2009 23:46:55 +0000
Message-Id: <1257810418-30075-18-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resulting object files have the same MD5 as before.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 include/linux/nl80211.h     |    8 +-
 include/net/cfg80211.h      |    8 +-
 net/mac80211/cfg.c          |    8 +-
 net/mac80211/ieee80211_i.h  |   10 +-
 net/mac80211/mesh.c         |    2 +-
 net/mac80211/mesh.h         |   10 +-
 net/mac80211/mesh_hwmp.c    |  221 ++++++++++++++++++++++---------------------
 net/mac80211/mesh_pathtbl.c |   12 +-
 net/wireless/nl80211.c      |    6 +-
 9 files changed, 144 insertions(+), 141 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 50afca3..f682911 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -895,14 +895,14 @@ enum nl80211_sta_info {
  *
  * @NL80211_MPATH_FLAG_ACTIVE: the mesh path is active
  * @NL80211_MPATH_FLAG_RESOLVING: the mesh path discovery process is running
- * @NL80211_MPATH_FLAG_DSN_VALID: the mesh path contains a valid DSN
+ * @NL80211_MPATH_FLAG_SN_VALID: the mesh path contains a valid SN
  * @NL80211_MPATH_FLAG_FIXED: the mesh path has been manually set
  * @NL80211_MPATH_FLAG_RESOLVED: the mesh path discovery process succeeded
  */
 enum nl80211_mpath_flags {
 	NL80211_MPATH_FLAG_ACTIVE =	1<<0,
 	NL80211_MPATH_FLAG_RESOLVING =	1<<1,
-	NL80211_MPATH_FLAG_DSN_VALID =	1<<2,
+	NL80211_MPATH_FLAG_SN_VALID =	1<<2,
 	NL80211_MPATH_FLAG_FIXED =	1<<3,
 	NL80211_MPATH_FLAG_RESOLVED =	1<<4,
 };
@@ -915,7 +915,7 @@ enum nl80211_mpath_flags {
  *
  * @__NL80211_MPATH_INFO_INVALID: attribute number 0 is reserved
  * @NL80211_ATTR_MPATH_FRAME_QLEN: number of queued frames for this destination
- * @NL80211_ATTR_MPATH_DSN: destination sequence number
+ * @NL80211_ATTR_MPATH_SN: destination sequence number
  * @NL80211_ATTR_MPATH_METRIC: metric (cost) of this mesh path
  * @NL80211_ATTR_MPATH_EXPTIME: expiration time for the path, in msec from now
  * @NL80211_ATTR_MPATH_FLAGS: mesh path flags, enumerated in
@@ -926,7 +926,7 @@ enum nl80211_mpath_flags {
 enum nl80211_mpath_info {
 	__NL80211_MPATH_INFO_INVALID,
 	NL80211_MPATH_INFO_FRAME_QLEN,
-	NL80211_MPATH_INFO_DSN,
+	NL80211_MPATH_INFO_SN,
 	NL80211_MPATH_INFO_METRIC,
 	NL80211_MPATH_INFO_EXPTIME,
 	NL80211_MPATH_INFO_FLAGS,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ff67865..b3031bd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -418,7 +418,7 @@ enum monitor_flags {
  * in during get_station() or dump_station().
  *
  * MPATH_INFO_FRAME_QLEN: @frame_qlen filled
- * MPATH_INFO_DSN: @dsn filled
+ * MPATH_INFO_SN: @sn filled
  * MPATH_INFO_METRIC: @metric filled
  * MPATH_INFO_EXPTIME: @exptime filled
  * MPATH_INFO_DISCOVERY_TIMEOUT: @discovery_timeout filled
@@ -427,7 +427,7 @@ enum monitor_flags {
  */
 enum mpath_info_flags {
 	MPATH_INFO_FRAME_QLEN		= BIT(0),
-	MPATH_INFO_DSN			= BIT(1),
+	MPATH_INFO_SN			= BIT(1),
 	MPATH_INFO_METRIC		= BIT(2),
 	MPATH_INFO_EXPTIME		= BIT(3),
 	MPATH_INFO_DISCOVERY_TIMEOUT	= BIT(4),
@@ -442,7 +442,7 @@ enum mpath_info_flags {
  *
  * @filled: bitfield of flags from &enum mpath_info_flags
  * @frame_qlen: number of queued frames for this destination
- * @dsn: destination sequence number
+ * @sn: target sequence number
  * @metric: metric (cost) of this mesh path
  * @exptime: expiration time for the mesh path from now, in msecs
  * @flags: mesh path flags
@@ -456,7 +456,7 @@ enum mpath_info_flags {
 struct mpath_info {
 	u32 filled;
 	u32 frame_qlen;
-	u32 dsn;
+	u32 sn;
 	u32 metric;
 	u32 exptime;
 	u32 discovery_timeout;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 56319b5..340678e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -907,7 +907,7 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 	pinfo->generation = mesh_paths_generation;
 
 	pinfo->filled = MPATH_INFO_FRAME_QLEN |
-			MPATH_INFO_DSN |
+			MPATH_INFO_SN |
 			MPATH_INFO_METRIC |
 			MPATH_INFO_EXPTIME |
 			MPATH_INFO_DISCOVERY_TIMEOUT |
@@ -915,7 +915,7 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 			MPATH_INFO_FLAGS;
 
 	pinfo->frame_qlen = mpath->frame_queue.qlen;
-	pinfo->dsn = mpath->dsn;
+	pinfo->sn = mpath->sn;
 	pinfo->metric = mpath->metric;
 	if (time_before(jiffies, mpath->exp_time))
 		pinfo->exptime = jiffies_to_msecs(mpath->exp_time - jiffies);
@@ -927,8 +927,8 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 		pinfo->flags |= NL80211_MPATH_FLAG_ACTIVE;
 	if (mpath->flags & MESH_PATH_RESOLVING)
 		pinfo->flags |= NL80211_MPATH_FLAG_RESOLVING;
-	if (mpath->flags & MESH_PATH_DSN_VALID)
-		pinfo->flags |= NL80211_MPATH_FLAG_DSN_VALID;
+	if (mpath->flags & MESH_PATH_SN_VALID)
+		pinfo->flags |= NL80211_MPATH_FLAG_SN_VALID;
 	if (mpath->flags & MESH_PATH_FIXED)
 		pinfo->flags |= NL80211_MPATH_FLAG_FIXED;
 	if (mpath->flags & MESH_PATH_RESOLVING)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8c54702..4259852 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -370,14 +370,14 @@ struct ieee80211_if_mesh {
 	u8 mesh_sp_id;
 	/* Authentication Protocol Identifier */
 	u8 mesh_auth_id;
-	/* Local mesh Destination Sequence Number */
-	u32 dsn;
+	/* Local mesh Sequence Number */
+	u32 sn;
 	/* Last used PREQ ID */
 	u32 preq_id;
 	atomic_t mpaths;
-	/* Timestamp of last DSN update */
-	unsigned long last_dsn_update;
-	/* Timestamp of last DSN sent */
+	/* Timestamp of last SN update */
+	unsigned long last_sn_update;
+	/* Timestamp of last SN sent */
 	unsigned long last_preq;
 	struct mesh_rmc *rmc;
 	spinlock_t mesh_preq_queue_lock;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 222a313..0f3e114 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -672,7 +672,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 		MESH_MIN_DISCOVERY_TIMEOUT;
 	ifmsh->accepting_plinks = true;
 	ifmsh->preq_id = 0;
-	ifmsh->dsn = 0;
+	ifmsh->sn = 0;
 	atomic_set(&ifmsh->mpaths, 0);
 	mesh_rmc_init(sdata);
 	ifmsh->last_preq = jiffies;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 1d534c7..ee687ad 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -26,7 +26,7 @@
  *
  * @MESH_PATH_ACTIVE: the mesh path can be used for forwarding
  * @MESH_PATH_RESOLVING: the discovery process is running for this mesh path
- * @MESH_PATH_DSN_VALID: the mesh path contains a valid destination sequence
+ * @MESH_PATH_SN_VALID: the mesh path contains a valid destination sequence
  * 	number
  * @MESH_PATH_FIXED: the mesh path has been manually set and should not be
  * 	modified
@@ -38,7 +38,7 @@
 enum mesh_path_flags {
 	MESH_PATH_ACTIVE =	BIT(0),
 	MESH_PATH_RESOLVING =	BIT(1),
-	MESH_PATH_DSN_VALID =	BIT(2),
+	MESH_PATH_SN_VALID =	BIT(2),
 	MESH_PATH_FIXED	=	BIT(3),
 	MESH_PATH_RESOLVED =	BIT(4),
 };
@@ -70,7 +70,7 @@ enum mesh_deferred_task_flags {
  * @timer: mesh path discovery timer
  * @frame_queue: pending queue for frames sent to this destination while the
  * 	path is unresolved
- * @dsn: destination sequence number of the destination
+ * @sn: target sequence number
  * @metric: current metric to this destination
  * @hop_count: hops to destination
  * @exp_time: in jiffies, when the path will expire or when it expired
@@ -94,7 +94,7 @@ struct mesh_path {
 	struct timer_list timer;
 	struct sk_buff_head frame_queue;
 	struct rcu_head rcu;
-	u32 dsn;
+	u32 sn;
 	u32 metric;
 	u8 hop_count;
 	unsigned long exp_time;
@@ -280,7 +280,7 @@ void mesh_mpp_table_grow(void);
 u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata,
 		struct mesh_table *tbl);
 /* Mesh paths */
-int mesh_path_error_tx(u8 ttl, u8 *dest, __le32 dest_dsn, __le16 dest_rcode,
+int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn, __le16 target_rcode,
 		u8 *ra, struct ieee80211_sub_if_data *sdata);
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 355099f..850c403 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -56,33 +56,33 @@ static inline u32 u16_field_get(u8 *preq_elem, int offset, bool ae)
 #define PREQ_IE_TTL(x)		(*(x + 2))
 #define PREQ_IE_PREQ_ID(x)	u32_field_get(x, 3, 0)
 #define PREQ_IE_ORIG_ADDR(x)	(x + 7)
-#define PREQ_IE_ORIG_DSN(x)	u32_field_get(x, 13, 0);
+#define PREQ_IE_ORIG_SN(x)	u32_field_get(x, 13, 0);
 #define PREQ_IE_LIFETIME(x)	u32_field_get(x, 17, AE_F_SET(x));
 #define PREQ_IE_METRIC(x) 	u32_field_get(x, 21, AE_F_SET(x));
-#define PREQ_IE_DST_F(x)	(*(AE_F_SET(x) ? x + 32 : x + 26))
-#define PREQ_IE_DST_ADDR(x) 	(AE_F_SET(x) ? x + 33 : x + 27)
-#define PREQ_IE_DST_DSN(x) 	u32_field_get(x, 33, AE_F_SET(x));
+#define PREQ_IE_TARGET_F(x)	(*(AE_F_SET(x) ? x + 32 : x + 26))
+#define PREQ_IE_TARGET_ADDR(x) 	(AE_F_SET(x) ? x + 33 : x + 27)
+#define PREQ_IE_TARGET_SN(x) 	u32_field_get(x, 33, AE_F_SET(x));
 
 
 #define PREP_IE_FLAGS(x)	PREQ_IE_FLAGS(x)
 #define PREP_IE_HOPCOUNT(x)	PREQ_IE_HOPCOUNT(x)
 #define PREP_IE_TTL(x)		PREQ_IE_TTL(x)
 #define PREP_IE_ORIG_ADDR(x)	(x + 3)
-#define PREP_IE_ORIG_DSN(x)	u32_field_get(x, 9, 0);
+#define PREP_IE_ORIG_SN(x)	u32_field_get(x, 9, 0);
 #define PREP_IE_LIFETIME(x)	u32_field_get(x, 13, AE_F_SET(x));
 #define PREP_IE_METRIC(x)	u32_field_get(x, 17, AE_F_SET(x));
-#define PREP_IE_DST_ADDR(x)	(AE_F_SET(x) ? x + 27 : x + 21)
-#define PREP_IE_DST_DSN(x)	u32_field_get(x, 27, AE_F_SET(x));
+#define PREP_IE_TARGET_ADDR(x)	(AE_F_SET(x) ? x + 27 : x + 21)
+#define PREP_IE_TARGET_SN(x)	u32_field_get(x, 27, AE_F_SET(x));
 
 #define PERR_IE_TTL(x)		(*(x))
-#define PERR_IE_DST_FLAGS(x)	(*(x + 2))
-#define PERR_IE_DST_ADDR(x)	(x + 3)
-#define PERR_IE_DST_DSN(x)	u32_field_get(x, 9, 0);
-#define PERR_IE_DST_RCODE(x)	u16_field_get(x, 13, 0);
+#define PERR_IE_TARGET_FLAGS(x)	(*(x + 2))
+#define PERR_IE_TARGET_ADDR(x)	(x + 3)
+#define PERR_IE_TARGET_SN(x)	u32_field_get(x, 9, 0);
+#define PERR_IE_TARGET_RCODE(x)	u16_field_get(x, 13, 0);
 
 #define MSEC_TO_TU(x) (x*1000/1024)
-#define DSN_GT(x, y) ((long) (y) - (long) (x) < 0)
-#define DSN_LT(x, y) ((long) (x) - (long) (y) < 0)
+#define SN_GT(x, y) ((long) (y) - (long) (x) < 0)
+#define SN_LT(x, y) ((long) (x) - (long) (y) < 0)
 
 #define net_traversal_jiffies(s) \
 	msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPnetDiameterTraversalTime)
@@ -102,9 +102,10 @@ enum mpath_frame_type {
 };
 
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
-		u8 *orig_addr, __le32 orig_dsn, u8 dst_flags, u8 *dst,
-		__le32 dst_dsn, u8 *da, u8 hop_count, u8 ttl, __le32 lifetime,
-		__le32 metric, __le32 preq_id, struct ieee80211_sub_if_data *sdata)
+		u8 *orig_addr, __le32 orig_sn, u8 target_flags, u8 *target,
+		__le32 target_sn, u8 *da, u8 hop_count, u8 ttl,__le32 lifetime,
+		__le32 metric, __le32 preq_id,
+		struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
@@ -133,13 +134,13 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 
 	switch (action) {
 	case MPATH_PREQ:
-		mhwmp_dbg("sending PREQ to %pM\n", dst);
+		mhwmp_dbg("sending PREQ to %pM\n", target);
 		ie_len = 37;
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREQ;
 		break;
 	case MPATH_PREP:
-		mhwmp_dbg("sending PREP to %pM\n", dst);
+		mhwmp_dbg("sending PREP to %pM\n", target);
 		ie_len = 31;
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREP;
@@ -165,7 +166,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	}
 	memcpy(pos, orig_addr, ETH_ALEN);
 	pos += ETH_ALEN;
-	memcpy(pos, &orig_dsn, 4);
+	memcpy(pos, &orig_sn, 4);
 	pos += 4;
 	if (action != MPATH_RANN) {
 		memcpy(pos, &lifetime, 4);
@@ -176,12 +177,12 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	if (action == MPATH_PREQ) {
 		/* destination count */
 		*pos++ = 1;
-		*pos++ = dst_flags;
+		*pos++ = target_flags;
 	}
 	if (action != MPATH_RANN) {
-		memcpy(pos, dst, ETH_ALEN);
+		memcpy(pos, target, ETH_ALEN);
 		pos += ETH_ALEN;
-		memcpy(pos, &dst_dsn, 4);
+		memcpy(pos, &target_sn, 4);
 	}
 
 	ieee80211_tx_skb(sdata, skb, 1);
@@ -191,12 +192,14 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 /**
  * mesh_send_path error - Sends a PERR mesh management frame
  *
- * @dst: broken destination
- * @dst_dsn: dsn of the broken destination
+ * @target: broken destination
+ * @target_sn: SN of the broken destination
+ * @target_rcode: reason code for this PERR
  * @ra: node this frame is addressed to
  */
-int mesh_path_error_tx(u8 ttl, u8 *dst, __le32 dst_dsn, __le16 dst_rcode,
-		u8 *ra, struct ieee80211_sub_if_data *sdata)
+int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
+    		__le16 target_rcode, u8 *ra,
+		struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
@@ -234,16 +237,16 @@ int mesh_path_error_tx(u8 ttl, u8 *dst, __le32 dst_dsn, __le16 dst_rcode,
 	 * bit 2 is set if we have a reason code
 	 */
 	*pos = 0;
-	if (!dst_dsn)
+	if (!target_sn)
 		*pos |= MP_F_USN;
-	if (dst_rcode)
+	if (target_rcode)
 		*pos |= MP_F_RCODE;
 	pos++;
-	memcpy(pos, dst, ETH_ALEN);
+	memcpy(pos, target, ETH_ALEN);
 	pos += ETH_ALEN;
-	memcpy(pos, &dst_dsn, 4);
+	memcpy(pos, &target_sn, 4);
 	pos += 4;
-	memcpy(pos, &dst_rcode, 2);
+	memcpy(pos, &target_rcode, 2);
 
 	ieee80211_tx_skb(sdata, skb, 1);
 	return 0;
@@ -324,7 +327,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	bool fresh_info;
 	u8 *orig_addr, *ta;
-	u32 orig_dsn, orig_metric;
+	u32 orig_sn, orig_metric;
 	unsigned long orig_lifetime, exp_time;
 	u32 last_hop_metric, new_metric;
 	bool process = true;
@@ -343,7 +346,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 	switch (action) {
 	case MPATH_PREQ:
 		orig_addr = PREQ_IE_ORIG_ADDR(hwmp_ie);
-		orig_dsn = PREQ_IE_ORIG_DSN(hwmp_ie);
+		orig_sn = PREQ_IE_ORIG_SN(hwmp_ie);
 		orig_lifetime = PREQ_IE_LIFETIME(hwmp_ie);
 		orig_metric = PREQ_IE_METRIC(hwmp_ie);
 		break;
@@ -356,7 +359,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 		 * information from both PREQ and PREP frames.
 		 */
 		orig_addr = PREP_IE_ORIG_ADDR(hwmp_ie);
-		orig_dsn = PREP_IE_ORIG_DSN(hwmp_ie);
+		orig_sn = PREP_IE_ORIG_SN(hwmp_ie);
 		orig_lifetime = PREP_IE_LIFETIME(hwmp_ie);
 		orig_metric = PREP_IE_METRIC(hwmp_ie);
 		break;
@@ -382,9 +385,9 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 			if (mpath->flags & MESH_PATH_FIXED)
 				fresh_info = false;
 			else if ((mpath->flags & MESH_PATH_ACTIVE) &&
-			    (mpath->flags & MESH_PATH_DSN_VALID)) {
-				if (DSN_GT(mpath->dsn, orig_dsn) ||
-				    (mpath->dsn == orig_dsn &&
+			    (mpath->flags & MESH_PATH_SN_VALID)) {
+				if (SN_GT(mpath->sn, orig_sn) ||
+				    (mpath->sn == orig_sn &&
 				     action == MPATH_PREQ &&
 				     new_metric > mpath->metric)) {
 					process = false;
@@ -403,9 +406,9 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 
 		if (fresh_info) {
 			mesh_path_assign_nexthop(mpath, sta);
-			mpath->flags |= MESH_PATH_DSN_VALID;
+			mpath->flags |= MESH_PATH_SN_VALID;
 			mpath->metric = new_metric;
-			mpath->dsn = orig_dsn;
+			mpath->sn = orig_sn;
 			mpath->exp_time = time_after(mpath->exp_time, exp_time)
 					  ?  mpath->exp_time : exp_time;
 			mesh_path_activate(mpath);
@@ -444,7 +447,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 
 		if (fresh_info) {
 			mesh_path_assign_nexthop(mpath, sta);
-			mpath->flags &= ~MESH_PATH_DSN_VALID;
+			mpath->flags &= ~MESH_PATH_SN_VALID;
 			mpath->metric = last_hop_metric;
 			mpath->exp_time = time_after(mpath->exp_time, exp_time)
 					  ?  mpath->exp_time : exp_time;
@@ -466,47 +469,47 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
-	u8 *dst_addr, *orig_addr;
-	u8 dst_flags, ttl;
-	u32 orig_dsn, dst_dsn, lifetime;
+	u8 *target_addr, *orig_addr;
+	u8 target_flags, ttl;
+	u32 orig_sn, target_sn, lifetime;
 	bool reply = false;
 	bool forward = true;
 
-	/* Update destination DSN, if present */
-	dst_addr = PREQ_IE_DST_ADDR(preq_elem);
+	/* Update target SN, if present */
+	target_addr = PREQ_IE_TARGET_ADDR(preq_elem);
 	orig_addr = PREQ_IE_ORIG_ADDR(preq_elem);
-	dst_dsn = PREQ_IE_DST_DSN(preq_elem);
-	orig_dsn = PREQ_IE_ORIG_DSN(preq_elem);
-	dst_flags = PREQ_IE_DST_F(preq_elem);
+	target_sn = PREQ_IE_TARGET_SN(preq_elem);
+	orig_sn = PREQ_IE_ORIG_SN(preq_elem);
+	target_flags = PREQ_IE_TARGET_F(preq_elem);
 
 	mhwmp_dbg("received PREQ from %pM\n", orig_addr);
 
-	if (memcmp(dst_addr, sdata->dev->dev_addr, ETH_ALEN) == 0) {
+	if (memcmp(target_addr, sdata->dev->dev_addr, ETH_ALEN) == 0) {
 		mhwmp_dbg("PREQ is for us\n");
 		forward = false;
 		reply = true;
 		metric = 0;
-		if (time_after(jiffies, ifmsh->last_dsn_update +
+		if (time_after(jiffies, ifmsh->last_sn_update +
 					net_traversal_jiffies(sdata)) ||
-		    time_before(jiffies, ifmsh->last_dsn_update)) {
-			dst_dsn = ++ifmsh->dsn;
-			ifmsh->last_dsn_update = jiffies;
+		    time_before(jiffies, ifmsh->last_sn_update)) {
+			target_sn = ++ifmsh->sn;
+			ifmsh->last_sn_update = jiffies;
 		}
 	} else {
 		rcu_read_lock();
-		mpath = mesh_path_lookup(dst_addr, sdata);
+		mpath = mesh_path_lookup(target_addr, sdata);
 		if (mpath) {
-			if ((!(mpath->flags & MESH_PATH_DSN_VALID)) ||
-					DSN_LT(mpath->dsn, dst_dsn)) {
-				mpath->dsn = dst_dsn;
-				mpath->flags |= MESH_PATH_DSN_VALID;
-			} else if ((!(dst_flags & MP_F_DO)) &&
+			if ((!(mpath->flags & MESH_PATH_SN_VALID)) ||
+					SN_LT(mpath->sn, target_sn)) {
+				mpath->sn = target_sn;
+				mpath->flags |= MESH_PATH_SN_VALID;
+			} else if ((!(target_flags & MP_F_DO)) &&
 					(mpath->flags & MESH_PATH_ACTIVE)) {
 				reply = true;
 				metric = mpath->metric;
-				dst_dsn = mpath->dsn;
-				if (dst_flags & MP_F_RF)
-					dst_flags |= MP_F_DO;
+				target_sn = mpath->sn;
+				if (target_flags & MP_F_RF)
+					target_flags |= MP_F_DO;
 				else
 					forward = false;
 			}
@@ -519,9 +522,9 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		ttl = ifmsh->mshcfg.dot11MeshTTL;
 		if (ttl != 0) {
 			mhwmp_dbg("replying to the PREQ\n");
-			mesh_path_sel_frame_tx(MPATH_PREP, 0, dst_addr,
-				cpu_to_le32(dst_dsn), 0, orig_addr,
-				cpu_to_le32(orig_dsn), mgmt->sa, 0, ttl,
+			mesh_path_sel_frame_tx(MPATH_PREP, 0, target_addr,
+				cpu_to_le32(target_sn), 0, orig_addr,
+				cpu_to_le32(orig_sn), mgmt->sa, 0, ttl,
 				cpu_to_le32(lifetime), cpu_to_le32(metric),
 				0, sdata);
 		} else
@@ -544,8 +547,8 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		preq_id = PREQ_IE_PREQ_ID(preq_elem);
 		hopcount = PREQ_IE_HOPCOUNT(preq_elem) + 1;
 		mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
-				cpu_to_le32(orig_dsn), dst_flags, dst_addr,
-				cpu_to_le32(dst_dsn), sdata->dev->broadcast,
+				cpu_to_le32(orig_sn), target_flags, target_addr,
+				cpu_to_le32(target_sn), sdata->dev->broadcast,
 				hopcount, ttl, cpu_to_le32(lifetime),
 				cpu_to_le32(metric), cpu_to_le32(preq_id),
 				sdata);
@@ -560,10 +563,10 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 				    u8 *prep_elem, u32 metric)
 {
 	struct mesh_path *mpath;
-	u8 *dst_addr, *orig_addr;
+	u8 *target_addr, *orig_addr;
 	u8 ttl, hopcount, flags;
 	u8 next_hop[ETH_ALEN];
-	u32 dst_dsn, orig_dsn, lifetime;
+	u32 target_sn, orig_sn, lifetime;
 
 	mhwmp_dbg("received PREP from %pM\n", PREP_IE_ORIG_ADDR(prep_elem));
 
@@ -573,8 +576,8 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	 * which corresponds with the originator of the PREQ which this PREP
 	 * replies
 	 */
-	dst_addr = PREP_IE_DST_ADDR(prep_elem);
-	if (memcmp(dst_addr, sdata->dev->dev_addr, ETH_ALEN) == 0)
+	target_addr = PREP_IE_TARGET_ADDR(prep_elem);
+	if (memcmp(target_addr, sdata->dev->dev_addr, ETH_ALEN) == 0)
 		/* destination, no forwarding required */
 		return;
 
@@ -585,7 +588,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	}
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(dst_addr, sdata);
+	mpath = mesh_path_lookup(target_addr, sdata);
 	if (mpath)
 		spin_lock_bh(&mpath->state_lock);
 	else
@@ -601,13 +604,13 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	lifetime = PREP_IE_LIFETIME(prep_elem);
 	hopcount = PREP_IE_HOPCOUNT(prep_elem) + 1;
 	orig_addr = PREP_IE_ORIG_ADDR(prep_elem);
-	dst_dsn = PREP_IE_DST_DSN(prep_elem);
-	orig_dsn = PREP_IE_ORIG_DSN(prep_elem);
+	target_sn = PREP_IE_TARGET_SN(prep_elem);
+	orig_sn = PREP_IE_ORIG_SN(prep_elem);
 
 	mesh_path_sel_frame_tx(MPATH_PREP, flags, orig_addr,
-		cpu_to_le32(orig_dsn), 0, dst_addr,
-		cpu_to_le32(dst_dsn), mpath->next_hop->sta.addr, hopcount, ttl,
-		cpu_to_le32(lifetime), cpu_to_le32(metric),
+		cpu_to_le32(orig_sn), 0, target_addr,
+		cpu_to_le32(target_sn), mpath->next_hop->sta.addr, hopcount,
+		ttl, cpu_to_le32(lifetime), cpu_to_le32(metric),
 		0, sdata);
 	rcu_read_unlock();
 
@@ -627,10 +630,10 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
 	u8 ttl;
-	u8 *ta, *dst_addr;
-	u8 dst_flags;
-	u32 dst_dsn;
-	u16 dst_rcode;
+	u8 *ta, *target_addr;
+	u8 target_flags;
+	u32 target_sn;
+	u16 target_rcode;
 
 	ta = mgmt->sa;
 	ttl = PERR_IE_TTL(perr_elem);
@@ -639,24 +642,24 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 	ttl--;
-	dst_flags = PERR_IE_DST_FLAGS(perr_elem);
-	dst_addr = PERR_IE_DST_ADDR(perr_elem);
-	dst_dsn = PERR_IE_DST_DSN(perr_elem);
-	dst_rcode = PERR_IE_DST_RCODE(perr_elem);
+	target_flags = PERR_IE_TARGET_FLAGS(perr_elem);
+	target_addr = PERR_IE_TARGET_ADDR(perr_elem);
+	target_sn = PERR_IE_TARGET_SN(perr_elem);
+	target_rcode = PERR_IE_TARGET_RCODE(perr_elem);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(dst_addr, sdata);
+	mpath = mesh_path_lookup(target_addr, sdata);
 	if (mpath) {
 		spin_lock_bh(&mpath->state_lock);
 		if (mpath->flags & MESH_PATH_ACTIVE &&
 		    memcmp(ta, mpath->next_hop->sta.addr, ETH_ALEN) == 0 &&
-		    (!(mpath->flags & MESH_PATH_DSN_VALID) ||
-		    DSN_GT(dst_dsn, mpath->dsn))) {
+		    (!(mpath->flags & MESH_PATH_SN_VALID) ||
+		    SN_GT(target_sn, mpath->sn))) {
 			mpath->flags &= ~MESH_PATH_ACTIVE;
-			mpath->dsn = dst_dsn;
+			mpath->sn = target_sn;
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_error_tx(ttl, dst_addr, cpu_to_le32(dst_dsn),
-					   cpu_to_le16(dst_rcode),
+			mesh_path_error_tx(ttl, target_addr, cpu_to_le32(target_sn),
+					   cpu_to_le16(target_rcode),
 					   sdata->dev->broadcast, sdata);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
@@ -673,7 +676,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	u8 *ta;
 	u8 ttl, flags, hopcount;
 	u8 *orig_addr;
-	u32 orig_dsn, metric;
+	u32 orig_sn, metric;
 
 	ta = mgmt->sa;
 	ttl = rann->rann_ttl;
@@ -684,7 +687,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	ttl--;
 	flags = rann->rann_flags;
 	orig_addr = rann->rann_addr;
-	orig_dsn = rann->rann_seq;
+	orig_sn = rann->rann_seq;
 	hopcount = rann->rann_hopcount;
 	hopcount++;
 	metric = rann->rann_metric;
@@ -703,14 +706,14 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 		mesh_queue_preq(mpath,
 				PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 	}
-	if (mpath->dsn < orig_dsn) {
+	if (mpath->sn < orig_sn) {
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
-				       cpu_to_le32(orig_dsn),
+				       cpu_to_le32(orig_sn),
 				       0, NULL, 0, sdata->dev->broadcast,
 				       hopcount, ttl, 0,
 				       cpu_to_le32(metric + mpath->metric),
 				       0, sdata);
-		mpath->dsn = orig_dsn;
+		mpath->sn = orig_sn;
 	}
 	rcu_read_unlock();
 }
@@ -823,7 +826,7 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_preq_queue *preq_node;
 	struct mesh_path *mpath;
-	u8 ttl, dst_flags;
+	u8 ttl, target_flags;
 	u32 lifetime;
 
 	spin_lock_bh(&ifmsh->mesh_preq_queue_lock);
@@ -865,11 +868,11 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 
 	ifmsh->last_preq = jiffies;
 
-	if (time_after(jiffies, ifmsh->last_dsn_update +
+	if (time_after(jiffies, ifmsh->last_sn_update +
 				net_traversal_jiffies(sdata)) ||
-	    time_before(jiffies, ifmsh->last_dsn_update)) {
-		++ifmsh->dsn;
-		sdata->u.mesh.last_dsn_update = jiffies;
+	    time_before(jiffies, ifmsh->last_sn_update)) {
+		++ifmsh->sn;
+		sdata->u.mesh.last_sn_update = jiffies;
 	}
 	lifetime = default_lifetime(sdata);
 	ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
@@ -880,14 +883,14 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 	}
 
 	if (preq_node->flags & PREQ_Q_F_REFRESH)
-		dst_flags = MP_F_DO;
+		target_flags = MP_F_DO;
 	else
-		dst_flags = MP_F_RF;
+		target_flags = MP_F_RF;
 
 	spin_unlock_bh(&mpath->state_lock);
 	mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->dev->dev_addr,
-			cpu_to_le32(ifmsh->dsn), dst_flags, mpath->dst,
-			cpu_to_le32(mpath->dsn), sdata->dev->broadcast, 0,
+			cpu_to_le32(ifmsh->sn), target_flags, mpath->dst,
+			cpu_to_le32(mpath->sn), sdata->dev->broadcast, 0,
 			ttl, cpu_to_le32(lifetime), 0,
 			cpu_to_le32(ifmsh->preq_id++), sdata);
 	mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
@@ -914,15 +917,15 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 	struct sk_buff *skb_to_free = NULL;
 	struct mesh_path *mpath;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u8 *dst_addr = hdr->addr3;
+	u8 *target_addr = hdr->addr3;
 	int err = 0;
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(dst_addr, sdata);
+	mpath = mesh_path_lookup(target_addr, sdata);
 
 	if (!mpath) {
-		mesh_path_add(dst_addr, sdata);
-		mpath = mesh_path_lookup(dst_addr, sdata);
+		mesh_path_add(target_addr, sdata);
+		mpath = mesh_path_lookup(target_addr, sdata);
 		if (!mpath) {
 			sdata->u.mesh.mshstats.dropped_frames_no_route++;
 			err = -ENOSPC;
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 5d54123..2cebdf5 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -463,10 +463,10 @@ void mesh_plink_broken(struct sta_info *sta)
 		    mpath->flags & MESH_PATH_ACTIVE &&
 		    !(mpath->flags & MESH_PATH_FIXED)) {
 			mpath->flags &= ~MESH_PATH_ACTIVE;
-			++mpath->dsn;
+			++mpath->sn;
 			spin_unlock_bh(&mpath->state_lock);
 			mesh_path_error_tx(MESH_TTL, mpath->dst,
-					cpu_to_le32(mpath->dsn),
+					cpu_to_le32(mpath->sn),
 					PERR_RCODE_DEST_UNREACH,
 					sdata->dev->broadcast, sdata);
 		} else
@@ -602,7 +602,7 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct mesh_path *mpath;
-	u32 dsn = 0;
+	u32 sn = 0;
 
 	if (memcmp(hdr->addr4, sdata->dev->dev_addr, ETH_ALEN) != 0) {
 		u8 *ra, *da;
@@ -611,8 +611,8 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 		ra = hdr->addr1;
 		mpath = mesh_path_lookup(da, sdata);
 		if (mpath)
-			dsn = ++mpath->dsn;
-		mesh_path_error_tx(MESH_TTL, skb->data, cpu_to_le32(dsn),
+			sn = ++mpath->sn;
+		mesh_path_error_tx(MESH_TTL, skb->data, cpu_to_le32(sn),
 				   PERR_RCODE_NO_ROUTE, ra, sdata);
 	}
 
@@ -648,7 +648,7 @@ void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop)
 {
 	spin_lock_bh(&mpath->state_lock);
 	mesh_path_assign_nexthop(mpath, next_hop);
-	mpath->dsn = 0xffff;
+	mpath->sn = 0xffff;
 	mpath->metric = 0;
 	mpath->hop_count = 0;
 	mpath->exp_time = 0;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8ed62b6..867b023 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2105,9 +2105,9 @@ static int nl80211_send_mpath(struct sk_buff *msg, u32 pid, u32 seq,
 	if (pinfo->filled & MPATH_INFO_FRAME_QLEN)
 		NLA_PUT_U32(msg, NL80211_MPATH_INFO_FRAME_QLEN,
 			    pinfo->frame_qlen);
-	if (pinfo->filled & MPATH_INFO_DSN)
-		NLA_PUT_U32(msg, NL80211_MPATH_INFO_DSN,
-			    pinfo->dsn);
+	if (pinfo->filled & MPATH_INFO_SN)
+		NLA_PUT_U32(msg, NL80211_MPATH_INFO_SN,
+			    pinfo->sn);
 	if (pinfo->filled & MPATH_INFO_METRIC)
 		NLA_PUT_U32(msg, NL80211_MPATH_INFO_METRIC,
 			    pinfo->metric);
-- 
1.5.6.5

