Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:48243 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759190Ab3EWVfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 17:35:47 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 2/2] iw: add coalesce support
Date: Thu, 23 May 2013 14:35:41 -0700
Message-ID: <1369344941-11217-2-git-send-email-bzhao@marvell.com> (sfid-20130523_233551_540629_5C611EBA)
In-Reply-To: <1369344941-11217-1-git-send-email-bzhao@marvell.com>
References: <1369344941-11217-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

User can add one coalesce rule at a time using 'iw coalesce add'
command. The settings can be cleared using 'iw coalesce disable'
command. 'iw coalesce show' displays current configuration.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 Makefile   |   2 +-
 coalesce.c | 232 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 info.c     |  14 ++++
 3 files changed, 247 insertions(+), 1 deletion(-)
 create mode 100644 coalesce.c

diff --git a/Makefile b/Makefile
index c485b5e..f042e30 100644
--- a/Makefile
+++ b/Makefile
@@ -16,7 +16,7 @@ OBJS = iw.o genl.o event.o info.o phy.o \
 	interface.o ibss.o station.o survey.o util.o \
 	mesh.o mpath.o scan.o reg.o version.o \
 	reason.o status.o connect.o link.o offch.o ps.o cqm.o \
-	bitrate.o wowlan.o roc.o p2p.o
+	bitrate.o wowlan.o coalesce.o roc.o p2p.o
 OBJS += sections.o
 
 OBJS-$(HWSIM) += hwsim.o
