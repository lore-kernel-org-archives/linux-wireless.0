Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37216 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbbKFCOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:14:52 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 44/73] staging: wilc1000: rename bValue in set_machw_change_vir_if function
Date: Fri, 6 Nov 2015 11:13:05 +0900
Message-ID: <1446776014-28094-44-git-send-email-glen.lee@atmel.com> (sfid-20151106_033757_890414_EB3E94CC)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename bValue to value that is second argument of
set_machw_change_vir_if function to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c          | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 6f9da09..54ed723 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -217,7 +217,7 @@ void wl_wlan_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
-u16 set_machw_change_vir_if(struct net_device *dev, bool bValue);
+u16 set_machw_change_vir_if(struct net_device *dev, bool value);
 int linux_wlan_get_firmware(struct net_device *dev);
 int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c4118fe..458eef2b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1715,7 +1715,7 @@ _fail_:
 	return ret;
 }
 
-u16 set_machw_change_vir_if(struct net_device *dev, bool bValue)
+u16 set_machw_change_vir_if(struct net_device *dev, bool value)
 {
 	u16 ret;
 	u32 reg;
@@ -1730,7 +1730,7 @@ u16 set_machw_change_vir_if(struct net_device *dev, bool bValue)
 	if (!ret)
 		PRINT_ER("Error while Reading reg WILC_CHANGING_VIR_IF\n");
 
-	if (bValue)
+	if (value)
 		reg |= BIT(31);
 	else
 		reg &= ~BIT(31);
-- 
1.9.1

