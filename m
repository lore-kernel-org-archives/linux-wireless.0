Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:49945 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316Ab3F1Tx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:53:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v5 2/2] iw: add coalesce support
Date: Fri, 28 Jun 2013 12:53:45 -0700
Message-ID: <1372449225-10652-2-git-send-email-bzhao@marvell.com> (sfid-20130628_215403_289457_F5C85B29)
In-Reply-To: <1372449225-10652-1-git-send-email-bzhao@marvell.com>
References: <1372449225-10652-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

User can configure multiple coalesce rules using 'iw coalesce
enable <config-file>' command. The setting can be cleared using
'iw coalesce disable' command. 'iw coalesce show' displays current
configuration.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
depends on nl80211.h patch:
cfg80211/nl80211: Add packet coalesce support

v3: match cfg80211/nl80211 structures v3 patchset
v5: match cfg80211/nl80211 structures v5 patchset
    provide coalesce configurations through file
    

 Makefile   |   2 +-
 coalesce.c | 285 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 info.c     |  15 ++++
 3 files changed, 301 insertions(+), 1 deletion(-)
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
index 0000000..22d1534
--- /dev/null
+++ b/coalesce.c
@@ -0,0 +1,285 @@
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
+static int handle_coalesce_enable(struct nl80211_state *state, struct nl_cb *cb,
+				  struct nl_msg *msg, int argc, char **argv,
+				  enum id_input id)
+{
+	struct nlattr *nl_rules, *nl_rule = NULL, *nl_pats, *nl_pat;
+	unsigned char *pat, *mask;
+	size_t patlen;
+	int patnum = 0, pkt_offset, err = 1;
+	char *eptr, *value1, *value2, *sptr = NULL, *end, buf[16768];
+	enum nl80211_coalesce_condition condition;
+	FILE *f = fopen(argv[0], "r");
+	enum {
+		PS_DELAY,
+		PS_CONDITION,
+		PS_PATTERNS
+	} parse_state = PS_DELAY;
+	int rule_num = 0;
+
+	if (!f)
+		return 1;
+
+	nl_rules = nla_nest_start(msg, NL80211_ATTR_COALESCE_RULE);
+	if (!nl_rules)
+		return -ENOBUFS;
+
+	while (!feof(f)) {
+		char *eol;
+
+		if (!fgets(buf, sizeof(buf), f))
+			break;
+
+		eol = strchr(buf + 5, '\r');
+		if (eol)
+			*eol = 0;
+		eol = strchr(buf + 5, '\n');
+		if (eol)
+			*eol = 0;
+
+		switch (parse_state) {
+		case PS_DELAY:
+			if (strncmp(buf, "delay=", 6) == 0) {
+				char *delay = buf + 6;
+
+				rule_num++;
+				nl_rule = nla_nest_start(msg, rule_num);
+				if (!nl_rule)
+					goto close;
+
+				NLA_PUT_U32(msg, NL80211_ATTR_COALESCE_RULE_DELAY,
+					    strtoul(delay, &end, 10));
+				if (*end != '\0')
+					goto close;
+				parse_state = PS_CONDITION;
+			} else {
+				goto close;
+			}
+			break;
+		case PS_CONDITION:
+			if (strncmp(buf, "condition=", 10) == 0) {
+				char *cond = buf + 10;
+
+				condition = strtoul(cond, &end, 10);
+				if (*end != '\0')
+					goto close;
+				NLA_PUT_U32(msg, NL80211_ATTR_COALESCE_RULE_CONDITION,
+					    condition);
+				parse_state = PS_PATTERNS;
+			} else {
+				goto close;
+			}
+			break;
+		case PS_PATTERNS:
+			if (strncmp(buf, "patterns=", 9) == 0) {
+				char *cur_pat = buf + 9;
+				char *next_pat = strchr(buf + 9, ',');
+
+				if (next_pat) {
+					*next_pat = 0;
+					next_pat++;
+				}
+
+				nl_pats = nla_nest_start(msg, NL80211_ATTR_COALESCE_RULE_PKT_PATTERN);
+				while (1) {
+					value1 = strtok_r(cur_pat, "+", &sptr);
+					value2 = strtok_r(NULL, "+", &sptr);
+
+					if (!value2) {
+						pkt_offset = 0;
+						if (!value1)
+							goto close;
+						value2 = value1;
+					} else {
+						pkt_offset = strtoul(value1, &eptr, 10);
+						if (eptr != value1 + strlen(value1))
+							goto close;
+					}
+
+					if (parse_hex_mask(value2, &pat, &patlen, &mask))
+						goto close;
+
+					nl_pat = nla_nest_start(msg, ++patnum);
+					NLA_PUT(msg, NL80211_PKTPAT_MASK,
+						DIV_ROUND_UP(patlen, 8), mask);
+					NLA_PUT(msg, NL80211_PKTPAT_PATTERN, patlen, pat);
+					NLA_PUT_U32(msg, NL80211_PKTPAT_OFFSET,
+						    pkt_offset);
+					nla_nest_end(msg, nl_pat);
+					free(mask);
+					free(pat);
+
+					if (!next_pat)
+						break;
+					cur_pat = next_pat;
+					next_pat = strchr(cur_pat, ',');
+					if (next_pat) {
+						*next_pat = 0;
+						next_pat++;
+					}
+				}
+				nla_nest_end(msg, nl_pats);
+				nla_nest_end(msg, nl_rule);
+				parse_state = PS_DELAY;
+
+			} else {
+				goto close;
+			}
+			break;
+		default:
+			if (buf[0] == '#')
+				continue;
+			goto close;
+		}
+	}
+
+	if (parse_state == PS_DELAY)
+		err = 0;
+	else
+		err = 1;
+	goto close;
+nla_put_failure:
+	err = -ENOBUFS;
+close:
+	fclose(f);
+	nla_nest_end(msg, nl_rules);
+	return err;
+}
+
+COMMAND(coalesce, enable, "<config-file>",
+	NL80211_CMD_SET_COALESCE, 0, CIB_PHY, handle_coalesce_enable,
+	"Enable coalesce with given configuration.\n"
+	"The configuration file contains coalesce rules:\n"
+	"  delay=<delay>\n"
+	"  condition=<condition>\n"
+	"  patterns=<[offset1+]<pattern1>,<[offset2+]<pattern2>,...>\n"
+	"  delay=<delay>\n"
+	"  condition=<condition>\n"
+	"  patterns=<[offset1+]<pattern1>,<[offset2+]<pattern2>,...>\n"
+	"  ...\n"
+	"delay: maximum coalescing delay in msec.\n"
+	"condition: 0/1 i.e. 'not match'/'match' the patterns\n"
+	"patterns: each pattern is given as a bytestring with '-' in\n"
+	"places where any byte may be present, e.g. 00:11:22:-:44 will\n"
+	"match 00:11:22:33:44 and 00:11:22:33:ff:44 etc. Offset and\n"
+	"pattern should be separated by '+', e.g. 18+43:34:00:12 will\n"
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
+	enum nl80211_coalesce_condition condition;
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
+		     nla_get_u32(ruleattr[NL80211_ATTR_COALESCE_RULE_CONDITION]);
+
+		printf("Rule - max coalescing delay: %dmsec condition:", delay);
+		if (condition)
+			printf("match\n");
+		else
+			printf("not match\n");
+
+		if (ruleattr[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN]) {
+			nla_for_each_nested(pattern,
+					    ruleattr[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN],
+					    rem_pattern) {
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
index d893ffc..7e61e88 100644
--- a/info.c
+++ b/info.c
@@ -528,6 +528,21 @@ broken_combination:
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
+		       "\t\t   maximum packet offset %u bytes\n"
+		       "\t\t * Maximum supported coalescing delay %u msecs\n",
+			rule->max_rules, pat->max_patterns, pat->min_pattern_len,
+			pat->max_pattern_len, pat->max_pkt_offset, rule->max_delay);
+	}
+
 	return NL_SKIP;
 }
 
-- 
1.8.0

