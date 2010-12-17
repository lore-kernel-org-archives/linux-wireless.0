Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12641 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab0LQDX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 22:23:29 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 19:23:14 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 2/8] cfg80211: process new country regulatory flags (DFS)
Date: Thu, 16 Dec 2010 19:23:11 -0800
Message-ID: <1292556197-4820-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lets us pick up the new country regulatory flags.
This will later be used to inform of drivers later of
DFS parameters.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h  |   23 +++++++++++++++++++++++
 include/net/regulatory.h |    1 +
 net/wireless/nl80211.c   |    9 +++++++++
 net/wireless/reg.c       |   26 ++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 1cee56b..061c9a1 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -858,6 +858,9 @@ enum nl80211_commands {
  *	attributes, specifying what a key should be set as default as.
  *	See &enum nl80211_key_default_types.
  *
+ * @NL80211_ATTR_REG_COUNTRY_FLAGS: Country specific regulatory flags.
+ *	These are @NL80211_CFLAG_DFS_FCC_*
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1040,6 +1043,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
 
+	NL80211_ATTR_REG_COUNTRY_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1477,6 +1482,24 @@ enum nl80211_reg_rule_flags {
 };
 
 /**
+ * enum nl80211_cflags - country regulatory flags
+ *
+ * @NL80211_CFLAG_DFS_FCC_: Country follows DFS master rules from FCC
+ * @NL80211_CFLAG_DFS_FCC_: Country follows DFS master rules from ETSI
+ * @NL80211_CFLAG_DFS_JP_: Country follows DFS master rules from JP/Telec
+ */
+enum nl80211_cflags {
+	NL80211_CFLAG_DFS_FCC		= 1<<0,
+	NL80211_CFLAG_DFS_ETSI		= 1<<1,
+	NL80211_CFLAG_DFS_JP		= 1<<2,
+};
+
+#define NL80211_CFLAG_ALL_DFS_FLAGS \
+	(NL80211_CFLAG_DFS_FCC | \
+	 NL80211_CFLAG_DFS_ETSI | \
+	 NL80211_CFLAG_DFS_JP)
+
+/**
  * enum nl80211_survey_info - survey information
  *
  * These attribute types are used with %NL80211_ATTR_SURVEY_INFO
diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 356d6e3..9fcb603 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -85,6 +85,7 @@ struct ieee80211_reg_rule {
 struct ieee80211_regdomain {
 	u32 n_reg_rules;
 	char alpha2[2];
+	u16 flags;
 	struct ieee80211_reg_rule reg_rules[];
 };
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 594a6ac..d255499 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -172,6 +172,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MCAST_RATE] = { .type = NLA_U32 },
 	[NL80211_ATTR_OFFCHANNEL_TX_OK] = { .type = NLA_FLAG },
 	[NL80211_ATTR_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_REG_COUNTRY_FLAGS] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -2906,6 +2907,8 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 
 	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2,
 		cfg80211_regdomain->alpha2);
+	NLA_PUT_U16(msg, NL80211_ATTR_REG_COUNTRY_FLAGS,
+		cfg80211_regdomain->flags);
 
 	nl_reg_rules = nla_nest_start(msg, NL80211_ATTR_REG_RULES);
 	if (!nl_reg_rules)
@@ -2963,6 +2966,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	char *alpha2 = NULL;
 	int rem_reg_rules = 0, r = 0;
 	u32 num_rules = 0, rule_idx = 0, size_of_regd;
+	u16 cflags = 0;
 	struct ieee80211_regdomain *rd = NULL;
 
 	if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
@@ -2973,6 +2977,10 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 
 	alpha2 = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
 
+	if (info->attrs[NL80211_ATTR_REG_COUNTRY_FLAGS])
+		cflags =
+		 nla_get_u16(info->attrs[NL80211_ATTR_REG_COUNTRY_FLAGS]);
+
 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
 			rem_reg_rules) {
 		num_rules++;
@@ -2999,6 +3007,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	rd->n_reg_rules = num_rules;
 	rd->alpha2[0] = alpha2[0];
 	rd->alpha2[1] = alpha2[1];
+	rd->flags = cflags;
 
 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
 			rem_reg_rules) {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 99d4183..a3731d2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1881,6 +1881,31 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 	}
 }
 
+#define flag_check_print(_str) \
+	do { \
+		if (has_flag) \
+			pr_info(", "); \
+		pr_info(_str); \
+		has_flag = true; \
+	} while (0)
+
+static void print_country_flags(u16 flags)
+{
+	bool has_flag = false;
+
+	if (!(flags & NL80211_CFLAG_ALL_DFS_FLAGS))
+		return;
+
+	pr_info("DFS Master region:");
+
+	if (flags & NL80211_CFLAG_DFS_FCC)
+		flag_check_print("FCC");
+	if (flags & NL80211_CFLAG_DFS_ETSI)
+		flag_check_print("ETSI");
+	if (flags & NL80211_CFLAG_DFS_JP)
+		flag_check_print("JP");
+}
+
 static void print_regdomain(const struct ieee80211_regdomain *rd)
 {
 
@@ -1908,6 +1933,7 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 			pr_info("Regulatory domain changed to country: %c%c\n",
 				rd->alpha2[0], rd->alpha2[1]);
 	}
+	print_country_flags(rd->flags);
 	print_rd_rules(rd);
 }
 
-- 
1.7.3.2.90.gd4c43

