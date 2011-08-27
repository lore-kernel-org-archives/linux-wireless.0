Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39904 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1H0AS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 20:18:27 -0400
Received: by gxk21 with SMTP id 21so3308768gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 17:18:27 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2 1/8] mac80211: Fix RCU pointer dereference in mesh_path_discard_frame()
Date: Fri, 26 Aug 2011 17:18:07 -0700
Message-Id: <1314404294-4233-2-git-send-email-javier@cozybit.com> (sfid-20110827_021830_741207_B46A99B1)
In-Reply-To: <1314404294-4233-1-git-send-email-javier@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
 <1314404294-4233-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported by Pedro Larbig (ASPj)

Signed-off-by: Javier Cardona <javier@cozybit.com>

---
v2: - Extend the rcu_read_lock section to protect mpath (Johannes)
    - Take state lock when increasing mpath serial number (Johannes)
 net/mac80211/mesh_pathtbl.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3c2bcb2..c92fd70 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -991,9 +991,14 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 
 		da = hdr->addr3;
 		ra = hdr->addr1;
+		rcu_read_lock();
 		mpath = mesh_path_lookup(da, sdata);
-		if (mpath)
+		if (mpath) {
+			spin_lock_bh(&mpath->state_lock);
 			sn = ++mpath->sn;
+			spin_unlock_bh(&mpath->state_lock);
+		}
+		rcu_read_unlock();
 		mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl, skb->data,
 				   cpu_to_le32(sn), reason, ra, sdata);
 	}
-- 
1.7.6

