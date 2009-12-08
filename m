Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45515 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbZLHDFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 22:05:12 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] iw: share mimumum ampdu spacing and maximum ampdu length prints
Date: Mon,  7 Dec 2009 22:05:18 -0500
Message-Id: <1260241518-22576-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This brings together the two separate compuations for ampdu spacing
and length to help being more consistant with terminology and with the
spec.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 info.c |   21 ++++-----------------
 iw.h   |    2 ++
 scan.c |   50 ++++----------------------------------------------
 util.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 64 insertions(+), 63 deletions(-)

diff --git a/info.c b/info.c
index c80a11f..d7a7d48 100644
--- a/info.c
+++ b/info.c
@@ -126,25 +126,12 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 			PBCOM(0x8000, "L-SIG TXOP protection support");
 		}
 		if (tb_band[NL80211_BAND_ATTR_HT_AMPDU_FACTOR]) {
-			unsigned char factor = nla_get_u8(tb_band[NL80211_BAND_ATTR_HT_AMPDU_FACTOR]);
-			printf("\t\tHT A-MPDU factor: 0x%.4x (%d bytes)\n", factor, (1<<(13+factor))-1);
+			__u8 exponent = nla_get_u8(tb_band[NL80211_BAND_ATTR_HT_AMPDU_FACTOR]);
+			print_ampdu_length(exponent);
 		}
 		if (tb_band[NL80211_BAND_ATTR_HT_AMPDU_DENSITY]) {
-			unsigned char dens = nla_get_u8(tb_band[NL80211_BAND_ATTR_HT_AMPDU_DENSITY]);
-			printf("\t\tHT A-MPDU density: 0x%.4x (", dens);
-			switch (dens) {
-			case 0:
-				printf("no restriction)\n");
-				break;
-			case 1:
-				printf("1/4 usec)\n");
-				break;
-			case 2:
-				printf("1/2 usec)\n");
-				break;
-			default:
-				printf("%d usec)\n", 1<<(dens - 3));
-			}
+			__u8 spacing = nla_get_u8(tb_band[NL80211_BAND_ATTR_HT_AMPDU_DENSITY]);
+			print_ampdu_spacing(spacing);
 		}
 		if (tb_band[NL80211_BAND_ATTR_HT_MCS_SET] &&
 		    nla_len(tb_band[NL80211_BAND_ATTR_HT_MCS_SET]) == 16) {
diff --git a/iw.h b/iw.h
index ef22737..d3b805a 100644
--- a/iw.h
+++ b/iw.h
@@ -121,6 +121,8 @@ void mac_addr_n2a(char *mac_addr, unsigned char *arg);
 int parse_keys(struct nl_msg *msg, char **argv, int argc);
 
 void print_mcs_set(const uint8_t *data);
+void print_ampdu_length(__u8 exponent);
+void print_ampdu_spacing(__u8 spacing);
 
 const char *iftype_name(enum nl80211_iftype iftype);
 const char *command_name(enum nl80211_commands cmd);
diff --git a/scan.c b/scan.c
index 973d690..6268f3d 100644
--- a/scan.c
+++ b/scan.c
@@ -421,39 +421,6 @@ static void print_rsn(const uint8_t type, uint8_t len, const uint8_t *data)
 	print_rsn_ie("CCMP", "IEEE 802.1X", len, data);
 }
 
-/*
- * There are only 4 possible values, we just use a case instead of computing it,
- * but technically this can also be computed through the formula:
- *
- * Max AMPDU length = (2 ^ (13 + exponent)) - 1 bytes
- */
-__u32 compute_ampdu_length(__u8 exponent)
-{
-	switch (exponent) {
-	case 0: return 8191;  /* (2 ^(13 + 0)) -1 */
-	case 1: return 16383; /* (2 ^(13 + 1)) -1 */
-	case 2: return 32767; /* (2 ^(13 + 2)) -1 */
-	case 3: return 65535; /* (2 ^(13 + 3)) -1 */
-	default: return 0;
-	}
-}
-
-const char *print_ampdu_space(__u8 space)
-{
-	switch (space) {
-	case 0: return "No restriction";
-	case 1: return "1/4 usec";
-	case 2: return "1/2 usec";
-	case 3: return "1 usec";
-	case 4: return "2 usec";
-	case 5: return "4 usec";
-	case 6: return "8 usec";
-	case 7: return "16 usec";
-	default:
-		return "Uknown";
-	}
-}
-
 static void print_ht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
 {
 #define PRINT_HT_CAP(_cond, _str) \
@@ -481,7 +448,7 @@ static void print_ht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
 	} __attribute__((packed)) ht_cap;
 	struct ht_cap_data *htc = &ht_cap;
 	__u8 ampdu_exponent, ampdu_spacing, bit;
