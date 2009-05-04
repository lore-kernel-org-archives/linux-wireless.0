Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36228 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbZEDFsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 01:48:11 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] add basic support for parsing WMM information element
Date: Sun,  3 May 2009 22:47:58 -0700
Message-Id: <1241416078-3824-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 1f7ed07..5caa504 100644
--- a/scan.c
+++ b/scan.c
@@ -277,6 +277,28 @@ static void print_wifi_wpa(unsigned char type, unsigned char len, unsigned char
 	print_wpa("WPA", vendor_oui, len, data);
 }
 
+static void print_wifi_wmm(unsigned char type, unsigned char len, unsigned char *data)
+{
+	int i;
+
+	printf("\tWMM ");
+	switch (data[0]) {
+	case 0x00:
+		printf("information:");
+		break;
+	case 0x01:
+		printf("parameter:");
+		break;
+	default:
+		printf("type %d:", data[0]);
+		break;
+	}
+
+	for(i=0; i<len-1; i++)
+		printf(" %.02x", data[i + 1]);
+	printf("\n");
+}
+
 static void print_wifi_wps(unsigned char type, unsigned char len, unsigned char *data)
 {
 	bool first = true;
@@ -359,6 +381,7 @@ static void print_wifi_wps(unsigned char type, unsigned char len, unsigned char
 
 static const printfn wifiprinters[] = {
 	[1] = print_wifi_wpa,
+	[2] = print_wifi_wmm,
 	[4] = print_wifi_wps,
 };
 
-- 
1.6.0.6

