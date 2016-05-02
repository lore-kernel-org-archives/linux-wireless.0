Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32846 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbcEBKsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 06:48:20 -0400
Received: by mail-pf0-f196.google.com with SMTP id e190so20540169pfe.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2016 03:48:20 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/7] staging: wilc1000: change handle_get_mac_address's return type to void
Date: Mon,  2 May 2016 19:47:53 +0900
Message-Id: <1462186075-8549-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160502_124823_822817_E1A74249)
In-Reply-To: <1462186075-8549-1-git-send-email-chaehyun.lim@gmail.com>
References: <1462186075-8549-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When handle_get_mac_address is called in hostIFthread that is a kernel
thread, it is not checked return type of this function. This patch
changes return type to void and removes braces if statement due to have
a single statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8a269fd..23bbaa8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -398,8 +398,8 @@ static void handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 		netdev_err(vif->ndev, "Failed to get IP address\n");
 }
 
-static s32 handle_get_mac_address(struct wilc_vif *vif,
-				  struct get_mac_addr *get_mac_addr)
+static void handle_get_mac_address(struct wilc_vif *vif,
+				   struct get_mac_addr *get_mac_addr)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -412,13 +412,9 @@ static s32 handle_get_mac_address(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "Failed to get mac address\n");
-		result = -EFAULT;
-	}
 	complete(&hif_wait_response);
-
-	return result;
 }
 
 static s32 handle_cfg_param(struct wilc_vif *vif,
-- 
2.8.2

