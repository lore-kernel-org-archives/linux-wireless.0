Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33334 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbbKHHuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:15 -0500
Received: by pabfh17 with SMTP id fh17so166199460pab.0
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:14 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 14/32] staging: wilc1000: rename pu8RxGtk in host_int_add_rx_gtk
Date: Sun,  8 Nov 2015 16:49:07 +0900
Message-Id: <1446968965-8958-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085020_118005_29DEEA68)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8RxGtk to rx_gtk to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 12b3f1d..b79383e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3273,7 +3273,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 	return result;
 }
 
-int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
+int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 u8GtkKeylen,	u8 u8KeyIdx,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
@@ -3312,7 +3312,7 @@ int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 		msg.body.key_info.action = ADDKEY;
 
 	msg.body.key_info.attr.wpa.key = kmalloc(u8KeyLen, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wpa.key, pu8RxGtk, u8GtkKeylen);
+	memcpy(msg.body.key_info.attr.wpa.key, rx_gtk, u8GtkKeylen);
 
 	if (pu8RxMic)
 		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5f1b20c..51f51be 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -317,7 +317,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 mode, u8 cipher_mode, u8 index);
 s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 			       u32 *pu32InactiveTime);
-int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
+int host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *rx_gtk,
 			u8 u8GtkKeylen,	u8 u8KeyIdx,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
-- 
2.6.3

