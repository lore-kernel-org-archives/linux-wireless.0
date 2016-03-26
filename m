Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:35523 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbcCZP1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2016 11:27:34 -0400
Received: by mail-qg0-f68.google.com with SMTP id c67so8755661qgc.2
        for <linux-wireless@vger.kernel.org>; Sat, 26 Mar 2016 08:27:33 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] mac80211: mesh: flush paths outside of plink lock
Date: Sat, 26 Mar 2016 11:27:19 -0400
Message-Id: <1459006039-4493-2-git-send-email-me@bobcopeland.com> (sfid-20160326_162740_313388_4AA1D54A)
In-Reply-To: <1459006039-4493-1-git-send-email-me@bobcopeland.com>
References: <1459006039-4493-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lockdep warned of a lock dependency between the mesh_plink lock
and the internal lock for the rhashtable.  The problem is that
the rhashtable code uses a spin lock with softirqs enabled, while
mesh_plink_timer executes a walk (to flush paths on a state change)
inside a softirq with the plink lock held.

This leads to the following deadlock if the timer fires while rht
lock is held on this CPU, and plink lock is held on another CPU:

   CPU0                         CPU1
   ----                         ----
   lock(&(&ht->lock)->rlock);
                                local_irq_disable();
                                lock(&(&sta->mesh->plink_lock)->rlock);
                                lock(&(&ht->lock)->rlock);
   <Interrupt>
   lock(&(&sta->mesh->plink_lock)->rlock);
   *** DEADLOCK ***

Fix by waiting until we drop the plink lock to flush paths.

Fixes: d48a1b7cd439 ("mac80211: mesh: convert path table to rhashtable")
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_plink.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index a07e93c21c9e..ecfba8ad29e4 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -331,7 +331,9 @@ free:
  *
  * @sta: mesh peer link to deactivate
  *
- * All mesh paths with this peer as next hop will be flushed
+ * Mesh paths with this peer as next hop should be flushed
+ * by the caller outside of plink_lock.
+ *
  * Returns beacon changed flag if the beacon content changed.
  *
  * Locking: the caller must hold sta->mesh->plink_lock
@@ -346,7 +348,6 @@ static u32 __mesh_plink_deactivate(struct sta_info *sta)
 	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
 		changed = mesh_plink_dec_estab_count(sdata);
 	sta->mesh->plink_state = NL80211_PLINK_BLOCKED;
-	mesh_path_flush_by_nexthop(sta);
 
 	ieee80211_mps_sta_status_update(sta);
 	changed |= ieee80211_mps_set_sta_local_pm(sta,
@@ -374,6 +375,7 @@ u32 mesh_plink_deactivate(struct sta_info *sta)
 			    sta->sta.addr, sta->mesh->llid, sta->mesh->plid,
 			    sta->mesh->reason);
 	spin_unlock_bh(&sta->mesh->plink_lock);
+	mesh_path_flush_by_nexthop(sta);
 
 	return changed;
 }
@@ -748,6 +750,7 @@ u32 mesh_plink_block(struct sta_info *sta)
 	changed = __mesh_plink_deactivate(sta);
 	sta->mesh->plink_state = NL80211_PLINK_BLOCKED;
 	spin_unlock_bh(&sta->mesh->plink_lock);
+	mesh_path_flush_by_nexthop(sta);
 
 	return changed;
 }
@@ -797,6 +800,7 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
 	enum ieee80211_self_protected_actioncode action = 0;
 	u32 changed = 0;
+	bool flush = false;
 
 	mpl_dbg(sdata, "peer %pM in state %s got event %s\n", sta->sta.addr,
 		mplstates[sta->mesh->plink_state], mplevents[event]);
@@ -885,6 +889,7 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 			changed |= mesh_set_short_slot_time(sdata);
 			mesh_plink_close(sdata, sta, event);
 			action = WLAN_SP_MESH_PEERING_CLOSE;
+			flush = true;
 			break;
 		case OPN_ACPT:
 			action = WLAN_SP_MESH_PEERING_CONFIRM;
@@ -916,6 +921,8 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 		break;
 	}
 	spin_unlock_bh(&sta->mesh->plink_lock);
+	if (flush)
+		mesh_path_flush_by_nexthop(sta);
 	if (action) {
 		mesh_plink_frame_tx(sdata, sta, action, sta->sta.addr,
 				    sta->mesh->llid, sta->mesh->plid,
-- 
2.6.1

