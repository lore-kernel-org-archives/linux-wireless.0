Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48846 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab1JDXsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 19:48:20 -0400
Received: by yxl31 with SMTP id 31so1031168yxl.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 16:48:19 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 8/8] iw: add DFS region parsing support
Date: Tue,  4 Oct 2011 16:47:47 -0700
Message-Id: <1317772067-6998-9-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111005_014822_980307_22050B42)
In-Reply-To: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lets iw parse the DFS region passed on by the kernel
when one is found for the currently used regulatory domain.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 reg.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/reg.c b/reg.c
index c4ee1c4..4fa5bec 100644
--- a/reg.c
+++ b/reg.c
@@ -96,6 +96,31 @@ COMMAND(reg, set, "<ISO/IEC 3166-1 alpha2>",
 	NL80211_CMD_REQ_SET_REG, 0, CIB_NONE, handle_reg_set,
 	"Notify the kernel about the current regulatory domain.");
 
+static void print_dfs_region(__u8 dfs_region)
+{
+	if (!dfs_region)
+		return;
+
+	printf("DFS Master region: ");
+
+	switch (dfs_region) {
+	case NL80211_DFS_FCC:
+		printf("FCC");
+		break;
+	case NL80211_DFS_ETSI:
+		printf("ETSI");
+		break;
+	case NL80211_DFS_JP:
+		printf("JP");
+		break;
+	default:
+		printf("Uknown");
+		break;
+	}
+
+	printf("\n");
+}
+
 static int print_reg_handler(struct nl_msg *msg, void *arg)
 
 {
@@ -107,6 +132,7 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
 	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
 	char *alpha2;
+	__u8 dfs_region = 0;
 	struct nlattr *nl_rule;
 	int rem_rule;
 	static struct nla_policy reg_rule_policy[NL80211_FREQUENCY_ATTR_MAX + 1] = {
@@ -132,7 +158,12 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 	}
 
 	alpha2 = nla_data(tb_msg[NL80211_ATTR_REG_ALPHA2]);
+
+	if (tb_msg[NL80211_ATTR_DFS_REGION])
+		dfs_region = nla_get_u8(tb_msg[NL80211_ATTR_DFS_REGION]);
+
 	printf("country %c%c:\n", alpha2[0], alpha2[1]);
+	print_dfs_region(dfs_region);
 
 	nla_for_each_nested(nl_rule, tb_msg[NL80211_ATTR_REG_RULES], rem_rule) {
 		struct nlattr *tb_rule[NL80211_FREQUENCY_ATTR_MAX + 1];
-- 
1.7.4.15.g7811d

