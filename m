Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934907AbZLHBzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 20:55:21 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] iw: add HT capability parsing for scanning
Date: Mon,  7 Dec 2009 20:55:25 -0500
Message-Id: <1260237325-8654-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds HT capability IE parsing for scanning. You will now
be able to easily review what HT capabilities your AP supports
with a simple iw scan.

Sreenshot of a scan result of a 1-stream AP:

BSS 00:03:7f:12:34:56 (on wlan6)
        TSF: 1817911860 usec (0d, 00:30:17)
        freq: 2427
        beacon interval: 100
        capability: ESS ShortPreamble SpectrumMgmt ShortSlotTime (0x0521)
        signal: -60.00 dBm
        last seen: 11390 ms ago
        SSID: sucia-perra
        Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
        DS Parameter set: channel 4
        Power constraint: 0 dB
        ERP: <no flags>
        Extended supported rates: 24.0 36.0 48.0 54.0
        HT capabilities:
                Capabilities: 0x010c
                        HT20
                        SM Power Save disabled
                        RX STBC 1-stream
                        Max AMSDU length: 7935 bytes
                        No DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 1/2 usec (0x02)
                MCS set:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff
                Supported RX MCS Indexes:
                        MCS Index 0
                        MCS Index 1
                        MCS Index 2
                        MCS Index 3
                        MCS Index 4
                        MCS Index 5
                        MCS Index 6
                        MCS Index 7
                No TX MCS set defined
        Extended capabilities: HT Information Exchange Supported
        WMM:    * Parameter version 1
                * u-APSD
                * BE: CW 15-1023, AIFSN 3
                * BK: CW 15-1023, AIFSN 7
                * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 scan.c |  175 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 175 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 99df462..1889bd0 100644
--- a/scan.c
+++ b/scan.c
@@ -421,6 +421,180 @@ static void print_rsn(const uint8_t type, uint8_t len, const uint8_t *data)
 	print_rsn_ie("CCMP", "IEEE 802.1X", len, data);
 }
 
