Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:47843 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751259AbaK1VGN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 16:06:13 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Nov 2014 23:05:56 +0200
Message-Id: <1417208756-14839-4-git-send-email-luca@coelho.fi> (sfid-20141128_220618_580919_33F1916E)
In-Reply-To: <1417208756-14839-1-git-send-email-luca@coelho.fi>
References: <1417208756-14839-1-git-send-email-luca@coelho.fi>
Subject: [PATCH iw v3 3/3] parse net detect wowlan configuration information
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Parse the net detect information when it is reported.  This includes
the scan interval, SSIDs to match and frequencies to scan.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 wowlan.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/wowlan.c b/wowlan.c
index 13a756c..fb7d956 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -523,8 +523,45 @@ static int print_wowlan_handler(struct nl_msg *msg, void *arg)
 		printf(" * wake up on 4-way handshake\n");
 	if (trig[NL80211_WOWLAN_TRIG_RFKILL_RELEASE])
 		printf(" * wake up on RF-kill release\n");
-	if (trig[NL80211_WOWLAN_TRIG_NET_DETECT])
+	if (trig[NL80211_WOWLAN_TRIG_NET_DETECT]) {
+		struct nlattr *match, *freq,
+			*nd[NUM_NL80211_ATTR], *tb[NUM_NL80211_ATTR];
+		int rem_match;
+
 		printf(" * wake up on network detection\n");
+		nla_parse(nd, NUM_NL80211_ATTR,
+			  nla_data(trig[NL80211_WOWLAN_TRIG_NET_DETECT]),
+			  nla_len(trig[NL80211_WOWLAN_TRIG_NET_DETECT]), NULL);
+
+		if (nd[NL80211_ATTR_SCHED_SCAN_INTERVAL])
+			printf("\tscan interval: %d msecs\n",
+			       nla_get_u32(nd[NL80211_ATTR_SCHED_SCAN_INTERVAL]));
+
+		if (nd[NL80211_ATTR_SCHED_SCAN_MATCH]) {
+			printf("\tmatches:\n");
+			nla_for_each_nested(match,
+					    nd[NL80211_ATTR_SCHED_SCAN_MATCH],
+					    rem_match) {
+				nla_parse(tb, NUM_NL80211_ATTR, nla_data(match),
+					  nla_len(match),
+					  NULL);
+				printf("\t\tSSID: ");
+				print_ssid_escaped(
+					nla_len(tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID]),
+					nla_data(tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID]));
+				printf("\n");
+			}
+		}
+		if (nd[NL80211_ATTR_SCAN_FREQUENCIES]) {
+			printf("\tfrequencies:");
+			nla_for_each_nested(freq,
+					    nd[NL80211_ATTR_SCAN_FREQUENCIES],
+					    rem_match) {
+				printf(" %d", nla_get_u32(freq));
+			}
+			printf("\n");
+		}
+	}
 	if (trig[NL80211_WOWLAN_TRIG_PKT_PATTERN]) {
 		nla_for_each_nested(pattern,
 				    trig[NL80211_WOWLAN_TRIG_PKT_PATTERN],
-- 
2.1.3

