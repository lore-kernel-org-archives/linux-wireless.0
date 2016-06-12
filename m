Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35126 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbcFLX2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2016 19:28:32 -0400
Received: by mail-pa0-f65.google.com with SMTP id hf6so1327224pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2016 16:28:32 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/6] staging: wilc1000: rename result in handle_cfg_param
Date: Mon, 13 Jun 2016 08:28:12 +0900
Message-Id: <20160612232815.12112-3-chaehyun.lim@gmail.com> (sfid-20160613_012837_111180_DC716C80)
In-Reply-To: <20160612232815.12112-1-chaehyun.lim@gmail.com>
References: <20160612232815.12112-1-chaehyun.lim@gmail.com>
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
index 0220045..ea5cb2d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -420,7 +420,7 @@ static void handle_get_mac_address(struct wilc_vif *vif,
 static void handle_cfg_param(struct wilc_vif *vif,
 			     struct cfg_param_attr *cfg_param_attr)
 {
-	int result = 0;
+	int ret = 0;
 	struct wid wid_list[32];
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	int i = 0;
@@ -682,10 +682,10 @@ static void handle_cfg_param(struct wilc_vif *vif,
 		i++;
 	}
 
-	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
-				      i, wilc_get_vif_idx(vif));
+	ret = wilc_send_config_pkt(vif, SET_CFG, wid_list,
+				   i, wilc_get_vif_idx(vif));
 
-	if (result)
+	if (ret)
 		netdev_err(vif->ndev, "Error in setting CFG params\n");
 
 unlock:
-- 
2.8.4

