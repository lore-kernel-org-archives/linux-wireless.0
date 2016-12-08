Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34946 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932967AbcLHBQM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 20:16:12 -0500
Received: by mail-pg0-f68.google.com with SMTP id p66so25071118pga.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 17:16:05 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net, me@bobcopeland.com
Cc: linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH v2 2/2] mac80211: Use appropriate name for functions and messages
Date: Thu,  8 Dec 2016 10:15:51 +0900
Message-Id: <1481159751-4097-2-git-send-email-masashi.honma@gmail.com> (sfid-20161208_021621_317014_01530350)
In-Reply-To: <1481159751-4097-1-git-send-email-masashi.honma@gmail.com>
References: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
 <1481159751-4097-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions drifts TSF timers, not TBTT.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/mesh.c        |  2 +-
 net/mac80211/mesh.h        |  2 +-
 net/mac80211/mesh_sync.c   | 16 ++++++++--------
 net/mac80211/tx.c          |  2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d37a577..94b2c9e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -624,8 +624,8 @@ struct ieee80211_mesh_sync_ops {
 			     struct ieee80211_rx_status *rx_status);
 
 	/* should be called with beacon_data under RCU read lock */
-	void (*adjust_tbtt)(struct ieee80211_sub_if_data *sdata,
-			    struct beacon_data *beacon);
+	void (*adjust_tsf)(struct ieee80211_sub_if_data *sdata,
+			   struct beacon_data *beacon);
 	/* add other framework functions here */
 };
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 42120d9..a6b43e4 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1349,7 +1349,7 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 		ieee80211_mesh_rootpath(sdata);
 
 	if (test_and_clear_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags))
-		mesh_sync_adjust_tbtt(sdata);
+		mesh_sync_adjust_tsf(sdata);
 
 	if (test_and_clear_bit(MESH_WORK_MBSS_CHANGED, &ifmsh->wrkq_flags))
 		mesh_bss_info_changed(sdata);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 26b9ccb..7e5f271 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -341,7 +341,7 @@ static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 }
 
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
-void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata);
+void mesh_sync_adjust_tsf(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_stop(void);
 #else
 static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 75608c0..a435f09 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -12,7 +12,7 @@
 #include "mesh.h"
 #include "driver-ops.h"
 
-/* This is not in the standard.  It represents a tolerable tbtt drift below
+/* This is not in the standard.  It represents a tolerable tsf drift below
  * which we do no TSF adjustment.
  */
 #define TOFFSET_MINIMUM_ADJUSTMENT 10
@@ -46,7 +46,7 @@ static bool mesh_peer_tbtt_adjusting(struct ieee802_11_elems *ie)
 			IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING) != 0;
 }
 
-void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
+void mesh_sync_adjust_tsf(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
@@ -57,12 +57,12 @@ void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 
 	spin_lock_bh(&ifmsh->sync_offset_lock);
 	if (ifmsh->sync_offset_clockdrift_max < beacon_int_fraction) {
-		msync_dbg(sdata, "TBTT : max clockdrift=%lld; adjusting\n",
+		msync_dbg(sdata, "TSF : max clockdrift=%lld; adjusting\n",
 			  (long long) ifmsh->sync_offset_clockdrift_max);
 		tsfdelta = -ifmsh->sync_offset_clockdrift_max;
 		ifmsh->sync_offset_clockdrift_max = 0;
 	} else {
-		msync_dbg(sdata, "TBTT : max clockdrift=%lld; adjusting by %llu\n",
+		msync_dbg(sdata, "TSF : max clockdrift=%lld; adjusting by %llu\n",
 			  (long long) ifmsh->sync_offset_clockdrift_max,
 			  (unsigned long long) beacon_int_fraction);
 		tsfdelta = -beacon_int_fraction;
@@ -167,7 +167,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 }
 
-static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata,
+static void mesh_sync_offset_adjust_tsf(struct ieee80211_sub_if_data *sdata,
 					 struct beacon_data *beacon)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
@@ -184,12 +184,12 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata,
 		 * the tsf adjustment to the mesh tasklet
 		 */
 		msync_dbg(sdata,
-			  "TBTT : kicking off TBTT adjustment with clockdrift_max=%lld\n",
+			  "TSF : kicking off TSF adjustment with clockdrift_max=%lld\n",
 			  ifmsh->sync_offset_clockdrift_max);
 		set_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags);
 	} else {
 		msync_dbg(sdata,
-			  "TBTT : max clockdrift=%lld; too small to adjust\n",
+			  "TSF : max clockdrift=%lld; too small to adjust\n",
 			  (long long)ifmsh->sync_offset_clockdrift_max);
 		ifmsh->sync_offset_clockdrift_max = 0;
 	}
@@ -201,7 +201,7 @@ static const struct sync_method sync_methods[] = {
 		.method = IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET,
 		.ops = {
 			.rx_bcn_presp = &mesh_sync_offset_rx_bcn_presp,
-			.adjust_tbtt = &mesh_sync_offset_adjust_tbtt,
+			.adjust_tsf = &mesh_sync_offset_adjust_tsf,
 		}
 	},
 };
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2c21b70..874332d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4076,7 +4076,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 		}
 
 		if (ifmsh->sync_ops)
-			ifmsh->sync_ops->adjust_tbtt(sdata, beacon);
+			ifmsh->sync_ops->adjust_tsf(sdata, beacon);
 
 		skb = dev_alloc_skb(local->tx_headroom +
 				    beacon->head_len +
-- 
2.7.4
