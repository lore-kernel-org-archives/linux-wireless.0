Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:44204 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3KLRcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 12:32:02 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv2] iw: add support for 5 and 10 MHz channels in IBSS mode
Date: Tue, 12 Nov 2013 18:31:58 +0100
Message-Id: <1384277518-12398-1-git-send-email-sw@simonwunderlich.de> (sfid-20131112_183206_432132_5D65C0F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

5/10 MHz requires to send the frequency information as chandef instead
of the the old channel type, therfore send the chandef next the channel
type (the latter is still used for old kernels).

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
Changes to PATCH:
 * also send old channel type to keep compatibility for older kernels
---
 ibss.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/ibss.c b/ibss.c
index 955446e..1bf1bab 100644
--- a/ibss.c
+++ b/ibss.c
@@ -30,16 +30,38 @@ static int join_ibss(struct nl80211_state *state,
 	float rate;
 	int bintval;
 	int i;
+	unsigned long freq;
 	static const struct {
 		const char *name;
-		unsigned int val;
-	} htmap[] = {
-		{ .name = "HT20", .val = NL80211_CHAN_HT20, },
-		{ .name = "HT40+", .val = NL80211_CHAN_HT40PLUS, },
-		{ .name = "HT40-", .val = NL80211_CHAN_HT40MINUS, },
-		{ .name = "NOHT", .val = NL80211_CHAN_NO_HT, },
+		unsigned int width;
+		int freq1_diff;
+		int chantype; /* for older kernel */
+	} *chanmode_selected = NULL, chanmode[] = {
+		{ .name = "HT20",
+		  .width = NL80211_CHAN_WIDTH_20,
+		  .freq1_diff = 0,
+		  .chantype = NL80211_CHAN_HT20 },
+		{ .name = "HT40+",
+		  .width = NL80211_CHAN_WIDTH_40,
+		  .freq1_diff = 10,
+		  .chantype = NL80211_CHAN_HT40PLUS },
+		{ .name = "HT40-",
+		  .width = NL80211_CHAN_WIDTH_40,
+		  .freq1_diff = -10,
+		  .chantype = NL80211_CHAN_HT40MINUS },
+		{ .name = "NOHT",
+		  .width = NL80211_CHAN_WIDTH_20_NOHT,
+		  .freq1_diff = 0,
+		  .chantype = NL80211_CHAN_NO_HT },
+		{ .name = "5MHZ",
+		  .width = NL80211_CHAN_WIDTH_5,
+		  .freq1_diff = 0,
+		  .chantype = -1 },
+		{ .name = "10MHZ",
+		  .width = NL80211_CHAN_WIDTH_10,
+		  .freq1_diff = 0,
+		  .chantype = -1 },
 	};
-	unsigned int htval;
 
 	if (argc < 2)
 		return 1;
@@ -50,23 +72,31 @@ static int join_ibss(struct nl80211_state *state,
 	argc--;
 
 	/* freq */
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ,
-		    strtoul(argv[0], &end, 10));
+	freq = strtoul(argv[0], &end, 10);
 	if (*end != '\0')
 		return 1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
 	argv++;
 	argc--;
 
 	if (argc) {
-		for (i = 0; i < ARRAY_SIZE(htmap); i++) {
-			if (strcasecmp(htmap[i].name, argv[0]) == 0) {
-				htval = htmap[i].val;
+		for (i = 0; i < ARRAY_SIZE(chanmode); i++) {
+			if (strcasecmp(chanmode[i].name, argv[0]) == 0) {
+				chanmode_selected = &chanmode[i];
 				break;
 			}
 		}
-		if (i != ARRAY_SIZE(htmap)) {
-			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
-				    htval);
+		if (chanmode_selected) {
+			NLA_PUT_U32(msg, NL80211_ATTR_CHANNEL_WIDTH,
+				    chanmode_selected->width);
+			NLA_PUT_U32(msg, NL80211_ATTR_CENTER_FREQ1,
+				    freq + chanmode_selected->freq1_diff);
+			if (chanmode_selected->chantype != -1)
+				NLA_PUT_U32(msg,
+					    NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+					    chanmode_selected->chantype);
+
 			argv++;
 			argc--;
 		}
@@ -164,7 +194,7 @@ COMMAND(ibss, leave, NULL,
 	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
 	"Leave the current IBSS cell.");
 COMMAND(ibss, join,
-	"<SSID> <freq in MHz> [HT20|HT40+|HT40-|NOHT] [fixed-freq] [<fixed bssid>] [beacon-interval <TU>]"
+	"<SSID> <freq in MHz> [HT20|HT40+|HT40-|NOHT|5MHZ|10MHZ] [fixed-freq] [<fixed bssid>] [beacon-interval <TU>]"
 	" [basic-rates <rate in Mbps,rate2,...>] [mcast-rate <rate in Mbps>] "
 	"[key d:0:abcde]",
 	NL80211_CMD_JOIN_IBSS, 0, CIB_NETDEV, join_ibss,
-- 
1.7.10.4

