Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbbECTdZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:25 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 40/42] iwlwifi: mvm: make thermal throttling values configurable per NIC family
Date: Sun,  3 May 2015 22:31:51 +0300
Message-Id: <1430681513-7838-40-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213348_234696_3FC29E0C)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

The thermal throttling parameters were constant and hardcoded, not allowing
changes for different NIC families.
Change this so that the values are part of the NIC family configuration and
are not constant (so they can be changed dynamically in the future).

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   | 23 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-config.h | 44 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h    | 46 ++-----------------------------
 drivers/net/wireless/iwlwifi/mvm/tt.c     | 40 ++++++---------------------
 4 files changed, 78 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 36e786f..69b2c0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -128,6 +128,28 @@ static const struct iwl_base_params iwl7000_base_params = {
 	.apmg_wake_up_wa = true,
 };
 
+static const struct iwl_tt_params iwl7000_high_temp_tt_params = {
+	.ct_kill_entry = 118,
+	.ct_kill_exit = 96,
+	.ct_kill_duration = 5,
+	.dynamic_smps_entry = 114,
+	.dynamic_smps_exit = 110,
+	.tx_protection_entry = 114,
+	.tx_protection_exit = 108,
+	.tx_backoff = {
+		{.temperature = 112, .backoff = 300},
+		{.temperature = 113, .backoff = 800},
+		{.temperature = 114, .backoff = 1500},
+		{.temperature = 115, .backoff = 3000},
+		{.temperature = 116, .backoff = 5000},
+		{.temperature = 117, .backoff = 10000},
+	},
+	.support_ct_kill = true,
+	.support_dynamic_smps = true,
+	.support_tx_protection = true,
+	.support_tx_backoff = true,
+};
+
 static const struct iwl_ht_params iwl7000_ht_params = {
 	.stbc = true,
 	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
@@ -170,6 +192,7 @@ const struct iwl_cfg iwl7260_2ac_cfg_high_temp = {
 	.host_interrupt_operation_mode = true,
 	.lp_xtal_workaround = true,
 	.dccm_len = IWL7260_DCCM_LEN,
+	.thermal_params = &iwl7000_high_temp_tt_params,
 };
 
 const struct iwl_cfg iwl7260_2n_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 3f33f75..225b6d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -195,6 +195,49 @@ struct iwl_ht_params {
 };
 
 /*
+ * Tx-backoff threshold
+ * @temperature: The threshold in Celsius
+ * @backoff: The tx-backoff in uSec
+ */
+struct iwl_tt_tx_backoff {
+	s32 temperature;
+	u32 backoff;
+};
+
+#define TT_TX_BACKOFF_SIZE 6
+
+/**
+ * struct iwl_tt_params - thermal throttling parameters
+ * @ct_kill_entry: CT Kill entry threshold
+ * @ct_kill_exit: CT Kill exit threshold
+ * @ct_kill_duration: The time  intervals (in uSec) in which the driver needs
+ *	to checks whether to exit CT Kill.
+ * @dynamic_smps_entry: Dynamic SMPS entry threshold
+ * @dynamic_smps_exit: Dynamic SMPS exit threshold
+ * @tx_protection_entry: TX protection entry threshold
+ * @tx_protection_exit: TX protection exit threshold
+ * @tx_backoff: Array of thresholds for tx-backoff , in ascending order.
+ * @support_ct_kill: Support CT Kill?
+ * @support_dynamic_smps: Support dynamic SMPS?
+ * @support_tx_protection: Support tx protection?
+ * @support_tx_backoff: Support tx-backoff?
+ */
+struct iwl_tt_params {
+	s32 ct_kill_entry;
+	s32 ct_kill_exit;
+	u32 ct_kill_duration;
+	s32 dynamic_smps_entry;
+	s32 dynamic_smps_exit;
+	s32 tx_protection_entry;
+	s32 tx_protection_exit;
+	struct iwl_tt_tx_backoff tx_backoff[TT_TX_BACKOFF_SIZE];
+	bool support_ct_kill;
+	bool support_dynamic_smps;
+	bool support_tx_protection;
+	bool support_tx_backoff;
+};
+
+/*
  * information on how to parse the EEPROM
  */
 #define EEPROM_REG_BAND_1_CHANNELS		0x08
@@ -316,6 +359,7 @@ struct iwl_cfg {
 	const u32 dccm2_len;
 	const u32 smem_offset;
 	const u32 smem_len;
+	const struct iwl_tt_params *thermal_params;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e6169c6..6d33234 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -76,6 +76,7 @@
 #include "iwl-notif-wait.h"
 #include "iwl-eeprom-parse.h"
 #include "iwl-fw-file.h"
+#include "iwl-config.h"
 #include "sta.h"
 #include "fw-api.h"
 #include "constants.h"
@@ -477,49 +478,6 @@ struct iwl_nvm_section {
 	const u8 *data;
 };
 
-/*
- * Tx-backoff threshold
- * @temperature: The threshold in Celsius
- * @backoff: The tx-backoff in uSec
- */
-struct iwl_tt_tx_backoff {
-	s32 temperature;
-	u32 backoff;
-};
-
-#define TT_TX_BACKOFF_SIZE 6
-
-/**
- * struct iwl_tt_params - thermal throttling parameters
- * @ct_kill_entry: CT Kill entry threshold
- * @ct_kill_exit: CT Kill exit threshold
- * @ct_kill_duration: The time  intervals (in uSec) in which the driver needs
- *	to checks whether to exit CT Kill.
- * @dynamic_smps_entry: Dynamic SMPS entry threshold
- * @dynamic_smps_exit: Dynamic SMPS exit threshold
- * @tx_protection_entry: TX protection entry threshold
- * @tx_protection_exit: TX protection exit threshold
- * @tx_backoff: Array of thresholds for tx-backoff , in ascending order.
- * @support_ct_kill: Support CT Kill?
- * @support_dynamic_smps: Support dynamic SMPS?
- * @support_tx_protection: Support tx protection?
- * @support_tx_backoff: Support tx-backoff?
- */
-struct iwl_tt_params {
-	s32 ct_kill_entry;
-	s32 ct_kill_exit;
-	u32 ct_kill_duration;
-	s32 dynamic_smps_entry;
-	s32 dynamic_smps_exit;
-	s32 tx_protection_entry;
-	s32 tx_protection_exit;
-	struct iwl_tt_tx_backoff tx_backoff[TT_TX_BACKOFF_SIZE];
-	bool support_ct_kill;
-	bool support_dynamic_smps;
-	bool support_tx_protection;
-	bool support_tx_backoff;
-};
-
 /**
  * struct iwl_mvm_tt_mgnt - Thermal Throttling Management structure
  * @ct_kill_exit: worker to exit thermal kill
@@ -534,7 +492,7 @@ struct iwl_mvm_tt_mgmt {
 	bool dynamic_smps;
 	u32 tx_backoff;
 	u32 min_backoff;
-	const struct iwl_tt_params *params;
+	struct iwl_tt_params params;
 	bool throttle;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index ba615ad..80d07db 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -70,7 +70,7 @@
 static void iwl_mvm_enter_ctkill(struct iwl_mvm *mvm)
 {
 	struct iwl_mvm_tt_mgmt *tt = &mvm->thermal_throttle;
-	u32 duration = mvm->thermal_throttle.params->ct_kill_duration;
+	u32 duration = tt->params.ct_kill_duration;
 
 	if (test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status))
 		return;
@@ -223,7 +223,7 @@ static void check_exit_ctkill(struct work_struct *work)
 	tt = container_of(work, struct iwl_mvm_tt_mgmt, ct_kill_exit.work);
 	mvm = container_of(tt, struct iwl_mvm, thermal_throttle);
 
-	duration = tt->params->ct_kill_duration;
+	duration = tt->params.ct_kill_duration;
 
 	mutex_lock(&mvm->mutex);
 
@@ -247,7 +247,7 @@ static void check_exit_ctkill(struct work_struct *work)
 
 	IWL_DEBUG_TEMP(mvm, "NIC temperature: %d\n", temp);
 
-	if (temp <= tt->params->ct_kill_exit) {
+	if (temp <= tt->params.ct_kill_exit) {
 		mutex_unlock(&mvm->mutex);
 		iwl_mvm_exit_ctkill(mvm);
 		return;
@@ -325,7 +325,7 @@ void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff)
 
 void iwl_mvm_tt_handler(struct iwl_mvm *mvm)
 {
-	const struct iwl_tt_params *params = mvm->thermal_throttle.params;
+	struct iwl_tt_params *params = &mvm->thermal_throttle.params;
 	struct iwl_mvm_tt_mgmt *tt = &mvm->thermal_throttle;
 	s32 temperature = mvm->temperature;
 	bool throttle_enable = false;
@@ -340,7 +340,7 @@ void iwl_mvm_tt_handler(struct iwl_mvm *mvm)
 	}
 
 	if (params->support_ct_kill &&
-	    temperature <= tt->params->ct_kill_exit) {
+	    temperature <= params->ct_kill_exit) {
 		iwl_mvm_exit_ctkill(mvm);
 		return;
 	}
@@ -400,7 +400,7 @@ void iwl_mvm_tt_handler(struct iwl_mvm *mvm)
 	}
 }
 
-static const struct iwl_tt_params iwl7000_tt_params = {
+static const struct iwl_tt_params iwl_mvm_default_tt_params = {
 	.ct_kill_entry = 118,
 	.ct_kill_exit = 96,
 	.ct_kill_duration = 5,
@@ -422,38 +422,16 @@ static const struct iwl_tt_params iwl7000_tt_params = {
 	.support_tx_backoff = true,
 };
 
-static const struct iwl_tt_params iwl7000_high_temp_tt_params = {
-	.ct_kill_entry = 118,
-	.ct_kill_exit = 96,
-	.ct_kill_duration = 5,
-	.dynamic_smps_entry = 114,
-	.dynamic_smps_exit = 110,
-	.tx_protection_entry = 114,
-	.tx_protection_exit = 108,
-	.tx_backoff = {
-		{.temperature = 112, .backoff = 300},
-		{.temperature = 113, .backoff = 800},
-		{.temperature = 114, .backoff = 1500},
-		{.temperature = 115, .backoff = 3000},
-		{.temperature = 116, .backoff = 5000},
-		{.temperature = 117, .backoff = 10000},
-	},
-	.support_ct_kill = true,
-	.support_dynamic_smps = true,
-	.support_tx_protection = true,
-	.support_tx_backoff = true,
-};
-
 void iwl_mvm_tt_initialize(struct iwl_mvm *mvm, u32 min_backoff)
 {
 	struct iwl_mvm_tt_mgmt *tt = &mvm->thermal_throttle;
 
 	IWL_DEBUG_TEMP(mvm, "Initialize Thermal Throttling\n");
 
-	if (mvm->cfg->high_temp)
-		tt->params = &iwl7000_high_temp_tt_params;
+	if (mvm->cfg->thermal_params)
+		tt->params = *mvm->cfg->thermal_params;
 	else
-		tt->params = &iwl7000_tt_params;
+		tt->params = iwl_mvm_default_tt_params;
 
 	tt->throttle = false;
 	tt->dynamic_smps = false;
-- 
2.1.0

