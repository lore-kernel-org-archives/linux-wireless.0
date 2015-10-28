Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41665 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbbJ1G6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:58:38 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/80] staging: wilc1000: rename u32Mode of struct op_mode
Date: Wed, 28 Oct 2015 15:59:30 +0900
Message-ID: <1446015640-29398-10-git-send-email-glen.lee@atmel.com> (sfid-20151028_075840_625547_04A0177C)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32Mode of struct op_mode to mode
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a1116ef..f693ea3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -381,13 +381,13 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 
 	wid.id = (u16)WID_SET_OPERATION_MODE;
 	wid.type = WID_INT;
-	wid.val = (s8 *)&pstrHostIfSetOperationMode->u32Mode;
+	wid.val = (s8 *)&pstrHostIfSetOperationMode->mode;
 	wid.size = sizeof(u32);
 
 	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
-	if ((pstrHostIfSetOperationMode->u32Mode) == IDLE_MODE)
+	if ((pstrHostIfSetOperationMode->mode) == IDLE_MODE)
 		up(&hif_sema_driver);
 
 	if (result) {
@@ -3700,7 +3700,7 @@ int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
-	msg.body.mode.u32Mode = mode;
+	msg.body.mode.mode = mode;
 	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index eb7b7d9..e040c7e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -244,7 +244,7 @@ struct drv_handler {
 };
 
 struct op_mode {
-	u32 u32Mode;
+	u32 mode;
 };
 
 struct set_mac_addr {
-- 
1.9.1

