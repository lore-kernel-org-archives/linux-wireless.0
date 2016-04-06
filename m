Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35478 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbcDFXLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 19:11:07 -0400
Received: by mail-pf0-f193.google.com with SMTP id r187so5523143pfr.2
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 16:11:06 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/7] staging: wilc1000: change return type of ret variable in handle_get_tx_pwr
Date: Thu,  7 Apr 2016 08:10:37 +0900
Message-Id: <1459984243-4689-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160407_011112_019763_E5244AA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of ret variable from s32 to int.
ret has return value from wilc_send_config_pkt that has return type of
int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index eb86fd4..09e4ca3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2468,7 +2468,7 @@ static void handle_set_tx_pwr(struct wilc_vif *vif, u8 tx_pwr)
 
 static void handle_get_tx_pwr(struct wilc_vif *vif, u8 *tx_pwr)
 {
-	s32 ret = 0;
+	int ret = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_TX_POWER;
-- 
2.8.0

