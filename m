Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33782 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974AbbJ2XSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 19:18:00 -0400
Received: by padfb7 with SMTP id fb7so5896155pad.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 16:17:59 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 03/12] staging: wilc1000: fix return type of host_int_del_station
Date: Fri, 30 Oct 2015 08:17:39 +0900
Message-Id: <1446160668-10747-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151030_001843_018762_72E7850B)
In-Reply-To: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_del_station from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: resend because 11/12 patch is changed.

 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b469962..be5e652 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4552,9 +4552,9 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
+int host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct del_sta *pstrDelStationMsg = &msg.body.del_sta_info;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 36de990..9eb1b3b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -979,7 +979,7 @@ s32 host_int_del_allstation(struct host_if_drv *hWFIDrv, u8 pu8MacAddr[][ETH_ALE
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr);
+int host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr);
 
 /*!
  *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv,
-- 
2.6.1

