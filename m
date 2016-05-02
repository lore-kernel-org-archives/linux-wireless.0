Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34955 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbcEBKsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 06:48:15 -0400
Received: by mail-pf0-f194.google.com with SMTP id r187so20694447pfr.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2016 03:48:14 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/7] staging: wilc1000: rename result in handle_get_ip_address
Date: Mon,  2 May 2016 19:47:51 +0900
Message-Id: <1462186075-8549-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160502_124817_764588_6B6883CB)
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
index acefd3b..1d48214 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -376,7 +376,7 @@ static void handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 static void handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 {
-	int result = 0;
+	int ret = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_IP_ADDRESS;
@@ -384,8 +384,8 @@ static void handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 	wid.val = kmalloc(IP_ALEN, GFP_KERNEL);
 	wid.size = IP_ALEN;
 
-	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
+	ret = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
+				   wilc_get_vif_idx(vif));
 
 	memcpy(get_ip[idx], wid.val, IP_ALEN);
 
@@ -394,7 +394,7 @@ static void handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 	if (memcmp(get_ip[idx], set_ip[idx], IP_ALEN) != 0)
 		wilc_setup_ipaddress(vif, set_ip[idx], idx);
 
-	if (result != 0)
+	if (ret != 0)
 		netdev_err(vif->ndev, "Failed to get IP address\n");
 }
 
-- 
2.8.2

