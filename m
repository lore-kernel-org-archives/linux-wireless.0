Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57038 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FFKVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:21:03 -0400
Received: by pbbrp8 with SMTP id rp8so8745290pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 03:21:02 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH 1/4] {nl,cfg,mac}80211: implement dot11MeshHWMProotInterval and dot11MeshHWMPactivePathToRootTimeout
Date: Wed,  6 Jun 2012 18:20:36 +0800
Message-Id: <1338978039-4269-2-git-send-email-yeohchunyeow@gmail.com> (sfid-20120606_122107_188719_234EC193)
In-Reply-To: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
References: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the mesh configuration parameters dot11MeshHWMProotInterval and
dot11MeshHWMPactivePathToRootTimeout to be used by proactive PREQ mechanism.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 include/linux/nl80211.h       |    9 +++++++++
 include/net/cfg80211.h        |    2 ++
 net/mac80211/cfg.c            |    8 ++++++++
 net/mac80211/debugfs_netdev.c |    6 ++++++
 net/wireless/mesh.c           |    4 ++++
 net/wireless/nl80211.c        |   14 ++++++++++++++
 6 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 85e5037..1744a0a 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2123,6 +2123,10 @@ enum nl80211_mntr_flags {
  * points receiving a PREQ shall consider the forwarding information from the
  * root to be valid. (TU = time unit)
  *
+ * @NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT: The time (in TUs) for
+ * which mesh STAs receiving a proactive PREQ shall consider the forwarding
+ * information to the root mesh STA to be valid.
+ *
  * @NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL: The minimum interval of time (in
  * TUs) during which an MP can send only one action frame containing a PREQ
  * reference element
@@ -2138,6 +2142,9 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_HWMP_RANN_INTERVAL:  The interval of time (in TUs) between
  * root announcements are transmitted.
  *
+ * @NL80211_MESHCONF_HWMP_ROOT_INTERVAL: The interval of time (in TUs) between
+ * proactive PREQs are transmitted.
+ *
  * @NL80211_MESHCONF_GATE_ANNOUNCEMENTS: Advertise that this mesh station has
  * access to a broader network beyond the MBSS.  This is done via Root
  * Announcement frames.
@@ -2175,11 +2182,13 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_PATH_REFRESH_TIME,
 	NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
 	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
+	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT,
 	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 	NL80211_MESHCONF_HWMP_ROOTMODE,
 	NL80211_MESHCONF_ELEMENT_TTL,
 	NL80211_MESHCONF_HWMP_RANN_INTERVAL,
+	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 	NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 	NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
 	NL80211_MESHCONF_FORWARDING,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4c90c44..128cdeb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -814,11 +814,13 @@ struct mesh_config {
 	u32 path_refresh_time;
 	u16 min_discovery_timeout;
 	u32 dot11MeshHWMPactivePathTimeout;
+	u32 dot11MeshHWMPactivePathToRootTimeout;
 	u16 dot11MeshHWMPpreqMinInterval;
 	u16 dot11MeshHWMPperrMinInterval;
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
 	u8  dot11MeshHWMPRootMode;
 	u16 dot11MeshHWMPRannInterval;
+	u16 dot11MeshHWMProotInterval;
 	/* This is missnamed in draft 12.0: dot11MeshGateAnnouncementProtocol
 	 * set to true only means that the station will announce others it's a
 	 * mesh gate, but not necessarily using the gate announcement protocol.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 50aea1a..626baa2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1538,6 +1538,10 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT, mask))
 		conf->dot11MeshHWMPactivePathTimeout =
 			nconf->dot11MeshHWMPactivePathTimeout;
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT,
+			   mask))
+		conf->dot11MeshHWMPactivePathToRootTimeout =
+			nconf->dot11MeshHWMPactivePathToRootTimeout;
 	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL, mask))
 		conf->dot11MeshHWMPpreqMinInterval =
 			nconf->dot11MeshHWMPpreqMinInterval;
@@ -1568,6 +1572,10 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		conf->dot11MeshHWMPRannInterval =
 			nconf->dot11MeshHWMPRannInterval;
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ROOT_INTERVAL, mask)) {
+		conf->dot11MeshHWMProotInterval =
+			nconf->dot11MeshHWMProotInterval;
+	}
 	if (_chg_mesh_attr(NL80211_MESHCONF_FORWARDING, mask))
 		conf->dot11MeshForwarding = nconf->dot11MeshForwarding;
 	if (_chg_mesh_attr(NL80211_MESHCONF_RSSI_THRESHOLD, mask)) {
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 1a3b361..268ceb7 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -489,6 +489,8 @@ IEEE80211_IF_FILE(dot11MeshMaxPeerLinks,
 		u.mesh.mshcfg.dot11MeshMaxPeerLinks, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPactivePathTimeout,
 		u.mesh.mshcfg.dot11MeshHWMPactivePathTimeout, DEC);
+IEEE80211_IF_FILE(dot11MeshHWMPactivePathToRootTimeout,
+		u.mesh.mshcfg.dot11MeshHWMPactivePathToRootTimeout, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPpreqMinInterval,
 		u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPperrMinInterval,
@@ -507,6 +509,8 @@ IEEE80211_IF_FILE(dot11MeshGateAnnouncementProtocol,
 		u.mesh.mshcfg.dot11MeshGateAnnouncementProtocol, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPRannInterval,
 		u.mesh.mshcfg.dot11MeshHWMPRannInterval, DEC);
+IEEE80211_IF_FILE(dot11MeshHWMProotInterval,
+		u.mesh.mshcfg.dot11MeshHWMProotInterval, DEC);
 IEEE80211_IF_FILE(dot11MeshForwarding, u.mesh.mshcfg.dot11MeshForwarding, DEC);
 IEEE80211_IF_FILE(rssi_threshold, u.mesh.mshcfg.rssi_threshold, DEC);
 IEEE80211_IF_FILE(ht_opmode, u.mesh.mshcfg.ht_opmode, DEC);
@@ -599,6 +603,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(auto_open_plinks);
 	MESHPARAMS_ADD(dot11MeshMaxPeerLinks);
 	MESHPARAMS_ADD(dot11MeshHWMPactivePathTimeout);
+	MESHPARAMS_ADD(dot11MeshHWMPactivePathToRootTimeout);
 	MESHPARAMS_ADD(dot11MeshHWMPpreqMinInterval);
 	MESHPARAMS_ADD(dot11MeshHWMPperrMinInterval);
 	MESHPARAMS_ADD(dot11MeshHWMPnetDiameterTraversalTime);
@@ -607,6 +612,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(min_discovery_timeout);
 	MESHPARAMS_ADD(dot11MeshHWMPRootMode);
 	MESHPARAMS_ADD(dot11MeshHWMPRannInterval);
+	MESHPARAMS_ADD(dot11MeshHWMProotInterval);
 	MESHPARAMS_ADD(dot11MeshGateAnnouncementProtocol);
 	MESHPARAMS_ADD(rssi_threshold);
 	MESHPARAMS_ADD(ht_opmode);
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 2e3b700..ad44e32 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -13,7 +13,9 @@
 #define MESH_HOLD_T 		100
 
 #define MESH_PATH_TIMEOUT	5000
+#define MESH_PATH_TO_ROOT_TIMEOUT	6000
 #define MESH_RANN_INTERVAL      5000
+#define MESH_ROOT_INTERVAL	5000
 
 /*
  * Minimum interval between two consecutive PREQs originated by the same
@@ -51,6 +53,7 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshMaxPeerLinks = MESH_MAX_ESTAB_PLINKS,
 	.dot11MeshNbrOffsetMaxNeighbor = MESH_SYNC_NEIGHBOR_OFFSET_MAX,
 	.dot11MeshHWMPactivePathTimeout = MESH_PATH_TIMEOUT,
+	.dot11MeshHWMPactivePathToRootTimeout = MESH_PATH_TO_ROOT_TIMEOUT,
 	.dot11MeshHWMPpreqMinInterval = MESH_PREQ_MIN_INT,
 	.dot11MeshHWMPperrMinInterval = MESH_PERR_MIN_INT,
 	.dot11MeshHWMPnetDiameterTraversalTime = MESH_DIAM_TRAVERSAL_TIME,
@@ -58,6 +61,7 @@ const struct mesh_config default_mesh_config = {
 	.path_refresh_time = MESH_PATH_REFRESH_TIME,
 	.min_discovery_timeout = MESH_MIN_DISCOVERY_TIMEOUT,
 	.dot11MeshHWMPRannInterval = MESH_RANN_INTERVAL,
+	.dot11MeshHWMProotInterval = MESH_ROOT_INTERVAL,
 	.dot11MeshGateAnnouncementProtocol = false,
 	.dot11MeshForwarding = true,
 	.rssi_threshold = MESH_RSSI_THRESHOLD,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b22f1f8..8af4561 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3449,6 +3449,8 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			cur_params.min_discovery_timeout) ||
 	    nla_put_u32(msg, NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
 			cur_params.dot11MeshHWMPactivePathTimeout) ||
+	    nla_put_u32(msg, NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT,
+			cur_params.dot11MeshHWMPactivePathToRootTimeout) ||
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 			cur_params.dot11MeshHWMPpreqMinInterval) ||
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
@@ -3459,6 +3461,8 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 		       cur_params.dot11MeshHWMPRootMode) ||
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 			cur_params.dot11MeshHWMPRannInterval) ||
+	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
+			cur_params.dot11MeshHWMProotInterval) ||
 	    nla_put_u8(msg, NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 		       cur_params.dot11MeshGateAnnouncementProtocol) ||
 	    nla_put_u8(msg, NL80211_MESHCONF_FORWARDING,
@@ -3494,11 +3498,14 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_PATH_REFRESH_TIME] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT]
+						= { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_ROOTMODE] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_HWMP_RANN_INTERVAL] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_HWMP_ROOT_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_GATE_ANNOUNCEMENTS] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_FORWARDING] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_RSSI_THRESHOLD] = { .type = NLA_U32},
@@ -3574,6 +3581,9 @@ do {\
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathTimeout,
 			mask, NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
 			nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathToRootTimeout,
+			mask, NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT,
+			nla_get_u32);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPpreqMinInterval,
 			mask, NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 			nla_get_u16);
@@ -3593,6 +3603,10 @@ do {\
 			NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 			nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
+			dot11MeshHWMProotInterval, mask,
+			NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
+			nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
 			dot11MeshGateAnnouncementProtocol, mask,
 			NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 			nla_get_u8);
-- 
1.7.0.4

