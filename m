Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33251 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771AbbJOCIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:08:14 -0400
Received: by pabrc13 with SMTP id rc13so71288345pab.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:08:14 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 23/33] staging: wilc1000: fix return type of host_int_delBASession
Date: Thu, 15 Oct 2015 11:06:52 +0900
Message-Id: <1444874822-31152-23-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040823_495845_6C6278E0)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_delBASession from s32 to int.
s32Error gets return value from wilc_mq_send that has return type of
int. It should be changed return type of this function as well as data
type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 83fd056..237fad1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5077,9 +5077,9 @@ void host_int_freeJoinParams(void *pJoinParams)
 		PRINT_ER("Unable to FREE null pointer\n");
 }
 
-s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
+int host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index aeb3cb3..6167295 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1080,7 +1080,7 @@ int host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx)
  *  @date
  *  @version	1.0
  */
-s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
+int host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
 
 /**
  *  @brief           host_int_delBASession
-- 
2.6.1

