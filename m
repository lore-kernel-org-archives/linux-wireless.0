Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46844 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbbFQI4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:56:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 14/14] mac80211: move mesh STA parameters code to own function
Date: Wed, 17 Jun 2015 10:41:15 +0200
Message-Id: <1434530475-3553-15-git-send-email-johannes@sipsolutions.net> (sfid-20150617_105636_517125_C78F6429)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code was always a bit awkward due to the 80-col restriction
and got worse in the previous patch. Refactor it a bit into its
own function to make it read nicer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 117 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 61 insertions(+), 56 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c9f8f34ac728..b145942a7624 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1019,6 +1019,65 @@ static int sta_apply_auth_flags(struct ieee80211_local *local,
 	return 0;
 }
 
+static void sta_apply_mesh_params(struct ieee80211_local *local,
+				  struct sta_info *sta,
+				  struct station_parameters *params)
+{
+#ifdef CONFIG_MAC80211_MESH
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u32 changed = 0;
+
+	if (params->sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE) {
+		switch (params->plink_state) {
+		case NL80211_PLINK_ESTAB:
+			if (sta->mesh->plink_state != NL80211_PLINK_ESTAB)
+				changed = mesh_plink_inc_estab_count(sdata);
+			sta->mesh->plink_state = params->plink_state;
+
+			ieee80211_mps_sta_status_update(sta);
+			changed |= ieee80211_mps_set_sta_local_pm(sta,
+				      sdata->u.mesh.mshcfg.power_mode);
+			break;
+		case NL80211_PLINK_LISTEN:
+		case NL80211_PLINK_BLOCKED:
+		case NL80211_PLINK_OPN_SNT:
+		case NL80211_PLINK_OPN_RCVD:
+		case NL80211_PLINK_CNF_RCVD:
+		case NL80211_PLINK_HOLDING:
+			if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
+				changed = mesh_plink_dec_estab_count(sdata);
+			sta->mesh->plink_state = params->plink_state;
+
+			ieee80211_mps_sta_status_update(sta);
+			changed |= ieee80211_mps_set_sta_local_pm(sta,
+					NL80211_MESH_POWER_UNKNOWN);
+			break;
+		default:
+			/*  nothing  */
+			break;
+		}
+	}
+
+	switch (params->plink_action) {
+	case NL80211_PLINK_ACTION_NO_ACTION:
+		/* nothing */
+		break;
+	case NL80211_PLINK_ACTION_OPEN:
+		changed |= mesh_plink_open(sta);
+		break;
+	case NL80211_PLINK_ACTION_BLOCK:
+		changed |= mesh_plink_block(sta);
+		break;
+	}
+
+	if (params->local_pm)
+		changed |= ieee80211_mps_set_sta_local_pm(sta,
+							  params->local_pm);
+
+	ieee80211_mbss_info_change_notify(sdata, changed);
+#endif
+}
+
 static int sta_apply_parameters(struct ieee80211_local *local,
 				struct sta_info *sta,
 				struct station_parameters *params)
@@ -1143,62 +1202,8 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 					      band, false);
 	}
 
-	if (ieee80211_vif_is_mesh(&sdata->vif)) {
-#ifdef CONFIG_MAC80211_MESH
-		u32 changed = 0;
-
-		if (params->sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE) {
-			switch (params->plink_state) {
-			case NL80211_PLINK_ESTAB:
-				if (sta->mesh->plink_state != NL80211_PLINK_ESTAB)
-					changed = mesh_plink_inc_estab_count(
-							sdata);
-				sta->mesh->plink_state = params->plink_state;
-
-				ieee80211_mps_sta_status_update(sta);
-				changed |= ieee80211_mps_set_sta_local_pm(sta,
-					      sdata->u.mesh.mshcfg.power_mode);
-				break;
-			case NL80211_PLINK_LISTEN:
-			case NL80211_PLINK_BLOCKED:
-			case NL80211_PLINK_OPN_SNT:
-			case NL80211_PLINK_OPN_RCVD:
-			case NL80211_PLINK_CNF_RCVD:
-			case NL80211_PLINK_HOLDING:
-				if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
-					changed = mesh_plink_dec_estab_count(
-							sdata);
-				sta->mesh->plink_state = params->plink_state;
-
-				ieee80211_mps_sta_status_update(sta);
-				changed |= ieee80211_mps_set_sta_local_pm(sta,
-						NL80211_MESH_POWER_UNKNOWN);
-				break;
-			default:
-				/*  nothing  */
-				break;
-			}
-		}
-
-		switch (params->plink_action) {
-		case NL80211_PLINK_ACTION_NO_ACTION:
-			/* nothing */
-			break;
-		case NL80211_PLINK_ACTION_OPEN:
-			changed |= mesh_plink_open(sta);
-			break;
-		case NL80211_PLINK_ACTION_BLOCK:
-			changed |= mesh_plink_block(sta);
-			break;
-		}
-
-		if (params->local_pm)
-			changed |=
-			      ieee80211_mps_set_sta_local_pm(sta,
-							     params->local_pm);
-		ieee80211_mbss_info_change_notify(sdata, changed);
-#endif
-	}
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		sta_apply_mesh_params(local, sta, params);
 
 	/* set the STA state after all sta info from usermode has been set */
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
-- 
2.1.4

