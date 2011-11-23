Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54099 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab1KWUct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 15:32:49 -0500
Received: by yenq3 with SMTP id q3so1826068yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 12:32:49 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 5/7] {nl,cfg,mac}80211: implement dot11MeshHWMPperrMinInterval
Date: Wed, 23 Nov 2011 12:32:24 -0800
Message-Id: <1322080347-7644-6-git-send-email-thomas@cozybit.com> (sfid-20111123_213253_766057_4B33AB30)
In-Reply-To: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
References: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As per 802.11mb 13.9.11.3

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h       |    5 +++++
 include/net/cfg80211.h        |    1 +
 net/mac80211/cfg.c            |    3 +++
 net/mac80211/debugfs_netdev.c |    3 +++
 net/mac80211/ieee80211_i.h    |    4 +++-
 net/mac80211/mesh.c           |    1 +
 net/mac80211/mesh_hwmp.c      |    6 ++++++
 net/wireless/mesh.c           |    2 ++
 net/wireless/nl80211.c        |    6 ++++++
 9 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 97bfebf..efbdfaf 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2084,6 +2084,10 @@ enum nl80211_mntr_flags {
  * access to a broader network beyond the MBSS.  This is done via Root
  * Announcement frames.
  *
+ * @NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL: The minimum interval of time (in
+ * TUs) during which a mesh STA can send only one Action frame containing a
+ * PERR element.
+ *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -2107,6 +2111,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_ELEMENT_TTL,
 	NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 	NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
+	NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index edf1a4b..8fb7d12 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -782,6 +782,7 @@ struct mesh_config {
 	u16 min_discovery_timeout;
 	u32 dot11MeshHWMPactivePathTimeout;
 	u16 dot11MeshHWMPpreqMinInterval;
+	u16 dot11MeshHWMPperrMinInterval;
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
 	u8  dot11MeshHWMPRootMode;
 	u16 dot11MeshHWMPRannInterval;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8fa85db..0eba909 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1262,6 +1262,9 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL, mask))
 		conf->dot11MeshHWMPpreqMinInterval =
 			nconf->dot11MeshHWMPpreqMinInterval;
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL, mask))
+		conf->dot11MeshHWMPperrMinInterval =
+			nconf->dot11MeshHWMPperrMinInterval;
 	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 			   mask))
 		conf->dot11MeshHWMPnetDiameterTraversalTime =
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 9352819..8df2891 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -405,6 +405,8 @@ IEEE80211_IF_FILE(dot11MeshHWMPactivePathTimeout,
 		u.mesh.mshcfg.dot11MeshHWMPactivePathTimeout, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPpreqMinInterval,
 		u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval, DEC);
+IEEE80211_IF_FILE(dot11MeshHWMPperrMinInterval,
+		u.mesh.mshcfg.dot11MeshHWMPperrMinInterval, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPnetDiameterTraversalTime,
 		u.mesh.mshcfg.dot11MeshHWMPnetDiameterTraversalTime, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPmaxPREQretries,
@@ -534,6 +536,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshMaxPeerLinks);
 	MESHPARAMS_ADD(dot11MeshHWMPactivePathTimeout);
 	MESHPARAMS_ADD(dot11MeshHWMPpreqMinInterval);
+	MESHPARAMS_ADD(dot11MeshHWMPperrMinInterval);
 	MESHPARAMS_ADD(dot11MeshHWMPnetDiameterTraversalTime);
 	MESHPARAMS_ADD(dot11MeshHWMPmaxPREQretries);
 	MESHPARAMS_ADD(path_refresh_time);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 762243e..0c872b8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -514,7 +514,9 @@ struct ieee80211_if_mesh {
 	atomic_t mpaths;
 	/* Timestamp of last SN update */
 	unsigned long last_sn_update;
-	/* Timestamp of last SN sent */
+	/* Time when it's ok to send next PERR */
+	unsigned long next_perr;
+	/* Timestamp of last PREQ sent */
 	unsigned long last_preq;
 	struct mesh_rmc *rmc;
 	spinlock_t mesh_preq_queue_lock;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ee82d2f..c707c8b 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -749,6 +749,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	atomic_set(&ifmsh->mpaths, 0);
 	mesh_rmc_init(sdata);
 	ifmsh->last_preq = jiffies;
+	ifmsh->next_perr = jiffies;
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 208ba35..fe93386 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -241,11 +241,15 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, ie_len;
 	int hdr_len = offsetof(struct ieee80211_mgmt, u.action.u.mesh_action) +
 		      sizeof(mgmt->u.action.u.mesh_action);
 
+	if (time_before(jiffies, ifmsh->next_perr))
+		return -EAGAIN;
+
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
 			    hdr_len +
 			    2 + 15 /* PERR IE */);
@@ -290,6 +294,8 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 
 	/* see note in function header */
 	prepare_frame_for_deferred_tx(sdata, skb);
+	ifmsh->next_perr = TU_TO_EXP_TIME(
+				   ifmsh->mshcfg.dot11MeshHWMPperrMinInterval);
 	ieee80211_add_pending_skb(local, skb);
 	return 0;
 }
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index b7b7868..8c550df 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -20,6 +20,7 @@
  * interface
  */
 #define MESH_PREQ_MIN_INT	10
+#define MESH_PERR_MIN_INT	100
 #define MESH_DIAM_TRAVERSAL_TIME 50
 
 /*
@@ -47,6 +48,7 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshMaxPeerLinks = MESH_MAX_ESTAB_PLINKS,
 	.dot11MeshHWMPactivePathTimeout = MESH_PATH_TIMEOUT,
 	.dot11MeshHWMPpreqMinInterval = MESH_PREQ_MIN_INT,
+	.dot11MeshHWMPperrMinInterval = MESH_PERR_MIN_INT,
 	.dot11MeshHWMPnetDiameterTraversalTime = MESH_DIAM_TRAVERSAL_TIME,
 	.dot11MeshHWMPmaxPREQretries = MESH_MAX_PREQ_RETRIES,
 	.path_refresh_time = MESH_PATH_REFRESH_TIME,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9b8f9d9..52cc311 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3176,6 +3176,8 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			cur_params.dot11MeshHWMPactivePathTimeout);
 	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 			cur_params.dot11MeshHWMPpreqMinInterval);
+	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
+			cur_params.dot11MeshHWMPperrMinInterval);
 	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 			cur_params.dot11MeshHWMPnetDiameterTraversalTime);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_HWMP_ROOTMODE,
@@ -3210,6 +3212,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_ROOTMODE] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_HWMP_RANN_INTERVAL] = { .type = NLA_U16 },
@@ -3284,6 +3287,9 @@ do {\
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPpreqMinInterval,
 			mask, NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 			nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPperrMinInterval,
+			mask, NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
+			nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
 			dot11MeshHWMPnetDiameterTraversalTime,
 			mask, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
-- 
1.7.5.4

