Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:47840 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751117AbaK1VGN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 16:06:13 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Nov 2014 23:05:55 +0200
Message-Id: <1417208756-14839-3-git-send-email-luca@coelho.fi> (sfid-20141128_220619_202194_BA6567CA)
In-Reply-To: <1417208756-14839-1-git-send-email-luca@coelho.fi>
References: <1417208756-14839-1-git-send-email-luca@coelho.fi>
Subject: [PATCH iw v3 2/3] add WoWLAN net-detect trigger
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Adds a netdetect option to the wowlan triggers that allows the user to
request network detection to be started when the device goes to
suspend mode.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 event.c  |  28 +++++++++-
 info.c   |   3 ++
 wowlan.c | 177 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 205 insertions(+), 3 deletions(-)

diff --git a/event.c b/event.c
index 25f8099..c175c66 100644
--- a/event.c
+++ b/event.c
@@ -200,7 +200,8 @@ static void parse_mic_failure(struct nlattr **attrs)
 
 static void parse_wowlan_wake_event(struct nlattr **attrs)
 {
-	struct nlattr *tb[NUM_NL80211_WOWLAN_TRIG];
+	struct nlattr *tb[NUM_NL80211_WOWLAN_TRIG],
+		*tb_match[NUM_NL80211_ATTR];
 
 	printf("WoWLAN wakeup\n");
 	if (!attrs[NL80211_ATTR_WOWLAN_TRIGGERS]) {
@@ -227,6 +228,31 @@ static void parse_wowlan_wake_event(struct nlattr **attrs)
 		printf("\t* 4-way handshake\n");
 	if (tb[NL80211_WOWLAN_TRIG_RFKILL_RELEASE])
 		printf("\t* RF-kill released\n");
+	if (tb[NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS]) {
+		struct nlattr *match, *freq;
+		int rem_nst, rem_nst2;
+
+		printf("\t* network detected\n");
+		nla_for_each_nested(match,
+				    tb[NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS],
+				    rem_nst) {
+			nla_parse(tb_match, NUM_NL80211_ATTR, nla_data(match),
+				  nla_len(match),
+				  NULL);
+			printf("\t\tSSID: \"");
+			print_ssid_escaped(nla_len(tb_match[NL80211_ATTR_SSID]),
+					   nla_data(tb_match[NL80211_ATTR_SSID]));
+			printf("\"");
+			if (tb_match[NL80211_ATTR_SCAN_FREQUENCIES]) {
+				printf(" freq(s):");
+				nla_for_each_nested(freq,
+						    tb_match[NL80211_ATTR_SCAN_FREQUENCIES],
+						    rem_nst2)
+					printf(" %d", nla_get_u32(freq));
+			}
+			printf("\n");
+		}
+	}
 	if (tb[NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211]) {
 		uint8_t *d = nla_data(tb[NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211]);
 		int l = nla_len(tb[NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211]);
diff --git a/info.c b/info.c
index 7499290..d934c58 100644
--- a/info.c
+++ b/info.c
@@ -455,6 +455,7 @@ broken_combination:
 			[NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST] = { .type = NLA_FLAG },
 			[NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE] = { .type = NLA_FLAG },
 			[NL80211_WOWLAN_TRIG_RFKILL_RELEASE] = { .type = NLA_FLAG },
+			[NL80211_WOWLAN_TRIG_NET_DETECT] = { .type = NLA_FLAG },
 			[NL80211_WOWLAN_TRIG_TCP_CONNECTION] = { .type = NLA_NESTED },
 		};
 		struct nl80211_pattern_support *pat;
@@ -492,6 +493,8 @@ broken_combination:
 				printf("\t\t * wake up on 4-way handshake\n");
 			if (tb_wowlan[NL80211_WOWLAN_TRIG_RFKILL_RELEASE])
 				printf("\t\t * wake up on rfkill release\n");
+			if (tb_wowlan[NL80211_WOWLAN_TRIG_NET_DETECT])
+				printf("\t\t * wake up on network detection\n");
 			if (tb_wowlan[NL80211_WOWLAN_TRIG_TCP_CONNECTION])
 				printf("\t\t * wake up on TCP connection\n");
 		}
diff --git a/wowlan.c b/wowlan.c
index fc8e2c3..13a756c 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -181,6 +181,163 @@ static int wowlan_parse_tcp_file(struct nl_msg *msg, const char *fn)
 	return err;
 }
 
