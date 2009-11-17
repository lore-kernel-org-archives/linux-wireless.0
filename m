Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38208 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZKQMec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 07:34:32 -0500
Subject: [PATCH] mac80211: use fixed broadcast address
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 13:34:04 +0100
Message-ID: <1258461244.3682.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The netdev broadcast address cannot change from
all-ones so there's no need to use it; we can
instead hard-code it. Since we already have an
instance in tkip.c, which will be shared if it
is marked static const, doing this reduces text
size at no data/bss cost.

The real motivation for this is, of course, the
desire to get rid of almost all uses of netdevs
in mac80211 so that auditing their use becomes
easier.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Reduces .text size by 80 bytes on my x86_64 compile:
   text	   data	    bss	    dec	    hex	filename
 283249	  10264	    588	 294101	  47cd5	net/mac80211/mac80211.ko (before)
 283169	  10264	    588	 294021	  47c85	net/mac80211/mac80211.ko (after)

 net/mac80211/mesh.c         |    5 +++--
 net/mac80211/mesh.h         |    4 ++--
 net/mac80211/mesh_hwmp.c    |   20 +++++++++++---------
 net/mac80211/mesh_pathtbl.c |    3 ++-
 net/mac80211/tkip.c         |    4 ++--
 net/mac80211/tx.c           |   10 +++++++---
 6 files changed, 27 insertions(+), 19 deletions(-)

--- wireless-testing.orig/net/mac80211/mesh.h	2009-11-17 12:44:56.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.h	2009-11-17 12:45:03.000000000 +0100
@@ -220,7 +220,7 @@ struct mesh_rmc {
 /* Public interfaces */
 /* Various */
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
-		char *da, char *sa);
+				  const u8 *da, const u8 *sa);
 int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 		struct ieee80211_sub_if_data *sdata, char *addr4,
 		char *addr5, char *addr6);
@@ -284,7 +284,7 @@ u32 mesh_table_hash(u8 *addr, struct iee
 		struct mesh_table *tbl);
 /* Mesh paths */
 int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn, __le16 target_rcode,
-		u8 *ra, struct ieee80211_sub_if_data *sdata);
+		       const u8 *ra, struct ieee80211_sub_if_data *sdata);
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2009-11-17 12:44:56.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2009-11-17 12:45:03.000000000 +0100
@@ -101,10 +101,12 @@ enum mpath_frame_type {
 	MPATH_RANN
 };
 
+static const u8 broadcast_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		u8 *orig_addr, __le32 orig_sn, u8 target_flags, u8 *target,
-		__le32 target_sn, u8 *da, u8 hop_count, u8 ttl,__le32 lifetime,
-		__le32 metric, __le32 preq_id,
+		__le32 target_sn, const u8 *da, u8 hop_count, u8 ttl,
+		__le32 lifetime, __le32 metric, __le32 preq_id,
 		struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -198,8 +200,8 @@ static int mesh_path_sel_frame_tx(enum m
  * @ra: node this frame is addressed to
  */
 int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
-		__le16 target_rcode, u8 *ra,
-		struct ieee80211_sub_if_data *sdata)
+		       __le16 target_rcode, const u8 *ra,
+		       struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
@@ -548,7 +550,7 @@ static void hwmp_preq_frame_process(stru
 		hopcount = PREQ_IE_HOPCOUNT(preq_elem) + 1;
 		mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
 				cpu_to_le32(orig_sn), target_flags, target_addr,
-				cpu_to_le32(target_sn), sdata->dev->broadcast,
+				cpu_to_le32(target_sn), broadcast_addr,
 				hopcount, ttl, cpu_to_le32(lifetime),
 				cpu_to_le32(metric), cpu_to_le32(preq_id),
 				sdata);
@@ -660,7 +662,7 @@ static void hwmp_perr_frame_process(stru
 			spin_unlock_bh(&mpath->state_lock);
 			mesh_path_error_tx(ttl, target_addr, cpu_to_le32(target_sn),
 					   cpu_to_le16(target_rcode),
-					   sdata->dev->broadcast, sdata);
+					   broadcast_addr, sdata);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
 	}
