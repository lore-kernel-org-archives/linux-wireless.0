Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41229 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757661Ab2EaCKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 22:10:22 -0400
Received: by dady13 with SMTP id y13so596246dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 19:10:21 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] {nl,cfg,mac}80211: implement dot11MeshHWMPconfirmationInterval
Date: Thu, 31 May 2012 10:09:41 +0800
Message-Id: <1338430181-12490-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120531_041026_851377_E5ACE6CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As defined in section 13.10.9.3 Case D (802.11-2012), this control variable is used to limit the
mesh STA to send only one PREQ to a root mesh STA within this interval of time (in TUs). The
default value for this variable is set to 2000 TUs. However, for current implementation, the maximum
configurable of dot11MeshHWMPconfirmationInterval is restricted by dot11MeshHWMPactivePathTimeout.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 include/linux/nl80211.h       |    5 +++++
 include/net/cfg80211.h        |    1 +
 net/mac80211/cfg.c            |    4 ++++
 net/mac80211/debugfs_netdev.c |    3 +++
 net/mac80211/mesh.h           |    2 ++
 net/mac80211/mesh_hwmp.c      |    7 ++++++-
 net/wireless/mesh.c           |    2 ++
 net/wireless/nl80211.c        |    7 +++++++
 8 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a6959f7..14bbf47 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2136,6 +2136,10 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_HWMP_RANN_INTERVAL:  The interval of time (in TUs) between
  * root announcements are transmitted.
  *
+ * @NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL: The minimum interval of time
+ * (in TUs) during which a mesh STA can send only one Action frame containing
+ * a PREQ element for root path confirmation.
+ *
  * @NL80211_MESHCONF_GATE_ANNOUNCEMENTS: Advertise that this mesh station has
  * access to a broader network beyond the MBSS.  This is done via Root
  * Announcement frames.
@@ -2178,6 +2182,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_ROOTMODE,
 	NL80211_MESHCONF_ELEMENT_TTL,
 	NL80211_MESHCONF_HWMP_RANN_INTERVAL,
