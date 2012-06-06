Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63510 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FFKVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:21:08 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so8594095dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 03:21:08 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH 3/4] mac80211: implement the proactive PREP generation
Date: Wed,  6 Jun 2012 18:20:38 +0800
Message-Id: <1338978039-4269-4-git-send-email-yeohchunyeow@gmail.com> (sfid-20120606_122112_803347_6F758DB2)
In-Reply-To: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
References: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generate the proactive PREP element in Proactive PREQ mode as defined in
Sec. 13.10.10.3 (Case D) of IEEE Std. 802.11-2012

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_hwmp.c |   34 ++++++++++++++++++++++++++++------
 1 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index b1e4399..d038767 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -529,10 +529,11 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	struct mesh_path *mpath = NULL;
 	u8 *target_addr, *orig_addr;
 	const u8 *da;
-	u8 target_flags, ttl;
+	u8 target_flags, ttl, flags;
 	u32 orig_sn, target_sn, lifetime;
 	bool reply = false;
 	bool forward = true;
+	bool root_is_gate;
 
 	/* Update target SN, if present */
 	target_addr = PREQ_IE_TARGET_ADDR(preq_elem);
@@ -540,6 +541,9 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	target_sn = PREQ_IE_TARGET_SN(preq_elem);
 	orig_sn = PREQ_IE_ORIG_SN(preq_elem);
 	target_flags = PREQ_IE_TARGET_F(preq_elem);
+	/* Proactive PREQ gate announcements */
+	flags = PREQ_IE_FLAGS(preq_elem);
+	root_is_gate = !!(flags & RANN_FLAG_IS_GATE);
 
 	mhwmp_dbg("received PREQ from %pM", orig_addr);
 
@@ -554,6 +558,15 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			target_sn = ++ifmsh->sn;
 			ifmsh->last_sn_update = jiffies;
 		}
+	} else if (is_broadcast_ether_addr(target_addr) &&
+			(target_flags & MP_F_DO)) {
+		mpath = mesh_path_lookup(orig_addr, sdata);
+		if (mpath) {
+			if (flags & PREQ_F_PREP)
+				reply = true;
+			if (root_is_gate)
+				mesh_path_add_gate(mpath);
+		}
 	} else {
 		rcu_read_lock();
 		mpath = mesh_path_lookup(target_addr, sdata);
@@ -581,11 +594,20 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		ttl = ifmsh->mshcfg.element_ttl;
 		if (ttl != 0) {
 			mhwmp_dbg("replying to the PREQ");
-			mesh_path_sel_frame_tx(MPATH_PREP, 0, orig_addr,
-				cpu_to_le32(orig_sn), 0, target_addr,
-				cpu_to_le32(target_sn), mgmt->sa, 0, ttl,
-				cpu_to_le32(lifetime), cpu_to_le32(metric),
-				0, sdata);
+			if (!is_broadcast_ether_addr(target_addr))
+				mesh_path_sel_frame_tx(MPATH_PREP, 0, orig_addr,
+				    cpu_to_le32(orig_sn), 0, target_addr,
+				    cpu_to_le32(target_sn), mgmt->sa, 0, ttl,
+				    cpu_to_le32(lifetime), cpu_to_le32(metric),
+				    0, sdata);
+			else {
+				mesh_path_sel_frame_tx(MPATH_PREP, 0, orig_addr,
+				    cpu_to_le32(orig_sn), 0, sdata->vif.addr,
+				    cpu_to_le32(++ifmsh->sn), mgmt->sa, 0, ttl,
+				    cpu_to_le32(lifetime), 0,
+				    0, sdata);
+				ifmsh->last_sn_update = jiffies;
+			}
 		} else
 			ifmsh->mshstats.dropped_frames_ttl++;
 	}
-- 
1.7.0.4

