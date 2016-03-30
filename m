Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35571 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbcC3OGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:31 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/43] iwlwifi: remove IWL_*_UCODE_API_OK
Date: Wed, 30 Mar 2016 17:05:10 +0300
Message-Id: <1459346715-7954-38-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160634_035066_D3971631)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

_UCODE_API_OK was a intermediate version between MIN and
MAX. If a user had a firmware below _OK but above _MIN, the
driver would work but the user would get a warning in the
kernel log telling him to update his firmware.
This is not needed since most users won't look for these
messages in the kernel log if their wifi is working.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-1000.c   | 10 ++--------
 drivers/net/wireless/intel/iwlwifi/iwl-2000.c   | 18 ++++--------------
 drivers/net/wireless/intel/iwlwifi/iwl-5000.c   | 11 ++---------
 drivers/net/wireless/intel/iwlwifi/iwl-6000.c   | 20 ++++----------------
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c   | 20 +++++---------------
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c   | 11 ++---------
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   |  6 +-----
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  3 ---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c    | 24 +-----------------------
 9 files changed, 21 insertions(+), 102 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-1000.c b/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
index a90dbab..ef22c3d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
@@ -34,10 +34,6 @@
 #define IWL1000_UCODE_API_MAX 5
 #define IWL100_UCODE_API_MAX 5
 
-/* Oldest version we won't warn about */
-#define IWL1000_UCODE_API_OK 5
-#define IWL100_UCODE_API_OK 5
-
 /* Lowest firmware API version supported */
 #define IWL1000_UCODE_API_MIN 1
 #define IWL100_UCODE_API_MIN 5
