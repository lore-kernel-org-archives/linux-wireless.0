Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36806 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932284AbcKGO75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Nov 2016 09:59:57 -0500
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
        Benjamin Berg <benjamin@sipsolutions.net>,
        Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH 4/8] mesh: Use common freqchan helper for joining a mesh
Date: Mon,  7 Nov 2016 15:59:39 +0100
Message-Id: <20161107145943.16761-5-benjamin@sipsolutions.net> (sfid-20161107_160000_898143_573ABAFE)
In-Reply-To: <20161107145943.16761-1-benjamin@sipsolutions.net>
References: <20161107145943.16761-1-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify code by using the helper which has been introduced earlier.

Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
---
 mesh.c | 67 +++++++++++-------------------------------------------------------
 1 file changed, 11 insertions(+), 56 deletions(-)

diff --git a/mesh.c b/mesh.c
index a0047fe..97f236b 100644
--- a/mesh.c
+++ b/mesh.c
@@ -446,31 +446,6 @@ static int join_mesh(struct nl80211_state *state,
 	unsigned char rates[NL80211_MAX_SUPP_RATES];
 	int bintval, dtim_period, n_rates = 0;
 	char *end, *value = NULL, *sptr = NULL;
-	unsigned int i;
-	unsigned long freq = 0;
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
-		{ .name = "80MHz",
-		  .width = NL80211_CHAN_WIDTH_80,
-		  .freq1_diff = 0,
-		  .chantype = -1 },
-	};
 
 	if (argc < 1)
 		return 1;
@@ -481,40 +456,20 @@ static int join_mesh(struct nl80211_state *state,
 
 	/* freq */
 	if (argc > 1 && strcmp(argv[0], "freq") == 0) {
-		argv++;
-		argc--;
-
-		freq = strtoul(argv[0], &end, 10);
-		if (*end != '\0')
-			return 1;
-		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
-
-		argv++;
-		argc--;
-	}
+		struct chandef chandef;
+		int err, parsed;
 
-	/* channel type */
-	if (argc) {
-		for (i = 0; i < ARRAY_SIZE(chanmode); i++) {
-			if (strcasecmp(chanmode[i].name, argv[0]) == 0) {
-				chanmode_selected = &chanmode[i];
-				break;
-			}
-		}
+		err = parse_freqchan(&chandef, false, argc - 1, argv + 1,
+				     &parsed);
+		if (err)
+			return err;
 
-		if (chanmode_selected) {
-			NLA_PUT_U32(msg, NL80211_ATTR_CHANNEL_WIDTH,
-				    chanmode_selected->width);
-			NLA_PUT_U32(msg, NL80211_ATTR_CENTER_FREQ1,
-				    get_cf1(chanmode_selected, freq));
-			if (chanmode_selected->chantype != -1)
-				NLA_PUT_U32(msg,
-					    NL80211_ATTR_WIPHY_CHANNEL_TYPE,
-					    chanmode_selected->chantype);
+		argv += parsed + 1;
+		argc -= parsed + 1;
 
-			argv++;
-			argc--;
-		}
+		put_chandef(msg, &chandef);
+		if (err)
+			return err;
 	}
 
 	/* basic rates */
-- 
2.10.2
