Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47166 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZEDEqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 00:46:35 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] add support for parsing WPA and RSN/WPA2 information elements
Date: Sun,  3 May 2009 21:46:21 -0700
Message-Id: <1241412381-2778-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |  156 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 150 insertions(+), 6 deletions(-)

diff --git a/scan.c b/scan.c
index 91e94ed..d383243 100644
--- a/scan.c
+++ b/scan.c
@@ -13,6 +13,9 @@
 #include "nl80211.h"
 #include "iw.h"
 
+static unsigned char vendor_oui[3] = { 0x00, 0x50, 0xf2 };
+static unsigned char cipher_oui[3] = { 0x00, 0x0f, 0xac };
+
 struct scan_params {
 	bool unknown;
 };
@@ -41,6 +44,14 @@ COMMAND(scan, trigger, NULL,
 
 typedef void (*printfn)(unsigned char type, unsigned char len, unsigned char *data);
 
+static void tab_on_first(bool *first)
+{
+	if (!*first)
+		printf("\t");
+	else
+		*first = false;
+}
+
 static void print_ssid(unsigned char type, unsigned char len, unsigned char *data)
 {
 	int i;
@@ -80,20 +91,152 @@ static void print_ign(unsigned char type, unsigned char len, unsigned char *data
 	/* ignore for now, not too useful */
 }
 
+static void print_cipher(const unsigned char *oui, unsigned char *data)
+{
+	if (memcmp(data, oui, 3) == 0) {
+		switch (data[3]) {
+		case 0x00:
+			printf("Use group cipher suite");
+			break;
+		case 0x01:
+			printf("WEP-40");
+			break;
+		case 0x02:
+			printf("TKIP");
+			break;
+		case 0x04:
+			printf("CCMP");
+			break;
+		case 0x05:
+			printf("WEP-104");
+			break;
+		default:
+			printf("Reserved (%.02x)", data[3]);
+			break;
+		}
+	} else if (memcmp(data, vendor_oui, 3) == 0)
+		printf("Vendor specific (%.02x)", data[3]);
+	else
+		printf("Other");
+}
+
+static void print_auth(const unsigned char *oui, unsigned char *data)
+{
+	if (memcmp(data, oui, 3) == 0) {
+		switch (data[3]) {
+		case 0x01:
+			printf("802.1x");
+			break;
+		case 0x02:
+			printf("PSK");
+			break;
+		default:
+			printf("Reserved (%.02x)", data[3]);
+			break;
+		}
+	} else if (memcmp(data, vendor_oui, 3) == 0)
+		printf("Vendor specific (%.02x)", data[3]);
+	else
+		printf("Other");
+}
+
+static void print_wpa(const char *ie, const unsigned char *oui,
+		      unsigned char len, unsigned char *data)
+{
+	bool first = true;
+	__u16 version, count, capa;
+	int i;
+
+	printf("\t%s:", ie);
+
+	if (len < 2) {
+		printf(" <too short> data:");
+		for(i = 0; i < len; i++)
+			printf(" %.02x", data[i]);
+		printf("\n");
+		return;
+	}
+
+	version = data[0] + (data[1] << 8);
+	tab_on_first(&first);
+	printf("\t * Version: %d\n", version);
+
+	data += 2;
+	len -= 2;
+
+	if (len < 4) {
+		tab_on_first(&first);
+		printf("\t * Group cipher: TKIP\n");
+		printf("\t * Pairwise ciphers: TKIP\n");
+		return;
+	}
+
+	tab_on_first(&first);
+	printf("\t * Group cipher: ");
+	print_cipher(oui, data);
+	printf("\n");
+
+	data += 4;
+	len -= 4;
+
+	if (len < 2) {
+		tab_on_first(&first);
+		printf("\t * Pairwise ciphers: TKIP\n");
+		return;
+	}
+
+	count = data[0] | (data[1] << 8);
+	tab_on_first(&first);
+	printf("\t * Pairwise ciphers:");
+	for (i=0; i<count; i++) {
+		printf(" ");
+		print_cipher(oui, data + 2 + (i * 4));
+	}
+	printf("\n");
+
+	data += 2 + (count * 4);
+	len -= 2 + (count * 4);
+
+	if (len < 2)
+		return;
+
+	count = data[0] | (data[1] << 8);
+	tab_on_first(&first);
+	printf("\t * Authentication suites:");
+	for (i=0; i<count; i++) {
+		printf(" ");
+		print_auth(oui, data + 2 + (i * 4));
+	}
+	printf("\n");
+
+	data += 2 + (count * 4);
+	len -= 2 + (count * 4);
+
+	if (len < 2)
+		return;
+
+	capa = data[0] | (data[1] << 8);
+	tab_on_first(&first);
+	printf("\t * Capabilities: 0x%.4x\n", capa);
+}
+
+static void print_rsn(unsigned char type, unsigned char len, unsigned char *data)
+{
+	print_wpa("WPA2", cipher_oui, len, data);
+}
+
 static const printfn ieprinters[] = {
 	[0] = print_ssid,
 	[1] = print_supprates,
 	[3] = print_ds,
 	[5] = print_ign,
+	[48] = print_rsn,
 	[50] = print_supprates,
 };
 
-static void tab_on_first(bool *first)
+static void print_wifi_wpa(unsigned char type, unsigned char len, unsigned char *data)
 {
-	if (!*first)
-		printf("\t");
-	else
-		*first = false;
+	print_wpa("WPA", vendor_oui, len, data);
 }
 
 static void print_wifi_wps(unsigned char type, unsigned char len, unsigned char *data)
@@ -177,6 +320,7 @@ static void print_wifi_wps(unsigned char type, unsigned char len, unsigned char
 }
 
 static const printfn wifiprinters[] = {
+	[1] = print_wifi_wpa,
 	[4] = print_wifi_wps,
 };
 
@@ -193,7 +337,7 @@ static void print_vendor(unsigned char len, unsigned char *data,
 		return;
 	}
 
-	if (len >= 4 && data[0] == 0x00 && data[1] == 0x50 && data[2] == 0xF2) {
+	if (len >= 4 && memcmp(data, vendor_oui, 3) == 0) {
 		if (data[3] < ARRAY_SIZE(wifiprinters) && wifiprinters[data[3]])
 			return wifiprinters[data[3]](data[3], len - 4, data + 4);
 		if (!params->unknown)
-- 
1.6.0.6

