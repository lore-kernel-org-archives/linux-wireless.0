Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65356 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab1JKLPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 07:15:40 -0400
Received: by bkbzt4 with SMTP id zt4so9641912bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 04:15:39 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: fix HT PHY BSS Membership selector value encoding
Date: Tue, 11 Oct 2011 13:15:25 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201110111315.25405.chunkeey@googlemail.com> (sfid-20111011_131543_574134_A819F2FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE 802.11n 7.3.2.2 extended the supported rate IE to
support a special encoding for HT rate support.

iw needs to be updated in order to recognize
the magic value and parse it accordingly.

e.g.:

> Extended supported rates: 63.5* 

now becomes:

> Extended supported rates: HT* 

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/scan.c b/scan.c
index d083591..2220f26 100644
--- a/scan.c
+++ b/scan.c
@@ -158,6 +158,8 @@ static void print_ssid(const uint8_t type, uint8_t len, const uint8_t *data)
 	printf("\n");
 }
 
+#define BSS_MEMBERSHIP_SELECTOR_HT_PHY 127
+
 static void print_supprates(const uint8_t type, uint8_t len, const uint8_t *data)
 {
 	int i;
@@ -166,7 +168,13 @@ static void print_supprates(const uint8_t type, uint8_t len, const uint8_t *data
 
 	for (i = 0; i < len; i++) {
 		int r = data[i] & 0x7f;
-		printf("%d.%d%s ", r/2, 5*(r&1), data[i] & 0x80 ? "*":"");
+
+		if (r == BSS_MEMBERSHIP_SELECTOR_HT_PHY)
+			printf("HT");
+		else
+			printf("%d.%d", r/2, 5*(r&1));
+
+		printf("%s ", data[i] & 0x80 ? "*" : "");
 	}
 	printf("\n");
 }
