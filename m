Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33427 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbbKHHu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:28 -0500
Received: by pabfh17 with SMTP id fh17so166202093pab.0
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:26 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 18/32] staging: wilc1000: rename KeyRSC in host_int_add_rx_gtk
Date: Sun,  8 Nov 2015 16:49:11 +0900
Message-Id: <1446968965-8958-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085033_112697_25E37D2D)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes KeyRSC to key_rsc to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 32d4606..b50e78d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3275,7 +3275,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 gtk_key_len,	u8 index,
-			u32 key_rsc_len, const u8 *KeyRSC,
+			u32 key_rsc_len, const u8 *key_rsc,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode)
 {
@@ -3295,9 +3295,9 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 	if (pu8TxMic)
 		u8KeyLen += TX_MIC_KEY_LEN;
 
-	if (KeyRSC) {
+	if (key_rsc) {
 		msg.body.key_info.attr.wpa.seq = kmalloc(key_rsc_len, GFP_KERNEL);
-		memcpy(msg.body.key_info.attr.wpa.seq, KeyRSC, key_rsc_len);
+		memcpy(msg.body.key_info.attr.wpa.seq, key_rsc, key_rsc_len);
 	}
 
 	msg.id = HOST_IF_MSG_KEY;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f75bfa1..66bb7d7 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -319,7 +319,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 			       u32 *pu32InactiveTime);
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 gtk_key_len,	u8 index,
-			u32 key_rsc_len, const u8 *KeyRSC,
+			u32 key_rsc_len, const u8 *key_rsc,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode);
 s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
-- 
2.6.3

