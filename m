Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33094 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbcFLX23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2016 19:28:29 -0400
Received: by mail-pf0-f195.google.com with SMTP id c74so9227882pfb.0
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2016 16:28:29 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/6] staging: wilc1000: change data type of result in handle_cfg_param
Date: Mon, 13 Jun 2016 08:28:11 +0900
Message-Id: <20160612232815.12112-2-chaehyun.lim@gmail.com> (sfid-20160613_012836_540230_DFFE32F4)
In-Reply-To: <20160612232815.12112-1-chaehyun.lim@gmail.com>
References: <20160612232815.12112-1-chaehyun.lim@gmail.com>
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
index aeb355e..0220045 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -420,7 +420,7 @@ static void handle_get_mac_address(struct wilc_vif *vif,
 static void handle_cfg_param(struct wilc_vif *vif,
 			     struct cfg_param_attr *cfg_param_attr)
 {
-	s32 result = 0;
+	int result = 0;
 	struct wid wid_list[32];
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	int i = 0;
-- 
2.8.4

