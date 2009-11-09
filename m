Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:55771 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbZKIMmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:42:31 -0500
Received: by fxm21 with SMTP id 21so158625fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:42:36 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 20/21] mac80211: add nl80211/cfg80211 handling of the new mesh root mode option.
Date: Mon,  9 Nov 2009 12:39:40 +0000
Message-Id: <1257770381-7680-21-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 include/linux/nl80211.h       |    3 +++
 include/net/cfg80211.h        |    1 +
 net/mac80211/cfg.c            |    7 +++++++
 net/mac80211/debugfs_netdev.c |    2 ++
 net/mac80211/mesh.c           |   13 +++++++++++++
 net/mac80211/mesh.h           |    1 +
 net/wireless/nl80211.c        |    6 ++++++
 7 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index f682911..4d4a9db 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1196,6 +1196,8 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in TUs)
  * that it takes for an HWMP information element to propagate across the mesh
  *
+ * @NL80211_MESHCONF_ROOTMODE: whether root mode is enabled or not
+ *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -1215,6 +1217,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
 	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+	NL80211_MESHCONF_HWMP_ROOTMODE,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b3031bd..b30d023 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -506,6 +506,7 @@ struct mesh_config {
 	u32 dot11MeshHWMPactivePathTimeout;
 	u16 dot11MeshHWMPpreqMinInterval;
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
+	u8  dot11MeshHWMPRootMode;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 340678e..25e9c56 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1001,7 +1001,10 @@ static int ieee80211_set_mesh_params(struct wiphy *wiphy,
 {
 	struct mesh_config *conf;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_mesh *ifmsh;
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	ifmsh = &sdata->u.mesh;
 
 	/* Set the config options which we are interested in setting */
 	conf = &(sdata->u.mesh.mshcfg);
@@ -1036,6 +1039,10 @@ static int ieee80211_set_mesh_params(struct wiphy *wiphy,
 			   mask))
 		conf->dot11MeshHWMPnetDiameterTraversalTime =
 			nconf->dot11MeshHWMPnetDiameterTraversalTime;
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ROOTMODE, mask)) {
+		conf->dot11MeshHWMPRootMode = nconf->dot11MeshHWMPRootMode;
+		ieee80211_mesh_root_setup(ifmsh);
+	}
 	return 0;
 }
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 8782264..472b203 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -149,6 +149,8 @@ IEEE80211_IF_FILE(path_refresh_time,
 		u.mesh.mshcfg.path_refresh_time, DEC);
 IEEE80211_IF_FILE(min_discovery_timeout,
 		u.mesh.mshcfg.min_discovery_timeout, DEC);
+IEEE80211_IF_FILE(dot11MeshHWMPRootMode,
+		u.mesh.mshcfg.dot11MeshHWMPRootMode, DEC);
 #endif
 
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 88dcfe3..05955dc 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -373,6 +373,17 @@ static void ieee80211_mesh_path_root_timer(unsigned long data)
 	ieee80211_queue_work(&local->hw, &ifmsh->work);
 }
 
+void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh)
+{
+	if (ifmsh->mshcfg.dot11MeshHWMPRootMode)
+		set_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags);
+	else {
+		clear_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags);
+		/* stop running timer */
+		del_timer_sync(&ifmsh->mesh_path_root_timer);
+	}
+}
+
 /**
  * ieee80211_fill_mesh_addresses - fill addresses of a locally originated mesh frame
  * @hdr:    	802.11 frame header
@@ -503,6 +514,7 @@ void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
 		add_timer(&ifmsh->mesh_path_timer);
 	if (test_and_clear_bit(TMR_RUNNING_MPR, &ifmsh->timers_running))
 		add_timer(&ifmsh->mesh_path_root_timer);
+	ieee80211_mesh_root_setup(ifmsh);
 }
 #endif
 
@@ -512,6 +524,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
+	ieee80211_mesh_root_setup(ifmsh);
 	ieee80211_queue_work(&local->hw, &ifmsh->work);
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 00ee842..5ad6975 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -242,6 +242,7 @@ ieee80211_rx_result
 ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 867b023..c1f66fc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2605,6 +2605,8 @@ static int nl80211_get_mesh_params(struct sk_buff *skb,
 			cur_params.dot11MeshHWMPpreqMinInterval);
 	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 			cur_params.dot11MeshHWMPnetDiameterTraversalTime);
+	NLA_PUT_U8(msg, NL80211_MESHCONF_HWMP_ROOTMODE,
+			cur_params.dot11MeshHWMPRootMode);
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
 	err = genlmsg_reply(msg, info);
@@ -2715,6 +2717,10 @@ static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info *info)
 			dot11MeshHWMPnetDiameterTraversalTime,
 			mask, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 			nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
+			dot11MeshHWMPRootMode, mask,
+			NL80211_MESHCONF_HWMP_ROOTMODE,
+			nla_get_u8);
 
 	/* Apply changes */
 	err = rdev->ops->set_mesh_params(&rdev->wiphy, dev, &cfg, mask);
-- 
1.5.6.5

