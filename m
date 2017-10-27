Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from james.theweblords.de ([217.11.55.87]:41605 "EHLO
        james.theweblords.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932190AbdJ0Vts (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 17:49:48 -0400
From: =?UTF-8?q?Peter=20Gro=C3=9Fe?= <pegro@friiks.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] ocb: Use common freqchan helper for setting the operating channel
Date: Fri, 27 Oct 2017 23:43:02 +0200
Message-Id: <20171027214302.4059-1-pegro@friiks.de> (sfid-20171027_234951_614097_424C518F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify code by using the helper which has been introduced earlier.

Signed-off-by: Peter Große <pegro@friiks.de>
---
 ocb.c | 50 ++++++++------------------------------------------
 1 file changed, 8 insertions(+), 42 deletions(-)

diff --git a/ocb.c b/ocb.c
index bcf0474..dfdaf59 100644
--- a/ocb.c
+++ b/ocb.c
@@ -10,56 +10,22 @@ static int join_ocb(struct nl80211_state *state,
 		    struct nl_msg *msg, int argc, char **argv,
 		    enum id_input id)
 {
-	unsigned long freq;
-	char *end;
-	unsigned int i;
-	const struct chanmode *chanmode_selected = NULL;
-	static const struct chanmode chanmode[] = {
-		{ .name = "5MHz",
-		  .width = NL80211_CHAN_WIDTH_5,
-		  .freq1_diff = 0,
-		  .chantype = -1 },
-		{ .name = "10MHz",
-		  .width = NL80211_CHAN_WIDTH_10,
-		  .freq1_diff = 0,
-		  .chantype = -1 },
-	};
+	struct chandef chandef;
+	int err, parsed;
 
 	if (argc < 2)
 		return 1;
 
-	/* freq */
-	freq = strtoul(argv[0], &end, 10);
-	if (*end != '\0')
-		return 1;
-
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
-	argv++;
-	argc--;
+	err = parse_freqchan(&chandef, false, argc, argv, &parsed);
 
-	/* channel width */
-	for (i = 0; i < ARRAY_SIZE(chanmode); i++) {
-		if (strcasecmp(chanmode[i].name, argv[0]) == 0) {
-			chanmode_selected = &chanmode[i];
-			break;
-		}
-	}
-	if (chanmode_selected) {
-		NLA_PUT_U32(msg, NL80211_ATTR_CHANNEL_WIDTH,
-			    chanmode_selected->width);
-		NLA_PUT_U32(msg, NL80211_ATTR_CENTER_FREQ1,
-			    get_cf1(chanmode_selected, freq));
+	if (err)
+		return err;
 
-		argv++;
-		argc--;
-	} else {
-		return 1;
-	}
+	put_chandef(msg, &chandef);
+	if (err)
+		return err;
 
 	return 0;
-
-nla_put_failure:
-	return -ENOBUFS;
 }
 COMMAND(ocb, join, "<freq in MHz> <5MHz|10MHz>",
 	NL80211_CMD_JOIN_OCB, 0, CIB_NETDEV, join_ocb,
-- 
2.13.6
