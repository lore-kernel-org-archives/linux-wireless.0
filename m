Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48375 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1HYBlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:41:20 -0400
Received: by mail-yw0-f46.google.com with SMTP id 7so1335324ywf.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:41:20 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 5/9] mac80211: Remove redundant mesh path expiration checks
Date: Wed, 24 Aug 2011 18:40:48 -0700
Message-Id: <1314236452-7226-6-git-send-email-thomas@cozybit.com> (sfid-20110825_034122_637073_68ECC5AF)
In-Reply-To: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3c96e55..562b150 100644
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
1.7.4.1

