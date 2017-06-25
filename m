Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34882 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751342AbdFYLMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:39 +0300
Message-Id: <20170625111158.1792-8-luca@coelho.fi> (sfid-20170625_131300_704321_8B3F0F8F)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 07/26] iwlwifi: mvm: add documentation for enum iwl_debug_cmds
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add kernel-doc documentation for enum iwl_debug_cmds, linking the
structures used by the commands.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index dc613b604914..224d10b1b076 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -554,9 +554,26 @@ enum iwl_regulatory_and_nvm_subcmd_ids {
 	NVM_GET_INFO = 0x2,
 };
 
+/**
+ * enum iwl_debug_cmds - debug commands
+ */
 enum iwl_debug_cmds {
+	/**
+	 * @LMAC_RD_WR:
+	 * LMAC memory read/write, using &struct iwl_dbg_mem_access_cmd and
+	 * &struct iwl_dbg_mem_access_rsp
+	 */
 	LMAC_RD_WR = 0x0,
+	/**
+	 * @UMAC_RD_WR:
+	 * UMAC memory read/write, using &struct iwl_dbg_mem_access_cmd and
+	 * &struct iwl_dbg_mem_access_rsp
+	 */
 	UMAC_RD_WR = 0x1,
+	/**
+	 * @MFU_ASSERT_DUMP_NTF:
+	 * &struct iwl_mfu_assert_dump_notif
+	 */
 	MFU_ASSERT_DUMP_NTF = 0xFE,
 };
 
-- 
2.11.0
