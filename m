Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32827 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbcEBKsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 06:48:11 -0400
Received: by mail-pf0-f193.google.com with SMTP id e190so20540037pfe.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2016 03:48:11 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/7] staging: wilc1000: change data type of result in handle_get_ip_address
Date: Mon,  2 May 2016 19:47:50 +0900
Message-Id: <1462186075-8549-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160502_124815_052638_CA955491)
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
index ce1cd68..acefd3b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -376,7 +376,7 @@ static void handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 static void handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 {
-	s32 result = 0;
+	int result = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_IP_ADDRESS;
-- 
2.8.2

