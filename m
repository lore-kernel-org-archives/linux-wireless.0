Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:34105 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab3BOLk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 06:40:56 -0500
Received: by mail-bk0-f50.google.com with SMTP id jg9so1488211bkc.9
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 03:40:55 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org, Marco Porsch <marco@cozybit.com>
Subject: [PATCH 1/3] mac80211: move mesh sync beacon handler into neighbour_update
Date: Fri, 15 Feb 2013 12:40:44 +0100
Message-Id: <1360928446-543-1-git-send-email-marco@cozybit.com> (sfid-20130215_124101_439533_A536AF7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the beacon handler into mesh_neighbour_update where the STA
pointer is already available. This avoids additional overhead
and simplifies the handler.
The repositioning will also benefit mesh PS which uses the TSF
and the just updated T_offset value.

Rename the handler to better reflect its purpose.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---

changes since RFC:
- rebased on todays mac80211-next/master

 net/mac80211/ieee80211_i.h |   10 ++++-----
 net/mac80211/mesh.c        |    7 +------
 net/mac80211/mesh.h        |    5 +++--
 net/mac80211/mesh_plink.c  |   16 ++++++++++++---
 net/mac80211/mesh_sync.c   |   48 ++++++++++++++++----------------------------
 5 files changed, 39 insertions(+), 47 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 388580a..62eeddf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -529,11 +529,11 @@ struct ieee80211_if_ibss {
  */
 struct ieee802_11_elems;
 struct ieee80211_mesh_sync_ops {
-	void (*rx_bcn_presp)(struct ieee80211_sub_if_data *sdata,
-			     u16 stype,
-			     struct ieee80211_mgmt *mgmt,
-			     struct ieee802_11_elems *elems,
-			     struct ieee80211_rx_status *rx_status);
+	void (*rx_bcn)(struct sta_info *sta,
+		       struct ieee80211_mgmt *mgmt,
+		       struct ieee802_11_elems *elems,
+		       struct ieee80211_rx_status *rx_status,
+		       u64 tsf);
 	void (*adjust_tbtt)(struct ieee80211_sub_if_data *sdata);
 	/* add other framework functions here */
 };
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a77d40e..4b42237 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -932,7 +932,6 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee802_11_elems elems;
 	struct ieee80211_channel *channel;
 	size_t baselen;
@@ -968,11 +967,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	if (mesh_matches_local(sdata, &elems))
-		mesh_neighbour_update(sdata, mgmt->sa, &elems);
-
-	if (ifmsh->sync_ops)
-		ifmsh->sync_ops->rx_bcn_presp(sdata,
-			stype, mgmt, &elems, rx_status);
+		mesh_neighbour_update(sdata, mgmt, &elems, rx_status);
 }
 
 static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 1a1da87..3fd4657 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -286,8 +286,9 @@ int mesh_path_send_to_gates(struct mesh_path *mpath);
 int mesh_gate_num(struct ieee80211_sub_if_data *sdata);
 /* Mesh plinks */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
-			   u8 *hw_addr,
-			   struct ieee802_11_elems *ie);
+			   struct ieee80211_mgmt *mgmt,
+			   struct ieee802_11_elems *ie,
+			   struct ieee80211_rx_status *rx_status);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 u32 mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index f7526e5..fe6fc22 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -12,6 +12,7 @@
 #include "ieee80211_i.h"
 #include "rate.h"
 #include "mesh.h"
+#include "driver-ops.h"
 
 #define PLINK_GET_LLID(p) (p + 2)
 #define PLINK_GET_PLID(p) (p + 4)
@@ -488,13 +489,19 @@ mesh_sta_info_get(struct ieee80211_sub_if_data *sdata,
  * Initiates peering if appropriate.
  */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
-			   u8 *hw_addr,
-			   struct ieee802_11_elems *elems)
+			   struct ieee80211_mgmt *mgmt,
+			   struct ieee802_11_elems *elems,
+			   struct ieee80211_rx_status *rx_status)
 {
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct sta_info *sta;
 	u32 changed = 0;
+	u64 tsf;
 
-	sta = mesh_sta_info_get(sdata, hw_addr, elems);
+	/* get tsf before entering rcu-read section */
+	tsf = drv_get_tsf(sdata->local, sdata);
+
+	sta = mesh_sta_info_get(sdata, mgmt->sa, elems);
 	if (!sta)
 		goto out;
 
@@ -505,6 +512,9 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 	    rssi_threshold_check(sta, sdata))
 		changed = mesh_plink_open(sta);
 
