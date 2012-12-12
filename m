Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54082 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab2LLBrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 20:47:43 -0500
Received: by mail-pb0-f42.google.com with SMTP id rp2so89363pbb.29
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 17:47:43 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>
Subject: [RFC] mac80211: update mesh established plink counter after userspace peering
Date: Tue, 11 Dec 2012 17:22:47 -0800
Message-Id: <1355275367-21371-1-git-send-email-marco@cozybit.com> (sfid-20121212_024746_874935_BC3EFAEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The established peer link count is indicated in mesh beacons and used for
other internal tasks. Previously it was not updated when authenticated peering
is performed in userspace.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---
 net/mac80211/cfg.c        |   22 +++++++++++++++++++---
 net/mac80211/mesh.h       |   14 ++++++++++++++
 net/mac80211/mesh_plink.c |   14 --------------
 3 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4965aa6..2b8e3f8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1200,18 +1200,33 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
-		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED)
+		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED) {
+			u32 changed = 0;
+
 			switch (params->plink_state) {
-			case NL80211_PLINK_LISTEN:
 			case NL80211_PLINK_ESTAB:
+				if (sta->plink_state != NL80211_PLINK_ESTAB)
+					changed = mesh_plink_inc_estab_count(
+							sdata);
+				sta->plink_state = params->plink_state;
+				break;
+			case NL80211_PLINK_LISTEN:
 			case NL80211_PLINK_BLOCKED:
+			case NL80211_PLINK_OPN_SNT:
+			case NL80211_PLINK_OPN_RCVD:
+			case NL80211_PLINK_CNF_RCVD:
+			case NL80211_PLINK_HOLDING:
+				if (sta->plink_state == NL80211_PLINK_ESTAB)
+					changed = mesh_plink_dec_estab_count(
+							sdata);
 				sta->plink_state = params->plink_state;
 				break;
 			default:
 				/*  nothing  */
 				break;
 			}
-		else
+			ieee80211_bss_info_change_notify(sdata, changed);
+		} else {
 			switch (params->plink_action) {
 			case PLINK_ACTION_OPEN:
 				mesh_plink_open(sta);
@@ -1220,6 +1235,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 				mesh_plink_block(sta);
 				break;
 			}
+		}
 #endif
 	}
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 7c9215f..39897e0 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -307,6 +307,20 @@ extern int mesh_paths_generation;
 #ifdef CONFIG_MAC80211_MESH
 extern int mesh_allocated;
 
+static inline
+u32 mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
+{
+	atomic_inc(&sdata->u.mesh.estab_plinks);
+	return mesh_accept_plinks_update(sdata);
+}
+
+static inline
+u32 mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
+{
+	atomic_dec(&sdata->u.mesh.estab_plinks);
+	return mesh_accept_plinks_update(sdata);
+}
+
 static inline int mesh_plink_free_count(struct ieee80211_sub_if_data *sdata)
 {
 	return sdata->u.mesh.mshcfg.dot11MeshMaxPeerLinks -
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ca52dfd..3254522 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -41,20 +41,6 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		enum ieee80211_self_protected_actioncode action,
 		u8 *da, __le16 llid, __le16 plid, __le16 reason);
 
-static inline
-u32 mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
-{
-	atomic_inc(&sdata->u.mesh.estab_plinks);
-	return mesh_accept_plinks_update(sdata);
-}
-
-static inline
-u32 mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
-{
-	atomic_dec(&sdata->u.mesh.estab_plinks);
-	return mesh_accept_plinks_update(sdata);
-}
-
 /**
  * mesh_plink_fsm_restart - restart a mesh peer link finite state machine
  *
-- 
1.7.9.5

