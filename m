Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:50005 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751387AbZBHTwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 14:52:33 -0500
From: Florian Sesser <flomaillist@cosetrain.com>
To: linux-wireless@vger.kernel.org
Cc: Florian Sesser <flomaillist@cosetrain.com>
Subject: [PATCH 2/3] mac80211: Modul. mesh path prot: Comm w/ Userspace
Date: Sun,  8 Feb 2009 20:52:21 +0100
Message-Id: <897787d59c53459e0bff3a6829ac470f6ed2e84e.1234118418.git.flomaillist@cosetrain.com> (sfid-20090208_205238_013714_9C35AD85)
In-Reply-To: <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>
References: <498F36B7.40806@cosetrain.com>
 <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>
In-Reply-To: <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>
References: <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modularize mesh path selection protocol.

This patch enables communication with userspace through the
"iw" tool. The corresponding patch to IW will be posted on
this list.

Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
---
 include/linux/nl80211.h |   10 ++++++++++
 include/net/cfg80211.h  |    4 ++++
 net/mac80211/cfg.c      |    9 +++++++++
 net/wireless/nl80211.c  |   18 ++++++++++++++++++
 4 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 4bc2704..1125e73 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -776,6 +776,13 @@ enum nl80211_mntr_flags {
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
@@ -795,6 +802,9 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
 	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+	NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID,
+	NL80211_MESHCONF_PATH_SELECTION_METRIC_ID,
+	NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index dd1fd51..83eb2a1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -458,6 +458,10 @@ struct mesh_config {
 	u32 dot11MeshHWMPactivePathTimeout;
 	u16 dot11MeshHWMPpreqMinInterval;
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
+	/* Mesh IDs */
+	u32 mesh_path_selection_protocol_id;
+	u32 mesh_path_selection_metric_id;
+	u32 mesh_congestion_control_mode_id;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a1a1344..c885086 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1085,6 +1085,15 @@ static int ieee80211_set_mesh_params(struct wiphy *wiphy,
 			   mask))
 		conf->dot11MeshHWMPnetDiameterTraversalTime =
 			nconf->dot11MeshHWMPnetDiameterTraversalTime;
+	if (_chg_mesh_attr(NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID, mask))
+		mesh_ids_set_pp(&sdata->u.mesh,
+		nconf->mesh_path_selection_protocol_id);
+	if (_chg_mesh_attr(NL80211_MESHCONF_PATH_SELECTION_METRIC_ID, mask))
+		conf->mesh_path_selection_metric_id =
+			nconf->mesh_path_selection_metric_id;
+	if (_chg_mesh_attr(NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID, mask))
+		conf->mesh_congestion_control_mode_id =
+			nconf->mesh_congestion_control_mode_id;
 	return 0;
 }
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d452396..6e62e33 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1979,6 +1979,12 @@ static int nl80211_get_mesh_params(struct sk_buff *skb,
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
@@ -2018,6 +2024,9 @@ nl80211_meshconf_params_policy[NL80211_MESHCONF_ATTR_MAX+1] __read_mostly = {
 	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_PATH_SELECTION_METRIC_ID] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID] = { .type = NLA_U32 },
 };
 
 static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info *info)
@@ -2079,6 +2088,15 @@ static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info *info)
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

