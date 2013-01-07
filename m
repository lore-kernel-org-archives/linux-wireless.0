Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:44328 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3AGPFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 10:05:04 -0500
Received: by mail-bk0-f44.google.com with SMTP id w11so8612238bku.31
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 07:05:03 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>
Subject: [PATCHv2 2/6] mac80211: update mesh peer link counter during userspace peering
Date: Mon,  7 Jan 2013 16:04:49 +0100
Message-Id: <1357571093-12868-3-git-send-email-marco@cozybit.com> (sfid-20130107_160515_136359_0957AC6C)
In-Reply-To: <1357571093-12868-1-git-send-email-marco@cozybit.com>
References: <1357571093-12868-1-git-send-email-marco@cozybit.com>
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
index 47e0aca..def81d6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1211,18 +1211,33 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 
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
@@ -1231,6 +1246,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 				mesh_plink_block(sta);
 				break;
 			}
+		}
 #endif
 	}
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 84c28c6..c07f6fc 100644
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
index 4b274e9..9e04166 100644
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

