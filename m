Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33892 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751860AbdB1X6z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 18:58:55 -0500
Received: by mail-pg0-f53.google.com with SMTP id p5so12393336pga.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 15:57:24 -0800 (PST)
Received: from [10.4.0.31] ([67.137.71.162])
        by smtp.gmail.com with ESMTPSA id h3sm6238531pfc.82.2017.02.28.15.50.47
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Feb 2017 15:50:47 -0800 (PST)
From: Alexis Green <agreen@uniumwifi.com>
Reply-To: agreen@cococorp.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211: mesh - always do every discovery retry
Message-ID: <58B60CD3.700@cococorp.com> (sfid-20170301_010410_289671_218BA7D8)
Date: Tue, 28 Feb 2017 15:50:43 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes since v1: Make this behavior optional and configurable via
  netlink.

Instead of stopping path discovery when a path is found continue
attempting to find paths until we hit the dot11MeshHWMPmaxPREQretries
limit.

This is important because path messages are not reliable and it is
relatively common to have a short bad path to the destination along with a
longer but better path. With the original code rather often a path message
along the long path would be lost so we would stick with the bad path.
With this change we have a greater chance to get messages over the longer
path allowing us to select the long path if it's better.

The standard doesn't seem to address this issue. All it says (13.10.8.5)
is that discovery should be limited to dot11MeshHWMPmaxPREQretries.

