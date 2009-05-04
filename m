Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37683 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZEDItH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 04:49:07 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 6/6] add support for parsing WPA and RSN/WPA2 information elements
Date: Mon,  4 May 2009 01:48:47 -0700
Message-Id: <1241426927-14902-6-git-send-email-marcel@holtmann.org>
In-Reply-To: <1241426927-14902-5-git-send-email-marcel@holtmann.org>
References: <1241426927-14902-1-git-send-email-marcel@holtmann.org>
 <1241426927-14902-2-git-send-email-marcel@holtmann.org>
 <1241426927-14902-3-git-send-email-marcel@holtmann.org>
 <1241426927-14902-4-git-send-email-marcel@holtmann.org>
 <1241426927-14902-5-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |  194 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 187 insertions(+), 7 deletions(-)

diff --git a/scan.c b/scan.c
index 6ff4386..8fb7ac2 100644
--- a/scan.c
+++ b/scan.c
@@ -27,6 +27,9 @@
 #define WLAN_CAPABILITY_APSD		(1<<11)
 #define WLAN_CAPABILITY_DSSS_OFDM	(1<<13)
 
+static unsigned char wifi_oui[3]      = { 0x00, 0x50, 0xf2 };
+static unsigned char ieee80211_oui[3] = { 0x00, 0x0f, 0xac };
+
 struct scan_params {
 	bool unknown;
 };
@@ -55,6 +58,14 @@ COMMAND(scan, trigger, NULL,
 
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
@@ -128,6 +139,176 @@ static void print_erp(unsigned char type, unsigned char len, unsigned char *data
 	printf("\n");
 }
 
+static void print_cipher(unsigned char *data)
+{
+	if (memcmp(data, wifi_oui, 3) == 0) {
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
+	} else if (memcmp(data, ieee80211_oui, 3) == 0) {
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
+		case 0x06:
+			printf("AES-128-CMAC");
+			break;
+		default:
+			printf("Reserved (%.02x)", data[3]);
+			break;
+		}
+	} else
+		printf("Other");
+}
+
+static void print_auth(unsigned char *data)
+{
+	if (memcmp(data, wifi_oui, 3) == 0) {
+		switch (data[3]) {
+		case 0x01:
+			printf("IEEE 802.1X");
+			break;
+		case 0x02:
+			printf("PSK");
+			break;
+		default:
+			printf("Reserved (%.02x)", data[3]);
+			break;
+		}
+	} else if (memcmp(data, ieee80211_oui, 3) == 0) {
+		switch (data[3]) {
+		case 0x01:
+			printf("IEEE 802.1X");
+			break;
+		case 0x02:
+			printf("PSK");
+			break;
+		default:
+			printf("Reserved (%.02x)", data[3]);
+			break;
+		}
+	} else
+		printf("Other");
+}
+
+static void print_wpa(const char *ie,
+		      const char *defcipher, const char *defauth,
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
+		printf("\t * Group cipher: %s\n", defcipher);
+		printf("\t * Pairwise ciphers: %s\n", defcipher);
+		return;
+	}
+
+	tab_on_first(&first);
+	printf("\t * Group cipher: ");
+	print_cipher(data);
+	printf("\n");
+
+	data += 4;
+	len -= 4;
+
+	if (len < 2) {
+		tab_on_first(&first);
+		printf("\t * Pairwise ciphers: %s\n", defcipher);
+		return;
+	}
+
+	count = data[0] | (data[1] << 8);
+	tab_on_first(&first);
+	printf("\t * Pairwise ciphers:");
+	for (i=0; i<count; i++) {
+		printf(" ");
+		print_cipher(data + 2 + (i * 4));
+	}
+	printf("\n");
+
+	data += 2 + (count * 4);
+	len -= 2 + (count * 4);
+
+	if (len < 2) {
+		tab_on_first(&first);
+		printf("\t * Authentication suites: %s\n", defauth);
+		return;
+	}
+
+	count = data[0] | (data[1] << 8);
+	tab_on_first(&first);
+	printf("\t * Authentication suites:");
+	for (i=0; i<count; i++) {
+		printf(" ");
+		print_auth(data + 2 + (i * 4));
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
+	print_wpa("WPA2", "CCMP", "IEEE 802.1X", len, data);
+}
+
 static void print_capabilities(unsigned char type, unsigned char len, unsigned char *data)
 {
 	int i;
@@ -145,16 +326,14 @@ static const printfn ieprinters[] = {
 	[5] = print_ign,
 	[7] = print_country,
 	[42] = print_erp,
+	[48] = print_rsn,
 	[50] = print_supprates,
 	[127] = print_capabilities,
 };
 
-static void tab_on_first(bool *first)
+static void print_wifi_wpa(unsigned char type, unsigned char len, unsigned char *data)
 {
-	if (!*first)
-		printf("\t");
-	else
-		*first = false;
+	print_wpa("WPA", "TKIP", "IEEE 802.1X", len, data);
 }
 
 static void print_wifi_wmm(unsigned char type, unsigned char len, unsigned char *data)
@@ -260,6 +439,7 @@ static void print_wifi_wps(unsigned char type, unsigned char len, unsigned char
 }
 
 static const printfn wifiprinters[] = {
+	[1] = print_wifi_wpa,
 	[2] = print_wifi_wmm,
 	[4] = print_wifi_wps,
 };
@@ -277,12 +457,12 @@ static void print_vendor(unsigned char len, unsigned char *data,
 		return;
 	}
 
-	if (len >= 4 && data[0] == 0x00 && data[1] == 0x50 && data[2] == 0xF2) {
+	if (len >= 4 && memcmp(data, wifi_oui, 3) == 0) {
 		if (data[3] < ARRAY_SIZE(wifiprinters) && wifiprinters[data[3]])
 			return wifiprinters[data[3]](data[3], len - 4, data + 4);
 		if (!params->unknown)
 			return;
-		printf("\tWiFi OUI %#.2x data:", data[3]);
+		printf("\tWiFi OUI %#.2x, data:", data[3]);
 		for(i = 0; i < len - 4; i++)
 			printf(" %.02x", data[i + 4]);
 		printf("\n");
-- 
1.6.0.6

