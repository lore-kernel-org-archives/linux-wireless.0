Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:56488 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965478AbbJ3JoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 05:44:24 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 01/17] staging: wilc1000: define wiphy private data priv in struct host_if_drv
Date: Fri, 30 Oct 2015 18:47:07 +0900
Message-ID: <1446198443-6623-1-git-send-email-glen.lee@atmel.com> (sfid-20151030_104427_617774_3EB6A65E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch defines wiphy private data priv in struct host_if_drv and set
priv to priv in host_if_drv to reference it's wiphy private data.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h         | 1 +
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 72c4797..f9efb5a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -260,6 +260,7 @@ enum p2p_listen_state {
 };
 
 struct host_if_drv {
+	struct wilc_priv *priv;
 	struct user_scan_req usr_scan_req;
 	struct user_conn_req usr_conn_req;
 	struct remain_ch remain_on_ch;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 32b93d3..8554f6f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3478,6 +3478,7 @@ int wilc_init_host_int(struct net_device *net)
 	s32Error = host_int_init(net, &priv->hWILCWFIDrv);
 	if (s32Error)
 		PRINT_ER("Error while initializing hostinterface\n");
+	priv->hWILCWFIDrv->priv = priv;
 
 	return s32Error;
 }
-- 
1.9.1

