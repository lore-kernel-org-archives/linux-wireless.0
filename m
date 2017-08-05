Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42596 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752665AbdHETom (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:44:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:23 +0300
Message-Id: <20170805194331.17426-12-luca@coelho.fi> (sfid-20170805_214445_288650_730C5431)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 11/19] iwlwifi: mvm: set the default cTDP budget
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

In case there is no value received from BIOS
for cTDP budget, the default should be 2000 mWatt.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index c5a9259145ea..7eee6d5f7922 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1173,7 +1173,12 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	}
 
 	/* TODO: read the budget from BIOS / Platform NVM */
-	if (iwl_mvm_is_ctdp_supported(mvm) && mvm->cooling_dev.cur_state > 0) {
+
+	/*
+	 * In case there is no budget from BIOS / Platform NVM the default
+	 * budget should be 2000mW (cooling state 0).
+	 */
+	if (iwl_mvm_is_ctdp_supported(mvm)) {
 		ret = iwl_mvm_ctdp_command(mvm, CTDP_CMD_OPERATION_START,
 					   mvm->cooling_dev.cur_state);
 		if (ret)
-- 
2.13.2
