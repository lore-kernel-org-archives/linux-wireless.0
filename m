Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41879 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZEDItD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 04:49:03 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 2/6] add basic support for parsing country information element
Date: Mon,  4 May 2009 01:48:43 -0700
Message-Id: <1241426927-14902-2-git-send-email-marcel@holtmann.org>
In-Reply-To: <1241426927-14902-1-git-send-email-marcel@holtmann.org>
References: <1241426927-14902-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index d4a4832..5b5d300 100644
--- a/scan.c
+++ b/scan.c
@@ -80,6 +80,25 @@ static void print_ign(unsigned char type, unsigned char len, unsigned char *data
 	/* ignore for now, not too useful */
 }
 
+static void print_country(unsigned char type, unsigned char len, unsigned char *data)
+{
+	int i;
+
+	printf("\tCountry: %.*s", 2, data);
+	switch (data[2]) {
+	case 'I':
+		printf(" (indoor)");
+		break;
+	case 'O':
+		printf(" (outdoor)");
+		break;
+	}
+	printf(", data:");
+	for(i=0; i<len-3; i++)
+		printf(" %.02x", data[i + 3]);
+	printf("\n");
+}
+
 static void print_erp(unsigned char type, unsigned char len, unsigned char *data)
 {
 	if (data[0] == 0x00)
@@ -100,6 +119,7 @@ static const printfn ieprinters[] = {
 	[1] = print_supprates,
 	[3] = print_ds,
 	[5] = print_ign,
+	[7] = print_country,
 	[42] = print_erp,
 	[50] = print_supprates,
 };
-- 
1.6.0.6

