Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36322 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758982AbcALAdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 19:33:07 -0500
Received: by mail-pf0-f196.google.com with SMTP id n128so4171290pfn.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2016 16:33:06 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/5] staging: wilc1000: fix alignment of open parenthesis
Date: Tue, 12 Jan 2016 09:32:51 +0900
Message-Id: <1452558775-21532-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160112_013311_408068_19961F04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes alignment of open parenthesis found by checkpatch.pl
CHECK: Alignment should match open parenthesis

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5fac516..d735267 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -303,7 +303,7 @@ static s32 handle_set_channel(struct wilc_vif *vif,
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to set channel\n");
@@ -350,7 +350,7 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
 	wid.size = sizeof(u32);
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	if ((hif_op_mode->mode) == IDLE_MODE)
 		up(&hif_sema_driver);
@@ -383,7 +383,7 @@ static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	wid.size = IP_ALEN;
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	host_int_get_ipaddress(vif, firmware_ip_addr, idx);
 
@@ -408,7 +408,7 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 	wid.size = IP_ALEN;
 
 	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", wid.val);
 
@@ -451,7 +451,7 @@ static s32 handle_set_mac_address(struct wilc_vif *vif,
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", wid.val);
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to set mac address\n");
 		result = -EFAULT;
@@ -473,7 +473,7 @@ static s32 handle_get_mac_address(struct wilc_vif *vif,
 	wid.size = ETH_ALEN;
 
 	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to get mac address\n");
-- 
2.6.4

