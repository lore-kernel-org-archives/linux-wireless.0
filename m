Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:39012 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZG1H5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 03:57:03 -0400
Received: by ewy26 with SMTP id 26so3767834ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 00:57:01 -0700 (PDT)
Message-ID: <4A6EAFF3.8050502@gmail.com>
Date: Tue, 28 Jul 2009 09:59:47 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: dcbw@redhat.com, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] libertas: Read outside array bounds
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reads bss->rates[j] before checking bounds of index, and should use
ARRAY_SIZE to determine the size of the array.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 601b542..6c95af3 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -5,6 +5,7 @@
   *  for sending scan commands to the firmware.
   */
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <asm/unaligned.h>
@@ -876,7 +877,7 @@ static inline char *lbs_translate_scan(struct lbs_private *priv,
 	iwe.u.bitrate.disabled = 0;
 	iwe.u.bitrate.value = 0;
 
-	for (j = 0; bss->rates[j] && (j < sizeof(bss->rates)); j++) {
+	for (j = 0; j < ARRAY_SIZE(bss->rates) && bss->rates[j]; j++) {
 		/* Bit rate given in 500 kb/s units */
 		iwe.u.bitrate.value = bss->rates[j] * 500000;
 		current_val = iwe_stream_add_value(info, start, current_val,