+/*
+ * There are only 4 possible values, we just use a case instead of computing it,
+ * but technically this can also be computed through the formula:
+ *
+ * Max AMPDU length = (2 ^ (13 + exponent)) - 1 bytes
+ */
+__u32 compute_ampdu_length(__u8 exponent)
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
+const char *print_ampdu_space(__u8 space)
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
+static void print_ht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
+{
+#define PRINT_HT_CAP(_cond, _str) \
+	do { \
+		if (_cond) \
+			printf("\t\t\t" _str "\n"); \
+	} while (0)
+	struct ht_cap_data {
+		__u16 cap;
+		__u8 ampdu_params;
+		struct {
+			__u8 rx_mcs_bitmask[10]; /* last 3 bits reserved */
+			__u16 max_rx_rate_1mbps: 10,
+			      reserved_0: 6;
+			__u8 tx_rx_mcs_defined:1,
+			     tx_rx_mcs_not_equal:1,
+			     tx_max_streams:2,
+			     tx_unequal_modulation:1,
+			     reserved_1:3; /* 3 reserved bits here */
+			__u8 reserved_2[3]; /* 24 reserved bits here = 27 */
+		} mcs_set;
+		__u16 ht_extend_cap;
+		__u32 tx_beamform_cap;
+		__u8 asel_cap;
+	} __attribute__((packed)) ht_cap;
+	struct ht_cap_data *htc = &ht_cap;
+	__u8 ampdu_exponent, ampdu_spacing, bit;
+	__u32 max_ampdu_length, i;
+	bool tx_rx_mcs_equal = false;
+
+	if (len != 26) {
+		printf("\n\t\tHT Capability IE len != expected 26 bytes, skipping parse\n");
+		return;
+	}
+
+	memcpy(&ht_cap, data, 26);
+
+	printf("\n\t\tCapabilities: %#.4x\n", htc->cap);
+
+	PRINT_HT_CAP((htc->cap & BIT(0)), "RX LDCP");
+	PRINT_HT_CAP((htc->cap & BIT(1)), "HT20/HT40");
+	PRINT_HT_CAP(!(htc->cap & BIT(1)), "HT20");
+
+	PRINT_HT_CAP(((htc->cap >> 2) & 0x3) == 0, "Static SM Power Save");
+	PRINT_HT_CAP(((htc->cap >> 2) & 0x3) == 1, "Dynamic SM Power Save");
+	PRINT_HT_CAP(((htc->cap >> 2) & 0x3) == 3, "SM Power Save disabled");
+
+	PRINT_HT_CAP((htc->cap & BIT(4)), "RX Greenfield");
+	PRINT_HT_CAP((htc->cap & BIT(5)), "RX HT20 SGI");
+	PRINT_HT_CAP((htc->cap & BIT(6)), "RX HT40 SGI");
+	PRINT_HT_CAP((htc->cap & BIT(7)), "TX STBC");
+
+	PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 0, "No RX STBC");
+	PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 1, "RX STBC 1-stream");
+	PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 2, "RX STBC 2-streams");
+	PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 3, "RX STBC 3-streams");
+
+	PRINT_HT_CAP((htc->cap & BIT(10)), "HT Delayed Block Ack");
+
+	PRINT_HT_CAP((htc->cap & BIT(11)), "Max AMSDU length: 3839 bytes");
+        PRINT_HT_CAP(!(htc->cap & BIT(11)), "Max AMSDU length: 7935 bytes");
+
+	/*
+	 * For beacons and probe response this would mean the BSS
+	 * does or does not allow the usage of DSSS/CCK HT40.
+	 * Otherwise it means the STA does or does not use
+	 * DSSS/CCK HT40.
+	 */
+	PRINT_HT_CAP((htc->cap & BIT(12)), "DSSS/CCK HT40");
+	PRINT_HT_CAP(!(htc->cap & BIT(12)), "No DSSS/CCK HT40");
+
+	/* BIT(13) is reserved */
+
+	PRINT_HT_CAP((htc->cap & BIT(14)), "40 MHz Intolerant");
+
+	PRINT_HT_CAP((htc->cap & BIT(15)), "L-SIG TXOP protection");
+
+	ampdu_exponent = htc->ampdu_params & 0x3;
+	max_ampdu_length = compute_ampdu_length(ampdu_exponent);
+	if (max_ampdu_length) {
+		printf("\t\tMaximum RX AMPDU length %d bytes (exponent: 0x0%02x)\n",
+		       compute_ampdu_length(ampdu_exponent), ampdu_exponent);
+	}
+	else
+		printf("\t\tMaximum RX AMPDU length: unrecognized bytes "
+		       "(exponent: %d)\n", ampdu_exponent);
+
+
+	ampdu_spacing = (htc->ampdu_params >> 2) & 0x3 ;
+	printf("\t\tMinimum RX AMPDU time spacing: %s (0x%02x)\n",
+	       print_ampdu_space(ampdu_spacing), ampdu_spacing);
+
+	/* This is the whole MCS set, which is 16 bytes */
+	printf("\t\tMCS set: ");
+	data+=2;
+	for (i = 15; i != 0; i--) {
+		printf(" %.2x", data[i]);
+	}
+	printf("\n");
+
+	if (htc->mcs_set.tx_rx_mcs_defined && htc->mcs_set.tx_rx_mcs_not_equal)
+		tx_rx_mcs_equal = true;
+	if (tx_rx_mcs_equal)
+		printf("\t\tSupported TX/RX MCS Indexes:\n");
+	else
+		printf("\t\tSupported RX MCS Indexes:\n");
+	/*
+	 * Parses the RX MCS rates. Only 10 bits correspond to actual MCS rates
+	 * MCS [0-76]
+	 */
+	for (i = 0; i < 10; i++) {
+		for (bit = 0; bit < 8; bit++) {
+			/* Only bits 0-76 are valid, bits 76-79 are reserved */
+			if (((i * 8) + bit) > 76)
+				break;
+			if (htc->mcs_set.rx_mcs_bitmask[i] & BIT(bit))
+				printf("\t\t\tMCS Index %d\n",
+				       (i * 8) + bit);
+		}
+	}
+
+	if (!htc->mcs_set.tx_rx_mcs_defined) {
+		/* This is actually quite common */
+		printf("\t\tNo TX MCS set defined\n");
+		goto out;
+	}
+
+	if (htc->mcs_set.tx_rx_mcs_not_equal) {
+		printf("\t\tMaximum supported TX spatial streams: %d\n",
+		       htc->mcs_set.tx_max_streams);
+		printf("\t\tTX unequal modulation ");
+		if (htc->mcs_set.tx_unequal_modulation)
+			printf("supported\n");
+		else
+			printf("unsupported\n");
+	}
+
+out:
+	return;
+}
+
 static void print_capabilities(const uint8_t type, uint8_t len, const uint8_t *data)
 {
 	int i, base, bit;
@@ -518,6 +692,7 @@ static const struct ie_print ieprinters[] = {
 	[7] = { "Country", print_country, 3, 255, BIT(PRINT_SCAN), },
 	[32] = { "Power constraint", print_powerconstraint, 1, 1, BIT(PRINT_SCAN), },
 	[42] = { "ERP", print_erp, 1, 255, BIT(PRINT_SCAN), },
+	[45] = { "HT capabilities", print_ht_capa, 1, 255, BIT(PRINT_SCAN), },
 	[48] = { "RSN", print_rsn, 2, 255, BIT(PRINT_SCAN), },
 	[50] = { "Extended supported rates", print_supprates, 0, 255, BIT(PRINT_SCAN), },
 	[127] = { "Extended capabilities", print_capabilities, 0, 255, BIT(PRINT_SCAN), },
-- 
1.6.3.3

