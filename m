Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45445 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab1HYBWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:22:07 -0400
Received: by gxk21 with SMTP id 21so1333929gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:22:07 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 1/8] Revert "{nl,cfg,mac}80211: let userspace make meshif mesh gate"
Date: Wed, 24 Aug 2011 18:21:46 -0700
Message-Id: <1314235313-4564-2-git-send-email-thomas@cozybit.com> (sfid-20110825_032215_114225_A335DA39)
In-Reply-To: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
References: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

This reverts commit 16dd7267f460739b3e29d984e73f05c5ffe2b142.
---
 include/linux/nl80211.h       |    5 -----
 include/net/cfg80211.h        |    5 -----
 net/mac80211/cfg.c            |    4 ----
 net/mac80211/debugfs_netdev.c |    3 ---
 net/mac80211/mesh_hwmp.c      |    5 +----
 net/wireless/mesh.c           |    1 -
 net/wireless/nl80211.c        |    7 -------
 7 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3769303..20353bb 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1864,10 +1864,6 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_HWMP_RANN_INTERVAL:  The interval of time (in TUs) between
  * root announcements are transmitted.
  *
- * @NL80211_MESHCONF_GATE_ANNOUNCEMENTS: Advertise that this mesh station has
- * access to a broader network beyond the MBSS.  This is done via Root
- * Announcement frames.
- *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -1890,7 +1886,6 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_ROOTMODE,
 	NL80211_MESHCONF_ELEMENT_TTL,
 	NL80211_MESHCONF_HWMP_RANN_INTERVAL,
-	NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a37f264..2d88f06 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -756,11 +756,6 @@ struct mesh_config {
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
 	u8  dot11MeshHWMPRootMode;
 	u16 dot11MeshHWMPRannInterval;
-	/* This is missnamed in draft 12.0: dot11MeshGateAnnouncementProtocol
-	 * set to true only means that the station will announce others it's a
-	 * mesh gate, but not necessarily using the gate announcement protocol.
-	 * Still keeping the same nomenclature to be in sync with the spec. */
-	bool  dot11MeshGateAnnouncementProtocol;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7d17a91..9995c83 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1137,10 +1137,6 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		conf->dot11MeshHWMPRootMode = nconf->dot11MeshHWMPRootMode;
 		ieee80211_mesh_root_setup(ifmsh);
 	}
-	if (_chg_mesh_attr(NL80211_MESHCONF_GATE_ANNOUNCEMENTS, mask)) {
-		conf->dot11MeshGateAnnouncementProtocol =
-			nconf->dot11MeshGateAnnouncementProtocol;
-	}
 	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_RANN_INTERVAL, mask)) {
 		conf->dot11MeshHWMPRannInterval =
 			nconf->dot11MeshHWMPRannInterval;
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 6e8eab7..bac9443 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -372,8 +372,6 @@ IEEE80211_IF_FILE(min_discovery_timeout,
 		u.mesh.mshcfg.min_discovery_timeout, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPRootMode,
 		u.mesh.mshcfg.dot11MeshHWMPRootMode, DEC);
-IEEE80211_IF_FILE(dot11MeshGateAnnouncementProtocol,
-		u.mesh.mshcfg.dot11MeshGateAnnouncementProtocol, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPRannInterval,
 		u.mesh.mshcfg.dot11MeshHWMPRannInterval, DEC);
 #endif
@@ -491,7 +489,6 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(min_discovery_timeout);
 	MESHPARAMS_ADD(dot11MeshHWMPRootMode);
 	MESHPARAMS_ADD(dot11MeshHWMPRannInterval);
-	MESHPARAMS_ADD(dot11MeshGateAnnouncementProtocol);
 #undef MESHPARAMS_ADD
 }
 #endif
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fd4f76a..ae3de75 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1045,11 +1045,8 @@ mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u32 interval = ifmsh->mshcfg.dot11MeshHWMPRannInterval;
-	u8 flags;
 
-	flags = (ifmsh->mshcfg.dot11MeshGateAnnouncementProtocol)
-			? RANN_FLAG_IS_GATE : 0;
-	mesh_path_sel_frame_tx(MPATH_RANN, flags, sdata->vif.addr,
+	mesh_path_sel_frame_tx(MPATH_RANN, 0, sdata->vif.addr,
 			       cpu_to_le32(++ifmsh->sn),
 			       0, NULL, 0, broadcast_addr,
 			       0, sdata->u.mesh.mshcfg.element_ttl,
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 4423e64..b5a39d4 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -51,7 +51,6 @@ const struct mesh_config default_mesh_config = {
 	.path_refresh_time = MESH_PATH_REFRESH_TIME,
 	.min_discovery_timeout = MESH_MIN_DISCOVERY_TIMEOUT,
 	.dot11MeshHWMPRannInterval = MESH_RANN_INTERVAL,
-	.dot11MeshGateAnnouncementProtocol = false,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 57ecfa4..bbf3d73 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3037,8 +3037,6 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			cur_params.dot11MeshHWMPRootMode);
 	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 			cur_params.dot11MeshHWMPRannInterval);
-	NLA_PUT_U8(msg, NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
-			cur_params.dot11MeshGateAnnouncementProtocol);
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
@@ -3068,7 +3066,6 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_ROOTMODE] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_HWMP_RANN_INTERVAL] = { .type = NLA_U16 },
-	[NL80211_MESHCONF_GATE_ANNOUNCEMENTS] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -3151,10 +3148,6 @@ do {\
 			dot11MeshHWMPRannInterval, mask,
 			NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 			nla_get_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-			dot11MeshGateAnnouncementProtocol, mask,
-			NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
-			nla_get_u8);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.4.1

