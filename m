Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34788 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbbKHHts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:49:48 -0500
Received: by padhx2 with SMTP id hx2so157826526pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:49:47 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/32] staging: wilc1000: rename pu8RxMic in host_int_add_ptk
Date: Sun,  8 Nov 2015 16:48:58 +0900
Message-Id: <1446968965-8958-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_084952_613444_C40B93B1)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8RxMic to rx_mic to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 96a0a58..9616a61 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3209,7 +3209,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 
 int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 ptk_key_len, const u8 *mac_addr,
-		     const u8 *pu8RxMic, const u8 *pu8TxMic,
+		     const u8 *rx_mic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
 	int result = 0;
@@ -3222,7 +3222,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		return -EFAULT;
 	}
 
-	if (pu8RxMic)
+	if (rx_mic)
 		u8KeyLen += RX_MIC_KEY_LEN;
 
 	if (pu8TxMic)
@@ -3242,11 +3242,11 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 	msg.body.key_info.attr.wpa.key = kmalloc(ptk_key_len, GFP_KERNEL);
 	memcpy(msg.body.key_info.attr.wpa.key, ptk, ptk_key_len);
 
-	if (pu8RxMic) {
-		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic, RX_MIC_KEY_LEN);
+	if (rx_mic) {
+		memcpy(msg.body.key_info.attr.wpa.key + 16, rx_mic, RX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < RX_MIC_KEY_LEN; i++)
-				PRINT_INFO(CFG80211_DBG, "PairwiseRx[%d] = %x\n", i, pu8RxMic[i]);
+				PRINT_INFO(CFG80211_DBG, "PairwiseRx[%d] = %x\n", i, rx_mic[i]);
 		}
 	}
 	if (pu8TxMic) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index ae0e260..2ee9304 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -313,7 +313,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				enum AUTHTYPE auth_type);
 int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 ptk_key_len, const u8 *mac_addr,
-		     const u8 *pu8RxMic, const u8 *pu8TxMic,
+		     const u8 *rx_mic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx);
 s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 			       u32 *pu32InactiveTime);
-- 
2.6.3

