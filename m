Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36143 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbLVAtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:23 -0500
Received: by mail-pf0-f170.google.com with SMTP id o64so96677732pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:23 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/13] staging: wilc1000: fix return type of wilc_add_rx_gtk declaration
Date: Tue, 22 Dec 2015 09:48:59 +0900
Message-Id: <1450745349-16811-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_014925_968641_651AE487)
In-Reply-To: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_add_rx_gtk declaration from s32
to int. The return type of this function declaration and definition
should be same as data type of int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7e89776..02c10171 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -317,7 +317,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 		 u8 mode, u8 cipher_mode, u8 index);
 s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 			   u32 *pu32InactiveTime);
-s32 wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 		    u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 		    const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode,
 		    u8 u8Ciphermode);
-- 
2.6.4