Signed-off-by: Alexis Green <agreen@uniumwifi.com>
---
 include/net/cfg80211.h        |  3 ++
 include/uapi/linux/nl80211.h  |  3 ++
 net/mac80211/cfg.c            |  2 ++
 net/mac80211/debugfs_netdev.c |  3 ++
 net/mac80211/mesh_hwmp.c      | 65 +++++++++++++++++++++++++++++--------------
 net/wireless/mesh.c           |  1 +
 net/wireless/nl80211.c        |  8 +++++-
 net/wireless/trace.h          |  5 +++-
 8 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 86c12f8..fb32abf 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1382,6 +1382,8 @@ struct bss_parameters {
  * @plink_timeout: If no tx activity is seen from a STA we've established
  *	peering with for longer than this time (in seconds), then remove it
  *	from the STA's list of peers.  Default is 30 minutes.
+ * @always_max_discoveries: whether to always perform number of discovery
+ *	attemts equal to dot11MeshHWMPmaxPREQretries
  */
 struct mesh_config {
 	u16 dot11MeshRetryTimeout;
@@ -1412,6 +1414,7 @@ struct mesh_config {
 	enum nl80211_mesh_power_mode power_mode;
 	u16 dot11MeshAwakeWindowDuration;
 	u32 plink_timeout;
+	bool always_max_discoveries;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9a499b1..58f8f0c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3449,6 +3449,8 @@ enum nl80211_mesh_power_mode {
  *	established peering with for longer than this time (in seconds), then
  *	remove it from the STA's list of peers. You may set this to 0 to disable
  *	the removal of the STA. Default is 30 minutes.
+ * @NL80211_MESHCONF_HWMP_ALWAYS_MAX_DISCOVERIES: whether to always perform
+ *	number of discovery attempts equal to MaxPREQretries (default is FALSE)
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
@@ -3482,6 +3484,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_POWER_MODE,
 	NL80211_MESHCONF_AWAKE_WINDOW,
 	NL80211_MESHCONF_PLINK_TIMEOUT,
+	NL80211_MESHCONF_HWMP_ALWAYS_MAX_DISCOVERIES,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9c7490c..9581873 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1956,6 +1956,8 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 			nconf->dot11MeshAwakeWindowDuration;
 	if (_chg_mesh_attr(NL80211_MESHCONF_PLINK_TIMEOUT, mask))
 		conf->plink_timeout = nconf->plink_timeout;
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ALWAYS_MAX_DISCOVERIES, mask))
+		conf->always_max_discoveries = nconf->always_max_discoveries;
 	ieee80211_mbss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 	return 0;
 }
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 8f5fff8..ceec6e8 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -642,6 +642,8 @@ IEEE80211_IF_FILE(dot11MeshHWMPconfirmationInterval,
 IEEE80211_IF_FILE(power_mode, u.mesh.mshcfg.power_mode, DEC);
 IEEE80211_IF_FILE(dot11MeshAwakeWindowDuration,
 		  u.mesh.mshcfg.dot11MeshAwakeWindowDuration, DEC);
+IEEE80211_IF_FILE(always_max_discoveries,
+		  u.mesh.mshcfg.always_max_discoveries, DEC);
 #endif
 
 #define DEBUGFS_ADD_MODE(name, mode) \
@@ -763,6 +765,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshHWMPconfirmationInterval);
 	MESHPARAMS_ADD(power_mode);
 	MESHPARAMS_ADD(dot11MeshAwakeWindowDuration);
+	MESHPARAMS_ADD(always_max_discoveries);
 #undef MESHPARAMS_ADD
 }
 #endif
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index d07ee3c..7c019f9 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1198,34 +1198,57 @@ void mesh_path_timer(unsigned long data)
 {
 	struct mesh_path *mpath = (void *) data;
 	struct ieee80211_sub_if_data *sdata = mpath->sdata;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	bool multiple_discoveries = ifmsh->mshcfg.always_max_discoveries;
 	int ret;
 
 	if (sdata->local->quiescing)
 		return;
 
 	spin_lock_bh(&mpath->state_lock);
-	if (mpath->flags & MESH_PATH_RESOLVED ||
-			(!(mpath->flags & MESH_PATH_RESOLVING))) {
-		mpath->flags &= ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);
-		spin_unlock_bh(&mpath->state_lock);
-	} else if (mpath->discovery_retries < max_preq_retries(sdata)) {
-		++mpath->discovery_retries;
-		mpath->discovery_timeout *= 2;
-		mpath->flags &= ~MESH_PATH_REQ_QUEUED;
-		spin_unlock_bh(&mpath->state_lock);
-		mesh_queue_preq(mpath, 0);
+	if (!multiple_discoveries) {
+		if (mpath->flags & MESH_PATH_RESOLVED ||
+		    (!(mpath->flags & MESH_PATH_RESOLVING))) {
+			mpath->flags &= ~(MESH_PATH_RESOLVING |
+					  MESH_PATH_RESOLVED);
+			spin_unlock_bh(&mpath->state_lock);
+			return;
+		} else if (mpath->discovery_retries < max_preq_retries(sdata)) {
+			++mpath->discovery_retries;
+			mpath->discovery_timeout *= 2;
+			mpath->flags &= ~MESH_PATH_REQ_QUEUED;
+			spin_unlock_bh(&mpath->state_lock);
+			mesh_queue_preq(mpath, 0);
+			return;
+		}
 	} else {
-		mpath->flags &= ~(MESH_PATH_RESOLVING |
-				  MESH_PATH_RESOLVED |
-				  MESH_PATH_REQ_QUEUED);
-		mpath->exp_time = jiffies;
-		spin_unlock_bh(&mpath->state_lock);
-		if (!mpath->is_gate && mesh_gate_num(sdata) > 0) {
-			ret = mesh_path_send_to_gates(mpath);
-			if (ret)
-				mhwmp_dbg(sdata, "no gate was reachable\n");
-		} else
-			mesh_path_flush_pending(mpath);
+		if (mpath->discovery_retries < max_preq_retries(sdata)) {
+			++mpath->discovery_retries;
+			mpath->discovery_timeout *= 2;
+			mpath->flags &= ~MESH_PATH_REQ_QUEUED;
+			spin_unlock_bh(&mpath->state_lock);
+			mesh_queue_preq(mpath, 0);
+			return;
+		} else if (mpath->flags & MESH_PATH_RESOLVED ||
+			   (!(mpath->flags & MESH_PATH_RESOLVING))) {
+			mpath->flags &= ~(MESH_PATH_RESOLVING |
+					  MESH_PATH_RESOLVED);
+			spin_unlock_bh(&mpath->state_lock);
+			return;
+		}
+	}
+
+	mpath->flags &= ~(MESH_PATH_RESOLVING |
+			  MESH_PATH_RESOLVED |
+			  MESH_PATH_REQ_QUEUED);
+	mpath->exp_time = jiffies;
+	spin_unlock_bh(&mpath->state_lock);
+	if (!mpath->is_gate && mesh_gate_num(sdata) > 0) {
+		ret = mesh_path_send_to_gates(mpath);
+		if (ret)
+			mhwmp_dbg(sdata, "no gate was reachable\n");
+	} else {
+		mesh_path_flush_pending(mpath);
 	}
 }
 
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 2d8518a..f82fcd3 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -77,6 +77,7 @@ const struct mesh_config default_mesh_config = {
 	.power_mode = NL80211_MESH_POWER_ACTIVE,
 	.dot11MeshAwakeWindowDuration = MESH_DEFAULT_AWAKE_WINDOW,
 	.plink_timeout = MESH_DEFAULT_PLINK_TIMEOUT,
+	.always_max_discoveries = false,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d516527..6e1181d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5729,7 +5729,9 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u16(msg, NL80211_MESHCONF_AWAKE_WINDOW,
 			cur_params.dot11MeshAwakeWindowDuration) ||
 	    nla_put_u32(msg, NL80211_MESHCONF_PLINK_TIMEOUT,
-			cur_params.plink_timeout))
+			cur_params.plink_timeout) ||
+	    nla_put_u8(msg, NL80211_MESHCONF_HWMP_ALWAYS_MAX_DISCOVERIES,
+		       cur_params.always_max_discoveries))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -5771,6 +5773,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_POWER_MODE] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_AWAKE_WINDOW] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_PLINK_TIMEOUT] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_HWMP_ALWAYS_MAX_DISCOVERIES] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -5995,6 +5998,9 @@ do {									    \
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, plink_timeout, 0, 0xffffffff,
 				  mask, NL80211_MESHCONF_PLINK_TIMEOUT,
 				  nl80211_check_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, always_max_discoveries, 0, 1, mask,
+				  NL80211_MESHCONF_HWMP_ALWAYS_MAX_DISCOVERIES,
+				  nl80211_check_bool);
 	if (mask_out)
 		*mask_out = mask;
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index fd55786..cc4a966 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -67,7 +67,8 @@
 		       __field(u16, ht_opmode)				   \
 		       __field(u32, dot11MeshHWMPactivePathToRootTimeout)  \
 		       __field(u16, dot11MeshHWMProotInterval)		   \
-		       __field(u16, dot11MeshHWMPconfirmationInterval)
+		       __field(u16, dot11MeshHWMPconfirmationInterval)	   \
+		       __field(bool, always_max_discoveries)
 #define MESH_CFG_ASSIGN							      \
 	do {								      \
 		__entry->dot11MeshRetryTimeout = conf->dot11MeshRetryTimeout; \
@@ -108,6 +109,8 @@
 				conf->dot11MeshHWMProotInterval;	      \
 		__entry->dot11MeshHWMPconfirmationInterval =		      \
 				conf->dot11MeshHWMPconfirmationInterval;      \
+		__entry->always_max_discoveries =			      \
+				conf->always_max_discoveries;		      \
 	} while (0)
 
 #define CHAN_ENTRY __field(enum nl80211_band, band) \
