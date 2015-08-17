Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34815 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbbHQCFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 22:05:32 -0400
Received: by paccq16 with SMTP id cq16so53590441pac.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2015 19:05:32 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/6] staging: wilc1000: remove unused codes of gps8ConfigPacket
Date: Mon, 17 Aug 2015 11:05:13 +0900
Message-Id: <1439777115-25861-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150817_040534_936236_6627DD30)
In-Reply-To: <1439777115-25861-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439777115-25861-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused codes of gps8ConfigPacket declared by global variable.
It is allocated and freed memory within CoreConfiguratorInit and CoreConfiguratorDeInit.
There is no used anywhere except within two functions.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 7c129aa..4a6b975 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -167,7 +167,6 @@ extern void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length);
 static struct semaphore SemHandleSendPkt;
 static struct semaphore SemHandlePktResp;
 
-static s8 *gps8ConfigPacket;
 
 static tstrConfigPktInfo gstrConfigPktInfo;
 
@@ -674,17 +673,8 @@ s32 CoreConfiguratorInit(void)
 	sema_init(&SemHandleSendPkt, 1);
 	sema_init(&SemHandlePktResp, 0);
 
-	gps8ConfigPacket = WILC_MALLOC(MAX_PACKET_BUFF_SIZE);
-	if (gps8ConfigPacket == NULL) {
-		PRINT_ER("failed in gps8ConfigPacket allocation\n");
-		s32Error = WILC_NO_MEM;
-		goto _fail_;
-	}
-
-	memset((void *)gps8ConfigPacket, 0, MAX_PACKET_BUFF_SIZE);
 
 	memset((void *)(&gstrConfigPktInfo), 0, sizeof(tstrConfigPktInfo));
-_fail_:
 	return s32Error;
 }
 
@@ -1956,11 +1946,6 @@ s32 CoreConfiguratorDeInit(void)
 
 	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorDeInit()\n");
 
-	if (gps8ConfigPacket != NULL) {
-
-		kfree(gps8ConfigPacket);
-		gps8ConfigPacket = NULL;
-	}
 
 	return s32Error;
 }
-- 
1.9.1

