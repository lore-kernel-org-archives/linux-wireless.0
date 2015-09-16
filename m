Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5682 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbbIPBoi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 21:44:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 06/10] staging: wilc1000: delete unused global variables.
Date: Wed, 16 Sep 2015 10:43:51 +0900
Message-ID: <1442367835-30733-7-git-send-email-tony.cho@atmel.com> (sfid-20150916_034440_677876_918AD620)
In-Reply-To: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
References: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
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
index b514d09..7936b49 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -139,12 +139,6 @@ typedef struct {
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
@@ -476,11 +470,6 @@ s32 CoreConfiguratorInit(void)
 
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

