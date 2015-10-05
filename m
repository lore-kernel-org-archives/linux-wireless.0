Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35758 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbbJECHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 22:07:33 -0400
Received: by pacfv12 with SMTP id fv12so163957510pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2015 19:07:33 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/3] staging: wilc1000: return error code directly in host_int_set_mac_chnl_num
Date: Mon,  5 Oct 2015 11:07:22 +0900
Message-Id: <1444010843-16796-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_040736_382314_0A78D4F1)
In-Reply-To: <1444010843-16796-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444010843-16796-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to pass the error code to the variable 'result'.
Just return the error directly when error occurs.
Return 0 at the end of this function when error is not happened.

Suggested-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 47ccaa8..b1aa7dd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5317,7 +5317,7 @@ s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
  */
 int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg msg;
 
 	if (!wfi_drv) {
@@ -5334,10 +5334,10 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
 		PRINT_ER("wilc mq send fail\n");
-		result = -EINVAL;
+		return -EINVAL;
 	}
 
-	return result;
+	return 0;
 }
 
 
-- 
2.6.0

