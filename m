Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48526 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965145AbcAZKVv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 05:21:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/5] iwlwifi: update support for 3168 series firmware and NVM
Date: Tue, 26 Jan 2016 12:21:37 +0200
Message-Id: <1453803698-20550-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160126_112156_522316_CBAC95AD)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9D452F@hasmsx109.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9D452F@hasmsx109.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Update the struct which defines the support for 3168 cards.
Now it will search for a firmware of this format:
iwlwifi-3168-XX.ucode
Also, set the minimum version of the ucode to 20.
Update the minimum NVM version and minimum NVM calibrations
version of the 3168 series.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index e60cf14..fa41a5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -74,16 +74,19 @@
 #define IWL7260_UCODE_API_MAX	17
 #define IWL7265_UCODE_API_MAX	17
 #define IWL7265D_UCODE_API_MAX	20
+#define IWL3168_UCODE_API_MAX	20
 
 /* Oldest version we won't warn about */
 #define IWL7260_UCODE_API_OK	13
 #define IWL7265_UCODE_API_OK	13
 #define IWL7265D_UCODE_API_OK	13
+#define IWL3168_UCODE_API_OK	20
 
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	13
 #define IWL7265_UCODE_API_MIN	13
 #define IWL7265D_UCODE_API_MIN	13
+#define IWL3168_UCODE_API_MIN	20
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d
@@ -92,6 +95,8 @@
 #define IWL3160_TX_POWER_VERSION	0xffff /* meaningless */
 #define IWL3165_NVM_VERSION		0x709
 #define IWL3165_TX_POWER_VERSION	0xffff /* meaningless */
+#define IWL3168_NVM_VERSION		0xd01
+#define IWL3168_TX_POWER_VERSION	0xffff /* meaningless */
 #define IWL7265_NVM_VERSION		0x0a1d
 #define IWL7265_TX_POWER_VERSION	0xffff /* meaningless */
 #define IWL7265D_NVM_VERSION		0x0c11
@@ -109,6 +114,9 @@
 #define IWL3160_FW_PRE "iwlwifi-3160-"
 #define IWL3160_MODULE_FIRMWARE(api) IWL3160_FW_PRE __stringify(api) ".ucode"
 
+#define IWL3168_FW_PRE "iwlwifi-3168-"
+#define IWL3168_MODULE_FIRMWARE(api) IWL3168_FW_PRE __stringify(api) ".ucode"
+
 #define IWL7265_FW_PRE "iwlwifi-7265-"
 #define IWL7265_MODULE_FIRMWARE(api) IWL7265_FW_PRE __stringify(api) ".ucode"
 
@@ -180,6 +188,12 @@ static const struct iwl_ht_params iwl7000_ht_params = {
 	.ucode_api_ok = IWL7265_UCODE_API_OK,			\
 	.ucode_api_min = IWL7265_UCODE_API_MIN
 
+#define IWL_DEVICE_3008						\
+	IWL_DEVICE_7000_COMMON,					\
+	.ucode_api_max = IWL3168_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL3168_UCODE_API_OK,			\
+	.ucode_api_min = IWL3168_UCODE_API_MIN
+
 #define IWL_DEVICE_7005D					\
 	IWL_DEVICE_7000_COMMON,					\
 	.ucode_api_max = IWL7265D_UCODE_API_MAX,		\
@@ -299,11 +313,11 @@ const struct iwl_cfg iwl3165_2ac_cfg = {
 
 const struct iwl_cfg iwl3168_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 3168",
-	.fw_name_pre = IWL7265D_FW_PRE,
-	IWL_DEVICE_7000,
+	.fw_name_pre = IWL3168_FW_PRE,
+	IWL_DEVICE_3008,
 	.ht_params = &iwl7000_ht_params,
-	.nvm_ver = IWL3165_NVM_VERSION,
-	.nvm_calib_ver = IWL3165_TX_POWER_VERSION,
+	.nvm_ver = IWL3168_NVM_VERSION,
+	.nvm_calib_ver = IWL3168_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 	.dccm_len = IWL7265_DCCM_LEN,
 };
@@ -376,5 +390,6 @@ const struct iwl_cfg iwl7265d_n_cfg = {
 
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
+MODULE_FIRMWARE(IWL3168_MODULE_FIRMWARE(IWL3168_UCODE_API_OK));
 MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7265_UCODE_API_OK));
 MODULE_FIRMWARE(IWL7265D_MODULE_FIRMWARE(IWL7265D_UCODE_API_OK));
-- 
2.5.0

