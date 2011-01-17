Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48712 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1AQJQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 04:16:06 -0500
Received: by wyb28 with SMTP id 28so4886915wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 01:16:04 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: add missing MODULE_FIRMWARE statment for AP-mode FW
Date: Mon, 17 Jan 2011 11:16:00 +0200
Message-Id: <1295255760-23759-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In wl12xx cards AP-mode requires a separate FW file. Add this file to
the module info.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |    1 +
 drivers/net/wireless/wl12xx/spi.c  |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 93cbb8d..d5e8748 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -345,3 +345,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
+MODULE_FIRMWARE(WL1271_AP_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 8f7ea2c..0132dad 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -495,4 +495,5 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
+MODULE_FIRMWARE(WL1271_AP_FW_NAME);
 MODULE_ALIAS("spi:wl1271");
-- 
1.7.1

