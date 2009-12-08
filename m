Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933714AbZLHDFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 22:05:36 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] iw: bring together common ht capability parsing
Date: Mon,  7 Dec 2009 22:05:42 -0500
Message-Id: <1260241542-22959-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both 'iw list' and 'iw dev wlan0 scan' now share the same
HT capability parsing code making them consistent.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 info.c |   37 ++-----------------------------------
 iw.h   |    1 +
 scan.c |   40 ++--------------------------------------
 util.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 73 deletions(-)

diff --git a/info.c b/info.c
index d7a7d48..9de7458 100644
--- a/info.c
+++ b/info.c
@@ -89,41 +89,8 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 
 #ifdef NL80211_BAND_ATTR_HT_CAPA
 		if (tb_band[NL80211_BAND_ATTR_HT_CAPA]) {
-			unsigned short cap = nla_get_u16(tb_band[NL80211_BAND_ATTR_HT_CAPA]);
-#define PCOM(fmt, args...) do { printf("\t\t\t* " fmt "\n", ##args); } while (0)
-#define PBCOM(bit, args...) if (cap & (bit)) PCOM(args)
-			printf("\t\tHT capabilities: 0x%.4x\n", cap);
-			PBCOM(0x0001, "LPDC coding");
-			if (cap & 0x0002)
-				PCOM("20/40 MHz operation");
-			else
-				PCOM("20 MHz operation");
-			switch ((cap & 0x000c) >> 2) {
-			case 0:
-				PCOM("static SM PS");
-				break;
-			case 1:
-				PCOM("dynamic SM PS");
-				break;
-			case 2:
-				PCOM("reserved SM PS");
-				break;
-			case 3:
-				PCOM("SM PS disabled");
-				break;
-			}
-			PBCOM(0x0010, "HT-greenfield");
-			PBCOM(0x0020, "20 MHz short GI");
-			PBCOM(0x0040, "40 MHz short GI");
-			PBCOM(0x0080, "TX STBC");
-			if (cap & 0x300)
-				PCOM("RX STBC %d streams", (cap & 0x0300) >> 8);
-			PBCOM(0x0400, "HT-delayed block-ack");
-			PCOM("max A-MSDU len %d", 0xeff + ((cap & 0x0800) << 1));
-			PBCOM(0x1000, "DSSS/CCK 40 MHz");
-			PBCOM(0x2000, "PSMP support");
-			PBCOM(0x4000, "40 MHz intolerant");
-			PBCOM(0x8000, "L-SIG TXOP protection support");
+			__u16 cap = nla_get_u16(tb_band[NL80211_BAND_ATTR_HT_CAPA]);
+			print_ht_capability(cap);
 		}
 		if (tb_band[NL80211_BAND_ATTR_HT_AMPDU_FACTOR]) {
 			__u8 exponent = nla_get_u8(tb_band[NL80211_BAND_ATTR_HT_AMPDU_FACTOR]);
diff --git a/iw.h b/iw.h
index d3b805a..a754561 100644
--- a/iw.h
+++ b/iw.h
@@ -123,6 +123,7 @@ int parse_keys(struct nl_msg *msg, char **argv, int argc);
 void print_mcs_set(const uint8_t *data);
 void print_ampdu_length(__u8 exponent);
 void print_ampdu_spacing(__u8 spacing);
+void print_ht_capability(__u16 cap);
 
 const char *iftype_name(enum nl80211_iftype iftype);
 const char *command_name(enum nl80211_commands cmd);
diff --git a/scan.c b/scan.c
index 6268f3d..bf2ec55 100644
--- a/scan.c
+++ b/scan.c
@@ -458,45 +458,9 @@ static void print_ht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
 
 	memcpy(&ht_cap, data, 26);
 
-	printf("\n\t\tCapabilities: %#.4x\n", htc->cap);
-
-	PRINT_HT_CAP((htc->cap & BIT(0)), "RX LDCP");
-	PRINT_HT_CAP((htc->cap & BIT(1)), "HT20/HT40");
-	PRINT_HT_CAP(!(htc->cap & BIT(1)), "HT20");
-
-	PRINT_HT_CAP(((htc->cap >> 2) & 0x3) == 0, "Static SM Power Save");
-	PRINT_HT_CAP(((htc->cap >> 2) & 0x3) == 1, "Dynamic SM Power Save");
-	PRINT_HT_CAP(((htc->cap >> 2) & 0x3) == 3, "SM Power Save disabled");
-
-	PRINT_HT_CAP((htc->cap & BIT(4)), "RX Greenfield");
-	PRINT_HT_CAP((htc->cap & BIT(5)), "RX HT20 SGI");
-	PRINT_HT_CAP((htc->cap & BIT(6)), "RX HT40 SGI");
-	PRINT_HT_CAP((htc->cap & BIT(7)), "TX STBC");
-
-	PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 0, "No RX STBC");
-	PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 1, "RX STBC 1-stream");
-	PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 2, "RX STBC 2-streams");
-	PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 3, "RX STBC 3-streams");
-
-	PRINT_HT_CAP((htc->cap & BIT(10)), "HT Delayed Block Ack");
-
-	PRINT_HT_CAP((htc->cap & BIT(11)), "Max AMSDU length: 3839 bytes");
-        PRINT_HT_CAP(!(htc->cap & BIT(11)), "Max AMSDU length: 7935 bytes");
-
-	/*
-	 * For beacons and probe response this would mean the BSS
-	 * does or does not allow the usage of DSSS/CCK HT40.
-	 * Otherwise it means the STA does or does not use
-	 * DSSS/CCK HT40.
-	 */
-	PRINT_HT_CAP((htc->cap & BIT(12)), "DSSS/CCK HT40");
-	PRINT_HT_CAP(!(htc->cap & BIT(12)), "No DSSS/CCK HT40");
-
-	/* BIT(13) is reserved */
-
-	PRINT_HT_CAP((htc->cap & BIT(14)), "40 MHz Intolerant");
+	printf("\n");
+	print_ht_capability(htc->cap);
 
