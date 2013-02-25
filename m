Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:45123 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721Ab3BYQBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 11:01:07 -0500
Received: by mail-bk0-f44.google.com with SMTP id j4so1356340bkw.17
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 08:01:06 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com
Cc: sleffler@google.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	Marco Porsch <marco@cozybit.com>
Subject: [PATCHv3 1/3] mac80211: move mesh sync beacon handler into neighbour_update
Date: Mon, 25 Feb 2013 17:00:55 +0100
Message-Id: <1361808057-17899-1-git-send-email-marco@cozybit.com> (sfid-20130225_170117_304281_9B22AEB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the beacon handler into mesh_neighbour_update where the STA
pointer is already available. This avoids additional overhead
and simplifies the handler.
The repositioning will also benefit mesh PS which uses T_r and
the updated T_offset value.

Check frame type before calling the handler. Rename it to better
reflect its purpose.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---

v3:
	check frame type before rx_bcn handler (Johannes)

 net/mac80211/ieee80211_i.h |    9 ++++-----
 net/mac80211/mesh.c        |    7 +------
 net/mac80211/mesh.h        |    4 +++-
 net/mac80211/mesh_plink.c  |   38 ++++++++++++++++++++++++++++-------
 net/mac80211/mesh_sync.c   |   47 +++++++++-----------------------------------
 5 files changed, 48 insertions(+), 57 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 388580a..631760f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -529,11 +529,10 @@ struct ieee80211_if_ibss {
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
+		       u64 t_r);
 	void (*adjust_tbtt)(struct ieee80211_sub_if_data *sdata);
 	/* add other framework functions here */
 };
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 29ce2aa..94682d2 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -938,7 +938,6 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee802_11_elems elems;
 	struct ieee80211_channel *channel;
 	size_t baselen;
@@ -974,11 +973,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
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
index 336c88a..ac02f38 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -283,7 +283,9 @@ int mesh_gate_num(struct ieee80211_sub_if_data *sdata);
 
 /* Mesh plinks */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
-			   u8 *hw_addr, struct ieee802_11_elems *ie);
+			   struct ieee80211_mgmt *mgmt,
+			   struct ieee802_11_elems *ie,
+			   struct ieee80211_rx_status *rx_status);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 u32 mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 07d396d..e34cfd1 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -12,6 +12,7 @@
 #include "ieee80211_i.h"
 #include "rate.h"
 #include "mesh.h"
+#include "driver-ops.h"
 
 #define PLINK_GET_LLID(p) (p + 2)
 #define PLINK_GET_PLID(p) (p + 4)
@@ -492,29 +493,52 @@ mesh_sta_info_get(struct ieee80211_sub_if_data *sdata,
  *
  * @sdata: local meshif
  * @addr: peer's address
- * @elems: IEs from beacon or mesh peering frame
+ * @elems: IEs from beacon or mesh probe response
  *
  * Initiates peering if appropriate.
  */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
-			   u8 *hw_addr,
-			   struct ieee802_11_elems *elems)
+			   struct ieee80211_mgmt *mgmt,
+			   struct ieee802_11_elems *elems,
+			   struct ieee80211_rx_status *rx_status)
 {
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct sta_info *sta;
 	u32 changed = 0;
+	u64 t_r = 0;
 
-	sta = mesh_sta_info_get(sdata, hw_addr, elems);
+	/*
+	 * If available, calculate the time the beacon timestamp field was
+	 * received from the rx_status->mactime field. Otherwise get the
+	 * current TSF as approximation before entering rcu-read section.
+	 */
+	 if (ieee80211_is_beacon(mgmt->frame_control)) {
+		if (ieee80211_have_rx_timestamp(rx_status))
+			t_r = ieee80211_calculate_rx_timestamp(local,
+					rx_status,
+					24 + 12 + elems->total_len + FCS_LEN,
+					24);
+		else
+			t_r = drv_get_tsf(local, sdata);
+	}
+
+	sta = mesh_sta_info_get(sdata, mgmt->sa, elems);
 	if (!sta)
 		goto out;
 
 	if (mesh_peer_accepts_plinks(elems) &&
 	    sta->plink_state == NL80211_PLINK_LISTEN &&
-	    sdata->u.mesh.accepting_plinks &&
-	    sdata->u.mesh.mshcfg.auto_open_plinks &&
+	    ifmsh->accepting_plinks && ifmsh->mshcfg.auto_open_plinks &&
 	    rssi_threshold_check(sta, sdata))
 		changed = mesh_plink_open(sta);
 
-	ieee80211_mps_frame_release(sta, elems);
+	if (ieee80211_is_beacon(mgmt->frame_control)) {
+		if (ifmsh->sync_ops)
+			ifmsh->sync_ops->rx_bcn(sta, mgmt, elems, t_r);
+
+		ieee80211_mps_frame_release(sta, elems);
+	}
 out:
 	rcu_read_unlock();
 	ieee80211_mbss_info_change_notify(sdata, changed);
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 05a256b..a6c14d9 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -75,35 +75,17 @@ void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
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
+				    u64 t_r)
 {
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
-	u64 t_t, t_r;
+	u64 t_t;
 
 	WARN_ON(ifmsh->mesh_sp_id != IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
 
-	/* standard mentions only beacons */
-	if (stype != IEEE80211_STYPE_BEACON)
-		return;
-
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
@@ -114,17 +96,9 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
 		msync_dbg(sdata, "STA %pM : is adjusting TBTT\n",
 			  sta->sta.addr);
-		goto no_sync;
+		return;
 	}
 
-	if (ieee80211_have_rx_timestamp(rx_status))
-		/* time when timestamp field was received */
-		t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
-						       24 + 12 +
-						       elems->total_len +
-						       FCS_LEN,
-						       24);
-
 	/* Timing offset calculation (see 13.13.2.2.2) */
 	t_t = le64_to_cpu(mgmt->u.beacon.timestamp);
 	sta->t_offset = t_t - t_r;
@@ -144,7 +118,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 				  sta->sta.addr,
 				  (long long) t_clockdrift);
 			clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
-			goto no_sync;
+			return;
 		}
 
 		spin_lock_bh(&ifmsh->sync_offset_lock);
@@ -159,9 +133,6 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			  sta->sta.addr,
 			  (long long) sta->t_offset);
 	}
-
-no_sync:
-	rcu_read_unlock();
 }
 
 static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
@@ -200,7 +171,7 @@ static const struct sync_method sync_methods[] = {
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

