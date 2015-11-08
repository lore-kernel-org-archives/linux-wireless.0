Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33810 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbbKHHty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:49:54 -0500
Received: by padhx2 with SMTP id hx2so157827824pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:49:53 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/32] staging: wilc1000: rename u8Ciphermode in host_int_add_ptk
Date: Sun,  8 Nov 2015 16:49:00 +0900
Message-Id: <1446968965-8958-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_084959_116473_C755118C)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u8Ciphermode to cipher_mode to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a8566ee..80a1442 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3210,7 +3210,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 ptk_key_len, const u8 *mac_addr,
 		     const u8 *rx_mic, const u8 *tx_mic,
-		     u8 mode, u8 u8Ciphermode, u8 u8Idx)
+		     u8 mode, u8 cipher_mode, u8 u8Idx)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3259,7 +3259,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 
 	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
 	msg.body.key_info.attr.wpa.mac_addr = mac_addr;
-	msg.body.key_info.attr.wpa.mode = u8Ciphermode;
+	msg.body.key_info.attr.wpa.mode = cipher_mode;
 	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5da584b..04ecf50 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -314,7 +314,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 ptk_key_len, const u8 *mac_addr,
 		     const u8 *rx_mic, const u8 *tx_mic,
-		     u8 mode, u8 u8Ciphermode, u8 u8Idx);
+		     u8 mode, u8 cipher_mode, u8 u8Idx);
 s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 			       u32 *pu32InactiveTime);
 s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk,
-- 
2.6.3

