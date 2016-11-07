Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36800 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932279AbcKGO74 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Nov 2016 09:59:56 -0500
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
        Benjamin Berg <benjamin@sipsolutions.net>,
        Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH 3/8] ibss: Use common freqchan helper for joining an ibss
Date: Mon,  7 Nov 2016 15:59:38 +0100
Message-Id: <20161107145943.16761-4-benjamin@sipsolutions.net> (sfid-20161107_160008_756716_623533E1)
In-Reply-To: <20161107145943.16761-1-benjamin@sipsolutions.net>
References: <20161107145943.16761-1-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify code by using the helper which has been introduced earlier.

Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
---
 ibss.c | 72 ++++++++++--------------------------------------------------------
 1 file changed, 10 insertions(+), 62 deletions(-)

diff --git a/ibss.c b/ibss.c
index 2b0b495..84f1e95 100644
--- a/ibss.c
+++ b/ibss.c
@@ -13,45 +13,14 @@ static int join_ibss(struct nl80211_state *state,
 		     enum id_input id)
 {
 	char *end;
+	struct chandef chandef;
 	unsigned char abssid[6];
 	unsigned char rates[NL80211_MAX_SUPP_RATES];
 	int n_rates = 0;
 	char *value = NULL, *sptr = NULL;
 	float rate;
 	int bintval;
-	unsigned int i;
-	unsigned long freq;
-	const struct chanmode *chanmode_selected = NULL;
-	static const struct chanmode chanmode[] = {
-		{ .name = "HT20",
-		  .width = NL80211_CHAN_WIDTH_20,
-		  .freq1_diff = 0,
-		  .chantype = NL80211_CHAN_HT20 },
-		{ .name = "HT40+",
-		  .width = NL80211_CHAN_WIDTH_40,
-		  .freq1_diff = 10,
-		  .chantype = NL80211_CHAN_HT40PLUS },
-		{ .name = "HT40-",
-		  .width = NL80211_CHAN_WIDTH_40,
-		  .freq1_diff = -10,
-		  .chantype = NL80211_CHAN_HT40MINUS },
-		{ .name = "NOHT",
-		  .width = NL80211_CHAN_WIDTH_20_NOHT,
-		  .freq1_diff = 0,
-		  .chantype = NL80211_CHAN_NO_HT },
-		{ .name = "5MHz",
-		  .width = NL80211_CHAN_WIDTH_5,
-		  .freq1_diff = 0,
-		  .chantype = -1 },
-		{ .name = "10MHz",
-		  .width = NL80211_CHAN_WIDTH_10,
-		  .freq1_diff = 0,
-		  .chantype = -1 },
-		{ .name = "80MHz",
-		  .width = NL80211_CHAN_WIDTH_80,
-		  .freq1_diff = 0,
-		  .chantype = -1 },
-	};
+	int parsed, err;
 
 	if (argc < 2)
 		return 1;
@@ -61,37 +30,16 @@ static int join_ibss(struct nl80211_state *state,
 	argv++;
 	argc--;
 
-	/* freq */
-	freq = strtoul(argv[0], &end, 10);
-	if (*end != '\0')
-		return 1;
-
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
-	argv++;
-	argc--;
+	err = parse_freqchan(&chandef, false, argc, argv, &parsed);
+	if (err)
+		return err;
 
-	if (argc) {
-		for (i = 0; i < ARRAY_SIZE(chanmode); i++) {
-			if (strcasecmp(chanmode[i].name, argv[0]) == 0) {
-				chanmode_selected = &chanmode[i];
-				break;
-			}
-		}
-		if (chanmode_selected) {
-			NLA_PUT_U32(msg, NL80211_ATTR_CHANNEL_WIDTH,
-				    chanmode_selected->width);
-			NLA_PUT_U32(msg, NL80211_ATTR_CENTER_FREQ1,
-				    get_cf1(chanmode_selected, freq));
-			if (chanmode_selected->chantype != -1)
-				NLA_PUT_U32(msg,
-					    NL80211_ATTR_WIPHY_CHANNEL_TYPE,
-					    chanmode_selected->chantype);
+	argv += parsed;
+	argc -= parsed;
 
-			argv++;
-			argc--;
-		}
-
-	}
+	put_chandef(msg, &chandef);
+	if (err)
+		return err;
 
 	if (argc && strcmp(argv[0], "fixed-freq") == 0) {
 		NLA_PUT_FLAG(msg, NL80211_ATTR_FREQ_FIXED);
-- 
2.10.2
