Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54308 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954260AbdDYU1p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:27:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:41 +0300
Message-Id: <20170425202243.7844-24-luca@coelho.fi> (sfid-20170425_222815_210994_51CB82F3)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 23/25] iwlwifi: mvm: memset binding before setting values
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The changes in commit 9415af7f306b ("iwlwifi: mvm: support new binding
API") assigned values that were later memset to 0.  Move the memset
earlier.

Fixes: 9415af7f306b ("iwlwifi: mvm: support new binding API")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
index 2e0ed080457f..75d35f6b041e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
@@ -86,6 +86,8 @@ static int iwl_mvm_binding_cmd(struct iwl_mvm *mvm, u32 action,
 	u32 status;
 	int size;
 
+	memset(&cmd, 0, sizeof(cmd));
+
 	if (fw_has_capa(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT)) {
 		size = sizeof(cmd);
@@ -98,8 +100,6 @@ static int iwl_mvm_binding_cmd(struct iwl_mvm *mvm, u32 action,
 		size = IWL_BINDING_CMD_SIZE_V1;
 	}
 
-	memset(&cmd, 0, sizeof(cmd));
-
 	cmd.id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(phyctxt->id,
 							   phyctxt->color));
 	cmd.action = cpu_to_le32(action);
-- 
2.11.0
