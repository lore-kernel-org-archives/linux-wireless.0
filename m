Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7573 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbbKBIuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:50:11 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 19/38] staging: wilc1000: remove extern function in c file and move it to header file.
Date: Mon, 2 Nov 2015 17:51:02 +0900
Message-ID: <1446454281-22484-19-git-send-email-glen.lee@atmel.com> (sfid-20151102_095016_359800_3D33EE8E)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes extern resolve_disconnect_aberration in c file and move
it to proper header file. Rename argument also to match with declaration.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 drivers/staging/wilc1000/linux_wlan.c     | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f9efb5a..510b4a5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -421,5 +421,5 @@ void host_int_freeJoinParams(void *pJoinParams);
 
 s32 host_int_get_statistics(struct host_if_drv *hWFIDrv,
 			    struct rf_info *pstrStatistics);
-
+void resolve_disconnect_aberration(struct host_if_drv *hif_drv);
 #endif
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 82495ce..ab4ab1f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -39,7 +39,6 @@
  #define _linux_wlan_device_removal()		{}
 
 extern bool g_obtainingIP;
-extern void resolve_disconnect_aberration(void *drvHandler);
 extern u8 multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 extern struct timer_list hDuringIpTimer;
 
-- 
1.9.1

