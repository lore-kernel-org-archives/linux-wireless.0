Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35881 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbbJOCIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:08:00 -0400
Received: by pabws5 with SMTP id ws5so7345012pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:59 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 18/33] staging: wilc1000: fix return type of host_int_ListenStateExpired
Date: Thu, 15 Oct 2015 11:06:47 +0900
Message-Id: <1444874822-31152-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_041333_110500_CC399438)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_ListenStateExpired from s32
to int. s32Error gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fdcfc91..f251186 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4546,9 +4546,9 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	return s32Error;
 }
 
-s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
+int host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7e95df4..71f04ef 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1130,7 +1130,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u3
  *  @date
  *  @version		1.0
  */
-s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID);
+int host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID);
 
 /**
  *  @brief           host_int_frame_register
-- 
2.6.1

