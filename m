Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41198 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaKZU4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 15:56:32 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so13779465wiv.11
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 12:56:31 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v4 3/4] cfg80211: allow usermode to query wiphy specific regdom
Date: Wed, 26 Nov 2014 22:56:27 +0200
Message-Id: <1417035388-2511-3-git-send-email-arik@wizery.com> (sfid-20141126_215637_092422_4A55F4DC)
In-Reply-To: <1417035388-2511-1-git-send-email-arik@wizery.com>
References: <1417035388-2511-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a wiphy-idx is specified, the kernel will return the wiphy specific
regdomain, if such exists. Otherwise return the global regdom.

When no wiphy-idx is specified, return the global regdomain as well as
all wiphy-specific regulatory domains in the system, via a new nested
list of attributes.

Add a new attribute for each wiphy-specific regdomain, for usermode to
identify it as such.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
Rest assured, I have an iw version that prints all the regdomains. I just
need a bit of time to clean it up.

 include/uapi/linux/nl80211.h |  16 +++++-
 net/wireless/nl80211.c       | 123 +++++++++++++++++++++++++++++++++----------
 net/wireless/reg.c           |   2 +-
 net/wireless/reg.h           |   1 +
 4 files changed, 111 insertions(+), 31 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 3771e7d..6517210 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -252,7 +252,9 @@
  *	%NL80211_ATTR_IFINDEX.
  *
  * @NL80211_CMD_GET_REG: ask the wireless core to send us its currently set
- * 	regulatory domain.
+ *	regulatory domain. If %NL80211_ATTR_WIPHY is specified and the device
+ *	its private regulatory domain will be returned.
+ *	returned, even if it's regulatory is not self-managed.
  * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this command
  *	after being queried by the kernel. CRDA replies by sending a regulatory
  *	domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
@@ -1693,6 +1695,14 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_MAC_MASK: MAC address mask
  *
+ * @NL80211_ATTR_WIPHY_PRIV_REG: flag attribute indicating the regulatory
+ *	information was obtained from the device's wiphy. This can happen
+ *	when the driver uses the regulatory_hint() API for setting the device's
+ *	regulatory domain.
+ *
+ * @NL80211_ATTR_WIPHY_REGDOM_LIST: Nested set of attributes containing
+ *	a list of wiphy specific regdomains.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2050,6 +2060,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAC_MASK,
 
+	NL80211_ATTR_WIPHY_PRIV_REG,
+
+	NL80211_ATTR_WIPHY_REGDOM_LIST,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f1e2f59..65bab11 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -396,6 +396,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
+	[NL80211_ATTR_WIPHY_PRIV_REG] = { .type = NLA_FLAG },
+	[NL80211_ATTR_WIPHY_REGDOM_LIST] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -5326,42 +5328,20 @@ static int nl80211_update_mesh_config(struct sk_buff *skb,
 	return err;
 }
 
-static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_put_regdom(const struct ieee80211_regdomain *regdom,
+			      struct sk_buff *msg)
 {
-	const struct ieee80211_regdomain *regdom;
-	struct sk_buff *msg;
-	void *hdr = NULL;
 	struct nlattr *nl_reg_rules;
 	unsigned int i;
 
-	if (!cfg80211_regdomain)
-		return -EINVAL;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOBUFS;
-
-	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
-			     NL80211_CMD_GET_REG);
-	if (!hdr)
-		goto put_failure;
-
-	if (reg_last_request_cell_base() &&
-	    nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
-			NL80211_USER_REG_HINT_CELL_BASE))
-		goto nla_put_failure;
-
-	rcu_read_lock();
-	regdom = rcu_dereference(cfg80211_regdomain);
-
 	if (nla_put_string(msg, NL80211_ATTR_REG_ALPHA2, regdom->alpha2) ||
 	    (regdom->dfs_region &&
 	     nla_put_u8(msg, NL80211_ATTR_DFS_REGION, regdom->dfs_region)))
-		goto nla_put_failure_rcu;
+		goto nla_put_failure;
 
 	nl_reg_rules = nla_nest_start(msg, NL80211_ATTR_REG_RULES);
 	if (!nl_reg_rules)
