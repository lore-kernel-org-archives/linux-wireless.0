Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64694 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab1ECX5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:38 -0400
Received: by pwi15 with SMTP id 15so278996pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:37 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 05/13] nl80211: Let userspace drive the peer link management states.
Date: Tue,  3 May 2011 16:57:11 -0700
Message-Id: <1304467039-7730-6-git-send-email-javier@cozybit.com> (sfid-20110504_015743_802852_BC8B787A)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h |    4 ++++
 include/net/cfg80211.h  |   29 +++++++++++++++++++++++++++++
 net/mac80211/cfg.c      |   30 +++++++++++++++++++++---------
 net/mac80211/sta_info.h |   23 -----------------------
 net/wireless/nl80211.c  |    6 ++++++
 5 files changed, 60 insertions(+), 32 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 8684c0a..48fb8cc 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -902,6 +902,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_SUPPORT_MESH_AUTH: Currently, this means the underlying driver
  *	allows auth frames in a mesh to be passed to userspace for processing via
  *	the @NL80211_MESH_SETUP_USERSPACE_AUTH flag.
+ * @NL80211_ATTR_STA_PLINK_STATE: The state of a mesh peer link. Used when
+ *      userspace is driving the peer link management state machine.
+ *      @NL80211_MESH_SETUP_USERSPACE_AMPE must be enabled.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1091,6 +1094,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
 
 	NL80211_ATTR_SUPPORT_MESH_AUTH,
+	NL80211_ATTR_STA_PLINK_STATE,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5e4f87b..e956ffb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -372,6 +372,33 @@ enum plink_actions {
 };
 
 /**
+ * enum plink_states - state of a mesh peer link finite state machine
+ *
+ * @PLINK_LISTEN: initial state, considered the implicit state of non
+ * existant mesh peer links
+ * @PLINK_OPN_SNT: mesh plink open frame has been sent to this mesh
+ * peer @PLINK_OPN_RCVD: mesh plink open frame has been received from
+ * this mesh peer
+ * @PLINK_CNF_RCVD: mesh plink confirm frame has been received from
+ * this mesh peer
+ * @PLINK_ESTAB: mesh peer link is established
+ * @PLINK_HOLDING: mesh peer link is being closed or cancelled
+ * @PLINK_BLOCKED: all frames transmitted from this mesh plink are
+ * discarded
+ * @PLINK_INVALID: reserved
+ */
+enum plink_state {
+	PLINK_LISTEN,
+	PLINK_OPN_SNT,
+	PLINK_OPN_RCVD,
+	PLINK_CNF_RCVD,
+	PLINK_ESTAB,
+	PLINK_HOLDING,
+	PLINK_BLOCKED,
+	PLINK_INVALID,
+};
+
+/**
  * struct station_parameters - station parameters
  *
  * Used to change and create a new station.
@@ -387,6 +414,7 @@ enum plink_actions {
  * @listen_interval: listen interval or -1 for no change
  * @aid: AID or zero for no change
  * @plink_action: plink action to take
+ * @plink_state: set the peer link state for a station
  * @ht_capa: HT capabilities of station
  */
 struct station_parameters {
@@ -397,6 +425,7 @@ struct station_parameters {
 	u16 aid;
 	u8 supported_rates_len;
 	u8 plink_action;
+	u8 plink_state;
 	struct ieee80211_ht_cap *ht_capa;
 };
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7ea13d3..dbc5bcb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -734,15 +734,27 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 						  params->ht_capa,
 						  &sta->sta.ht_cap);
 
-	if (ieee80211_vif_is_mesh(&sdata->vif) && params->plink_action) {
-		switch (params->plink_action) {
-		case PLINK_ACTION_OPEN:
-			mesh_plink_open(sta);
-			break;
-		case PLINK_ACTION_BLOCK:
-			mesh_plink_block(sta);
-			break;
-		}
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED)
+			switch (params->plink_state) {
+			case PLINK_LISTEN:
+			case PLINK_ESTAB:
+			case PLINK_BLOCKED:
+				sta->plink_state = params->plink_state;
+				break;
+			default:
+				/*  nothing  */
+				break;
+			}
+		else
+			switch (params->plink_action) {
+			case PLINK_ACTION_OPEN:
+				mesh_plink_open(sta);
+				break;
+			case PLINK_ACTION_BLOCK:
+				mesh_plink_block(sta);
+				break;
+			}
 	}
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index aa0adcb..f00b4dc 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -174,29 +174,6 @@ struct sta_ampdu_mlme {
 
 
 /**
- * enum plink_state - state of a mesh peer link finite state machine
- *
- * @PLINK_LISTEN: initial state, considered the implicit state of non existent
- * 	mesh peer links
- * @PLINK_OPN_SNT: mesh plink open frame has been sent to this mesh peer
- * @PLINK_OPN_RCVD: mesh plink open frame has been received from this mesh peer
- * @PLINK_CNF_RCVD: mesh plink confirm frame has been received from this mesh
- * 	peer
- * @PLINK_ESTAB: mesh peer link is established
- * @PLINK_HOLDING: mesh peer link is being closed or cancelled
- * @PLINK_BLOCKED: all frames transmitted from this mesh plink are discarded
- */
-enum plink_state {
-	PLINK_LISTEN,
-	PLINK_OPN_SNT,
-	PLINK_OPN_RCVD,
-	PLINK_CNF_RCVD,
-	PLINK_ESTAB,
-	PLINK_HOLDING,
-	PLINK_BLOCKED
-};
-
-/**
  * struct sta_info - STA information
  *
  * This structure collects information about a station that
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7c1c4de..49f220a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -173,6 +173,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MCAST_RATE] = { .type = NLA_U32 },
 	[NL80211_ATTR_OFFCHANNEL_TX_OK] = { .type = NLA_FLAG },
 	[NL80211_ATTR_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_STA_PLINK_STATE] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -2216,6 +2217,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	memset(&params, 0, sizeof(params));
 
 	params.listen_interval = -1;
+	params.plink_state = PLINK_INVALID;
 
 	if (info->attrs[NL80211_ATTR_STA_AID])
 		return -EINVAL;
@@ -2247,6 +2249,10 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		params.plink_action =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
 
+	if (info->attrs[NL80211_ATTR_STA_PLINK_STATE])
+		params.plink_state =
+		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
+
 	err = get_vlan(info, rdev, &params.vlan);
 	if (err)
 		goto out;
-- 
1.7.1

