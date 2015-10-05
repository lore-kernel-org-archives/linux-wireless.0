Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34513 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbbJEKfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:52 -0400
Received: by padhy16 with SMTP id hy16so33474627pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:51 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 14/20] staging: wilc1000: rename hWFIDrv in host_int_remove_wep_key
Date: Mon,  5 Oct 2015 19:34:58 +0900
Message-Id: <1444041304-7727-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123555_631799_F5ED9A4E)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces hWFIDrv with wfi_drv that is first argument of
host_int_remove_wep_key to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c19fb23..cfeb81b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4291,10 +4291,10 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
+int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 u8keyIdx)
 {
 	int s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
+	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)wfi_drv;
 	struct host_if_msg msg;
 
 
@@ -4311,7 +4311,7 @@ int host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = REMOVEKEY;
-	msg.drvHandler = hWFIDrv;
+	msg.drvHandler = wfi_drv;
 
 
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d3d05fc..372acb7 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -407,7 +407,7 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress);
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index);
+int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 u8Index);
 /**
  *  @brief              sets WEP deafault key
  *  @details    Sets the index of the WEP encryption key in use,
-- 
2.6.0