-		goto nla_put_failure_rcu;
+		goto nla_put_failure;
 
 	for (i = 0; i < regdom->n_reg_rules; i++) {
 		struct nlattr *nl_reg_rule;
@@ -5376,7 +5356,7 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 
 		nl_reg_rule = nla_nest_start(msg, i);
 		if (!nl_reg_rule)
-			goto nla_put_failure_rcu;
+			goto nla_put_failure;
 
 		max_bandwidth_khz = freq_range->max_bandwidth_khz;
 		if (!max_bandwidth_khz)
@@ -5397,13 +5377,98 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 				power_rule->max_eirp) ||
 		    nla_put_u32(msg, NL80211_ATTR_DFS_CAC_TIME,
 				reg_rule->dfs_cac_ms))
-			goto nla_put_failure_rcu;
+			goto nla_put_failure;
 
 		nla_nest_end(msg, nl_reg_rule);
 	}
-	rcu_read_unlock();
 
 	nla_nest_end(msg, nl_reg_rules);
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
+{
+	const struct ieee80211_regdomain *regdom = NULL;
+	struct cfg80211_registered_device *rdev;
+	struct wiphy *wiphy;
+	struct sk_buff *msg;
+	struct nlattr *nl_priv_regdoms, *nl_priv_regdom;
+	void *hdr = NULL;
+	int i;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOBUFS;
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_GET_REG);
+	if (!hdr)
+		goto put_failure;
+
+	if (info->attrs[NL80211_ATTR_WIPHY]) {
+		rdev = cfg80211_get_dev_from_info(genl_info_net(info), info);
+		if (IS_ERR(rdev)) {
+			nlmsg_free(msg);
+			return PTR_ERR(rdev);
+		}
+
+		wiphy = &rdev->wiphy;
+		regdom = get_wiphy_regdom(wiphy);
+		if (regdom &&
+		    nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx))
+			goto nla_put_failure;
+	}
+
+	if (!regdom) {
+		if (!cfg80211_regdomain) {
+			nlmsg_free(msg);
+			return -EINVAL;
+		}
+
+		if (reg_last_request_cell_base() &&
+		    nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
+				NL80211_USER_REG_HINT_CELL_BASE))
+			goto nla_put_failure;
+	}
+
+	rcu_read_lock();
+
+	if (!regdom)
+		regdom = rcu_dereference(cfg80211_regdomain);
+
+	if (nl80211_put_regdom(regdom, msg))
+		goto nla_put_failure_rcu;
+
+	nl_priv_regdoms = nla_nest_start(msg, NL80211_ATTR_WIPHY_REGDOM_LIST);
+	if (!nl_priv_regdoms)
+		goto nla_put_failure_rcu;
+
+	i = 0;
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		wiphy = &rdev->wiphy;
+		regdom = get_wiphy_regdom(wiphy);
+		if (!regdom)
+			continue;
+
+		nl_priv_regdom = nla_nest_start(msg, i);
+		if (!nl_priv_regdom)
+			goto nla_put_failure_rcu;
+
+		if (nl80211_put_regdom(regdom, msg))
+			goto nla_put_failure_rcu;
+
+		if (nla_put_flag(msg, NL80211_ATTR_WIPHY_PRIV_REG))
+			goto nla_put_failure_rcu;
+
+		nla_nest_end(msg, nl_priv_regdom);
+		i++;
+	}
+	nla_nest_end(msg, nl_priv_regdoms);
+
+	rcu_read_unlock();
 
 	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b23d513..41badc4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -142,7 +142,7 @@ static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 	return rtnl_dereference(cfg80211_regdomain);
 }
 
-static const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy)
+const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy)
 {
 	return rtnl_dereference(wiphy->regd);
 }
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 5e48031..4b45d6e 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -38,6 +38,7 @@ unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
 				   const struct ieee80211_reg_rule *rule);
 
 bool reg_last_request_cell_base(void);
+const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy);
 
 /**
  * regulatory_hint_found_beacon - hints a beacon was found on a channel
-- 
1.9.1

