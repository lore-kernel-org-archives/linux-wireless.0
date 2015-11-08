Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36559 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbKHHto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:49:44 -0500
Received: by pacdm15 with SMTP id dm15so141901464pac.3
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:49:41 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/32] staging: wilc1000: rename pu8Ptk in host_int_add_ptk
Date: Sun,  8 Nov 2015 16:48:56 +0900
Message-Id: <1446968965-8958-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_084950_099137_D19D1570)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8Ptk to ptk to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 082450f..d225dbf 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3207,7 +3207,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	return result;
 }
 
-int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
+int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 u8PtkKeylen, const u8 *mac_addr,
 		     const u8 *pu8RxMic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx)
@@ -3240,7 +3240,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 		msg.body.key_info.action = ADDKEY;
 
 	msg.body.key_info.attr.wpa.key = kmalloc(u8PtkKeylen, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wpa.key, pu8Ptk, u8PtkKeylen);
+	memcpy(msg.body.key_info.attr.wpa.key, ptk, u8PtkKeylen);
 
 	if (pu8RxMic) {
 		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic, RX_MIC_KEY_LEN);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 12deff4..ae70dc5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -311,7 +311,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				const u8 *key, u8 len, u8 index, u8 mode,
 				enum AUTHTYPE auth_type);
-int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
+int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 u8PtkKeylen, const u8 *mac_addr,
 		     const u8 *pu8RxMic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx);
-- 
2.6.3

