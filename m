Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52134 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab1H2UXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 16:23:24 -0400
Received: by gya6 with SMTP id 6so5097515gya.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 13:23:23 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v3 4/7] mac80211: Remove redundant mesh path expiration checks
Date: Mon, 29 Aug 2011 13:23:06 -0700
Message-Id: <1314649389-7115-5-git-send-email-javier@cozybit.com> (sfid-20110829_222329_097747_F053B050)
In-Reply-To: <1314649389-7115-1-git-send-email-javier@cozybit.com>
References: <1314649389-7115-1-git-send-email-javier@cozybit.com>
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

