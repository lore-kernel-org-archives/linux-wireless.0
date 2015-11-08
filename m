Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34048 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbbKHHuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:24 -0500
Received: by padhx2 with SMTP id hx2so157834459pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:23 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 17/32] staging: wilc1000: rename u32KeyRSClen in host_int_add_rx_gtk
Date: Sun,  8 Nov 2015 16:49:10 +0900
Message-Id: <1446968965-8958-17-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085029_531292_69FF921D)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u32KeyRSClen to key_rsc_len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 22fdca5..32d4606 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3275,7 +3275,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 gtk_key_len,	u8 index,
-			u32 u32KeyRSClen, const u8 *KeyRSC,
+			u32 key_rsc_len, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode)
 {
@@ -3296,8 +3296,8 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 		u8KeyLen += TX_MIC_KEY_LEN;
 
 	if (KeyRSC) {
-		msg.body.key_info.attr.wpa.seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
-		memcpy(msg.body.key_info.attr.wpa.seq, KeyRSC, u32KeyRSClen);
+		msg.body.key_info.attr.wpa.seq = kmalloc(key_rsc_len, GFP_KERNEL);
+		memcpy(msg.body.key_info.attr.wpa.seq, KeyRSC, key_rsc_len);
 	}
 
 	msg.id = HOST_IF_MSG_KEY;
@@ -3324,7 +3324,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 
 	msg.body.key_info.attr.wpa.index = index;
 	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
-	msg.body.key_info.attr.wpa.seq_len = u32KeyRSClen;
+	msg.body.key_info.attr.wpa.seq_len = key_rsc_len;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 41ca349..f75bfa1 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -319,7 +319,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 			       u32 *pu32InactiveTime);
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 gtk_key_len,	u8 index,
-			u32 u32KeyRSClen, const u8 *KeyRSC,
+			u32 key_rsc_len, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode);
 s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
-- 
2.6.3

