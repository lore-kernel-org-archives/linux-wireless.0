Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42151 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaLAPxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 10:53:50 -0500
Received: by mail-wg0-f41.google.com with SMTP id y19so14577539wgg.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 07:53:49 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 3/4] iw: fix attr max for reg_rule
Date: Mon,  1 Dec 2014 17:53:43 +0200
Message-Id: <1417449224-10293-3-git-send-email-arik@wizery.com> (sfid-20141201_165354_139601_D7EC8123)
In-Reply-To: <1417449224-10293-1-git-send-email-arik@wizery.com>
References: <1417449224-10293-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 reg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/reg.c b/reg.c
index 9af8e7e..a02c982 100644
--- a/reg.c
+++ b/reg.c
@@ -127,7 +127,7 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 	struct nlattr *nl_rule;
 	int rem_rule;
 	enum nl80211_dfs_regions dfs_domain;
-	static struct nla_policy reg_rule_policy[NL80211_FREQUENCY_ATTR_MAX + 1] = {
+	static struct nla_policy reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] = {
 		[NL80211_ATTR_REG_RULE_FLAGS]		= { .type = NLA_U32 },
 		[NL80211_ATTR_FREQ_RANGE_START]		= { .type = NLA_U32 },
 		[NL80211_ATTR_FREQ_RANGE_END]		= { .type = NLA_U32 },
@@ -159,10 +159,10 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 	printf("country %c%c: %s\n", alpha2[0], alpha2[1], dfs_domain_name(dfs_domain));
 
 	nla_for_each_nested(nl_rule, tb_msg[NL80211_ATTR_REG_RULES], rem_rule) {
-		struct nlattr *tb_rule[NL80211_FREQUENCY_ATTR_MAX + 1];
+		struct nlattr *tb_rule[NL80211_REG_RULE_ATTR_MAX + 1];
 		__u32 flags, start_freq_khz, end_freq_khz, max_bw_khz, max_ant_gain_mbi, max_eirp_mbm;
 
-		nla_parse(tb_rule, NL80211_FREQUENCY_ATTR_MAX, nla_data(nl_rule), nla_len(nl_rule), reg_rule_policy);
+		nla_parse(tb_rule, NL80211_REG_RULE_ATTR_MAX, nla_data(nl_rule), nla_len(nl_rule), reg_rule_policy);
 
 		flags = nla_get_u32(tb_rule[NL80211_ATTR_REG_RULE_FLAGS]);
 		start_freq_khz = nla_get_u32(tb_rule[NL80211_ATTR_FREQ_RANGE_START]);
-- 
1.9.1

