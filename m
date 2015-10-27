Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58161 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbJ0J0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:26:21 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 13/27] staging: wilc1000: host_int_init: add argument net_device
Date: Tue, 27 Oct 2015 18:27:49 +0900
Message-ID: <1445938083-20445-13-git-send-email-glen.lee@atmel.com> (sfid-20151027_102624_074063_403AAF50)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add argument net_device and pass netdev private data member wilc
to kthread_run. Pass net_device to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 11 +++++++++--
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 930dcba..f658594 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7,6 +7,7 @@
 #include "wilc_wlan_if.h"
 #include "wilc_msgqueue.h"
 #include <linux/etherdevice.h>
+#include "wilc_wfi_netdevice.h"
 
 extern u8 connecting;
 
@@ -4131,11 +4132,16 @@ void host_int_send_network_info_to_host
 {
 }
 
-s32 host_int_init(struct host_if_drv **hif_drv_handler)
+s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 {
 	s32 result = 0;
 	struct host_if_drv *hif_drv;
 	int err;
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
+
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
 
 	PRINT_D(HOSTINF_DBG, "Initializing host interface for client %d\n", clients_count + 1);
 
@@ -4181,7 +4187,8 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 			goto _fail_;
 		}
 
-		hif_thread_handler = kthread_run(hostIFthread, NULL, "WILC_kthread");
+		hif_thread_handler = kthread_run(hostIFthread, wilc,
+						 "WILC_kthread");
 
 		if (IS_ERR(hif_thread_handler)) {
 			PRINT_ER("Failed to creat Thread\n");
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f3fb628..0fd2eda 100644
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
index ac32d2b..21d053d 100644
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

