Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41004 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752283AbdG1O01 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:26:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:28 +0300
Message-Id: <20170728142337.19183-16-luca@coelho.fi> (sfid-20170728_162630_852008_1E0B8FE7)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 15/24] iwlwifi: mvm: support fw reading empty OTP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

If the OTP is empty, the NVM_GET_INFO command returns
with flags' bit(0) on. This means the FW returns the
default values for working with. This is allowed, so
use this returned data.

Fixes: e9e1ba3dbf00 ("iwlwifi: mvm: support getting nvm data from firmware")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h | 10 +++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c        |  7 ++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index d4c01f3dce32..00bc7a25dece 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -164,8 +164,16 @@ struct iwl_nvm_get_info {
 } __packed; /* GRP_REGULATORY_NVM_GET_INFO_CMD_S_VER_1 */
 
 /**
+ * enum iwl_nvm_info_general_flags - flags in NVM_GET_INFO resp
+ * @NVM_GENERAL_FLAGS_EMPTY_OTP: 1 if OTP is empty
+ */
+enum iwl_nvm_info_general_flags {
+	NVM_GENERAL_FLAGS_EMPTY_OTP	= BIT(0),
+};
+
+/**
  * struct iwl_nvm_get_info_general - general NVM data
- * @flags: 1 - empty, 0 - valid
+ * @flags: bit 0: 1 - empty, 0 - non-empty
  * @nvm_version: nvm version
  * @board_type: board type
  * @reserved: reserved
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index dac7e542a190..5cc749261ce3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -576,11 +576,8 @@ int iwl_mvm_nvm_get_from_fw(struct iwl_mvm *mvm)
 	}
 
 	rsp = (void *)hcmd.resp_pkt->data;
-	if (le32_to_cpu(rsp->general.flags)) {
-		IWL_ERR(mvm, "Invalid NVM data from FW\n");
-		ret = -EINVAL;
-		goto out;
-	}
+	if (le32_to_cpu(rsp->general.flags) & NVM_GENERAL_FLAGS_EMPTY_OTP)
+		IWL_INFO(mvm, "OTP is empty\n");
 
 	mvm->nvm_data = kzalloc(sizeof(*mvm->nvm_data) +
 				sizeof(struct ieee80211_channel) *
-- 
2.13.2
