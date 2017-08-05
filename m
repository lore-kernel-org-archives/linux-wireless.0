Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42572 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752665AbdHEToa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:44:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Matt Chen <matt.chen@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:25 +0300
Message-Id: <20170805194331.17426-14-luca@coelho.fi> (sfid-20170805_214432_871950_FEE88AD3)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 13/19] iwlwifi: mvm: don't send CTDP commands via debugfs if not supported
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matt Chen <matt.chen@intel.com>

Fix this issue if it is not supported by the firmware.

Fixes: 00f481bd895a ("iwlwifi: mvm: add ctdp operations to debugfs")
Signed-off-by: Matt Chen <matt.chen@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 0b5cae54b86b..ceb486610a56 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -82,6 +82,9 @@ static ssize_t iwl_dbgfs_ctdp_budget_read(struct file *file,
 	char buf[16];
 	int pos, budget;
 
+	if (!iwl_mvm_is_ctdp_supported(mvm))
+		return -EOPNOTSUPP;
+
 	if (!iwl_mvm_firmware_running(mvm) ||
 	    mvm->fwrt.cur_fw_img != IWL_UCODE_REGULAR)
 		return -EIO;
@@ -103,6 +106,9 @@ static ssize_t iwl_dbgfs_stop_ctdp_write(struct iwl_mvm *mvm, char *buf,
 {
 	int ret;
 
+	if (!iwl_mvm_is_ctdp_supported(mvm))
+		return -EOPNOTSUPP;
+
 	if (!iwl_mvm_firmware_running(mvm) ||
 	    mvm->fwrt.cur_fw_img != IWL_UCODE_REGULAR)
 		return -EIO;
-- 
2.13.2
