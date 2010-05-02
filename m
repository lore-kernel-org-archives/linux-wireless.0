Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:43813 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab0EBULp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 May 2010 16:11:45 -0400
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [RFC v2] ibss: Added channel type in order to create HT IBSS
Date: Sun,  2 May 2010 22:10:52 +0200
Message-Id: <1272831052-23221-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When joining an IBSS, the command line parameters could be used to
create the IBSS. As such, we need to know if the user wants to create an
HT IBSS or not. This is accomplish by passing the channel type (ie ht20,
ht40- or ht40+). Default is to create a non HT IBSS.

v2: Fixed parsing order of optionnal parameters. Parse argv[0] instead
  of argv[1].

v3: Added parse_channel_type to factor some common parsing code.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 ibss.c |    9 ++++++++-
 iw.h   |    1 +
 phy.c  |   20 ++------------------
 util.c |   27 +++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/ibss.c b/ibss.c
index 4715ac8..4d22157 100644
--- a/ibss.c
+++ b/ibss.c
@@ -18,6 +18,7 @@ static int join_ibss(struct nl80211_state *state,
 {
 	char *end;
 	unsigned char abssid[6];
+	unsigned int htval;
 
 	if (argc < 2)
 		return 1;
@@ -35,6 +36,12 @@ static int join_ibss(struct nl80211_state *state,
 	argv++;
 	argc--;
 
+	if (argc && parse_channel_type(argv[0], &htval)) {
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, htval);
+		argv++;
+		argc--;
+	}
+
 	if (argc && strcmp(argv[0], "fixed-freq") == 0) {
 		NLA_PUT_FLAG(msg, NL80211_ATTR_FREQ_FIXED);
 		argv++;
@@ -73,7 +80,7 @@ static int leave_ibss(struct nl80211_state *state,
 COMMAND(ibss, leave, NULL,
 	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
 	"Leave the current IBSS cell.");
-COMMAND(ibss, join, "<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [key d:0:abcde]",
+COMMAND(ibss, join, "<SSID> <freq in MHz> [HT20|HT40+|HT40-] [fixed-freq] [<fixed bssid>] [key d:0:abcde]",
 	NL80211_CMD_JOIN_IBSS, 0, CIB_NETDEV, join_ibss,
 	"Join the IBSS cell with the given SSID, if it doesn't exist create\n"
 	"it on the given frequency. When fixed frequency is requested, don't\n"
diff --git a/iw.h b/iw.h
index d1608e8..2ab4b90 100644
--- a/iw.h
+++ b/iw.h
@@ -120,6 +120,7 @@ void mac_addr_n2a(char *mac_addr, unsigned char *arg);
 unsigned char *parse_hex(char *hex, size_t *outlen);
 
 int parse_keys(struct nl_msg *msg, char **argv, int argc);
+int parse_channel_type(const char *str, unsigned int *htval);
 
 void print_ht_mcs(const __u8 *mcs);
 void print_ampdu_length(__u8 exponent);
diff --git a/phy.c b/phy.c
index 8f8d757..a33c4e1 100644
--- a/phy.c
+++ b/phy.c
@@ -32,30 +32,14 @@ static int handle_freqchan(struct nl_msg *msg, bool chan,
 			   int argc, char **argv)
 {
 	char *end;
-	static const struct {
-		const char *name;
-		unsigned int val;
-	} htmap[] = {
-		{ .name = "HT20", .val = NL80211_CHAN_HT20, },
-		{ .name = "HT40+", .val = NL80211_CHAN_HT40PLUS, },
-		{ .name = "HT40-", .val = NL80211_CHAN_HT40MINUS, },
-	};
 	unsigned int htval = NL80211_CHAN_NO_HT;
 	unsigned int freq;
-	int i;
 
 	if (!argc || argc > 2)
 		return 1;
 
-	if (argc == 2) {
-		for (i = 0; i < ARRAY_SIZE(htmap); i++) {
-			if (strcasecmp(htmap[i].name, argv[1]) == 0) {
-				htval = htmap[i].val;
-				break;
-			}
-		}
-		if (htval == NL80211_CHAN_NO_HT)
-			return 1;
+	if (argc == 2 && !parse_channel_type(argv[1], &htval)) {
+		return 1;
 	}
 
 	if (!*argv[0])
diff --git a/util.c b/util.c
index 42c992d..9426306 100644
--- a/util.c
+++ b/util.c
@@ -338,6 +338,33 @@ int parse_keys(struct nl_msg *msg, char **argv, int argc)
 	return 2;
 }
 
+/*
+ * Convert a string "HT20", "HT40+" or "HT40-" into nl80211
+ * value. Conversion is case insensitive. Returns 1 on success, 0 on error.
+ */
+
+int parse_channel_type(const char *str, unsigned int *htval)
+{
+	static const struct {
+		const char *name;
+		unsigned int val;
+	} htmap[] = {
+		{ .name = "HT20", .val = NL80211_CHAN_HT20, },
+		{ .name = "HT40+", .val = NL80211_CHAN_HT40PLUS, },
+		{ .name = "HT40-", .val = NL80211_CHAN_HT40MINUS, },
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(htmap); i++) {
+		if (strcasecmp(htmap[i].name, str) == 0) {
+			*htval = htmap[i].val;
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 static void print_mcs_index(const __u8 *mcs)
 {
 	unsigned int mcs_bit, prev_bit = -2, prev_cont = 0;
-- 
1.7.0.4

