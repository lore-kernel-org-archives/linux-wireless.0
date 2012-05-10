Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50831 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab2EJJPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:08 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so247958wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:07 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 17/78] wl18xx: set Rx block-size alignment quirk
Date: Thu, 10 May 2012 12:13:22 +0300
Message-Id: <1336641263-5761-18-git-send-email-arik@wizery.com> (sfid-20120510_111517_571151_5DB0DED5)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 18xx FW sends Rx blocks with aligned length.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 4a5ef6e..a074d81 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -243,7 +243,8 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (185x PG10)",
 			     wl->chip.id);
 		wl->sr_fw_name = WL18XX_FW_NAME;
-		wl->quirks |= WLCORE_QUIRK_NO_ELP;
+		wl->quirks |= WLCORE_QUIRK_NO_ELP |
+			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN;
 
 		/* TODO: need to blocksize alignment for RX/TX separately? */
 		break;
-- 
1.7.9.5

