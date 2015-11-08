Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34007 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbbKHHuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:18 -0500
Received: by padhx2 with SMTP id hx2so157833239pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:17 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 15/32] staging: wilc1000: rename u8GtkKeylen in host_int_add_rx_gtk
Date: Sun,  8 Nov 2015 16:49:08 +0900
Message-Id: <1446968965-8958-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085023_625689_5964F46B)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u8GtkKeylen to gtk_key_len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b79383e..5c40d40 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3274,14 +3274,14 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 }
 
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
-			u8 u8GtkKeylen,	u8 u8KeyIdx,
+			u8 gtk_key_len,	u8 u8KeyIdx,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode)
 {
 	int result = 0;
 	struct host_if_msg msg;
-	u8 u8KeyLen = u8GtkKeylen;
+	u8 u8KeyLen = gtk_key_len;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -3312,7 +3312,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 		msg.body.key_info.action = ADDKEY;
 
 	msg.body.key_info.attr.wpa.key = kmalloc(u8KeyLen, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wpa.key, rx_gtk, u8GtkKeylen);
+	memcpy(msg.body.key_info.attr.wpa.key, rx_gtk, gtk_key_len);
 
 	if (pu8RxMic)
 		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 51f51be..6b7b05e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -318,7 +318,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 			       u32 *pu32InactiveTime);
 int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
-			u8 u8GtkKeylen,	u8 u8KeyIdx,
+			u8 gtk_key_len,	u8 u8KeyIdx,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode);
-- 
2.6.3