+	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 	NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 	NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
 	NL80211_MESHCONF_FORWARDING,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0289d4c..95a19cd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -814,6 +814,7 @@ struct mesh_config {
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
 	u8  dot11MeshHWMPRootMode;
 	u16 dot11MeshHWMPRannInterval;
+	u16 dot11MeshHWMPconfirmationInterval;
 	/* This is missnamed in draft 12.0: dot11MeshGateAnnouncementProtocol
 	 * set to true only means that the station will announce others it's a
 	 * mesh gate, but not necessarily using the gate announcement protocol.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0221270..26f3610 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1528,6 +1528,10 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		conf->dot11MeshHWMPRannInterval =
 			nconf->dot11MeshHWMPRannInterval;
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL, mask)) {
+		conf->dot11MeshHWMPconfirmationInterval =
+			nconf->dot11MeshHWMPconfirmationInterval;
+	}
 	if (_chg_mesh_attr(NL80211_MESHCONF_FORWARDING, mask))
 		conf->dot11MeshForwarding = nconf->dot11MeshForwarding;
 	if (_chg_mesh_attr(NL80211_MESHCONF_RSSI_THRESHOLD, mask)) {
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 7ed433c..fa62a5e 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -507,6 +507,8 @@ IEEE80211_IF_FILE(dot11MeshGateAnnouncementProtocol,
 		u.mesh.mshcfg.dot11MeshGateAnnouncementProtocol, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPRannInterval,
 		u.mesh.mshcfg.dot11MeshHWMPRannInterval, DEC);
+IEEE80211_IF_FILE(dot11MeshHWMPconfirmationInterval,
+		u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval, DEC);
 IEEE80211_IF_FILE(dot11MeshForwarding, u.mesh.mshcfg.dot11MeshForwarding, DEC);
 IEEE80211_IF_FILE(rssi_threshold, u.mesh.mshcfg.rssi_threshold, DEC);
 IEEE80211_IF_FILE(ht_opmode, u.mesh.mshcfg.ht_opmode, DEC);
@@ -607,6 +609,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(min_discovery_timeout);
 	MESHPARAMS_ADD(dot11MeshHWMPRootMode);
 	MESHPARAMS_ADD(dot11MeshHWMPRannInterval);
+	MESHPARAMS_ADD(dot11MeshHWMPconfirmationInterval);
 	MESHPARAMS_ADD(dot11MeshGateAnnouncementProtocol);
 	MESHPARAMS_ADD(rssi_threshold);
 	MESHPARAMS_ADD(ht_opmode);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index e364275..243d4ef 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -104,6 +104,7 @@ enum mesh_deferred_task_flags {
  * an mpath to a hash bucket on a path table.
  * @rann_snd_addr: the RANN sender address
  * @rann_metric: the aggregated path metric towards the root node
+ * @last_preq_to_root: Timestamp of last PREQ sent to root
  * @is_root: the destination station of this path is a root node
  * @is_gate: the destination station of this path is a mesh gate
  *
@@ -131,6 +132,7 @@ struct mesh_path {
 	spinlock_t state_lock;
 	u8 rann_snd_addr[ETH_ALEN];
 	u32 rann_metric;
+	unsigned long last_preq_to_root;
 	bool is_root;
 	bool is_gate;
 };
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 70ac7d1..db0ad5f 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -98,6 +98,8 @@ static inline u32 u16_field_get(u8 *preq_elem, int offset, bool ae)
 #define max_preq_retries(s) (s->u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries)
 #define disc_timeout_jiff(s) \
 	msecs_to_jiffies(sdata->u.mesh.mshcfg.min_discovery_timeout)
+#define root_path_confirmation_jiffies(s) \
+	msecs_to_jiffies(sdata->u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval)
 
 enum mpath_frame_type {
 	MPATH_PREQ = 0,
@@ -786,11 +788,14 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if ((!(mpath->flags & (MESH_PATH_ACTIVE | MESH_PATH_RESOLVING)) ||
-	     time_after(jiffies, mpath->exp_time - 1*HZ)) &&
+	     (time_after(jiffies, mpath->last_preq_to_root +
+	     root_path_confirmation_jiffies(sdata)) ||
+	     time_before(jiffies, mpath->last_preq_to_root))) &&
 	     !(mpath->flags & MESH_PATH_FIXED)) {
 		mhwmp_dbg("%s time to refresh root mpath %pM", sdata->name,
 							       orig_addr);
 		mesh_queue_preq(mpath, PREQ_Q_F_START | PREQ_Q_F_REFRESH);
+		mpath->last_preq_to_root = jiffies;
 	}
 
 	if ((SN_LT(mpath->sn, orig_sn) || (mpath->sn == orig_sn &&
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 2749cb8..2701d7c 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -14,6 +14,7 @@
 
 #define MESH_PATH_TIMEOUT	5000
 #define MESH_RANN_INTERVAL      5000
+#define MESH_ROOT_CONFIRMATION_INTERVAL 2000
 
 /*
  * Minimum interval between two consecutive PREQs originated by the same
@@ -58,6 +59,7 @@ const struct mesh_config default_mesh_config = {
 	.path_refresh_time = MESH_PATH_REFRESH_TIME,
 	.min_discovery_timeout = MESH_MIN_DISCOVERY_TIMEOUT,
 	.dot11MeshHWMPRannInterval = MESH_RANN_INTERVAL,
+	.dot11MeshHWMPconfirmationInterval = MESH_ROOT_CONFIRMATION_INTERVAL,
 	.dot11MeshGateAnnouncementProtocol = false,
 	.dot11MeshForwarding = true,
 	.rssi_threshold = MESH_RSSI_THRESHOLD,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 206465d..a51ee15 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3406,6 +3406,8 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 		       cur_params.dot11MeshHWMPRootMode) ||
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 			cur_params.dot11MeshHWMPRannInterval) ||
+	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
+			cur_params.dot11MeshHWMPconfirmationInterval) ||
 	    nla_put_u8(msg, NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 		       cur_params.dot11MeshGateAnnouncementProtocol) ||
 	    nla_put_u8(msg, NL80211_MESHCONF_FORWARDING,
@@ -3446,6 +3448,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_ROOTMODE] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_HWMP_RANN_INTERVAL] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_GATE_ANNOUNCEMENTS] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_FORWARDING] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_RSSI_THRESHOLD] = { .type = NLA_U32},
@@ -3540,6 +3543,10 @@ do {\
 			NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 			nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
+			dot11MeshHWMPconfirmationInterval, mask,
+			NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
+			nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
 			dot11MeshGateAnnouncementProtocol, mask,
 			NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 			nla_get_u8);
-- 
1.7.0.4

