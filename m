Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37259 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbbKXR40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 12:56:26 -0500
Received: by wmww144 with SMTP id w144so37202061wmw.0
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2015 09:56:25 -0800 (PST)
From: Sven Eckelmann <sven@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Sven Eckelmann <sven@open-mesh.com>
Subject: [PATCH v2] iw: add VHT80 support for 802.11s
Date: Tue, 24 Nov 2015 18:56:16 +0100
Message-Id: <1448387776-26601-1-git-send-email-sven@open-mesh.com> (sfid-20151124_185629_619086_B07237B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iw mesh supports non-HT and HT channel widths like HT20 or NOHT. But the
Linux 802.11s implementation also supports VHT80 which can be specified
during the mesh join.

    iw dev mesh0 mesh join "meshnet" freq 5180 80MHz

Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
---
v2: rebased from v4.3 to current master

 ibss.c | 33 ---------------------------------
 iw.h   |  9 +++++++++
 mesh.c | 16 ++++++++--------
 util.c | 26 ++++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 41 deletions(-)

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
index f2415f3..d674d61 100644
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
@@ -470,6 +466,10 @@ static int join_mesh(struct nl80211_state *state,
 		  .width = NL80211_CHAN_WIDTH_20_NOHT,
 		  .freq1_diff = 0,
 		  .chantype = NL80211_CHAN_NO_HT },
+		{ .name = "80MHz",
+		  .width = NL80211_CHAN_WIDTH_80,
+		  .freq1_diff = 0,
+		  .chantype = -1 },
 	};
 
 	if (argc < 1)
@@ -506,7 +506,7 @@ static int join_mesh(struct nl80211_state *state,
 			NLA_PUT_U32(msg, NL80211_ATTR_CHANNEL_WIDTH,
 				    chanmode_selected->width);
 			NLA_PUT_U32(msg, NL80211_ATTR_CENTER_FREQ1,
-				    freq + chanmode_selected->freq1_diff);
+				    get_cf1(chanmode_selected, freq));
 			if (chanmode_selected->chantype != -1)
 				NLA_PUT_U32(msg,
 					    NL80211_ATTR_WIPHY_CHANNEL_TYPE,
@@ -608,7 +608,7 @@ static int join_mesh(struct nl80211_state *state,
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(mesh, join, "<mesh ID> [[freq <freq in MHz> <HT20|HT40+|HT40-|NOHT>]"
+COMMAND(mesh, join, "<mesh ID> [[freq <freq in MHz> <HT20|HT40+|HT40-|NOHT|80MHz>]"
 	" [basic-rates <rate in Mbps,rate2,...>]], [mcast-rate <rate in Mbps>]"
 	" [beacon-interval <time in TUs>] [dtim-period <value>]"
 	" [vendor_sync on|off] [<param>=<value>]*",
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

