Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44632 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbbGaHly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:41:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 27/28] staging: wilc1000: fix casting build warning
Date: Fri, 31 Jul 2015 16:38:35 +0900
Message-ID: <1438328316-30197-28-git-send-email-tony.cho@atmel.com> (sfid-20150731_094159_344157_9585EC02)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

u32Mode type is u32 and it indicates integer type operation mode.
So change (32)NULL with 0.

drivers/staging/wilc1000/host_interface.c:704:47: warning: cast from pointer
to integer of different size [-Wpointer-to-int-cast]
  if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL)

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c5db385..b36f98c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -700,7 +700,7 @@ static s32 Handle_SetOperationMode(WILC_WFIDrvHandle drvHandler, tstrHostIfSetOp
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 
 
-	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL)
+	if ((pstrHostIfSetOperationMode->u32Mode) == 0)
 		up(&hSemDeinitDrvHandle);
 
 
-- 
1.9.1

