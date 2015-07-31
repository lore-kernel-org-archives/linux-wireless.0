Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44523 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbGaHlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:41:16 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 21/28] staging: wilc1000: remove unwanted type cast
Date: Fri, 31 Jul 2015 16:38:29 +0900
Message-ID: <1438328316-30197-22-git-send-email-tony.cho@atmel.com> (sfid-20150731_094119_152883_7B5F39DC)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch removes (u32) type cast which makes build warning because
the parameter of u32 type in the function host_int_set_wfi_drv_handler was
changed with WILC_WFIDrvHandle. Not necessary to cast type.

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bc9195f..ab2e082 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6687,7 +6687,7 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
 	WILC_TimerDestroy(&(pstrWFIDrv->hRemainOnChannel), NULL);
 	#endif
 
-	host_int_set_wfi_drv_handler((u32)NULL);
+	host_int_set_wfi_drv_handler(NULL);
 	down(&hSemDeinitDrvHandle);
 
 
-- 
1.9.1

