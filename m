Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36002 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751701AbdF1UPf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:15:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:15 +0300
Message-Id: <20170628201330.9432-17-luca@coelho.fi> (sfid-20170628_224510_660137_157019A2)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 16/31] iwlwifi: mvm: use proper CDB check in PHY context modify
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the firmware supports CDB, PHY contexts cannot be modified to
change their band, but need to be added/remove instead. Instead of
relying on iwl_mvm_has_new_tx_api(), check the right FW capa flag
IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT and remove the comment.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index d59efe804356..fb9eaf003ea5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -255,8 +255,8 @@ int iwl_mvm_phy_ctxt_changed(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* In CDB mode we cannot modify PHY context between bands so... */
-	if (iwl_mvm_has_new_tx_api(mvm) &&
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT) &&
 	    ctxt->channel->band != chandef->chan->band) {
 		int ret;
 
-- 
2.11.0
