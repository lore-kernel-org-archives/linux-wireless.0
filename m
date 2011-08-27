Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49718 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1H0ASh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 20:18:37 -0400
Received: by ywf7 with SMTP id 7so3294733ywf.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 17:18:37 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2 4/8] mac80211: Remove redundant mesh path expiration checks
Date: Fri, 26 Aug 2011 17:18:10 -0700
Message-Id: <1314404294-4233-5-git-send-email-javier@cozybit.com> (sfid-20110827_021840_481505_F8620DB2)
In-Reply-To: <1314404294-4233-1-git-send-email-javier@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
 <1314404294-4233-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index b895a7c..598249e 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -359,8 +359,7 @@ struct mesh_path *mesh_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
 				memcmp(dst, mpath->dst, ETH_ALEN) == 0) {
 			if (MPATH_EXPIRED(mpath)) {
 				spin_lock_bh(&mpath->state_lock);
-				if (MPATH_EXPIRED(mpath))
-					mpath->flags &= ~MESH_PATH_ACTIVE;
+				mpath->flags &= ~MESH_PATH_ACTIVE;
 				spin_unlock_bh(&mpath->state_lock);
 			}
 			return mpath;
@@ -386,8 +385,7 @@ struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
 		    memcmp(dst, mpath->dst, ETH_ALEN) == 0) {
 			if (MPATH_EXPIRED(mpath)) {
 				spin_lock_bh(&mpath->state_lock);
-				if (MPATH_EXPIRED(mpath))
-					mpath->flags &= ~MESH_PATH_ACTIVE;
+				mpath->flags &= ~MESH_PATH_ACTIVE;
 				spin_unlock_bh(&mpath->state_lock);
 			}
 			return mpath;
@@ -420,8 +418,7 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data
 		if (j++ == idx) {
 			if (MPATH_EXPIRED(node->mpath)) {
 				spin_lock_bh(&node->mpath->state_lock);
-				if (MPATH_EXPIRED(node->mpath))
-					node->mpath->flags &= ~MESH_PATH_ACTIVE;
+				node->mpath->flags &= ~MESH_PATH_ACTIVE;
 				spin_unlock_bh(&node->mpath->state_lock);
 			}
 			return node->mpath;
-- 
1.7.6

