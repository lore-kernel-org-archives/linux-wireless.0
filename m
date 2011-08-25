Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53054 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab1HYRgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 13:36:22 -0400
Received: by gxk21 with SMTP id 21so1945941gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 10:36:21 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH] mac80211: mesh gate fixes
Date: Thu, 25 Aug 2011 10:36:14 -0700
Message-Id: <1314293774-18689-1-git-send-email-thomas@cozybit.com> (sfid-20110825_193625_585980_7378B5F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since a v1 of the mesh gate series was accidentally applied, this patch
contains the changes in v2.

These are:
	- automatically make mesh gate a root node.
	- use TU_TO_EXP_TIME macro.
	- initialize timer instead of checking for NULL timer function.
	- cleanups.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

John,

Please drop the 'FIXUP: mesh gates' series and apply this patch instead if it
is alright with you.

Thomas

 net/mac80211/cfg.c          |    8 ++++++++
 net/mac80211/mesh.c         |    4 ++--
 net/mac80211/mesh_pathtbl.c |   10 ++++------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7d17a91..6ab67ab 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1138,6 +1138,14 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		ieee80211_mesh_root_setup(ifmsh);
 	}
 	if (_chg_mesh_attr(NL80211_MESHCONF_GATE_ANNOUNCEMENTS, mask)) {
+		/* our current gate announcement implementation rides on root
+		 * announcements, so require this ifmsh to also be a root node
+		 * */
+		if (nconf->dot11MeshGateAnnouncementProtocol &&
+		    !conf->dot11MeshHWMPRootMode) {
+			conf->dot11MeshHWMPRootMode = 1;
+			ieee80211_mesh_root_setup(ifmsh);
+		}
 		conf->dot11MeshGateAnnouncementProtocol =
 			nconf->dot11MeshGateAnnouncementProtocol;
 	}
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1c4f53c..28ab510 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -537,8 +537,8 @@ static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
 
 	mesh_path_tx_root_frame(sdata);
 	mod_timer(&ifmsh->mesh_path_root_timer,
-		  round_jiffies(jiffies +
-			  usecs_to_jiffies(ifmsh->mshcfg.dot11MeshHWMPRannInterval * 1024)));
+		  round_jiffies(TU_TO_EXP_TIME(
+				  ifmsh->mshcfg.dot11MeshHWMPRannInterval)));
 }
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 75e4b60..3c2bcb2 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -288,7 +288,7 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 				    struct mesh_path *from_mpath,
 				    bool copy)
 {
-	struct sk_buff *skb, *cp_skb;
+	struct sk_buff *skb, *cp_skb = NULL;
 	struct sk_buff_head gateq, failq;
 	unsigned long flags;
 	int num_skbs;
@@ -711,6 +711,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	new_mpath->flags = 0;
 	skb_queue_head_init(&new_mpath->frame_queue);
 	new_node->mpath = new_mpath;
+	init_timer(&new_mpath->timer);
 	new_mpath->exp_time = jiffies;
 	spin_lock_init(&new_mpath->state_lock);
 
@@ -843,8 +844,7 @@ static void mesh_path_node_reclaim(struct rcu_head *rp)
 	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
 	struct ieee80211_sub_if_data *sdata = node->mpath->sdata;
 
-	if (node->mpath->timer.function)
-		del_timer_sync(&node->mpath->timer);
+	del_timer_sync(&node->mpath->timer);
 	atomic_dec(&sdata->u.mesh.mpaths);
 	kfree(node->mpath);
 	kfree(node);
@@ -1046,8 +1046,7 @@ static void mesh_path_node_free(struct hlist_node *p, bool free_leafs)
 	mpath = node->mpath;
 	hlist_del_rcu(p);
 	if (free_leafs) {
-		if (mpath->timer.function)
-			del_timer_sync(&mpath->timer);
+		del_timer_sync(&mpath->timer);
 		kfree(mpath);
 	}
 	kfree(node);
@@ -1094,7 +1093,6 @@ int mesh_pathtbl_init(void)
 	tbl_mpp->free_node = &mesh_path_node_free;
 	tbl_mpp->copy_node = &mesh_path_node_copy;
 	tbl_mpp->mean_chain_len = MEAN_CHAIN_LEN;
-	/* XXX: not needed */
 	tbl_mpp->known_gates = kzalloc(sizeof(struct hlist_head), GFP_ATOMIC);
 	INIT_HLIST_HEAD(tbl_mpp->known_gates);
 
-- 
1.7.4.1

