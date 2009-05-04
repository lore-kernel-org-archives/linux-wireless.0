Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:33299 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZEDFTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 01:19:07 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] add support for showing extended capabilities IE
Date: Sun,  3 May 2009 22:18:52 -0700
Message-Id: <1241414332-3394-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index c503487..1f7ed07 100644
--- a/scan.c
+++ b/scan.c
@@ -250,6 +250,16 @@ static void print_rsn(unsigned char type, unsigned char len, unsigned char *data
 	print_wpa("WPA2", cipher_oui, len, data);
 }
 
+static void print_capabilities(unsigned char type, unsigned char len, unsigned char *data)
+{
+	int i;
+
+	printf("\tExtended capabilties:");
+	for(i=0; i<len; i++)
+		printf(" %.02x", data[i]);
+	printf("\n");
+}
+
 static const printfn ieprinters[] = {
 	[0] = print_ssid,
 	[1] = print_supprates,
@@ -259,6 +269,7 @@ static const printfn ieprinters[] = {
 	[42] = print_erp,
 	[48] = print_rsn,
 	[50] = print_supprates,
+	[127] = print_capabilities,
 };
 
 static void print_wifi_wpa(unsigned char type, unsigned char len, unsigned char *data)
-- 
1.6.0.6

