Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51650 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751612AbdDNJCa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:02:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:01:45 +0300
Message-Id: <20170414090210.31397-2-luca@coelho.fi> (sfid-20170414_110234_066567_183814EF)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 01/26] iwlwifi: mvm: read new secure boot registers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Addresses were changed for a000 devices.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 13 ++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index bb7e0d642981..e1aa1f7836fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -400,6 +400,8 @@ enum aux_misc_master1_en {
 #define PREG_AUX_BUS_WPROT_0		0xA04CC0
 #define SB_CPU_1_STATUS			0xA01E30
 #define SB_CPU_2_STATUS			0xA01E34
+#define UMAG_SB_CPU_1_STATUS		0xA038C0
+#define UMAG_SB_CPU_2_STATUS		0xA038C4
 
 /* FW chicken bits */
 #define LMPM_CHICK			0xA01FF8
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index e481bb050c6e..6adbd4bcb40a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -639,11 +639,18 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	ret = iwl_wait_notification(&mvm->notif_wait, &alive_wait,
 				    MVM_UCODE_ALIVE_TIMEOUT);
 	if (ret) {
-		if (mvm->trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		struct iwl_trans *trans = mvm->trans;
+
+		if (trans->cfg->gen2)
+			IWL_ERR(mvm,
+				"SecBoot CPU1 Status: 0x%x, CPU2 Status: 0x%x\n",
+				iwl_read_prph(trans, UMAG_SB_CPU_1_STATUS),
+				iwl_read_prph(trans, UMAG_SB_CPU_2_STATUS));
+		else if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
 			IWL_ERR(mvm,
 				"SecBoot CPU1 Status: 0x%x, CPU2 Status: 0x%x\n",
-				iwl_read_prph(mvm->trans, SB_CPU_1_STATUS),
-				iwl_read_prph(mvm->trans, SB_CPU_2_STATUS));
+				iwl_read_prph(trans, SB_CPU_1_STATUS),
+				iwl_read_prph(trans, SB_CPU_2_STATUS));
 		mvm->cur_ucode = old_type;
 		return ret;
 	}
-- 
2.11.0
