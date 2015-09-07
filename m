Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36271 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbbIGPg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 11:36:58 -0400
Received: by padhk3 with SMTP id hk3so14813378pad.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2015 08:36:58 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/5] staging: wilc1000: host_interface.c: fix build warning
Date: Tue,  8 Sep 2015 00:36:39 +0900
Message-Id: <1441640199-1507-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150907_173707_892566_58DE875A)
In-Reply-To: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove build build warning from Handle_SetOperationMode function.
Host interface operation mode has one of 4 types from AP_MODE, STATION_MODE,
GO_MODE and CLIENT_MODE.
This values are range from 0x01 to 0x04 if mode is set correctly.
If value of host interface operation is 0, it is not initialized any value
because struct tstrHostIFmsg is initialized by zeroes.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e09508e..3be3b4c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -754,7 +754,7 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOpe
 				 get_id_from_handler(pstrWFIDrv));
 
 
-	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL)
+	if (!pstrHostIfSetOperationMode->u32Mode)
 		up(&hSemDeinitDrvHandle);
 
 
-- 
2.5.1

