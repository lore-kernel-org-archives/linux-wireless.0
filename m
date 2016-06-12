Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34751 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbcFLX2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2016 19:28:38 -0400
Received: by mail-pf0-f193.google.com with SMTP id 66so7385386pfy.1
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2016 16:28:37 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/6] staging: wilc1000: add bss_type to remove line over 80 characters
Date: Mon, 13 Jun 2016 08:28:14 +0900
Message-Id: <20160612232815.12112-5-chaehyun.lim@gmail.com> (sfid-20160613_012841_418137_14DF13B6)
In-Reply-To: <20160612232815.12112-1-chaehyun.lim@gmail.com>
References: <20160612232815.12112-1-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A local bss_type variable is added to remove checkpatch warning of
line over 80 characters.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 96821f6..828efff 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -427,12 +427,14 @@ static void handle_cfg_param(struct wilc_vif *vif,
 	mutex_lock(&hif_drv->cfg_values_lock);
 
 	if (cfg_param_attr->flag & BSS_TYPE) {
-		if (cfg_param_attr->bss_type < 6) {
+		u8 bss_type = cfg_param_attr->bss_type;
+
+		if (bss_type < 6) {
 			wid_list[i].id = WID_BSS_TYPE;
-			wid_list[i].val = (s8 *)&cfg_param_attr->bss_type;
+			wid_list[i].val = (s8 *)&bss_type;
 			wid_list[i].type = WID_CHAR;
 			wid_list[i].size = sizeof(char);
-			hif_drv->cfg_values.bss_type = (u8)cfg_param_attr->bss_type;
+			hif_drv->cfg_values.bss_type = (u8)bss_type;
 		} else {
 			netdev_err(vif->ndev, "check value 6 over\n");
 			goto unlock;
-- 
2.8.4

