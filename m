Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35981 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbbJOCHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:07:10 -0400
Received: by pabws5 with SMTP id ws5so7323210pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:09 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/33] staging: wilc1000: fix return type of host_int_set_WEPDefaultKeyID
Date: Thu, 15 Oct 2015 11:06:30 +0900
Message-Id: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040714_768120_4CDC27FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_set_WEPDefaultKeyID from s32
to int. s32Error gets return value from wilc_mq_send that has return
type of int. It should be changed return type by int as well as data
type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 04f3bc2..d30cfa4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3196,9 +3196,9 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	return result;
 }
 
-s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
+int host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
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

