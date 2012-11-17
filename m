Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48699 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2KQGsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:53 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
Subject: [RFC 11/14] {cfg,nl}80211: add awake window to mesh config
Date: Fri, 16 Nov 2012 22:48:03 -0800
Message-Id: <1353134886-13256-12-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074914_483922_FA333CEC)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit adds the dot11MeshAwakeWindowDuration value to the mesh config.
The awake window is a duration in TU describing how long the STA will stay
awake after transmitting its beacon in PS mode.
The value can be changed during mesh operation.

Signed-off-by: Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
---
 include/net/cfg80211.h        |    3 +++
 include/uapi/linux/nl80211.h  |    3 +++
 net/mac80211/cfg.c            |    5 +++++
 net/mac80211/debugfs_netdev.c |    3 +++
 net/wireless/mesh.c           |    2 ++
 net/wireless/nl80211.c        |    8 +++++++-
 6 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ad6fabe..452932b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -896,6 +896,8 @@ struct bss_parameters {
  * @dtim_period: DTIM period to use
  * @power_mode: The default mesh power save mode which will be the initial
  *	setting for new peer links.
+ * @dot11MeshAwakeWindowDuration: The duration in TUs the STA will remain awake
+ *	after transmitting its beacon.
  */
 struct mesh_config {
 	u16 dot11MeshRetryTimeout;
@@ -926,6 +928,7 @@ struct mesh_config {
 	u16 beacon_interval;
 	u8 dtim_period;
 	enum nl80211_mesh_power_mode power_mode;
+	u16 dot11MeshAwakeWindowDuration;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index baac4e5..356af50 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2345,6 +2345,8 @@ enum nl80211_mesh_power_mode {
  *
  * @NL80211_MESHCONF_POWER_MODE: default link-specific power save mode
  *
+ * @NL80211_MESHCONF_AWAKE_WINDOW: awake window duration (in TUs)
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2377,6 +2379,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_BEACON_INTERVAL,
 	NL80211_MESHCONF_DTIM_PERIOD,
 	NL80211_MESHCONF_POWER_MODE,
+	NL80211_MESHCONF_AWAKE_WINDOW,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 32a1dbf..4321cd9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1692,6 +1692,11 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		conf->power_mode = nconf->power_mode;
 		ieee80211_local_ps_update(sdata);
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_AWAKE_WINDOW, mask)) {
+		conf->dot11MeshAwakeWindowDuration =
+			nconf->dot11MeshAwakeWindowDuration;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+	}
 	return 0;
 }
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 3a51988..58e58cb 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -520,6 +520,8 @@ IEEE80211_IF_FILE(beacon_interval,
 		  u.mesh.mshcfg.beacon_interval, DEC);
 IEEE80211_IF_FILE(dtim_period,
 		  u.mesh.mshcfg.dtim_period, DEC);
+IEEE80211_IF_FILE(dot11MeshAwakeWindowDuration,
+		  u.mesh.mshcfg.dot11MeshAwakeWindowDuration, DEC);
 #endif
 
 #define DEBUGFS_ADD_MODE(name, mode) \
@@ -626,6 +628,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshHWMPconfirmationInterval);
 	MESHPARAMS_ADD(beacon_interval);
 	MESHPARAMS_ADD(dtim_period);
+	MESHPARAMS_ADD(dot11MeshAwakeWindowDuration);
 #undef MESHPARAMS_ADD
 }
 #endif
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 1c7fab6..8fe70f3 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -46,6 +46,7 @@
 
 #define MESH_DEFAULT_BEACON_INTERVAL	1000 	/* in 1024 us units (=TUs) */
 #define MESH_DEFAULT_DTIM_PERIOD	4
+#define MESH_DEFAULT_AWAKE_WINDOW	10	/* in 1024 us units (=TUs) */
 
 const struct mesh_config default_mesh_config = {
 	.dot11MeshRetryTimeout = MESH_RET_T,
@@ -75,6 +76,7 @@ const struct mesh_config default_mesh_config = {
 	.beacon_interval = MESH_DEFAULT_BEACON_INTERVAL,
 	.dtim_period = MESH_DEFAULT_DTIM_PERIOD,
 	.power_mode = NL80211_MESH_POWER_ACTIVE,
+	.dot11MeshAwakeWindowDuration = MESH_DEFAULT_AWAKE_WINDOW,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dca2aac..9d45f83 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3796,7 +3796,9 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u8(msg, NL80211_MESHCONF_DTIM_PERIOD,
 		       cur_params.dtim_period) ||
 	    nla_put_u8(msg, NL80211_MESHCONF_POWER_MODE,
-		       cur_params.power_mode))
+		       cur_params.power_mode) ||
+	    nla_put_u16(msg, NL80211_MESHCONF_AWAKE_WINDOW,
+			cur_params.dot11MeshAwakeWindowDuration))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -3838,6 +3840,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_BEACON_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_DTIM_PERIOD] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_POWER_MODE] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_AWAKE_WINDOW] = { .type = NLA_U16 },
 };
 
 static const struct nla_policy
@@ -3965,6 +3968,9 @@ do {\
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

