Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27582 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab1GWSBV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 14:01:21 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/11] iwlagn: bump firmware API for some devices
Date: Sat, 23 Jul 2011 10:24:45 -0700
Message-Id: <1311441890-19959-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110723_200138_184496_4477995C)
In-Reply-To: <1311441890-19959-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311441890-19959-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We're working on improvements for the firmware
for some devices, and need to bump the API for
those since they won't be backward compatible
completely (the earlier patch reserving queue
10 for P2P).

Bump the API version to 6 for those devices
but don't warn users of version 5 yet.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |   10 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-2000.c |   18 ++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-6000.c |   11 ++++++++---
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 97b9c74..683f5bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -46,8 +46,12 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL1000_UCODE_API_MAX 5
-#define IWL100_UCODE_API_MAX 5
+#define IWL1000_UCODE_API_MAX 6
+#define IWL100_UCODE_API_MAX 6
+
+/* Oldest version we won't warn about */
+#define IWL1000_UCODE_API_OK 5
+#define IWL100_UCODE_API_OK 5
 
 /* Lowest firmware API version supported */
 #define IWL1000_UCODE_API_MIN 1
@@ -206,6 +210,7 @@ static struct iwl_ht_params iwl1000_ht_params = {
 #define IWL_DEVICE_1000						\
 	.fw_name_pre = IWL1000_FW_PRE,				\
 	.ucode_api_max = IWL1000_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL1000_UCODE_API_OK,			\
 	.ucode_api_min = IWL1000_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
@@ -227,6 +232,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 #define IWL_DEVICE_100						\
 	.fw_name_pre = IWL100_FW_PRE,				\
 	.ucode_api_max = IWL100_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL100_UCODE_API_OK,			\
 	.ucode_api_min = IWL100_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index d557ef3..cdc7428 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -47,10 +47,16 @@
 #include "iwl-6000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL2030_UCODE_API_MAX 5
-#define IWL2000_UCODE_API_MAX 5
-#define IWL105_UCODE_API_MAX 5
-#define IWL135_UCODE_API_MAX 5
+#define IWL2030_UCODE_API_MAX 6
+#define IWL2000_UCODE_API_MAX 6
+#define IWL105_UCODE_API_MAX 6
+#define IWL135_UCODE_API_MAX 6
+
+/* Oldest version we won't warn about */
+#define IWL2030_UCODE_API_OK 5
+#define IWL2000_UCODE_API_OK 5
+#define IWL105_UCODE_API_OK 5
+#define IWL135_UCODE_API_OK 5
 
 /* Lowest firmware API version supported */
 #define IWL2030_UCODE_API_MIN 5
@@ -255,6 +261,7 @@ static struct iwl_bt_params iwl2030_bt_params = {
 #define IWL_DEVICE_2000						\
 	.fw_name_pre = IWL2000_FW_PRE,				\
 	.ucode_api_max = IWL2000_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL2000_UCODE_API_OK,			\
 	.ucode_api_min = IWL2000_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
@@ -279,6 +286,7 @@ struct iwl_cfg iwl2000_2bg_cfg = {
 #define IWL_DEVICE_2030						\
 	.fw_name_pre = IWL2030_FW_PRE,				\
 	.ucode_api_max = IWL2030_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL2030_UCODE_API_OK,			\
 	.ucode_api_min = IWL2030_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
@@ -305,6 +313,7 @@ struct iwl_cfg iwl2030_2bg_cfg = {
 #define IWL_DEVICE_105						\
 	.fw_name_pre = IWL105_FW_PRE,				\
 	.ucode_api_max = IWL105_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL105_UCODE_API_OK,			\
 	.ucode_api_min = IWL105_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
@@ -331,6 +340,7 @@ struct iwl_cfg iwl105_bgn_cfg = {
 #define IWL_DEVICE_135						\
 	.fw_name_pre = IWL135_FW_PRE,				\
 	.ucode_api_max = IWL135_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL135_UCODE_API_OK,			\
 	.ucode_api_min = IWL135_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 973d197..12838c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -50,7 +50,10 @@
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 4
 #define IWL6050_UCODE_API_MAX 5
-#define IWL6000G2_UCODE_API_MAX 5
+#define IWL6000G2_UCODE_API_MAX 6
+
+/* Oldest version we won't warn about */
+#define IWL6000G2_UCODE_API_OK 5
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
@@ -365,8 +368,9 @@ static struct iwl_bt_params iwl6000_bt_params = {
 };
 
 #define IWL_DEVICE_6005						\
-	.fw_name_pre = IWL6005_FW_PRE,			\
+	.fw_name_pre = IWL6005_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
+	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.eeprom_ver = EEPROM_6005_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
@@ -393,8 +397,9 @@ struct iwl_cfg iwl6005_2bg_cfg = {
 };
 
 #define IWL_DEVICE_6030						\
-	.fw_name_pre = IWL6030_FW_PRE,			\
+	.fw_name_pre = IWL6030_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
+	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
-- 
1.7.0.4

