Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33536 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbbJOCHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:07:33 -0400
Received: by pabrc13 with SMTP id rc13so71271343pab.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:33 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/33] staging: wilc1000: fix return type of host_int_set_MacAddress
Date: Thu, 15 Oct 2015 11:06:38 +0900
Message-Id: <1444874822-31152-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040738_239747_0D58CB82)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_set_MacAddress from s32 to
int. s32Error gets return value from wilc_mq_send that has return type
of int. It should be changed return type by int as well as data type of
s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ba63565d..6246a12 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3518,9 +3518,9 @@ int host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	return s32Error;
 }
 
-s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
+int host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 
 	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 08cc4c0..d2ddc4b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -599,7 +599,7 @@ int host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
  *  @date		16 July 2012
  *  @version		1.0
  */
-s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
+int host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              wait until msg q is empty
-- 
2.6.1