@@ -709,7 +711,7 @@ static void hwmp_rann_frame_process(stru
 	if (mpath->sn < orig_sn) {
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
 				       cpu_to_le32(orig_sn),
-				       0, NULL, 0, sdata->dev->broadcast,
+				       0, NULL, 0, broadcast_addr,
 				       hopcount, ttl, 0,
 				       cpu_to_le32(metric + mpath->metric),
 				       0, sdata);
@@ -890,7 +892,7 @@ void mesh_path_start_discovery(struct ie
 	spin_unlock_bh(&mpath->state_lock);
 	mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->dev->dev_addr,
 			cpu_to_le32(ifmsh->sn), target_flags, mpath->dst,
-			cpu_to_le32(mpath->sn), sdata->dev->broadcast, 0,
+			cpu_to_le32(mpath->sn), broadcast_addr, 0,
 			ttl, cpu_to_le32(lifetime), 0,
 			cpu_to_le32(ifmsh->preq_id++), sdata);
 	mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
@@ -1011,6 +1013,6 @@ mesh_path_tx_root_frame(struct ieee80211
 
 	mesh_path_sel_frame_tx(MPATH_RANN, 0, sdata->dev->dev_addr,
 			       cpu_to_le32(++ifmsh->sn),
-			       0, NULL, 0, sdata->dev->broadcast,
+			       0, NULL, 0, broadcast_addr,
 			       0, MESH_TTL, 0, 0, 0, sdata);
 }
--- wireless-testing.orig/net/mac80211/mesh_pathtbl.c	2009-11-17 12:44:56.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_pathtbl.c	2009-11-17 12:45:03.000000000 +0100
@@ -449,6 +449,7 @@ err_path_alloc:
  */
 void mesh_plink_broken(struct sta_info *sta)
 {
+	static const u8 bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	struct hlist_node *p;
@@ -468,7 +469,7 @@ void mesh_plink_broken(struct sta_info *
 			mesh_path_error_tx(MESH_TTL, mpath->dst,
 					cpu_to_le32(mpath->sn),
 					PERR_RCODE_DEST_UNREACH,
-					sdata->dev->broadcast, sdata);
+					bcast, sdata);
 		} else
 		spin_unlock_bh(&mpath->state_lock);
 	}
--- wireless-testing.orig/net/mac80211/tkip.c	2009-11-17 12:44:56.000000000 +0100
+++ wireless-testing/net/mac80211/tkip.c	2009-11-17 12:45:03.000000000 +0100
@@ -301,9 +301,9 @@ int ieee80211_tkip_decrypt_data(struct c
 #endif
 		if (key->local->ops->update_tkip_key &&
 			key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
-			u8 bcast[ETH_ALEN] =
+			static const u8 bcast[ETH_ALEN] =
 				{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-			u8 *sta_addr = key->sta->sta.addr;
+			const u8 *sta_addr = key->sta->sta.addr;
 
 			if (is_multicast_ether_addr(ra))
 				sta_addr = bcast;
--- wireless-testing.orig/net/mac80211/mesh.c	2009-11-17 12:44:56.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.c	2009-11-17 12:45:03.000000000 +0100
@@ -394,8 +394,9 @@ void ieee80211_mesh_root_setup(struct ie
  *
  * Return the length of the 802.11 (does not include a mesh control header)
  */
-int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc, char
-		*meshda, char *meshsa) {
+int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
+				  const u8 *meshda, const u8 *meshsa)
+{
 	if (is_multicast_ether_addr(meshda)) {
 		*fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA TA SA */
--- wireless-testing.orig/net/mac80211/tx.c	2009-11-17 12:44:56.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-11-17 12:45:03.000000000 +0100
@@ -1684,21 +1684,25 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 			/* packet from other interface */
 			struct mesh_path *mppath;
 			int is_mesh_mcast = 1;
-			char *mesh_da;
+			const u8 *mesh_da;
 
 			rcu_read_lock();
 			if (is_multicast_ether_addr(skb->data))
 				/* DA TA mSA AE:SA */
 				mesh_da = skb->data;
 			else {
+				static const u8 bcast[ETH_ALEN] =
+					{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+
 				mppath = mpp_path_lookup(skb->data, sdata);
 				if (mppath) {
 					/* RA TA mDA mSA AE:DA SA */
 					mesh_da = mppath->mpp;
 					is_mesh_mcast = 0;
-				} else
+				} else {
 					/* DA TA mSA AE:SA */
-					mesh_da = dev->broadcast;
+					mesh_da = bcast;
+				}
 			}
 			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
 					mesh_da, dev->dev_addr);


