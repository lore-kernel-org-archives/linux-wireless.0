Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36771 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbbGCTmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 15:42:17 -0400
Received: by igrv9 with SMTP id v9so122230015igr.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jul 2015 12:42:17 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v2 1/3] mac80211: reorder mesh_plink to remove forward decl
Date: Fri,  3 Jul 2015 15:41:10 -0400
Message-Id: <1435952472-22752-2-git-send-email-me@bobcopeland.com> (sfid-20150703_214232_644098_17F8A650)
In-Reply-To: <1435952472-22752-1-git-send-email-me@bobcopeland.com>
References: <1435952472-22752-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mesh_plink_frame_tx() above the first caller to remove
the forward declaration.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_plink.c | 109 ++++++++++++++++++++++------------------------
 1 file changed, 52 insertions(+), 57 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 1a7d98398626..7b071e36e55e 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -53,11 +53,6 @@ static const char * const mplevents[] = {
 	[CLS_IGNR] = "CLS_IGNR"
 };
 
-static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
-			       enum ieee80211_self_protected_actioncode action,
-			       u8 *da, u16 llid, u16 plid, u16 reason);
-
-
 /* We only need a valid sta if user configured a minimum rssi_threshold. */
 static bool rssi_threshold_check(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta)
@@ -204,58 +199,6 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 	return BSS_CHANGED_HT;
 }
 
-/**
- * __mesh_plink_deactivate - deactivate mesh peer link
- *
- * @sta: mesh peer link to deactivate
- *
- * All mesh paths with this peer as next hop will be flushed
- * Returns beacon changed flag if the beacon content changed.
- *
- * Locking: the caller must hold sta->mesh->plink_lock
- */
-static u32 __mesh_plink_deactivate(struct sta_info *sta)
-{
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	u32 changed = 0;
-
-	lockdep_assert_held(&sta->mesh->plink_lock);
-
-	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
-		changed = mesh_plink_dec_estab_count(sdata);
-	sta->mesh->plink_state = NL80211_PLINK_BLOCKED;
-	mesh_path_flush_by_nexthop(sta);
-
-	ieee80211_mps_sta_status_update(sta);
-	changed |= ieee80211_mps_set_sta_local_pm(sta,
-			NL80211_MESH_POWER_UNKNOWN);
-
-	return changed;
-}
-
-/**
- * mesh_plink_deactivate - deactivate mesh peer link
- *
- * @sta: mesh peer link to deactivate
- *
- * All mesh paths with this peer as next hop will be flushed
- */
-u32 mesh_plink_deactivate(struct sta_info *sta)
-{
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	u32 changed;
-
-	spin_lock_bh(&sta->mesh->plink_lock);
-	changed = __mesh_plink_deactivate(sta);
-	sta->mesh->reason = WLAN_REASON_MESH_PEER_CANCELED;
-	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
-			    sta->sta.addr, sta->mesh->llid, sta->mesh->plid,
-			    sta->mesh->reason);
-	spin_unlock_bh(&sta->mesh->plink_lock);
-
-	return changed;
-}
-
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			       enum ieee80211_self_protected_actioncode action,
 			       u8 *da, u16 llid, u16 plid, u16 reason)
@@ -375,6 +318,58 @@ free:
 	return err;
 }
 
+/**
+ * __mesh_plink_deactivate - deactivate mesh peer link
+ *
+ * @sta: mesh peer link to deactivate
+ *
+ * All mesh paths with this peer as next hop will be flushed
+ * Returns beacon changed flag if the beacon content changed.
+ *
+ * Locking: the caller must hold sta->mesh->plink_lock
+ */
+static u32 __mesh_plink_deactivate(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u32 changed = 0;
+
+	lockdep_assert_held(&sta->mesh->plink_lock);
+
+	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
+		changed = mesh_plink_dec_estab_count(sdata);
+	sta->mesh->plink_state = NL80211_PLINK_BLOCKED;
+	mesh_path_flush_by_nexthop(sta);
+
+	ieee80211_mps_sta_status_update(sta);
+	changed |= ieee80211_mps_set_sta_local_pm(sta,
+			NL80211_MESH_POWER_UNKNOWN);
+
+	return changed;
+}
+
+/**
+ * mesh_plink_deactivate - deactivate mesh peer link
+ *
+ * @sta: mesh peer link to deactivate
+ *
+ * All mesh paths with this peer as next hop will be flushed
+ */
+u32 mesh_plink_deactivate(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u32 changed;
+
+	spin_lock_bh(&sta->mesh->plink_lock);
+	changed = __mesh_plink_deactivate(sta);
+	sta->mesh->reason = WLAN_REASON_MESH_PEER_CANCELED;
+	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
+			    sta->sta.addr, sta->mesh->llid, sta->mesh->plid,
+			    sta->mesh->reason);
+	spin_unlock_bh(&sta->mesh->plink_lock);
+
+	return changed;
+}
+
 static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 			       struct sta_info *sta,
 			       struct ieee802_11_elems *elems, bool insert)
-- 
2.1.4

