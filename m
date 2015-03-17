Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53373 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbbCQWCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 18:02:41 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] iw:  Print OSEN element for HotSpot 2.0 IE.
Date: Tue, 17 Mar 2015 15:02:33 -0700
Message-Id: <1426629753-16905-1-git-send-email-greearb@candelatech.com> (sfid-20150317_230244_329921_E79CD1F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Re-uses most of the print-rsn logic since only the header
differs.

Example output:
...
	HotSpot 2.0 OSEN:
		 * Group cipher: NO-GROUP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: OSEN
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 scan.c | 51 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/scan.c b/scan.c
index 538b30e..f01921a 100644
--- a/scan.c
+++ b/scan.c
@@ -410,6 +410,9 @@ static void print_cipher(const uint8_t *data)
 		case 6:
 			printf("AES-128-CMAC");
 			break;
+		case 7:
+			printf("NO-GROUP");
+			break;
 		case 8:
 			printf("GCMP");
 			break;
@@ -466,24 +469,37 @@ static void print_auth(const uint8_t *data)
 				data[0], data[1] ,data[2], data[3]);
 			break;
 		}
+	} else if (memcmp(data, wfa_oui, 3) == 0) {
+		switch (data[3]) {
+		case 1:
+			printf("OSEN");
+			break;
+		default:
+			printf("%.02x-%.02x-%.02x:%d",
+				data[0], data[1] ,data[2], data[3]);
+			break;
+		}
 	} else
 		printf("%.02x-%.02x-%.02x:%d",
 			data[0], data[1] ,data[2], data[3]);
 }
 
-static void print_rsn_ie(const char *defcipher, const char *defauth,
-			 uint8_t len, const uint8_t *data)
+static void _print_rsn_ie(const char *defcipher, const char *defauth,
+			  uint8_t len, const uint8_t *data, int is_osen)
 {
 	bool first = true;
-	__u16 version, count, capa;
+	__u16 count, capa;
 	int i;
 
-	version = data[0] + (data[1] << 8);
-	tab_on_first(&first);
-	printf("\t * Version: %d\n", version);
+	if (!is_osen) {
+		__u16 version;
+		version = data[0] + (data[1] << 8);
+		tab_on_first(&first);
+		printf("\t * Version: %d\n", version);
 
-	data += 2;
-	len -= 2;
+		data += 2;
+		len -= 2;
+	}
 
 	if (len < 4) {
 		tab_on_first(&first);
@@ -627,6 +643,19 @@ static void print_rsn_ie(const char *defcipher, const char *defauth,
 	}
 }
 
+static void print_rsn_ie(const char *defcipher, const char *defauth,
+			 uint8_t len, const uint8_t *data)
+{
+	_print_rsn_ie(defcipher, defauth, len, data, 0);
+}
+
+static void print_osen_ie(const char *defcipher, const char *defauth,
+			  uint8_t len, const uint8_t *data)
+{
+	printf("\n\t");
+	_print_rsn_ie(defcipher, defauth, len, data, 1);
+}
+
 static void print_rsn(const uint8_t type, uint8_t len, const uint8_t *data)
 {
 	print_rsn_ie("CCMP", "IEEE 802.1X", len, data);
@@ -1076,6 +1105,11 @@ static void print_wifi_wpa(const uint8_t type, uint8_t len, const uint8_t *data)
 	print_rsn_ie("TKIP", "IEEE 802.1X", len, data);
 }
 
+static void print_wifi_osen(const uint8_t type, uint8_t len, const uint8_t *data)
+{
+	print_osen_ie("OSEN", "OSEN", len, data);
+}
+
 static bool print_wifi_wmm_param(const uint8_t *data, uint8_t len)
 {
 	int i;
@@ -1429,6 +1463,7 @@ static inline void print_hs20_ind(const uint8_t type, uint8_t len, const uint8_t
 static const struct ie_print wfa_printers[] = {
 	[9] = { "P2P", print_p2p, 2, 255, BIT(PRINT_SCAN), },
 	[16] = { "HotSpot 2.0 Indication", print_hs20_ind, 1, 255, BIT(PRINT_SCAN), },
+	[18] = { "HotSpot 2.0 OSEN", print_wifi_osen, 1, 255, BIT(PRINT_SCAN), },
 };
 
 static void print_vendor(unsigned char len, unsigned char *data,
-- 
1.7.11.7

