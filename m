Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35920 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbbJEKf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:58 -0400
Received: by pablk4 with SMTP id lk4so172813742pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:58 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 16/20] staging: wilc1000: rename s32Error in host_int_remove_wep_key
Date: Mon,  5 Oct 2015 19:35:00 +0900
Message-Id: <1444041304-7727-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123601_682146_D7A98546)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces s32Error with result in host_int_remove_wep_key to
avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ca0e8e3..c02a007 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4293,15 +4293,15 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
  */
 int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 index)
 {
-	int s32Error = 0;
+	int result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)wfi_drv;
 	struct host_if_msg msg;
 
 
 	if (pstrWFIDrv == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("Failed to send setup multicast config packet\n");
-		return s32Error;
+		return result;
 	}
 
 	/* prepare the Remove Wep Key Message */
@@ -4319,12 +4319,12 @@ int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 index)
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = index;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	return s32Error;
+	return result;
 }
 
 /**
-- 
2.6.0

