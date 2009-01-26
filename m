Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:40899 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752210AbZAZUjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 15:39:19 -0500
From: Florian Sesser <flomaillist@cosetrain.com>
To: linux-wireless@vger.kernel.org
Cc: Florian Sesser <flomaillist@cosetrain.com>
Subject: [PATCH 5/6] mac80211: o11s PP api communication with userspace
Date: Mon, 26 Jan 2009 21:39:14 +0100
Message-Id: <4ffda2b82d85e1a020ec30132906e35caeaa90e0.1233001803.git.flomaillist@cosetrain.com> (sfid-20090126_213928_130305_FA1A1736)
In-Reply-To: <79a59b62a4378b8b88cb3a33b1ec3cbd3808906e.1233001802.git.flomaillist@cosetrain.com>
References: <497E1B90.4060803@cosetrain.com>
 <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
 <3202b18e8531aa78c29636c163de20875ae1a9cf.1233001802.git.flomaillist@cosetrain.com>
 <e236615740b8ce8c9515c14aac3a2d9d93806a98.1233001802.git.flomaillist@cosetrain.com>
 <79a59b62a4378b8b88cb3a33b1ec3cbd3808906e.1233001802.git.flomaillist@cosetrain.com>
In-Reply-To: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
References: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interface nl80211 and iw to enable iw changing
path selection protocols by doing something like
iw dev <mesh-dev> set mesh_param mesh_path_selection_protocol_id <id>

Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
---
 include/linux/nl80211.h |   10 ++++++++++
 net/mac80211/cfg.c      |    8 ++++++++
 net/wireless/nl80211.c  |   18 ++++++++++++++++++
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 76aae3d..f8ec895 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -772,6 +772,13 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in TUs)
  * that it takes for an HWMP information element to propagate across the mesh
  *
+ * @NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID: Path Selection Protocol
+ * ID, consisting of an OUI + arbitrary 8 bit
+ *
+ * @NL80211_MESHCONF_PATH_SELECTION_METRIC_ID: Path Selection Metric ID
+ *
+ * @NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID: Congestion Control Mode ID
+ *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -791,6 +798,9 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
 	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+	NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID,
+	NL80211_MESHCONF_PATH_SELECTION_METRIC_ID,
+	NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a1a1344..5d72be9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1085,6 +1085,14 @@ static int ieee80211_set_mesh_params(struct wiphy *wiphy,
 			   mask))
 		conf->dot11MeshHWMPnetDiameterTraversalTime =
 			nconf->dot11MeshHWMPnetDiameterTraversalTime;
+	if (_chg_mesh_attr(NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID, mask))
+		mesh_ids_set_pp(&sdata->u.mesh, nconf->mesh_path_selection_protocol_id);
+	if (_chg_mesh_attr(NL80211_MESHCONF_PATH_SELECTION_METRIC_ID, mask))
+		conf->mesh_path_selection_metric_id =
+			nconf->mesh_path_selection_metric_id;
+	if (_chg_mesh_attr(NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID, mask))
+		conf->mesh_congestion_control_mode_id =
+			nconf->mesh_congestion_control_mode_id;
 	return 0;
 }
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 09a5d0f..4736077 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1974,6 +1974,12 @@ static int nl80211_get_mesh_params(struct sk_buff *skb,
 			cur_params.dot11MeshHWMPpreqMinInterval);
 	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 			cur_params.dot11MeshHWMPnetDiameterTraversalTime);
+	NLA_PUT_U32(msg, NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID,
+			cur_params.mesh_path_selection_protocol_id);
+	NLA_PUT_U32(msg, NL80211_MESHCONF_PATH_SELECTION_METRIC_ID,
+			cur_params.mesh_path_selection_metric_id);
+	NLA_PUT_U32(msg, NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID,
+			cur_params.mesh_congestion_control_mode_id);
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
 	err = genlmsg_unicast(msg, info->snd_pid);
@@ -2013,6 +2019,9 @@ nl80211_meshconf_params_policy[NL80211_MESHCONF_ATTR_MAX+1] __read_mostly = {
 	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_PATH_SELECTION_METRIC_ID] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID] = { .type = NLA_U32 },
 };
 
 static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info *info)
@@ -2074,6 +2083,15 @@ static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info *info)
 			dot11MeshHWMPnetDiameterTraversalTime,
 			mask, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 			nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, mesh_path_selection_protocol_id,
+			mask, NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID,
+			nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, mesh_path_selection_metric_id,
+			mask, NL80211_MESHCONF_PATH_SELECTION_METRIC_ID,
+			nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, mesh_congestion_control_mode_id,
+			mask, NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID,
+			nla_get_u32);
 
 	/* Apply changes */
 	rtnl_lock();
-- 
1.5.6.5

