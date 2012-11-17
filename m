Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:39696 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2KQGsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:35 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC 01/14] {nl,cfg,mac}80211: add beacon interval and DTIM period to mesh config
Date: Fri, 16 Nov 2012 22:47:53 -0800
Message-Id: <1353134886-13256-2-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074838_606880_AF1877A1)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moves the default mesh beacon interval and DTIM period to cfg80211 and
makes it accessible to nl80211. This enables modifying both values at
mesh runtime.
One safety check is added that keeps the DTIM counter within the allowed
limits.

NOTE: In a mesh with links in PS mode it is not advised to use the default
parameters 1000:4, as these cause excessive buffering delays that exceed
various timeouts (e.g. HWMP path request).

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 include/net/cfg80211.h        |    4 ++++
 include/uapi/linux/nl80211.h  |    6 ++++++
 net/mac80211/cfg.c            |   12 ++++++++++++
 net/mac80211/debugfs_netdev.c |    6 ++++++
 net/mac80211/mesh.c           |    3 ++-
 net/mac80211/mesh.h           |    2 --
 net/mac80211/tx.c             |    3 ++-
 net/wireless/mesh.c           |    5 +++++
 net/wireless/nl80211.c        |   14 +++++++++++++-
 9 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c696457..4c6668f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -878,6 +878,8 @@ struct bss_parameters {
  * @dot11MeshHWMPconfirmationInterval: The minimum interval of time (in TUs)
  *	during which a mesh STA can send only one Action frame containing
  *	a PREQ element for root path confirmation.
+ * @beacon_interval: beacon interval to use
+ * @dtim_period: DTIM period to use
  */
 struct mesh_config {
 	u16 dot11MeshRetryTimeout;
@@ -905,6 +907,8 @@ struct mesh_config {
 	u32 dot11MeshHWMPactivePathToRootTimeout;
 	u16 dot11MeshHWMProotInterval;
 	u16 dot11MeshHWMPconfirmationInterval;
+	u16 beacon_interval;
+	u8 dtim_period;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 617d0fb..3306e79 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2296,6 +2296,10 @@ enum nl80211_mntr_flags {
  *	(in TUs) during which a mesh STA can send only one Action frame
  *	containing a PREQ element for root path confirmation.
  *
+ * @NL80211_MESHCONF_BEACON_INTERVAL: beacon interval to use
+ *
+ * @NL80211_MESHCONF_DTIM_PERIOD: DTIM period to use
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2325,6 +2329,8 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
 	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
+	NL80211_MESHCONF_BEACON_INTERVAL,
+	NL80211_MESHCONF_DTIM_PERIOD,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7669002..aef8445 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1666,6 +1666,18 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL, mask))
 		conf->dot11MeshHWMPconfirmationInterval =
 			nconf->dot11MeshHWMPconfirmationInterval;
+	if (_chg_mesh_attr(NL80211_MESHCONF_BEACON_INTERVAL, mask)) {
+		conf->beacon_interval = nconf->beacon_interval;
+		sdata->vif.bss_conf.beacon_int = nconf->beacon_interval;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
+				BSS_CHANGED_BEACON_INT |
+				BSS_CHANGED_BEACON_ENABLED);
+	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_DTIM_PERIOD, mask)) {
+		conf->dtim_period = nconf->dtim_period;
+		sdata->vif.bss_conf.dtim_period = nconf->dtim_period;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+	}
 	return 0;
 }
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 3393ad5..3a51988 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -516,6 +516,10 @@ IEEE80211_IF_FILE(dot11MeshHWMProotInterval,
 		  u.mesh.mshcfg.dot11MeshHWMProotInterval, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPconfirmationInterval,
 		  u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval, DEC);
+IEEE80211_IF_FILE(beacon_interval,
+		  u.mesh.mshcfg.beacon_interval, DEC);
+IEEE80211_IF_FILE(dtim_period,
+		  u.mesh.mshcfg.dtim_period, DEC);
 #endif
 
 #define DEBUGFS_ADD_MODE(name, mode) \
