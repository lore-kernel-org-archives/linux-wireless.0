Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41877 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZEDItB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 04:49:01 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 1/6] add support for parsing ERP information element
Date: Mon,  4 May 2009 01:48:42 -0700
Message-Id: <1241426927-14902-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 91e94ed..d4a4832 100644
--- a/scan.c
+++ b/scan.c
@@ -80,11 +80,27 @@ static void print_ign(unsigned char type, unsigned char len, unsigned char *data
 	/* ignore for now, not too useful */
 }
 
+static void print_erp(unsigned char type, unsigned char len, unsigned char *data)
+{
+	if (data[0] == 0x00)
+		return;
+
+	printf("\tERP:");
+	if (data[0] & 0x01)
+		printf(" NonERP_Present");
+	if (data[0] & 0x02)
+		printf(" Use_Protection");
+	if (data[0] & 0x04)
+		printf(" Barker_Preamble_Mode");
+	printf("\n");
+}
+
 static const printfn ieprinters[] = {
 	[0] = print_ssid,
 	[1] = print_supprates,
 	[3] = print_ds,
 	[5] = print_ign,
+	[42] = print_erp,
 	[50] = print_supprates,
 };
 
-- 
1.6.0.6

