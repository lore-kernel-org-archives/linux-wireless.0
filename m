Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:48319 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbZHBHlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 03:41:03 -0400
Received: by ewy10 with SMTP id 10so2372222ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 00:41:02 -0700 (PDT)
Message-ID: <4A7543CC.2010206@gmail.com>
Date: Sun, 02 Aug 2009 09:44:12 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] libertas: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/libertas/11d.c b/drivers/net/wireless/libertas/11d.c
index 9a5408e..5c69681 100644
--- a/drivers/net/wireless/libertas/11d.c
+++ b/drivers/net/wireless/libertas/11d.c
@@ -47,7 +47,7 @@ static u8 lbs_region_2_code(u8 *region)
 {
 	u8 i;
 
-	for (i = 0; region[i] && i < COUNTRY_CODE_LEN; i++)
+	for (i = 0; i < COUNTRY_CODE_LEN && region[i]; i++)
 		region[i] = toupper(region[i]);
 
 	for (i = 0; i < ARRAY_SIZE(region_code_mapping); i++) {
