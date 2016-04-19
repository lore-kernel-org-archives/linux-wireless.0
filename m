Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36401 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbcDSAfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 20:35:43 -0400
Received: by mail-pf0-f195.google.com with SMTP id p185so95608pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 17:35:43 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/3] staging: wilc1000: change data type of result in handle_set_ip_address
Date: Tue, 19 Apr 2016 09:35:30 +0900
Message-Id: <1461026131-5841-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160419_023548_576660_19D800B6)
In-Reply-To: <1461026131-5841-1-git-send-email-chaehyun.lim@gmail.com>
References: <1461026131-5841-1-git-send-email-chaehyun.lim@gmail.com>
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
index 87c8789..9ddb238 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -351,7 +351,7 @@ static void handle_set_operation_mode(struct wilc_vif *vif,
 
 static void handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
-	s32 result = 0;
+	int result = 0;
 	struct wid wid;
 	char firmware_ip_addr[4] = {0};
 
-- 
2.8.0

