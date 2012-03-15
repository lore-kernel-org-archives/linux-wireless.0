Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161450Ab2COU2O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/26] iwlwifi: remove firmware info from iwl_shared
Date: Thu, 15 Mar 2012 13:27:04 -0700
Message-Id: <1331843226-29860-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212822_185269_06B497DB)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

With error logging now completely handled in
the op_mode, the transport layer does not
need to know information about the loaded
firmware.

Remove this state information from the
iwl_shared data structure.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   20 +++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-shared.h |    1 -
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b8fcb4a..e91d88d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1498,8 +1498,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	priv = IWL_OP_MODE_GET_DVM(op_mode);
 	priv->shrd = trans->shrd;
 	priv->fw = fw;
-	/* TODO: remove fw from shared data later */
-	priv->shrd->fw = fw;
 
 	/*
 	 * Populate the state variables that the transport layer needs
@@ -1817,10 +1815,10 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	base = priv->device_pointers.error_event_table;
 	if (priv->cur_ucode == IWL_UCODE_INIT) {
 		if (!base)
-			base = priv->shrd->fw->init_errlog_ptr;
+			base = priv->fw->init_errlog_ptr;
 	} else {
 		if (!base)
-			base = priv->shrd->fw->inst_errlog_ptr;
+			base = priv->fw->inst_errlog_ptr;
 	}
 
 	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
@@ -1908,10 +1906,10 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	base = priv->device_pointers.log_event_table;
 	if (priv->cur_ucode == IWL_UCODE_INIT) {
 		if (!base)
-			base = priv->shrd->fw->init_evtlog_ptr;
+			base = priv->fw->init_evtlog_ptr;
 	} else {
 		if (!base)
-			base = priv->shrd->fw->inst_evtlog_ptr;
+			base = priv->fw->inst_evtlog_ptr;
 	}
 
 	if (mode == 0)
@@ -2022,13 +2020,13 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 
 	base = priv->device_pointers.log_event_table;
 	if (priv->cur_ucode == IWL_UCODE_INIT) {
-		logsize = priv->shrd->fw->init_evtlog_size;
+		logsize = priv->fw->init_evtlog_size;
 		if (!base)
-			base = priv->shrd->fw->init_evtlog_ptr;
+			base = priv->fw->init_evtlog_ptr;
 	} else {
-		logsize = priv->shrd->fw->inst_evtlog_size;
+		logsize = priv->fw->inst_evtlog_size;
 		if (!base)
-			base = priv->shrd->fw->inst_evtlog_ptr;
+			base = priv->fw->inst_evtlog_ptr;
 	}
 
 	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
@@ -2117,7 +2115,7 @@ static void iwl_nic_error(struct iwl_op_mode *op_mode)
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
 	IWL_ERR(priv, "Loaded firmware version: %s\n",
-		priv->shrd->fw->fw_version);
+		priv->fw->fw_version);
 
 	iwl_dump_nic_error_log(priv);
 	iwl_dump_nic_event_log(priv, false, NULL, false);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 90f464e..983b41e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -354,7 +354,6 @@ struct iwl_shared {
 	struct iwl_trans *trans;
 	void *drv;
 	struct iwl_hw_params hw_params;
-	const struct iwl_fw *fw;
 
 	/* eeprom -- this is in the card's little endian byte order */
 	u8 *eeprom;
-- 
1.7.0.4

