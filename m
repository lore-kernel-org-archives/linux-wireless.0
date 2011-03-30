Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47082 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281Ab1C3A4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:56:41 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 03/34] ath6kl: propagate error values on ar6000_avail_ev()
Date: Tue, 29 Mar 2011 17:56:00 -0700
Message-ID: <1301446591-15236-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When something fails we set up some generic error values,
instead keep the values from the callers and make sure to
pass them on.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |   51 ++++++++++++--------------
 1 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 6248c6d..846eea7 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1601,7 +1601,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
 #ifdef ATH6K_CONFIG_CFG80211
     struct wireless_dev *wdev;
 #endif /* ATH6K_CONFIG_CFG80211 */
-    int init_status = 0;
+    int r = 0;
     struct hif_device_os_device_info osDevInfo;
 
     memset(&osDevInfo, 0, sizeof(osDevInfo));
@@ -1722,28 +1722,25 @@ ar6000_avail_ev(void *context, void *hif_handle)
     {
         struct bmi_target_info targ_info;
 
-        if (BMIGetTargetInfo(ar->arHifDevice, &targ_info) != 0) {
-            init_status = A_ERROR;
+        r = BMIGetTargetInfo(ar->arHifDevice, &targ_info);
+        if (r)
             goto avail_ev_failed;
-        }
 
         ar->arVersion.target_ver = targ_info.target_ver;
         ar->arTargetType = targ_info.target_type;
 
-            /* do any target-specific preparation that can be done through BMI */
-        if (ar6000_prepare_target(ar->arHifDevice,
+        /* do any target-specific preparation that can be done through BMI */
+        r = ar6000_prepare_target(ar->arHifDevice,
                                   targ_info.target_type,
-                                  targ_info.target_ver) != 0) {
-            init_status = A_ERROR;
+                                  targ_info.target_ver);
+        if (r)
             goto avail_ev_failed;
-        }
 
     }
 
-    if (ar6000_configure_target(ar) != 0) {
-            init_status = A_ERROR;
+    r = ar6000_configure_target(ar);
+    if (r)
             goto avail_ev_failed;
-    }
 
     A_MEMZERO(&htcInfo,sizeof(htcInfo));
     htcInfo.pContext = ar;
@@ -1751,8 +1748,8 @@ ar6000_avail_ev(void *context, void *hif_handle)
 
     ar->arHtcTarget = HTCCreate(ar->arHifDevice,&htcInfo);
 
-    if (ar->arHtcTarget == NULL) {
-        init_status = A_ERROR;
+    if (!ar->arHtcTarget) {
+        r = -ENOMEM;
         goto avail_ev_failed;
     }
 
@@ -1771,9 +1768,10 @@ ar6000_avail_ev(void *context, void *hif_handle)
 #endif
 
 #ifdef ATH_AR6K_11N_SUPPORT
-    if((ar->aggr_cntxt = aggr_init(ar6000_alloc_netbufs)) == NULL) {
+    ar->aggr_cntxt = aggr_init(ar6000_alloc_netbufs);
+    if (!ar->aggr_cntxt) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("%s() Failed to initialize aggr.\n", __func__));
-            init_status = A_ERROR;
+            r = -ENOMEM;
             goto avail_ev_failed;
     }
 
@@ -1790,9 +1788,9 @@ ar6000_avail_ev(void *context, void *hif_handle)
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("BMI enabled: %d\n", wlaninitmode));
     if ((wlaninitmode == WLAN_INIT_MODE_UDEV) ||
         (wlaninitmode == WLAN_INIT_MODE_DRV)) {
-        int status = 0;
         do {
-            if ((status = ar6000_sysfs_bmi_get_config(ar, wlaninitmode)) != 0) {
+            r = ar6000_sysfs_bmi_get_config(ar, wlaninitmode);
+            if (r) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_avail: ar6000_sysfs_bmi_get_config failed\n"));
                 break;
             }
@@ -1802,24 +1800,23 @@ ar6000_avail_ev(void *context, void *hif_handle)
             }
 #endif 
             rtnl_lock();
-            status = (ar6000_init(dev)==0) ? 0 : A_ERROR;
+            r = ar6000_init(dev);
             rtnl_unlock();
-            if (status) {
+            if (r) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_avail: ar6000_init\n"));
             }
         } while (false);
 
-        if (status) {
-            init_status = status;
+        if (r)
             goto avail_ev_failed;
-        }
     }
 
     /* This runs the init function if registered */
-    if (register_netdev(dev)) {
+    r = register_netdev(dev);
+    if (r) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_avail: register_netdev failed\n"));
         ar6000_destroy(dev, 0);
-        return A_ERROR;
+        return r;
     }
 
 	is_netdev_registered = 1;
@@ -1832,10 +1829,10 @@ ar6000_avail_ev(void *context, void *hif_handle)
                     (unsigned long)ar));
 
 avail_ev_failed :
-    if (init_status)
+    if (r)
         ar6000_sysfs_bmi_deinit(ar);  
 
-    return init_status;
+    return r;
 }
 
 static void ar6000_target_failure(void *Instance, int Status)
-- 
1.7.0.4

