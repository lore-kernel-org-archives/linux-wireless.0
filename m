Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58235 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932691Ab3BTAo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 19:44:57 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3] iw: add packet offset information for wowlan pattern
Date: Tue, 19 Feb 2013 16:44:44 -0800
Message-Id: <1361321084-11325-1-git-send-email-bzhao@marvell.com> (sfid-20130220_014502_484286_92FBE140)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Now user can provide packet offset along with the pattern in
"iw wowlan" command. Default offset will be 0 when it is not
provided.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v3: check struct size to avoid crash on old kernels; and use
    '+' delimiter between offset and pattern. (Johannes Berg)
v2: display maximum permissible packet offset as well for
    WOWLAN patterns

 info.c   | 11 ++++++-----
 wowlan.c | 36 +++++++++++++++++++++++++++++-------
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/info.c b/info.c
index 4cdbda7..a1018a2 100644
--- a/info.c
+++ b/info.c
@@ -400,9 +400,7 @@ broken_combination:
 			[NL80211_WOWLAN_TRIG_ANY] = { .type = NLA_FLAG },
 			[NL80211_WOWLAN_TRIG_DISCONNECT] = { .type = NLA_FLAG },
 			[NL80211_WOWLAN_TRIG_MAGIC_PKT] = { .type = NLA_FLAG },
-			[NL80211_WOWLAN_TRIG_PKT_PATTERN] = {
-				.minlen = sizeof(struct nl80211_wowlan_pattern_support),
-			},
+			[NL80211_WOWLAN_TRIG_PKT_PATTERN] = { .type = NLA_NESTED },
 			[NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED] = { .type = NLA_FLAG },
 			[NL80211_WOWLAN_TRIG_GTK_REKEY_FAILURE] = { .type = NLA_FLAG },
 			[NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST] = { .type = NLA_FLAG },
@@ -429,8 +427,11 @@ broken_combination:
 				printf("\t\t * wake up on magic packet\n");
 			if (tb_wowlan[NL80211_WOWLAN_TRIG_PKT_PATTERN]) {
 				pat = nla_data(tb_wowlan[NL80211_WOWLAN_TRIG_PKT_PATTERN]);
-				printf("\t\t * wake up on pattern match, up to %u patterns of %u-%u bytes\n",
-					pat->max_patterns, pat->min_pattern_len, pat->max_pattern_len);
+				printf("\t\t * wake up on pattern match, up to %u patterns of %u-%u bytes,\n"
+					"\t\t   maximum packet offset %u bytes\n",
+					pat->max_patterns, pat->min_pattern_len, pat->max_pattern_len,
+					(nla_len(tb_wowlan[NL80211_WOWLAN_TRIG_PKT_PATTERN]) <
+					sizeof(*pat)) ? 0 : pat->max_pkt_offset);
 			}
 			if (tb_wowlan[NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED])
 				printf("\t\t * can do GTK rekeying\n");
diff --git a/wowlan.c b/wowlan.c
index 0093a87..4be43d9 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -194,7 +194,8 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 	int err = -ENOBUFS;
 	unsigned char *pat, *mask;
 	size_t patlen;
-	int patnum = 0;
+	int patnum = 0, pkt_offset;
+	char *eptr, *value1, *value2, *sptr = NULL;
 
 	wowlan = nla_nest_start(msg, NL80211_ATTR_WOWLAN_TRIGGERS);
 	if (!wowlan)
@@ -240,15 +241,31 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 			}
 			break;
 		case PS_PAT:
-			if (parse_hex_mask(argv[0], &pat, &patlen, &mask)) {
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
 				err = 1;
 				goto nla_put_failure;
 			}
+
 			pattern = nla_nest_start(patterns, ++patnum);
 			NLA_PUT(patterns, NL80211_WOWLAN_PKTPAT_MASK,
 				DIV_ROUND_UP(patlen, 8), mask);
 			NLA_PUT(patterns, NL80211_WOWLAN_PKTPAT_PATTERN,
 				patlen, pat);
+			NLA_PUT_U32(patterns, NL80211_WOWLAN_PKTPAT_OFFSET, pkt_offset);
 			nla_nest_end(patterns, pattern);
 			free(mask);
 			free(pat);
@@ -269,12 +286,14 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 	return err;
 }
 COMMAND(wowlan, enable, "[any] [disconnect] [magic-packet] [gtk-rekey-failure] [eap-identity-request]"
-	" [4way-handshake] [rfkill-release] [tcp <config-file>] [patterns <pattern>*]",
+	" [4way-handshake] [rfkill-release] [tcp <config-file>] [patterns [offset1+]<pattern1> ...]",
 	NL80211_CMD_SET_WOWLAN, 0, CIB_PHY, handle_wowlan_enable,
 	"Enable WoWLAN with the given triggers.\n"
 	"Each pattern is given as a bytestring with '-' in places where any byte\n"
 	"may be present, e.g. 00:11:22:-:44 will match 00:11:22:33:44 and\n"
-	"00:11:22:33:ff:44 etc.\n\n"
+	"00:11:22:33:ff:44 etc.\n"
+	"Offset and pattern should be separated by '+', e.g. 18+43:34:00:12 will match "
+	"'43:34:00:12' after 18 bytes of offset in Rx packet.\n\n"
 	"The TCP configuration file contains:\n"
 	"  source=ip[:port]\n"
 	"  dest=ip:port@mac\n"
@@ -338,23 +357,26 @@ static int print_wowlan_handler(struct nl_msg *msg, void *arg)
 				    trig[NL80211_WOWLAN_TRIG_PKT_PATTERN],
 				    rem_pattern) {
 			struct nlattr *patattr[NUM_NL80211_WOWLAN_PKTPAT];
-			int i, patlen, masklen;
+			int i, patlen, masklen, pkt_offset;
 			uint8_t *mask, *pat;
 			nla_parse(patattr, MAX_NL80211_WOWLAN_PKTPAT,
 				  nla_data(pattern), nla_len(pattern),
 				  NULL);
 			if (!patattr[NL80211_WOWLAN_PKTPAT_MASK] ||
-			    !patattr[NL80211_WOWLAN_PKTPAT_PATTERN]) {
+			    !patattr[NL80211_WOWLAN_PKTPAT_PATTERN] ||
+			    !patattr[NL80211_WOWLAN_PKTPAT_OFFSET]) {
 				printf(" * (invalid pattern specification)\n");
 				continue;
 			}
 			masklen = nla_len(patattr[NL80211_WOWLAN_PKTPAT_MASK]);
 			patlen = nla_len(patattr[NL80211_WOWLAN_PKTPAT_PATTERN]);
+			pkt_offset = nla_get_u32(patattr[NL80211_WOWLAN_PKTPAT_OFFSET]);
 			if (DIV_ROUND_UP(patlen, 8) != masklen) {
 				printf(" * (invalid pattern specification)\n");
 				continue;
 			}
-			printf(" * wake up on pattern: ");
+			printf(" * wake up on packet offset: %d", pkt_offset);
+			printf(" pattern: ");
 			pat = nla_data(patattr[NL80211_WOWLAN_PKTPAT_PATTERN]);
 			mask = nla_data(patattr[NL80211_WOWLAN_PKTPAT_MASK]);
 			for (i = 0; i < patlen; i++) {
-- 
1.8.0

