Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51937 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbbJWF1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:27:17 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/28] staging: wilc1000: host_int_init: add argument net_device
Date: Fri, 23 Oct 2015 14:28:30 +0900
Message-ID: <1445578124-31486-14-git-send-email-glen.lee@atmel.com> (sfid-20151023_074658_229442_17DE9914)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add argument net_device *dev and pass it to kthread_run.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 4 ++--
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 646e7e9..2fc0ce8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4127,7 +4127,7 @@ void host_int_send_network_info_to_host
 {
 }
 
-s32 host_int_init(struct host_if_drv **hif_drv_handler)
+s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 {
 	s32 result = 0;
 	struct host_if_drv *hif_drv;
@@ -4177,7 +4177,7 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 			goto _fail_;
 		}
 
-		hif_thread_handler = kthread_run(hostIFthread, NULL, "WILC_kthread");
+		hif_thread_handler = kthread_run(hostIFthread, dev, "WILC_kthread");
 
 		if (IS_ERR(hif_thread_handler)) {
 			PRINT_ER("Failed to creat Thread\n");
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 146a60f..f1de52e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -911,7 +911,7 @@ void host_int_send_network_info_to_host
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_init(struct host_if_drv **phWFIDrv);
+s32 host_int_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
 
 /**
  *  @brief              host interface initialization function
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5559aa6..7b21bea 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3464,7 +3464,7 @@ int wilc_init_host_int(struct net_device *net)
 	priv->bInP2PlistenState = false;
 
 	sema_init(&(priv->hSemScanReq), 1);
-	s32Error = host_int_init(&priv->hWILCWFIDrv);
+	s32Error = host_int_init(net, &priv->hWILCWFIDrv);
 	if (s32Error)
 		PRINT_ER("Error while initializing hostinterface\n");
 
-- 
1.9.1

