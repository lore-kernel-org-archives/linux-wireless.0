Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbbCATcp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:45 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/31] iwlwifi: mvm: restart firmware recording when no configuration is set
Date: Sun,  1 Mar 2015 21:31:41 +0200
Message-Id: <1425238304-498-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203419_537621_535BBD0E)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes the firmware will have a hard coded configuration.
In this case, the driver won't find any configuration
in the firmware file, and it will have to re-start
recording in case it has been stopped. This can't be done
by the configuration host command since there is no such
host command configured. Do that with the registers instead.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h |  1 -
 drivers/net/wireless/iwlwifi/mvm/fw.c   | 19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 6221e4d..6095088 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -370,7 +370,6 @@ enum secure_load_status_reg {
 #define MON_BUFF_CYCLE_CNT		(0xa03c48)
 
 #define DBGC_IN_SAMPLE			(0xa03c00)
-#define DBGC_OUT_CTRL			(0xa03c0c)
 
 /* FW chicken bits */
 #define LMPM_CHICK			0xA01FF8
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 64e9039..a81da4c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -544,6 +544,14 @@ int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 	return 0;
 }
 
+static inline void iwl_mvm_restart_early_start(struct iwl_mvm *mvm)
+{
+	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000)
+		iwl_clear_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x100);
+	else
+		iwl_write_prph(mvm->trans, DBGC_IN_SAMPLE, 1);
+}
+
 int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 conf_id)
 {
 	u8 *ptr;
@@ -554,6 +562,14 @@ int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 conf_id)
 		      "Invalid configuration %d\n", conf_id))
 		return -EINVAL;
 
+	/* EARLY START - firmware's configuration is hard coded */
+	if ((!mvm->fw->dbg_conf_tlv[conf_id] ||
+	     !mvm->fw->dbg_conf_tlv[conf_id]->num_of_hcmds) &&
+	    conf_id == FW_DBG_START_FROM_ALIVE) {
+		iwl_mvm_restart_early_start(mvm);
+		return 0;
+	}
+
 	if (!mvm->fw->dbg_conf_tlv[conf_id])
 		return -EINVAL;
 
@@ -663,6 +679,9 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		IWL_ERR(mvm, "Failed to initialize Smart Fifo\n");
 
 	mvm->fw_dbg_conf = FW_DBG_INVALID;
+	/* if we have a destination, assume EARLY START */
+	if (mvm->fw->dbg_dest_tlv)
+		mvm->fw_dbg_conf = FW_DBG_START_FROM_ALIVE;
 	iwl_mvm_start_fw_dbg_conf(mvm, FW_DBG_START_FROM_ALIVE);
 
 	ret = iwl_send_tx_ant_cfg(mvm, iwl_mvm_get_valid_tx_ant(mvm));
-- 
1.9.1

