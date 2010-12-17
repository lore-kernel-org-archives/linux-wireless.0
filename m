Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12658 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab0LQDXp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 22:23:45 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 19:23:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 7/8] iw: add DFS region parsing support
Date: Thu, 16 Dec 2010 19:23:16 -0800
Message-ID: <1292556197-4820-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 reg.c |   36 +++++++++++++++++++++++++++++++++++-
 1 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/reg.c b/reg.c
index 7f82e08..3c1b334 100644
--- a/reg.c
+++ b/reg.c
@@ -96,6 +96,33 @@ COMMAND(reg, set, "<ISO/IEC 3166-1 alpha2>",
 	NL80211_CMD_REQ_SET_REG, 0, CIB_NONE, handle_reg_set,
 	"Notify the kernel about the current regulatory domain.");
 
+#define flag_check_print(_str) \
+	do { \
+		if (has_flag) \
+			printf(", "); \
+		printf(_str); \
+		has_flag = true; \
+	} while (0)
+
+static void print_dfs_region(__u16 flags)
+{
+	bool has_flag = false;
+
+	if (!flags)
+		return;
+
+	printf(" ");
+
+	if (flags & NL80211_CFLAG_DFS_FCC)
+		flag_check_print("DFS-FCC");
+	if (flags & NL80211_CFLAG_DFS_ETSI)
+		flag_check_print("DFS-ETSI");
+	if (flags & NL80211_CFLAG_DFS_JP)
+		flag_check_print("DFS-JP");
+
+	printf("\n");
+}
+
 static int print_reg_handler(struct nl_msg *msg, void *arg)
 
 {
@@ -107,8 +134,10 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
 	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
 	char *alpha2;
+	char calpha2[2];
 	struct nlattr *nl_rule;
 	int rem_rule;
+	__u16 dfs_region;
 	static struct nla_policy reg_rule_policy[NL80211_FREQUENCY_ATTR_MAX + 1] = {
 		[NL80211_ATTR_REG_RULE_FLAGS]           = { .type = NLA_U32 },
 		[NL80211_ATTR_FREQ_RANGE_START]         = { .type = NLA_U32 },
@@ -132,7 +161,12 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 	}
 
 	alpha2 = nla_data(tb_msg[NL80211_ATTR_REG_ALPHA2]);
-	printf("country %s:\n", alpha2);
+	calpha2[0] = alpha2[0];
+	calpha2[1] = alpha2[1];
+	dfs_region = nla_get_u16(tb_msg[NL80211_ATTR_REG_COUNTRY_FLAGS]);
+
+	printf("country %c%c:", calpha2[0], calpha2[1]);
+	print_dfs_region(dfs_region);
 
 	nla_for_each_nested(nl_rule, tb_msg[NL80211_ATTR_REG_RULES], rem_rule) {
 		struct nlattr *tb_rule[NL80211_FREQUENCY_ATTR_MAX + 1];
-- 
1.7.3.2.90.gd4c43

