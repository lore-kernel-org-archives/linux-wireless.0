Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20470 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab1CNR70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:26 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 09/38] ath6kl: remove-typedef HIF_DEVICE_OS_DEVICE_INFO
Date: Mon, 14 Mar 2011 10:58:43 -0700
Message-ID: <1300125552-24422-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HIF_DEVICE_OS_DEVICE_INFO \
	"struct hif_device_os_device_info" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |    2 +-
 drivers/staging/ath6kl/include/hif.h               |    6 +++---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   10 +++++-----
 .../staging/ath6kl/os/linux/export_hci_transport.c |    4 ++--
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |    2 +-
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 9b947b4..6d3b9f4 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -730,7 +730,7 @@ HIFConfigureDevice(HIF_DEVICE *device, HIF_DEVICE_CONFIG_OPCODE opcode,
             break; 
         case HIF_DEVICE_GET_OS_DEVICE:
                 /* pass back a pointer to the SDIO function's "dev" struct */
-            ((HIF_DEVICE_OS_DEVICE_INFO *)config)->pOSDevice = &device->func->dev;
+            ((struct hif_device_os_device_info *)config)->pOSDevice = &device->func->dev;
             break; 
         case HIF_DEVICE_POWER_STATE_CHANGE:
             status = PowerStateChangeNotify(device, *(HIF_DEVICE_POWER_CHANGE_TYPE *)config);
diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index 8df01b3..2c0f490 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -211,7 +211,7 @@ typedef enum {
  * 
  *   HIF_DEVICE_GET_OS_DEVICE
  *   intput : none
- *   output : HIF_DEVICE_OS_DEVICE_INFO;
+ *   output : struct hif_device_os_device_info;
  *   note: On some operating systems, the HIF layer has a parent device object for the bus.  This object
  *         may be required to register certain types of logical devices.
  * 
@@ -315,9 +315,9 @@ typedef struct _HIF_DEVICE_SCATTER_SUPPORT_INFO {
     int                             MaxTransferSizePerScatterReq;
 } HIF_DEVICE_SCATTER_SUPPORT_INFO;
                       
-typedef struct {
+struct hif_device_os_device_info {
     void    *pOSDevice;
-} HIF_DEVICE_OS_DEVICE_INFO;
+};
                       
 #define HIF_MAX_DEVICES                 1
 
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 749e284..b739943 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -803,7 +803,7 @@ ar6000_sysfs_bmi_read(struct file *fp, struct kobject *kobj,
 {
     int index;
     AR_SOFTC_T *ar;
-    HIF_DEVICE_OS_DEVICE_INFO   *osDevInfo;
+    struct hif_device_os_device_info   *osDevInfo;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("BMI: Read %d bytes\n", (u32)count));
     for (index=0; index < MAX_AR6000; index++) {
@@ -830,7 +830,7 @@ ar6000_sysfs_bmi_write(struct file *fp, struct kobject *kobj,
 {
     int index;
     AR_SOFTC_T *ar;
-    HIF_DEVICE_OS_DEVICE_INFO   *osDevInfo;
+    struct hif_device_os_device_info   *osDevInfo;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("BMI: Write %d bytes\n", (u32)count));
     for (index=0; index < MAX_AR6000; index++) {
@@ -856,13 +856,13 @@ ar6000_sysfs_bmi_init(AR_SOFTC_T *ar)
     int status;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("BMI: Creating sysfs entry\n"));
-    A_MEMZERO(&ar->osDevInfo, sizeof(HIF_DEVICE_OS_DEVICE_INFO));
+    A_MEMZERO(&ar->osDevInfo, sizeof(struct hif_device_os_device_info));
 
     /* Get the underlying OS device */
     status = HIFConfigureDevice(ar->arHifDevice,
                                 HIF_DEVICE_GET_OS_DEVICE,
                                 &ar->osDevInfo,
-                                sizeof(HIF_DEVICE_OS_DEVICE_INFO));
+                                sizeof(struct hif_device_os_device_info));
 
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI: Failed to get OS device info from HIF\n"));
@@ -1604,7 +1604,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
     struct wireless_dev *wdev;
 #endif /* ATH6K_CONFIG_CFG80211 */
     int init_status = 0;
-    HIF_DEVICE_OS_DEVICE_INFO osDevInfo;
+    struct hif_device_os_device_info osDevInfo;
 
     memset(&osDevInfo, 0, sizeof(osDevInfo));
     if (HIFConfigureDevice(hif_handle, HIF_DEVICE_GET_OS_DEVICE,
diff --git a/drivers/staging/ath6kl/os/linux/export_hci_transport.c b/drivers/staging/ath6kl/os/linux/export_hci_transport.c
index fd87526..79b30eb 100644
--- a/drivers/staging/ath6kl/os/linux/export_hci_transport.c
+++ b/drivers/staging/ath6kl/os/linux/export_hci_transport.c
@@ -76,8 +76,8 @@ ar6000_get_hif_dev(HIF_DEVICE *device, void *config)
 
     status = HIFConfigureDevice(device,
                                 HIF_DEVICE_GET_OS_DEVICE,
-                                (HIF_DEVICE_OS_DEVICE_INFO *)config, 
-                                sizeof(HIF_DEVICE_OS_DEVICE_INFO));
+                                (struct hif_device_os_device_info *)config, 
+                                sizeof(struct hif_device_os_device_info));
     return status;
 }
 
diff --git a/drivers/staging/ath6kl/os/linux/hci_bridge.c b/drivers/staging/ath6kl/os/linux/hci_bridge.c
index 4500f84..d30ca24 100644
--- a/drivers/staging/ath6kl/os/linux/hci_bridge.c
+++ b/drivers/staging/ath6kl/os/linux/hci_bridge.c
@@ -857,7 +857,7 @@ static int bt_setup_hci(struct ar6k_hci_bridge_info *pHcidevInfo)
 {
     int                    status = 0;
     struct hci_dev              *pHciDev = NULL;
-    HIF_DEVICE_OS_DEVICE_INFO   osDevInfo;
+    struct hif_device_os_device_info   osDevInfo;
     
     if (!setupbtdev) {
         return 0;
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 2373ed5..a209133 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -596,7 +596,7 @@ typedef struct ar6_softc {
 	WMI_BTCOEX_CONFIG_EVENT arBtcoexConfig;
 	WMI_BTCOEX_STATS_EVENT  arBtcoexStats;
     s32 (*exitCallback)(void *config);  /* generic callback at AR6K exit */
-    HIF_DEVICE_OS_DEVICE_INFO   osDevInfo;
+    struct hif_device_os_device_info   osDevInfo;
 #ifdef ATH6K_CONFIG_CFG80211
     struct wireless_dev *wdev;
     struct cfg80211_scan_request    *scan_request;
-- 
1.7.4.15.g7811d

