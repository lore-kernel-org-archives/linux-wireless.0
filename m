Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36581 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbbKHHtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:49:45 -0500
Received: by pacdm15 with SMTP id dm15so141902038pac.3
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:49:44 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/32] staging: wilc1000: rename u8PtkKeylen in host_int_add_ptk
Date: Sun,  8 Nov 2015 16:48:57 +0900
Message-Id: <1446968965-8958-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_084957_725512_3F09B7A1)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u8PtkKeylen to ptk_key_len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d225dbf..96a0a58 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3208,13 +3208,13 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 }
 
 int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
-		     u8 u8PtkKeylen, const u8 *mac_addr,
+		     u8 ptk_key_len, const u8 *mac_addr,
 		     const u8 *pu8RxMic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
 	int result = 0;
 	struct host_if_msg msg;
-	u8 u8KeyLen = u8PtkKeylen;
+	u8 u8KeyLen = ptk_key_len;
 	u32 i;
 
 	if (!hif_drv) {
@@ -3239,8 +3239,8 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
 
-	msg.body.key_info.attr.wpa.key = kmalloc(u8PtkKeylen, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wpa.key, ptk, u8PtkKeylen);
+	msg.body.key_info.attr.wpa.key = kmalloc(ptk_key_len, GFP_KERNEL);
+	memcpy(msg.body.key_info.attr.wpa.key, ptk, ptk_key_len);
 
 	if (pu8RxMic) {
 		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic, RX_MIC_KEY_LEN);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index ae70dc5..ae0e260 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -312,7 +312,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				const u8 *key, u8 len, u8 index, u8 mode,
 				enum AUTHTYPE auth_type);
 int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
-		     u8 u8PtkKeylen, const u8 *mac_addr,
+		     u8 ptk_key_len, const u8 *mac_addr,
 		     const u8 *pu8RxMic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx);
 s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
-- 
2.6.3

