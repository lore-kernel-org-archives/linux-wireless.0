Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34413 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbbJOCHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:07:51 -0400
Received: by payp3 with SMTP id p3so23388942pay.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:50 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 15/33] staging: wilc1000: fix return type of host_int_get_link_speed
Date: Thu, 15 Oct 2015 11:06:44 +0900
Message-Id: <1444874822-31152-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_041412_202731_28DE4C8A)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_get_link_speed from s32 to
int. s32Error gets return value from wilc_mq_send that has return type
of int. It should be changed return type of int as well as data type of
s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 61d8805..0c6048a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3962,10 +3962,10 @@ int host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 	return s32Error;
 }
 
-s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
+int host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
 {
 	struct host_if_msg msg;
-	s32 s32Error = 0;
+	int s32Error = 0;
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_LINKSPEED;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8a16749..892e1b7 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -815,7 +815,7 @@ int host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo);
  *  @version		1.0
  */
 int host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
-s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd);
+int host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd);
 /**
  *  @brief              scans a set of channels
  *  @details
-- 
2.6.1

