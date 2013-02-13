Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44971 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3BMUPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 15:15:31 -0500
Received: by mail-pa0-f46.google.com with SMTP id kp14so913044pab.5
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2013 12:15:30 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 1/3] mac80211: consolidate MBSS change notification
Date: Wed, 13 Feb 2013 12:14:19 -0800
Message-Id: <1360786461-30107-1-git-send-email-thomas@cozybit.com> (sfid-20130213_211541_408524_E342EE88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few mesh utility functions will call
ieee80211_bss_info_change_notify(), and then the caller
might notify the driver of the same change again. Avoid
this redundancy by propagating the BSS changes and
generally calling bss_info_change_notify() once per
change.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

v2:
	avoid unnecessary beacon updates (Marco)

 net/mac80211/cfg.c        |   19 +++++++++++--------
 net/mac80211/mesh.c       |    2 +-
 net/mac80211/mesh.h       |   10 +++++-----
 net/mac80211/mesh_plink.c |   33 ++++++++++++++++++---------------
 net/mac80211/mesh_ps.c    |   25 +++++++++++++++++++------
 5 files changed, 54 insertions(+), 35 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0969978..6a39d38 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1262,8 +1262,8 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
+		u32 changed = 0;
 		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED) {
-			u32 changed = 0;
 
 			switch (params->plink_state) {
 			case NL80211_PLINK_ESTAB:
@@ -1273,8 +1273,8 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 				sta->plink_state = params->plink_state;
 
 				ieee80211_mps_sta_status_update(sta);
-				ieee80211_mps_set_sta_local_pm(sta,
-					sdata->u.mesh.mshcfg.power_mode);
+				changed |= ieee80211_mps_set_sta_local_pm(sta,
+					      sdata->u.mesh.mshcfg.power_mode);
 				break;
 			case NL80211_PLINK_LISTEN:
 			case NL80211_PLINK_BLOCKED:
@@ -1288,26 +1288,29 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 				sta->plink_state = params->plink_state;
 
 				ieee80211_mps_sta_status_update(sta);
-				ieee80211_mps_local_status_update(sdata);
+				changed |=
+				      ieee80211_mps_local_status_update(sdata);
 				break;
 			default:
 				/*  nothing  */
 				break;
 			}
-			ieee80211_bss_info_change_notify(sdata, changed);
 		} else {
 			switch (params->plink_action) {
 			case PLINK_ACTION_OPEN:
-				mesh_plink_open(sta);
+				changed |= mesh_plink_open(sta);
 				break;
 			case PLINK_ACTION_BLOCK:
-				mesh_plink_block(sta);
+				changed |= mesh_plink_block(sta);
 				break;
 			}
 		}
 
 		if (params->local_pm)
-			ieee80211_mps_set_sta_local_pm(sta, params->local_pm);
+			changed |=
+			      ieee80211_mps_set_sta_local_pm(sta,
+							     params->local_pm);
+		ieee80211_bss_info_change_notify(sdata, changed);
 #endif
 	}
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 2bf0158..0adec3d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -675,7 +675,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(local, band);
 
-	ieee80211_mps_local_status_update(sdata);
+	changed |= ieee80211_mps_local_status_update(sdata);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 3b9d862..7ad035f 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -245,9 +245,9 @@ void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
 const struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method);
 
 /* mesh power save */
-void ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata);
-void ieee80211_mps_set_sta_local_pm(struct sta_info *sta,
-				    enum nl80211_mesh_power_mode pm);
+u32 ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata);
+u32 ieee80211_mps_set_sta_local_pm(struct sta_info *sta,
+				   enum nl80211_mesh_power_mode pm);
 void ieee80211_mps_set_frame_flags(struct ieee80211_sub_if_data *sdata,
 				   struct sta_info *sta,
 				   struct ieee80211_hdr *hdr);
@@ -289,8 +289,8 @@ bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 u32 mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
 u32 mesh_plink_deactivate(struct sta_info *sta);
-int mesh_plink_open(struct sta_info *sta);
-void mesh_plink_block(struct sta_info *sta);
+u32 mesh_plink_open(struct sta_info *sta);
+u32 mesh_plink_block(struct sta_info *sta);
 void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len,
 			 struct ieee80211_rx_status *rx_status);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 56c9b31..a4c7a7e 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -202,7 +202,7 @@ static u32 __mesh_plink_deactivate(struct sta_info *sta)
 	mesh_path_flush_by_nexthop(sta);
 
 	ieee80211_mps_sta_status_update(sta);
-	ieee80211_mps_local_status_update(sdata);
+	changed |= ieee80211_mps_local_status_update(sdata);
 
 	return changed;
 }
@@ -494,6 +494,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 			   struct ieee802_11_elems *elems)
 {
 	struct sta_info *sta;
+	u32 changed = 0;
 
 	sta = mesh_sta_info_get(sdata, hw_addr, elems);
 	if (!sta)
@@ -504,11 +505,12 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 	    sdata->u.mesh.accepting_plinks &&
 	    sdata->u.mesh.mshcfg.auto_open_plinks &&
 	    rssi_threshold_check(sta, sdata))
-		mesh_plink_open(sta);
+		changed = mesh_plink_open(sta);
 
 	ieee80211_mps_frame_release(sta, elems);
 out:
 	rcu_read_unlock();
+	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
 static void mesh_plink_timer(unsigned long data)
@@ -621,13 +623,14 @@ static inline void mesh_plink_timer_set(struct sta_info *sta, int timeout)
 	add_timer(&sta->plink_timer);
 }
 
