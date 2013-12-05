Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:33122 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab3LEJCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 04:02:32 -0500
Received: by mail-ee0-f49.google.com with SMTP id c41so2863169eek.36
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 01:02:31 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2] iw: add VHT MCS/NSS set support to set bitrates
Date: Thu,  5 Dec 2013 10:02:17 +0100
Message-Id: <1386234137-3531-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131205_100244_265143_070E89FC)
In-Reply-To: <1386234137-3531-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1386234137-3531-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mcs-2.4/mcs-5 rename to ht-mcs-2.4/ht-mcs-5
vht-mcs-2.4/vht-mcs-5 added

Format for vht-mcs-*, eg:
1  - MCS=1, NSS=1
9  - MCS=9, NSS=1
10 - MCS=0, NSS=2
19 - MCS=9, NSS=2
20 - MCS=0, NSS=3
29 - MCS=9, NSS=3

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 bitrate.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 76 insertions(+), 25 deletions(-)

diff --git a/bitrate.c b/bitrate.c
index 4da246f..cc80003 100644
--- a/bitrate.c
+++ b/bitrate.c
@@ -4,6 +4,26 @@
 #include "iw.h"
 
 
+static int setup_vht(struct nl80211_txrate_vht *txrate_vht,
+		      uint8_t *mcs_table, int n_mcs)
+{
+	int nss, mcs, i;
+
+	memset(txrate_vht, 0, sizeof(*txrate_vht));
+
+	for (i = 0; i < n_mcs; i++) {
+		nss = mcs_table[i]  / 10;
+		mcs = 1 << (mcs_table[i] % 10);
+
+		if ((nss < 0) || (nss >= NL80211_VHT_NSS_MAX))
+			return 0;
+
+		txrate_vht->mcs[nss] |= mcs;
+	}
+
+	return 1;
+}
+
 static int handle_bitrates(struct nl80211_state *state,
 			   struct nl_cb *cb,
 			   struct nl_msg *msg,
@@ -17,15 +37,19 @@ static int handle_bitrates(struct nl80211_state *state,
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
+	struct nl80211_txrate_vht txrate_vht_24 = {};
+	struct nl80211_txrate_vht txrate_vht_5 = {};
 	uint8_t *mcs = NULL;
 	int *n_mcs = NULL;
 	enum {
 		S_NONE,
 		S_LEGACY,
-		S_MCS,
+		S_HT,
+		S_VHT,
 	} parser_state = S_NONE;
 
 	for (i = 0; i < argc; i++) {
@@ -48,20 +72,34 @@ static int handle_bitrates(struct nl80211_state *state,
 			n_legacy = &n_legacy_5;
 			have_legacy_5 = true;
 		}
-		else if (strcmp(argv[i], "mcs-2.4") == 0) {
-			if (have_mcs_24)
+		else if (strcmp(argv[i], "ht-mcs-2.4") == 0) {
+			if (have_ht_mcs_24)
+				return 1;
+			parser_state = S_HT;
+			mcs = ht_mcs_24;
+			n_mcs = &n_ht_mcs_24;
+			have_ht_mcs_24 = true;
+		} else if (strcmp(argv[i], "ht-mcs-5") == 0) {
+			if (have_ht_mcs_5)
 				return 1;
-			parser_state = S_MCS;
-			mcs = mcs_24;
-			n_mcs = &n_mcs_24;
-			have_mcs_24 = true;
-		} else if (strcmp(argv[i], "mcs-5") == 0) {
-			if (have_mcs_5)
+			parser_state = S_HT;
+			mcs = ht_mcs_5;
+			n_mcs = &n_ht_mcs_5;
+			have_ht_mcs_5 = true;
+		} else if (strcmp(argv[i], "vht-mcs-2.4") == 0) {
+			if (have_vht_mcs_24)
 				return 1;
-			parser_state = S_MCS;
-			mcs = mcs_5;
-			n_mcs = &n_mcs_5;
-			have_mcs_5 = true;
+			parser_state = S_VHT;
+			mcs = vht_mcs_24;
+			n_mcs = &n_vht_mcs_24;
+			have_vht_mcs_24 = true;
+		} else if (strcmp(argv[i], "vht-mcs-5") == 0) {
+			if (have_vht_mcs_5)
+				return 1;
+			parser_state = S_VHT;
+			mcs = vht_mcs_5;
+			n_mcs = &n_vht_mcs_5;
+			have_vht_mcs_5 = true;
 		}
 		else switch (parser_state) {
 		case S_LEGACY:
@@ -72,7 +110,8 @@ static int handle_bitrates(struct nl80211_state *state,
 				return 1;
 			legacy[(*n_legacy)++] = tmpd * 2;
 			break;
-		case S_MCS:
+		case S_HT:
+		case S_VHT:
 			tmpl = strtol(argv[i], &end, 0);
 			if (*end != '\0')
 				return 1;
@@ -85,29 +124,41 @@ static int handle_bitrates(struct nl80211_state *state,
 		}
 	}
 
+	if (have_vht_mcs_24)
+		if(!setup_vht(&txrate_vht_24, vht_mcs_24, n_vht_mcs_24))
+			return -EINVAL;
+
+	if (have_vht_mcs_5)
+		if(!setup_vht(&txrate_vht_5, vht_mcs_5, n_vht_mcs_5))
+			return -EINVAL;
+
 	nl_rates = nla_nest_start(msg, NL80211_ATTR_TX_RATES);
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
+			nla_put(msg, NL80211_TXRATE_HT, n_ht_mcs_24, ht_mcs_24);
+		if (have_vht_mcs_24)
+			nla_put(msg, NL80211_TXRATE_VHT, sizeof(txrate_vht_24), &txrate_vht_24);
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
+			nla_put(msg, NL80211_TXRATE_HT, n_ht_mcs_5, ht_mcs_5);
+		if (have_vht_mcs_5)
+			nla_put(msg, NL80211_TXRATE_VHT, sizeof(txrate_vht_5), &txrate_vht_5);
 		nla_nest_end(msg, nl_band);
 	}
 
@@ -119,9 +170,9 @@ static int handle_bitrates(struct nl80211_state *state,
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

