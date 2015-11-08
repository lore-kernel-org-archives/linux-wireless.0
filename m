Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35631 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbKHHuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:21 -0500
Received: by pasz6 with SMTP id z6so170549715pas.2
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:20 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 16/32] staging: wilc1000: rename u8KeyIdx in host_int_add_rx_gtk
Date: Sun,  8 Nov 2015 16:49:09 +0900
Message-Id: <1446968965-8958-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085028_822563_DB2C00F0)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u8KeyIdx to index to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5c40d40..22fdca5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3274,7 +3274,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 }
 
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
-			u8 gtk_key_len,	u8 u8KeyIdx,
+			u8 gtk_key_len,	u8 index,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode)
@@ -3322,7 +3322,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 		memcpy(msg.body.key_info.attr.wpa.key + 24, pu8TxMic,
 		       TX_MIC_KEY_LEN);
 
-	msg.body.key_info.attr.wpa.index = u8KeyIdx;
+	msg.body.key_info.attr.wpa.index = index;
 	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
 	msg.body.key_info.attr.wpa.seq_len = u32KeyRSClen;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 6b7b05e..41ca349 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -318,7 +318,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 			       u32 *pu32InactiveTime);
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
-			u8 gtk_key_len,	u8 u8KeyIdx,
+			u8 gtk_key_len,	u8 index,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode);
-- 
2.6.3

