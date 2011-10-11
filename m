Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61753 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab1JKSAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 14:00:34 -0400
Received: by qadb15 with SMTP id b15so4947341qad.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 11:00:33 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 5/6] cfg80211: process regulatory DFS region for countries
Date: Tue, 11 Oct 2011 10:59:02 -0700
Message-Id: <1318355944-24708-6-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111011_200037_001014_791BC570)
In-Reply-To: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wireless-regdb now has support for mapping a country to
one DFS region. CRDA sends this to us now so process it
so we can provide that hint to drivers. This will later be
used by code for processing DFS in a way that meets the
criteria for the DFS region the country belongs to.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 include/linux/nl80211.h  |   21 +++++++++++++++++++++
 include/net/regulatory.h |    1 +
 net/wireless/nl80211.c   |   15 +++++++++++++++
 net/wireless/reg.c       |   37 +++++++++++++++++++++++++++++++++++++
 net/wireless/reg.h       |    1 +
 5 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 9d797f2..2dbb799 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1109,6 +1109,10 @@ enum nl80211_commands {
  *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver to perform a TDLS operation.
  *
+ * @NL80211_ATTR_DFS_REGION: region for regulatory rules which this country
+ *    abides to when initiating radiation on DFS channels. A country maps
+ *    to one DFS region.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1337,6 +1341,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_SUPPORT,
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
 
+	NL80211_ATTR_DFS_REGION,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1843,6 +1849,21 @@ enum nl80211_reg_rule_flags {
 };
 
 /**
+ * enum nl80211_dfs_regions - regulatory DFS regions
+ *
+ * @NL80211_DFS_UNSET: Country has no DFS master region specified
+ * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
+ * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
+ * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
+ */
+enum nl80211_dfs_regions {
+	NL80211_DFS_UNSET	= 0,
+	NL80211_DFS_FCC		= 1,
+	NL80211_DFS_ETSI	= 2,
+	NL80211_DFS_JP		= 3,
+};
+
+/**
  * enum nl80211_survey_info - survey information
  *
  * These attribute types are used with %NL80211_ATTR_SURVEY_INFO
diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index eb7d3c2..7399c93 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -93,6 +93,7 @@ struct ieee80211_reg_rule {
 struct ieee80211_regdomain {
 	u32 n_reg_rules;
 	char alpha2[2];
+	u8 dfs_region;
 	struct ieee80211_reg_rule reg_rules[];
 };
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index edf655a..8d3012a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -197,6 +197,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_TDLS_OPERATION] = { .type = NLA_U8 },
 	[NL80211_ATTR_TDLS_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TDLS_EXTERNAL_SETUP] = { .type = NLA_FLAG },
+	[NL80211_ATTR_DFS_REGION] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -3348,6 +3349,9 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 
 	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2,
 		cfg80211_regdomain->alpha2);
+	if (cfg80211_regdomain->dfs_region)
+		NLA_PUT_U8(msg, NL80211_ATTR_DFS_REGION,
+			   cfg80211_regdomain->dfs_region);
 
 	nl_reg_rules = nla_nest_start(msg, NL80211_ATTR_REG_RULES);
 	if (!nl_reg_rules)
@@ -3406,6 +3410,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	char *alpha2 = NULL;
 	int rem_reg_rules = 0, r = 0;
 	u32 num_rules = 0, rule_idx = 0, size_of_regd;
+	u8 dfs_region = 0;
 	struct ieee80211_regdomain *rd = NULL;
 
 	if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
@@ -3416,6 +3421,9 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 
 	alpha2 = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
 
+	if (info->attrs[NL80211_ATTR_DFS_REGION])
+		dfs_region = nla_get_u8(info->attrs[NL80211_ATTR_DFS_REGION]);
+
 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
 			rem_reg_rules) {
 		num_rules++;
@@ -3443,6 +3451,13 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	rd->alpha2[0] = alpha2[0];
 	rd->alpha2[1] = alpha2[1];
 
+	/*
+	 * Disable DFS master mode if the DFS region was
+	 * not supported or known on this kernel.
+	 */
+	if (reg_supported_dfs_region(dfs_region))
+		rd->dfs_region = dfs_region;
+
 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
 			rem_reg_rules) {
 		nla_parse(tb, NL80211_REG_RULE_ATTR_MAX,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2520a1b..69141ed 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1946,6 +1946,42 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 	}
 }
 
+bool reg_supported_dfs_region(u8 dfs_region)
+{
+	switch (dfs_region) {
+	case NL80211_DFS_UNSET:
+	case NL80211_DFS_FCC:
+	case NL80211_DFS_ETSI:
+	case NL80211_DFS_JP:
+		return true;
+	default:
+		REG_DBG_PRINT("Ignoring uknown DFS master region: %d\n",
+			      dfs_region);
+		return false;
+	}
+}
+
+static void print_dfs_region(u8 dfs_region)
+{
+	if (!dfs_region)
+		return;
+
+	switch (dfs_region) {
+	case NL80211_DFS_FCC:
+		pr_info(" DFS Master region FCC");
+		break;
+	case NL80211_DFS_ETSI:
+		pr_info(" DFS Master region ETSI");
+		break;
+	case NL80211_DFS_JP:
+		pr_info(" DFS Master region JP");
+		break;
+	default:
+		pr_info(" DFS Master region Uknown");
+		break;
+	}
+}
+
 static void print_regdomain(const struct ieee80211_regdomain *rd)
 {
 
@@ -1973,6 +2009,7 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 			pr_info("Regulatory domain changed to country: %c%c\n",
 				rd->alpha2[0], rd->alpha2[1]);
 	}
+	print_dfs_region(rd->dfs_region);
 	print_rd_rules(rd);
 }
 
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 4a56799..786e414 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -5,6 +5,7 @@ extern const struct ieee80211_regdomain *cfg80211_regdomain;
 
 bool is_world_regdom(const char *alpha2);
 bool reg_is_valid_request(const char *alpha2);
+bool reg_supported_dfs_region(u8 dfs_region);
 
 int regulatory_hint_user(const char *alpha2);
 
-- 
1.7.4.15.g7811d

