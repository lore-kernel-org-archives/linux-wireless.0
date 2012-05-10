Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50831 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180Ab2EJJPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:46 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so247958wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:45 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 35/78] wl18xx: disable FW log functionality
Date: Thu, 10 May 2012 12:13:40 +0300
Message-Id: <1336641263-5761-36-git-send-email-arik@wizery.com> (sfid-20120510_111555_952865_22EA73B1)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently (Fw .67) appears to do more harm than good.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 82403e3..0f07886 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -574,6 +574,7 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 			     wl->chip.id);
 		wl->sr_fw_name = WL18XX_FW_NAME;
 		wl->quirks |= WLCORE_QUIRK_NO_ELP |
+			      WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED |
 			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN;
 
 		/* TODO: need to blocksize alignment for RX/TX separately? */
-- 
1.7.9.5

