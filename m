Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35420 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbKHHt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:49:57 -0500
Received: by pasz6 with SMTP id z6so170543786pas.2
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:49:56 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/32] staging: wilc1000: rename u8Idx in host_int_add_ptk
Date: Sun,  8 Nov 2015 16:49:01 +0900
Message-Id: <1446968965-8958-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085000_829022_0781A894)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u8Idx to index to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 80a1442..fedd099 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3210,7 +3210,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 ptk_key_len, const u8 *mac_addr,
 		     const u8 *rx_mic, const u8 *tx_mic,
-		     u8 mode, u8 cipher_mode, u8 u8Idx)
+		     u8 mode, u8 cipher_mode, u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3234,7 +3234,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 	msg.body.key_info.type = WPA_PTK;
 	if (mode == AP_MODE) {
 		msg.body.key_info.action = ADDKEY_AP;
-		msg.body.key_info.attr.wpa.index = u8Idx;
+		msg.body.key_info.attr.wpa.index = index;
 	}
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 04ecf50..9238315 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -314,7 +314,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 ptk_key_len, const u8 *mac_addr,
 		     const u8 *rx_mic, const u8 *tx_mic,
-		     u8 mode, u8 cipher_mode, u8 u8Idx);
+		     u8 mode, u8 cipher_mode, u8 index);
 s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 			       u32 *pu32InactiveTime);
 s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk,
-- 
2.6.3

