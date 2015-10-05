Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35980 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbbJEKgC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:36:02 -0400
Received: by pablk4 with SMTP id lk4so172815091pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:36:01 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 17/20] staging: wilc1000: remove pstrWFIDrv in host_int_remove_key
Date: Mon,  5 Oct 2015 19:35:01 +0900
Message-Id: <1444041304-7727-17-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123606_277580_D8A03F6B)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove pstrWFIDrv in host_int_remove_key. There is no need to
make another variable to check if first argument is NULL or not.
It is able to use wfi_drv directly that is first argument of this
function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c02a007..e284afb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4294,11 +4294,10 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
 int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 index)
 {
 	int result = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)wfi_drv;
 	struct host_if_msg msg;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (wfi_drv == NULL) {
 		result = -EFAULT;
 		PRINT_ER("Failed to send setup multicast config packet\n");
 		return result;
@@ -4322,7 +4321,7 @@ int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 index)
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
-	down(&(pstrWFIDrv->hSemTestKeyBlock));
+	down(&(wfi_drv->hSemTestKeyBlock));
 
 	return result;
 }
-- 
2.6.0

