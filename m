Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:35575 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3DSUji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 16:39:38 -0400
Date: Fri, 19 Apr 2013 22:39:05 +0200
From: Joerg Mayer <jmayer@loplof.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2] iw: Deocde some more IEs
Message-ID: <20130419203905.GA15678@rhrk.uni-kl.de> (sfid-20130419_223942_492307_9749A9B7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small update, found while verifying against the standard.

Thanks
    Jörg

The results of a boring train ride:
- Decode some IEs sent by other traveller's devices
  + IBSS ATIM window
  + TPC report
  + Old ERP IE (802.11g D4.0)
- Tiny whitespace fix
- Add Unit 'TUs' to beacon interval.

v2: TPC: Link margin element is not used in beacons

In case this project requires a sob:
Signed-off-by: Joerg Mayer <jmayer@loplof.de>

diff --git a/scan.c b/scan.c
index dfb78c0..0863ad0 100644
--- a/scan.c
+++ b/scan.c
@@ -285,6 +285,12 @@ static void print_powerconstraint(const uint8_t type, uint8_t len, const uint8_t
 	printf(" %d dB\n", data[0]);
 }
 
+static void print_tpcreport(const uint8_t type, uint8_t len, const uint8_t *data)
+{
+	printf(" TX power: %d dBm\n", data[0]);
+	/* printf(" Link Margin (%d dB) is reserved in Beacons\n", data[1]); */
+}
+
 static void print_erp(const uint8_t type, uint8_t len, const uint8_t *data)
 {
 	if (data[0] == 0x00)
@@ -693,6 +699,11 @@ static void print_tim(const uint8_t type, uint8_t len, const uint8_t *data)
 	printf("\n");
 }
 
+static void print_ibssatim(const uint8_t type, uint8_t len, const uint8_t *data)
+{
+	printf(" %d TUs", (data[1] << 8) + data[0]);
+}
+
 static void print_vht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
 {
 	printf("\n");
@@ -791,11 +802,14 @@ static const struct ie_print ieprinters[] = {
 	[1] = { "Supported rates", print_supprates, 0, 255, BIT(PRINT_SCAN), },
 	[3] = { "DS Parameter set", print_ds, 1, 1, BIT(PRINT_SCAN), },
 	[5] = { "TIM", print_tim, 4, 255, BIT(PRINT_SCAN), },
+	[6] = { "IBSS ATIM window", print_ibssatim, 2, 2, BIT(PRINT_SCAN), },
 	[7] = { "Country", print_country, 3, 255, BIT(PRINT_SCAN), },
 	[11] = { "BSS Load", print_bss_load, 5, 5, BIT(PRINT_SCAN), },
 	[32] = { "Power constraint", print_powerconstraint, 1, 1, BIT(PRINT_SCAN), },
+	[35] = { "TPC report", print_tpcreport, 2, 2, BIT(PRINT_SCAN), },
 	[42] = { "ERP", print_erp, 1, 255, BIT(PRINT_SCAN), },
 	[45] = { "HT capabilities", print_ht_capa, 26, 26, BIT(PRINT_SCAN), },
+	[47] = { "ERP D4.0", print_erp, 1, 255, BIT(PRINT_SCAN), },
 	[74] = { "Overlapping BSS scan params", print_obss_scan_params, 14, 255, BIT(PRINT_SCAN), },
 	[61] = { "HT operation", print_ht_op, 22, 22, BIT(PRINT_SCAN), },
 	[62] = { "Secondary Channel Offset", print_secchan_offs, 1, 1, BIT(PRINT_SCAN), },
@@ -1378,7 +1393,7 @@ static int print_bss_handler(struct nl_msg *msg, void *arg)
 			is_dmg = true;
 	}
 	if (bss[NL80211_BSS_BEACON_INTERVAL])
-		printf("\tbeacon interval: %d\n",
+		printf("\tbeacon interval: %d TUs\n",
 			nla_get_u16(bss[NL80211_BSS_BEACON_INTERVAL]));
 	if (bss[NL80211_BSS_CAPABILITY]) {
 		__u16 capa = nla_get_u16(bss[NL80211_BSS_CAPABILITY]);
