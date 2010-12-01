Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab0LAVDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 16:03:12 -0500
Message-Id: <20101201210225.338244440@sipsolutions.net>
Date: Wed, 01 Dec 2010 21:59:40 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org
Subject: [RFC 1/5] mac80211: use configured mesh TTL
References: <20101201205939.009530439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It seems the configured mesh TTL should be used,
not the default value.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.h         |    2 ++
 net/mac80211/mesh_hwmp.c    |    5 +++--
 net/mac80211/mesh_pathtbl.c |    5 +++--
 3 files changed, 8 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/mesh_pathtbl.c	2010-12-01 21:46:30.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_pathtbl.c	2010-12-01 21:58:56.000000000 +0100
@@ -467,7 +467,7 @@ void mesh_plink_broken(struct sta_info *
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			++mpath->sn;
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_error_tx(MESH_TTL, mpath->dst,
+			mesh_path_error_tx(MESH_DEFAULT_ELEMENT_TTL, mpath->dst,
 					cpu_to_le32(mpath->sn),
 					cpu_to_le16(PERR_RCODE_DEST_UNREACH),
 					bcast, sdata);
@@ -614,7 +614,8 @@ void mesh_path_discard_frame(struct sk_b
 		mpath = mesh_path_lookup(da, sdata);
 		if (mpath)
 			sn = ++mpath->sn;
-		mesh_path_error_tx(MESH_TTL, skb->data, cpu_to_le32(sn),
+		mesh_path_error_tx(MESH_DEFAULT_ELEMENT_TTL, skb->data,
+				   cpu_to_le32(sn),
 				   cpu_to_le16(PERR_RCODE_NO_ROUTE), ra, sdata);
 	}
 
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2010-12-01 21:46:30.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2010-12-01 21:49:23.000000000 +0100
@@ -232,7 +232,7 @@ int mesh_path_error_tx(u8 ttl, u8 *targe
 	*pos++ = WLAN_EID_PERR;
 	*pos++ = ie_len;
 	/* ttl */
-	*pos++ = MESH_TTL;
+	*pos++ = ttl;
 	/* number of destinations */
 	*pos++ = 1;
 	/*
@@ -1013,5 +1013,6 @@ mesh_path_tx_root_frame(struct ieee80211
 	mesh_path_sel_frame_tx(MPATH_RANN, 0, sdata->vif.addr,
 			       cpu_to_le32(++ifmsh->sn),
 			       0, NULL, 0, broadcast_addr,
-			       0, MESH_TTL, 0, 0, 0, sdata);
+			       0, sdata->u.mesh.mshcfg.dot11MeshTTL,
+			       0, 0, 0, sdata);
 }
--- wireless-testing.orig/net/mac80211/mesh.h	2010-12-01 21:57:44.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.h	2010-12-01 21:58:01.000000000 +0100
@@ -216,6 +216,8 @@ struct mesh_rmc {
 #define PERR_RCODE_NO_ROUTE     12
 #define PERR_RCODE_DEST_UNREACH 13
 
+#define MESH_DEFAULT_ELEMENT_TTL 31
+
 /* Public interfaces */
 /* Various */
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,