-int mesh_plink_open(struct sta_info *sta)
+u32 mesh_plink_open(struct sta_info *sta)
 {
 	__le16 llid;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u32 changed;
 
 	if (!test_sta_flag(sta, WLAN_STA_AUTH))
-		return -EPERM;
+		return 0;
 
 	spin_lock_bh(&sta->lock);
 	get_random_bytes(&llid, 2);
@@ -635,7 +638,7 @@ int mesh_plink_open(struct sta_info *sta)
 	if (sta->plink_state != NL80211_PLINK_LISTEN &&
 	    sta->plink_state != NL80211_PLINK_BLOCKED) {
 		spin_unlock_bh(&sta->lock);
-		return -EBUSY;
+		return 0;
 	}
 	sta->plink_state = NL80211_PLINK_OPN_SNT;
 	mesh_plink_timer_set(sta, sdata->u.mesh.mshcfg.dot11MeshRetryTimeout);
@@ -645,15 +648,15 @@ int mesh_plink_open(struct sta_info *sta)
 		sta->sta.addr);
 
 	/* set the non-peer mode to active during peering */
-	ieee80211_mps_local_status_update(sdata);
+	changed = ieee80211_mps_local_status_update(sdata);
 
-	return mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
-				   sta->sta.addr, llid, 0, 0);
+	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
+			    sta->sta.addr, llid, 0, 0);
+	return changed;
 }
 
-void mesh_plink_block(struct sta_info *sta)
+u32 mesh_plink_block(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 changed;
 
 	spin_lock_bh(&sta->lock);
@@ -661,7 +664,7 @@ void mesh_plink_block(struct sta_info *sta)
 	sta->plink_state = NL80211_PLINK_BLOCKED;
 	spin_unlock_bh(&sta->lock);
 
-	ieee80211_bss_info_change_notify(sdata, changed);
+	return changed;
 }
 
 
@@ -882,7 +885,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 					     mshcfg->dot11MeshRetryTimeout);
 
 			/* set the non-peer mode to active during peering */
-			ieee80211_mps_local_status_update(sdata);
+			changed |= ieee80211_mps_local_status_update(sdata);
 
 			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(sdata,
@@ -978,7 +981,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			ieee80211_mps_sta_status_update(sta);
-			ieee80211_mps_set_sta_local_pm(sta,
+			changed |= ieee80211_mps_set_sta_local_pm(sta,
 						       mshcfg->power_mode);
 			break;
 		default:
@@ -1020,8 +1023,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 					    WLAN_SP_MESH_PEERING_CONFIRM,
 					    sta->sta.addr, llid, plid, 0);
 			ieee80211_mps_sta_status_update(sta);
-			ieee80211_mps_set_sta_local_pm(sta,
-						       mshcfg->power_mode);
+			changed |= ieee80211_mps_set_sta_local_pm(sta,
+							mshcfg->power_mode);
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index b677962..4f28d96 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -74,14 +74,17 @@ static void mps_qos_null_tx(struct sta_info *sta)
  * @sdata: local mesh subif
  *
  * sets the non-peer power mode and triggers the driver PS (re-)configuration
+ * Return BSS_CHANGED_BEACON if a beacon update is necessary.
  */
-void ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
+u32 ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct sta_info *sta;
 	bool peering = false;
 	int light_sleep_cnt = 0;
 	int deep_sleep_cnt = 0;
+	u32 changed = 0;
+	enum nl80211_mesh_power_mode nonpeer_pm;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
@@ -115,17 +118,26 @@ void ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
 	 */
 	if (peering) {
 		mps_dbg(sdata, "setting non-peer PM to active for peering\n");
-		ifmsh->nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
+		nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
 	} else if (light_sleep_cnt || deep_sleep_cnt) {
 		mps_dbg(sdata, "setting non-peer PM to deep sleep\n");
-		ifmsh->nonpeer_pm = NL80211_MESH_POWER_DEEP_SLEEP;
+		nonpeer_pm = NL80211_MESH_POWER_DEEP_SLEEP;
 	} else {
 		mps_dbg(sdata, "setting non-peer PM to user value\n");
-		ifmsh->nonpeer_pm = ifmsh->mshcfg.power_mode;
+		nonpeer_pm = ifmsh->mshcfg.power_mode;
 	}
 
+	/* need update if sleep counts move between 0 and non-zero */
+	if (ifmsh->nonpeer_pm != nonpeer_pm ||
+	    !ifmsh->ps_peers_light_sleep != !light_sleep_cnt ||
+	    !ifmsh->ps_peers_deep_sleep != !deep_sleep_cnt)
+		changed = BSS_CHANGED_BEACON;
+
+	ifmsh->nonpeer_pm = nonpeer_pm;
 	ifmsh->ps_peers_light_sleep = light_sleep_cnt;
 	ifmsh->ps_peers_deep_sleep = deep_sleep_cnt;
+
+	return changed;
 }
 
 /**
@@ -133,8 +145,9 @@ void ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
  *
  * @sta: mesh STA
  * @pm: the power mode to set
+ * Return BSS_CHANGED_BEACON if a beacon update is in order.
  */
-void ieee80211_mps_set_sta_local_pm(struct sta_info *sta,
+u32 ieee80211_mps_set_sta_local_pm(struct sta_info *sta,
 				    enum nl80211_mesh_power_mode pm)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -151,7 +164,7 @@ void ieee80211_mps_set_sta_local_pm(struct sta_info *sta,
 	if (sta->plink_state == NL80211_PLINK_ESTAB)
 		mps_qos_null_tx(sta);
 
-	ieee80211_mps_local_status_update(sdata);
+	return ieee80211_mps_local_status_update(sdata);
 }
 
 /**
-- 
1.7.10.4