diff --git a/coalesce.c b/coalesce.c
new file mode 100644
index 0000000..73f5d77
--- /dev/null
+++ b/coalesce.c
@@ -0,0 +1,232 @@
+#include <net/if.h>
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+
+#include <netlink/genl/genl.h>
+#include <netlink/genl/family.h>
+#include <netlink/genl/ctrl.h>
+#include <netlink/msg.h>
+#include <netlink/attr.h>
+
+#include <arpa/inet.h>
+
+#include "nl80211.h"
+#include "iw.h"
+
+SECTION(coalesce);
+
+static int handle_coalesce_add(struct nl80211_state *state, struct nl_cb *cb,
+			       struct nl_msg *msg, int argc, char **argv,
+			       enum id_input id)
+{
+	struct nlattr *coalesce, *pattern;
+	struct nl_msg *patterns = NULL;
+	enum {
+		PS_REG,
+		PS_PAT,
+	} parse_state = PS_REG;
+	int err = -ENOBUFS;
+	unsigned char *pat, *mask;
+	size_t patlen;
+	int patnum = 0, pkt_offset;
+	char *eptr, *value1, *value2, *sptr = NULL, *end;
+	unsigned int condition;
+
+	coalesce = nla_nest_start(msg, NL80211_ATTR_COALESCE_RULE);
+	if (!coalesce)
+		return -ENOBUFS;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_COALESCE_RULE_DELAY,
+		    strtoul(argv[0], &end, 10));
+	if (*end != '\0')
+		return 1;
+
+	argv++;
+	argc--;
+
+	condition = strtoul(argv[0], &end, 10);
+
+	if (condition != 1 && condition != 0)
+		return 1;
+
+	if (*end)
+		return 1;
+
+	NLA_PUT_U8(msg, NL80211_ATTR_COALESCE_RULE_CONDITION, condition);
+
+	argv++;
+	argc--;
+
+	while (argc) {
+		switch (parse_state) {
+		case PS_REG:
+			if (strcmp(argv[0], "patterns") == 0) {
+				parse_state = PS_PAT;
+				patterns = nlmsg_alloc();
+				if (!patterns) {
+					err = -ENOMEM;
+					goto nla_put_failure;
+				}
+			} else {
+				err = 1;
+				goto nla_put_failure;
+			}
+			break;
+		case PS_PAT:
+			value1 = strtok_r(argv[0], "+", &sptr);
+			value2 = strtok_r(NULL, "+", &sptr);
+
+			if (!value2) {
+				pkt_offset = 0;
+				value2 = value1;
+			} else {
+				pkt_offset = strtoul(value1, &eptr, 10);
+				if (eptr != value1 + strlen(value1)) {
+					err = 1;
+					goto nla_put_failure;
+				}
+			}
+
+			if (parse_hex_mask(value2, &pat, &patlen, &mask)) {
+				err = 1;
+				goto nla_put_failure;
+			}
+
+			pattern = nla_nest_start(patterns, ++patnum);
+			NLA_PUT(patterns, NL80211_PKTPAT_MASK,
+				DIV_ROUND_UP(patlen, 8), mask);
+			NLA_PUT(patterns, NL80211_PKTPAT_PATTERN, patlen, pat);
+			NLA_PUT_U32(patterns, NL80211_PKTPAT_OFFSET,
+				    pkt_offset);
+			nla_nest_end(patterns, pattern);
+			free(mask);
+			free(pat);
+			break;
+		}
+		argv++;
+		argc--;
+	}
+
+	if (patterns)
+		nla_put_nested(msg, NL80211_ATTR_COALESCE_RULE_PKT_PATTERN,
+			       patterns);
+
+	nla_nest_end(msg, coalesce);
+	err = 0;
+ nla_put_failure:
+	nlmsg_free(patterns);
+	return err;
+}
+COMMAND(coalesce, add, "<delay> <0|1> patterns [offset1+]<pattern1> ...]",
+	NL80211_CMD_SET_COALESCE, 0, CIB_PHY, handle_coalesce_add,
+	"Add coalesce rule.\n"
+	"Maximum coalescing delay in msec.\n"
+	"Condition is 0/1 i.e. 'not match'/'match' the patterns\n"
+	"Each pattern is given as a bytestring with '-' in places where any byte\n"
+	"may be present, e.g. 00:11:22:-:44 will match 00:11:22:33:44 and\n"
+	"00:11:22:33:ff:44 etc.\n"
+	"Offset and pattern should be separated by '+', e.g. 18+43:34:00:12 will\n"
+	"match '43:34:00:12' after 18 bytes of offset in Rx packet.\n");
+
+static int
+handle_coalesce_disable(struct nl80211_state *state, struct nl_cb *cb,
+			struct nl_msg *msg, int argc, char **argv,
+			enum id_input id)
+{
+	/* just a set w/o coalesce attribute */
+	return 0;
+}
+COMMAND(coalesce, disable, "", NL80211_CMD_SET_COALESCE, 0, CIB_PHY,
+	handle_coalesce_disable, "Disable coalesce.");
+
+static int print_coalesce_handler(struct nl_msg *msg, void *arg)
+{
+	struct nlattr *attrs[NL80211_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	struct nlattr *pattern, *rule;
+	int rem_pattern, rem_rule;
+	bool condition;
+	int delay;
+
+	nla_parse(attrs, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+
+	if (!attrs[NL80211_ATTR_COALESCE_RULE]) {
+		printf("Coalesce is disabled.\n");
+		return NL_SKIP;
+	}
+
+	printf("Coalesce is enabled:\n");
+
+	nla_for_each_nested(rule, attrs[NL80211_ATTR_COALESCE_RULE], rem_rule) {
+		struct nlattr *ruleattr[NUM_NL80211_ATTR_COALESCE_RULE];
+
+		nla_parse(ruleattr, NL80211_ATTR_COALESCE_RULE_MAX,
+			  nla_data(rule), nla_len(rule), NULL);
+
+		delay = nla_get_u32(ruleattr[NL80211_ATTR_COALESCE_RULE_DELAY]);
+		condition =
+		     nla_get_u8(ruleattr[NL80211_ATTR_COALESCE_RULE_CONDITION]);
+
+		printf("Rule - max coalescing delay: %dmsec condition:", delay);
+		if (condition)
+			printf("match\n");
+		else
+			printf("not match\n");
+
+		if (ruleattr[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN]) {
+			nla_for_each_nested(pattern,
+					ruleattr[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN],
+					rem_pattern) {
+				struct nlattr *patattr[NUM_NL80211_PKTPAT];
+				int i, patlen, masklen, pkt_offset;
+				uint8_t *mask, *pat;
+
+				nla_parse(patattr, MAX_NL80211_PKTPAT,
+					  nla_data(pattern), nla_len(pattern),
+					  NULL);
+				if (!patattr[NL80211_PKTPAT_MASK] ||
+				    !patattr[NL80211_PKTPAT_PATTERN] ||
+				    !patattr[NL80211_PKTPAT_OFFSET]) {
+					printf(" * (invalid pattern specification)\n");
+					continue;
+				}
+				masklen = nla_len(patattr[NL80211_PKTPAT_MASK]);
+				patlen = nla_len(patattr[NL80211_PKTPAT_PATTERN]);
+				pkt_offset = nla_get_u32(patattr[NL80211_PKTPAT_OFFSET]);
+				if (DIV_ROUND_UP(patlen, 8) != masklen) {
+					printf(" * (invalid pattern specification)\n");
+					continue;
+				}
+				printf(" * packet offset: %d", pkt_offset);
+				printf(" pattern: ");
+				pat = nla_data(patattr[NL80211_PKTPAT_PATTERN]);
+				mask = nla_data(patattr[NL80211_PKTPAT_MASK]);
+				for (i = 0; i < patlen; i++) {
+					if (mask[i / 8] & (1 << (i % 8)))
+						printf("%.2x", pat[i]);
+					else
+						printf("--");
+					if (i != patlen - 1)
+						printf(":");
+				}
+				printf("\n");
+			}
+		}
+	}
+
+	return NL_SKIP;
+}
+
+static int handle_coalesce_show(struct nl80211_state *state, struct nl_cb *cb,
+			      struct nl_msg *msg, int argc, char **argv,
+			      enum id_input id)
+{
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM,
+		  print_coalesce_handler, NULL);
+
+	return 0;
+}
+COMMAND(coalesce, show, "", NL80211_CMD_GET_COALESCE, 0, CIB_PHY, handle_coalesce_show,
+	"Show coalesce status.");
diff --git a/info.c b/info.c
index d893ffc..849da67 100644
--- a/info.c
+++ b/info.c
@@ -528,6 +528,20 @@ broken_combination:
 			printf("\tDevice supports AP scan.\n");
 	}
 
+	if (tb_msg[NL80211_ATTR_COALESCE_RULE]) {
+		struct nl80211_coalesce_rule_support *rule;
+		struct nl80211_pattern_support *pat;
+
+		printf("\tCoalesce support:\n");
+		rule = nla_data(tb_msg[NL80211_ATTR_COALESCE_RULE]);
+		pat = &rule->pat;
+		printf("\t\t * Maximum %u coalesce rules supported\n"
+		       "\t\t * Each rule contains upto %u patterns of %u-%u bytes,\n"
+		       "\t\t   maximum packet offset %u bytes\n",
+			rule->max_rules, pat->max_patterns, pat->min_pattern_len,
+			pat->max_pattern_len, pat->max_pkt_offset);
+	}
+
 	return NL_SKIP;
 }
 
-- 
1.8.0

