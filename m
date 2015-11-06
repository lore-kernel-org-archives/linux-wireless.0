Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36836 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbbKFKLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:11:39 -0500
Received: by pacdm15 with SMTP id dm15so94610098pac.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2015 02:11:38 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 01/12] staging: wilc1000: fix return type of host_int_del_beacon
Date: Fri,  6 Nov 2015 19:11:10 +0900
Message-Id: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151106_111144_559786_68CC89EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_del_beacon from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: rebase latest staging-testing.

 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 17826f3..ef45b32 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4505,9 +4505,9 @@ ERRORHANDLER:
 	return result;
 }
 
-s32 host_int_del_beacon(struct host_if_drv *hif_drv)
+int host_int_del_beacon(struct host_if_drv *hif_drv)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 72c4797..417f682 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -377,7 +377,7 @@ s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 			u8 *pu8Head,
 			u32 u32TailLen,
 			u8 *pu8tail);
-s32 host_int_del_beacon(struct host_if_drv *hWFIDrv);
+int host_int_del_beacon(struct host_if_drv *hWFIDrv);
 s32 host_int_add_station(struct host_if_drv *hWFIDrv,
 			 struct add_sta_param *pstrStaParams);
 s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
-- 
2.6.3

