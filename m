Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34110 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbbLVAtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:35 -0500
Received: by mail-pf0-f182.google.com with SMTP id u7so50240313pfb.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:35 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/13] staging: wilc1000: fix return type of wilc_set_pmkid_info
Date: Tue, 22 Dec 2015 09:49:03 +0900
Message-Id: <1450745349-16811-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_014938_348778_499767F7)
In-Reply-To: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_set_pmkid_info from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8c77520..c976c1f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3291,10 +3291,10 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 	return result;
 }
 
-s32 wilc_set_pmkid_info(struct wilc_vif *vif,
+int wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pu8PmkidInfoArray)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	u32 i;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 1e3f389..3dfdc04 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -321,7 +321,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 		    u8 index, u32 key_rsc_len, const u8 *key_rsc,
 		    const u8 *rx_mic, const u8 *tx_mic, u8 mode,
 		    u8 cipher_mode);
-s32 wilc_set_pmkid_info(struct wilc_vif *vif,
+int wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pu8PmkidInfoArray);
 s32 wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
 s32 wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
-- 
2.6.4

