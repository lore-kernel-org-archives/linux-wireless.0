Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36792 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689AbbJOCHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:07:54 -0400
Received: by pabws5 with SMTP id ws5so7342341pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:53 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 16/33] staging: wilc1000: fix return type of host_int_get_statistics
Date: Thu, 15 Oct 2015 11:06:45 +0900
Message-Id: <1444874822-31152-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040815_226743_4B4C4A7F)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_get_statistics from s32 to
int. s32Error gets return value from wilc_mq_send that has return type
of int. It should be changed return type of this function as well as
data type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0c6048a..05e6880 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3992,9 +3992,9 @@ int host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
 	return s32Error;
 }
 
-s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
+int host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 892e1b7..c9b0533 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1158,6 +1158,6 @@ static s32 Handle_ScanDone(struct host_if_drv *drvHandler, enum scan_event enuEv
 
 void host_int_freeJoinParams(void *pJoinParams);
 
-s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrStatistics);
+int host_int_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrStatistics);
 
 #endif
-- 
2.6.1

