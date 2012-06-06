Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36023 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2FFLqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 07:46:22 -0400
Received: by dady13 with SMTP id y13so8682073dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 04:46:21 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] {nl,cfg,mac}80211: implement dot11MeshHWMPconfirmationInterval
Date: Wed,  6 Jun 2012 19:46:04 +0800
Message-Id: <1338983164-16060-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120606_134626_215284_F09868B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As defined in section 13.10.9.3 Case D (802.11-2012), this control variable is used to limit the
mesh STA to send only one PREQ to a root mesh STA within this interval of time (in TUs). The
default value for this variable is set to 2000 TUs. However, for current implementation, the maximum
configurable of dot11MeshHWMPconfirmationInterval is restricted by dot11MeshHWMPactivePathTimeout.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2: avoid renumbering the old command ids (Johannes)

 include/linux/nl80211.h       |    5 +++++
 include/net/cfg80211.h        |    1 +
 net/mac80211/cfg.c            |    4 ++++
 net/mac80211/debugfs_netdev.c |    3 +++
 net/mac80211/mesh.h           |    2 ++
 net/mac80211/mesh_hwmp.c      |    7 ++++++-
 net/wireless/mesh.c           |    2 ++
 net/wireless/nl80211.c        |    9 ++++++++-
 8 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 85e5037..46bf24f 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2160,6 +2160,10 @@ enum nl80211_mntr_flags {
  *
  * @NL80211_MESHCONF_HT_OPMODE: set mesh HT protection mode.
  *
+ * @NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL: The minimum interval of time
+ * (in TUs) during which a mesh STA can send only one Action frame containing
+ * a PREQ element for root path confirmation.
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2186,6 +2190,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_RSSI_THRESHOLD,
 	NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
 	NL80211_MESHCONF_HT_OPMODE,
+	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4c90c44..796013e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -827,6 +827,7 @@ struct mesh_config {
 	bool dot11MeshForwarding;
 	s32 rssi_threshold;
 	u16 ht_opmode;
+	u16 dot11MeshHWMPconfirmationInterval;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 50aea1a..d861dd3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1583,6 +1583,10 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		sdata->vif.bss_conf.ht_operation_mode = nconf->ht_opmode;
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL, mask)) {
+		conf->dot11MeshHWMPconfirmationInterval =
+			nconf->dot11MeshHWMPconfirmationInterval;
+	}
 	return 0;
 }
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 1a3b361..49a6e4c 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -510,6 +510,8 @@ IEEE80211_IF_FILE(dot11MeshHWMPRannInterval,
 IEEE80211_IF_FILE(dot11MeshForwarding, u.mesh.mshcfg.dot11MeshForwarding, DEC);
 IEEE80211_IF_FILE(rssi_threshold, u.mesh.mshcfg.rssi_threshold, DEC);
 IEEE80211_IF_FILE(ht_opmode, u.mesh.mshcfg.ht_opmode, DEC);
+IEEE80211_IF_FILE(dot11MeshHWMPconfirmationInterval,
+		u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval, DEC);
 #endif
 
 #define DEBUGFS_ADD_MODE(name, mode) \
@@ -610,6 +612,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshGateAnnouncementProtocol);
 	MESHPARAMS_ADD(rssi_threshold);
 	MESHPARAMS_ADD(ht_opmode);
+	MESHPARAMS_ADD(dot11MeshHWMPconfirmationInterval);
 #undef MESHPARAMS_ADD
 }
 #endif
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
index fa7c580..38b60d1 100644
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
index 2e3b700..5b11ca4 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -14,6 +14,7 @@
 
 #define MESH_PATH_TIMEOUT	5000
 #define MESH_RANN_INTERVAL      5000
+#define MESH_ROOT_CONFIRMATION_INTERVAL 2000
 
 /*
  * Minimum interval between two consecutive PREQs originated by the same
@@ -62,6 +63,7 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshForwarding = true,
 	.rssi_threshold = MESH_RSSI_THRESHOLD,
 	.ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED,
+	.dot11MeshHWMPconfirmationInterval = MESH_ROOT_CONFIRMATION_INTERVAL,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b22f1f8..12cd1ca 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3466,7 +3466,9 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u32(msg, NL80211_MESHCONF_RSSI_THRESHOLD,
 			cur_params.rssi_threshold) ||
 	    nla_put_u32(msg, NL80211_MESHCONF_HT_OPMODE,
-			cur_params.ht_opmode))
+			cur_params.ht_opmode) ||
+	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
+			cur_params.dot11MeshHWMPconfirmationInterval))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -3503,6 +3505,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_FORWARDING] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_RSSI_THRESHOLD] = { .type = NLA_U32},
 	[NL80211_MESHCONF_HT_OPMODE] = { .type = NLA_U16},
+	[NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL] = { .type = NLA_U16 },
 };
 
 static const struct nla_policy
@@ -3602,6 +3605,10 @@ do {\
 			mask, NL80211_MESHCONF_RSSI_THRESHOLD, nla_get_u32);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode,
 			mask, NL80211_MESHCONF_HT_OPMODE, nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
+			dot11MeshHWMPconfirmationInterval, mask,
+			NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
+			nla_get_u16);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.0.4

