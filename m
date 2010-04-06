Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:41597 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371Ab0DFPEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 11:04:05 -0400
Date: Tue, 6 Apr 2010 18:03:57 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: Parse some common WPS attributes
Message-ID: <20100406150357.GA26375@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make iw scan result output a bit more readable for WPS APs by parsing
some of the commonly used attributes instead of showing them as unknown
TLVs with a hex dump.
---
diff --git a/scan.c b/scan.c
index c0287c4..09b1047 100644
--- a/scan.c
+++ b/scan.c
@@ -683,6 +683,26 @@ static void print_wifi_wmm(const uint8_t type, uint8_t len, const uint8_t *data)
 	printf("\n");
 }
 
+static const char * wifi_wps_dev_passwd_id(uint16_t id)
+{
+	switch (id) {
+	case 0:
+		return "Default (PIN)";
+	case 1:
+		return "User-specified";
+	case 2:
+		return "Machine-specified";
+	case 3:
+		return "Rekey";
+	case 4:
+		return "PushButton";
+	case 5:
+		return "Registrar-specified";
+	default:
+		return "??";
+	}
+}
+
 static void print_wifi_wps(const uint8_t type, uint8_t len, const uint8_t *data)
 {
 	bool first = true;
@@ -703,6 +723,19 @@ static void print_wifi_wps(const uint8_t type, uint8_t len, const uint8_t *data)
 			tab_on_first(&first);
 			printf("\t * Device name: %.*s\n", sublen, data + 4);
 			break;
+		case 0x1012: {
+			uint16_t id;
+			tab_on_first(&first);
+			if (sublen != 2) {
+				printf("\t * Device Password ID: (invalid "
+				       "length %d)\n", sublen);
+				break;
+			}
+			id = data[4] << 8 | data[5];
+			printf("\t * Device Password ID: %u (%s)\n",
+			       id, wifi_wps_dev_passwd_id(id));
+			break;
+		}
 		case 0x1021:
 			tab_on_first(&first);
 			printf("\t * Manufacturer: %.*s\n", sublen, data + 4);
@@ -711,17 +744,69 @@ static void print_wifi_wps(const uint8_t type, uint8_t len, const uint8_t *data)
 			tab_on_first(&first);
 			printf("\t * Model: %.*s\n", sublen, data + 4);
 			break;
+		case 0x1024:
+			tab_on_first(&first);
+			printf("\t * Model Number: %.*s\n", sublen, data + 4);
+			break;
+		case 0x103b: {
+			__u8 val = data[4];
+			tab_on_first(&first);
+			printf("\t * Response Type: %d%s\n",
+			       val, val == 3 ? " (AP)" : "");
+			break;
+		}
+		case 0x103c: {
+			__u8 val = data[4];
+			tab_on_first(&first);
+			printf("\t * RF Bands: 0x%x\n", val);
+			break;
+		}
+		case 0x1041: {
+			__u8 val = data[4];
+			tab_on_first(&first);
+			printf("\t * Selected Registrar: 0x%x\n", val);
+			break;
+		}
+		case 0x1042:
+			tab_on_first(&first);
+			printf("\t * Serial Number: %.*s\n", sublen, data + 4);
+			break;
+		case 0x1044: {
+			__u8 val = data[4];
+			tab_on_first(&first);
+			printf("\t * Wi-Fi Protected Setup State: %d%s%s\n",
+			       val,
+			       val == 1 ? " (Unconfigured)" : "",
+			       val == 2 ? " (Configured)" : "");
+			break;
+		}
+		case 0x1054: {
+			tab_on_first(&first);
+			if (sublen != 8) {
+				printf("\t * Primary Device Type: (invalid "
+				       "length %d)\n", sublen);
+				break;
+			}
+			printf("\t * Primary Device Type: "
+			       "%u-%02x%02x%02x%02x-%u\n",
+			       data[4] << 8 | data[5],
+			       data[6], data[7], data[8], data[9],
+			       data[10] << 8 | data[11]);
+			break;
+		}
 		case 0x1057: {
 			__u8 val = data[4];
 			tab_on_first(&first);
 			printf("\t * AP setup locked: 0x%.2x\n", val);
 			break;
 		}
-		case 0x1008: {
+		case 0x1008:
+		case 0x1053: {
 			__u16 meth = (data[4] << 8) + data[5];
 			bool comma = false;
 			tab_on_first(&first);
-			printf("\t * Config methods:");
+			printf("\t * %sConfig methods:",
+			       subtype == 0x1053 ? "Selected Registrar ": "");
 #define T(bit, name) do {		\
 	if (meth & (1<<bit)) {		\
 		if (comma)		\

-- 
Jouni Malinen                                            PGP id EFC895FA
