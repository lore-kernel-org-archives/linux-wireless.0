Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47306 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZEDQtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:49:23 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] add length checks for WPA/RSN cipher and authentication suites
Date: Mon,  4 May 2009 09:49:09 -0700
Message-Id: <1241455749-5435-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/scan.c b/scan.c
index 720c48d..9698f9f 100644
--- a/scan.c
+++ b/scan.c
@@ -317,9 +317,12 @@ static void print_rsn_ie(const char *defcipher, const char *defauth,
 	}
 
 	count = data[0] | (data[1] << 8);
+	if (2 + (count * 4) > len)
+		goto invalid;
+
 	tab_on_first(&first);
 	printf("\t * Pairwise ciphers:");
-	for (i=0; i<count; i++) {
+	for (i = 0; i < count; i++) {
 		printf(" ");
 		print_cipher(data + 2 + (i * 4));
 	}
@@ -335,6 +338,9 @@ static void print_rsn_ie(const char *defcipher, const char *defauth,
 	}
 
 	count = data[0] | (data[1] << 8);
+	if (2 + (count * 4) > len)
+		goto invalid;
+
 	tab_on_first(&first);
 	printf("\t * Authentication suites:");
 	for (i = 0; i < count; i++) {
@@ -352,6 +358,20 @@ static void print_rsn_ie(const char *defcipher, const char *defauth,
 	capa = data[0] | (data[1] << 8);
 	tab_on_first(&first);
 	printf("\t * Capabilities: 0x%.4x\n", capa);
+
+	data += 2;
+	len -= 2;
+
+invalid:
+	if (len != 0) {
+		printf("\t\t * bogus tail data (%d):", len);
+		while (len) {
+			printf(" %.2x", *data);
+			data++;
+			len--;
+		}
+		printf("\n");
+	}
 }
 
 static void print_rsn(const uint8_t type, uint8_t len, const uint8_t *data)
-- 
1.6.0.6

