Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43479 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794AbbJ1HHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:07:10 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 79/80] staging: wilc1000: rename pstrHostIfSetDrvHandler of fuction Handle_SetWfiDrvHandler
Date: Wed, 28 Oct 2015 16:07:24 +0900
Message-ID: <1446016045-32154-29-git-send-email-glen.lee@atmel.com> (sfid-20151028_081657_552917_D2B54C62)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrHostIfSetDrvHandler of fuction Handle_SetWfiDrvHandler
to hif_drv_handler to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 02d8935..9431915 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -349,18 +349,17 @@ static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 }
 
 static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
-				   struct drv_handler *pstrHostIfSetDrvHandler)
+				    struct drv_handler *hif_drv_handler)
 {
 	s32 result = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_SET_DRV_HANDLER;
 	wid.type = WID_INT;
-	wid.val = (s8 *)&pstrHostIfSetDrvHandler->handler;
+	wid.val = (s8 *)&hif_drv_handler->handler;
 	wid.size = sizeof(u32);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
-				 pstrHostIfSetDrvHandler->handler);
+	result = send_config_pkt(SET_CFG, &wid, 1, hif_drv_handler->handler);
 
 	if (!hif_drv)
 		up(&hif_sema_driver);
-- 
1.9.1

