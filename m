Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35858 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbLVAtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:16 -0500
Received: by mail-pa0-f52.google.com with SMTP id q3so87128436pav.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:16 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/13] staging: wilc1000: fix return type of wilc_add_pkt declaration
Date: Tue, 22 Dec 2015 09:48:57 +0900
Message-Id: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_014920_666378_B549E3B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_add_pkt declaration from s32 to
int. The return type of this function declaration and definition should
be same as data type of int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8faac27..be1536a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -312,7 +312,7 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 			     u8 index);
 int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 			    u8 index, u8 mode, enum AUTHTYPE auth_type);
-s32 wilc_add_ptk(struct wilc_vif *vif, const u8 *pu8Ptk, u8 u8PtkKeylen,
+int wilc_add_ptk(struct wilc_vif *vif, const u8 *pu8Ptk, u8 u8PtkKeylen,
 		 const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic,
 		 u8 mode, u8 u8Ciphermode, u8 u8Idx);
 s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
-- 
2.6.4

