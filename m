Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60720 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751214AbdFBL0L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:26:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:33 +0300
Message-Id: <20170602112553.2466-6-luca@coelho.fi> (sfid-20170602_132637_018816_C84C0410)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 05/25] iwlwifi: mvm: document which group enums are used with which group ID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make it explicit which command definition enum is supposed to be
used with which command group, rather than relying on being able
to figure it out by name.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 27 ++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 0996127897c1..c69aff91404b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -131,7 +131,7 @@ enum iwl_mvm_tx_fifo {
 
 
 /* commands */
-enum {
+enum iwl_legacy_cmds {
 	MVM_ALIVE = 0x1,
 	REPLY_ERROR = 0x2,
 	ECHO_CMD = 0x3,
@@ -354,8 +354,29 @@ enum iwl_debug_cmds {
 	MFU_ASSERT_DUMP_NTF = 0xFE,
 };
 
-/* command groups */
-enum {
+/**
+ * enum iwl_mvm_command_groups - command groups for the firmware
+ * @LEGACY_GROUP: legacy group, uses command IDs from &enum iwl_legacy_cmds
+ * @LONG_GROUP: legacy group with long header, also uses command IDs
+ *	from &enum iwl_legacy_cmds
+ * @SYSTEM_GROUP: system group, uses command IDs from
+ *	&enum iwl_system_subcmd_ids
+ * @MAC_CONF_GROUP: MAC configuration group, uses command IDs from
+ *	&enum iwl_mac_conf_subcmd_ids
+ * @PHY_OPS_GROUP: PHY operations group, uses command IDs from
+ *	&enum iwl_phy_ops_subcmd_ids
+ * @DATA_PATH_GROUP: data path group, uses command IDs from
+ *	&enum iwl_data_path_subcmd_ids
+ * @SCAN_GROUP: scan group, uses command IDs from &enum iwl_scan_subcmd_ids
+ * @NAN_GROUP: NAN group, uses command IDs from &enum iwl_nan_subcmd_ids
+ * @TOF_GROUP: TOF group, uses command IDs from &enum iwl_tof_subcmd_ids
+ * @PROT_OFFLOAD_GROUP: protocol offload group, uses command IDs from
+ *	&enum iwl_prot_offload_subcmd_ids
+ * @REGULATORY_AND_NVM_GROUP: regulatory/NVM group, uses command IDs from
+ *	&enum iwl_regulatory_and_nvm_subcmd_ids
+ * @DEBUG_GROUP: Debug group, uses command IDs from &enum iwl_debug_cmds
+ */
+enum iwl_mvm_command_groups {
 	LEGACY_GROUP = 0x0,
 	LONG_GROUP = 0x1,
 	SYSTEM_GROUP = 0x2,
-- 
2.11.0
