Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab0LCI1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 03:27:30 -0500
Message-Id: <20101203082348.883873119@sipsolutions.net>
Date: Fri, 03 Dec 2010 09:20:43 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] nl80211: refactor mesh parameter parsing
References: <20101203082039.131181927@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

I'm going to need this in a new place later.

Tested-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: - reduce scope of macro

 net/wireless/nl80211.c |   61 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 23 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2010-12-03 09:13:49.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2010-12-03 09:13:52.000000000 +0100
@@ -2613,14 +2613,6 @@ static int nl80211_get_mesh_params(struc
 	return -ENOBUFS;
 }
 
-#define FILL_IN_MESH_PARAM_IF_SET(table, cfg, param, mask, attr_num, nla_fn) \
-do {\
-	if (table[attr_num]) {\
-		cfg.param = nla_fn(table[attr_num]); \
-		mask |= (1 << (attr_num - 1)); \
-	} \
-} while (0);\
-
 static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_ATTR_MAX+1] = {
 	[NL80211_MESHCONF_RETRY_TIMEOUT] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_CONFIRM_TIMEOUT] = { .type = NLA_U16 },
@@ -2639,31 +2631,34 @@ static const struct nla_policy nl80211_m
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
 };
 
-static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_parse_mesh_params(struct genl_info *info,
+				     struct mesh_config *cfg,
+				     u32 *mask_out)
 {
-	u32 mask;
-	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
-	struct mesh_config cfg;
 	struct nlattr *tb[NL80211_MESHCONF_ATTR_MAX + 1];
-	struct nlattr *parent_attr;
+	u32 mask = 0;
+
+#define FILL_IN_MESH_PARAM_IF_SET(table, cfg, param, mask, attr_num, nla_fn) \
+do {\
+	if (table[attr_num]) {\
+		cfg->param = nla_fn(table[attr_num]); \
+		mask |= (1 << (attr_num - 1)); \
+	} \
+} while (0);\
+
 
-	parent_attr = info->attrs[NL80211_ATTR_MESH_PARAMS];
-	if (!parent_attr)
+	if (!info->attrs[NL80211_ATTR_MESH_PARAMS])
 		return -EINVAL;
 	if (nla_parse_nested(tb, NL80211_MESHCONF_ATTR_MAX,
-			parent_attr, nl80211_meshconf_params_policy))
+			     info->attrs[NL80211_ATTR_MESH_PARAMS],
+			     nl80211_meshconf_params_policy))
 		return -EINVAL;
 
-	if (!rdev->ops->set_mesh_params)
-		return -EOPNOTSUPP;
-
 	/* This makes sure that there aren't more than 32 mesh config
 	 * parameters (otherwise our bitfield scheme would not work.) */
 	BUILD_BUG_ON(NL80211_MESHCONF_ATTR_MAX > 32);
 
 	/* Fill in the params struct */
-	mask = 0;
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshRetryTimeout,
 			mask, NL80211_MESHCONF_RETRY_TIMEOUT, nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshConfirmTimeout,
@@ -2703,12 +2698,32 @@ static int nl80211_set_mesh_params(struc
 			NL80211_MESHCONF_HWMP_ROOTMODE,
 			nla_get_u8);
 
+	if (mask_out)
+		*mask_out = mask;
+	return 0;
+
+#undef FILL_IN_MESH_PARAM_IF_SET
+}
+
+static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct mesh_config cfg;
+	u32 mask;
+	int err;
+
+	if (!rdev->ops->set_mesh_params)
+		return -EOPNOTSUPP;
+
+	err = nl80211_parse_mesh_params(info, &cfg, &mask);
+	if (err)
+		return err;
+
 	/* Apply changes */
 	return rdev->ops->set_mesh_params(&rdev->wiphy, dev, &cfg, mask);
 }
 
-#undef FILL_IN_MESH_PARAM_IF_SET
-
 static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 {
 	struct sk_buff *msg;


