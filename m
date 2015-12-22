Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33251 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbLVAtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:20 -0500
Received: by mail-pf0-f193.google.com with SMTP id 78so1048976pfw.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:19 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/13] staging: wilc1000: match argument name of wilc_add_ptk declaration
Date: Tue, 22 Dec 2015 09:48:58 +0900
Message-Id: <1450745349-16811-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_014923_066499_5657C84A)
In-Reply-To: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some arguments name of wilc_add_pkt declaration is different to those of
this function definition. It is changed as same name of this function
declaration and definition.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index be1536a..7e89776 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -312,9 +312,9 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 			     u8 index);
 int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 			    u8 index, u8 mode, enum AUTHTYPE auth_type);
-int wilc_add_ptk(struct wilc_vif *vif, const u8 *pu8Ptk, u8 u8PtkKeylen,
-		 const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic,
-		 u8 mode, u8 u8Ciphermode, u8 u8Idx);
+int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
+		 const u8 *mac_addr, const u8 *rx_mic, const u8 *tx_mic,
+		 u8 mode, u8 cipher_mode, u8 index);
 s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 			   u32 *pu32InactiveTime);
 s32 wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *pu8RxGtk, u8 u8GtkKeylen,
-- 
2.6.4

