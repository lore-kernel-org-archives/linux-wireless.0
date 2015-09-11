Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37751 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbbIKHxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2015 03:53:45 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 6/7] staging: wilc1000: delete unused global variables.
Date: Fri, 11 Sep 2015 16:53:02 +0900
Message-ID: <1441957983-17726-7-git-send-email-tony.cho@atmel.com> (sfid-20150911_095351_389908_A7005514)
In-Reply-To: <1441957983-17726-1-git-send-email-tony.cho@atmel.com>
References: <1441957983-17726-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

gstrConfigPktInfo, SemHandleSendPkt and SemHandlePktResp are never used in
the drivers. So just delete the variables and it's related code.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 60b8961..ac97830 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -140,12 +140,6 @@ typedef struct {
 /*****************************************************************************/
 /* Global Variables                                                          */
 /*****************************************************************************/
-static struct semaphore SemHandleSendPkt;
-static struct semaphore SemHandlePktResp;
-
-
-static tstrConfigPktInfo gstrConfigPktInfo;
-
 /* WID Switches */
 static tstrWID gastrWIDs[] = {
 	{WID_FIRMWARE_VERSION,          WID_STR},
@@ -477,11 +471,6 @@ s32 CoreConfiguratorInit(void)
 
 	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit()\n");
 
-	sema_init(&SemHandleSendPkt, 1);
-	sema_init(&SemHandlePktResp, 0);
-
-
-	memset((void *)(&gstrConfigPktInfo), 0, sizeof(tstrConfigPktInfo));
 	return s32Error;
 }
 
-- 
1.9.1

