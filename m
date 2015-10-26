Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33358 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbJZAoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 20:44:55 -0400
Received: by pabuq3 with SMTP id uq3so5112525pab.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2015 17:44:54 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/4] staging: wilc1000: fix return type of host_int_set_WEPDefaultKeyID
Date: Mon, 26 Oct 2015 09:44:42 +0900
Message-Id: <1445820285-14433-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151026_014458_301727_C8EB7F55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_set_WEPDefaultKeyID from s32
to int. The result variable gets return value from wilc_mq_send that has
return type of int. It should be changed return type int as well as data
type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5f81eab..56e0859 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3128,9 +3128,9 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	return result;
 }
 
-s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
+int host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 146a60f..a125233 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -384,7 +384,7 @@ int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index);
+int host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index);
 
 /**
  *  @brief              sets WEP deafault key
-- 
2.6.1

