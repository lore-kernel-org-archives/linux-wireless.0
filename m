Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37827 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbbKFCSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:18:32 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 65/73] staging: wilc1000: rename Handle_SetWfiDrvHandler function
Date: Fri, 6 Nov 2015 11:20:04 +0900
Message-ID: <1446776412-30670-16-git-send-email-glen.lee@atmel.com> (sfid-20151106_031835_408816_86AC2333)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames Handle_SetWfiDrvHandler function to handle_set_wfi_drv_handler
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 16396e5..dcaf0eb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -347,8 +347,8 @@ static s32 handle_set_channel(struct host_if_drv *hif_drv,
 	return result;
 }
 
-static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
-				    struct drv_handler *hif_drv_handler)
+static s32 handle_set_wfi_drv_handler(struct host_if_drv *hif_drv,
+				      struct drv_handler *hif_drv_handler)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2970,8 +2970,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
-			Handle_SetWfiDrvHandler(msg.drv,
-						&msg.body.drv);
+			handle_set_wfi_drv_handler(msg.drv, &msg.body.drv);
 			break;
 
 		case HOST_IF_MSG_SET_OPERATION_MODE:
-- 
1.9.1

