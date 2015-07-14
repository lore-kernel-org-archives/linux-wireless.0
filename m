Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:32862 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbbGNMcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 08:32:17 -0400
Received: by ietj16 with SMTP id j16so10056877iet.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2015 05:32:16 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v3 4/5] mac80211: mesh: separate plid and aid concepts
Date: Tue, 14 Jul 2015 08:31:58 -0400
Message-Id: <1436877119-17577-5-git-send-email-me@bobcopeland.com> (sfid-20150714_143226_620709_EDBC31F3)
In-Reply-To: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
References: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to 802.11-2012 13.3.1, a mesh STA should assign an AID
upon receipt of a mesh peering open frame rather than using the link
id of the peer.  Using the peer link id has two potential issues:
it may not be unique among the peers, and by its nature it is random,
so the TIM may not compress well.

In preparation for allocating it properly, use sta->sta.aid, but keep
the existing behavior of using the plid in the aid we send.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
v3:
   - introduce local aid and parse it from confirm frame
   - split out bugfix for aid pos

 net/mac80211/mesh_plink.c | 29 +++++++++++++++++++----------
 net/mac80211/mesh_ps.c    |  2 +-
 net/mac80211/sta_info.c   |  5 +----
 net/mac80211/sta_info.h   |  2 ++
 4 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index a5aa0345dd7e..3323413acb77 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -13,6 +13,7 @@
 #include "rate.h"
 #include "mesh.h"
 
+#define PLINK_CNF_AID(mgmt) ((mgmt)->u.action.u.self_prot.variable + 2)
 #define PLINK_GET_LLID(p) (p + 2)
 #define PLINK_GET_PLID(p) (p + 4)
 
@@ -200,6 +201,7 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 }
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
+			       struct sta_info *sta,
 			       enum ieee80211_self_protected_actioncode action,
 			       u8 *da, u16 llid, u16 plid, u16 reason)
 {
@@ -249,7 +251,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		if (action == WLAN_SP_MESH_PEERING_CONFIRM) {
 			/* AID */
 			pos = skb_put(skb, 2);
-			put_unaligned_le16(plid, pos);
+			put_unaligned_le16(sta->sta.aid, pos);
 		}
 		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
@@ -362,7 +364,7 @@ u32 mesh_plink_deactivate(struct sta_info *sta)
 	spin_lock_bh(&sta->mesh->plink_lock);
 	changed = __mesh_plink_deactivate(sta);
 	sta->mesh->reason = WLAN_REASON_MESH_PEER_CANCELED;
-	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+	mesh_plink_frame_tx(sdata, sta, WLAN_SP_MESH_PEERING_CLOSE,
 			    sta->sta.addr, sta->mesh->llid, sta->mesh->plid,
 			    sta->mesh->reason);
 	spin_unlock_bh(&sta->mesh->plink_lock);
@@ -619,7 +621,7 @@ static void mesh_plink_timer(unsigned long data)
 	}
 	spin_unlock_bh(&sta->mesh->plink_lock);
 	if (action)
-		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
+		mesh_plink_frame_tx(sdata, sta, action, sta->sta.addr,
 				    sta->mesh->llid, sta->mesh->plid, reason);
 }
 
@@ -689,7 +691,7 @@ u32 mesh_plink_open(struct sta_info *sta)
 	/* set the non-peer mode to active during peering */
 	changed = ieee80211_mps_local_status_update(sdata);
 
-	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
+	mesh_plink_frame_tx(sdata, sta, WLAN_SP_MESH_PEERING_OPEN,
 			    sta->sta.addr, sta->mesh->llid, 0, 0);
 	return changed;
 }
@@ -871,13 +873,13 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 	}
 	spin_unlock_bh(&sta->mesh->plink_lock);
 	if (action) {
-		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
+		mesh_plink_frame_tx(sdata, sta, action, sta->sta.addr,
 				    sta->mesh->llid, sta->mesh->plid,
 				    sta->mesh->reason);
 
 		/* also send confirm in open case */
 		if (action == WLAN_SP_MESH_PEERING_OPEN) {
-			mesh_plink_frame_tx(sdata,
+			mesh_plink_frame_tx(sdata, sta,
 					    WLAN_SP_MESH_PEERING_CONFIRM,
 					    sta->sta.addr, sta->mesh->llid,
 					    sta->mesh->plid, 0);
@@ -1067,8 +1069,9 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 			goto unlock_rcu;
 		}
 		sta->mesh->plid = plid;
+		sta->sta.aid = plid;
 	} else if (!sta && event == OPN_RJCT) {
-		mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+		mesh_plink_frame_tx(sdata, NULL, WLAN_SP_MESH_PEERING_CLOSE,
 				    mgmt->sa, 0, plid,
 				    WLAN_REASON_MESH_CONFIG);
 		goto unlock_rcu;
@@ -1077,9 +1080,15 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 		goto unlock_rcu;
 	}
 
-	/* 802.11-2012 13.3.7.2 - update plid on CNF if not set */
-	if (!sta->mesh->plid && event == CNF_ACPT)
-		sta->mesh->plid = plid;
+	if (event == CNF_ACPT) {
+		/* 802.11-2012 13.3.7.2 - update plid on CNF if not set */
+		if (!sta->mesh->plid) {
+			sta->mesh->plid = plid;
+			sta->sta.aid = sta->mesh->plid;
+		}
+
+		sta->mesh->aid = get_unaligned_le16(PLINK_CNF_AID(mgmt));
+	}
 
 	changed |= mesh_plink_fsm(sdata, sta, event);
 
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 29747f92b9b0..90a268abea17 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -579,7 +579,7 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 
 	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
 		has_buffered = ieee80211_check_tim(elems->tim, elems->tim_len,
-						   sta->mesh->llid);
+						   sta->mesh->aid);
 
 	if (has_buffered)
 		mps_dbg(sta->sdata, "%pM indicates buffered frames\n",
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9da7d2bc271a..70cd9fa57424 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -635,7 +635,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 	bool indicate_tim = false;
 	u8 ignore_for_tim = sta->sta.uapsd_queues;
 	int ac;
-	u16 id;
+	u16 id = sta->sta.aid;
 
 	if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
@@ -643,12 +643,9 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 			return;
 
 		ps = &sta->sdata->bss->ps;
-		id = sta->sta.aid;
 #ifdef CONFIG_MAC80211_MESH
 	} else if (ieee80211_vif_is_mesh(&sta->sdata->vif)) {
 		ps = &sta->sdata->u.mesh.ps;
-		/* TIM map only for 1 <= PLID <= IEEE80211_MAX_AID */
-		id = sta->mesh->plid % (IEEE80211_MAX_AID + 1);
 #endif
 	} else {
 		return;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 6dcb33484eac..1d2805c598c0 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -277,6 +277,7 @@ struct ieee80211_fast_tx {
  * @plink_lock: serialize access to plink fields
  * @llid: Local link ID
  * @plid: Peer link ID
+ * @aid: local aid supplied by peer
  * @reason: Cancel reason on PLINK_HOLDING state
  * @plink_retries: Retries in establishment
  * @plink_state: peer link state
@@ -301,6 +302,7 @@ struct mesh_sta {
 	spinlock_t plink_lock;
 	u16 llid;
 	u16 plid;
+	u16 aid;
 	u16 reason;
 	u8 plink_retries;
 
-- 
2.1.4

