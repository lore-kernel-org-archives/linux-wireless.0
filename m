Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52697 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2HHGZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 02:25:44 -0400
Received: from postman.hrz.tu-chemnitz.de ([134.109.133.5] helo=mailbox.hrz.tu-chemnitz.de)
	by cora.hrz.tu-chemnitz.de with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <marco.porsch@etit.tu-chemnitz.de>)
	id 1SyzIu-0000WL-Tb
	for linux-wireless@vger.kernel.org; Wed, 08 Aug 2012 07:59:37 +0200
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [PATCH] mac80211: fix unnecessary beacon update after peering status change
Date: Wed,  8 Aug 2012 07:58:43 +0200
Message-Id: <1344405523-3332-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20120808_082549_140000_76148181)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_bss_info_change_notify is called everytime a peer link is established
or closed, because the accepting_plinks flag in the meshconf IE *might* have changed.

With this patch the corresponding functions return the BSS_CHANGED_BEACON flag when a beacon update is necessary.

Also it makes mesh_accept_plinks_update the common place to update the accepting_plinks flag.
mesh_accept_plinks_update is called upon plink change and also periodically from ieee80211_mesh_housekeeping.
Thus, it also picks up changes of local->num_sta.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Acked-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c       |   20 ++++++++++++--------
 net/mac80211/mesh.h       |    2 +-
 net/mac80211/mesh_plink.c |   44 +++++++++++++++++++-------------------------
 3 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 764593d..d51934a 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -134,12 +134,14 @@ bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie)
 
 /**
  * mesh_accept_plinks_update: update accepting_plink in local mesh beacons
+ * Returns beacon changed flag if the beacon content changed.
  *
  * @sdata: mesh interface in which mesh beacons are going to be updated
  */
-void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
+u32 mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 {
 	bool free_plinks;
+	u32 changed = 0;
 
 	/* In case mesh_plink_free_count > 0 and mesh_plinktbl_capacity == 0,
 	 * the mesh interface might be able to establish plinks with peers that
@@ -149,8 +151,12 @@ void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 	 */
 	free_plinks = mesh_plink_availables(sdata);
 
-	if (free_plinks != sdata->u.mesh.accepting_plinks)
-		ieee80211_mesh_housekeeping_timer((unsigned long) sdata);
+	if (free_plinks != sdata->u.mesh.accepting_plinks) {
+		sdata->u.mesh.accepting_plinks = free_plinks;
+		changed = BSS_CHANGED_BEACON;
+	}
+
+	return changed;
 }
 
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
@@ -262,7 +268,6 @@ mesh_add_meshconf_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	neighbors = (neighbors > 15) ? 15 : neighbors;
 	*pos++ = neighbors << 1;
 	/* Mesh capability */
-	ifmsh->accepting_plinks = mesh_plink_availables(sdata);
 	*pos = MESHCONF_CAPAB_FORWARDING;
 	*pos |= ifmsh->accepting_plinks ?
 	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
@@ -521,14 +526,13 @@ int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 			   struct ieee80211_if_mesh *ifmsh)
 {
-	bool free_plinks;
+	u32 changed;
 
 	ieee80211_sta_expire(sdata, IEEE80211_MESH_PEER_INACTIVITY_LIMIT);
 	mesh_path_expire(sdata);
 
-	free_plinks = mesh_plink_availables(sdata);
-	if (free_plinks != sdata->u.mesh.accepting_plinks)
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+	changed = mesh_accept_plinks_update(sdata);
+	ieee80211_bss_info_change_notify(sdata, changed);
 
 	mod_timer(&ifmsh->housekeeping_timer,
 		  round_jiffies(jiffies + IEEE80211_MESH_HOUSEKEEPING_INTERVAL));
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index faaa39b..13fd5b5 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -282,7 +282,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 			   u8 *hw_addr,
 			   struct ieee802_11_elems *ie);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
-void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
+u32 mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
 void mesh_plink_deactivate(struct sta_info *sta);
 int mesh_plink_open(struct sta_info *sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4256859..709c1f6 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -48,17 +48,17 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		u8 *da, __le16 llid, __le16 plid, __le16 reason);
 
 static inline