-	PRINT_HT_CAP((htc->cap & BIT(15)), "L-SIG TXOP protection");
 
 	ampdu_exponent = htc->ampdu_params & 0x3;
 	print_ampdu_length(ampdu_exponent);
diff --git a/util.c b/util.c
index 1424a58..f017b88 100644
--- a/util.c
+++ b/util.c
@@ -355,3 +355,53 @@ void print_ampdu_spacing(__u8 spacing)
         printf("\t\tMinimum RX AMPDU time spacing: %s (0x%02x)\n",
                print_ampdu_space(spacing), spacing);
 }
+
+void print_ht_capability(__u16 cap)
+{
+#define PRINT_HT_CAP(_cond, _str) \
+	do { \
+		if (_cond) \
+			printf("\t\t\t" _str "\n"); \
+	} while (0)
+
+	printf("\t\tCapabilities: 0x%02x\n", cap);
+
+	PRINT_HT_CAP((cap & BIT(0)), "RX LDCP");
+	PRINT_HT_CAP((cap & BIT(1)), "HT20/HT40");
+	PRINT_HT_CAP(!(cap & BIT(1)), "HT20");
+
+	PRINT_HT_CAP(((cap >> 2) & 0x3) == 0, "Static SM Power Save");
+	PRINT_HT_CAP(((cap >> 2) & 0x3) == 1, "Dynamic SM Power Save");
+	PRINT_HT_CAP(((cap >> 2) & 0x3) == 3, "SM Power Save disabled");
+
+	PRINT_HT_CAP((cap & BIT(4)), "RX Greenfield");
+	PRINT_HT_CAP((cap & BIT(5)), "RX HT20 SGI");
+	PRINT_HT_CAP((cap & BIT(6)), "RX HT40 SGI");
+	PRINT_HT_CAP((cap & BIT(7)), "TX STBC");
+
+	PRINT_HT_CAP(((cap >> 8) & 0x3) == 0, "No RX STBC");
+	PRINT_HT_CAP(((cap >> 8) & 0x3) == 1, "RX STBC 1-stream");
+	PRINT_HT_CAP(((cap >> 8) & 0x3) == 2, "RX STBC 2-streams");
+	PRINT_HT_CAP(((cap >> 8) & 0x3) == 3, "RX STBC 3-streams");
+
+	PRINT_HT_CAP((cap & BIT(10)), "HT Delayed Block Ack");
+
+	PRINT_HT_CAP((cap & BIT(11)), "Max AMSDU length: 3839 bytes");
+        PRINT_HT_CAP(!(cap & BIT(11)), "Max AMSDU length: 7935 bytes");
+
+	/*
+	 * For beacons and probe response this would mean the BSS
+	 * does or does not allow the usage of DSSS/CCK HT40.
+	 * Otherwise it means the STA does or does not use
+	 * DSSS/CCK HT40.
+	 */
+	PRINT_HT_CAP((cap & BIT(12)), "DSSS/CCK HT40");
+	PRINT_HT_CAP(!(cap & BIT(12)), "No DSSS/CCK HT40");
+
+	/* BIT(13) is reserved */
+
+	PRINT_HT_CAP((cap & BIT(14)), "40 MHz Intolerant");
+
+	PRINT_HT_CAP((cap & BIT(15)), "L-SIG TXOP protection");
+#undef PRINT_HT_CAP
+}
-- 
1.6.3.3

