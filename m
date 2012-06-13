Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45403 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab2FMLCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 07:02:31 -0400
Received: by pbbrp8 with SMTP id rp8so2132045pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 04:02:31 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v4] {nl,cfg,mac}80211: implement dot11MeshHWMProotInterval and dot11MeshHWMPactivePathToRootTimeout
Date: Wed, 13 Jun 2012 19:01:34 +0800
Message-Id: <1339585294-10652-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120613_130256_176102_429A426F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the mesh configuration parameters dot11MeshHWMProotInterval and
dot11MeshHWMPactivePathToRootTimeout to be used by proactive PREQ mechanism.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2: avoid renumbering the old command ids (Johannes)
v3: adhere the coding style and add kernel-doc (Johannes)
v4: rebase to coding-style/kernel-doc patch (Johannes)

 include/linux/nl80211.h       |    9 +++++++++
 include/net/cfg80211.h        |    7 +++++++
 net/mac80211/cfg.c            |    6 ++++++
 net/mac80211/debugfs_netdev.c |    6 ++++++
 net/wireless/mesh.c           |    4 ++++
 net/wireless/nl80211.c        |   15 ++++++++++++++-
 6 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index c61e162..cf279bd 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2164,6 +2164,13 @@ enum nl80211_mntr_flags {
  *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
+ * @NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT: The time (in TUs) for
+ *	which mesh STAs receiving a proactive PREQ shall consider the forwarding
+ *	information to the root mesh STA to be valid.
+ *
+ * @NL80211_MESHCONF_HWMP_ROOT_INTERVAL: The interval of time (in TUs) between
+ *	proactive PREQs are transmitted.
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2190,6 +2197,8 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_RSSI_THRESHOLD,
 	NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
 	NL80211_MESHCONF_HT_OPMODE,
+	NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
+	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 778e533..3d04da9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -842,6 +842,11 @@ struct bss_parameters {
  * @rssi_threshold: the threshold for average signal strength of candidate
  *	station to establish a peer link
  * @ht_opmode: mesh HT protection mode
+ * @dot11MeshHWMPactivePathToRootTimeout: The time (in TUs) for which mesh STAs
+ *	receiving a proactive PREQ shall consider the forwarding information to
+ *	the root mesh STA to be valid.
+ * @dot11MeshHWMProotInterval: The interval of time (in TUs) between proactive
+ *	PREQs are transmitted.
  */
 struct mesh_config {
 	u16 dot11MeshRetryTimeout;
@@ -866,6 +871,8 @@ struct mesh_config {
 	bool dot11MeshForwarding;
 	s32 rssi_threshold;
 	u16 ht_opmode;
+	u32 dot11MeshHWMPactivePathToRootTimeout;
+	u16 dot11MeshHWMProotInterval;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f41f9be..af0fce3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1589,6 +1589,12 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		sdata->vif.bss_conf.ht_operation_mode = nconf->ht_opmode;
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT, mask))
+		conf->dot11MeshHWMPactivePathToRootTimeout =
+			nconf->dot11MeshHWMPactivePathToRootTimeout;
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ROOT_INTERVAL, mask))
+		conf->dot11MeshHWMProotInterval =
+			nconf->dot11MeshHWMProotInterval;
 	return 0;
 }
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index c429417..a8cea70 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -510,6 +510,10 @@ IEEE80211_IF_FILE(dot11MeshHWMPRannInterval,
 IEEE80211_IF_FILE(dot11MeshForwarding, u.mesh.mshcfg.dot11MeshForwarding, DEC);
 IEEE80211_IF_FILE(rssi_threshold, u.mesh.mshcfg.rssi_threshold, DEC);
 IEEE80211_IF_FILE(ht_opmode, u.mesh.mshcfg.ht_opmode, DEC);
+IEEE80211_IF_FILE(dot11MeshHWMPactivePathToRootTimeout,
+		  u.mesh.mshcfg.dot11MeshHWMPactivePathToRootTimeout, DEC);
+IEEE80211_IF_FILE(dot11MeshHWMProotInterval,
+		  u.mesh.mshcfg.dot11MeshHWMProotInterval, DEC);
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
index dd94ee5..c0cf53e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3469,7 +3469,11 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u32(msg, NL80211_MESHCONF_RSSI_THRESHOLD,
 			cur_params.rssi_threshold) ||
 	    nla_put_u32(msg, NL80211_MESHCONF_HT_OPMODE,
-			cur_params.ht_opmode))
+			cur_params.ht_opmode) ||
+	    nla_put_u32(msg, NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
+			cur_params.dot11MeshHWMPactivePathToRootTimeout) ||
+	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
+			cur_params.dot11MeshHWMProotInterval))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -3505,6 +3509,8 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_FORWARDING] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_RSSI_THRESHOLD] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HT_OPMODE] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_HWMP_ROOT_INTERVAL] = { .type = NLA_U16 },
 };
 
 static const struct nla_policy
@@ -3612,6 +3618,13 @@ do {\
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode,
 				  mask, NL80211_MESHCONF_HT_OPMODE,
 				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathToRootTimeout,
+				  mask,
+				  NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
+				  nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMProotInterval,
+				  mask, NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
+				  nla_get_u16);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.0.4

