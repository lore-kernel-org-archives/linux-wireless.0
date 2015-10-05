Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33703 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbJECHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 22:07:30 -0400
Received: by pacex6 with SMTP id ex6so160796428pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2015 19:07:30 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/3] staging: wilc1000: remove pstrWFIDrv in host_int_set_mac_chnl_num
Date: Mon,  5 Oct 2015 11:07:21 +0900
Message-Id: <1444010843-16796-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_040733_665969_02323444)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes pstrWFIDrv variable in host_int_set_mac_chnl_num
function. There is no need to make another variable to check if first
arugment is NULL or not.
It is able to use wfi_drv directly that is first argument of
this function.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 39d72ac..47ccaa8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5318,10 +5318,9 @@ s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
 int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
 {
 	int result = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)wfi_drv;
 	struct host_if_msg msg;
 
-	if (!pstrWFIDrv) {
+	if (!wfi_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
-- 
2.6.0

