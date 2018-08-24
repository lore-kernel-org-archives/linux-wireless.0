Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43958 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726572AbeHXOE7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:59 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:12 +0300
Message-Id: <20180824103018.15011-11-luca@coelho.fi> (sfid-20180824_123106_914008_A58E5798)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 10/16] iwlwifi: avoid code duplication in stopping fw debug data recording
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Make all FW debug data stop recording flows to use
iwl_fw_dbg_stop_recording function instead of writing to FW
registers directly.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c          |  4 ++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h          | 10 +++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c          |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c |  5 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |  8 +-------
 5 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 37b1e1f13621..3435a83e4d18 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1197,7 +1197,7 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 
 	if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
 		/* stop recording */
-		iwl_fw_dbg_stop_recording(fwrt);
+		iwl_fw_dbg_stop_recording(fwrt->trans);
 
 		iwl_fw_error_dump(fwrt);
 
@@ -1215,7 +1215,7 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 		u32 in_sample = iwl_read_prph(fwrt->trans, DBGC_IN_SAMPLE);
 		u32 out_ctrl = iwl_read_prph(fwrt->trans, DBGC_OUT_CTRL);
 
-		iwl_fw_dbg_stop_recording(fwrt);
+		iwl_fw_dbg_stop_recording(fwrt->trans);
 		/* wait before we collect the data till the DBGC stop */
 		udelay(500);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 5eba0e7ca760..d04e68104ded 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -196,14 +196,14 @@ _iwl_fw_dbg_trigger_simple_stop(struct iwl_fw_runtime *fwrt,
 					iwl_fw_dbg_get_trigger((fwrt)->fw,\
 							       (trig)))
 
-static inline void iwl_fw_dbg_stop_recording(struct iwl_fw_runtime *fwrt)
+static inline void iwl_fw_dbg_stop_recording(struct iwl_trans *trans)
 {
-	if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
-		iwl_set_bits_prph(fwrt->trans, MON_BUFF_SAMPLE_CTL, 0x100);
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
+		iwl_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x100);
 	} else {
-		iwl_write_prph(fwrt->trans, DBGC_IN_SAMPLE, 0);
+		iwl_write_prph(trans, DBGC_IN_SAMPLE, 0);
 		udelay(100);
-		iwl_write_prph(fwrt->trans, DBGC_OUT_CTRL, 0);
+		iwl_write_prph(trans, DBGC_OUT_CTRL, 0);
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 58531dd40c45..99050c8dd432 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1042,7 +1042,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	 * the recording automatically before entering D3.  This can
 	 * be removed once the FW starts doing that.
 	 */
-	iwl_fw_dbg_stop_recording(&mvm->fwrt);
+	iwl_fw_dbg_stop_recording(mvm->fwrt.trans);
 
 	/* must be last -- this switches firmware state */
 	ret = iwl_mvm_send_cmd(mvm, &d3_cfg_cmd);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 9b2a248e88b0..5f61b02e651e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -55,6 +55,7 @@
 #include "iwl-context-info.h"
 #include "iwl-context-info-gen3.h"
 #include "internal.h"
+#include "fw/dbg.h"
 
 /*
  * Start up NIC's basic functionality after it has been reset
@@ -164,9 +165,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power)
 	trans_pcie->is_down = true;
 
 	/* Stop dbgc before stopping device */
-	iwl_write_prph(trans, DBGC_IN_SAMPLE, 0);
-	udelay(100);
-	iwl_write_prph(trans, DBGC_OUT_CTRL, 0);
+	iwl_fw_dbg_stop_recording(trans);
 
 	/* tell the device to stop sending interrupts */
 	iwl_disable_interrupts(trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index d8aca7291614..cc8c53dc0ab6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1243,13 +1243,7 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 	trans_pcie->is_down = true;
 
 	/* Stop dbgc before stopping device */
-	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
-		iwl_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x100);
-	} else {
-		iwl_write_prph(trans, DBGC_IN_SAMPLE, 0);
-		udelay(100);
-		iwl_write_prph(trans, DBGC_OUT_CTRL, 0);
-	}
+	iwl_fw_dbg_stop_recording(trans);
 
 	/* tell the device to stop sending interrupts */
 	iwl_disable_interrupts(trans);
-- 
2.18.0