@@ -620,6 +624,8 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshHWMPactivePathToRootTimeout);
 	MESHPARAMS_ADD(dot11MeshHWMProotInterval);
 	MESHPARAMS_ADD(dot11MeshHWMPconfirmationInterval);
+	MESHPARAMS_ADD(beacon_interval);
+	MESHPARAMS_ADD(dtim_period);
 #undef MESHPARAMS_ADD
 }
 #endif
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a350cab..827a7ca 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -630,7 +630,8 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_queue_work(&local->hw, &sdata->work);
 	sdata->vif.bss_conf.ht_operation_mode =
 				ifmsh->mshcfg.ht_opmode;
-	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
+	sdata->vif.bss_conf.beacon_int = ifmsh->mshcfg.beacon_interval;
+	sdata->vif.bss_conf.dtim_period = ifmsh->mshcfg.dtim_period;
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(sdata->local,
 					  ieee80211_get_sdata_band(sdata));
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 9285f3f..1fc5672 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -205,8 +205,6 @@ struct mesh_rmc {
 #define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
 #define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
 
-#define MESH_DEFAULT_BEACON_INTERVAL		1000 	/* in 1024 us units */
-
 #define MESH_PATH_EXPIRE (600 * HZ)
 
 /* Default maximum number of plinks per interface */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6f19818..de8a59b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2276,7 +2276,8 @@ static void ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 		have_bits = !bitmap_empty((unsigned long*)ps->tim,
 					  IEEE80211_MAX_AID+1);
 
-	if (ps->dtim_count == 0)
+	if (ps->dtim_count == 0 ||
+	    ps->dtim_count >= sdata->vif.bss_conf.dtim_period)
 		ps->dtim_count = sdata->vif.bss_conf.dtim_period - 1;
 	else
 		ps->dtim_count--;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 966cfc4..e461502 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -44,6 +44,9 @@
 
 #define MESH_SYNC_NEIGHBOR_OFFSET_MAX 50
 
+#define MESH_DEFAULT_BEACON_INTERVAL	1000 	/* in 1024 us units (=TUs) */
+#define MESH_DEFAULT_DTIM_PERIOD	4
+
 const struct mesh_config default_mesh_config = {
 	.dot11MeshRetryTimeout = MESH_RET_T,
 	.dot11MeshConfirmTimeout = MESH_CONF_T,
@@ -69,6 +72,8 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshHWMPactivePathToRootTimeout = MESH_PATH_TO_ROOT_TIMEOUT,
 	.dot11MeshHWMProotInterval = MESH_ROOT_INTERVAL,
 	.dot11MeshHWMPconfirmationInterval = MESH_ROOT_CONFIRMATION_INTERVAL,
+	.beacon_interval = MESH_DEFAULT_BEACON_INTERVAL,
+	.dtim_period = MESH_DEFAULT_DTIM_PERIOD,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8c08578..636634d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3770,7 +3770,11 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 			cur_params.dot11MeshHWMProotInterval) ||
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
-			cur_params.dot11MeshHWMPconfirmationInterval))
+			cur_params.dot11MeshHWMPconfirmationInterval) ||
+	    nla_put_u16(msg, NL80211_MESHCONF_BEACON_INTERVAL,
+			cur_params.beacon_interval) ||
+	    nla_put_u8(msg, NL80211_MESHCONF_DTIM_PERIOD,
+		       cur_params.dtim_period))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -3809,6 +3813,8 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_ROOT_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_BEACON_INTERVAL] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_DTIM_PERIOD] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -3927,6 +3933,12 @@ do {\
 				  dot11MeshHWMPconfirmationInterval, mask,
 				  NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, beacon_interval,
+				  mask, NL80211_MESHCONF_BEACON_INTERVAL,
+				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dtim_period,
+				  mask, NL80211_MESHCONF_DTIM_PERIOD,
+				  nla_get_u8);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.9.5

