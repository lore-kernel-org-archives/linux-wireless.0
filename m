Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:36522 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbbGBN3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 09:29:00 -0400
Received: by iecvh10 with SMTP id vh10so56464537iec.3
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 06:28:59 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/3] mac80211: mesh: separate plid and aid concepts
Date: Thu,  2 Jul 2015 09:28:09 -0400
Message-Id: <1435843690-2856-3-git-send-email-me@bobcopeland.com> (sfid-20150702_152906_723540_27B6CA85)
In-Reply-To: <1435843690-2856-1-git-send-email-me@bobcopeland.com>
References: <1435843690-2856-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to 802.11-2012 13.3.1, a mesh STA should assign an AID
upon receipt of a mesh peering open frame rather than using the link
id of the peer.  Using the peer link id has two potential issues:
it may not be unique among the peers, and by its nature it is random,
so the TIM may not compress well.

In preparation for allocating it properly, use sta->sta.aid, but keep
the existing behavior of using the plid.

Additionally, fix a bug where the AID is written into the wrong place
in peering confirm frame skbs.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_plink.c | 20 ++++++++++++--------
 net/mac80211/sta_info.c   |  5 +----
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 7b071e36e55e..9dca16bd3eb9 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -200,6 +200,7 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 }
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
+			       struct sta_info *sta,
 			       enum ieee80211_self_protected_actioncode action,
 			       u8 *da, u16 llid, u16 plid, u16 reason)
 {
@@ -249,7 +250,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		if (action == WLAN_SP_MESH_PEERING_CONFIRM) {
 			/* AID */
 			pos = skb_put(skb, 2);
-			put_unaligned_le16(plid, pos + 2);
+			put_unaligned_le16(sta->sta.aid, pos);
 		}
 		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
@@ -362,7 +363,7 @@ u32 mesh_plink_deactivate(struct sta_info *sta)
 	spin_lock_bh(&sta->mesh->plink_lock);
 	changed = __mesh_plink_deactivate(sta);
 	sta->mesh->reason = WLAN_REASON_MESH_PEER_CANCELED;
-	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+	mesh_plink_frame_tx(sdata, sta, WLAN_SP_MESH_PEERING_CLOSE,
 			    sta->sta.addr, sta->mesh->llid, sta->mesh->plid,
 			    sta->mesh->reason);
 	spin_unlock_bh(&sta->mesh->plink_lock);
@@ -619,7 +620,7 @@ static void mesh_plink_timer(unsigned long data)
 	}
 	spin_unlock_bh(&sta->mesh->plink_lock);
 	if (action)
-		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
+		mesh_plink_frame_tx(sdata, sta, action, sta->sta.addr,
 				    sta->mesh->llid, sta->mesh->plid, reason);
 }
 
@@ -689,7 +690,7 @@ u32 mesh_plink_open(struct sta_info *sta)
 	/* set the non-peer mode to active during peering */
 	changed = ieee80211_mps_local_status_update(sdata);
 
-	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
+	mesh_plink_frame_tx(sdata, sta, WLAN_SP_MESH_PEERING_OPEN,
 			    sta->sta.addr, sta->mesh->llid, 0, 0);
 	return changed;
 }
@@ -871,13 +872,13 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
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
@@ -1067,8 +1068,9 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
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
@@ -1078,8 +1080,10 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* 802.11-2012 13.3.7.2 - update plid on CNF if not set */
-	if (!sta->mesh->plid && event == CNF_ACPT)
+	if (!sta->mesh->plid && event == CNF_ACPT) {
 		sta->mesh->plid = plid;
+		sta->sta.aid = sta->mesh->plid;
+	}
 
 	changed |= mesh_plink_fsm(sdata, sta, event);
 
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
-- 
2.1.4

