Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33942 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbbJOCHZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:07:25 -0400
Received: by payp3 with SMTP id p3so23377853pay.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:24 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/33] staging: wilc1000: fix return type of host_int_get_inactive_time
Date: Thu, 15 Oct 2015 11:06:35 +0900
Message-Id: <1444874822-31152-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040731_918735_1981234A)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_get_inactive_time from s32
int. s32Error gets return value from wilc_mq_send that has return type
of int. It should be changed return type by int as well as data type of
s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 482dc55..191d840 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3871,10 +3871,10 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
 
 }
 
-s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
+int host_int_get_inactive_time(struct host_if_drv *hif_drv,
 			       const u8 *mac, u32 *pu32InactiveTime)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c9ab99d..b660eec 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -453,7 +453,7 @@ int host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeyl
  *  @date		15 April 2013
  *  @version		1.0
  */
-s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
+int host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
 
 /**
  *  @brief              adds Rx GTk Key
-- 
2.6.1

