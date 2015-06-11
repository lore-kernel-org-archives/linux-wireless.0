Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8473 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbbFKDpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 23:45:10 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH] staging: wilc1000: modify odd print message
Date: Thu, 11 Jun 2015 12:44:24 +0900
Message-ID: <1433994264-26509-1-git-send-email-dean.lee@atmel.com> (sfid-20150611_054514_092596_E7937EC0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver has odd message in print string.
So this patch removes the data type.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1ecb373..9e055c4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -703,7 +703,7 @@ static WILC_Sint32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperat
 	strWID.s32ValueSize = sizeof(WILC_Uint32);
 
 	/*Sending Cfg*/
-	PRINT_INFO(HOSTINF_DBG, "(size_t)pstrWFIDrv= %p \n", pstrWFIDrv);
+	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p \n", pstrWFIDrv);
 
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
 
@@ -8040,4 +8040,3 @@ WILC_Sint32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 i
 
 
 }
-
-- 
2.4.3

