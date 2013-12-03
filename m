Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:41673 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3LCIvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 03:51:04 -0500
Received: by mail-ee0-f43.google.com with SMTP id c13so1263800eek.30
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 00:51:03 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] iw: add VHT MCS set support to set bitrates
Date: Tue,  3 Dec 2013 09:50:48 +0100
Message-Id: <1386060648-6020-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131203_095113_916218_27DCF46F)
In-Reply-To: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 bitrate.c |   71 +++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 25 deletions(-)

diff --git a/bitrate.c b/bitrate.c
index 4da246f..2af75d5 100644
--- a/bitrate.c
+++ b/bitrate.c
@@ -17,15 +17,17 @@ static int handle_bitrates(struct nl80211_state *state,
 	int n_legacy_24 = 0, n_legacy_5 = 0;
 	uint8_t *legacy = NULL;
 	int *n_legacy = NULL;
-	bool have_mcs_24 = false, have_mcs_5 = false;
-	uint8_t mcs_24[77], mcs_5[77];
-	int n_mcs_24 = 0, n_mcs_5 = 0;
+	bool have_ht_mcs_24 = false, have_ht_mcs_5 = false;
+	bool have_vht_mcs_24 = false, have_vht_mcs_5 = false;
+	uint8_t ht_mcs_24[77], ht_mcs_5[77], vht_mcs_24[80], vht_mcs_5[80];
+	int n_ht_mcs_24 = 0, n_ht_mcs_5 = 0, n_vht_mcs_24 = 0, n_vht_mcs_5 = 0;
 	uint8_t *mcs = NULL;
 	int *n_mcs = NULL;
 	enum {
 		S_NONE,
 		S_LEGACY,
-		S_MCS,
+		S_HT_MCS,
+		S_VHT_MCS,
 	} parser_state = S_NONE;
 
 	for (i = 0; i < argc; i++) {
@@ -48,20 +50,34 @@ static int handle_bitrates(struct nl80211_state *state,
 			n_legacy = &n_legacy_5;
 			have_legacy_5 = true;
 		}
-		else if (strcmp(argv[i], "mcs-2.4") == 0) {
-			if (have_mcs_24)
+		else if (strcmp(argv[i], "ht-mcs-2.4") == 0) {
+			if (have_ht_mcs_24)
 				return 1;
-			parser_state = S_MCS;
-			mcs = mcs_24;
-			n_mcs = &n_mcs_24;
-			have_mcs_24 = true;
-		} else if (strcmp(argv[i], "mcs-5") == 0) {
-			if (have_mcs_5)
+			parser_state = S_HT_MCS;
+			mcs = ht_mcs_24;
+			n_mcs = &n_ht_mcs_24;
+			have_ht_mcs_24 = true;
+		} else if (strcmp(argv[i], "ht-mcs-5") == 0) {
+			if (have_ht_mcs_5)
 				return 1;
-			parser_state = S_MCS;
-			mcs = mcs_5;
-			n_mcs = &n_mcs_5;
-			have_mcs_5 = true;
+			parser_state = S_HT_MCS;
+			mcs = ht_mcs_5;
+			n_mcs = &n_ht_mcs_5;
+			have_ht_mcs_5 = true;
+		} else if (strcmp(argv[i], "vht-mcs-2.4") == 0) {
+			if (have_vht_mcs_24)
+				return 1;
+			parser_state = S_VHT_MCS;
+			mcs = vht_mcs_24;
+			n_mcs = &n_vht_mcs_24;
+			have_vht_mcs_24 = true;
+		} else if (strcmp(argv[i], "vht-mcs-5") == 0) {
+			if (have_vht_mcs_5)
+				return 1;
+			parser_state = S_VHT_MCS;
+			mcs = vht_mcs_5;
+			n_mcs = &n_vht_mcs_5;
+			have_vht_mcs_5 = true;
 		}
 		else switch (parser_state) {
 		case S_LEGACY:
@@ -72,7 +88,8 @@ static int handle_bitrates(struct nl80211_state *state,
 				return 1;
 			legacy[(*n_legacy)++] = tmpd * 2;
 			break;
-		case S_MCS:
+		case S_HT_MCS:
+		case S_VHT_MCS:
 			tmpl = strtol(argv[i], &end, 0);
 			if (*end != '\0')
 				return 1;
@@ -89,25 +106,29 @@ static int handle_bitrates(struct nl80211_state *state,
 	if (!nl_rates)
 		goto nla_put_failure;
 
-	if (have_legacy_24 || have_mcs_24) {
+	if (have_legacy_24 || have_ht_mcs_24 || have_vht_mcs_24) {
 		nl_band = nla_nest_start(msg, NL80211_BAND_2GHZ);
 		if (!nl_band)
 			goto nla_put_failure;
 		if (have_legacy_24)
 			nla_put(msg, NL80211_TXRATE_LEGACY, n_legacy_24, legacy_24);
-		if (have_mcs_24)
-			nla_put(msg, NL80211_TXRATE_MCS, n_mcs_24, mcs_24);
+		if (have_ht_mcs_24)
+			nla_put(msg, NL80211_TXRATE_HT_MCS, n_ht_mcs_24, ht_mcs_24);
+		if (have_vht_mcs_24)
+			nla_put(msg, NL80211_TXRATE_VHT_MCS, n_vht_mcs_24, vht_mcs_24);
 		nla_nest_end(msg, nl_band);
 	}
 
-	if (have_legacy_5 || have_mcs_5) {
+	if (have_legacy_5 || have_ht_mcs_5 || have_vht_mcs_5) {
 		nl_band = nla_nest_start(msg, NL80211_BAND_5GHZ);
 		if (!nl_band)
 			goto nla_put_failure;
 		if (have_legacy_5)
 			nla_put(msg, NL80211_TXRATE_LEGACY, n_legacy_5, legacy_5);
-		if (have_mcs_5)
-			nla_put(msg, NL80211_TXRATE_MCS, n_mcs_5, mcs_5);
+		if (have_ht_mcs_5)
+			nla_put(msg, NL80211_TXRATE_HT_MCS, n_ht_mcs_5, ht_mcs_5);
+		if (have_vht_mcs_5)
+			nla_put(msg, NL80211_TXRATE_VHT_MCS, n_vht_mcs_5, vht_mcs_5);
 		nla_nest_end(msg, nl_band);
 	}
 
@@ -119,9 +140,9 @@ static int handle_bitrates(struct nl80211_state *state,
 }
 
 #define DESCR_LEGACY "[legacy-<2.4|5> <legacy rate in Mbps>*]"
-#define DESCR DESCR_LEGACY " [mcs-<2.4|5> <MCS index>*]"
+#define DESCR DESCR_LEGACY " [ht-mcs-<2.4|5> <MCS index>*] [vht-mcs-<2.4|5> <MCS index>*]"
 
-COMMAND(set, bitrates, "[legacy-<2.4|5> <legacy rate in Mbps>*] [mcs-<2.4|5> <MCS index>*]",
+COMMAND(set, bitrates, "[legacy-<2.4|5> <legacy rate in Mbps>*] [ht-mcs-<2.4|5> <MCS index>*] [vht-mcs-<2.4|5> <MCS index>*]",
 	NL80211_CMD_SET_TX_BITRATE_MASK, 0, CIB_NETDEV, handle_bitrates,
 	"Sets up the specified rate masks.\n"
 	"Not passing any arguments would clear the existing mask (if any).");
-- 
1.7.9.5

