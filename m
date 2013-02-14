Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759244Ab3BNWbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 17:31:19 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, thomas@cozybit.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] cfg80211: clean up mesh plink station change API
Date: Thu, 14 Feb 2013 23:31:15 +0100
Message-Id: <1360881075-12522-1-git-send-email-johannes@sipsolutions.net> (sfid-20130214_233123_217712_314920E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make the ability to leave the plink_state unchanged not use a
magic -1 variable that isn't in the enum, but an explicit change
flag; reject invalid plink states or actions and move the needed
constants for plink actions to the right header file. Also
reject plink_state changes for non-mesh interfaces.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 15 ++-------------
 include/uapi/linux/nl80211.h | 20 +++++++++++++++++++-
 net/mac80211/cfg.c           | 14 +++++++++++---
 net/wireless/nl80211.c       | 22 +++++++++++++++++-----
 4 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b518b54..ed73542 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -611,22 +611,10 @@ struct cfg80211_ap_settings {
 };
 
 /**
- * enum plink_action - actions to perform in mesh peers
- *
- * @PLINK_ACTION_INVALID: action 0 is reserved
- * @PLINK_ACTION_OPEN: start mesh peer link establishment
- * @PLINK_ACTION_BLOCK: block traffic from this mesh peer
- */
-enum plink_actions {
-	PLINK_ACTION_INVALID,
-	PLINK_ACTION_OPEN,
-	PLINK_ACTION_BLOCK,
-};
-
-/**
  * enum station_parameters_apply_mask - station parameter values to apply
  * @STATION_PARAM_APPLY_UAPSD: apply new uAPSD parameters (uapsd_queues, max_sp)
  * @STATION_PARAM_APPLY_CAPABILITY: apply new capability
+ * @STATION_PARAM_APPLY_PLINK_STATE: apply new plink state
  *
  * Not all station parameters have in-band "no change" signalling,
  * for those that don't these flags will are used.
@@ -634,6 +622,7 @@ enum plink_actions {
 enum station_parameters_apply_mask {
 	STATION_PARAM_APPLY_UAPSD = BIT(0),
 	STATION_PARAM_APPLY_CAPABILITY = BIT(1),
+	STATION_PARAM_APPLY_PLINK_STATE = BIT(2),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5354cc6..5b7601f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -890,7 +890,8 @@ enum nl80211_commands {
  *	consisting of a nested array.
  *
  * @NL80211_ATTR_MESH_ID: mesh id (1-32 bytes).
- * @NL80211_ATTR_STA_PLINK_ACTION: action to perform on the mesh peer link.
+ * @NL80211_ATTR_STA_PLINK_ACTION: action to perform on the mesh peer link
+ *	(see &enum nl80211_plink_action).
  * @NL80211_ATTR_MPATH_NEXT_HOP: MAC address of the next hop for a mesh path.
  * @NL80211_ATTR_MPATH_INFO: information about a mesh_path, part of mesh path
  * 	info given for %NL80211_CMD_GET_MPATH, nested attribute described at
@@ -3323,6 +3324,23 @@ enum nl80211_plink_state {
 	MAX_NL80211_PLINK_STATES = NUM_NL80211_PLINK_STATES - 1
 };
 
+/**
+ * enum nl80211_plink_action - actions to perform in mesh peers
+ *
+ * @NL80211_PLINK_ACTION_NO_ACTION: perform no action
+ * @NL80211_PLINK_ACTION_OPEN: start mesh peer link establishment
+ * @NL80211_PLINK_ACTION_BLOCK: block traffic from this mesh peer
+ * @NUM_NL80211_PLINK_ACTIONS: number of possible actions
+ */
+enum plink_actions {
+	NL80211_PLINK_ACTION_NO_ACTION,
+	NL80211_PLINK_ACTION_OPEN,
+	NL80211_PLINK_ACTION_BLOCK,
+
+	NUM_NL80211_PLINK_ACTIONS,
+};
+
+
 #define NL80211_KCK_LEN			16
 #define NL80211_KEK_LEN			16
 #define NL80211_REPLAY_CTR_LEN		8
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 909053a..8e1a03e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1261,7 +1261,9 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		u32 changed = 0;
-		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED) {
+		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED &&
+		    (params->sta_modify_mask &
+					STATION_PARAM_APPLY_PLINK_STATE)) {
 			switch (params->plink_state) {
 			case NL80211_PLINK_ESTAB:
 				if (sta->plink_state != NL80211_PLINK_ESTAB)
@@ -1292,12 +1294,18 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 				/*  nothing  */
 				break;
 			}
+		} else if (params->sta_modify_mask &
+					STATION_PARAM_APPLY_PLINK_STATE) {
+			return -EINVAL;
 		} else {
 			switch (params->plink_action) {
-			case PLINK_ACTION_OPEN:
+			case NL80211_PLINK_ACTION_NO_ACTION:
+				/* nothing */
+				break;
+			case NL80211_PLINK_ACTION_OPEN:
 				changed |= mesh_plink_open(sta);
 				break;
-			case PLINK_ACTION_BLOCK:
+			case NL80211_PLINK_ACTION_BLOCK:
 				changed |= mesh_plink_block(sta);
 				break;
 			}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f3a07d0..ec3417b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3632,7 +3632,6 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	memset(&params, 0, sizeof(params));
 
 	params.listen_interval = -1;
-	params.plink_state = -1;
 
 	if (info->attrs[NL80211_ATTR_STA_AID])
 		return -EINVAL;
@@ -3671,13 +3670,20 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	if (parse_station_flags(info, dev->ieee80211_ptr->iftype, &params))
 		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION])
+	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION]) {
 		params.plink_action =
-		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
+			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
+		if (params.plink_action >= NUM_NL80211_PLINK_ACTIONS)
+			return -EINVAL;
+	}
 
-	if (info->attrs[NL80211_ATTR_STA_PLINK_STATE])
+	if (info->attrs[NL80211_ATTR_STA_PLINK_STATE]) {
 		params.plink_state =
-		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
+			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
+		if (params.plink_state >= NUM_NL80211_PLINK_STATES)
+			return -EINVAL;
+		params.sta_modify_mask |= STATION_PARAM_APPLY_PLINK_STATE;
+	}
 
 	if (info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]) {
 		enum nl80211_mesh_power_mode pm = nla_get_u32(
@@ -3699,6 +3705,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		if (params.local_pm)
 			return -EINVAL;
+		if (params.sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE)
+			return -EINVAL;
 
 		/* TDLS can't be set, ... */
 		if (params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
@@ -3762,6 +3770,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		if (params.local_pm)
 			return -EINVAL;
+		if (params.sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE)
+			return -EINVAL;
 		/* reject any changes other than AUTHORIZED or WME (for TDLS) */
 		if (params.sta_flags_mask & ~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
 					      BIT(NL80211_STA_FLAG_WME)))
@@ -3773,6 +3783,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		if (params.local_pm)
 			return -EINVAL;
+		if (params.sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE)
+			return -EINVAL;
 		if (info->attrs[NL80211_ATTR_HT_CAPABILITY] ||
 		    info->attrs[NL80211_ATTR_VHT_CAPABILITY])
 			return -EINVAL;
-- 
1.8.0

