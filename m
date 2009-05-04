Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41881 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZEDItD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 04:49:03 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3/6] add support for showing extended capabilities IE
Date: Mon,  4 May 2009 01:48:44 -0700
Message-Id: <1241426927-14902-3-git-send-email-marcel@holtmann.org>
In-Reply-To: <1241426927-14902-2-git-send-email-marcel@holtmann.org>
References: <1241426927-14902-1-git-send-email-marcel@holtmann.org>
 <1241426927-14902-2-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 5b5d300..0cd3aa8 100644
--- a/scan.c
+++ b/scan.c
@@ -114,6 +114,16 @@ static void print_erp(unsigned char type, unsigned char len, unsigned char *data
 	printf("\n");
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
@@ -122,6 +132,7 @@ static const printfn ieprinters[] = {
 	[7] = print_country,
 	[42] = print_erp,
 	[50] = print_supprates,
+	[127] = print_capabilities,
 };
 
 static void tab_on_first(bool *first)
-- 
1.6.0.6

