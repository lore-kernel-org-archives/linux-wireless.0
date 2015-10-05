Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35860 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbbJEKfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:55 -0400
Received: by pablk4 with SMTP id lk4so172812410pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:55 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 15/20] staging: wilc1000: rename u8keyIdx in host_int_remove_wep_key
Date: Mon,  5 Oct 2015 19:34:59 +0900
Message-Id: <1444041304-7727-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123558_304667_73FCD25C)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces u8keyIdx with index that is secondard argument of
host_int_remove_wep_key to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cfeb81b..ca0e8e3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4291,7 +4291,7 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 u8keyIdx)
+int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 index)
 {
 	int s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)wfi_drv;
@@ -4316,7 +4316,7 @@ int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 u8keyIdx)
 
 
 	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8keyIdx;
+	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = index;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 372acb7..4fd18d4 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -407,7 +407,7 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress);
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 u8Index);
+int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 index);
 /**
  *  @brief              sets WEP deafault key
  *  @details    Sets the index of the WEP encryption key in use,
-- 
2.6.0

