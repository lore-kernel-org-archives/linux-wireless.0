Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbbAVUeg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:36 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/38] iwlwifi: mvm: support family 8000 C step
Date: Thu, 22 Jan 2015 22:33:21 +0200
Message-Id: <1421958809-3371-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214447_498401_8F25E305)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

C step functionality in the driver is exactly the same as
B step besides the ucode name that present as iwlwifi-8000C-xx.ucode
instead of iwlwifi-8000B-xx.ucode

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h    | 1 +
 drivers/net/wireless/iwlwifi/mvm/nvm.c    | 2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 7f40cf3..faa17f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -307,6 +307,7 @@
 enum {
 	SILICON_A_STEP = 0,
 	SILICON_B_STEP,
+	SILICON_C_STEP,
 };
 
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index d8ac01d..5383429 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -356,7 +356,7 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 		max_section_size = IWL_MAX_NVM_SECTION_SIZE;
 	else if (CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_A_STEP)
 		max_section_size = IWL_MAX_NVM_8000A_SECTION_SIZE;
-	else /* Family 8000 B-step */
+	else /* Family 8000 B-step or C-step */
 		max_section_size = IWL_MAX_NVM_8000B_SECTION_SIZE;
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 95c2ab1..49e3206 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -982,7 +982,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 
 	/* Load the given image to the HW */
 	if ((trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) &&
-	    (CSR_HW_REV_STEP(trans->hw_rev) == SILICON_B_STEP))
+	    (CSR_HW_REV_STEP(trans->hw_rev) != SILICON_A_STEP))
 		return iwl_pcie_load_given_ucode_8000b(trans, fw);
 	else
 		return iwl_pcie_load_given_ucode(trans, fw);
-- 
1.9.1

