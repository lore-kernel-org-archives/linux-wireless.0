Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:30938 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933578AbcCIRqF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:05 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/21] iwlwifi: mvm: fix unregistration of thermal in some error flows
Date: Wed,  9 Mar 2016 19:45:35 +0200
Message-Id: <1457545550-30677-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_184611_090475_4216E396)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

The call to iwl_mvm_thermal_initialize() was too early in the
function.
Unregister will be performed when goto out_unregister is called,
but as the code was - out_free may be called and leave without
unregistering from thermal.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 699a808..4322e8e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -611,9 +611,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	IWL_INFO(mvm, "Detected %s, REV=0x%X\n",
 		 mvm->cfg->name, mvm->trans->hw_rev);
 
-	min_backoff = calc_min_backoff(trans, cfg);
-	iwl_mvm_thermal_initialize(mvm, min_backoff);
-
 	if (iwlwifi_mod_params.nvm_file)
 		mvm->nvm_file_name = iwlwifi_mod_params.nvm_file;
 	else
@@ -666,6 +663,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (err)
 		goto out_free;
 
+	min_backoff = calc_min_backoff(trans, cfg);
+	iwl_mvm_thermal_initialize(mvm, min_backoff);
+
 	err = iwl_mvm_dbgfs_register(mvm, dbgfs_dir);
 	if (err)
 		goto out_unregister;
-- 
2.5.0

