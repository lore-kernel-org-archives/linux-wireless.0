Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35910 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZKSPtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 10:49:09 -0500
Received: by ewy19 with SMTP id 19so12480ewy.21
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2009 07:49:13 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>
Subject: [PATCH] mac80211: fix endianess on mesh_path_error_tx() calls
Date: Thu, 19 Nov 2009 15:49:10 +0000
Message-Id: <1258645750-29740-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rui Paulo <rpaulo@gmail.com>
---
 net/mac80211/mesh_pathtbl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3fbabbf..a8da239 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -468,7 +468,7 @@ void mesh_plink_broken(struct sta_info *sta)
 			spin_unlock_bh(&mpath->state_lock);
 			mesh_path_error_tx(MESH_TTL, mpath->dst,
 					cpu_to_le32(mpath->sn),
-					PERR_RCODE_DEST_UNREACH,
+					cpu_to_le16(PERR_RCODE_DEST_UNREACH),
 					bcast, sdata);
 		} else
 		spin_unlock_bh(&mpath->state_lock);
@@ -614,7 +614,7 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 		if (mpath)
 			sn = ++mpath->sn;
 		mesh_path_error_tx(MESH_TTL, skb->data, cpu_to_le32(sn),
-				   PERR_RCODE_NO_ROUTE, ra, sdata);
+				   cpu_to_le16(PERR_RCODE_NO_ROUTE), ra, sdata);
 	}
 
 	kfree_skb(skb);
-- 
1.5.6.5

