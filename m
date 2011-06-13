Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:45490 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab1FMIyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 04:54:24 -0400
Subject: [PATCH 2/2] ath6kl: cache firmware
To: gregkh@suse.de
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Mon, 13 Jun 2011 11:54:18 +0300
Message-ID: <20110613085418.15065.59377.stgit@localhost6.localdomain6> (sfid-20110613_105427_846221_C56622C4)
In-Reply-To: <20110613085118.15065.16173.stgit@localhost6.localdomain6>
References: <20110613085118.15065.16173.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers should not request firmware during resume. Fix ath6kl to
cache the firmware instead.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   49 ++++++++++++++------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    9 ++++
 2 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 48dd9e3..aa97efc 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -954,9 +954,13 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
     const char *filename;
     const struct firmware *fw_entry;
     u32 fw_entry_size;
+    u8 **buf;
+    size_t *buf_len;
 
     switch (file) {
         case AR6K_OTP_FILE:
+		buf = &ar->fw_otp;
+		buf_len = &ar->fw_otp_len;
             if (ar->arVersion.target_ver == AR6003_REV1_VERSION) {
                 filename = AR6003_REV1_OTP_FILE;
             } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
@@ -970,6 +974,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
             break;
 
         case AR6K_FIRMWARE_FILE:
+		buf = &ar->fw;
+		buf_len = &ar->fw_len;
             if (ar->arVersion.target_ver == AR6003_REV1_VERSION) {
                 filename = AR6003_REV1_FIRMWARE_FILE;
             } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
@@ -1028,6 +1034,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
             break;
 
         case AR6K_PATCH_FILE:
+		buf = &ar->fw_patch;
+		buf_len = &ar->fw_patch_len;
             if (ar->arVersion.target_ver == AR6003_REV1_VERSION) {
                 filename = AR6003_REV1_PATCH_FILE;
             } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
@@ -1041,6 +1049,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
             break;
 
         case AR6K_BOARD_DATA_FILE:
+		buf = &ar->fw_data;
+		buf_len = &ar->fw_data_len;
             if (ar->arVersion.target_ver == AR6003_REV1_VERSION) {
                 filename = AR6003_REV1_BOARD_DATA_FILE;
             } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
@@ -1057,23 +1067,29 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown file type: %d\n", file));
             return A_ERROR;
     }
-    if ((A_REQUEST_FIRMWARE(&fw_entry, filename, ((struct device *)ar->osDevInfo.pOSDevice))) != 0)
-    {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Failed to get %s\n", filename));
-        return A_ENOENT;
+
+    if (*buf == NULL) {
+	    if ((A_REQUEST_FIRMWARE(&fw_entry, filename, ((struct device *)ar->osDevInfo.pOSDevice))) != 0) {
+		    AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Failed to get %s\n", filename));
+		    return A_ENOENT;
+	    }
+
+	    *buf = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
+	    *buf_len = fw_entry->size;
+	    A_RELEASE_FIRMWARE(fw_entry);
     }
 
 #ifdef SOFTMAC_FILE_USED
-    if (file==AR6K_BOARD_DATA_FILE && fw_entry->data) {
-        ar6000_softmac_update(ar, (u8 *)fw_entry->data, fw_entry->size);
+    if (file==AR6K_BOARD_DATA_FILE && *buf_len) {
+        ar6000_softmac_update(ar, *buf, *buf_len);
     }
 #endif 
 
 
-    fw_entry_size = fw_entry->size;
+    fw_entry_size = *buf_len;
 
     /* Load extended board data for AR6003 */
-    if ((file==AR6K_BOARD_DATA_FILE) && (fw_entry->data)) {
+    if ((file==AR6K_BOARD_DATA_FILE) && *buf) {
         u32 board_ext_address;
         u32 board_ext_data_size;
         u32 board_data_size;
@@ -1089,14 +1105,13 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("Board extended Data download address: 0x%x\n", board_ext_address));
 
         /* check whether the target has allocated memory for extended board data and file contains extended board data */
-        if ((board_ext_address) && (fw_entry->size == (board_data_size + board_ext_data_size))) {
+        if ((board_ext_address) && (*buf_len == (board_data_size + board_ext_data_size))) {
             u32 param;
 
-            status = BMIWriteMemory(ar->arHifDevice, board_ext_address, (u8 *)(fw_entry->data + board_data_size), board_ext_data_size);
+            status = BMIWriteMemory(ar->arHifDevice, board_ext_address, (u8 *)(*buf + board_data_size), board_ext_data_size);
 
             if (status) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI operation failed: %d\n", __LINE__));
-                A_RELEASE_FIRMWARE(fw_entry);
                 return A_ERROR;
             }
 
@@ -1110,17 +1125,16 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
     }
 
     if (compressed) {
-        status = BMIFastDownload(ar->arHifDevice, address, (u8 *)fw_entry->data, fw_entry_size);
+        status = BMIFastDownload(ar->arHifDevice, address, *buf, fw_entry_size);
     } else {
-        status = BMIWriteMemory(ar->arHifDevice, address, (u8 *)fw_entry->data, fw_entry_size);
+        status = BMIWriteMemory(ar->arHifDevice, address, *buf, fw_entry_size);
     }
 
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI operation failed: %d\n", __LINE__));
-        A_RELEASE_FIRMWARE(fw_entry);
         return A_ERROR;
     }
-    A_RELEASE_FIRMWARE(fw_entry);
+
     return 0;
 }
 
@@ -2088,6 +2102,11 @@ ar6000_destroy(struct net_device *dev, unsigned int unregister)
     ar6000_remove_ap_interface();
 #endif /*CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT */
 
+    kfree(ar->fw_otp);
+    kfree(ar->fw);
+    kfree(ar->fw_patch);
+    kfree(ar->fw_data);
+
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("-ar6000_destroy \n"));
 }
 
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 22453b0..2911ea0 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -651,6 +651,15 @@ struct ar6_softc {
     void                    *arApDev;
 #endif
     u8 arAutoAuthStage;
+
+	u8 *fw_otp;
+	size_t fw_otp_len;
+	u8 *fw;
+	size_t fw_len;
+	u8 *fw_patch;
+	size_t fw_patch_len;
+	u8 *fw_data;
+	size_t fw_data_len;
 };
 
 #ifdef CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT

