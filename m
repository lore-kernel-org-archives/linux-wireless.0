Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60594 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751239AbdFBJfc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:35:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 12:35:11 +0300
Message-Id: <20170602093516.16369-6-luca@coelho.fi> (sfid-20170602_113539_562823_FE159901)
In-Reply-To: <20170602093516.16369-1-luca@coelho.fi>
References: <20170602093516.16369-1-luca@coelho.fi>
Subject: [PATCH 05/10] iwlwifi: mvm: fix firmware debug restart recording
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we want to stop the recording of the firmware debug
and restart it later without reloading the firmware we
don't need to resend the configuration that comes with
host commands.
Sending those commands confused the hardware and led to
an NMI 0x66.

Change the flow as following:
* read the relevant registers (DBGC_IN_SAMPLE, DBGC_OUT_CTRL)
* clear those registers
* wait for the hardware to complete its write to the buffer
* get the data
* restore the value of those registers (to restart the
  recording)

For early start (where the configuration is already
compiled in the firmware), we don't need to set those
registers after the firmware has been loaded, but only
when we want to restart the recording without having
restarted the firmware.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 12 +---------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h    |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c    | 32 ++++++++++++++++++-------
 4 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 306bc967742e..77efbb78e867 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -370,6 +370,7 @@
 #define MON_DMARB_RD_DATA_ADDR		(0xa03c5c)
 
 #define DBGC_IN_SAMPLE			(0xa03c00)
+#define DBGC_OUT_CTRL			(0xa03c0c)
 
 /* enable the ID buf for read */
 #define WFPM_PS_CTL_CLR			0xA0300C
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 7b86a4f1b574..c8712e6eea74 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -1002,14 +1002,6 @@ int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 	return 0;
 }
 
-static inline void iwl_mvm_restart_early_start(struct iwl_mvm *mvm)
-{
-	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000)
-		iwl_clear_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x100);
-	else
-		iwl_write_prph(mvm->trans, DBGC_IN_SAMPLE, 1);
-}
-
 int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 conf_id)
 {
 	u8 *ptr;
@@ -1023,10 +1015,8 @@ int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 conf_id)
 	/* EARLY START - firmware's configuration is hard coded */
 	if ((!mvm->fw->dbg_conf_tlv[conf_id] ||
 	     !mvm->fw->dbg_conf_tlv[conf_id]->num_of_hcmds) &&
-	    conf_id == FW_DBG_START_FROM_ALIVE) {
-		iwl_mvm_restart_early_start(mvm);
+	    conf_id == FW_DBG_START_FROM_ALIVE)
 		return 0;
-	}
 
 	if (!mvm->fw->dbg_conf_tlv[conf_id])
 		return -EINVAL;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ed20c0c5abc8..52f8d7a6a7dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1756,6 +1756,7 @@ static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 	if (!iwl_mvm_has_new_tx_api(mvm))
 		iwl_free_fw_paging(mvm);
 	mvm->ucode_loaded = false;
+	mvm->fw_dbg_conf = FW_DBG_INVALID;
 	iwl_trans_stop_device(mvm->trans);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 9ffff6ed8133..3da5ec40aaea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1149,21 +1149,37 @@ static void iwl_mvm_fw_error_dump_wk(struct work_struct *work)
 
 	mutex_lock(&mvm->mutex);
 
-	/* stop recording */
 	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
+		/* stop recording */
 		iwl_set_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x100);
+
+		iwl_mvm_fw_error_dump(mvm);
+
+		/* start recording again if the firmware is not crashed */
+		if (!test_bit(STATUS_FW_ERROR, &mvm->trans->status) &&
+		    mvm->fw->dbg_dest_tlv)
+			iwl_clear_bits_prph(mvm->trans,
+					    MON_BUFF_SAMPLE_CTL, 0x100);
 	} else {
+		u32 in_sample = iwl_read_prph(mvm->trans, DBGC_IN_SAMPLE);
+		u32 out_ctrl = iwl_read_prph(mvm->trans, DBGC_OUT_CTRL);
+
+		/* stop recording */
 		iwl_write_prph(mvm->trans, DBGC_IN_SAMPLE, 0);
-		/* wait before we collect the data till the DBGC stop */
 		udelay(100);
-	}
+		iwl_write_prph(mvm->trans, DBGC_OUT_CTRL, 0);
+		/* wait before we collect the data till the DBGC stop */
+		udelay(500);
 
-	iwl_mvm_fw_error_dump(mvm);
+		iwl_mvm_fw_error_dump(mvm);
 
-	/* start recording again if the firmware is not crashed */
-	WARN_ON_ONCE((!test_bit(STATUS_FW_ERROR, &mvm->trans->status)) &&
-		     mvm->fw->dbg_dest_tlv &&
-		     iwl_mvm_start_fw_dbg_conf(mvm, mvm->fw_dbg_conf));
+		/* start recording again if the firmware is not crashed */
+		if (!test_bit(STATUS_FW_ERROR, &mvm->trans->status) &&
+		    mvm->fw->dbg_dest_tlv) {
+			iwl_write_prph(mvm->trans, DBGC_IN_SAMPLE, in_sample);
+			iwl_write_prph(mvm->trans, DBGC_OUT_CTRL, out_ctrl);
+		}
+	}
 
 	mutex_unlock(&mvm->mutex);
 
-- 
2.11.0
