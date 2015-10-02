Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36010 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbbJBMpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 08:45:15 -0400
Received: by pablk4 with SMTP id lk4so105514142pab.3
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 05:45:15 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/10] staging: wilc1000: rename s32Error in host_int_set_mac_chnl_num
Date: Fri,  2 Oct 2015 21:44:49 +0900
Message-Id: <1443789896-7082-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_144522_246179_01385A72)
In-Reply-To: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces s32Error with result to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 65bd325..566e618 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5317,7 +5317,7 @@ s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
  */
 int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 {
-	int s32Error = 0;
+	int result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
 
@@ -5332,13 +5332,13 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	msg.body.channel_info.u8SetChan = u8ChNum;
 	msg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("wilc mq send fail\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 
-- 
2.6.0

