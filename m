Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47076 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab1C3A4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:56:40 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:16 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 02/34] ath6kl: remove BMIENABLE_SET define
Date: Tue, 29 Mar 2011 17:55:59 -0700
Message-ID: <1301446591-15236-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Leave the code in place as this is always defined statically.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/Makefile                    |    1 -
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |    2 -
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   66 ++++++++------------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    6 --
 drivers/staging/ath6kl/os/linux/ioctl.c            |   14 +---
 5 files changed, 28 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/ath6kl/Makefile b/drivers/staging/ath6kl/Makefile
index ab68078..50c1db0 100644
--- a/drivers/staging/ath6kl/Makefile
+++ b/drivers/staging/ath6kl/Makefile
@@ -126,7 +126,6 @@ ccflags-y += -DWAPI_ENABLE
 ccflags-y += -DCHECKSUM_OFFLOAD
 ccflags-y += -DWLAN_HEADERS
 ccflags-y += -DINIT_MODE_DRV_ENABLED
-ccflags-y += -DBMIENABLE_SET
 
 obj-$(CONFIG_ATH6K_LEGACY) := ath6kl.o
 ath6kl-y += htc2/AR6000/ar6k.o
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_android.c b/drivers/staging/ath6kl/os/linux/ar6000_android.c
index c96f6e9..03352b0 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_android.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_android.c
@@ -37,7 +37,6 @@ char fwpath[256] = "/system/wifi";
 int wowledon;
 unsigned int enablelogcat;
 
-extern int bmienable;
 extern struct net_device *ar6000_devices[];
 extern char ifname[];
 
@@ -309,7 +308,6 @@ static void android_late_resume(struct early_suspend *h)
 
 void android_module_init(OSDRV_CALLBACKS *osdrvCallbacks)
 {
-    bmienable = 1;
     if (ifname[0] == '\0')
         strcpy(ifname, def_ifname);
 #ifdef CONFIG_HAS_EARLYSUSPEND
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 6ca147f..6248c6d 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -118,7 +118,6 @@ struct hci_transport_callbacks ar6kHciTransCallbacks = { NULL };
 #endif
 
 unsigned int processDot11Hdr = 0;
-int bmienable = BMIENABLE_DEFAULT;
 
 char ifname[IFNAMSIZ] = {0,};
 
@@ -164,7 +163,6 @@ unsigned int eppingtest=0;
 
 module_param_string(ifname, ifname, sizeof(ifname), 0644);
 module_param(wlaninitmode, int, 0644);
-module_param(bmienable, int, 0644);
 module_param(bypasswmi, bool, 0644);
 module_param(debuglevel, uint, 0644);
 module_param(tspecCompliance, int, 0644);
@@ -1719,9 +1717,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
 
     BMIInit();
 
-    if (bmienable) {
-        ar6000_sysfs_bmi_init(ar);
-    }
+    ar6000_sysfs_bmi_init(ar);
 
     {
         struct bmi_target_info targ_info;
@@ -1791,38 +1787,31 @@ ar6000_avail_ev(void *context, void *hif_handle)
     /* when the module is unloaded.                                  */
     ar6000_devices[device_index] = dev;
 
-    /* Don't install the init function if BMI is requested */
-    if (!bmienable) {
-        ar6000_netdev_ops.ndo_init = ar6000_init;
-    } else {
-        AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("BMI enabled: %d\n", wlaninitmode));
-        if ((wlaninitmode == WLAN_INIT_MODE_UDEV) ||
-            (wlaninitmode == WLAN_INIT_MODE_DRV))
-        {
-            int status = 0;
-            do {
-                if ((status = ar6000_sysfs_bmi_get_config(ar, wlaninitmode)) != 0)
-                {
-                    AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_avail: ar6000_sysfs_bmi_get_config failed\n"));
-                    break;
-                }
+    AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("BMI enabled: %d\n", wlaninitmode));
+    if ((wlaninitmode == WLAN_INIT_MODE_UDEV) ||
+        (wlaninitmode == WLAN_INIT_MODE_DRV)) {
+        int status = 0;
+        do {
+            if ((status = ar6000_sysfs_bmi_get_config(ar, wlaninitmode)) != 0) {
+                AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_avail: ar6000_sysfs_bmi_get_config failed\n"));
+                break;
+            }
 #ifdef HTC_RAW_INTERFACE
-                if (!eppingtest && bypasswmi) {
-                    break; /* Don't call ar6000_init for ART */
-                }
+            if (!eppingtest && bypasswmi) {
+                break; /* Don't call ar6000_init for ART */
+            }
 #endif 
-                rtnl_lock();
-                status = (ar6000_init(dev)==0) ? 0 : A_ERROR;
-                rtnl_unlock();
-                if (status) {
-                    AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_avail: ar6000_init\n"));
-                }
-            } while (false);
-
+            rtnl_lock();
+            status = (ar6000_init(dev)==0) ? 0 : A_ERROR;
+            rtnl_unlock();
             if (status) {
-                init_status = status;
-                goto avail_ev_failed;
+                AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_avail: ar6000_init\n"));
             }
+        } while (false);
+
+        if (status) {
+            init_status = status;
+            goto avail_ev_failed;
         }
     }
 
@@ -1843,11 +1832,8 @@ ar6000_avail_ev(void *context, void *hif_handle)
                     (unsigned long)ar));
 
 avail_ev_failed :
-    if (init_status) {
-        if (bmienable) { 
-            ar6000_sysfs_bmi_deinit(ar);  
-        }
-    }
+    if (init_status)
+        ar6000_sysfs_bmi_deinit(ar);  
 
     return init_status;
 }
@@ -2120,9 +2106,7 @@ ar6000_destroy(struct net_device *dev, unsigned int unregister)
         /* cleanup any allocated AMSDU buffers */
     ar6000_cleanup_amsdu_rxbufs(ar);
 
-    if (bmienable) {
-        ar6000_sysfs_bmi_deinit(ar);
-    }
+    ar6000_sysfs_bmi_deinit(ar);
 
     /* Cleanup BMI */
     BMICleanup();
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 89fd80a..dc27860 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -227,12 +227,6 @@ typedef enum _AR6K_BIN_FILE {
 #define SETUPBTDEV_DEFAULT         0
 #endif /* SETUPBTDEV_ENABLED */
 
-#ifdef BMIENABLE_SET
-#define BMIENABLE_DEFAULT          1
-#else
-#define BMIENABLE_DEFAULT          0
-#endif /* BMIENABLE_SET */
-
 #ifdef ENABLEUARTPRINT_SET
 #define ENABLEUARTPRINT_DEFAULT    1
 #else
diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index 159a64c..f2acc68 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -33,7 +33,6 @@ u32 tcmdRxFreq;
 extern unsigned int wmitimeout;
 extern A_WAITQUEUE_HEAD arEvent;
 extern int tspecCompliance;
-extern int bmienable;
 extern int loghci;
 
 static int
@@ -2105,16 +2104,9 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 #endif /* CONFIG_HOST_TCMD_SUPPORT */
 
         case AR6000_XIOCTL_BMI_DONE:
-            if(bmienable)
-            {
-                rtnl_lock(); /* ar6000_init expects to be called holding rtnl lock */
-                ret = ar6000_init(dev);
-                rtnl_unlock();
-            }
-            else
-            {
-                ret = BMIDone(hifDevice);
-            }
+            rtnl_lock(); /* ar6000_init expects to be called holding rtnl lock */
+            ret = ar6000_init(dev);
+            rtnl_unlock();
             break;
 
         case AR6000_XIOCTL_BMI_READ_MEMORY:
-- 
1.7.0.4

