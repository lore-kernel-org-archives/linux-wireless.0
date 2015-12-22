Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34985 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbLVAtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:51 -0500
Received: by mail-pf0-f182.google.com with SMTP id 78so23903614pfw.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:51 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 12/13] staging: wilc1000: fix return type of wilc_set_mac_address
Date: Tue, 22 Dec 2015 09:49:08 +0900
Message-Id: <1450745349-16811-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_020307_716528_C67A60EF)
In-Reply-To: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_set_mac_address from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 613c5a2..ed6f932 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3346,9 +3346,9 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 	return result;
 }
 
-s32 wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress)
+int wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 
 	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 76f90cd..337965f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -324,7 +324,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 int wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pmkid);
 int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
-s32 wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
+int wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
 int wilc_wait_msg_queue_idle(void);
 s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
-- 
2.6.4

