Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21597 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbbIUDVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:21:06 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 33/34] staging: wilc1000: remove u32Intialized which is unnecessary
Date: Mon, 21 Sep 2015 12:17:02 +0900
Message-ID: <1442805423-3711-34-git-send-email-tony.cho@atmel.com> (sfid-20150921_052109_851536_9376D0C1)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the global variable, u32Intialized which is not necessary
from the host_interface.c file.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 59e82ee..dd8dd04 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6366,7 +6366,6 @@ void host_int_send_network_info_to_host
  *  @date		8 March 2012
  *  @version		1.0
  */
-static u32 u32Intialized;
 static u32 clients_count;
 
 s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
@@ -6375,12 +6374,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	int err;
 
-	/*if(u32Intialized == 1)
-	 * {
-	 *      PRINT_D(HOSTINF_DBG,"Host interface is previously initialized\n");
-	 * *phWFIDrv = (WILC_WFIDrvHandle)gWFiDrvHandle; //Will be adjusted later for P2P
-	 *      return 0;
-	 * }	*/
 	PRINT_D(HOSTINF_DBG, "Initializing host interface for client %d\n", clients_count + 1);
 
 	gbScanWhileConnected = false;
@@ -6491,7 +6484,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 		goto _fail_mem_;
 	}
 
-	u32Intialized = 1;
 	clients_count++; /* increase number of created entities */
 
 	return s32Error;
@@ -6531,12 +6523,6 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 
 	/*obtain driver handle*/
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	/*if(u32Intialized == 0)
-	 * {
-	 *      PRINT_ER("Host Interface is not initialized\n");
-	 *      return 0;
-	 * }*/
-
 
 	if (pstrWFIDrv == NULL)	{
 		PRINT_ER("pstrWFIDrv = NULL\n");
@@ -6610,7 +6596,6 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
 
 	/*Setting the gloabl driver handler with NULL*/
-	u32Intialized = 0;
 	/* gWFiDrvHandle = NULL; */
 	ret = remove_handler_in_list(pstrWFIDrv);
 	if (ret)
-- 
1.9.1

