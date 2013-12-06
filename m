Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:47792 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab3LFMef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 07:34:35 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so278093eaj.12
        for <linux-wireless@vger.kernel.org>; Fri, 06 Dec 2013 04:34:33 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v3] iw: add VHT MCS/NSS set support to set bitrates
Date: Fri,  6 Dec 2013 13:34:19 +0100
Message-Id: <1386333259-5847-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131206_133438_592233_6CACCD4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mcs-2.4/mcs-5 rename to ht-mcs-2.4/ht-mcs-5
vht-mcs-2.4/vht-mcs-5 added

Format for vht-mcs-*, eg:
1:0-9 - set NSS=1 and MCS0-9
2:4,5 - set NSS=2 and MCS4, MCS5
3:1   - set NSS=3 and MCS1

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 bitrate.c |  163 +++++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 138 insertions(+), 25 deletions(-)

diff --git a/bitrate.c b/bitrate.c
index 4da246f..dc60ade 100644
--- a/bitrate.c
+++ b/bitrate.c
@@ -4,6 +4,79 @@
 #include "iw.h"
 
 
+
+static int parse_vht_chunk(const char *arg, __u8 *nss, __u16 *mcs)
+{
+	int count, i;
+	unsigned int inss, mcs_start, mcs_end, tab[10];
+
+	*nss = 0; *mcs = 0;
+
+	if (strchr(arg, '-')) {
+		/* Format: NSS:MCS_START-MCS_END */
+		count = sscanf(arg, "%u:%u-%u", &inss, &mcs_start, &mcs_end);
+
+		if (count != 3)
+			return 0;
+
+		if (inss < 1 || inss > NL80211_VHT_NSS_MAX)
+			return 0;
+
+		if (mcs_start > mcs_end)
+			return 0;
+
+		if (mcs_start > 9 || mcs_end > 9)
+			return 0;
+
+		*nss = inss;
+		for (i = mcs_start; i <= mcs_end; i++)
+			*mcs |= 1 << i;
+
+	} else {
+		/* Format: NSS:MCSx,MCSy,... */
+		count = sscanf(arg, "%u:%u,%u,%u,%u,%u,%u,%u,%u,%u,%u", &inss,
+			   &tab[0], &tab[1], &tab[2], &tab[3], &tab[4], &tab[5],
+			   &tab[6], &tab[7], &tab[8], &tab[9]);
+
+		if (count < 2)
+			return 0;
+
+		if (inss < 1 || inss > NL80211_VHT_NSS_MAX)
+			return 0;
+
+		*nss = inss;
+		for (i = 0; i < count - 1; i++) {
+			if (tab[i] > 9)
+				return 0;
+			*mcs |= 1 << tab[i];
+		}
+	}
+
+	return 1;
+}
+
+static int setup_vht(struct nl80211_txrate_vht *txrate_vht,
+		     int argc, char **argv)
+{
+	__u8 nss;
+	__u16 mcs;
+	int i;
+
+	memset(txrate_vht, 0, sizeof(*txrate_vht));
+
+	for (i = 0; i < argc; i++) {
+		if(!parse_vht_chunk(argv[i], &nss, &mcs))
+			return 0;
+
+		nss--;
+		txrate_vht->mcs[nss] |= mcs;
+	}
+
+	return 1;
+}
+
+#define VHT_ARGC_MAX	100
+
 static int handle_bitrates(struct nl80211_state *state,
 			   struct nl_cb *cb,
 			   struct nl_msg *msg,
@@ -17,15 +90,24 @@ static int handle_bitrates(struct nl80211_state *state,
 	int n_legacy_24 = 0, n_legacy_5 = 0;
 	uint8_t *legacy = NULL;
 	int *n_legacy = NULL;
-	bool have_mcs_24 = false, have_mcs_5 = false;
-	uint8_t mcs_24[77], mcs_5[77];
-	int n_mcs_24 = 0, n_mcs_5 = 0;
+	bool have_ht_mcs_24 = false, have_ht_mcs_5 = false;
+	bool have_vht_mcs_24 = false, have_vht_mcs_5 = false;
+	uint8_t ht_mcs_24[77], ht_mcs_5[77];
+	int n_ht_mcs_24 = 0, n_ht_mcs_5 = 0;
+	struct nl80211_txrate_vht txrate_vht_24 = {};
+	struct nl80211_txrate_vht txrate_vht_5 = {};
 	uint8_t *mcs = NULL;
 	int *n_mcs = NULL;
+	char *vht_argv_5[VHT_ARGC_MAX] = {}; char *vht_argv_24[VHT_ARGC_MAX] = {};
+	char **vht_argv = NULL;
+	int vht_argc_5 = 0; int vht_argc_24 = 0;
+	int *vht_argc = NULL;
+
 	enum {
 		S_NONE,
 		S_LEGACY,
-		S_MCS,
+		S_HT,
+		S_VHT,
 	} parser_state = S_NONE;
 
 	for (i = 0; i < argc; i++) {
@@ -48,20 +130,34 @@ static int handle_bitrates(struct nl80211_state *state,
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
+				return 1;
+			parser_state = S_HT;
+			mcs = ht_mcs_5;
+			n_mcs = &n_ht_mcs_5;
+			have_ht_mcs_5 = true;
+		} else if (strcmp(argv[i], "vht-mcs-2.4") == 0) {
+			if (have_vht_mcs_24)
 				return 1;
-			parser_state = S_MCS;
-			mcs = mcs_24;
-			n_mcs = &n_mcs_24;
-			have_mcs_24 = true;
-		} else if (strcmp(argv[i], "mcs-5") == 0) {
-			if (have_mcs_5)
+			parser_state = S_VHT;
+			vht_argv = vht_argv_24;
+			vht_argc = &vht_argc_24;
+			have_vht_mcs_24 = true;
+		} else if (strcmp(argv[i], "vht-mcs-5") == 0) {
+			if (have_vht_mcs_5)
 				return 1;
-			parser_state = S_MCS;
-			mcs = mcs_5;
-			n_mcs = &n_mcs_5;
-			have_mcs_5 = true;
+			parser_state = S_VHT;
+			vht_argv = vht_argv_5;
+			vht_argc = &vht_argc_5;
+			have_vht_mcs_5 = true;
 		}
 		else switch (parser_state) {
 		case S_LEGACY:
@@ -72,7 +168,7 @@ static int handle_bitrates(struct nl80211_state *state,
 				return 1;
 			legacy[(*n_legacy)++] = tmpd * 2;
 			break;
-		case S_MCS:
+		case S_HT:
 			tmpl = strtol(argv[i], &end, 0);
 			if (*end != '\0')
 				return 1;
@@ -80,34 +176,51 @@ static int handle_bitrates(struct nl80211_state *state,
 				return 1;
 			mcs[(*n_mcs)++] = tmpl;
 			break;
+		case S_VHT:
+			if (*vht_argc >= VHT_ARGC_MAX)
+				return 1;
+			vht_argv[(*vht_argc)++] = argv[i];
+			break;
 		default:
 			return 1;
 		}
 	}
 
+	if (have_vht_mcs_24)
+		if(!setup_vht(&txrate_vht_24, vht_argc_24, vht_argv_24))
+			return -EINVAL;
+
+	if (have_vht_mcs_5)
+		if(!setup_vht(&txrate_vht_5, vht_argc_5, vht_argv_5))
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
 
@@ -119,9 +232,9 @@ static int handle_bitrates(struct nl80211_state *state,
 }
 
 #define DESCR_LEGACY "[legacy-<2.4|5> <legacy rate in Mbps>*]"
-#define DESCR DESCR_LEGACY " [mcs-<2.4|5> <MCS index>*]"
+#define DESCR DESCR_LEGACY " [ht-mcs-<2.4|5> <MCS index>*] [vht-mcs-<2.4|5> <NSS:MCSx,MCSy... | NSS:MCSx-MCSy>*]"
 
-COMMAND(set, bitrates, "[legacy-<2.4|5> <legacy rate in Mbps>*] [mcs-<2.4|5> <MCS index>*]",
+COMMAND(set, bitrates, "[legacy-<2.4|5> <legacy rate in Mbps>*] [ht-mcs-<2.4|5> <MCS index>*] [vht-mcs-<2.4|5> <NSS:MCSx,MCSy... | NSS:MCSx-MCSy>*]",
 	NL80211_CMD_SET_TX_BITRATE_MASK, 0, CIB_NETDEV, handle_bitrates,
 	"Sets up the specified rate masks.\n"
 	"Not passing any arguments would clear the existing mask (if any).");
-- 
1.7.9.5

