Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40085 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2KWUT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:19:27 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFCv2 10/13] {cfg,nl}80211: add awake window to mesh config
Date: Fri, 23 Nov 2012 12:18:51 -0800
Message-Id: <1353701934-12752-11-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_214526_765088_60209C36)
In-Reply-To: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit adds the dot11MeshAwakeWindowDuration value to the mesh config.
The awake window is a duration in TU describing how long the STA will stay
awake after transmitting its beacon in PS mode.
The value can be changed during mesh runtime.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 include/net/cfg80211.h        |    3 +++
 include/uapi/linux/nl80211.h  |    3 +++
 net/mac80211/debugfs_netdev.c |    3 +++
 net/wireless/mesh.c           |    2 ++
 net/wireless/nl80211.c        |    8 +++++++-
 5 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 74b6c59..6ee661b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -894,6 +894,8 @@ struct bss_parameters {
  *	a PREQ element for root path confirmation.
  * @power_mode: The default mesh power save mode which will be the initial
  *	setting for new peer links.
+ * @dot11MeshAwakeWindowDuration: The duration in TUs the STA will remain awake
+ *	after transmitting its beacon.
  */
 struct mesh_config {
 	u16 dot11MeshRetryTimeout;
@@ -922,6 +924,7 @@ struct mesh_config {
 	u16 dot11MeshHWMProotInterval;
 	u16 dot11MeshHWMPconfirmationInterval;
 	enum nl80211_mesh_power_mode power_mode;
+	u16 dot11MeshAwakeWindowDuration;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 62e5b68..086d613 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2341,6 +2341,8 @@ enum nl80211_mesh_power_mode {
  * @NL80211_MESHCONF_POWER_MODE: Default mesh power mode for new peer links.
  *	type &enum nl80211_mesh_power_mode (u8)
  *
+ * @NL80211_MESHCONF_AWAKE_WINDOW: awake window duration (in TUs)
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2371,6 +2373,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 	NL80211_MESHCONF_POWER_MODE,
+	NL80211_MESHCONF_AWAKE_WINDOW,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 99bef96..16151be 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -518,6 +518,8 @@ IEEE80211_IF_FILE(dot11MeshHWMPconfirmationInterval,
 		  u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval, DEC);
 IEEE80211_IF_FILE(power_mode,
 		  u.mesh.mshcfg.power_mode, DEC);
+IEEE80211_IF_FILE(dot11MeshAwakeWindowDuration,
+		  u.mesh.mshcfg.dot11MeshAwakeWindowDuration, DEC);
 #endif
 
 #define DEBUGFS_ADD_MODE(name, mode) \
@@ -623,6 +625,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshHWMProotInterval);
 	MESHPARAMS_ADD(dot11MeshHWMPconfirmationInterval);
 	MESHPARAMS_ADD(power_mode);
+	MESHPARAMS_ADD(dot11MeshAwakeWindowDuration);
 #undef MESHPARAMS_ADD
 }
 #endif
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 21f668b..e9da6ca 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -46,6 +46,7 @@
 
 #define MESH_DEFAULT_BEACON_INTERVAL	1000 	/* in 1024 us units (=TUs) */
 #define MESH_DEFAULT_DTIM_PERIOD	4
+#define MESH_DEFAULT_AWAKE_WINDOW	10	/* in 1024 us units (=TUs) */
 
 const struct mesh_config default_mesh_config = {
 	.dot11MeshRetryTimeout = MESH_RET_T,
@@ -73,6 +74,7 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshHWMProotInterval = MESH_ROOT_INTERVAL,
 	.dot11MeshHWMPconfirmationInterval = MESH_ROOT_CONFIRMATION_INTERVAL,
 	.power_mode = NL80211_MESH_POWER_ACTIVE,
+	.dot11MeshAwakeWindowDuration = MESH_DEFAULT_AWAKE_WINDOW,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 84ebe38..512e7b0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3800,7 +3800,9 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 			cur_params.dot11MeshHWMPconfirmationInterval) ||
 	    nla_put_u8(msg, NL80211_MESHCONF_POWER_MODE,
-		       cur_params.power_mode))
+		       cur_params.power_mode) ||
+	    nla_put_u16(msg, NL80211_MESHCONF_AWAKE_WINDOW,
+			cur_params.dot11MeshAwakeWindowDuration))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -3840,6 +3842,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_ROOT_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_POWER_MODE] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_AWAKE_WINDOW] = { .type = NLA_U16 },
 };
 
 static const struct nla_policy
@@ -3961,6 +3964,9 @@ do {\
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, power_mode,
 				  mask, NL80211_MESHCONF_POWER_MODE,
 				  nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshAwakeWindowDuration,
+				  mask, NL80211_MESHCONF_AWAKE_WINDOW,
+				  nla_get_u16);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.9.5

