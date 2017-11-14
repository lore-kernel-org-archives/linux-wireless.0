Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:48688 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755199AbdKNPUR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 10:20:17 -0500
Received: by mail-pf0-f194.google.com with SMTP id r62so2052638pfd.5
        for <linux-wireless@vger.kernel.org>; Tue, 14 Nov 2017 07:20:17 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: fix the update of path metric for RANN frame
Date: Tue, 14 Nov 2017 23:20:05 +0800
Message-Id: <1510672805-32594-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20171114_162020_781664_38D2C7BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous path metric update from RANN frame has not considered
the own link metric toward the transmitting mesh STA. Fix this.

Reported-by: Michael65535
Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_hwmp.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index c1d1b86..35ad398 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -797,7 +797,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	struct mesh_path *mpath;
 	u8 ttl, flags, hopcount;
 	const u8 *orig_addr;
-	u32 orig_sn, metric, metric_txsta, interval;
+	u32 orig_sn, new_metric, orig_metric, last_hop_metric, interval;
 	bool root_is_gate;
 
 	ttl = rann->rann_ttl;
@@ -808,7 +808,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	interval = le32_to_cpu(rann->rann_interval);
 	hopcount = rann->rann_hopcount;
 	hopcount++;
-	metric = le32_to_cpu(rann->rann_metric);
+	orig_metric = le32_to_cpu(rann->rann_metric);
 
 	/*  Ignore our own RANNs */
 	if (ether_addr_equal(orig_addr, sdata->vif.addr))
@@ -825,7 +825,10 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	metric_txsta = airtime_link_metric_get(local, sta);
+	last_hop_metric = airtime_link_metric_get(local, sta);
+	new_metric = orig_metric + last_hop_metric;
+	if (new_metric < orig_metric)
+		new_metric = MAX_METRIC;
 
 	mpath = mesh_path_lookup(sdata, orig_addr);
 	if (!mpath) {
@@ -838,7 +841,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (!(SN_LT(mpath->sn, orig_sn)) &&
-	    !(mpath->sn == orig_sn && metric < mpath->rann_metric)) {
+	    !(mpath->sn == orig_sn && new_metric < mpath->rann_metric)) {
 		rcu_read_unlock();
 		return;
 	}
@@ -856,7 +859,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	}
 
 	mpath->sn = orig_sn;
-	mpath->rann_metric = metric + metric_txsta;
+	mpath->rann_metric = new_metric;
 	mpath->is_root = true;
 	/* Recording RANNs sender address to send individually
 	 * addressed PREQs destined for root mesh STA */
@@ -876,7 +879,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
 				       orig_sn, 0, NULL, 0, broadcast_addr,
 				       hopcount, ttl, interval,
-				       metric + metric_txsta, 0, sdata);
+				       new_metric, 0, sdata);
 	}
 
 	rcu_read_unlock();
-- 
2.3.0
