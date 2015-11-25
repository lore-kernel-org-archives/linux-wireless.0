Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37456 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbbKYN71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 08:59:27 -0500
Received: by wmww144 with SMTP id w144so70468091wmw.0
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2015 05:59:26 -0800 (PST)
From: Sven Eckelmann <sven@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Julian Calaby <julian.calaby@gmail.com>,
	Sven Eckelmann <sven@open-mesh.com>
Subject: [PATCH v3 1/4] iw: prepare get_cf1 for use in join_* functions
Date: Wed, 25 Nov 2015 14:59:15 +0100
Message-Id: <1448459959-23641-1-git-send-email-sven@open-mesh.com> (sfid-20151125_145931_857597_60A458AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chanmode structure and the function get_cf1 to calculate the center
frequency one can be used by not only the ibss join code but also by the
mesh and ocb join code.

Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
---
v3:
 * split patch into two different patches (0001/0002) as request by
   Julian Calaby <julian.calaby@gmail.com>
 * change join_ocb to also use get_cf1
 * move NOHT to the last entry in the mesh/ibss join usage texts as
   requested by Julian Calaby <julian.calaby@gmail.com>
v2:
 * rebase from v4.3-ish version to current master

 ibss.c | 33 ---------------------------------
 iw.h   |  9 +++++++++
 mesh.c | 10 +++-------
 util.c | 26 ++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/ibss.c b/ibss.c
index 024981a..a761794 100644
--- a/ibss.c
+++ b/ibss.c
@@ -16,39 +16,6 @@
 
 SECTION(ibss);
 
-struct chanmode {
-	const char *name;
-	unsigned int width;
-	int freq1_diff;
-	int chantype; /* for older kernel */
-};
-
-static int get_cf1(const struct chanmode *chanmode, unsigned long freq)
-{
-	unsigned int cf1 = freq, j;
-	unsigned int vht80[] = { 5180, 5260, 5500, 5580, 5660, 5745 };
-
-	switch (chanmode->width) {
-	case NL80211_CHAN_WIDTH_80:
-	        /* setup center_freq1 */
-		for (j = 0; j < ARRAY_SIZE(vht80); j++) {
-			if (freq >= vht80[j] && freq < vht80[j] + 80)
-				break;
-		}
-
-		if (j == ARRAY_SIZE(vht80))
-			break;
-
-		cf1 = vht80[j] + 30;
-		break;
-	default:
-		cf1 = freq + chanmode->freq1_diff;
-		break;
-	}
-
-	return cf1;
-}
-
 static int join_ibss(struct nl80211_state *state,
 		     struct nl_msg *msg,
 		     int argc, char **argv,
diff --git a/iw.h b/iw.h
index 263e8b1..d91a33e 100644
--- a/iw.h
+++ b/iw.h
@@ -59,6 +59,13 @@ struct cmd {
 	const struct cmd *parent;
 };
 
+struct chanmode {
+	const char *name;
+	unsigned int width;
+	int freq1_diff;
+	int chantype; /* for older kernel */
+};
+
 #define ARRAY_SIZE(ar) (sizeof(ar)/sizeof(ar[0]))
 #define DIV_ROUND_UP(x, y) (((x) + (y - 1)) / (y))
 
@@ -174,6 +181,8 @@ void print_ies(unsigned char *ie, int ielen, bool unknown,
 void parse_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen);
 void iw_hexdump(const char *prefix, const __u8 *data, size_t len);
 
+int get_cf1(const struct chanmode *chanmode, unsigned long freq);
+
 #define SCHED_SCAN_OPTIONS "interval <in_msecs> [delay <in_secs>] " \
 	"[freqs <freq>+] [matches [ssid <ssid>]+]] [active [ssid <ssid>]+|passive] [randomise[=<addr>/<mask>]]"
 int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv);
diff --git a/mesh.c b/mesh.c
index f2415f3..593ab7a 100644
--- a/mesh.c
+++ b/mesh.c
@@ -448,12 +448,8 @@ static int join_mesh(struct nl80211_state *state,
 	char *end, *value = NULL, *sptr = NULL;
 	unsigned int i;
 	unsigned long freq = 0;
-	static const struct {
-		const char *name;
-		unsigned int width;
-		int freq1_diff;
-		int chantype; /* for older kernel */
-	} *chanmode_selected = NULL, chanmode[] = {
+	const struct chanmode *chanmode_selected = NULL;
+	static const struct chanmode chanmode[] = {
 		{ .name = "HT20",
 		  .width = NL80211_CHAN_WIDTH_20,
 		  .freq1_diff = 0,
@@ -506,7 +502,7 @@ static int join_mesh(struct nl80211_state *state,
 			NLA_PUT_U32(msg, NL80211_ATTR_CHANNEL_WIDTH,
 				    chanmode_selected->width);
 			NLA_PUT_U32(msg, NL80211_ATTR_CENTER_FREQ1,
-				    freq + chanmode_selected->freq1_diff);
+				    get_cf1(chanmode_selected, freq));
 			if (chanmode_selected->chantype != -1)
 				NLA_PUT_U32(msg,
 					    NL80211_ATTR_WIPHY_CHANNEL_TYPE,
diff --git a/util.c b/util.c
index 55e1e26..da3be32 100644
--- a/util.c
+++ b/util.c
@@ -726,3 +726,29 @@ void iw_hexdump(const char *prefix, const __u8 *buf, size_t size)
 	}
 	printf("\n\n");
 }
+
+int get_cf1(const struct chanmode *chanmode, unsigned long freq)
+{
+	unsigned int cf1 = freq, j;
+	unsigned int vht80[] = { 5180, 5260, 5500, 5580, 5660, 5745 };
+
+	switch (chanmode->width) {
+	case NL80211_CHAN_WIDTH_80:
+	        /* setup center_freq1 */
+		for (j = 0; j < ARRAY_SIZE(vht80); j++) {
+			if (freq >= vht80[j] && freq < vht80[j] + 80)
+				break;
+		}
+
+		if (j == ARRAY_SIZE(vht80))
+			break;
+
+		cf1 = vht80[j] + 30;
+		break;
+	default:
+		cf1 = freq + chanmode->freq1_diff;
+		break;
+	}
+
+	return cf1;
+}
-- 
2.6.2

