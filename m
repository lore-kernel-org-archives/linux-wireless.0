Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36196 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752177AbdI2Qoj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:44:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:08 +0300
Message-Id: <20170929164423.23666-4-luca@coelho.fi> (sfid-20170929_200759_103602_D0A6FF0B)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
Subject: [PATCH 03/18] iwlwifi: mvm: add marker cmd response struct.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

This helps for documentation and clarifies the code by defining the
exact response struct for the marker command.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h | 1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h    | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
index 074868394427..7ebbf097488b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
@@ -504,6 +504,7 @@ enum iwl_legacy_cmds {
 
 	/**
 	 * @MARKER_CMD: trace marker command, uses &struct iwl_mvm_marker
+	 * with &struct iwl_mvm_marker_rsp
 	 */
 	MARKER_CMD = 0xcb,
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h b/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
index 9f88b61536bc..0a81fb1b6ed4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
@@ -278,6 +278,15 @@ struct iwl_mvm_marker {
 	__le32 metadata[0];
 } __packed; /* MARKER_API_S_VER_1 */
 
+/**
+ * struct iwl_mvm_marker_rsp - Response to marker cmd
+ *
+ * @gp2: The gp2 clock value in the FW
+ */
+struct iwl_mvm_marker_rsp {
+	__le32 gp2;
+} __packed;
+
 /* Operation types for the debug mem access */
 enum {
 	DEBUG_MEM_OP_READ = 0,
-- 
2.14.1
