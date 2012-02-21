Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46901 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2BUKKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 05:10:55 -0500
Received: by pbcun15 with SMTP id un15so7223879pbc.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 02:10:55 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: Fix the generation of PREQs in proactive RANN mechanism of HWMP
Date: Wed, 22 Feb 2012 02:53:02 +0800
Message-Id: <1329850383-31837-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120221_111059_221384_A2F274D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to Section Y.7.4 Actions on receipt of proactive RANN, an individually
addressed PREQ should be generated towards the neighbor peer mesh STA indicated
in the RANN Sender Address field in the forwarding information.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh.h      |    4 ++++
 net/mac80211/mesh_hwmp.c |   28 +++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index bd14bd2..4b0a9e8 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -86,6 +86,8 @@ enum mesh_deferred_task_flags {
  * @state_lock: mesh path state lock used to protect changes to the
  * mpath itself.  No need to take this lock when adding or removing
  * an mpath to a hash bucket on a path table.
+ * @rann_snd_addr: the RANN sender address
+ * @is_root: the destination station of this path is a root node
  * @is_gate: the destination station of this path is a mesh gate
  *
  *
@@ -110,6 +112,8 @@ struct mesh_path {
 	u8 discovery_retries;
 	enum mesh_path_flags flags;
 	spinlock_t state_lock;
+	u8 rann_snd_addr[ETH_ALEN];
+	bool is_root;
 	bool is_gate;
 };
 
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index cae4071..e228670 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -590,12 +590,22 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		flags = PREQ_IE_FLAGS(preq_elem);
 		preq_id = PREQ_IE_PREQ_ID(preq_elem);
 		hopcount = PREQ_IE_HOPCOUNT(preq_elem) + 1;
+		if (mpath && mpath->is_root) {
+			mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
+				cpu_to_le32(orig_sn), target_flags, target_addr,
+				cpu_to_le32(target_sn), mpath->rann_snd_addr,
+				hopcount, ttl, cpu_to_le32(lifetime),
+				cpu_to_le32(metric), cpu_to_le32(preq_id),
+				sdata);
+			goto endpreq;
+		}
 		mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
 				cpu_to_le32(orig_sn), target_flags, target_addr,
 				cpu_to_le32(target_sn), broadcast_addr,
 				hopcount, ttl, cpu_to_le32(lifetime),
 				cpu_to_le32(metric), cpu_to_le32(preq_id),
 				sdata);
+endpreq:
 		ifmsh->mshstats.fwded_mcast++;
 		ifmsh->mshstats.fwded_frames++;
 	}
@@ -741,8 +751,8 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	if (memcmp(orig_addr, sdata->vif.addr, ETH_ALEN) == 0)
 		return;
 
-	mhwmp_dbg("received RANN from %pM (is_gate=%d)", orig_addr,
-			root_is_gate);
+	mhwmp_dbg("received RANN from %pM via neighbour %pM (is_gate=%d)",
+			orig_addr, mgmt->sa, root_is_gate);
 
 	rcu_read_lock();
 	mpath = mesh_path_lookup(orig_addr, sdata);
@@ -773,6 +783,11 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 				       0, sdata);
 		mpath->sn = orig_sn;
 	}
+
+	/* Using individually addressed PREQ for root node */
+	memcpy(mpath->rann_snd_addr, mgmt->sa, ETH_ALEN);
+	mpath->is_root = true;
+
 	if (root_is_gate)
 		mesh_path_add_gate(mpath);
 
@@ -970,11 +985,18 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 		target_flags = MP_F_RF;
 
 	spin_unlock_bh(&mpath->state_lock);
-	mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->vif.addr,
+	if (!mpath->is_root)
+		mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->vif.addr,
 			cpu_to_le32(ifmsh->sn), target_flags, mpath->dst,
 			cpu_to_le32(mpath->sn), broadcast_addr, 0,
 			ttl, cpu_to_le32(lifetime), 0,
 			cpu_to_le32(ifmsh->preq_id++), sdata);
+	else
+		mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->vif.addr,
+			cpu_to_le32(ifmsh->sn), target_flags, mpath->dst,
+			cpu_to_le32(mpath->sn), mpath->rann_snd_addr, 0,
+			ttl, cpu_to_le32(lifetime), 0,
+			cpu_to_le32(ifmsh->preq_id++), sdata);
 	mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
 
 enddiscovery:
-- 
1.7.0.4

