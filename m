Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60003 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZA1Q6m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 11:58:42 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 08:58:42 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2] iw: add get regulatory domain support
Date: Wed, 28 Jan 2009 08:57:59 -0800
Message-ID: <1233161879-27131-1-git-send-email-lrodriguez@atheros.com> (sfid-20090128_175846_343744_FF443B6D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This v2 remove silly sprintfs.

 COPYING   |    2 +-
 nl80211.h |    4 ++
 reg.c     |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+), 1 deletions(-)

diff --git a/COPYING b/COPYING
index 3ba767c..73e19ac 100644
--- a/COPYING
+++ b/COPYING
@@ -1,7 +1,7 @@
 Copyright (c) 2007, 2008	Johannes Berg
 Copyright (c) 2007		Andy Lutomirski
 Copyright (c) 2007		Mike Kershaw
-Copyright (c) 2008		Luis R. Rodriguez
+Copyright (c) 2008-2009		Luis R. Rodriguez
 
 Permission to use, copy, modify, and/or distribute this software for any
 purpose with or without fee is hereby granted, provided that the above
diff --git a/nl80211.h b/nl80211.h
index 76aae3d..4bc2704 100644
--- a/nl80211.h
+++ b/nl80211.h
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
diff --git a/reg.c b/reg.c
index 01573d3..cb58ed9 100644
--- a/reg.c
+++ b/reg.c
@@ -11,6 +11,13 @@
 #include "nl80211.h"
 #include "iw.h"
 
+#define MHZ_TO_KHZ(freq) ((freq) * 1000)
+#define KHZ_TO_MHZ(freq) ((freq) / 1000)
+#define DBI_TO_MBI(gain) ((gain) * 100)
+#define MBI_TO_DBI(gain) ((gain) / 100)
+#define DBM_TO_MBM(gain) ((gain) * 100)
+#define MBM_TO_DBM(gain) ((gain) / 100)
+
 static int isalpha_upper(char letter)
 {
 	if (letter >= 65 && letter <= 90)
@@ -67,3 +74,95 @@ static int handle_reg_set(struct nl_cb *cb,
 }
 COMMAND(reg, set, "<ISO/IEC 3166-1 alpha2>",
 	NL80211_CMD_REQ_SET_REG, 0, CIB_NONE, handle_reg_set);
+
+static int print_reg_handler(struct nl_msg *msg, void *arg)
+
+{
+#define PARSE_FLAG(nl_flag, string_value)  do { \
+		if ((flags & nl_flag)) { \
+			printf(", %s", string_value); \
+		} \
+	} while (0)
+	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	char *alpha2;
+	struct nlattr *nl_rule;
+	int rem_rule;
+	static struct nla_policy reg_rule_policy[NL80211_FREQUENCY_ATTR_MAX + 1] = {
+		[NL80211_ATTR_REG_RULE_FLAGS]           = { .type = NLA_U32 },
+		[NL80211_ATTR_FREQ_RANGE_START]         = { .type = NLA_U32 },
+		[NL80211_ATTR_FREQ_RANGE_END]           = { .type = NLA_U32 },
+		[NL80211_ATTR_FREQ_RANGE_MAX_BW]        = { .type = NLA_U32 },
+		[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]  = { .type = NLA_U32 },
+		[NL80211_ATTR_POWER_RULE_MAX_EIRP]      = { .type = NLA_U32 },
+	};
+
+	nla_parse(tb_msg, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		genlmsg_attrlen(gnlh, 0), NULL);
+
+	if (!tb_msg[NL80211_ATTR_REG_ALPHA2]) {
+		printf("No alpha2\n");
+		return NL_SKIP;
+	}
+
+	if (!tb_msg[NL80211_ATTR_REG_RULES]) {
+		printf("No reg rules\n");
+		return NL_SKIP;
+	}
+
+	alpha2 = nla_data(tb_msg[NL80211_ATTR_REG_ALPHA2]);
+	printf("country %s:\n", alpha2);
+
+	nla_for_each_nested(nl_rule, tb_msg[NL80211_ATTR_REG_RULES], rem_rule) {
+		struct nlattr *tb_rule[NL80211_FREQUENCY_ATTR_MAX + 1];
+		__u32 flags, start_freq_khz, end_freq_khz, max_bw_khz, max_ant_gain_mbi, max_eirp_mbm;
+
+		nla_parse(tb_rule, NL80211_FREQUENCY_ATTR_MAX, nla_data(nl_rule), nla_len(nl_rule), reg_rule_policy);
+
+		flags = nla_get_u32(tb_rule[NL80211_ATTR_REG_RULE_FLAGS]);
+		start_freq_khz = nla_get_u32(tb_rule[NL80211_ATTR_FREQ_RANGE_START]);
+		end_freq_khz = nla_get_u32(tb_rule[NL80211_ATTR_FREQ_RANGE_END]);
+		max_bw_khz = nla_get_u32(tb_rule[NL80211_ATTR_FREQ_RANGE_MAX_BW]);
+		max_ant_gain_mbi = nla_get_u32(tb_rule[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]);
+		max_eirp_mbm = nla_get_u32(tb_rule[NL80211_ATTR_POWER_RULE_MAX_EIRP]);
+
+
+		printf("\t(%d - %d @ %d), (",
+			KHZ_TO_MHZ(start_freq_khz), KHZ_TO_MHZ(end_freq_khz), KHZ_TO_MHZ(max_bw_khz));
+
+		if (MBI_TO_DBI(max_ant_gain_mbi))
+			printf("%d", MBI_TO_DBI(max_ant_gain_mbi));
+		else
+			printf("N/A");
+
+		printf(", %d)", MBM_TO_DBM(max_eirp_mbm));
+
+		if (!flags) {
+			printf("\n");
+			continue;
+		}
+
+		/* Sync this output format to match that of dbparse.py from wireless-regdb.git */
+		PARSE_FLAG(NL80211_RRF_NO_OFDM, "NO-OFDM");
+		PARSE_FLAG(NL80211_RRF_NO_CCK, "NO-CCK");
+		PARSE_FLAG(NL80211_RRF_NO_INDOOR, "NO-INDOOR");
+		PARSE_FLAG(NL80211_RRF_NO_OUTDOOR, "NO-OUTDOOR");
+		PARSE_FLAG(NL80211_RRF_DFS, "DFS");
+		PARSE_FLAG(NL80211_RRF_PTP_ONLY, "PTP-ONLY");
+		PARSE_FLAG(NL80211_RRF_PASSIVE_SCAN, "PASSIVE-SCAN");
+		PARSE_FLAG(NL80211_RRF_NO_IBSS, "NO-IBSS");
+
+		printf("\n");
+	}
+	return NL_OK;
+#undef PARSE_FLAG
+}
+
+static int handle_reg_get(struct nl_cb *cb,
+			  struct nl_msg *msg,
+			  int argc, char **argv)
+{
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_reg_handler, NULL);
+	return 0;
+}
+COMMAND(reg, get, NULL, NL80211_CMD_GET_REG, 0, CIB_NONE, handle_reg_get);
-- 
1.6.1.rc3.51.g5832d