-void mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
+u32 mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_inc(&sdata->u.mesh.mshstats.estab_plinks);
-	mesh_accept_plinks_update(sdata);
+	return mesh_accept_plinks_update(sdata);
 }
 
 static inline
-void mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
+u32 mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_dec(&sdata->u.mesh.mshstats.estab_plinks);
-	mesh_accept_plinks_update(sdata);
+	return mesh_accept_plinks_update(sdata);
 }
 
 /**
@@ -170,22 +170,21 @@ out:
  * @sta: mesh peer link to deactivate
  *
  * All mesh paths with this peer as next hop will be flushed
+ * Returns beacon changed flag if the beacon content changed.
  *
  * Locking: the caller must hold sta->lock
  */
-static bool __mesh_plink_deactivate(struct sta_info *sta)
+static u32 __mesh_plink_deactivate(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	bool deactivated = false;
+	u32 changed = 0;
 
-	if (sta->plink_state == NL80211_PLINK_ESTAB) {
-		mesh_plink_dec_estab_count(sdata);
-		deactivated = true;
-	}
+	if (sta->plink_state == NL80211_PLINK_ESTAB)
+		changed = mesh_plink_dec_estab_count(sdata);
 	sta->plink_state = NL80211_PLINK_BLOCKED;
 	mesh_path_flush_by_nexthop(sta);
 
-	return deactivated;
+	return changed;
 }
 
 /**
@@ -198,18 +197,17 @@ static bool __mesh_plink_deactivate(struct sta_info *sta)
 void mesh_plink_deactivate(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	bool deactivated;
+	u32 changed;
 
 	spin_lock_bh(&sta->lock);
-	deactivated = __mesh_plink_deactivate(sta);
+	changed = __mesh_plink_deactivate(sta);
 	sta->reason = cpu_to_le16(WLAN_REASON_MESH_PEER_CANCELED);
 	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
 			    sta->sta.addr, sta->llid, sta->plid,
 			    sta->reason);
 	spin_unlock_bh(&sta->lock);
 
-	if (deactivated)
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
@@ -540,15 +538,14 @@ int mesh_plink_open(struct sta_info *sta)
 void mesh_plink_block(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	bool deactivated;
+	u32 changed;
 
 	spin_lock_bh(&sta->lock);
-	deactivated = __mesh_plink_deactivate(sta);
+	changed = __mesh_plink_deactivate(sta);
 	sta->plink_state = NL80211_PLINK_BLOCKED;
 	spin_unlock_bh(&sta->lock);
 
-	if (deactivated)
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
 
@@ -851,9 +848,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			del_timer(&sta->plink_timer);
 			sta->plink_state = NL80211_PLINK_ESTAB;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_inc_estab_count(sdata);
+			changed |= mesh_plink_inc_estab_count(sdata);
 			changed |= mesh_set_ht_prot_mode(sdata);
-			changed |= BSS_CHANGED_BEACON;
 			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			break;
@@ -887,9 +883,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			del_timer(&sta->plink_timer);
 			sta->plink_state = NL80211_PLINK_ESTAB;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_inc_estab_count(sdata);
+			changed |= mesh_plink_inc_estab_count(sdata);
 			changed |= mesh_set_ht_prot_mode(sdata);
-			changed |= BSS_CHANGED_BEACON;
 			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			mesh_plink_frame_tx(sdata,
@@ -907,13 +902,12 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		case CLS_ACPT:
 			reason = cpu_to_le16(WLAN_REASON_MESH_CLOSE);
 			sta->reason = reason;
-			__mesh_plink_deactivate(sta);
+			changed |= __mesh_plink_deactivate(sta);
 			sta->plink_state = NL80211_PLINK_HOLDING;
 			llid = sta->llid;
 			mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 			spin_unlock_bh(&sta->lock);
 			changed |= mesh_set_ht_prot_mode(sdata);
-			changed |= BSS_CHANGED_BEACON;
 			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
 					    sta->sta.addr, llid, plid, reason);
 			break;
-- 
1.7.9.5

