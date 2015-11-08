Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36718 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbKHHuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:50:03 -0500
Received: by pacdm15 with SMTP id dm15so141905650pac.3
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:50:02 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/32] staging: wilc1000: rename u8KeyLen in host_int_add_ptk
Date: Sun,  8 Nov 2015 16:49:03 +0900
Message-Id: <1446968965-8958-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085008_483384_C1481F31)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes u8KeyLen to key_len to avoid camelcase.
It is used as local variable in order to save pkt_key_len that is
argument of this function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a959f48..dd7e8ed 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3214,7 +3214,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 {
 	int result = 0;
 	struct host_if_msg msg;
-	u8 u8KeyLen = ptk_key_len;
+	u8 key_len = ptk_key_len;
 	int i;
 
 	if (!hif_drv) {
@@ -3223,10 +3223,10 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 	}
 
 	if (rx_mic)
-		u8KeyLen += RX_MIC_KEY_LEN;
+		key_len += RX_MIC_KEY_LEN;
 
 	if (tx_mic)
-		u8KeyLen += TX_MIC_KEY_LEN;
+		key_len += TX_MIC_KEY_LEN;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
@@ -3257,7 +3257,7 @@ int host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *ptk,
 		}
 	}
 
-	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
+	msg.body.key_info.attr.wpa.key_len = key_len;
 	msg.body.key_info.attr.wpa.mac_addr = mac_addr;
 	msg.body.key_info.attr.wpa.mode = cipher_mode;
 	msg.drv = hif_drv;
-- 
2.6.3

