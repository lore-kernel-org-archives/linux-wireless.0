Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64004 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab1HYBWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:22:09 -0400
Received: by yie30 with SMTP id 30so1334527yie.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:22:09 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 2/8] Revert "{nl,cfg,mac}80211: let userspace set RANN interval"
Date: Wed, 24 Aug 2011 18:21:47 -0700
Message-Id: <1314235313-4564-3-git-send-email-thomas@cozybit.com> (sfid-20110825_032218_497840_724A1B4B)
In-Reply-To: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
References: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

This reverts commit 0507e159a2b590666982b53ecf6fb2843a5bb423.
---
 include/linux/nl80211.h       |    4 ----
 include/net/cfg80211.h        |    1 -
 net/mac80211/cfg.c            |    4 ----
 net/mac80211/debugfs_netdev.c |    3 ---
 net/mac80211/mesh.c           |    3 +--
 net/mac80211/mesh.h           |    1 +
 net/mac80211/mesh_hwmp.c      |    8 ++++----
 net/wireless/mesh.c           |    2 --
 net/wireless/nl80211.c        |    7 -------
 9 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 20353bb..89dec16 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1861,9 +1861,6 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
  * source mesh point for path selection elements.
  *
- * @NL80211_MESHCONF_HWMP_RANN_INTERVAL:  The interval of time (in TUs) between
- * root announcements are transmitted.
- *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -1885,7 +1882,6 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 	NL80211_MESHCONF_HWMP_ROOTMODE,
 	NL80211_MESHCONF_ELEMENT_TTL,
-	NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2d88f06..497e583 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -755,7 +755,6 @@ struct mesh_config {
 	u16 dot11MeshHWMPpreqMinInterval;
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
 	u8  dot11MeshHWMPRootMode;
-	u16 dot11MeshHWMPRannInterval;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9995c83..c1fa577 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1137,10 +1137,6 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		conf->dot11MeshHWMPRootMode = nconf->dot11MeshHWMPRootMode;
 		ieee80211_mesh_root_setup(ifmsh);
 	}
-	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_RANN_INTERVAL, mask)) {
-		conf->dot11MeshHWMPRannInterval =
-			nconf->dot11MeshHWMPRannInterval;
-	}
 	return 0;
 }
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index bac9443..75ece3d 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -372,8 +372,6 @@ IEEE80211_IF_FILE(min_discovery_timeout,
 		u.mesh.mshcfg.min_discovery_timeout, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPRootMode,
 		u.mesh.mshcfg.dot11MeshHWMPRootMode, DEC);
-IEEE80211_IF_FILE(dot11MeshHWMPRannInterval,
-		u.mesh.mshcfg.dot11MeshHWMPRannInterval, DEC);
 #endif
 
 
@@ -488,7 +486,6 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(path_refresh_time);
 	MESHPARAMS_ADD(min_discovery_timeout);
 	MESHPARAMS_ADD(dot11MeshHWMPRootMode);
-	MESHPARAMS_ADD(dot11MeshHWMPRannInterval);
 #undef MESHPARAMS_ADD
 }
 #endif
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1c4f53c..e120fef 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -537,8 +537,7 @@ static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
 
 	mesh_path_tx_root_frame(sdata);
 	mod_timer(&ifmsh->mesh_path_root_timer,
-		  round_jiffies(jiffies +
-			  usecs_to_jiffies(ifmsh->mshcfg.dot11MeshHWMPRannInterval * 1024)));
+		  round_jiffies(jiffies + IEEE80211_MESH_RANN_INTERVAL));
 }
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 2027207..9d9116e 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -175,6 +175,7 @@ struct mesh_rmc {
 
 #define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
 #define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
+#define IEEE80211_MESH_RANN_INTERVAL	     (1 * HZ)
 
 #define MESH_DEFAULT_BEACON_INTERVAL		1000 	/* in 1024 us units */
 
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index ae3de75..7b517c4 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -695,7 +695,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	u8 ttl, flags, hopcount;
 	u8 *orig_addr;
 	u32 orig_sn, metric;
-	u32 interval = ifmsh->mshcfg.dot11MeshHWMPRannInterval;
+	u32 interval = cpu_to_le32(IEEE80211_MESH_RANN_INTERVAL);
 	bool root_is_gate;
 
 	ttl = rann->rann_ttl;
@@ -743,7 +743,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
 				       cpu_to_le32(orig_sn),
 				       0, NULL, 0, broadcast_addr,
-				       hopcount, ttl, cpu_to_le32(interval),
+				       hopcount, ttl, interval,
 				       cpu_to_le32(metric + mpath->metric),
 				       0, sdata);
 		mpath->sn = orig_sn;
@@ -1044,11 +1044,11 @@ void
 mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	u32 interval = ifmsh->mshcfg.dot11MeshHWMPRannInterval;
+	u32 interval = cpu_to_le32(IEEE80211_MESH_RANN_INTERVAL);
 
 	mesh_path_sel_frame_tx(MPATH_RANN, 0, sdata->vif.addr,
 			       cpu_to_le32(++ifmsh->sn),
 			       0, NULL, 0, broadcast_addr,
 			       0, sdata->u.mesh.mshcfg.element_ttl,
-			       cpu_to_le32(interval), 0, 0, sdata);
+			       interval, 0, 0, sdata);
 }
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index b5a39d4..5c11608 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -12,7 +12,6 @@
 #define MESH_HOLD_T 		100
 
 #define MESH_PATH_TIMEOUT	5000
-#define MESH_RANN_INTERVAL      5000
 
 /*
  * Minimum interval between two consecutive PREQs originated by the same
@@ -50,7 +49,6 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshHWMPmaxPREQretries = MESH_MAX_PREQ_RETRIES,
 	.path_refresh_time = MESH_PATH_REFRESH_TIME,
 	.min_discovery_timeout = MESH_MIN_DISCOVERY_TIMEOUT,
-	.dot11MeshHWMPRannInterval = MESH_RANN_INTERVAL,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bbf3d73..93ee888 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3035,8 +3035,6 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			cur_params.dot11MeshHWMPnetDiameterTraversalTime);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_HWMP_ROOTMODE,
 			cur_params.dot11MeshHWMPRootMode);
-	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_RANN_INTERVAL,
-			cur_params.dot11MeshHWMPRannInterval);
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
@@ -3065,7 +3063,6 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_ROOTMODE] = { .type = NLA_U8 },
-	[NL80211_MESHCONF_HWMP_RANN_INTERVAL] = { .type = NLA_U16 },
 };
 
 static const struct nla_policy
@@ -3144,10 +3141,6 @@ do {\
 			dot11MeshHWMPRootMode, mask,
 			NL80211_MESHCONF_HWMP_ROOTMODE,
 			nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-			dot11MeshHWMPRannInterval, mask,
-			NL80211_MESHCONF_HWMP_RANN_INTERVAL,
-			nla_get_u16);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.4.1

