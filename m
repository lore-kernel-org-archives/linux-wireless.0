Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:4406 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbbIQIuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 04:50:07 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/4] staging: wilc1000: Modify null check routine
Date: Thu, 17 Sep 2015 17:50:03 +0900
Message-ID: <1442479806-10737-1-git-send-email-tony.cho@atmel.com> (sfid-20150917_105014_630063_51AE9C84)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch modify null check routine.
- Null check error non return. (Handle_RcvdGnrlAsyncInfo)

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6fdf392..a9eaa8f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2403,8 +2403,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 	s32 s32Err = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
 
-	if (pstrWFIDrv == NULL)
+	if (!pstrWFIDrv) {
 		PRINT_ER("Driver handler is NULL\n");
+		return -EFAULT;
+	}
 	PRINT_D(GENERIC_DBG, "Current State = %d,Received state = %d\n", pstrWFIDrv->enuHostIFstate,
 		pstrRcvdGnrlAsyncInfo->pu8Buffer[7]);
 
-- 
1.9.1

