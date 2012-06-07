Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34932 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2FGEjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 00:39:48 -0400
Received: by pbbrp8 with SMTP id rp8so502624pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 21:39:48 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2 1/4] {nl,cfg,mac}80211: implement dot11MeshHWMProotInterval and dot11MeshHWMPactivePathToRootTimeout
Date: Thu,  7 Jun 2012 12:39:20 +0800
Message-Id: <1339043963-2043-2-git-send-email-yeohchunyeow@gmail.com> (sfid-20120607_063954_292969_044C248C)
In-Reply-To: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
References: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the mesh configuration parameters dot11MeshHWMProotInterval and
dot11MeshHWMPactivePathToRootTimeout to be used by proactive PREQ mechanism.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2: avoid renumbering the old command ids (Johannes)

 include/linux/nl80211.h       |    9 +++++++++
 include/net/cfg80211.h        |    2 ++
 net/mac80211/cfg.c            |    8 ++++++++
 net/mac80211/debugfs_netdev.c |    6 ++++++
 net/wireless/mesh.c           |    4 ++++
 net/wireless/nl80211.c        |   17 ++++++++++++++++-
 6 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 970afdf..b91b3fe 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2162,6 +2162,13 @@ enum nl80211_mntr_flags {
  *
  * @NL80211_MESHCONF_HT_OPMODE: set mesh HT protection mode.
  *
+ * @NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT: The time (in TUs) for
+ * which mesh STAs receiving a proactive PREQ shall consider the forwarding
+ * information to the root mesh STA to be valid.
+ *
+ * @NL80211_MESHCONF_HWMP_ROOT_INTERVAL: The interval of time (in TUs) between
+ * proactive PREQs are transmitted.
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2188,6 +2195,8 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_RSSI_THRESHOLD,
 	NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
 	NL80211_MESHCONF_HT_OPMODE,
+	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT,
+	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7319f25..dfc8939 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -827,6 +827,8 @@ struct mesh_config {
 	bool dot11MeshForwarding;
 	s32 rssi_threshold;
 	u16 ht_opmode;
+	u32 dot11MeshHWMPactivePathToRootTimeout;
+	u16 dot11MeshHWMProotInterval;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 498c94e..38e743f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1590,6 +1590,14 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		sdata->vif.bss_conf.ht_operation_mode = nconf->ht_opmode;
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT,
+	    mask))
+		conf->dot11MeshHWMPactivePathToRootTimeout =
+			nconf->dot11MeshHWMPactivePathToRootTimeout;
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ROOT_INTERVAL, mask)) {
+		conf->dot11MeshHWMProotInterval =
+			nconf->dot11MeshHWMProotInterval;
+	}
 	return 0;
 }
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index d4272ff..59d2086 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -510,6 +510,10 @@ IEEE80211_IF_FILE(dot11MeshHWMPRannInterval,
 IEEE80211_IF_FILE(dot11MeshForwarding, u.mesh.mshcfg.dot11MeshForwarding, DEC);
 IEEE80211_IF_FILE(rssi_threshold, u.mesh.mshcfg.rssi_threshold, DEC);
 IEEE80211_IF_FILE(ht_opmode, u.mesh.mshcfg.ht_opmode, DEC);
+IEEE80211_IF_FILE(dot11MeshHWMPactivePathToRootTimeout,
+		u.mesh.mshcfg.dot11MeshHWMPactivePathToRootTimeout, DEC);
+IEEE80211_IF_FILE(dot11MeshHWMProotInterval,
+		u.mesh.mshcfg.dot11MeshHWMProotInterval, DEC);
 #endif
 
 #define DEBUGFS_ADD_MODE(name, mode) \
@@ -611,6 +615,8 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshGateAnnouncementProtocol);
 	MESHPARAMS_ADD(rssi_threshold);
 	MESHPARAMS_ADD(ht_opmode);
+	MESHPARAMS_ADD(dot11MeshHWMPactivePathToRootTimeout);
+	MESHPARAMS_ADD(dot11MeshHWMProotInterval);
 #undef MESHPARAMS_ADD
 }
 #endif
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index b44c736..2f141cf 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -14,6 +14,8 @@
 
 #define MESH_PATH_TIMEOUT	5000
 #define MESH_RANN_INTERVAL      5000
+#define MESH_PATH_TO_ROOT_TIMEOUT      6000
+#define MESH_ROOT_INTERVAL     5000
 
 /*
  * Minimum interval between two consecutive PREQs originated by the same
@@ -62,6 +64,8 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshForwarding = true,
 	.rssi_threshold = MESH_RSSI_THRESHOLD,
 	.ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED,
+	.dot11MeshHWMPactivePathToRootTimeout = MESH_PATH_TO_ROOT_TIMEOUT,
+	.dot11MeshHWMProotInterval = MESH_ROOT_INTERVAL,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ae54b8..cc554b9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3469,7 +3469,11 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u32(msg, NL80211_MESHCONF_RSSI_THRESHOLD,
 			cur_params.rssi_threshold) ||
 	    nla_put_u32(msg, NL80211_MESHCONF_HT_OPMODE,
-			cur_params.ht_opmode))
+			cur_params.ht_opmode) ||
+	    nla_put_u32(msg, NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT,
+			cur_params.dot11MeshHWMPactivePathToRootTimeout) ||
+	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
+			cur_params.dot11MeshHWMProotInterval))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -3506,6 +3510,10 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_FORWARDING] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_RSSI_THRESHOLD] = { .type = NLA_U32},
 	[NL80211_MESHCONF_HT_OPMODE] = { .type = NLA_U16},
+	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT] = {
+		.type = NLA_U32
+	},
+	[NL80211_MESHCONF_HWMP_ROOT_INTERVAL] = { .type = NLA_U16 },
 };
 
 static const struct nla_policy
@@ -3605,6 +3613,13 @@ do {\
 			mask, NL80211_MESHCONF_RSSI_THRESHOLD, nla_get_u32);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode,
 			mask, NL80211_MESHCONF_HT_OPMODE, nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathToRootTimeout,
+			mask, NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT,
+			nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
+			dot11MeshHWMProotInterval, mask,
+			NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
+			nla_get_u16);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.0.4

