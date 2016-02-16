Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34261 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbcBPIkT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 03:40:19 -0500
Received: by mail-pa0-f49.google.com with SMTP id fy10so60202586pac.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2016 00:40:19 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/7] staging: wilc1000: handle_set_mac_address: rename result
Date: Tue, 16 Feb 2016 17:39:54 +0900
Message-Id: <1455611995-28773-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160216_094026_890104_16EE2DA4)
In-Reply-To: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames result to ret that is used to get return value from
wilc_send_config_pkt. It will be changed until all handle_*() function
has same variable name as ret.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 90321a3..bfca0b4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -427,7 +427,7 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 static void handle_set_mac_address(struct wilc_vif *vif,
 				   struct set_mac_addr *set_mac_addr)
 {
-	int result = 0;
+	int ret = 0;
 	struct wid wid;
 
 	u8 *mac_buf = kmemdup(set_mac_addr->mac_addr, ETH_ALEN, GFP_KERNEL);
@@ -439,9 +439,9 @@ static void handle_set_mac_address(struct wilc_vif *vif,
 	wid.val = mac_buf;
 	wid.size = ETH_ALEN;
 
-	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	if (result)
+	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+				   wilc_get_vif_idx(vif));
+	if (ret)
 		PRINT_ER("Failed to set mac address\n");
 
 	kfree(mac_buf);
-- 
2.7.1

