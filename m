Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26936 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030300AbbKEFgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:36:06 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 27/38] staging: wilc1000: rename pBSSID of function linux_wlan_set_bssid
Date: Thu, 5 Nov 2015 14:36:28 +0900
Message-ID: <1446701799-24870-27-git-send-email-glen.lee@atmel.com> (sfid-20151105_063800_709778_0F71DF0C)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pBSSID of function linux_wlan_set_bssid to bssid
to avoid CamelCase naming convention.
Also, prototype linux_wlan_set_bssid in wilc_wfi_cfgoperations.c is moved to
wilc_wfi_netdevice.h.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 --
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 1 +
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6758cbc..2fac99d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -358,7 +358,7 @@ struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 	return NULL;
 }
 
-int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
+int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid)
 {
 	int i = 0;
 	int ret = -1;
@@ -370,7 +370,7 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 
 	for (i = 0; i < wilc->vif_num; i++)
 		if (wilc->vif[i].ndev == wilc_netdev) {
-			memcpy(wilc->vif[i].bssid, pBSSID, 6);
+			memcpy(wilc->vif[i].bssid, bssid, 6);
 			ret = 0;
 			break;
 		}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 32b93d3..e8c8272 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -505,8 +505,6 @@ int WILC_WFI_Set_PMKSA(u8 *bssid, struct wilc_priv *priv)
 
 
 }
-int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
-
 
 /**
  *  @brief      CfgConnectResult
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 07917ea..9b11b71 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -219,4 +219,5 @@ void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 u16 Set_machw_change_vir_if(struct net_device *dev, bool bValue);
 int linux_wlan_get_firmware(struct net_device *dev);
+int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid);
 #endif
-- 
1.9.1

