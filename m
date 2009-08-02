Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:60075 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbZHBHUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 03:20:00 -0400
Received: by ewy10 with SMTP id 10so2366943ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 00:20:00 -0700 (PDT)
Message-ID: <4A753EDE.9030506@gmail.com>
Date: Sun, 02 Aug 2009 09:23:10 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] airo: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index c70604f..e8ac4d9 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -6819,7 +6819,7 @@ static int airo_set_txpow(struct net_device *dev,
 		return -EINVAL;
 	}
 	clear_bit (FLAG_RADIO_OFF, &local->flags);
-	for (i = 0; cap_rid.txPowerLevels[i] && (i < 8); i++)
+	for (i = 0; i < 8 && cap_rid.txPowerLevels[i]; i++)
 		if (v == cap_rid.txPowerLevels[i]) {
 			readConfigRid(local, 1);
 			local->config.txPower = v;
