Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0LBIej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 03:34:39 -0500
Subject: [RFC 4/5 v2] nl80211: refactor mesh parameter parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org
In-Reply-To: <20101201210225.939307280@sipsolutions.net>
References: <20101201205939.009530439@sipsolutions.net>
	 <20101201210225.939307280@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 09:34:37 +0100
Message-ID: <1291278877.3481.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

I'm going to need this in a new place later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: - reduce scope of macro

 net/wireless/nl80211.c |   61 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 23 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2010-12-02 08:19:44.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2010-12-02 09:12:45.000000000 +0100
@@ -2611,14 +2611,6 @@ static int nl80211_get_mesh_params(struc
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
@@ -2636,31 +2628,34 @@ static const struct nla_policy nl80211_m
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
@@ -2698,12 +2693,32 @@ static int nl80211_set_mesh_params(struc
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


