Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36356 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbbJOCHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:07:30 -0400
Received: by pabws5 with SMTP id ws5so7332030pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:30 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/33] staging: wilc1000: fix return type of host_int_get_MacAddress
Date: Thu, 15 Oct 2015 11:06:37 +0900
Message-Id: <1444874822-31152-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040736_129328_66B0416D)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_get_MacAddress from s32 to
int. s32Error gets return value from wilc_mq_send that has return type
of int. It should be changed return type by int as well as data type of
s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a4e0c5b..ba63565d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3497,9 +3497,9 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
 	return 0;
 }
 
-s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
+int host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 34aa1dc..08cc4c0 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -586,7 +586,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
  *  @date		19 April 2012
  *  @version		1.0
  */
-s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
+int host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              sets mac address
-- 
2.6.1

