Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36644 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758704AbZKKAB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 19:01:29 -0500
Received: by ewy3 with SMTP id 3so647176ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 16:01:33 -0800 (PST)
Date: Wed, 11 Nov 2009 00:01:31 +0000
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 11/20] mac80211: implement RANN processing and forwarding
Message-ID: <20091111000131.GA58859@asus-p5b.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Process the RANN (Root Annoucement) Frame and try to find the HWMP
root station by sending a PREQ.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 include/linux/ieee80211.h  |   15 ++++++++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh_hwmp.c   |   79 +++++++++++++++++++++++++++++++++++++++----
 net/mac80211/util.c        |    4 ++
 4 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 50c684d..49b1abd 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -554,6 +554,20 @@ struct ieee80211_tim_ie {
 	u8 virtual_map[1];
 } __attribute__ ((packed));
 
+/**
+ * struct ieee80211_rann_ie
+ *
+ * This structure refers to "Root Announcement information element"
+ */
+struct ieee80211_rann_ie {
+	u8 rann_flags;
+	u8 rann_hopcount;
+	u8 rann_ttl;
+	u8 rann_addr[6];
+	u32 rann_seq;
+	u32 rann_metric;
+} __attribute__ ((packed));
+
 #define WLAN_SA_QUERY_TR_ID_LEN 2
 
 struct ieee80211_mgmt {
@@ -1070,6 +1084,7 @@ enum ieee80211_eid {
 	WLAN_EID_PREQ = 68,
 	WLAN_EID_PREP = 69,
 	WLAN_EID_PERR = 70,
+	WLAN_EID_RANN = 49,	/* compatible with FreeBSD */
 	/* 802.11h */
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1f4f88a..f6fdea6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -799,6 +799,7 @@ struct ieee802_11_elems {
 	u8 *preq;
 	u8 *prep;
 	u8 *perr;
+	struct ieee80211_rann_ie *rann;
 	u8 *ch_switch_elem;
 	u8 *country_elem;
 	u8 *pwr_constr_elem;
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index db1a330..7b9dd87 100644
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
@@ -81,7 +83,8 @@ static inline u32 u32_field_get(u8 *preq_elem, int offset, bool ae)
 enum mpath_frame_type {
 	MPATH_PREQ = 0,
 	MPATH_PREP,
-	MPATH_PERR
+	MPATH_PERR,
+	MPATH_RANN
 };
 
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
@@ -109,7 +112,8 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	/* BSSID is left zeroed, wildcard value */
+	/* BSSID == SA */
+	memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
 	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
 
@@ -126,6 +130,12 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREP;
 		break;
+	case MPATH_RANN:
+		mhwmp_dbg("sending RANN from %pM\n", orig_addr);
+		ie_len = sizeof(struct ieee80211_rann_ie);
+		pos = skb_put(skb, 2 + ie_len);
+		*pos++ = WLAN_EID_RANN;
+		break;
 	default:
 		kfree_skb(skb);
 		return -ENOTSUPP;
@@ -143,8 +153,10 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
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
@@ -152,9 +164,11 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
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
@@ -610,6 +624,54 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 }
 
+static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
+				struct ieee80211_mgmt *mgmt,
+				struct ieee80211_rann_ie *rann)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_path *mpath;
+	u8 *ta;
+	u8 ttl, flags, hopcount;
+	u8 *orig_addr;
+	u32 orig_dsn, metric;
+
+	ta = mgmt->sa;
+	ttl = rann->rann_ttl;
+	if (ttl <= 1) {
+		ifmsh->mshstats.dropped_frames_ttl++;
+		return;
+	}
+	ttl--;
+	flags = rann->rann_flags;
+	orig_addr = rann->rann_addr;
+	orig_dsn = rann->rann_seq;
+	hopcount = rann->rann_hopcount;
+	metric = rann->rann_metric;
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
@@ -654,7 +716,8 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 			return;
 		hwmp_perr_frame_process(sdata, mgmt, elems.perr);
 	}
-
+	if (elems.rann)
+		hwmp_rann_frame_process(sdata, mgmt, elems.rann);
 }
 
 /**
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index aedbaaa..da86e15 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -685,6 +685,10 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			elems->perr = pos;
 			elems->perr_len = elen;
 			break;
+		case WLAN_EID_RANN:
+			if (elen >= sizeof(struct ieee80211_rann_ie))
+				elems->rann = (void *)pos;
+			break;
 		case WLAN_EID_CHANNEL_SWITCH:
 			elems->ch_switch_elem = pos;
 			elems->ch_switch_elem_len = elen;
-- 
1.5.6.5

