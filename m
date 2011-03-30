Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47149 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309Ab1C3A5R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:17 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 17/34] ath6kl: remove INIT_MODE_DRV_ENABLED define
Date: Tue, 29 Mar 2011 17:56:14 -0700
Message-ID: <1301446591-15236-18-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since this is defined statically we just leave the code.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/Makefile                    |    1 -
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   14 ++++----------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    4 ----
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ath6kl/Makefile b/drivers/staging/ath6kl/Makefile
index cd04fba..8a46e93 100644
--- a/drivers/staging/ath6kl/Makefile
+++ b/drivers/staging/ath6kl/Makefile
@@ -112,7 +112,6 @@ endif
 
 ccflags-y += -DWAPI_ENABLE
 ccflags-y += -DCHECKSUM_OFFLOAD
-ccflags-y += -DINIT_MODE_DRV_ENABLED
 
 obj-$(CONFIG_ATH6K_LEGACY) := ath6kl.o
 ath6kl-y += htc2/AR6000/ar6k.o
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index b9d0471..8f9e4b2 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -852,8 +852,6 @@ ar6000_sysfs_bmi_deinit(struct ar6_softc *ar)
     } \
 } while(0)
 
-#ifdef INIT_MODE_DRV_ENABLED
-
 #ifdef SOFTMAC_FILE_USED
 #define AR6002_MAC_ADDRESS_OFFSET     0x0A
 #define AR6003_MAC_ADDRESS_OFFSET     0x16
@@ -1111,7 +1109,6 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
     A_RELEASE_FIRMWARE(fw_entry);
     return 0;
 }
-#endif /* INIT_MODE_DRV_ENABLED */
 
 int
 ar6000_update_bdaddr(struct ar6_softc *ar)
@@ -1158,7 +1155,6 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
         }
 
         A_RELEASE_FIRMWARE(fw_entry);
-#ifdef INIT_MODE_DRV_ENABLED
     } else {
         /* The config is contained within the driver itself */
         int status;
@@ -1348,8 +1344,6 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
             msleep(1000);
         }
 #endif /* HTC_RAW_INTERFACE */
-
-#endif /* INIT_MODE_DRV_ENABLED */
     }
 
     return 0;
@@ -2340,10 +2334,10 @@ u8 ar6000_endpoint_id2_ac(void * devt, HTC_ENDPOINT_ID ep )
 int ar6000_target_config_wlan_params(struct ar6_softc *ar)
 {
     int status = 0;
-#if defined(INIT_MODE_DRV_ENABLED) && defined(ENABLE_COEXISTENCE)
+#if defined(ENABLE_COEXISTENCE)
     WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD sbcb_cmd;
     WMI_SET_BTCOEX_FE_ANT_CMD sbfa_cmd;
-#endif /* INIT_MODE_DRV_ENABLED && ENABLE_COEXISTENCE */
+#endif /* ENABLE_COEXISTENCE */
 
 #ifdef CONFIG_HOST_TCMD_SUPPORT
     if (ar->arTargetMode != AR6000_WLAN_MODE) {
@@ -2361,7 +2355,7 @@ int ar6000_target_config_wlan_params(struct ar6_softc *ar)
         status = A_ERROR;
     }
 
-#if defined(INIT_MODE_DRV_ENABLED) && defined(ENABLE_COEXISTENCE)
+#if defined(ENABLE_COEXISTENCE)
     /* Configure the type of BT collocated with WLAN */
     memset(&sbcb_cmd, 0, sizeof(WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD));
 #ifdef CONFIG_AR600x_BT_QCOM
@@ -2393,7 +2387,7 @@ int ar6000_target_config_wlan_params(struct ar6_softc *ar)
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Unable to set fornt end antenna configuration\n"));
         status = A_ERROR;
     }
-#endif /* INIT_MODE_DRV_ENABLED && ENABLE_COEXISTENCE */
+#endif /* ENABLE_COEXISTENCE */
 
 #if WLAN_CONFIG_IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN
     if ((wmi_pmparams_cmd(ar->arWmi, 0, 1, 0, 0, 1, IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN)) != 0) {
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 23427cf..205a7bf 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -238,11 +238,7 @@ typedef enum _AR6K_BIN_FILE {
 #define HCIUARTSTEP_DEFAULT        0
 #endif /* AR600x_BT_AR3001 */
 
-#ifdef INIT_MODE_DRV_ENABLED
 #define WLAN_INIT_MODE_DEFAULT     WLAN_INIT_MODE_DRV
-#else
-#define WLAN_INIT_MODE_DEFAULT     WLAN_INIT_MODE_USR
-#endif /* INIT_MODE_DRV_ENABLED */
 
 #define AR6K_PATCH_DOWNLOAD_ADDRESS(_param, _ver) do { \
     if ((_ver) == AR6003_REV1_VERSION) { \
-- 
1.7.0.4

