Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33126 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbbKHHtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:49:51 -0500
Received: by pabfh17 with SMTP id fh17so166193577pab.0
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:49:50 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/32] staging: wilc1000: rename pu8TxMic in host_int_add_ptk
Date: Sun,  8 Nov 2015 16:48:59 +0900
Message-Id: <1446968965-8958-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_084955_553341_DD48F89E)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8TxMic to tx_mic to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9616a61..a8566ee 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3209,7 +3209,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 
 int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 ptk_key_len, const u8 *mac_addr,
-		     const u8 *rx_mic, const u8 *pu8TxMic,
+		     const u8 *rx_mic, const u8 *tx_mic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
 	int result = 0;
@@ -3225,7 +3225,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 	if (rx_mic)
 		u8KeyLen += RX_MIC_KEY_LEN;
 
-	if (pu8TxMic)
+	if (tx_mic)
 		u8KeyLen += TX_MIC_KEY_LEN;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3249,11 +3249,11 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 				PRINT_INFO(CFG80211_DBG, "PairwiseRx[%d] = %x\n", i, rx_mic[i]);
 		}
 	}
-	if (pu8TxMic) {
-		memcpy(msg.body.key_info.attr.wpa.key + 24, pu8TxMic, TX_MIC_KEY_LEN);
+	if (tx_mic) {
+		memcpy(msg.body.key_info.attr.wpa.key + 24, tx_mic, TX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < TX_MIC_KEY_LEN; i++)
-				PRINT_INFO(CFG80211_DBG, "PairwiseTx[%d] = %x\n", i, pu8TxMic[i]);
+				PRINT_INFO(CFG80211_DBG, "PairwiseTx[%d] = %x\n", i, tx_mic[i]);
 		}
 	}
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 2ee9304..5da584b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -313,7 +313,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				enum AUTHTYPE auth_type);
 int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		     u8 ptk_key_len, const u8 *mac_addr,
-		     const u8 *rx_mic, const u8 *pu8TxMic,
+		     const u8 *rx_mic, const u8 *tx_mic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx);
 s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 			       u32 *pu32InactiveTime);
-- 
2.6.3

