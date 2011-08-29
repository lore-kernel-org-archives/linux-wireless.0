Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33745 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab1H2UXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 16:23:21 -0400
Received: by ywf7 with SMTP id 7so5057048ywf.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 13:23:20 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v3 1/7] mac80211: Fix RCU pointer dereference in mesh_path_discard_frame()
Date: Mon, 29 Aug 2011 13:23:03 -0700
Message-Id: <1314649389-7115-2-git-send-email-javier@cozybit.com> (sfid-20110829_222324_941937_BF94E56E)
In-Reply-To: <1314649389-7115-1-git-send-email-javier@cozybit.com>
References: <1314649389-7115-1-git-send-email-javier@cozybit.com>
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