-	__u32 max_ampdu_length, i;
+	__u32 i;
 	bool tx_rx_mcs_equal = false;
 
 	if (len != 26) {
@@ -532,19 +499,10 @@ static void print_ht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
 	PRINT_HT_CAP((htc->cap & BIT(15)), "L-SIG TXOP protection");
 
 	ampdu_exponent = htc->ampdu_params & 0x3;
-	max_ampdu_length = compute_ampdu_length(ampdu_exponent);
-	if (max_ampdu_length) {
-		printf("\t\tMaximum RX AMPDU length %d bytes (exponent: 0x0%02x)\n",
-		       compute_ampdu_length(ampdu_exponent), ampdu_exponent);
-	}
-	else
-		printf("\t\tMaximum RX AMPDU length: unrecognized bytes "
-		       "(exponent: %d)\n", ampdu_exponent);
-
+	print_ampdu_length(ampdu_exponent);
 
-	ampdu_spacing = (htc->ampdu_params >> 2) & 0x3 ;
-	printf("\t\tMinimum RX AMPDU time spacing: %s (0x%02x)\n",
-	       print_ampdu_space(ampdu_spacing), ampdu_spacing);
+	ampdu_spacing = (htc->ampdu_params >> 2) & 0x3;
+	print_ampdu_spacing(ampdu_spacing);
 
 	/* This is the whole MCS set, which is 16 bytes */
 	printf("\t\tMCS set:");
diff --git a/util.c b/util.c
index 3b6fa47..1424a58 100644
--- a/util.c
+++ b/util.c
@@ -301,3 +301,57 @@ void print_mcs_set(const uint8_t *data)
                 printf(" %.2x", data[i]);
         }
 }
+
+/*
+ * There are only 4 possible values, we just use a case instead of computing it,
+ * but technically this can also be computed through the formula:
+ *
+ * Max AMPDU length = (2 ^ (13 + exponent)) - 1 bytes
+ */
+static __u32 compute_ampdu_length(__u8 exponent)
+{
+	switch (exponent) {
+	case 0: return 8191;  /* (2 ^(13 + 0)) -1 */
+	case 1: return 16383; /* (2 ^(13 + 1)) -1 */
+	case 2: return 32767; /* (2 ^(13 + 2)) -1 */
+	case 3: return 65535; /* (2 ^(13 + 3)) -1 */
+	default: return 0;
+	}
+}
+
+static const char *print_ampdu_space(__u8 space)
+{
+	switch (space) {
+	case 0: return "No restriction";
+	case 1: return "1/4 usec";
+	case 2: return "1/2 usec";
+	case 3: return "1 usec";
+	case 4: return "2 usec";
+	case 5: return "4 usec";
+	case 6: return "8 usec";
+	case 7: return "16 usec";
+	default:
+		return "Uknown";
+	}
+}
+
+void print_ampdu_length(__u8 exponent)
+{
+	__u8 max_ampdu_length;
+
+	max_ampdu_length = compute_ampdu_length(exponent);
+
+	if (max_ampdu_length) {
+		printf("\t\tMaximum RX AMPDU length %d bytes (exponent: 0x0%02x)\n",
+		       max_ampdu_length, exponent);
+        } else {
+		printf("\t\tMaximum RX AMPDU length: unrecognized bytes "
+		       "(exponent: %d)\n", exponent);
+	}
+}
+
+void print_ampdu_spacing(__u8 spacing)
+{
+        printf("\t\tMinimum RX AMPDU time spacing: %s (0x%02x)\n",
+               print_ampdu_space(spacing), spacing);
+}
-- 
1.6.3.3

