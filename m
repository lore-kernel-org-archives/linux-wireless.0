Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27309 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965285AbbJ2DG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:06:26 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 63/64] staging: wilc1000: rename pstrHostIfSetDrvHandler of fuction Handle_SetWfiDrvHandler
Date: Thu, 29 Oct 2015 12:05:55 +0900
Message-ID: <1446087956-19054-30-git-send-email-glen.lee@atmel.com> (sfid-20151029_040628_445357_E3B886BE)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
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
index 819306b..96c6d4a 100644
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

