Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:34139 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759183Ab3DCMwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 08:52:06 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] iw: display DFS regulatory domain
Date: Wed,  3 Apr 2013 14:51:56 +0200
Message-Id: <1364993516-12537-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130403_145211_326653_AEA9B447)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 reg.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/reg.c b/reg.c
index 5afc92b..9a60cec 100644
--- a/reg.c
+++ b/reg.c
@@ -59,6 +59,22 @@ char *reg_initiator_to_string(__u8 initiator)
 	}
 }
 
+static const char *dfs_domain_name(enum nl80211_dfs_regions region)
+{
+	switch (region) {
+	case NL80211_DFS_UNSET:
+		return "DFS-UNSET";
+	case NL80211_DFS_FCC:
+		return "DFS-FCC";
+	case NL80211_DFS_ETSI:
+		return "DFS-ETSI";
+	case NL80211_DFS_JP:
+		return "DFS-JP";
+	default:
+		return "DFS-invalid";
+	}
+}
+
 static int handle_reg_set(struct nl80211_state *state,
 			  struct nl_cb *cb,
 			  struct nl_msg *msg,
@@ -110,6 +126,7 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 	char *alpha2;
 	struct nlattr *nl_rule;
 	int rem_rule;
+	enum nl80211_dfs_regions dfs_domain;
 	static struct nla_policy reg_rule_policy[NL80211_FREQUENCY_ATTR_MAX + 1] = {
 		[NL80211_ATTR_REG_RULE_FLAGS]		= { .type = NLA_U32 },
 		[NL80211_ATTR_FREQ_RANGE_START]		= { .type = NLA_U32 },
@@ -132,8 +149,13 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 		return NL_SKIP;
 	}
 
+	if (tb_msg[NL80211_ATTR_DFS_REGION])
+		dfs_domain = nla_get_u8(tb_msg[NL80211_ATTR_DFS_REGION]);
+	else
+		dfs_domain = NL80211_DFS_UNSET;
+
 	alpha2 = nla_data(tb_msg[NL80211_ATTR_REG_ALPHA2]);
-	printf("country %c%c:\n", alpha2[0], alpha2[1]);
+	printf("country %c%c: %s\n", alpha2[0], alpha2[1], dfs_domain_name(dfs_domain));
 
 	nla_for_each_nested(nl_rule, tb_msg[NL80211_ATTR_REG_RULES], rem_rule) {
 		struct nlattr *tb_rule[NL80211_FREQUENCY_ATTR_MAX + 1];
-- 
1.7.4.1

