Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:52194 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1HIXq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 19:46:27 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so23646iye.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 16:46:27 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 3/8] mac80211: mesh locking fixes
Date: Tue,  9 Aug 2011 16:45:06 -0700
Message-Id: <1312933511-9486-4-git-send-email-thomas@cozybit.com> (sfid-20110810_014631_321543_2FD662C5)
In-Reply-To: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

mesh_queue_preq is invoked invoked from both user (work queue) and
softirq (timer) context, so the _bh version of spinlock needs to be
used. Also, the mpath->state_lock should be softirq safe as well.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 89f469b..b4480a9 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -654,12 +654,12 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
 		    memcmp(addr, mpath->dst, ETH_ALEN) == 0) {
-			spin_lock(&mpath->state_lock);
+			spin_lock_bh(&mpath->state_lock);
 			mpath->flags |= MESH_PATH_RESOLVING;
 			hlist_del_rcu(&node->list);
 			call_rcu(&node->rcu, mesh_path_node_reclaim);
 			atomic_dec(&tbl->entries);
-			spin_unlock(&mpath->state_lock);
+			spin_unlock_bh(&mpath->state_lock);
 			goto enddel;
 		}
 	}
-- 
1.7.6

