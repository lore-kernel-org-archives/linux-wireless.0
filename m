Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5409 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422760AbbEUTxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 15:53:15 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/10] iwlwifi: 7000: modify the firmware name for 3165
Date: Thu, 21 May 2015 22:53:02 +0300
Message-Id: <1432237990-5890-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150521_215324_123421_7003817B)
In-Reply-To: <1432237819.26813.4.camel@intel.com>
References: <1432237819.26813.4.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

3165 really needs to load iwlwifi-7265D-13.ucode. This
device is supported starting from -13.ucode, update the
MIN and OK defines accordingly. While at it, add 3165 to
the device list in the Kconfig file.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig    |  1 +
 drivers/net/wireless/iwlwifi/iwl-7000.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index ab019b4..f89f446 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -21,6 +21,7 @@ config IWLWIFI
 		Intel 7260 Wi-Fi Adapter
 		Intel 3160 Wi-Fi Adapter
 		Intel 7265 Wi-Fi Adapter
+		Intel 3165 Wi-Fi Adapter
 
 
 	  This driver uses the kernel's mac80211 subsystem.
diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 36e786f..74ad278 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -70,15 +70,14 @@
 
 /* Highest firmware API version supported */
 #define IWL7260_UCODE_API_MAX	13
-#define IWL3160_UCODE_API_MAX	13
 
 /* Oldest version we won't warn about */
 #define IWL7260_UCODE_API_OK	12
-#define IWL3160_UCODE_API_OK	12
+#define IWL3165_UCODE_API_OK	13
 
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	10
-#define IWL3160_UCODE_API_MIN	10
+#define IWL3165_UCODE_API_MIN	13
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d
@@ -104,9 +103,6 @@
 #define IWL3160_FW_PRE "iwlwifi-3160-"
 #define IWL3160_MODULE_FIRMWARE(api) IWL3160_FW_PRE __stringify(api) ".ucode"
 
-#define IWL3165_FW_PRE "iwlwifi-3165-"
-#define IWL3165_MODULE_FIRMWARE(api) IWL3165_FW_PRE __stringify(api) ".ucode"
-
 #define IWL7265_FW_PRE "iwlwifi-7265-"
 #define IWL7265_MODULE_FIRMWARE(api) IWL7265_FW_PRE __stringify(api) ".ucode"
 
@@ -248,8 +244,13 @@ static const struct iwl_ht_params iwl7265_ht_params = {
 
 const struct iwl_cfg iwl3165_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 3165",
-	.fw_name_pre = IWL3165_FW_PRE,
+	.fw_name_pre = IWL7265D_FW_PRE,
 	IWL_DEVICE_7000,
+	/* sparse doens't like the re-assignment but it is safe */
+#ifndef __CHECKER__
+	.ucode_api_ok = IWL3165_UCODE_API_OK,
+	.ucode_api_min = IWL3165_UCODE_API_MIN,
+#endif
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3165_NVM_VERSION,
 	.nvm_calib_ver = IWL3165_TX_POWER_VERSION,
@@ -325,6 +326,5 @@ const struct iwl_cfg iwl7265d_n_cfg = {
 
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
-MODULE_FIRMWARE(IWL3165_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
 MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL7265D_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-- 
2.1.4

