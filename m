Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:61742 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbaBCU7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:10 -0500
Received: by mail-ea0-f173.google.com with SMTP id d10so3977164eaj.32
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:09 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>, Ido Yariv <idox.yariv@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/62] iwlwifi: mvm: handle platform PCIe power limitation
Date: Mon,  3 Feb 2014 22:57:39 +0200
Message-Id: <1391461088-8082-33-git-send-email-egrumbach@gmail.com> (sfid-20140203_220011_097423_F4B57698)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

The tx backoff settings used by the thermal throttling mechanism can
also be used for enforcing a limit on the power consumption of the module.

Handle the platform PCIe power limitation by translating the limit
(measured in mw) to its respective tx backoff value. The translation is
module specific.

The resulting tx backoff value is sent to the ucode, and also serves as the
minimal backoff value that can be set by the thermal throttling mechanism.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-config.h |   11 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw.c     |    3 +++
 drivers/net/wireless/iwlwifi/mvm/mvm.h    |    5 ++++-
 drivers/net/wireless/iwlwifi/mvm/ops.c    |   21 ++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/tt.c     |    7 +++++--
 5 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index df7d409..456fcca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -193,6 +193,15 @@ struct iwl_eeprom_params {
 	bool enhanced_txpower;
 };
 
+/* Tx-backoff power threshold
+ * @pwr: The power limit in mw
+ * @backoff: The tx-backoff in uSec
+ */
+struct iwl_pwr_tx_backoff {
+	u32 pwr;
+	u32 backoff;
+};
+
 /**
  * struct iwl_cfg
  * @name: Offical name of the device
@@ -219,6 +228,7 @@ struct iwl_eeprom_params {
  * @host_interrupt_operation_mode: device needs host interrupt operation
  *	mode set
  * @nvm_hw_section_num: the ID of the HW NVM section
+ * @pwr_tx_backoffs: translation table between power limits and backoffs
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -250,6 +260,7 @@ struct iwl_cfg {
 	const bool host_interrupt_operation_mode;
 	bool high_temp;
 	u8   nvm_hw_section_num;
+	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index c03d395..5798f1a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -439,6 +439,9 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 			goto error;
 	}
 
+	/* Initialize tx backoffs to the minimal possible */
+	iwl_mvm_tt_tx_backoff(mvm, 0);
+
 	ret = iwl_mvm_power_update_device_mode(mvm);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 80052d9..3202a6e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -418,6 +418,7 @@ struct iwl_tt_params {
  * @ct_kill_exit: worker to exit thermal kill
  * @dynamic_smps: Is thermal throttling enabled dynamic_smps?
  * @tx_backoff: The current thremal throttling tx backoff in uSec.
+ * @min_backoff: The minimal tx backoff due to power restrictions
  * @params: Parameters to configure the thermal throttling algorithm.
  * @throttle: Is thermal throttling is active?
  */
@@ -425,6 +426,7 @@ struct iwl_mvm_tt_mgmt {
 	struct delayed_work ct_kill_exit;
 	bool dynamic_smps;
 	u32 tx_backoff;
+	u32 min_backoff;
 	const struct iwl_tt_params *params;
 	bool throttle;
 };
@@ -947,8 +949,9 @@ static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
 }
 
 /* Thermal management and CT-kill */
+void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
 void iwl_mvm_tt_handler(struct iwl_mvm *mvm);
-void iwl_mvm_tt_initialize(struct iwl_mvm *mvm);
+void iwl_mvm_tt_initialize(struct iwl_mvm *mvm, u32 min_backoff);
 void iwl_mvm_tt_exit(struct iwl_mvm *mvm);
 void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 24afbd6..cf33a12 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -326,6 +326,23 @@ static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
 /* this forward declaration can avoid to export the function */
 static void iwl_mvm_async_handlers_wk(struct work_struct *wk);
 
+static u32 calc_min_backoff(struct iwl_trans *trans, const struct iwl_cfg *cfg)
+{
+	const struct iwl_pwr_tx_backoff *pwr_tx_backoff = cfg->pwr_tx_backoffs;
+
+	if (!pwr_tx_backoff)
+		return 0;
+
+	while (pwr_tx_backoff->pwr) {
+		if (trans->dflt_pwr_limit >= pwr_tx_backoff->pwr)
+			return pwr_tx_backoff->backoff;
+
+		pwr_tx_backoff++;
+	}
+
+	return 0;
+}
+
 static struct iwl_op_mode *
 iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		      const struct iwl_fw *fw, struct dentry *dbgfs_dir)
@@ -338,6 +355,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		TX_CMD,
 	};
 	int err, scan_size;
+	u32 min_backoff;
 
 	/*
 	 * We use IWL_MVM_STATION_COUNT to check the validity of the station
@@ -433,7 +451,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	IWL_INFO(mvm, "Detected %s, REV=0x%X\n",
 		 mvm->cfg->name, mvm->trans->hw_rev);
 
-	iwl_mvm_tt_initialize(mvm);
+	min_backoff = calc_min_backoff(trans, cfg);
+	iwl_mvm_tt_initialize(mvm, min_backoff);
 
 	/*
 	 * If the NVM exists in an external file,
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 3afa6b6..7a99fa3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -403,7 +403,7 @@ static void iwl_mvm_tt_tx_protection(struct iwl_mvm *mvm, bool enable)
 	}
 }
 
-static void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff)
+void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_THERMAL_MNG_BACKOFF,
@@ -412,6 +412,8 @@ static void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff)
 		.flags = CMD_SYNC,
 	};
 
+	backoff = max(backoff, mvm->thermal_throttle.min_backoff);
+
 	if (iwl_mvm_send_cmd(mvm, &cmd) == 0) {
 		IWL_DEBUG_TEMP(mvm, "Set Thermal Tx backoff to: %u\n",
 			       backoff);
@@ -534,7 +536,7 @@ static const struct iwl_tt_params iwl7000_high_temp_tt_params = {
 	.support_tx_backoff = true,
 };
 
-void iwl_mvm_tt_initialize(struct iwl_mvm *mvm)
+void iwl_mvm_tt_initialize(struct iwl_mvm *mvm, u32 min_backoff)
 {
 	struct iwl_mvm_tt_mgmt *tt = &mvm->thermal_throttle;
 
@@ -546,6 +548,7 @@ void iwl_mvm_tt_initialize(struct iwl_mvm *mvm)
 		tt->params = &iwl7000_tt_params;
 
 	tt->throttle = false;
+	tt->min_backoff = min_backoff;
 	INIT_DELAYED_WORK(&tt->ct_kill_exit, check_exit_ctkill);
 }
 
-- 
1.7.9.5

