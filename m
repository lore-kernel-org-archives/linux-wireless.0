Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34242 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbLVAty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:54 -0500
Received: by mail-pf0-f182.google.com with SMTP id u7so50243891pfb.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:54 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 13/13] staging: wilc1000: rename pu8MacAddress in wilc_set_mac_address
Date: Tue, 22 Dec 2015 09:49:09 +0900
Message-Id: <1450745349-16811-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_020059_059066_DA03882C)
In-Reply-To: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8MacAddress to mac_addr to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ed6f932..78d26ee 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3346,16 +3346,16 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 	return result;
 }
 
-int wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress)
+int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 {
 	int result = 0;
 	struct host_if_msg msg;
 
-	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
+	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", mac_addr[0], mac_addr[1], mac_addr[2]);
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
-	memcpy(msg.body.set_mac_info.mac_addr, pu8MacAddress, ETH_ALEN);
+	memcpy(msg.body.set_mac_info.mac_addr, mac_addr, ETH_ALEN);
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 337965f..13d253c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -324,7 +324,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 int wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pmkid);
 int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
-int wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
+int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_wait_msg_queue_idle(void);
 s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
-- 
2.6.4

