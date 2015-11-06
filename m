Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37839 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbbKFCSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:18:38 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 66/73] staging: wilc1000: rename Handle_SetOperationMode function
Date: Fri, 6 Nov 2015 11:20:05 +0900
Message-ID: <1446776412-30670-17-git-send-email-glen.lee@atmel.com> (sfid-20151106_031850_777828_0E435113)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames Handle_SetOperationMode function to handle_set_operation_mode
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dcaf0eb..504763e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -371,8 +371,8 @@ static s32 handle_set_wfi_drv_handler(struct host_if_drv *hif_drv,
 	return result;
 }
 
-static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
-				    struct op_mode *hif_op_mode)
+static s32 handle_set_operation_mode(struct host_if_drv *hif_drv,
+				     struct op_mode *hif_op_mode)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2974,7 +2974,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SET_OPERATION_MODE:
-			Handle_SetOperationMode(msg.drv, &msg.body.mode);
+			handle_set_operation_mode(msg.drv, &msg.body.mode);
 			break;
 
 		case HOST_IF_MSG_SET_IPADDRESS:
-- 
1.9.1

