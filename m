Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53969 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1BRVN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:13:56 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 13:13:35 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH 01/15] staging: ath6kl: Fixing a NULL pointer exception
Date: Fri, 18 Feb 2011 13:13:02 -0800
Message-ID: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver was dereferencing a NULL pointer because of the device instance
being registered via the set_wiphy_dev() function. The function
ar6000_avail_ev() was passing the argument as NULL instead of using the one
returned by the MMC stack through the probe callback.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 26dafc9..4f6ddf7 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1604,6 +1604,14 @@ ar6000_avail_ev(void *context, void *hif_handle)
     struct wireless_dev *wdev;
 #endif /* ATH6K_CONFIG_CFG80211 */
     int init_status = 0;
+    HIF_DEVICE_OS_DEVICE_INFO osDevInfo;
+
+    memset(&osDevInfo, 0, sizeof(osDevInfo));
+    if (HIFConfigureDevice(hif_handle, HIF_DEVICE_GET_OS_DEVICE,
+        &osDevInfo, sizeof(osDevInfo))) {
+        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("%s: Failed to get OS device instance\n", __func__));
+        return A_ERROR;
+    }
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("ar6000_available\n"));
 
@@ -1623,7 +1631,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
     device_index = i;
 
 #ifdef ATH6K_CONFIG_CFG80211
-    wdev = ar6k_cfg80211_init(NULL);
+    wdev = ar6k_cfg80211_init(osDevInfo.pOSDevice);
     if (IS_ERR(wdev)) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("%s: ar6k_cfg80211_init failed\n", __func__));
         return A_ERROR;
@@ -1668,12 +1676,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
 
 #ifdef SET_NETDEV_DEV
     if (ar_netif) { 
-        HIF_DEVICE_OS_DEVICE_INFO osDevInfo;
-        A_MEMZERO(&osDevInfo, sizeof(osDevInfo));
-        if (!HIFConfigureDevice(hif_handle, HIF_DEVICE_GET_OS_DEVICE,
-				&osDevInfo, sizeof(osDevInfo))) {
-            SET_NETDEV_DEV(dev, osDevInfo.pOSDevice);
-        }
+        SET_NETDEV_DEV(dev, osDevInfo.pOSDevice);
     }
 #endif 
 
-- 
1.6.3.3

