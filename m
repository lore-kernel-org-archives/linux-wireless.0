Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41639 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbbJ1G6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:58:31 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/80] staging: wilc1000: rename u32Address of struct drv_handler
Date: Wed, 28 Oct 2015 15:59:29 +0900
Message-ID: <1446015640-29398-9-git-send-email-glen.lee@atmel.com> (sfid-20151028_075834_505413_1F6115E4)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32Address of struct drv_handler to handler
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index eee53b9..a1116ef 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -356,11 +356,11 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 
 	wid.id = (u16)WID_SET_DRV_HANDLER;
 	wid.type = WID_INT;
-	wid.val = (s8 *)&pstrHostIfSetDrvHandler->u32Address;
+	wid.val = (s8 *)&pstrHostIfSetDrvHandler->handler;
 	wid.size = sizeof(u32);
 
 	result = send_config_pkt(SET_CFG, &wid, 1,
-				 pstrHostIfSetDrvHandler->u32Address);
+				 pstrHostIfSetDrvHandler->handler);
 
 	if (!hif_drv)
 		up(&hif_sema_driver);
@@ -3681,7 +3681,7 @@ int host_int_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
-	msg.body.drv.u32Address = get_id_from_handler(hif_drv);
+	msg.body.drv.handler = get_id_from_handler(hif_drv);
 	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d4fb1d4..eb7b7d9 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -240,7 +240,7 @@ struct user_conn_req {
 };
 
 struct drv_handler {
-	u32 u32Address;
+	u32 handler;
 };
 
 struct op_mode {
-- 
1.9.1

