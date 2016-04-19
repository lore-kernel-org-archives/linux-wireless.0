Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34315 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbcDSAfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 20:35:47 -0400
Received: by mail-pf0-f193.google.com with SMTP id d184so102712pfc.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 17:35:46 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/3] staging: wilc1000: rename result in handle_set_ip_address
Date: Tue, 19 Apr 2016 09:35:31 +0900
Message-Id: <1461026131-5841-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160419_023550_015844_F50E1753)
In-Reply-To: <1461026131-5841-1-git-send-email-chaehyun.lim@gmail.com>
References: <1461026131-5841-1-git-send-email-chaehyun.lim@gmail.com>
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
index 9ddb238..5d352aa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -351,7 +351,7 @@ static void handle_set_operation_mode(struct wilc_vif *vif,
 
 static void handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
-	int result = 0;
+	int ret = 0;
 	struct wid wid;
 	char firmware_ip_addr[4] = {0};
 
@@ -365,12 +365,12 @@ static void handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	wid.val = (u8 *)ip_addr;
 	wid.size = IP_ALEN;
 
-	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
+	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+				   wilc_get_vif_idx(vif));
 
 	host_int_get_ipaddress(vif, firmware_ip_addr, idx);
 
-	if (result)
+	if (ret)
 		netdev_err(vif->ndev, "Failed to set IP address\n");
 }
 
-- 
2.8.0

