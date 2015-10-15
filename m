Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36673 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556AbbJOCHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:07:48 -0400
Received: by pabws5 with SMTP id ws5so7339599pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:48 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 14/33] staging: wilc1000: fix return type of host_int_get_rssi
Date: Thu, 15 Oct 2015 11:06:43 +0900
Message-Id: <1444874822-31152-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040754_062083_0609BF2A)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_get_rssi from s32 to int.
s32Error gets return value from wilc_mq_send that has return type of
int. It should be changed return type of int as well as data type of
s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5859d34..61d8805 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3932,9 +3932,9 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 	return s32Error;
 }
 
-s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
+int host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5b2261d..8a16749 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -814,7 +814,7 @@ int host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
+int host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
 s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd);
 /**
  *  @brief              scans a set of channels
-- 
2.6.1

