Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34139 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbbKHHug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:36 -0500
Received: by padhx2 with SMTP id hx2so157837108pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:35 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 21/32] staging: wilc1000: rename u8Ciphermode in host_int_add_rx_gtk
Date: Sun,  8 Nov 2015 16:49:14 +0900
Message-Id: <1446968965-8958-21-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085042_618985_3DF53857)
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
index 7ca924a..7b647ce 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3277,7 +3277,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 gtk_key_len,	u8 index,
 			u32 key_rsc_len, const u8 *key_rsc,
 			const u8 *rx_mic, const u8 *tx_mic,
-			u8 mode, u8 u8Ciphermode)
+			u8 mode, u8 cipher_mode)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3306,7 +3306,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 
 	if (mode == AP_MODE) {
 		msg.body.key_info.action = ADDKEY_AP;
-		msg.body.key_info.attr.wpa.mode = u8Ciphermode;
+		msg.body.key_info.attr.wpa.mode = cipher_mode;
 	}
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e25f838..da81b92 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -321,7 +321,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 gtk_key_len,	u8 index,
 			u32 key_rsc_len, const u8 *key_rsc,
 			const u8 *rx_mic, const u8 *tx_mic,
-			u8 mode, u8 u8Ciphermode);
+			u8 mode, u8 cipher_mode);
 s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
 			u8 *pu8TxGtk, u8 u8KeyIdx);
 s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv,
-- 
2.6.3

