Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35727 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbbKHHud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:33 -0500
Received: by pasz6 with SMTP id z6so170552424pas.2
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:32 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 20/32] staging: wilc1000: rename pu8TxMic in host_int_add_rx_gtk
Date: Sun,  8 Nov 2015 16:49:13 +0900
Message-Id: <1446968965-8958-20-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085037_905688_1424149C)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8TxMic to tx_mic to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index df364dc..7ca924a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3276,7 +3276,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 gtk_key_len,	u8 index,
 			u32 key_rsc_len, const u8 *key_rsc,
-			const u8 *rx_mic, const u8 *pu8TxMic,
+			const u8 *rx_mic, const u8 *tx_mic,
 			u8 mode, u8 u8Ciphermode)
 {
 	int result = 0;
@@ -3292,7 +3292,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 	if (rx_mic)
 		u8KeyLen += RX_MIC_KEY_LEN;
 
-	if (pu8TxMic)
+	if (tx_mic)
 		u8KeyLen += TX_MIC_KEY_LEN;
 
 	if (key_rsc) {
@@ -3318,8 +3318,8 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 		memcpy(msg.body.key_info.attr.wpa.key + 16, rx_mic,
 		       RX_MIC_KEY_LEN);
 
-	if (pu8TxMic)
-		memcpy(msg.body.key_info.attr.wpa.key + 24, pu8TxMic,
+	if (tx_mic)
+		memcpy(msg.body.key_info.attr.wpa.key + 24, tx_mic,
 		       TX_MIC_KEY_LEN);
 
 	msg.body.key_info.attr.wpa.index = index;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 42c8749..e25f838 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -320,7 +320,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 gtk_key_len,	u8 index,
 			u32 key_rsc_len, const u8 *key_rsc,
-			const u8 *rx_mic, const u8 *pu8TxMic,
+			const u8 *rx_mic, const u8 *tx_mic,
 			u8 mode, u8 u8Ciphermode);
 s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
 			u8 *pu8TxGtk, u8 u8KeyIdx);
-- 
2.6.3

