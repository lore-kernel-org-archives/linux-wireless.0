Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32786 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbcBPIkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 03:40:13 -0500
Received: by mail-pa0-f46.google.com with SMTP id fl4so87812522pad.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2016 00:40:13 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/7] staging: wilc1000: handle_set_mac_address: change return type to void
Date: Tue, 16 Feb 2016 17:39:52 +0900
Message-Id: <1455611995-28773-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160216_094020_791165_29B012DE)
In-Reply-To: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When handle_set_mac_address is called in hostIFthread that is a kernel
thread, it is not checked return type of this function. This patch
changes return type to void and removes a brace of if statement due to
have a single statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 65d2393..c671f05 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -424,15 +424,15 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 	return result;
 }
 
-static s32 handle_set_mac_address(struct wilc_vif *vif,
-				  struct set_mac_addr *set_mac_addr)
+static void handle_set_mac_address(struct wilc_vif *vif,
+				   struct set_mac_addr *set_mac_addr)
 {
 	s32 result = 0;
 	struct wid wid;
 
 	u8 *mac_buf = kmemdup(set_mac_addr->mac_addr, ETH_ALEN, GFP_KERNEL);
 	if (!mac_buf)
-		return -ENOMEM;
+		return;
 
 	wid.id = (u16)WID_MAC_ADDR;
 	wid.type = WID_STR;
@@ -441,13 +441,10 @@ static s32 handle_set_mac_address(struct wilc_vif *vif,
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
-	if (result) {
+	if (result)
 		PRINT_ER("Failed to set mac address\n");
-		result = -EFAULT;
-	}
 
 	kfree(mac_buf);
-	return result;
 }
 
 static s32 handle_get_mac_address(struct wilc_vif *vif,
-- 
2.7.1

