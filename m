Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43505 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbbJ1HHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:07:16 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 80/80] staging: wilc1000: rename pstrHostIfSetOperationMode of fuction Handle_SetOperationMode
Date: Wed, 28 Oct 2015 16:07:25 +0900
Message-ID: <1446016045-32154-30-git-send-email-glen.lee@atmel.com> (sfid-20151028_081658_192067_3173596E)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrHostIfSetOperationMode of fuction Handle_SetOperationMode
to hif_op_mode to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9431915..311a0f2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -373,20 +373,20 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 }
 
 static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
-				   struct op_mode *pstrHostIfSetOperationMode)
+				    struct op_mode *hif_op_mode)
 {
 	s32 result = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_SET_OPERATION_MODE;
 	wid.type = WID_INT;
-	wid.val = (s8 *)&pstrHostIfSetOperationMode->mode;
+	wid.val = (s8 *)&hif_op_mode->mode;
 	wid.size = sizeof(u32);
 
 	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
-	if ((pstrHostIfSetOperationMode->mode) == IDLE_MODE)
+	if ((hif_op_mode->mode) == IDLE_MODE)
 		up(&hif_sema_driver);
 
 	if (result) {
-- 
1.9.1

