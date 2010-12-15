Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36962 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab0LOBRv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 20:17:51 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 17:17:36 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH] staging: ath6kl: Fixing device NULL pointer dereference
Date: Tue, 14 Dec 2010 17:17:59 -0800
Message-ID: <1292375879-32085-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing the device instance being passed to set_wiphy_dev() from
NULL to the one being returned by the MMC stack probe callback.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index a659f70..9f3e928 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1608,6 +1608,15 @@ ar6000_avail_ev(void *context, void *hif_handle)
     struct wireless_dev *wdev;
 #endif /* ATH6K_CONFIG_CFG80211 */
     A_STATUS init_status = A_OK;
+    HIF_DEVICE_OS_DEVICE_INFO osDevInfo;
+
+    A_MEMZERO(&osDevInfo, sizeof(osDevInfo));
+    if ( A_FAILED( HIFConfigureDevice(hif_handle, HIF_DEVICE_GET_OS_DEVICE,
+                    &osDevInfo, sizeof(osDevInfo))) )
+    {
+        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("%s: Failed to get OS device instance\n", __func__));
+        return A_ERROR;
+    }
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("ar6000_available\n"));
 
@@ -1627,7 +1636,8 @@ ar6000_avail_ev(void *context, void *hif_handle)
     device_index = i;
 
 #ifdef ATH6K_CONFIG_CFG80211
-    wdev = ar6k_cfg80211_init(NULL);
+    wdev = ar6k_cfg80211_init(osDevInfo.pOSDevice);
+
     if (IS_ERR(wdev)) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("%s: ar6k_cfg80211_init failed\n", __func__));
         return A_ERROR;
@@ -1672,12 +1682,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
 
 #ifdef SET_NETDEV_DEV
     if (ar_netif) { 
-        HIF_DEVICE_OS_DEVICE_INFO osDevInfo;
-        A_MEMZERO(&osDevInfo, sizeof(osDevInfo));
-        if ( A_SUCCESS( HIFConfigureDevice(hif_handle, HIF_DEVICE_GET_OS_DEVICE,
-                        &osDevInfo, sizeof(osDevInfo))) ) {
-            SET_NETDEV_DEV(dev, osDevInfo.pOSDevice);
-        }
+        SET_NETDEV_DEV(dev, osDevInfo.pOSDevice);
     }
 #endif 
 
-- 
1.6.3.3

