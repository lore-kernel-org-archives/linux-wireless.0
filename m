Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24108 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaL3OTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/33] iwlwifi: mvm: support additional nvm_file in family 8000 B step
Date: Tue, 30 Dec 2014 16:18:46 +0200
Message-Id: <1419949148-24046-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154348_525140_9DA9A8C9)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

nvm_file in family 8000 B step and A step differ. This means
that the driver should support 2 file name as default.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c     |  5 ++++-
 drivers/net/wireless/iwlwifi/iwl-config.h   |  1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      | 11 ++++++++---
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 6c5c558..8f64928 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -90,7 +90,8 @@
 	IWL8000_FW_PRE "-" __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_8000		10
-#define DEFAULT_NVM_FILE_FAMILY_8000		"iwl_nvm_8000.bin"
+#define DEFAULT_NVM_FILE_FAMILY_8000A		"iwl_nvm_8000.bin"
+#define DEFAULT_NVM_FILE_FAMILY_8000		"iwl_nvm_8000B.bin"
 
 /* Max SDIO RX aggregation size of the ADDBA request/response */
 #define MAX_RX_AGG_SIZE_8260_SDIO	28
@@ -159,6 +160,7 @@ const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
+	.default_nvm_file_8000A = DEFAULT_NVM_FILE_FAMILY_8000A,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
 	.disable_dummy_notification = true,
 	.max_ht_ampdu_exponent  = MAX_HT_AMPDU_EXPONENT_8260_SDIO,
@@ -173,6 +175,7 @@ const struct iwl_cfg iwl4165_2ac_sdio_cfg = {
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
+	.default_nvm_file_8000A = DEFAULT_NVM_FILE_FAMILY_8000A,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
 	.bt_shared_single_ant = true,
 	.disable_dummy_notification = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 31c67df..2daabab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -300,6 +300,7 @@ struct iwl_cfg {
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
 	bool no_power_up_nic_in_init;
 	const char *default_nvm_file;
+	const char *default_nvm_file_8000A;
 	unsigned int max_rx_agg_size;
 	bool disable_dummy_notification;
 	unsigned int max_tx_agg_size;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 2293a51..f53bfd6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -85,6 +85,7 @@
 #include "testmode.h"
 #include "iwl-fw-error-dump.h"
 #include "iwl-prph.h"
+#include "iwl-csr.h"
 
 static const struct ieee80211_iface_limit iwl_mvm_limits[] = {
 	{
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 146554c..b2fa3b8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -511,10 +511,15 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	min_backoff = calc_min_backoff(trans, cfg);
 	iwl_mvm_tt_initialize(mvm, min_backoff);
 	/* set the nvm_file_name according to priority */
-	if (iwlwifi_mod_params.nvm_file)
+	if (iwlwifi_mod_params.nvm_file) {
 		mvm->nvm_file_name = iwlwifi_mod_params.nvm_file;
-	else
-		mvm->nvm_file_name = mvm->cfg->default_nvm_file;
+	} else {
+		if ((trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) &&
+		    (CSR_HW_REV_STEP(trans->hw_rev) == SILICON_A_STEP))
+			mvm->nvm_file_name = mvm->cfg->default_nvm_file_8000A;
+		else
+			mvm->nvm_file_name = mvm->cfg->default_nvm_file;
+	}
 
 	if (WARN(cfg->no_power_up_nic_in_init && !mvm->nvm_file_name,
 		 "not allowing power-up and not having nvm_file\n"))
-- 
1.9.1

