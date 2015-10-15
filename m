Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33327 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbbJOCHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:07:22 -0400
Received: by pabrc13 with SMTP id rc13so71266427pab.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:21 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/33] staging: wilc1000: fix return type of host_int_add_rx_gtk
Date: Thu, 15 Oct 2015 11:06:34 +0900
Message-Id: <1444874822-31152-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040729_401882_854053DF)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_add_rx_gtk from s32 to int.
s32Error gets return value from wilc_mq_send that has return type of
int. It should be changed return type by int as well as data type of
s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f2288fc..482dc55 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3371,13 +3371,13 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	return s32Error;
 }
 
-s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
+int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 			u8 u8GtkKeylen,	u8 u8KeyIdx,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 	u8 u8KeyLen = u8GtkKeylen;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 1705a68..c9ab99d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -471,7 +471,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+int host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode);
 
-- 
2.6.1

