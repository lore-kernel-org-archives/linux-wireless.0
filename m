Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42170 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbZEDFKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 01:10:01 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] add basic support for parsing country information element
Date: Sun,  3 May 2009 22:09:47 -0700
Message-Id: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 2976115..c503487 100644
--- a/scan.c
+++ b/scan.c
@@ -91,6 +91,16 @@ static void print_ign(unsigned char type, unsigned char len, unsigned char *data
 	/* ignore for now, not too useful */
 }
 
+static void print_country(unsigned char type, unsigned char len, unsigned char *data)
+{
+	int i;
+
+	printf("\tCountry: %.*s data:", 3, data);
+	for(i=0; i<len-3; i++)
+		printf(" %.02x", data[i + 3]);
+	printf("\n");
+}
+
 static void print_erp(unsigned char type, unsigned char len, unsigned char *data)
 {
 	if (data[0] == 0x00)
@@ -245,6 +255,7 @@ static const printfn ieprinters[] = {
 	[1] = print_supprates,
 	[3] = print_ds,
 	[5] = print_ign,
+	[7] = print_country,
 	[42] = print_erp,
 	[48] = print_rsn,
 	[50] = print_supprates,
-- 
1.6.0.6

