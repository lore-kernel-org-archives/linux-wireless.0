Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbbEZTSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:18 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>, Ido Yariv <idox.yariv@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/39] iwlwifi: update thermal throttling values for 8000 devices
Date: Tue, 26 May 2015 22:17:24 +0300
Message-Id: <1432667872-18092-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211943_124782_294A1DC9)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

8000 devices have different thermal throttling values from previous
generations.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 75881f9..5dca838 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -122,6 +122,27 @@ static const struct iwl_ht_params iwl8000_ht_params = {
 	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
 };
 
+static const struct iwl_tt_params iwl8000_tt_params = {
+	.ct_kill_entry = 115,
+	.ct_kill_exit = 93,
+	.ct_kill_duration = 5,
+	.dynamic_smps_entry = 111,
+	.dynamic_smps_exit = 107,
+	.tx_protection_entry = 112,
+	.tx_protection_exit = 105,
+	.tx_backoff = {
+		{.temperature = 110, .backoff = 200},
+		{.temperature = 111, .backoff = 600},
+		{.temperature = 112, .backoff = 1200},
+		{.temperature = 113, .backoff = 2000},
+		{.temperature = 114, .backoff = 4000},
+	},
+	.support_ct_kill = true,
+	.support_dynamic_smps = true,
+	.support_tx_protection = true,
+	.support_tx_backoff = true,
+};
+
 #define IWL_DEVICE_8000							\
 	.ucode_api_max = IWL8000_UCODE_API_MAX,				\
 	.ucode_api_ok = IWL8000_UCODE_API_OK,				\
@@ -141,7 +162,8 @@ static const struct iwl_ht_params iwl8000_ht_params = {
 	.smem_offset = IWL8260_SMEM_OFFSET,				\
 	.smem_len = IWL8260_SMEM_LEN,					\
 	.default_nvm_file_B_step = DEFAULT_NVM_FILE_FAMILY_8000B,	\
-	.default_nvm_file_C_step = DEFAULT_NVM_FILE_FAMILY_8000C
+	.default_nvm_file_C_step = DEFAULT_NVM_FILE_FAMILY_8000C,	\
+	.thermal_params = &iwl8000_tt_params
 
 const struct iwl_cfg iwl8260_2n_cfg = {
 	.name = "Intel(R) Dual Band Wireless N 8260",
-- 
2.1.4

