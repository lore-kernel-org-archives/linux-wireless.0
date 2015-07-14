Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34562 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbbGNBs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 21:48:59 -0400
Received: by pactm7 with SMTP id tm7so29095208pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2015 18:48:59 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/2] staging: wilc1000: fix uninitialized variablie warning
Date: Tue, 14 Jul 2015 10:48:40 +0900
Message-Id: <1436838521-8200-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150714_034903_139218_52C2CCF3)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building this driver, I got a warning as below:

host_interface.c: In function ‘host_int_add_beacon’:
host_interface.c:7116:16: warning: ‘*((void *)&strHostIFmsg+8).pu8Head’ may be used
uninitialized in this function [-Wmaybe-uninitialized]

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c089e73..ca97b70 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7131,8 +7131,11 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 	pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
 	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
 	pstrSetBeaconParam->pu8Head = (u8 *)WILC_MALLOC(u32HeadLen);
-	if (pstrSetBeaconParam->pu8Head == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+	if (pstrSetBeaconParam->pu8Head == NULL) {
+		PRINT_ER("Failed to allocated memory\n");
+		s32Error = WILC_NO_MEM;
+		goto _fail_;
+	}
 	WILC_memcpy(pstrSetBeaconParam->pu8Head, pu8Head, u32HeadLen);
 	pstrSetBeaconParam->u32TailLen = u32TailLen;
 
@@ -7159,6 +7162,7 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 			WILC_FREE(pstrSetBeaconParam->pu8Tail);
 	}
 
+_fail_:
 	return s32Error;
 
 }
-- 
1.9.1

