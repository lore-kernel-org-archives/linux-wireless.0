Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7937 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbbKBIvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:51:44 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 35/38] staging: wilc1000: rename host_int_get_MacAddress function
Date: Mon, 2 Nov 2015 17:51:18 +0900
Message-ID: <1446454281-22484-35-git-send-email-glen.lee@atmel.com> (sfid-20151102_101657_583322_FD4DDB44)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename host_int_get_MacAddress function to hif_get_mac_address
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/host_interface.h | 2 +-
 drivers/staging/wilc1000/linux_wlan.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index de84c5d..5c38390 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3494,7 +3494,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
 	return 0;
 }
 
-s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
+s32 hif_get_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 510b4a5..dd33bc3 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -334,7 +334,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 					 u8 u8Psklength);
 s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 					 u8 *pu8PassPhrase, u8 u8Psklength);
-s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
+s32 hif_get_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 int host_int_wait_msg_queue_idle(void);
 s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index a4038e1..8370a90 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1114,7 +1114,7 @@ int mac_open(struct net_device *ndev)
 
 	set_machw_change_vir_if(ndev, false);
 
-	host_int_get_MacAddress(priv->hWILCWFIDrv, mac_add);
+	hif_get_mac_address(priv->hWILCWFIDrv, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	for (i = 0; i < wl->vif_num; i++) {
-- 
1.9.1

