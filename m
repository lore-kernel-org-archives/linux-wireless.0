Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36130 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161036AbbKFKMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:12:00 -0500
Received: by pacdm15 with SMTP id dm15so94619036pac.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2015 02:12:00 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 07/12] staging: wilc1000: fix return type of host_int_add_station
Date: Fri,  6 Nov 2015 19:11:16 +0900
Message-Id: <1446804681-8873-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20151106_111205_264550_03658536)
In-Reply-To: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_add_station from s32 to int.
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
index 2b6f620..dc5f45a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4526,10 +4526,10 @@ int host_int_del_beacon(struct host_if_drv *hif_drv)
 	return result;
 }
 
-s32 host_int_add_station(struct host_if_drv *hif_drv,
+int host_int_add_station(struct host_if_drv *hif_drv,
 			 struct add_sta_param *pstrStaParams)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 11c4220..0949950 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -378,7 +378,7 @@ s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 			u32 u32TailLen,
 			u8 *pu8tail);
 int host_int_del_beacon(struct host_if_drv *hif_drv);
-s32 host_int_add_station(struct host_if_drv *hWFIDrv,
+int host_int_add_station(struct host_if_drv *hWFIDrv,
 			 struct add_sta_param *pstrStaParams);
 s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
 			    u8 pu8MacAddr[][ETH_ALEN]);
-- 
2.6.3

