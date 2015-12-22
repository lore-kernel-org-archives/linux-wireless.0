Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34198 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbbLVAts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:48 -0500
Received: by mail-pf0-f182.google.com with SMTP id u7so50242623pfb.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:48 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/13] staging: wilc1000: rename pu8MacAddress in wilc_get_mac_address
Date: Tue, 22 Dec 2015 09:49:07 +0900
Message-Id: <1450745349-16811-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_020058_173907_B5A2C22E)
In-Reply-To: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8MacAddress to mac_addr to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index affd1e6..613c5a2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3325,7 +3325,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 	return result;
 }
 
-int wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress)
+int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3333,7 +3333,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
-	msg.body.get_mac_info.mac_addr = pu8MacAddress;
+	msg.body.get_mac_info.mac_addr = mac_addr;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 6be4b14..76f90cd 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -323,7 +323,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 		    u8 cipher_mode);
 int wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pmkid);
-int wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
+int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 s32 wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
 int wilc_wait_msg_queue_idle(void);
 s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
-- 
2.6.4

