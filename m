Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36254 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbcEBKsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 06:48:23 -0400
Received: by mail-pa0-f65.google.com with SMTP id i5so17651828pag.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2016 03:48:23 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/7] staging: wilc1000: change data type of result in handle_get_mac_address
Date: Mon,  2 May 2016 19:47:54 +0900
Message-Id: <1462186075-8549-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160502_124826_502998_F4C74784)
In-Reply-To: <1462186075-8549-1-git-send-email-chaehyun.lim@gmail.com>
References: <1462186075-8549-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes data type of result variable from s32 to int. result
is used to get return value from wilc_send_config_pkt that has return
type of int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 23bbaa8..71d6b66 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -401,7 +401,7 @@ static void handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 static void handle_get_mac_address(struct wilc_vif *vif,
 				   struct get_mac_addr *get_mac_addr)
 {
-	s32 result = 0;
+	int result = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_MAC_ADDR;
-- 
2.8.2

