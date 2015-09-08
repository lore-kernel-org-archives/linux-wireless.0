Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21353 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbbIHIHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 04:07:41 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/5] staging: wilc1000: define undefined operation mode
Date: Tue, 8 Sep 2015 17:07:59 +0900
Message-ID: <1441699683-31463-1-git-send-email-tony.cho@atmel.com> (sfid-20150908_100747_130542_865375AA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johnny Kim <johnny.kim@atmel.com>

This patch adds new define, IDLE_MODE to change comparison statement which
is wrong due to typecasting to null.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/host_interface.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8458d8d..8033205 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -754,7 +754,7 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOpe
 				 get_id_from_handler(pstrWFIDrv));
 
 
-	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL)
+	if ((pstrHostIfSetOperationMode->u32Mode) == IDLE_MODE)
 		up(&hSemDeinitDrvHandle);
 
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 349d5f5..a107377 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -23,6 +23,7 @@
 #define BIT1                    ((u32)(1 << 1))
 #define BIT0                    ((u32)(1 << 0))
 
+#define IDLE_MODE	0x00
 #define AP_MODE		0x01
 #define STATION_MODE	0x02
 #define GO_MODE	0x03
-- 
1.9.1

