Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:30636 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbZKIMk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:40:56 -0500
Received: by fg-out-1718.google.com with SMTP id d23so703179fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:41:01 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 12/21] mac80211: implement RANN processing and forwarding
Date: Mon,  9 Nov 2009 12:39:32 +0000
Message-Id: <1257770381-7680-13-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Process the RANN (Root Annoucement) Frame and try to find the HWMP
root station by sending a PREQ.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |   88 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index db1a330..4525419 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -28,6 +28,8 @@
 /* Reply and forward */
 #define MP_F_RF	0x2
 
+static void mesh_queue_preq(struct mesh_path *, u8);
+
 static inline u32 u32_field_get(u8 *preq_elem, int offset, bool ae)
 {
 	if (ae)
@@ -64,6 +66,13 @@ static inline u32 u32_field_get(u8 *preq_elem, int offset, bool ae)
 #define PERR_IE_DST_ADDR(x)	(x + 2)
 #define PERR_IE_DST_DSN(x)	u32_field_get(x, 8, 0);
 
+#define RANN_IE_FLAGS(x)	PREP_IE_FLAGS(x)
+#define RANN_IE_HOPCOUNT(x)	PREP_IE_HOPCOUNT(x)
+#define RANN_IE_TTL(x)		PREP_IE_TTL(x)
+#define RANN_IE_ORIG_ADDR(x)	PREP_IE_ORIG_ADDR(x)
+#define RANN_IE_ORIG_DSN(x)	PREP_IE_ORIG_DSN(x)
+#define RANN_IE_METRIC(x)	u32_field_get(x, 13, 0)
+
 #define MSEC_TO_TU(x) (x*1000/1024)
 #define DSN_GT(x, y) ((long) (y) - (long) (x) < 0)
 #define DSN_LT(x, y) ((long) (x) - (long) (y) < 0)
@@ -81,7 +90,8 @@ static inline u32 u32_field_get(u8 *preq_elem, int offset, bool ae)
 enum mpath_frame_type {
 	MPATH_PREQ = 0,
 	MPATH_PREP,
-	MPATH_PERR
+	MPATH_PERR,
+	MPATH_RANN
 };
 
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
@@ -109,7 +119,8 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	/* BSSID is left zeroed, wildcard value */
+	/* BSSID == SA */
+	memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
 	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
 
@@ -126,6 +137,12 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREP;
 		break;
+	case MPATH_RANN:
+		mhwmp_dbg("sending RANN from %pM\n", orig_addr);
+		ie_len = 17;
+		pos = skb_put(skb, 2 + ie_len);
+		*pos++ = WLAN_EID_RANN;
+		break;
 	default:
 		kfree_skb(skb);
 		return -ENOTSUPP;
@@ -143,8 +160,10 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	pos += ETH_ALEN;
 	memcpy(pos, &orig_dsn, 4);
 	pos += 4;
-	memcpy(pos, &lifetime, 4);
-	pos += 4;
+	if (action != MPATH_RANN) {
+		memcpy(pos, &lifetime, 4);
+		pos += 4;
+	}
 	memcpy(pos, &metric, 4);
 	pos += 4;
 	if (action == MPATH_PREQ) {
@@ -152,9 +171,11 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		*pos++ = 1;
 		*pos++ = dst_flags;
 	}
-	memcpy(pos, dst, ETH_ALEN);
-	pos += ETH_ALEN;
-	memcpy(pos, &dst_dsn, 4);
+	if (action != MPATH_RANN) {
+		memcpy(pos, dst, ETH_ALEN);
+		pos += ETH_ALEN;
+		memcpy(pos, &dst_dsn, 4);
+	}
 
 	ieee80211_tx_skb(sdata, skb, 1);
 	return 0;
@@ -610,6 +631,53 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 }
 
+static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
+				struct ieee80211_mgmt *mgmt, u8 *rann_elem)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_path *mpath;
+	u8 *ta;
+	u8 ttl, flags, hopcount;
+	u8 *orig_addr;
+	u32 orig_dsn, metric;
+
+	ta = mgmt->sa;
+	ttl = RANN_IE_TTL(rann_elem);
+	if (ttl <= 1) {
+		ifmsh->mshstats.dropped_frames_ttl++;
+		return;
+	}
+	ttl--;
+	flags = RANN_IE_FLAGS(rann_elem);
+	orig_addr = RANN_IE_ORIG_ADDR(rann_elem);
+	orig_dsn = RANN_IE_ORIG_DSN(rann_elem);
+	hopcount = RANN_IE_HOPCOUNT(rann_elem);
+	metric = RANN_IE_METRIC(rann_elem);
+	mhwmp_dbg("received RANN from %pM\n", orig_addr);
+
+	rcu_read_lock();
+	mpath = mesh_path_lookup(orig_addr, sdata);
+	if (!mpath) {
+		mesh_path_add(orig_addr, sdata);
+		mpath = mesh_path_lookup(orig_addr, sdata);
+		if (!mpath) {
+			rcu_read_unlock();
+			sdata->u.mesh.mshstats.dropped_frames_no_route++;
+			return;
+		}
+		mesh_queue_preq(mpath,
+				PREQ_Q_F_START | PREQ_Q_F_REFRESH);
+	}
+	if (mpath->dsn < orig_dsn) {
+		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
+				       cpu_to_le32(orig_dsn),
+				       0, NULL, 0, sdata->dev->broadcast,
+				       hopcount, ttl, 0, cpu_to_le32(metric),
+				       0, sdata);
+		mpath->dsn = orig_dsn;
+	}
+	rcu_read_unlock();
+}
 
 
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
@@ -654,7 +722,11 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 			return;
 		hwmp_perr_frame_process(sdata, mgmt, elems.perr);
 	}
-
+	if (elems.rann) {
+		if (elems.rann_len != 17)
+			return;
+		hwmp_rann_frame_process(sdata, mgmt, elems.rann);
+	}
 }
 
 /**
-- 
1.5.6.5

