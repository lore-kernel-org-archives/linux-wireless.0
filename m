Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:36099 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbcBPIkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 03:40:16 -0500
Received: by mail-pf0-f179.google.com with SMTP id e127so101534677pfe.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2016 00:40:16 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/7] staging: wilc1000: handle_set_mac_address: change data type of result
Date: Tue, 16 Feb 2016 17:39:53 +0900
Message-Id: <1455611995-28773-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160216_094023_799270_C79C6AA8)
In-Reply-To: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

result variable gets value from wilc_send_config_pkt that has return
value of int. This patch changes data type of result variable to int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c671f05..90321a3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -427,7 +427,7 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 static void handle_set_mac_address(struct wilc_vif *vif,
 				   struct set_mac_addr *set_mac_addr)
 {
-	s32 result = 0;
+	int result = 0;
 	struct wid wid;
 
 	u8 *mac_buf = kmemdup(set_mac_addr->mac_addr, ETH_ALEN, GFP_KERNEL);
-- 
2.7.1

