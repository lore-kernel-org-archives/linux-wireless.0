Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14242 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbbI3Jtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:49:46 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 21/32] staging: wilc1000: rename strHostIfSetDrvHandler
Date: Wed, 30 Sep 2015 18:44:38 +0900
Message-ID: <1443606289-25407-21-git-send-email-tony.cho@atmel.com> (sfid-20150930_121654_917923_FF49F917)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIfSetDrvHandler to drv to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5a54608..b8ef165 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -384,7 +384,7 @@ union message_body {
 	struct power_mgmt_param pwr_mgmt_info;
 	struct sta_inactive_t mac_info;
 	struct set_ip_addr strHostIfSetIP;
-	struct drv_handler strHostIfSetDrvHandler;
+	struct drv_handler drv;
 	struct set_multicast strHostIfSetMulti;
 	struct op_mode strHostIfSetOperationMode;
 	struct set_mac_addr strHostIfSetMacAddress;
@@ -4159,7 +4159,7 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
 			Handle_SetWfiDrvHandler(msg.drvHandler,
-						&msg.body.strHostIfSetDrvHandler);
+						&msg.body.drv);
 			break;
 
 		case HOST_IF_MSG_SET_OPERATION_MODE:
@@ -5382,7 +5382,7 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
-	msg.body.strHostIfSetDrvHandler.u32Address = get_id_from_handler(u32address);
+	msg.body.drv.u32Address = get_id_from_handler(u32address);
 	msg.drvHandler = u32address;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

