Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36018 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbbGNBtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 21:49:09 -0400
Received: by pachj5 with SMTP id hj5so41334470pac.3
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2015 18:49:09 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/2] staging: wilc1000: fix memory allocation error check
Date: Tue, 14 Jul 2015 10:48:41 +0900
Message-Id: <1436838521-8200-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150714_034913_338464_251D4777)
In-Reply-To: <1436838521-8200-1-git-send-email-chaehyun.lim@gmail.com>
References: <1436838521-8200-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove WILC_ERRORREPORT macro. If memory allocation is failed,
jump to a label to return this function with WILC_NO_MEM.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ca97b70..f6ba7d1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7142,8 +7142,11 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 	/* Bug 4599 : if tail length = 0 skip allocating & copying */
 	if (u32TailLen > 0) {
 		pstrSetBeaconParam->pu8Tail = (u8 *)WILC_MALLOC(u32TailLen);
-		if (pstrSetBeaconParam->pu8Tail == NULL)
-			WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		if (pstrSetBeaconParam->pu8Tail == NULL) {
+			PRINT_ER("Failed to allocate memory\n");
+			s32Error = WILC_NO_MEM;
+			goto _fail_;
+		}
 		WILC_memcpy(pstrSetBeaconParam->pu8Tail, pu8Tail, u32TailLen);
 	} else {
 		pstrSetBeaconParam->pu8Tail = NULL;
-- 
1.9.1