+	if (ifmsh->sync_ops)
+		ifmsh->sync_ops->rx_bcn(sta, mgmt, elems, rx_status, tsf);
+
 	ieee80211_mps_frame_release(sta, elems);
 out:
 	rcu_read_unlock();
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index aa8d1e4..f395c06 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -75,35 +75,23 @@ void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 		drv_set_tsf(local, sdata, tsf + tsfdelta);
 }
 
-static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
-				   u16 stype,
-				   struct ieee80211_mgmt *mgmt,
-				   struct ieee802_11_elems *elems,
-				   struct ieee80211_rx_status *rx_status)
+static void mesh_sync_offset_rx_bcn(struct sta_info *sta,
+				    struct ieee80211_mgmt *mgmt,
+				    struct ieee802_11_elems *elems,
+				    struct ieee80211_rx_status *rx_status,
+				    u64 t_r)
 {
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
-	u64 t_t, t_r;
+	u64 t_t;
 
 	WARN_ON(ifmsh->mesh_sp_id != IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
 
 	/* standard mentions only beacons */
-	if (stype != IEEE80211_STYPE_BEACON)
+	if (!ieee80211_is_beacon(mgmt->frame_control))
 		return;
 
-	/* The current tsf is a first approximation for the timestamp
-	 * for the received beacon.  Further down we try to get a
-	 * better value from the rx_status->mactime field if
-	 * available. Also we have to call drv_get_tsf() before
-	 * entering the rcu-read section.*/
-	t_r = drv_get_tsf(local, sdata);
-
-	rcu_read_lock();
-	sta = sta_info_get(sdata, mgmt->sa);
-	if (!sta)
-		goto no_sync;
-
 	/* check offset sync conditions (13.13.2.2.1)
 	 *
 	 * TODO also sync to
@@ -113,11 +101,16 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (elems->mesh_config && mesh_peer_tbtt_adjusting(elems)) {
 		clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
 		msync_dbg(sdata, "STA %pM : is adjusting TBTT\n", sta->sta.addr);
-		goto no_sync;
+		return;
 	}
 
+	/*
+	 * The current tsf is a first approximation for the timestamp
+	 * of the received beacon. If available, get a better value
+	 * from the rx_status->mactime field (time when timestamp field
+	 * was received).
+	 */
 	if (ieee80211_have_rx_timestamp(rx_status))
-		/* time when timestamp field was received */
 		t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
 						       24 + 12 +
 						       elems->total_len +
@@ -146,11 +139,9 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 				  sta->sta.addr,
 				  (long long) t_clockdrift);
 			clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
-			goto no_sync;
+			return;
 		}
 
-		rcu_read_unlock();
-
 		spin_lock_bh(&ifmsh->sync_offset_lock);
 		if (t_clockdrift >
 		    ifmsh->sync_offset_clockdrift_max)
@@ -165,12 +156,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			  "STA %pM : offset was invalid, sta->t_offset=%lld\n",
 			  sta->sta.addr,
 			  (long long) sta->t_offset);
-		rcu_read_unlock();
 	}
-	return;
-
-no_sync:
-	rcu_read_unlock();
 }
 
 static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
@@ -212,7 +198,7 @@ static const struct sync_method sync_methods[] = {
 	{
 		.method = IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET,
 		.ops = {
-			.rx_bcn_presp = &mesh_sync_offset_rx_bcn_presp,
+			.rx_bcn = &mesh_sync_offset_rx_bcn,
 			.adjust_tbtt = &mesh_sync_offset_adjust_tbtt,
 		}
 	},
-- 
1.7.9.5

