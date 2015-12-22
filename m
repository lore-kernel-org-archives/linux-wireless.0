Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33667 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbLVAt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:26 -0500
Received: by mail-pf0-f180.google.com with SMTP id n128so80072527pfn.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:26 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/13] staging: wilc1000: match argument name of wilc_add_rx_gtk declaration
Date: Tue, 22 Dec 2015 09:49:00 +0900
Message-Id: <1450745349-16811-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_014928_937740_9249C985)
In-Reply-To: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some argument name of wilc_add_rx_gtk declaration is different to those
of this function definition. It is changed as same name of this function
declaration and definition.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 02c10171..6a5f3bd 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -317,10 +317,10 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 		 u8 mode, u8 cipher_mode, u8 index);
 s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 			   u32 *pu32InactiveTime);
-int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *pu8RxGtk, u8 u8GtkKeylen,
-		    u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
-		    const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode,
-		    u8 u8Ciphermode);
+int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
+		    u8 index, u32 key_rsc_len, const u8 *key_rsc,
+		    const u8 *rx_mic, const u8 *tx_mic, u8 mode,
+		    u8 cipher_mode);
 s32 wilc_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
 			u8 *pu8TxGtk, u8 u8KeyIdx);
 s32 wilc_set_pmkid_info(struct wilc_vif *vif,
-- 
2.6.4

