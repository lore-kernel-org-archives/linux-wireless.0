Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38230 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247Ab2AET6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 14:58:17 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCH 2/2] iw: remove ifdefs for mcs mask
Date: Thu,  5 Jan 2012 20:58:10 +0100
Message-Id: <1325793490-21501-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20120105_205825_838394_55647120)
In-Reply-To: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are enums, not defines. Therefore the ifdef check can never be
true.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 bitrate.c |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/bitrate.c b/bitrate.c
index cefd150..22b863e 100644
--- a/bitrate.c
+++ b/bitrate.c
@@ -17,12 +17,10 @@ static int handle_bitrates(struct nl80211_state *state,
 	uint8_t *legacy = NULL;
 	int *n_legacy = NULL;
 	bool have_mcs_24 = false, have_mcs_5 = false;
-#ifdef NL80211_TXRATE_MCS
 	uint8_t mcs_24[77], mcs_5[77];
 	int n_mcs_24 = 0, n_mcs_5 = 0;
 	uint8_t *mcs = NULL;
 	int *n_mcs = NULL;
-#endif
 	enum {
 		S_NONE,
 		S_LEGACY,
@@ -32,9 +30,7 @@ static int handle_bitrates(struct nl80211_state *state,
 	for (i = 0; i < argc; i++) {
 		char *end;
 		double tmpd;
-#ifdef NL80211_TXRATE_MCS
 		long tmpl;
-#endif
 
 		if (strcmp(argv[i], "legacy-2.4") == 0) {
 			if (have_legacy_24)
@@ -51,7 +47,6 @@ static int handle_bitrates(struct nl80211_state *state,
 			n_legacy = &n_legacy_5;
 			have_legacy_5 = true;
 		}
-#ifdef NL80211_TXRATE_MCS
 		else if (strcmp(argv[i], "mcs-2.4") == 0) {
 			if (have_mcs_24)
 				return 1;
@@ -67,7 +62,6 @@ static int handle_bitrates(struct nl80211_state *state,
 			n_mcs = &n_mcs_5;
 			have_mcs_5 = true;
 		}
-#endif
 		else switch (parser_state) {
 		case S_LEGACY:
 			tmpd = strtod(argv[i], &end);
@@ -78,7 +72,6 @@ static int handle_bitrates(struct nl80211_state *state,
 			legacy[(*n_legacy)++] = tmpd * 2;
 			break;
 		case S_MCS:
-#ifdef NL80211_TXRATE_MCS
 			tmpl = strtol(argv[i], &end, 0);
 			if (*end != '\0')
 				return 1;
@@ -86,7 +79,6 @@ static int handle_bitrates(struct nl80211_state *state,
 				return 1;
 			mcs[(*n_mcs)++] = tmpl;
 			break;
-#endif
 		default:
 			return 1;
 		}
@@ -102,10 +94,8 @@ static int handle_bitrates(struct nl80211_state *state,
 			goto nla_put_failure;
 		if (have_legacy_24)
 			nla_put(msg, NL80211_TXRATE_LEGACY, n_legacy_24, legacy_24);
-#ifdef NL80211_TXRATE_MCS
 		if (have_mcs_24)
 			nla_put(msg, NL80211_TXRATE_MCS, n_mcs_24, mcs_24);
-#endif
 		nla_nest_end(msg, nl_band);
 	}
 
@@ -115,10 +105,8 @@ static int handle_bitrates(struct nl80211_state *state,
 			goto nla_put_failure;
 		if (have_legacy_5)
 			nla_put(msg, NL80211_TXRATE_LEGACY, n_legacy_5, legacy_5);
-#ifdef NL80211_TXRATE_MCS
 		if (have_mcs_5)
 			nla_put(msg, NL80211_TXRATE_MCS, n_mcs_5, mcs_5);
-#endif
 		nla_nest_end(msg, nl_band);
 	}
 
@@ -130,13 +118,9 @@ static int handle_bitrates(struct nl80211_state *state,
 }
 
 #define DESCR_LEGACY "[legacy-<2.4|5> <legacy rate in Mbps>*]"
-#ifdef NL80211_TXRATE_MCS
 #define DESCR DESCR_LEGACY " [mcs-<2.4|5> <MCS index>*]"
-#else
-#define DESCR DESCR_LEGACY
-#endif
 
-COMMAND(set, bitrates, DESCR, NL80211_CMD_SET_TX_BITRATE_MASK, 0, CIB_NETDEV,
-	handle_bitrates,
+COMMAND(set, bitrates, "[legacy-<2.4|5> <legacy rate in Mbps>*] [mcs-<2.4|5> <MCS index>*]",
+	NL80211_CMD_SET_TX_BITRATE_MASK, 0, CIB_NETDEV, handle_bitrates,
 	"Sets up the specified rate masks.\n"
 	"Not passing any arguments would clear the existing mask (if any).");
-- 
1.7.7.3