@@ -86,7 +82,6 @@ static const struct iwl_eeprom_params iwl1000_eeprom_params = {
 #define IWL_DEVICE_1000						\
 	.fw_name_pre = IWL1000_FW_PRE,				\
 	.ucode_api_max = IWL1000_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL1000_UCODE_API_OK,			\
 	.ucode_api_min = IWL1000_UCODE_API_MIN,			\
 	.device_family = IWL_DEVICE_FAMILY_1000,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
@@ -112,7 +107,6 @@ const struct iwl_cfg iwl1000_bg_cfg = {
 #define IWL_DEVICE_100						\
 	.fw_name_pre = IWL100_FW_PRE,				\
 	.ucode_api_max = IWL100_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL100_UCODE_API_OK,			\
 	.ucode_api_min = IWL100_UCODE_API_MIN,			\
 	.device_family = IWL_DEVICE_FAMILY_100,			\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
@@ -136,5 +130,5 @@ const struct iwl_cfg iwl100_bg_cfg = {
 	IWL_DEVICE_100,
 };
 
-MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_OK));
-MODULE_FIRMWARE(IWL100_MODULE_FIRMWARE(IWL100_UCODE_API_OK));
+MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL100_MODULE_FIRMWARE(IWL100_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-2000.c b/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
index a6da959..dc246c9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
@@ -36,12 +36,6 @@
 #define IWL105_UCODE_API_MAX 6
 #define IWL135_UCODE_API_MAX 6
 
-/* Oldest version we won't warn about */
-#define IWL2030_UCODE_API_OK 6
-#define IWL2000_UCODE_API_OK 6
-#define IWL105_UCODE_API_OK 6
-#define IWL135_UCODE_API_OK 6
-
 /* Lowest firmware API version supported */
 #define IWL2030_UCODE_API_MIN 5
 #define IWL2000_UCODE_API_MIN 5
@@ -114,7 +108,6 @@ static const struct iwl_eeprom_params iwl20x0_eeprom_params = {
 #define IWL_DEVICE_2000						\
 	.fw_name_pre = IWL2000_FW_PRE,				\
 	.ucode_api_max = IWL2000_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL2000_UCODE_API_OK,			\
 	.ucode_api_min = IWL2000_UCODE_API_MIN,			\
 	.device_family = IWL_DEVICE_FAMILY_2000,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
@@ -142,7 +135,6 @@ const struct iwl_cfg iwl2000_2bgn_d_cfg = {
 #define IWL_DEVICE_2030						\
 	.fw_name_pre = IWL2030_FW_PRE,				\
 	.ucode_api_max = IWL2030_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL2030_UCODE_API_OK,			\
 	.ucode_api_min = IWL2030_UCODE_API_MIN,			\
 	.device_family = IWL_DEVICE_FAMILY_2030,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
@@ -163,7 +155,6 @@ const struct iwl_cfg iwl2030_2bgn_cfg = {
 #define IWL_DEVICE_105						\
 	.fw_name_pre = IWL105_FW_PRE,				\
 	.ucode_api_max = IWL105_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL105_UCODE_API_OK,			\
 	.ucode_api_min = IWL105_UCODE_API_MIN,			\
 	.device_family = IWL_DEVICE_FAMILY_105,			\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
@@ -191,7 +182,6 @@ const struct iwl_cfg iwl105_bgn_d_cfg = {
 #define IWL_DEVICE_135						\
 	.fw_name_pre = IWL135_FW_PRE,				\
 	.ucode_api_max = IWL135_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL135_UCODE_API_OK,			\
 	.ucode_api_min = IWL135_UCODE_API_MIN,			\
 	.device_family = IWL_DEVICE_FAMILY_135,			\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
@@ -210,7 +200,7 @@ const struct iwl_cfg iwl135_bgn_cfg = {
 	.ht_params = &iwl2000_ht_params,
 };
 
-MODULE_FIRMWARE(IWL2000_MODULE_FIRMWARE(IWL2000_UCODE_API_OK));
-MODULE_FIRMWARE(IWL2030_MODULE_FIRMWARE(IWL2030_UCODE_API_OK));
-MODULE_FIRMWARE(IWL105_MODULE_FIRMWARE(IWL105_UCODE_API_OK));
-MODULE_FIRMWARE(IWL135_MODULE_FIRMWARE(IWL135_UCODE_API_OK));
+MODULE_FIRMWARE(IWL2000_MODULE_FIRMWARE(IWL2000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL2030_MODULE_FIRMWARE(IWL2030_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL105_MODULE_FIRMWARE(IWL105_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL135_MODULE_FIRMWARE(IWL135_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-5000.c b/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
index 8b5afde..4dcdab6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
@@ -34,10 +34,6 @@
 #define IWL5000_UCODE_API_MAX 5
 #define IWL5150_UCODE_API_MAX 2
 
-/* Oldest version we won't warn about */
-#define IWL5000_UCODE_API_OK 5
-#define IWL5150_UCODE_API_OK 2
-
 /* Lowest firmware API version supported */
 #define IWL5000_UCODE_API_MIN 1
 #define IWL5150_UCODE_API_MIN 1
@@ -84,7 +80,6 @@ static const struct iwl_eeprom_params iwl5000_eeprom_params = {
 #define IWL_DEVICE_5000						\
 	.fw_name_pre = IWL5000_FW_PRE,				\
 	.ucode_api_max = IWL5000_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL5000_UCODE_API_OK,			\
 	.ucode_api_min = IWL5000_UCODE_API_MIN,			\
 	.device_family = IWL_DEVICE_FAMILY_5000,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
@@ -132,7 +127,6 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.name = "Intel(R) WiMAX/WiFi Link 5350 AGN",
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
-	.ucode_api_ok = IWL5000_UCODE_API_OK,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.device_family = IWL_DEVICE_FAMILY_5000,
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,
@@ -149,7 +143,6 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 #define IWL_DEVICE_5150						\
 	.fw_name_pre = IWL5150_FW_PRE,				\
 	.ucode_api_max = IWL5150_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL5150_UCODE_API_OK,			\
 	.ucode_api_min = IWL5150_UCODE_API_MIN,			\
 	.device_family = IWL_DEVICE_FAMILY_5150,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
@@ -174,5 +167,5 @@ const struct iwl_cfg iwl5150_abg_cfg = {
 	IWL_DEVICE_5150,
 };
 
-MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_OK));
-MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_OK));
+MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
index 0b4ba78..9938f53 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
@@ -36,13 +36,6 @@
 #define IWL6000G2_UCODE_API_MAX 6
 #define IWL6035_UCODE_API_MAX 6
 
-/* Oldest version we won't warn about */
-#define IWL6000_UCODE_API_OK 4
-#define IWL6000G2_UCODE_API_OK 5
-#define IWL6050_UCODE_API_OK 5
-#define IWL6000G2B_UCODE_API_OK 6
-#define IWL6035_UCODE_API_OK 6
-
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
 #define IWL6050_UCODE_API_MIN 4
@@ -136,7 +129,6 @@ static const struct iwl_eeprom_params iwl6000_eeprom_params = {
 #define IWL_DEVICE_6005						\
 	.fw_name_pre = IWL6005_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
-	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.device_family = IWL_DEVICE_FAMILY_6005,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
@@ -191,7 +183,6 @@ const struct iwl_cfg iwl6005_2agn_mow2_cfg = {
 #define IWL_DEVICE_6030						\
 	.fw_name_pre = IWL6030_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
-	.ucode_api_ok = IWL6000G2B_UCODE_API_OK,		\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.device_family = IWL_DEVICE_FAMILY_6030,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
@@ -228,7 +219,6 @@ const struct iwl_cfg iwl6030_2bg_cfg = {
 #define IWL_DEVICE_6035						\
 	.fw_name_pre = IWL6030_FW_PRE,				\
 	.ucode_api_max = IWL6035_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL6035_UCODE_API_OK,			\
 	.ucode_api_min = IWL6035_UCODE_API_MIN,			\
 	.device_family = IWL_DEVICE_FAMILY_6030,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
@@ -282,7 +272,6 @@ const struct iwl_cfg iwl130_bg_cfg = {
 #define IWL_DEVICE_6000i					\
 	.fw_name_pre = IWL6000_FW_PRE,				\
 	.ucode_api_max = IWL6000_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL6000_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000_UCODE_API_MIN,			\
 	.device_family = IWL_DEVICE_FAMILY_6000i,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
@@ -370,7 +359,6 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
 	.name = "Intel(R) Centrino(R) Ultimate-N 6300 AGN",
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
-	.ucode_api_ok = IWL6000_UCODE_API_OK,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.device_family = IWL_DEVICE_FAMILY_6000,
 	.max_inst_size = IWL60_RTC_INST_SIZE,
@@ -383,7 +371,7 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
 	.led_mode = IWL_LED_BLINK,
 };
 
-MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_OK));
-MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_OK));
-MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_OK));
-MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2B_UCODE_API_OK));
+MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2B_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index f4012a3..b6283c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -76,12 +76,6 @@
 #define IWL7265D_UCODE_API_MAX	21
 #define IWL3168_UCODE_API_MAX	21
 
-/* Oldest version we won't warn about */
-#define IWL7260_UCODE_API_OK	16
-#define IWL7265_UCODE_API_OK	16
-#define IWL7265D_UCODE_API_OK	16
-#define IWL3168_UCODE_API_OK	20
-
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	16
 #define IWL7265_UCODE_API_MIN	16
@@ -179,25 +173,21 @@ static const struct iwl_ht_params iwl7000_ht_params = {
 #define IWL_DEVICE_7000						\
 	IWL_DEVICE_7000_COMMON,					\
 	.ucode_api_max = IWL7260_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL7260_UCODE_API_OK,			\
 	.ucode_api_min = IWL7260_UCODE_API_MIN
 
 #define IWL_DEVICE_7005						\
 	IWL_DEVICE_7000_COMMON,					\
 	.ucode_api_max = IWL7265_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL7265_UCODE_API_OK,			\
 	.ucode_api_min = IWL7265_UCODE_API_MIN
 
 #define IWL_DEVICE_3008						\
 	IWL_DEVICE_7000_COMMON,					\
 	.ucode_api_max = IWL3168_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL3168_UCODE_API_OK,			\
 	.ucode_api_min = IWL3168_UCODE_API_MIN
 
 #define IWL_DEVICE_7005D					\
 	IWL_DEVICE_7000_COMMON,					\
 	.ucode_api_max = IWL7265D_UCODE_API_MAX,		\
-	.ucode_api_ok = IWL7265D_UCODE_API_OK,			\
 	.ucode_api_min = IWL7265D_UCODE_API_MIN
 
 const struct iwl_cfg iwl7260_2ac_cfg = {
@@ -388,8 +378,8 @@ const struct iwl_cfg iwl7265d_n_cfg = {
 	.dccm_len = IWL7265_DCCM_LEN,
 };
 
-MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-MODULE_FIRMWARE(IWL3168_MODULE_FIRMWARE(IWL3168_UCODE_API_OK));
-MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7265_UCODE_API_OK));
-MODULE_FIRMWARE(IWL7265D_MODULE_FIRMWARE(IWL7265D_UCODE_API_OK));
+MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL7260_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL3168_MODULE_FIRMWARE(IWL3168_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7265_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL7265D_MODULE_FIRMWARE(IWL7265D_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index 49bb2a5..0728a28 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -73,10 +73,6 @@
 #define IWL8000_UCODE_API_MAX	21
 #define IWL8265_UCODE_API_MAX	21
 
-/* Oldest version we won't warn about */
-#define IWL8000_UCODE_API_OK	16
-#define IWL8265_UCODE_API_OK	20
-
 /* Lowest firmware API version supported */
 #define IWL8000_UCODE_API_MIN	16
 #define IWL8265_UCODE_API_MIN	20
@@ -175,19 +171,16 @@ static const struct iwl_tt_params iwl8000_tt_params = {
 #define IWL_DEVICE_8000							\
 	IWL_DEVICE_8000_COMMON,						\
 	.ucode_api_max = IWL8000_UCODE_API_MAX,				\
-	.ucode_api_ok = IWL8000_UCODE_API_OK,				\
 	.ucode_api_min = IWL8000_UCODE_API_MIN				\
 
 #define IWL_DEVICE_8260							\
 	IWL_DEVICE_8000_COMMON,						\
 	.ucode_api_max = IWL8000_UCODE_API_MAX,				\
-	.ucode_api_ok = IWL8000_UCODE_API_OK,				\
 	.ucode_api_min = IWL8000_UCODE_API_MIN				\
 
 #define IWL_DEVICE_8265							\
 	IWL_DEVICE_8000_COMMON,						\
 	.ucode_api_max = IWL8265_UCODE_API_MAX,				\
-	.ucode_api_ok = IWL8265_UCODE_API_OK,				\
 	.ucode_api_min = IWL8265_UCODE_API_MIN				\
 
 const struct iwl_cfg iwl8260_2n_cfg = {
@@ -259,5 +252,5 @@ const struct iwl_cfg iwl4165_2ac_sdio_cfg = {
 	.max_vht_ampdu_exponent = MAX_VHT_AMPDU_EXPONENT_8260_SDIO,
 };
 
-MODULE_FIRMWARE(IWL8000_MODULE_FIRMWARE(IWL8000_UCODE_API_OK));
-MODULE_FIRMWARE(IWL8265_MODULE_FIRMWARE(IWL8265_UCODE_API_OK));
+MODULE_FIRMWARE(IWL8000_MODULE_FIRMWARE(IWL8000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL8265_MODULE_FIRMWARE(IWL8265_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 1f25ba6..a3d35aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -57,9 +57,6 @@
 /* Highest firmware API version supported */
 #define IWL9000_UCODE_API_MAX	21
 
-/* Oldest version we won't warn about */
-#define IWL9000_UCODE_API_OK	16
-
 /* Lowest firmware API version supported */
 #define IWL9000_UCODE_API_MIN	16
 
@@ -122,7 +119,6 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 
 #define IWL_DEVICE_9000							\
 	.ucode_api_max = IWL9000_UCODE_API_MAX,				\
-	.ucode_api_ok = IWL9000_UCODE_API_OK,				\
 	.ucode_api_min = IWL9000_UCODE_API_MIN,				\
 	.device_family = IWL_DEVICE_FAMILY_8000,			\
 	.max_inst_size = IWL60_RTC_INST_SIZE,				\
@@ -164,4 +160,4 @@ const struct iwl_cfg iwl5165_2ac_cfg = {
 		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
-MODULE_FIRMWARE(IWL9000_MODULE_FIRMWARE(IWL9000_UCODE_API_OK));
+MODULE_FIRMWARE(IWL9000_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index b002557..08bb4f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -279,8 +279,6 @@ struct iwl_pwr_tx_backoff {
  *	(.ucode) will be added to filename before loading from disk. The
  *	filename is constructed as fw_name_pre<api>.ucode.
  * @ucode_api_max: Highest version of uCode API supported by driver.
- * @ucode_api_ok: oldest version of the uCode API that is OK to load
- *	without a warning, for use in transitions
  * @ucode_api_min: Lowest version of uCode API supported by driver.
  * @max_inst_size: The maximal length of the fw inst section
  * @max_data_size: The maximal length of the fw data section
@@ -326,7 +324,6 @@ struct iwl_cfg {
 	const char *name;
 	const char *fw_name_pre;
 	const unsigned int ucode_api_max;
-	const unsigned int ucode_api_ok;
 	const unsigned int ucode_api_min;
 	const enum iwl_device_family device_family;
 	const u32 max_data_size;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 9a680ac..605910f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1206,7 +1206,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	int err;
 	struct iwl_firmware_pieces *pieces;
 	const unsigned int api_max = drv->cfg->ucode_api_max;
-	unsigned int api_ok = drv->cfg->ucode_api_ok;
 	const unsigned int api_min = drv->cfg->ucode_api_min;
 	size_t trigger_tlv_sz[FW_DBG_TRIGGER_MAX];
 	u32 api_ver;
@@ -1219,20 +1218,12 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE;
 	fw->ucode_capa.n_scan_channels = IWL_DEFAULT_SCAN_CHANNELS;
 
-	if (!api_ok)
-		api_ok = api_max;
-
 	pieces = kzalloc(sizeof(*pieces), GFP_KERNEL);
 	if (!pieces)
 		return;
 
-	if (!ucode_raw) {
-		if (drv->fw_index <= api_ok)
-			IWL_ERR(drv,
-				"request for firmware file '%s' failed.\n",
-				drv->firmware_name);
+	if (!ucode_raw)
 		goto try_again;
-	}
 
 	IWL_DEBUG_INFO(drv, "Loaded firmware file '%s' (%zd bytes).\n",
 		       drv->firmware_name, ucode_raw->size);
@@ -1271,19 +1262,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				api_max, api_ver);
 			goto try_again;
 		}
-
-		if (api_ver < api_ok) {
-			if (api_ok != api_max)
-				IWL_ERR(drv, "Firmware has old API version, "
-					"expected v%u through v%u, got v%u.\n",
-					api_ok, api_max, api_ver);
-			else
-				IWL_ERR(drv, "Firmware has old API version, "
-					"expected v%u, got v%u.\n",
-					api_max, api_ver);
-			IWL_ERR(drv, "New firmware can be obtained from "
-				      "http://www.intellinuxwireless.org/.\n");
-		}
 	}
 
 	/*
-- 
2.5.0

