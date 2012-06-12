Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44444 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2FLHvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 03:51:52 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6514254dad.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 00:51:52 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v3 3/4] mac80211: implement the proactive PREP generation
Date: Tue, 12 Jun 2012 15:50:44 +0800
Message-Id: <1339487445-25428-4-git-send-email-yeohchunyeow@gmail.com> (sfid-20120612_095155_207033_A3F0E980)
In-Reply-To: <1339487445-25428-1-git-send-email-yeohchunyeow@gmail.com>
References: <1339487445-25428-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generate the proactive PREP element in Proactive PREQ mode as defined in
Sec. 13.10.10.3 (Case D) of IEEE Std. 802.11-2012.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2: adhere to Linux kernel coding style (Johannes)
v3: eliminate 4 spaces indentation (Johannes)

 net/mac80211/mesh_hwmp.c |   35 ++++++++++++++++++++++++++++++++---
 1 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 3ce131b..1d2a122 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -519,10 +519,11 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	struct mesh_path *mpath = NULL;
 	u8 *target_addr, *orig_addr;
 	const u8 *da;
-	u8 target_flags, ttl;
-	u32 orig_sn, target_sn, lifetime;
+	u8 target_flags, ttl, flags;
+	u32 orig_sn, target_sn, lifetime, orig_metric;
 	bool reply = false;
 	bool forward = true;
+	bool root_is_gate;
 
 	/* Update target SN, if present */
 	target_addr = PREQ_IE_TARGET_ADDR(preq_elem);
@@ -530,6 +531,10 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	target_sn = PREQ_IE_TARGET_SN(preq_elem);
 	orig_sn = PREQ_IE_ORIG_SN(preq_elem);
 	target_flags = PREQ_IE_TARGET_F(preq_elem);
+	orig_metric = metric;
+	/* Proactive PREQ gate announcements */
+	flags = PREQ_IE_FLAGS(preq_elem);
+	root_is_gate = !!(flags & RANN_FLAG_IS_GATE);
 
 	mhwmp_dbg("received PREQ from %pM", orig_addr);
 
@@ -544,6 +549,22 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			target_sn = ++ifmsh->sn;
 			ifmsh->last_sn_update = jiffies;
 		}
+	} else if (is_broadcast_ether_addr(target_addr) &&
+		   (target_flags & TO_FLAG)) {
+		rcu_read_lock();
+		mpath = mesh_path_lookup(orig_addr, sdata);
+		if (mpath) {
+			if (flags & PROACTIVE_PREP_FLAG) {
+				reply = true;
+				target_addr = sdata->vif.addr;
+				target_sn = ++ifmsh->sn;
+				metric = 0;
+				ifmsh->last_sn_update = jiffies;
+			}
+			if (root_is_gate)
+				mesh_path_add_gate(mpath);
+		}
+		rcu_read_unlock();
 	} else {
 		rcu_read_lock();
 		mpath = mesh_path_lookup(target_addr, sdata);
@@ -576,8 +597,9 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				cpu_to_le32(target_sn), mgmt->sa, 0, ttl,
 				cpu_to_le32(lifetime), cpu_to_le32(metric),
 				0, sdata);
-		} else
+		} else {
 			ifmsh->mshstats.dropped_frames_ttl++;
+		}
 	}
 
 	if (forward && ifmsh->mshcfg.dot11MeshForwarding) {
@@ -597,6 +619,13 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		hopcount = PREQ_IE_HOPCOUNT(preq_elem) + 1;
 		da = (mpath && mpath->is_root) ?
 			mpath->rann_snd_addr : broadcast_addr;
+
+		if (flags & PROACTIVE_PREP_FLAG) {
+			target_addr = PREQ_IE_TARGET_ADDR(preq_elem);
+			target_sn = PREQ_IE_TARGET_SN(preq_elem);
+			metric = orig_metric;
+		}
+
 		mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
 				cpu_to_le32(orig_sn), target_flags, target_addr,
 				cpu_to_le32(target_sn), da,
-- 
1.7.0.4

