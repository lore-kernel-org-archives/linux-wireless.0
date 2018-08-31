Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45620 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727633AbeHaODJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:03:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:00 +0300
Message-Id: <20180831095614.14099-3-luca@coelho.fi> (sfid-20180831_115634_603094_09CF4051)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 02/16] iwlwifi: fw: add a restart FW debug function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Move the restart FW debug code to a function. This avoids code
duplication and lays the infra to support the new start and stop
host commands in some future devices.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 37 ++++------------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   | 42 +++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  2 +-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  2 +-
 5 files changed, 50 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 9963d6c84908..b0da16f3f474 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1149,6 +1149,7 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 {
 	struct iwl_fw_runtime *fwrt =
 		container_of(work, struct iwl_fw_runtime, dump.wk.work);
+	struct iwl_fw_dbg_params params = {0};
 
 	if (fwrt->ops && fwrt->ops->dump_start &&
 	    fwrt->ops->dump_start(fwrt->ops_ctx))
@@ -1162,38 +1163,16 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 		goto out;
 	}
 
-	if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
-		/* stop recording */
-		iwl_fw_dbg_stop_recording(fwrt->trans);
-
-		iwl_fw_error_dump(fwrt);
-
-		/* start recording again if the firmware is not crashed */
-		if (!test_bit(STATUS_FW_ERROR, &fwrt->trans->status) &&
-		    fwrt->fw->dbg_dest_tlv) {
-			iwl_clear_bits_prph(fwrt->trans,
-					    MON_BUFF_SAMPLE_CTL, 0x100);
-			iwl_clear_bits_prph(fwrt->trans,
-					    MON_BUFF_SAMPLE_CTL, 0x1);
-			iwl_set_bits_prph(fwrt->trans,
-					  MON_BUFF_SAMPLE_CTL, 0x1);
-		}
-	} else {
-		u32 in_sample = iwl_read_prph(fwrt->trans, DBGC_IN_SAMPLE);
-		u32 out_ctrl = iwl_read_prph(fwrt->trans, DBGC_OUT_CTRL);
+	iwl_fw_dbg_stop_recording(fwrt->trans, &params);
+
+	iwl_fw_error_dump(fwrt);
 
-		iwl_fw_dbg_stop_recording(fwrt->trans);
+	/* start recording again if the firmware is not crashed */
+	if (!test_bit(STATUS_FW_ERROR, &fwrt->trans->status) &&
+	    fwrt->fw->dbg_dest_tlv) {
 		/* wait before we collect the data till the DBGC stop */
 		udelay(500);
-
-		iwl_fw_error_dump(fwrt);
-
-		/* start recording again if the firmware is not crashed */
-		if (!test_bit(STATUS_FW_ERROR, &fwrt->trans->status) &&
-		    fwrt->fw->dbg_dest_tlv) {
-			iwl_write_prph(fwrt->trans, DBGC_IN_SAMPLE, in_sample);
-			iwl_write_prph(fwrt->trans, DBGC_OUT_CTRL, out_ctrl);
-		}
+		iwl_fw_dbg_restart_recording(fwrt->trans, &params);
 	}
 out:
 	if (fwrt->ops && fwrt->ops->dump_end)
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index d04e68104ded..878758b6c7ae 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -83,6 +83,16 @@ struct iwl_fw_dump_desc {
 	struct iwl_fw_error_dump_trigger_desc trig_desc;
 };
 
+/**
+ * struct iwl_fw_dbg_params - register values to restore
+ * @in_sample: DBGC_IN_SAMPLE value
+ * @out_ctrl: DBGC_OUT_CTRL value
+ */
+struct iwl_fw_dbg_params {
+	u32 in_sample;
+	u32 out_ctrl;
+};
+
 extern const struct iwl_fw_dump_desc iwl_dump_desc_assert;
 
 static inline void iwl_fw_free_dump_desc(struct iwl_fw_runtime *fwrt)
@@ -196,14 +206,40 @@ _iwl_fw_dbg_trigger_simple_stop(struct iwl_fw_runtime *fwrt,
 					iwl_fw_dbg_get_trigger((fwrt)->fw,\
 							       (trig)))
 
-static inline void iwl_fw_dbg_stop_recording(struct iwl_trans *trans)
+static inline void
+iwl_fw_dbg_stop_recording(struct iwl_trans *trans,
+			  struct iwl_fw_dbg_params *params)
 {
 	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
 		iwl_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x100);
+		return;
+	}
+
+	if (params) {
+		params->in_sample = iwl_read_prph(trans, DBGC_IN_SAMPLE);
+		params->out_ctrl = iwl_read_prph(trans, DBGC_OUT_CTRL);
+	}
+
+	iwl_write_prph(trans, DBGC_IN_SAMPLE, 0);
+	udelay(100);
+	iwl_write_prph(trans, DBGC_OUT_CTRL, 0);
+}
+
+static inline void
+iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
+			     struct iwl_fw_dbg_params *params)
+{
+	if (WARN_ON(!params))
+		return;
+
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
+		iwl_clear_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x100);
+		iwl_clear_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x1);
+		iwl_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x1);
 	} else {
-		iwl_write_prph(trans, DBGC_IN_SAMPLE, 0);
+		iwl_write_prph(trans, DBGC_IN_SAMPLE, params->in_sample);
 		udelay(100);
-		iwl_write_prph(trans, DBGC_OUT_CTRL, 0);
+		iwl_write_prph(trans, DBGC_OUT_CTRL, params->out_ctrl);
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 99050c8dd432..5305342439b2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1042,7 +1042,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	 * the recording automatically before entering D3.  This can
 	 * be removed once the FW starts doing that.
 	 */
-	iwl_fw_dbg_stop_recording(mvm->fwrt.trans);
+	iwl_fw_dbg_stop_recording(mvm->fwrt.trans, NULL);
 
 	/* must be last -- this switches firmware state */
 	ret = iwl_mvm_send_cmd(mvm, &d3_cfg_cmd);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 5f61b02e651e..b5902c74e5d0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -165,7 +165,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power)
 	trans_pcie->is_down = true;
 
 	/* Stop dbgc before stopping device */
-	iwl_fw_dbg_stop_recording(trans);
+	iwl_fw_dbg_stop_recording(trans, NULL);
 
 	/* tell the device to stop sending interrupts */
 	iwl_disable_interrupts(trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index cc8c53dc0ab6..5ecd5c8d0f02 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1243,7 +1243,7 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 	trans_pcie->is_down = true;
 
 	/* Stop dbgc before stopping device */
-	iwl_fw_dbg_stop_recording(trans);
+	iwl_fw_dbg_stop_recording(trans, NULL);
 
 	/* tell the device to stop sending interrupts */
 	iwl_disable_interrupts(trans);
-- 
2.18.0
