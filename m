Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27125 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103AbbKEFgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:36:51 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 35/38] staging: wilc1000: rename host_int_get_MacAddress function
Date: Thu, 5 Nov 2015 14:36:36 +0900
Message-ID: <1446701799-24870-35-git-send-email-glen.lee@atmel.com> (sfid-20151105_063701_359227_782E8BE0)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
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
index d0e4039..84a2479 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3396,7 +3396,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
 	return 0;
 }
 
-s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
+s32 hif_get_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f73817a..f70da75 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -333,7 +333,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 					 u8 u8Psklength);
 s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 					 u8 *pu8PassPhrase, u8 u8Psklength);
-s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
+s32 hif_get_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 int host_int_wait_msg_queue_idle(void);
 s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 79e755c..f2de20b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1109,7 +1109,7 @@ int mac_open(struct net_device *ndev)
 
 	set_machw_change_vir_if(ndev, false);
 
-	host_int_get_MacAddress(priv->hWILCWFIDrv, mac_add);
+	hif_get_mac_address(priv->hWILCWFIDrv, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	for (i = 0; i < wl->vif_num; i++) {
-- 
1.9.1

