Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:58832 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab3LUTSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Dec 2013 14:18:38 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so1635128ead.22
        for <linux-wireless@vger.kernel.org>; Sat, 21 Dec 2013 11:18:37 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] iw: add sgi/lgi support to set bitrates
Date: Sat, 21 Dec 2013 20:18:22 +0100
Message-Id: <1387653502-2825-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131221_201842_264754_1B89D2D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add possiblity to force SGI/LGI.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
base on, iw: add VHT MCS/NSS set support to set bitrates

 bitrate.c |   41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/bitrate.c b/bitrate.c
index dc60ade..82c95ab 100644
--- a/bitrate.c
+++ b/bitrate.c
@@ -102,12 +102,14 @@ static int handle_bitrates(struct nl80211_state *state,
 	char **vht_argv = NULL;
 	int vht_argc_5 = 0; int vht_argc_24 = 0;
 	int *vht_argc = NULL;
+	int sgi_24 = 0, sgi_5 = 0, lgi_24 = 0, lgi_5 = 0;
 
 	enum {
 		S_NONE,
 		S_LEGACY,
 		S_HT,
 		S_VHT,
+		S_GI,
 	} parser_state = S_NONE;
 
 	for (i = 0; i < argc; i++) {
@@ -158,8 +160,19 @@ static int handle_bitrates(struct nl80211_state *state,
 			vht_argv = vht_argv_5;
 			vht_argc = &vht_argc_5;
 			have_vht_mcs_5 = true;
-		}
-		else switch (parser_state) {
+		} else if (strcmp(argv[i], "sgi-2.4") == 0) {
+			sgi_24 = 1;
+			parser_state = S_GI;
+		} else if (strcmp(argv[i], "sgi-5") == 0) {
+			sgi_5 = 1;
+			parser_state = S_GI;
+		} else if (strcmp(argv[i], "lgi-2.4") == 0) {
+			lgi_24 = 1;
+			parser_state = S_GI;
+		} else if (strcmp(argv[i], "lgi-5") == 0) {
+			lgi_5 = 1;
+			parser_state = S_GI;
+		} else switch (parser_state) {
 		case S_LEGACY:
 			tmpd = strtod(argv[i], &end);
 			if (*end != '\0')
@@ -181,6 +194,8 @@ static int handle_bitrates(struct nl80211_state *state,
 				return 1;
 			vht_argv[(*vht_argc)++] = argv[i];
 			break;
+		case S_GI:
+			break;
 		default:
 			return 1;
 		}
@@ -194,11 +209,17 @@ static int handle_bitrates(struct nl80211_state *state,
 		if(!setup_vht(&txrate_vht_5, vht_argc_5, vht_argv_5))
 			return -EINVAL;
 
+	if (sgi_5 && lgi_5)
+		return 1;
+
+	if (sgi_24 && lgi_24)
+		return 1;
+
 	nl_rates = nla_nest_start(msg, NL80211_ATTR_TX_RATES);
 	if (!nl_rates)
 		goto nla_put_failure;
 
-	if (have_legacy_24 || have_ht_mcs_24 || have_vht_mcs_24) {
+	if (have_legacy_24 || have_ht_mcs_24 || have_vht_mcs_24 || sgi_24 || lgi_24) {
 		nl_band = nla_nest_start(msg, NL80211_BAND_2GHZ);
 		if (!nl_band)
 			goto nla_put_failure;
@@ -208,10 +229,14 @@ static int handle_bitrates(struct nl80211_state *state,
 			nla_put(msg, NL80211_TXRATE_HT, n_ht_mcs_24, ht_mcs_24);
 		if (have_vht_mcs_24)
 			nla_put(msg, NL80211_TXRATE_VHT, sizeof(txrate_vht_24), &txrate_vht_24);
+		if (sgi_24)
+			nla_put_u8(msg, NL80211_TXRATE_GI, NL80211_TXRATE_FORCE_SGI);
+		if (lgi_24)
+			nla_put_u8(msg, NL80211_TXRATE_GI, NL80211_TXRATE_FORCE_LGI);
 		nla_nest_end(msg, nl_band);
 	}
 
-	if (have_legacy_5 || have_ht_mcs_5 || have_vht_mcs_5) {
+	if (have_legacy_5 || have_ht_mcs_5 || have_vht_mcs_5 || sgi_5 || lgi_5) {
 		nl_band = nla_nest_start(msg, NL80211_BAND_5GHZ);
 		if (!nl_band)
 			goto nla_put_failure;
@@ -221,6 +246,10 @@ static int handle_bitrates(struct nl80211_state *state,
 			nla_put(msg, NL80211_TXRATE_HT, n_ht_mcs_5, ht_mcs_5);
 		if (have_vht_mcs_5)
 			nla_put(msg, NL80211_TXRATE_VHT, sizeof(txrate_vht_5), &txrate_vht_5);
+		if (sgi_5)
+			nla_put_u8(msg, NL80211_TXRATE_GI, NL80211_TXRATE_FORCE_SGI);
+		if (lgi_5)
+			nla_put_u8(msg, NL80211_TXRATE_GI, NL80211_TXRATE_FORCE_LGI);
 		nla_nest_end(msg, nl_band);
 	}
 
@@ -232,9 +261,9 @@ static int handle_bitrates(struct nl80211_state *state,
 }
 
 #define DESCR_LEGACY "[legacy-<2.4|5> <legacy rate in Mbps>*]"
-#define DESCR DESCR_LEGACY " [ht-mcs-<2.4|5> <MCS index>*] [vht-mcs-<2.4|5> <NSS:MCSx,MCSy... | NSS:MCSx-MCSy>*]"
+#define DESCR DESCR_LEGACY " [ht-mcs-<2.4|5> <MCS index>*] [vht-mcs-<2.4|5> <NSS:MCSx,MCSy... | NSS:MCSx-MCSy>*] [sgi-2.4|lgi-2.4] [sgi-5|lgi-5]"
 
-COMMAND(set, bitrates, "[legacy-<2.4|5> <legacy rate in Mbps>*] [ht-mcs-<2.4|5> <MCS index>*] [vht-mcs-<2.4|5> <NSS:MCSx,MCSy... | NSS:MCSx-MCSy>*]",
+COMMAND(set, bitrates, "[legacy-<2.4|5> <legacy rate in Mbps>*] [ht-mcs-<2.4|5> <MCS index>*] [vht-mcs-<2.4|5> <NSS:MCSx,MCSy... | NSS:MCSx-MCSy>*] [sgi-2.4|lgi-2.4] [sgi-5|lgi-5]",
 	NL80211_CMD_SET_TX_BITRATE_MASK, 0, CIB_NETDEV, handle_bitrates,
 	"Sets up the specified rate masks.\n"
 	"Not passing any arguments would clear the existing mask (if any).");
-- 
1.7.9.5

