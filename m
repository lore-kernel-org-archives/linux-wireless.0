Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:49796 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316Ab3F1Tyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:54:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v5 1/2] iw: use updated structures and enums for packet pattern
Date: Fri, 28 Jun 2013 12:53:44 -0700
Message-ID: <1372449225-10652-1-git-send-email-bzhao@marvell.com> (sfid-20130628_215439_809135_44360D85)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

They are renamed in new nl80211.h so that they can be used for
new feature. This patch uses those updated structures and enums
to make the code look nicer.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
depends on nl80211.h patch:
cfg80211/nl80211: rename packet pattern related structures and enums

v3: use new structure/enum names to make the code look nicer
v5: no change since v3. Resend as v5 series

 info.c   |  2 +-
 wowlan.c | 32 ++++++++++++++++----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/info.c b/info.c
index 54d9a8d..d893ffc 100644
--- a/info.c
+++ b/info.c
@@ -432,7 +432,7 @@ broken_combination:
 			[NL80211_WOWLAN_TRIG_RFKILL_RELEASE] = { .type = NLA_FLAG },
 			[NL80211_WOWLAN_TRIG_TCP_CONNECTION] = { .type = NLA_NESTED },
 		};
-		struct nl80211_wowlan_pattern_support *pat;
+		struct nl80211_pattern_support *pat;
 		int err;
 
 		err = nla_parse_nested(tb_wowlan, MAX_NL80211_WOWLAN_TRIG,
diff --git a/wowlan.c b/wowlan.c
index b4a2715..d323ca7 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -261,11 +261,11 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 			}
 
 			pattern = nla_nest_start(patterns, ++patnum);
-			NLA_PUT(patterns, NL80211_WOWLAN_PKTPAT_MASK,
+			NLA_PUT(patterns, NL80211_PKTPAT_MASK,
 				DIV_ROUND_UP(patlen, 8), mask);
-			NLA_PUT(patterns, NL80211_WOWLAN_PKTPAT_PATTERN,
-				patlen, pat);
-			NLA_PUT_U32(patterns, NL80211_WOWLAN_PKTPAT_OFFSET, pkt_offset);
+			NLA_PUT(patterns, NL80211_PKTPAT_PATTERN, patlen, pat);
+			NLA_PUT_U32(patterns, NL80211_PKTPAT_OFFSET,
+				    pkt_offset);
 			nla_nest_end(patterns, pattern);
 			free(mask);
 			free(pat);
@@ -356,29 +356,29 @@ static int print_wowlan_handler(struct nl_msg *msg, void *arg)
 		nla_for_each_nested(pattern,
 				    trig[NL80211_WOWLAN_TRIG_PKT_PATTERN],
 				    rem_pattern) {
-			struct nlattr *patattr[NUM_NL80211_WOWLAN_PKTPAT];
+			struct nlattr *patattr[NUM_NL80211_PKTPAT];
 			int i, patlen, masklen, pkt_offset;
 			uint8_t *mask, *pat;
-			nla_parse(patattr, MAX_NL80211_WOWLAN_PKTPAT,
-				  nla_data(pattern), nla_len(pattern),
-				  NULL);
-			if (!patattr[NL80211_WOWLAN_PKTPAT_MASK] ||
-			    !patattr[NL80211_WOWLAN_PKTPAT_PATTERN] ||
-			    !patattr[NL80211_WOWLAN_PKTPAT_OFFSET]) {
+			nla_parse(patattr, MAX_NL80211_PKTPAT,
+				  nla_data(pattern), nla_len(pattern), NULL);
+			if (!patattr[NL80211_PKTPAT_MASK] ||
+			    !patattr[NL80211_PKTPAT_PATTERN] ||
+			    !patattr[NL80211_PKTPAT_OFFSET]) {
 				printf(" * (invalid pattern specification)\n");
 				continue;
 			}
-			masklen = nla_len(patattr[NL80211_WOWLAN_PKTPAT_MASK]);
-			patlen = nla_len(patattr[NL80211_WOWLAN_PKTPAT_PATTERN]);
-			pkt_offset = nla_get_u32(patattr[NL80211_WOWLAN_PKTPAT_OFFSET]);
+			masklen = nla_len(patattr[NL80211_PKTPAT_MASK]);
+			patlen = nla_len(patattr[NL80211_PKTPAT_PATTERN]);
+			pkt_offset =
+				nla_get_u32(patattr[NL80211_PKTPAT_OFFSET]);
 			if (DIV_ROUND_UP(patlen, 8) != masklen) {
 				printf(" * (invalid pattern specification)\n");
 				continue;
 			}
 			printf(" * wake up on packet offset: %d", pkt_offset);
 			printf(" pattern: ");
-			pat = nla_data(patattr[NL80211_WOWLAN_PKTPAT_PATTERN]);
-			mask = nla_data(patattr[NL80211_WOWLAN_PKTPAT_MASK]);
+			pat = nla_data(patattr[NL80211_PKTPAT_PATTERN]);
+			mask = nla_data(patattr[NL80211_PKTPAT_MASK]);
 			for (i = 0; i < patlen; i++) {
 				if (mask[i / 8] & (1 << (i % 8)))
 					printf("%.2x", pat[i]);
-- 
1.8.0

