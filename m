Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49681 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2FOCV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 22:21:26 -0400
Received: by yhmm54 with SMTP id m54so2100466yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 19:21:25 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: fix and improve mesh RANN processing
Date: Fri, 15 Jun 2012 10:20:02 +0800
Message-Id: <1339726802-14441-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120615_042130_403599_2E22BADB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the problem of dropping RANN element if the TTL
is 1. If the received RANN element TTL is 1 or greater than 1, the
RANN is processed. However, forwarding of received RANN element
with TTL 1 or less is prohibited according to the standard. This
is previously reported by Monthadar Al Jaberi.

Besides, this patch also avoid the processing of unicast PREQ
generation if the RANN element does not meet the acceptance
criteria mentioned in Sec. 13.10.12.4.2 of IEEE Std. 802.11-2012.

Reported-by: Monthadar Al Jaberi <monthadar@gmail.com>
Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_hwmp.c |   43 +++++++++++++++++++++++++------------------
 1 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 616c940..d0e925d 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -772,11 +772,6 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	bool root_is_gate;
 
 	ttl = rann->rann_ttl;
-	if (ttl <= 1) {
-		ifmsh->mshstats.dropped_frames_ttl++;
-		return;
-	}
-	ttl--;
 	flags = rann->rann_flags;
 	root_is_gate = !!(flags & RANN_FLAG_IS_GATE);
 	orig_addr = rann->rann_addr;
@@ -813,37 +808,49 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	if (!(SN_LT(mpath->sn, orig_sn)) &&
+	    !(mpath->sn == orig_sn && metric < mpath->rann_metric)) {
+		rcu_read_unlock();
+		return;
+	}
+
 	if ((!(mpath->flags & (MESH_PATH_ACTIVE | MESH_PATH_RESOLVING)) ||
 	     (time_after(jiffies, mpath->last_preq_to_root +
 				  root_path_confirmation_jiffies(sdata)) ||
 	     time_before(jiffies, mpath->last_preq_to_root))) &&
-	     !(mpath->flags & MESH_PATH_FIXED)) {
+	     !(mpath->flags & MESH_PATH_FIXED) && (ttl != 0)) {
 		mhwmp_dbg("%s time to refresh root mpath %pM", sdata->name,
 							       orig_addr);
 		mesh_queue_preq(mpath, PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 		mpath->last_preq_to_root = jiffies;
 	}
 
-	if ((SN_LT(mpath->sn, orig_sn) || (mpath->sn == orig_sn &&
-	   metric < mpath->rann_metric)) && ifmsh->mshcfg.dot11MeshForwarding) {
+	mpath->sn = orig_sn;
+	mpath->rann_metric = metric + metric_txsta;
+	mpath->is_root = true;
+	/* Recording RANNs sender address to send individually
+	 * addressed PREQs destined for root mesh STA */
+	memcpy(mpath->rann_snd_addr, mgmt->sa, ETH_ALEN);
+
+	if (root_is_gate)
+		mesh_path_add_gate(mpath);
+
+	if (ttl <= 1) {
+		ifmsh->mshstats.dropped_frames_ttl++;
+		rcu_read_unlock();
+		return;
+	}
+	ttl--;
+
+	if (ifmsh->mshcfg.dot11MeshForwarding) {
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
 				       cpu_to_le32(orig_sn),
 				       0, NULL, 0, broadcast_addr,
 				       hopcount, ttl, cpu_to_le32(interval),
 				       cpu_to_le32(metric + metric_txsta),
 				       0, sdata);
-		mpath->sn = orig_sn;
-		mpath->rann_metric = metric + metric_txsta;
-		/* Recording RANNs sender address to send individually
-		 * addressed PREQs destined for root mesh STA */
-		memcpy(mpath->rann_snd_addr, mgmt->sa, ETH_ALEN);
 	}
 
-	mpath->is_root = true;
-
-	if (root_is_gate)
-		mesh_path_add_gate(mpath);
-
 	rcu_read_unlock();
 }
 
-- 
1.7.0.4

