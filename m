Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:41326 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751694AbbCMMRV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 08:17:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri, 13 Mar 2015 14:17:07 +0200
Message-Id: <1426249027-22165-3-git-send-email-luca@coelho.fi> (sfid-20150313_131728_129333_3833C378)
In-Reply-To: <1426249027-22165-1-git-send-email-luca@coelho.fi>
References: <1426249027-22165-1-git-send-email-luca@coelho.fi>
Subject: [PATCH iw 2/2] iw: add a delay option to net-detect
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add an option that allows the initial net-detect scan to be delayed by
the specified number of seconds.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 wowlan.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/wowlan.c b/wowlan.c
index fb7d956..12abc76 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -193,7 +193,7 @@ static int wowlan_parse_net_detect(struct nl_msg *msg, int *argc, char ***argv)
 	int c  = *argc;
 	char *end, **v = *argv;
 	int err = 0, i = 0;
-	unsigned int freq, interval = 0;
+	unsigned int freq, interval = 0, delay = 0;
 	bool have_matchset = false, have_freqs = false;
 
 	nd = nla_nest_start(msg, NL80211_WOWLAN_TRIG_NET_DETECT);
@@ -236,6 +236,25 @@ static int wowlan_parse_net_detect(struct nl_msg *msg, int *argc, char ***argv)
 				NLA_PUT_U32(msg,
 					    NL80211_ATTR_SCHED_SCAN_INTERVAL,
 					    interval);
+			} else if (!strcmp(v[0], "delay")) {
+				c--; v++;
+				if (c == 0) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+
+				if (delay) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+				delay = strtoul(v[0], &end, 10);
+				if (*end) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+				NLA_PUT_U32(msg,
+					    NL80211_ATTR_SCHED_SCAN_DELAY,
+					    delay);
 			} else if (!strcmp(v[0], "matches")) {
 				parse_state = ND_MATCH;
 				if (have_matchset) {
@@ -454,7 +473,7 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 	return err;
 }
 COMMAND(wowlan, enable, "[any] [disconnect] [magic-packet] [gtk-rekey-failure] [eap-identity-request]"
-	" [4way-handshake] [rfkill-release] [net-detect interval <in_msecs> [freqs <freq>+] [matches [ssid <ssid>]+]]"
+	" [4way-handshake] [rfkill-release] [net-detect interval <in_msecs> [delay <in_secs> [freqs <freq>+] [matches [ssid <ssid>]+]]"
 	" [tcp <config-file>] [patterns [offset1+]<pattern1> ...]",
 	NL80211_CMD_SET_WOWLAN, 0, CIB_PHY, handle_wowlan_enable,
 	"Enable WoWLAN with the given triggers.\n"
@@ -472,7 +491,7 @@ COMMAND(wowlan, enable, "[any] [disconnect] [magic-packet] [gtk-rekey-failure] [
 	"  [data.seq=len,offset[,start]]\n"
 	"  [data.tok=len,offset,<token stream>]\n\n"
 	"Net-detect configuration example:\n"
-	" iw phy0 wowlan enable net-detect interval 5000 freqs 2412 2422 matches ssid foo ssid bar");
+	" iw phy0 wowlan enable net-detect interval 5000 delay 30 freqs 2412 2422 matches ssid foo ssid bar");
 
 
 static int handle_wowlan_disable(struct nl80211_state *state, struct nl_cb *cb,
@@ -534,9 +553,13 @@ static int print_wowlan_handler(struct nl_msg *msg, void *arg)
 			  nla_len(trig[NL80211_WOWLAN_TRIG_NET_DETECT]), NULL);
 
 		if (nd[NL80211_ATTR_SCHED_SCAN_INTERVAL])
-			printf("\tscan interval: %d msecs\n",
+			printf("\tscan interval: %u msecs\n",
 			       nla_get_u32(nd[NL80211_ATTR_SCHED_SCAN_INTERVAL]));
 
+		if (nd[NL80211_ATTR_SCHED_SCAN_DELAY])
+			printf("\tintial scan delay: %u secs\n",
+			       nla_get_u32(nd[NL80211_ATTR_SCHED_SCAN_DELAY]));
+
 		if (nd[NL80211_ATTR_SCHED_SCAN_MATCH]) {
 			printf("\tmatches:\n");
 			nla_for_each_nested(match,
-- 
2.1.4

