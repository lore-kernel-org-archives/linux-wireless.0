Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58798 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZEDQGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:06:21 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] add support for showing power constraint IE
Date: Mon,  4 May 2009 09:06:07 -0700
Message-Id: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 9b58c29..206b6e8 100644
--- a/scan.c
+++ b/scan.c
@@ -176,6 +176,11 @@ static void print_country(const uint8_t type, uint8_t len, const uint8_t *data)
 	printf("\n");
 }
 
+static void print_powerconstraint(const uint8_t type, uint8_t len, const uint8_t *data)
+{
+	printf(" %d db\n", data[0]);
+}
+
 static void print_erp(const uint8_t type, uint8_t len, const uint8_t *data)
 {
 	if (data[0] == 0x00)
@@ -407,6 +412,7 @@ static const struct ie_print ieprinters[] = {
 	[3] = { "DS Paramater set", print_ds, 1, 1, },
 	[5] = PRINT_IGN,
 	[7] = { "Country", print_country, 3, 255, },
+	[32] = { "Power constraint", print_powerconstraint, 1, 1, },
 	[42] = { "ERP", print_erp, 1, 255, },
 	[48] = { "RSN", print_rsn, 2, 255, },
 	[50] = { "Extended supported rates", print_supprates, 0, 255, },
-- 
1.6.0.6

