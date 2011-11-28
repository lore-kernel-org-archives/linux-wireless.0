Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40703 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab1K1R4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 12:56:23 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] iw: add HT options for ibss
Date: Mon, 28 Nov 2011 18:55:17 +0100
Message-Id: <1322502917-28205-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111128_185628_553057_1BB45565)
In-Reply-To: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow to set a specific HT mode for ibss_join.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 ibss.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/ibss.c b/ibss.c
index b70dee3..4b43095 100644
--- a/ibss.c
+++ b/ibss.c
@@ -3,6 +3,7 @@
 #endif
 #include <errno.h>
 #include <string.h>
+#include <strings.h>
 
 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
@@ -27,6 +28,18 @@ static int join_ibss(struct nl80211_state *state,
 	char *value = NULL, *sptr = NULL;
 	float rate;
 	int bintval;
+	int i;
+	static const struct {
+		const char *name;
+		unsigned int val;
+	} htmap[] = {
+		{ .name = "HT20", .val = NL80211_CHAN_HT20, },
+		{ .name = "HT40+", .val = NL80211_CHAN_HT40PLUS, },
+		{ .name = "HT40-", .val = NL80211_CHAN_HT40MINUS, },
+		{ .name = "NOHT", .val = NL80211_CHAN_NO_HT, },
+	};
+	unsigned int htval = NL80211_CHAN_NO_HT;
+
 
 	if (argc < 2)
 		return 1;
@@ -44,6 +57,22 @@ static int join_ibss(struct nl80211_state *state,
 	argv++;
 	argc--;
 
+	if (argc) {
+		for (i = 0; i < ARRAY_SIZE(htmap); i++) {
+			if (strcasecmp(htmap[i].name, argv[0]) == 0) {
+				htval = htmap[i].val;
+				break;
+			}
+		}
+		if (i != ARRAY_SIZE(htmap)) {
+			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+				    htval);
+			argv++;
+			argc--;
+		}
+
+	}
+
 	if (argc && strcmp(argv[0], "fixed-freq") == 0) {
 		NLA_PUT_FLAG(msg, NL80211_ATTR_FREQ_FIXED);
 		argv++;
@@ -134,7 +163,7 @@ COMMAND(ibss, leave, NULL,
 	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
 	"Leave the current IBSS cell.");
 COMMAND(ibss, join,
-	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [beacon-interval <TU>]"
+	"<SSID> <freq in MHz> [HT20|HT40+|HT40-|NOHT] [fixed-freq] [<fixed bssid>] [beacon-interval <TU>]"
 	" [basic-rates <rate in Mbps,rate2,...>] [mcast-rate <rate in Mbps>] "
 	"[key d:0:abcde]",
 	NL80211_CMD_JOIN_IBSS, 0, CIB_NETDEV, join_ibss,
-- 
1.7.7.3