+static int wowlan_parse_net_detect(struct nl_msg *msg, int *argc, char ***argv)
+{
+	struct nl_msg *matchset = NULL, *freqs = NULL;
+	struct nlattr *nd, *match = NULL;
+	enum {
+		ND_TOPLEVEL,
+		ND_MATCH,
+		ND_FREQS,
+	} parse_state = ND_TOPLEVEL;
+	int c  = *argc;
+	char *end, **v = *argv;
+	int err = 0, i = 0;
+	unsigned int freq, interval = 0;
+	bool have_matchset = false, have_freqs = false;
+
+	nd = nla_nest_start(msg, NL80211_WOWLAN_TRIG_NET_DETECT);
+	if (!nd) {
+		err = -ENOBUFS;
+		goto out;
+	}
+
+	matchset = nlmsg_alloc();
+	if (!matchset) {
+		err = -ENOBUFS;
+		goto out;
+	}
+
+	freqs = nlmsg_alloc();
+	if (!freqs) {
+		err = -ENOBUFS;
+		goto out;
+	}
+
+	while (c) {
+		switch (parse_state) {
+		case ND_TOPLEVEL:
+			if (!strcmp(v[0], "interval")) {
+				c--; v++;
+				if (c == 0) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+
+				if (interval) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+				interval = strtoul(v[0], &end, 10);
+				if (*end || !interval) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+				NLA_PUT_U32(msg,
+					    NL80211_ATTR_SCHED_SCAN_INTERVAL,
+					    interval);
+			} else if (!strcmp(v[0], "matches")) {
+				parse_state = ND_MATCH;
+				if (have_matchset) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+
+				i = 0;
+			} else if (!strcmp(v[0], "freqs")) {
+				parse_state = ND_FREQS;
+				if (have_freqs) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+
+				have_freqs = true;
+				i = 0;
+			} else {
+				/* this element is not for us, so
+				 * return to continue parsing.
+				 */
+				goto nla_put_failure;
+			}
+			c--; v++;
+
+			break;
+		case ND_MATCH:
+			if (!strcmp(v[0], "ssid")) {
+				c--; v++;
+				if (c == 0) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+
+				/* TODO: for now we can only have an
+				 * SSID in the match, so we can start
+				 * the match nest here.
+				 */
+				match = nla_nest_start(matchset, i);
+				if (!match) {
+					err = -ENOBUFS;
+					goto nla_put_failure;
+				}
+
+				NLA_PUT(matchset,
+					NL80211_SCHED_SCAN_MATCH_ATTR_SSID,
+					strlen(v[0]), v[0]);
+				nla_nest_end(matchset, match);
+				match = NULL;
+
+				have_matchset = true;
+				i++;
+				c--; v++;
+			} else {
+				/* other element that cannot be part
+				 * of a match indicates the end of the
+				 * match. */
+				/* need at least one match in the matchset */
+				if (i == 0) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+
+				parse_state = ND_TOPLEVEL;
+			}
+
+			break;
+		case ND_FREQS:
+			freq = strtoul(v[0], &end, 10);
+			if (*end) {
+				if (i == 0) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+
+				parse_state = ND_TOPLEVEL;
+			} else {
+				NLA_PUT_U32(freqs, i, freq);
+				i++;
+				c--; v++;
+			}
+			break;
+		}
+	}
+
+	if (have_freqs)
+		nla_put_nested(msg, NL80211_ATTR_SCAN_FREQUENCIES, freqs);
+	if (have_matchset)
+		nla_put_nested(msg, NL80211_ATTR_SCHED_SCAN_MATCH, matchset);
+
+nla_put_failure:
+	if (match)
+		nla_nest_end(msg, match);
+	nlmsg_free(freqs);
+	nlmsg_free(matchset);
+	nla_nest_end(msg, nd);
+out:
+	*argc = c;
+	*argv = v;
+	return err;
+}
+
 static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 				struct nl_msg *msg, int argc, char **argv,
 				enum id_input id)
@@ -235,6 +392,17 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 					err = -ENOMEM;
 					goto nla_put_failure;
 				}
+			} else if (strcmp(argv[0], "net-detect") == 0) {
+				argv++;
+				argc--;
+				if (!argc) {
+					err = 1;
+					goto nla_put_failure;
+				}
+				err = wowlan_parse_net_detect(msg, &argc, &argv);
+				if (err)
+					goto nla_put_failure;
+				continue;
 			} else {
 				err = 1;
 				goto nla_put_failure;
@@ -286,7 +454,8 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 	return err;
 }
 COMMAND(wowlan, enable, "[any] [disconnect] [magic-packet] [gtk-rekey-failure] [eap-identity-request]"
-	" [4way-handshake] [rfkill-release] [tcp <config-file>] [patterns [offset1+]<pattern1> ...]",
+	" [4way-handshake] [rfkill-release] [net-detect interval <in_msecs> [freqs <freq>+] [matches [ssid <ssid>]+]]"
+	" [tcp <config-file>] [patterns [offset1+]<pattern1> ...]",
 	NL80211_CMD_SET_WOWLAN, 0, CIB_PHY, handle_wowlan_enable,
 	"Enable WoWLAN with the given triggers.\n"
 	"Each pattern is given as a bytestring with '-' in places where any byte\n"
@@ -301,7 +470,9 @@ COMMAND(wowlan, enable, "[any] [disconnect] [magic-packet] [gtk-rekey-failure] [
 	"  data.interval=seconds\n"
 	"  [wake=<hex packet with masked out bytes indicated by '-'>]\n"
 	"  [data.seq=len,offset[,start]]\n"
-	"  [data.tok=len,offset,<token stream>]");
+	"  [data.tok=len,offset,<token stream>]\n\n"
+	"Net-detect configuration example:\n"
+	" iw phy0 wowlan enable net-detect interval 5000 freqs 2412 2422 matches ssid foo ssid bar");
 
 
 static int handle_wowlan_disable(struct nl80211_state *state, struct nl_cb *cb,
@@ -352,6 +523,8 @@ static int print_wowlan_handler(struct nl_msg *msg, void *arg)
 		printf(" * wake up on 4-way handshake\n");
 	if (trig[NL80211_WOWLAN_TRIG_RFKILL_RELEASE])
 		printf(" * wake up on RF-kill release\n");
+	if (trig[NL80211_WOWLAN_TRIG_NET_DETECT])
+		printf(" * wake up on network detection\n");
 	if (trig[NL80211_WOWLAN_TRIG_PKT_PATTERN]) {
 		nla_for_each_nested(pattern,
 				    trig[NL80211_WOWLAN_TRIG_PKT_PATTERN],
-- 
2.1.3

