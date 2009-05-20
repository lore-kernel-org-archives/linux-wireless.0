Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:40131 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbZETAMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 20:12:55 -0400
Received: by ewy24 with SMTP id 24so167537ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 17:12:56 -0700 (PDT)
Message-ID: <4A134B08.3080803@gmail.com>
Date: Wed, 20 May 2009 02:12:56 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: users@rt2x00.serialmonkey.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] wireless: beyond ARRAY_SIZE of intf->crypto_stats
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not go beyond ARRAY_SIZE of intf->crypto_stats

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 07d378e..7b3ee8c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -138,7 +138,7 @@ void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
 
 	if (cipher == CIPHER_TKIP_NO_MIC)
 		cipher = CIPHER_TKIP;
-	if (cipher == CIPHER_NONE || cipher > CIPHER_MAX)
+	if (cipher == CIPHER_NONE || cipher >= CIPHER_MAX)
 		return;
 
 	/* Remove CIPHER_NONE index */
