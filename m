Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53671 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaLAQ2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 11:28:55 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so27350710wib.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 08:28:53 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v7 1/4] cfg80211: allow usermode to query wiphy specific regdom
Date: Mon,  1 Dec 2014 18:28:48 +0200
Message-Id: <1417451331-20536-1-git-send-email-arik@wizery.com> (sfid-20141201_172859_854881_5937A8EA)
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
 include/uapi/linux/nl80211.h |   8 +-
 net/wireless/nl80211.c       | 178 +++++++++++++++++++++++++++++++++++--------
 net/wireless/reg.c           |   2 +-
 net/wireless/reg.h           |   1 +
 4 files changed, 154 insertions(+), 35 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b37bd5a..62176a6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -252,7 +252,13 @@
  *	%NL80211_ATTR_IFINDEX.
  *
  * @NL80211_CMD_GET_REG: ask the wireless core to send us its currently set
- * 	regulatory domain.
+ *	regulatory domain. If %NL80211_ATTR_WIPHY is specified and the device
+ *	has a private regulatory domain, it will be returned. Otherwise, the
+ *	global regdomain will be returned.
+ *	A device will have a private regulatory domain if it uses the
+ *	regulatory_hint() API. Even when a private regdomain is used the channel
+ *	information will still be mended according to further hints from
+ *	the regulatory core to help with compliance.
  * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this command
  *	after being queried by the kernel. CRDA replies by sending a regulatory
  *	domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a17d6bc..6736eae 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5327,42 +5327,20 @@ static int nl80211_update_mesh_config(struct sk_buff *skb,
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
@@ -5377,7 +5355,7 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 
 		nl_reg_rule = nla_nest_start(msg, i);
 		if (!nl_reg_rule)
-			goto nla_put_failure_rcu;
+			goto nla_put_failure;
 
 		max_bandwidth_khz = freq_range->max_bandwidth_khz;
 		if (!max_bandwidth_khz)
@@ -5398,13 +5376,69 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
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
+static int nl80211_get_reg_do(struct sk_buff *skb, struct genl_info *info)
+{
+	const struct ieee80211_regdomain *regdom = NULL;
+	struct cfg80211_registered_device *rdev;
+	struct wiphy *wiphy = NULL;
+	struct sk_buff *msg;
+	void *hdr;
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
+
+		if (regdom &&
+		    nla_put_u32(msg, NL80211_ATTR_WIPHY, get_wiphy_idx(wiphy)))
+			goto nla_put_failure;
+	}
+
+	if (!regdom && !cfg80211_regdomain) {
+		nlmsg_free(msg);
+		return -EINVAL;
+	}
+
+	if (!wiphy && reg_last_request_cell_base() &&
+	    nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
+			NL80211_USER_REG_HINT_CELL_BASE))
+		goto nla_put_failure;
+
+	rcu_read_lock();
+
+	if (!regdom)
+		regdom = rcu_dereference(cfg80211_regdomain);
+
+	if (nl80211_put_regdom(regdom, msg))
+		goto nla_put_failure_rcu;
+
+	rcu_read_unlock();
 
 	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
@@ -5418,6 +5452,79 @@ put_failure:
 	return -EMSGSIZE;
 }
 
+static int nl80211_send_regdom(struct sk_buff *msg, struct netlink_callback *cb,
+			       u32 seq, int flags, struct wiphy *wiphy,
+			       const struct ieee80211_regdomain *regdom)
+{
+	void *hdr = nl80211hdr_put(msg, NETLINK_CB(cb->skb).portid, seq, flags,
+				   NL80211_CMD_GET_REG);
+
+	if (!hdr)
+		return -1;
+
+	genl_dump_check_consistent(cb, hdr, &nl80211_fam);
+
+	if (nl80211_put_regdom(regdom, msg))
+		goto nla_put_failure;
+
+	if (!wiphy && reg_last_request_cell_base() &&
+	    nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
+			NL80211_USER_REG_HINT_CELL_BASE))
+		goto nla_put_failure;
+
+	if (wiphy &&
+	    nla_put_u32(msg, NL80211_ATTR_WIPHY, get_wiphy_idx(wiphy)))
+		goto nla_put_failure;
+
+	return genlmsg_end(msg, hdr);
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static int nl80211_get_reg_dump(struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	const struct ieee80211_regdomain *regdom = NULL;
+	struct cfg80211_registered_device *rdev;
+	int err, reg_idx, start = cb->args[2];
+
+	rtnl_lock();
+
+	if (cfg80211_regdomain && start == 0) {
+		err = nl80211_send_regdom(skb, cb, cb->nlh->nlmsg_seq,
+					  NLM_F_MULTI, NULL,
+					  rtnl_dereference(cfg80211_regdomain));
+		if (err < 0)
+			goto out_err;
+	}
+
+	/* the global regdom is idx 0 */
+	reg_idx = 1;
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		regdom = get_wiphy_regdom(&rdev->wiphy);
+		if (!regdom)
+			continue;
+
+		if (++reg_idx <= start)
+			continue;
+
+		err = nl80211_send_regdom(skb, cb, cb->nlh->nlmsg_seq,
+					  NLM_F_MULTI, &rdev->wiphy, regdom);
+		if (err < 0) {
+			reg_idx--;
+			break;
+		}
+	}
+
+	cb->args[2] = reg_idx;
+	err = skb->len;
+out_err:
+	rtnl_unlock();
+	return err;
+}
+
 static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[NL80211_REG_RULE_ATTR_MAX + 1];
@@ -10225,7 +10332,8 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_REG,
-		.doit = nl80211_get_reg,
+		.doit = nl80211_get_reg_do,
+		.dumpit = nl80211_get_reg_dump,
 		.policy = nl80211_policy,
 		.internal_flags = NL80211_FLAG_NEED_RTNL,
 		/* can be retrieved by unprivileged users */
@@ -10983,9 +11091,13 @@ void nl80211_send_reg_change_event(struct regulatory_request *request)
 			goto nla_put_failure;
 	}
 
-	if (request->wiphy_idx != WIPHY_IDX_INVALID &&
-	    nla_put_u32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx))
-		goto nla_put_failure;
+	if (request->wiphy_idx != WIPHY_IDX_INVALID) {
+		struct wiphy *wiphy = wiphy_idx_to_wiphy(request->wiphy_idx);
+
+		if (wiphy &&
+		    nla_put_u32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx))
+			goto nla_put_failure;
+	}
 
 	genlmsg_end(msg, hdr);
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 47be616..48d90da 100644
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

