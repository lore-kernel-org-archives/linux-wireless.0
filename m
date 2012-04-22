Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27614 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2DVPAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 11:00:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] iwlwifi: use correct released ucode version
Date: Sun, 22 Apr 2012 07:55:27 -0700
Message-Id: <1335106527-16180-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120422_170050_256092_283C2380)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Report correctly the latest released version
of the iwlwifi firmware for all
iwlwifi-supported devices.

Cc: stable@vger.kernel.org #3.3+
Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch will be also available from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-1000.c |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-2000.c |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-5000.c |   11 +++++++++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |   10 ++++++----
 4 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5b0d888..8d80e23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -46,8 +46,8 @@
 #include "iwl-prph.h"
 
 /* Highest firmware API version supported */
-#define IWL1000_UCODE_API_MAX 6
-#define IWL100_UCODE_API_MAX 6
+#define IWL1000_UCODE_API_MAX 5
+#define IWL100_UCODE_API_MAX 5
 
 /* Oldest version we won't warn about */
 #define IWL1000_UCODE_API_OK 5
@@ -226,5 +226,5 @@ const struct iwl_cfg iwl100_bg_cfg = {
 	IWL_DEVICE_100,
 };
 
-MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL100_MODULE_FIRMWARE(IWL100_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_OK));
+MODULE_FIRMWARE(IWL100_MODULE_FIRMWARE(IWL100_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 5635b9e..ea10862 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -51,10 +51,10 @@
 #define IWL135_UCODE_API_MAX 6
 
 /* Oldest version we won't warn about */
-#define IWL2030_UCODE_API_OK 5
-#define IWL2000_UCODE_API_OK 5
-#define IWL105_UCODE_API_OK 5
-#define IWL135_UCODE_API_OK 5
+#define IWL2030_UCODE_API_OK 6
+#define IWL2000_UCODE_API_OK 6
+#define IWL105_UCODE_API_OK 6
+#define IWL135_UCODE_API_OK 6
 
 /* Lowest firmware API version supported */
 #define IWL2030_UCODE_API_MIN 5
@@ -328,7 +328,7 @@ const struct iwl_cfg iwl135_bgn_cfg = {
 	.ht_params = &iwl2000_ht_params,
 };
 
-MODULE_FIRMWARE(IWL2000_MODULE_FIRMWARE(IWL2000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL2030_MODULE_FIRMWARE(IWL2030_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL105_MODULE_FIRMWARE(IWL105_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL135_MODULE_FIRMWARE(IWL135_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL2000_MODULE_FIRMWARE(IWL2000_UCODE_API_OK));
+MODULE_FIRMWARE(IWL2030_MODULE_FIRMWARE(IWL2030_UCODE_API_OK));
+MODULE_FIRMWARE(IWL105_MODULE_FIRMWARE(IWL105_UCODE_API_OK));
+MODULE_FIRMWARE(IWL135_MODULE_FIRMWARE(IWL135_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a805e97..de0920c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -51,6 +51,10 @@
 #define IWL5000_UCODE_API_MAX 5
 #define IWL5150_UCODE_API_MAX 2
 
+/* Oldest version we won't warn about */
+#define IWL5000_UCODE_API_OK 5
+#define IWL5150_UCODE_API_OK 2
+
 /* Lowest firmware API version supported */
 #define IWL5000_UCODE_API_MIN 1
 #define IWL5150_UCODE_API_MIN 1
@@ -326,6 +330,7 @@ static const struct iwl_ht_params iwl5000_ht_params = {
 #define IWL_DEVICE_5000						\
 	.fw_name_pre = IWL5000_FW_PRE,				\
 	.ucode_api_max = IWL5000_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL5000_UCODE_API_OK,			\
 	.ucode_api_min = IWL5000_UCODE_API_MIN,			\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
@@ -371,6 +376,7 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.name = "Intel(R) WiMAX/WiFi Link 5350 AGN",
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
+	.ucode_api_ok = IWL5000_UCODE_API_OK,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,
@@ -386,6 +392,7 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 #define IWL_DEVICE_5150						\
 	.fw_name_pre = IWL5150_FW_PRE,				\
 	.ucode_api_max = IWL5150_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL5150_UCODE_API_OK,			\
 	.ucode_api_min = IWL5150_UCODE_API_MIN,			\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
@@ -409,5 +416,5 @@ const struct iwl_cfg iwl5150_abg_cfg = {
 	IWL_DEVICE_5150,
 };
 
-MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_OK));
+MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 64060cd..b1b6951 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -53,6 +53,8 @@
 /* Oldest version we won't warn about */
 #define IWL6000_UCODE_API_OK 4
 #define IWL6000G2_UCODE_API_OK 5
+#define IWL6050_UCODE_API_OK 5
+#define IWL6000G2B_UCODE_API_OK 6
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
@@ -334,7 +336,7 @@ static const struct iwl_bt_params iwl6000_bt_params = {
 #define IWL_DEVICE_6005						\
 	.fw_name_pre = IWL6005_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
-	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
+	.ucode_api_ok = IWL6000G2B_UCODE_API_OK,		\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
@@ -557,6 +559,6 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_OK));
-MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_OK));
+MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_OK));
+MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2B_UCODE_API_OK));
-- 
1.7.0.4

