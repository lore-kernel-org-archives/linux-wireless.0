Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:44088 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757913Ab0EBQIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 May 2010 12:08:14 -0400
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [RFC] ibss: Added channel type in order to create HT IBSS
Date: Sun,  2 May 2010 16:12:08 +0200
Message-Id: <1272809528-11000-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When joining an IBSS, the parameters can be used to create the IBSS. As
such, we need to know if the user wants to create an HT IBSS or not.
This is accomplish by passing the channel type (ie ht20, ht40- or
ht40+). Default is to create a non HT IBSS.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
It is needed for upcoming patches regarding HT IBSS
 ibss.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/ibss.c b/ibss.c
index 4715ac8..4003a38 100644
--- a/ibss.c
+++ b/ibss.c
@@ -18,6 +18,15 @@ static int join_ibss(struct nl80211_state *state,
 {
 	char *end;
 	unsigned char abssid[6];
+	int i;
+	static const struct {
+		const char *name;
+		unsigned int val;
+	} htmap[] = {
+		{ .name = "HT20", .val = NL80211_CHAN_HT20, },
+		{ .name = "HT40+", .val = NL80211_CHAN_HT40PLUS, },
+		{ .name = "HT40-", .val = NL80211_CHAN_HT40MINUS, },
+	};
 
 	if (argc < 2)
 		return 1;
@@ -52,6 +61,22 @@ static int join_ibss(struct nl80211_state *state,
 	if (!argc)
 		return 0;
 
+	if (argc) {
+		for (i = 0; i < ARRAY_SIZE(htmap); i++) {
+			if (strcasecmp(htmap[i].name, argv[1]) == 0) {
+				NLA_PUT_U32(msg,
+					    NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+					    htmap[i].val);
+				argv++;
+				argc--;
+				break;
+			}
+		}
+	}
+
+	if (!argc)
+		return 0;
+
 	if (strcmp(*argv, "key") != 0 && strcmp(*argv, "keys") != 0)
 		return 1;
 
@@ -73,7 +98,7 @@ static int leave_ibss(struct nl80211_state *state,
 COMMAND(ibss, leave, NULL,
 	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
 	"Leave the current IBSS cell.");
-COMMAND(ibss, join, "<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [key d:0:abcde]",
+COMMAND(ibss, join, "<SSID> <freq in MHz> [HT20|HT40+|HT40-] [fixed-freq] [<fixed bssid>] [key d:0:abcde]",
 	NL80211_CMD_JOIN_IBSS, 0, CIB_NETDEV, join_ibss,
 	"Join the IBSS cell with the given SSID, if it doesn't exist create\n"
 	"it on the given frequency. When fixed frequency is requested, don't\n"
-- 
1.7.0.4

