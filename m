Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37416 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbdBNU10 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 15:27:26 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] mac80211: use DECLARE_EWMA for mesh_fail_avg
Date: Tue, 14 Feb 2017 12:27:16 -0800
Message-ID: <1487104037-24941-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20170214_212737_517697_097FB6E3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As moving average is not considering fractional part, it
will stuck at the same level after certain state. For example
with current values, moving average stuck at 96 and it will
not move forward. Fortunately current threshold is matching
against 95%. If thresold is increased more than 96, mesh path
never be deactivated under worst case. Fix failure average
movement by using EWMA helpers.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mesh_hwmp.c    | 21 +++++++++++++++------
 net/mac80211/mesh_pathtbl.c |  3 +++
 net/mac80211/sta_info.h     |  4 +++-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index b747c9645e43..d07ee3ca07ee 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -307,10 +307,11 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 
 	failed = !(txinfo->flags & IEEE80211_TX_STAT_ACK);
 
-	/* moving average, scaled to 100 */
-	sta->mesh->fail_avg =
-		((80 * sta->mesh->fail_avg + 5) / 100 + 20 * failed);
-	if (sta->mesh->fail_avg > 95)
+	/* moving average, scaled to 100.
+	 * feed failure as 100 and success as 0
+	 */
+	ewma_mesh_fail_avg_add(&sta->mesh->fail_avg, failed * 100);
+	if (ewma_mesh_fail_avg_read(&sta->mesh->fail_avg) > 95)
 		mesh_plink_broken(sta);
 }
 
@@ -325,6 +326,8 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	int rate, err;
 	u32 tx_time, estimated_retx;
 	u64 result;
+	unsigned long fail_avg =
+		ewma_mesh_fail_avg_read(&sta->mesh->fail_avg);
 
 	/* Try to get rate based on HW/SW RC algorithm.
 	 * Rate is returned in units of Kbps, correct this
@@ -336,7 +339,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	if (rate) {
 		err = 0;
 	} else {
-		if (sta->mesh->fail_avg >= 100)
+		if (fail_avg >= 100)
 			return MAX_METRIC;
 
 		sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
@@ -344,7 +347,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 		if (WARN_ON(!rate))
 			return MAX_METRIC;
 
-		err = (sta->mesh->fail_avg << ARITH_SHIFT) / 100;
+		err = (fail_avg << ARITH_SHIFT) / 100;
 	}
 
 	/* bitrate is in units of 100 Kbps, while we need rate in units of
@@ -484,6 +487,9 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 					  ?  mpath->exp_time : exp_time;
 			mesh_path_activate(mpath);
 			spin_unlock_bh(&mpath->state_lock);
+			ewma_mesh_fail_avg_init(&sta->mesh->fail_avg);
+			/* init it at a low value - 0 start is tricky */
+			ewma_mesh_fail_avg_add(&sta->mesh->fail_avg, 1);
 			mesh_path_tx_pending(mpath);
 			/* draft says preq_id should be saved to, but there does
 			 * not seem to be any use for it, skipping by now
@@ -522,6 +528,9 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 					  ?  mpath->exp_time : exp_time;
 			mesh_path_activate(mpath);
 			spin_unlock_bh(&mpath->state_lock);
+			ewma_mesh_fail_avg_init(&sta->mesh->fail_avg);
+			/* init it at a low value - 0 start is tricky */
+			ewma_mesh_fail_avg_add(&sta->mesh->fail_avg, 1);
 			mesh_path_tx_pending(mpath);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index f0e6175a9821..98a3b1c0c338 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -829,6 +829,9 @@ void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop)
 	mpath->flags = MESH_PATH_FIXED | MESH_PATH_SN_VALID;
 	mesh_path_activate(mpath);
 	spin_unlock_bh(&mpath->state_lock);
+	ewma_mesh_fail_avg_init(&next_hop->mesh->fail_avg);
+	/* init it at a low value - 0 start is tricky */
+	ewma_mesh_fail_avg_add(&next_hop->mesh->fail_avg, 1);
 	mesh_path_tx_pending(mpath);
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index dd06ef0b8861..d9010f29de3d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -322,6 +322,8 @@ struct ieee80211_fast_rx {
 	struct rcu_head rcu_head;
 };
 
+DECLARE_EWMA(mesh_fail_avg, 64, 8)
+
 /**
  * struct mesh_sta - mesh STA information
  * @plink_lock: serialize access to plink fields
@@ -367,7 +369,7 @@ struct mesh_sta {
 	enum nl80211_mesh_power_mode nonpeer_pm;
 
 	/* moving percentage of failed MSDUs */
-	unsigned int fail_avg;
+	struct ewma_mesh_fail_avg fail_avg;
 };
 
 DECLARE_EWMA(signal, 1024, 8)
-- 
1.9.1
