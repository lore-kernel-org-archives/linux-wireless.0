Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:33506 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZGFTTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 15:19:50 -0400
Received: by ewy7 with SMTP id 7so2227324ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 12:19:52 -0700 (PDT)
Message-ID: <4A524E91.9040400@gmail.com>
Date: Mon, 06 Jul 2009 21:20:49 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: kalle.valo@nokia.com, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] wl12xx: loop off by one.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with `while (loop++ < INIT_LOOP)' `loop' reaches -1 after the loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 48ac08c..8899905 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -247,7 +247,7 @@ int wl12xx_boot_run_firmware(struct wl12xx *wl)
 		}
 	}
 
-	if (loop >= INIT_LOOP) {
+	if (loop > INIT_LOOP) {
 		wl12xx_error("timeout waiting for the hardware to "
 			     "complete initialization");
 		return -EIO;
