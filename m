Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35530 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbcEBKs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 06:48:26 -0400
Received: by mail-pa0-f67.google.com with SMTP id zy2so20790940pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2016 03:48:26 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 7/7] staging: wilc1000: rename result in handle_get_mac_address
Date: Mon,  2 May 2016 19:47:55 +0900
Message-Id: <1462186075-8549-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160502_124829_427830_F5883568)
In-Reply-To: <1462186075-8549-1-git-send-email-chaehyun.lim@gmail.com>
References: <1462186075-8549-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames result to ret that is used to get return value from
wilc_send_config_pkt. Some handle_*() functions are used as result,
others are used as ret. It will be changed as ret in all handle_*()
functions to match variable name.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 71d6b66..9535842 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -401,7 +401,7 @@ static void handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 static void handle_get_mac_address(struct wilc_vif *vif,
 				   struct get_mac_addr *get_mac_addr)
 {
-	int result = 0;
+	int ret = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_MAC_ADDR;
@@ -409,10 +409,10 @@ static void handle_get_mac_address(struct wilc_vif *vif,
 	wid.val = get_mac_addr->mac_addr;
 	wid.size = ETH_ALEN;
 
-	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
+	ret = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
+				   wilc_get_vif_idx(vif));
 
-	if (result)
+	if (ret)
 		netdev_err(vif->ndev, "Failed to get mac address\n");
 	complete(&hif_wait_response);
 }
-- 
2.8.2

