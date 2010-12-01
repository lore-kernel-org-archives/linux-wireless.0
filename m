Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab0LAU26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 15:28:58 -0500
Subject: [PATCH/RFC] mac80211: use configured mesh TTL
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimgfRvqp=-CDU=G8o-ZfD4fVbf3j-AdXCVtoM6c@mail.gmail.com>
References: <1291168735-3423-1-git-send-email-javier@cozybit.com>
	 <1291184383.4199.4.camel@jlt3.sipsolutions.net>
	 <AANLkTikMex0A91Qy=5EwPAEfVWKDVz4_mneWnCvy3soR@mail.gmail.com>
	 <1291229642.4199.11.camel@jlt3.sipsolutions.net>
	 <1291232151.4199.12.camel@jlt3.sipsolutions.net>
	 <AANLkTimgfRvqp=-CDU=G8o-ZfD4fVbf3j-AdXCVtoM6c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 21:28:57 +0100
Message-ID: <1291235337.4199.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It seems the configured mesh TTL should be used,
not the default value.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_pathtbl.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/mesh_pathtbl.c	2010-12-01 21:26:47.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_pathtbl.c	2010-12-01 21:27:42.000000000 +0100
@@ -467,8 +467,8 @@ void mesh_plink_broken(struct sta_info *
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			++mpath->sn;
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_error_tx(MESH_TTL, mpath->dst,
-					cpu_to_le32(mpath->sn),
+			mesh_path_error_tx(sdata->u.mesh.mshcfg.dot11MeshTTL,
+					mpath->dst, cpu_to_le32(mpath->sn),
 					cpu_to_le16(PERR_RCODE_DEST_UNREACH),
 					bcast, sdata);
 		} else
@@ -614,7 +614,8 @@ void mesh_path_discard_frame(struct sk_b
 		mpath = mesh_path_lookup(da, sdata);
 		if (mpath)
 			sn = ++mpath->sn;
-		mesh_path_error_tx(MESH_TTL, skb->data, cpu_to_le32(sn),
+		mesh_path_error_tx(sdata->u.mesh.mshcfg.dot11MeshTTL, skb->data,
+				   cpu_to_le32(sn),
 				   cpu_to_le16(PERR_RCODE_NO_ROUTE), ra, sdata);
 	}
 


