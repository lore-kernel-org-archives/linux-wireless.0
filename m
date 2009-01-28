Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57334 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbZA1Cws (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 21:52:48 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 18:52:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: add get reg command
Date: Tue, 27 Jan 2009 18:52:05 -0800
Message-ID: <1233111125-7955-1-git-send-email-lrodriguez@atheros.com> (sfid-20090128_035251_909766_11641546)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lets userspace request to get the currently set
regulatory domain.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |    4 ++
 net/wireless/nl80211.c  |   82 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/reg.c      |    8 ++++
 net/wireless/reg.h      |    2 +
 4 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3357907..ef5c1d3 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -113,6 +113,8 @@
  * @NL80211_CMD_SET_BSS: Set BSS attributes for BSS identified by
  *	%NL80211_ATTR_IFINDEX.
  *
+ * @NL80211_CMD_GET_REG: ask the wireless core to send us its currently set
+ * 	regulatory domain.
  * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this command
  *	after being queried by the kernel. CRDA replies by sending a regulatory
  *	domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
@@ -188,6 +190,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_MGMT_EXTRA_IE,
 
+	NL80211_CMD_GET_REG,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3c6327d..7fbd359 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2094,6 +2094,82 @@ static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info *info)
 
 #undef FILL_IN_MESH_PARAM_IF_SET
 
+static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	const struct ieee80211_regdomain *regd;
+	void *hdr = NULL;
+	struct nlattr *nl_reg_rules;
+	unsigned int i;
+	int err = -EINVAL;
+
+	mutex_lock(&cfg80211_drv_mutex);
+	regd = reg_get_current_rd();
+	mutex_unlock(&cfg80211_drv_mutex);
+
+	if (!regd)
+		goto out;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg) {
+		err = -ENOBUFS;
+		goto out;
+	}
+
+	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_GET_REG);
+	if (!hdr)
+		goto nla_put_failure;
+
+	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2, regd->alpha2);
+
+	nl_reg_rules = nla_nest_start(msg, NL80211_ATTR_REG_RULES);
+	if (!nl_reg_rules)
+		goto nla_put_failure;
+
+	for (i = 0; i < regd->n_reg_rules; i++) {
+		struct nlattr *nl_reg_rule;
+		const struct ieee80211_reg_rule *reg_rule;
+		const struct ieee80211_freq_range *freq_range;
+		const struct ieee80211_power_rule *power_rule;
+
+		reg_rule = &regd->reg_rules[i];
+		freq_range = &reg_rule->freq_range;
+		power_rule = &reg_rule->power_rule;
+
+		nl_reg_rule = nla_nest_start(msg, i);
+		if (!nl_reg_rule)
+			goto nla_put_failure;
+
+		NLA_PUT_U32(msg, NL80211_ATTR_REG_RULE_FLAGS,
+			reg_rule->flags);
+		NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_START,
+			freq_range->start_freq_khz);
+		NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_END,
+			freq_range->end_freq_khz);
+		NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_MAX_BW,
+			freq_range->max_bandwidth_khz);
+		NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,
+			power_rule->max_antenna_gain);
+		NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,
+			power_rule->max_eirp);
+
+		nla_nest_end(msg, nl_reg_rule);
+	}
+
+	nla_nest_end(msg, nl_reg_rules);
+
+	genlmsg_end(msg, hdr);
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto out;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	err = -EMSGSIZE;
+out:
+	return err;
+}
+
 static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[NL80211_REG_RULE_ATTR_MAX + 1];
@@ -2334,6 +2410,12 @@ static struct genl_ops nl80211_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
+		.cmd = NL80211_CMD_GET_REG,
+		.doit = nl80211_get_reg,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
+	{
 		.cmd = NL80211_CMD_SET_REG,
 		.doit = nl80211_set_reg,
 		.policy = nl80211_policy,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f643d39..50d8328 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1598,6 +1598,14 @@ void reg_device_remove(struct wiphy *wiphy)
 	last_request->country_ie_env = ENVIRON_ANY;
 }
 
+/* caller is reponsible for locking */
+const struct ieee80211_regdomain *reg_get_current_rd(void)
+{
+	const struct ieee80211_regdomain *regd;
+	reg_copy_regd(&regd, cfg80211_regdomain);
+	return regd;
+}
+
 int regulatory_init(void)
 {
 	int err;
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index eb1dd5b..1dcbdfe 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -34,4 +34,6 @@ extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 			     const char *alpha2, u32 country_ie_checksum,
 			     enum environment_cap country_ie_env);
 
+const struct ieee80211_regdomain *reg_get_current_rd(void);
+
 #endif  /* __NET_WIRELESS_REG_H */
-- 
1.6.1.rc3.51.g5832d

