Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34705 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbbKHHto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:49:44 -0500
Received: by padhx2 with SMTP id hx2so157824068pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:49:35 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/32] staging: wilc1000: fix return type of host_int_add_ptk
Date: Sun,  8 Nov 2015 16:48:54 +0900
Message-Id: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_084948_409010_2335567F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_add_ptk from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d5b7725..082450f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3207,12 +3207,12 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
+int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 		     u8 u8PtkKeylen, const u8 *mac_addr,
 		     const u8 *pu8RxMic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 57e1d42..ee9c8fe 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -311,7 +311,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				const u8 *key, u8 len, u8 index, u8 mode,
 				enum AUTHTYPE auth_type);
-s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk,
+int host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk,
 		     u8 u8PtkKeylen, const u8 *mac_addr,
 		     const u8 *pu8RxMic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx);
-- 
2.6.3

