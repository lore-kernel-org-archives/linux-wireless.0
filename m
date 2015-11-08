Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34096 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbbKHHua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:30 -0500
Received: by padhx2 with SMTP id hx2so157835809pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:29 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 19/32] staging: wilc1000: rename pu8RxMic in host_int_add_rx_gtk
Date: Sun,  8 Nov 2015 16:49:12 +0900
Message-Id: <1446968965-8958-19-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085038_668839_F7184A9B)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8RxMic to rx_mic to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b50e78d..df364dc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3276,7 +3276,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 gtk_key_len,	u8 index,
 			u32 key_rsc_len, const u8 *key_rsc,
-			const u8 *pu8RxMic, const u8 *pu8TxMic,
+			const u8 *rx_mic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode)
 {
 	int result = 0;
@@ -3289,7 +3289,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 	}
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	if (pu8RxMic)
+	if (rx_mic)
 		u8KeyLen += RX_MIC_KEY_LEN;
 
 	if (pu8TxMic)
@@ -3314,8 +3314,8 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 	msg.body.key_info.attr.wpa.key = kmalloc(u8KeyLen, GFP_KERNEL);
 	memcpy(msg.body.key_info.attr.wpa.key, rx_gtk, gtk_key_len);
 
-	if (pu8RxMic)
-		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic,
+	if (rx_mic)
+		memcpy(msg.body.key_info.attr.wpa.key + 16, rx_mic,
 		       RX_MIC_KEY_LEN);
 
 	if (pu8TxMic)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 66bb7d7..42c8749 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -320,7 +320,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 gtk_key_len,	u8 index,
 			u32 key_rsc_len, const u8 *key_rsc,
-			const u8 *pu8RxMic, const u8 *pu8TxMic,
+			const u8 *rx_mic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode);
 s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
 			u8 *pu8TxGtk, u8 u8KeyIdx);
-- 
2.6.3

