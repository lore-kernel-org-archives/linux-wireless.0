Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:23966 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530AbbLPOXk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:23:40 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] iwlwifi: separate firmware version for 7260 devices
Date: Wed, 16 Dec 2015 16:23:36 +0200
Message-Id: <1450275817-16938-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151216_152343_051408_54065D51)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E91F275@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E91F275@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The 7260 devices aren't going to be updated for completely new
firmware versions any more (only bugfixes), and haven't been
since API version 17. Encode that in the data structures to
avoid trying to load FW images that will never exist.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 49 +++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index bf88ec3..d9a4aee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -69,13 +69,19 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL7260_UCODE_API_MAX	19
+#define IWL7260_UCODE_API_MAX	17
+#define IWL7265_UCODE_API_MAX	19
+#define IWL7265D_UCODE_API_MAX	19
 
 /* Oldest version we won't warn about */
 #define IWL7260_UCODE_API_OK	13
+#define IWL7265_UCODE_API_OK	13
+#define IWL7265D_UCODE_API_OK	13
 
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	13
+#define IWL7265_UCODE_API_MIN	13
+#define IWL7265D_UCODE_API_MIN	13
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d
@@ -149,10 +155,7 @@ static const struct iwl_ht_params iwl7000_ht_params = {
 	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
 };
 
-#define IWL_DEVICE_7000						\
-	.ucode_api_max = IWL7260_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL7260_UCODE_API_OK,			\
-	.ucode_api_min = IWL7260_UCODE_API_MIN,			\
+#define IWL_DEVICE_7000_COMMON					\
 	.device_family = IWL_DEVICE_FAMILY_7000,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
@@ -163,6 +166,24 @@ static const struct iwl_ht_params iwl7000_ht_params = {
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,	\
 	.dccm_offset = IWL7000_DCCM_OFFSET
 
+#define IWL_DEVICE_7000						\
+	IWL_DEVICE_7000_COMMON,					\
+	.ucode_api_max = IWL7260_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL7260_UCODE_API_OK,			\
+	.ucode_api_min = IWL7260_UCODE_API_MIN
+
+#define IWL_DEVICE_7005						\
+	IWL_DEVICE_7000_COMMON,					\
+	.ucode_api_max = IWL7265_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL7265_UCODE_API_OK,			\
+	.ucode_api_min = IWL7265_UCODE_API_MIN
+
+#define IWL_DEVICE_7005D					\
+	IWL_DEVICE_7000_COMMON,					\
+	.ucode_api_max = IWL7265D_UCODE_API_MAX,		\
+	.ucode_api_ok = IWL7265D_UCODE_API_OK,			\
+	.ucode_api_min = IWL7265D_UCODE_API_MIN
+
 const struct iwl_cfg iwl7260_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 7260",
 	.fw_name_pre = IWL7260_FW_PRE,
@@ -266,7 +287,7 @@ static const struct iwl_ht_params iwl7265_ht_params = {
 const struct iwl_cfg iwl3165_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 3165",
 	.fw_name_pre = IWL7265D_FW_PRE,
-	IWL_DEVICE_7000,
+	IWL_DEVICE_7005D,
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3165_NVM_VERSION,
 	.nvm_calib_ver = IWL3165_TX_POWER_VERSION,
@@ -277,7 +298,7 @@ const struct iwl_cfg iwl3165_2ac_cfg = {
 const struct iwl_cfg iwl7265_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 7265",
 	.fw_name_pre = IWL7265_FW_PRE,
-	IWL_DEVICE_7000,
+	IWL_DEVICE_7005,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
@@ -288,7 +309,7 @@ const struct iwl_cfg iwl7265_2ac_cfg = {
 const struct iwl_cfg iwl7265_2n_cfg = {
 	.name = "Intel(R) Dual Band Wireless N 7265",
 	.fw_name_pre = IWL7265_FW_PRE,
-	IWL_DEVICE_7000,
+	IWL_DEVICE_7005,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
@@ -299,7 +320,7 @@ const struct iwl_cfg iwl7265_2n_cfg = {
 const struct iwl_cfg iwl7265_n_cfg = {
 	.name = "Intel(R) Wireless N 7265",
 	.fw_name_pre = IWL7265_FW_PRE,
-	IWL_DEVICE_7000,
+	IWL_DEVICE_7005,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
@@ -310,7 +331,7 @@ const struct iwl_cfg iwl7265_n_cfg = {
 const struct iwl_cfg iwl7265d_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 7265",
 	.fw_name_pre = IWL7265D_FW_PRE,
-	IWL_DEVICE_7000,
+	IWL_DEVICE_7005D,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265D_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
@@ -321,7 +342,7 @@ const struct iwl_cfg iwl7265d_2ac_cfg = {
 const struct iwl_cfg iwl7265d_2n_cfg = {
 	.name = "Intel(R) Dual Band Wireless N 7265",
 	.fw_name_pre = IWL7265D_FW_PRE,
-	IWL_DEVICE_7000,
+	IWL_DEVICE_7005D,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265D_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
@@ -332,7 +353,7 @@ const struct iwl_cfg iwl7265d_2n_cfg = {
 const struct iwl_cfg iwl7265d_n_cfg = {
 	.name = "Intel(R) Wireless N 7265",
 	.fw_name_pre = IWL7265D_FW_PRE,
-	IWL_DEVICE_7000,
+	IWL_DEVICE_7005D,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265D_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
@@ -342,5 +363,5 @@ const struct iwl_cfg iwl7265d_n_cfg = {
 
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-MODULE_FIRMWARE(IWL7265D_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
+MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7265_UCODE_API_OK));
+MODULE_FIRMWARE(IWL7265D_MODULE_FIRMWARE(IWL7265D_UCODE_API_OK));
-- 
2.5.0

