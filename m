Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:57214 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982Ab3BLU0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 15:26:47 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] iw: add packet offset information for wowlan pattern
Date: Tue, 12 Feb 2013 12:16:27 -0800
Message-Id: <1360700187-22806-2-git-send-email-bzhao@marvell.com> (sfid-20130212_212650_979542_93165272)
In-Reply-To: <1360700187-22806-1-git-send-email-bzhao@marvell.com>
References: <1360700187-22806-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Now user can provide packet offset along with the pattern in
"iw wowlan" command. Default offset will be 0 when it is not
provided.

A trailing ':' should be used for single byte pattern to
distinguish it from an offset.
Ex. "iw phy phy# wowlan patterns 18 43:" means wakeup on
offset 18 pattern 0x43.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: display maximum permissible packet offset as well for
    WOWLAN patterns

 info.c   |  5 +++--
 util.c   |  2 ++
 wowlan.c | 30 +++++++++++++++++++++++-------
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/info.c b/info.c
index 08dbfc0..891ab0d 100644
--- a/info.c
+++ b/info.c
@@ -382,8 +382,9 @@ broken_combination:
 				printf("\t\t * wake up on magic packet\n");
 			if (tb_wowlan[NL80211_WOWLAN_TRIG_PKT_PATTERN]) {
 				pat = nla_data(tb_wowlan[NL80211_WOWLAN_TRIG_PKT_PATTERN]);
-				printf("\t\t * wake up on pattern match, up to %u patterns of %u-%u bytes\n",
-					pat->max_patterns, pat->min_pattern_len, pat->max_pattern_len);
+				printf("\t\t * wake up on pattern match, up to %u patterns of %u-%u bytes,\n"
+					"\t\t   maximum packet offset %u bytes\n",
+					pat->max_patterns, pat->min_pattern_len, pat->max_pattern_len, pat->max_pkt_offset);
 			}
 			if (tb_wowlan[NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED])
 				printf("\t\t * can do GTK rekeying\n");
diff --git a/util.c b/util.c
index c272c1d..6ef86cd 100644
--- a/util.c
+++ b/util.c
@@ -75,6 +75,8 @@ int parse_hex_mask(char *hexmask, unsigned char **result, size_t *result_len,
 		if (cp) {
 			*cp = 0;
 			cp++;
+		} else if (!strlen(hexmask)) {
+			break;
 		}
 
 		if (result_mask && (strcmp(hexmask, "-") == 0 ||
diff --git a/wowlan.c b/wowlan.c
index 6d324ef..a314c7d 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -26,7 +26,8 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 	int err = -ENOBUFS;
 	unsigned char *pat, *mask;
 	size_t patlen;
-	int patnum = 0;
+	int patnum = 0, pkt_offset;
+	char *eptr;
 
 	wowlan = nla_nest_start(msg, NL80211_ATTR_WOWLAN_TRIGGERS);
 	if (!wowlan)
@@ -62,7 +63,16 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 			}
 			break;
 		case PS_PAT:
-			if (parse_hex_mask(argv[0], &pat, &patlen, &mask)) {
+			pkt_offset = strtoul(argv[0], &eptr, 10);
+			if (eptr != argv[0] + strlen(argv[0])) {
+				/* packet offset is not provided, set default value to 0 */
+				pkt_offset = 0;
+			} else {
+				argv++;
+				argc--;
+			}
+
+			if (!argc || parse_hex_mask(argv[0], &pat, &patlen, &mask)) {
 				err = 1;
 				goto nla_put_failure;
 			}
@@ -71,6 +81,7 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 				DIV_ROUND_UP(patlen, 8), mask);
 			NLA_PUT(patterns, NL80211_WOWLAN_PKTPAT_PATTERN,
 				patlen, pat);
+			NLA_PUT_U32(patterns, NL80211_WOWLAN_PKTPAT_OFFSET, pkt_offset);
 			nla_nest_end(patterns, pattern);
 			free(mask);
 			free(pat);
@@ -91,12 +102,14 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 	return err;
 }
 COMMAND(wowlan, enable, "[any] [disconnect] [magic-packet] [gtk-rekey-failure] [eap-identity-request]"
-	" [4way-handshake] [rfkill-release] [patterns <pattern>*]",
+	" [4way-handshake] [rfkill-release] [patterns [offset1] <pattern1> ...]",
 	NL80211_CMD_SET_WOWLAN, 0, CIB_PHY, handle_wowlan_enable,
 	"Enable WoWLAN with the given triggers.\n"
 	"Each pattern is given as a bytestring with '-' in places where any byte\n"
 	"may be present, e.g. 00:11:22:-:44 will match 00:11:22:33:44 and\n"
-	"00:11:22:33:ff:44 etc.");
+	"00:11:22:33:ff:44 etc.\n"
+	"Use ':' for single byte pattern as well, e.g. 18 43: will match '43' "
+	"after 18 bytes of offset in Rx packet.");
 
 
 static int handle_wowlan_disable(struct nl80211_state *state, struct nl_cb *cb,
@@ -152,23 +165,26 @@ static int print_wowlan_handler(struct nl_msg *msg, void *arg)
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

