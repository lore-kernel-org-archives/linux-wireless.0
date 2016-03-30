Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:33836 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbcC3NNX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 09:13:23 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>, stable@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] iwlwifi: mvm: fix memory leak in paging
Date: Wed, 30 Mar 2016 16:12:51 +0300
Message-Id: <1459343571-27345-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_151326_163879_F8D107E6)
In-Reply-To: <1459343451.4731.6.camel@intel.com>
References: <1459343451.4731.6.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Currently paging download buffer is freed during the
the unloading of the opmode which happens when the driver
is unloaded.

This causes a memory leak since the paging download
buffer is allocated every time we enable the
interface, so the download buffer can be allocated many
times, but only be freed once.

Free paging download buffer during disabling of the
interface.

CC: stable@vger.kernel.org [4.3+]
Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 76e649c..a50f4df 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1147,6 +1147,8 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	/* the fw is stopped, the aux sta is dead: clean up driver state */
 	iwl_mvm_del_aux_sta(mvm);
 
+	iwl_free_fw_paging(mvm);
+
 	/*
 	 * Clear IN_HW_RESTART flag when stopping the hw (as restart_complete()
 	 * won't be called in this case).
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 5e8ab79..d278399 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -761,8 +761,6 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	for (i = 0; i < NVM_MAX_NUM_SECTIONS; i++)
 		kfree(mvm->nvm_sections[i].data);
 
-	iwl_free_fw_paging(mvm);
-
 	iwl_mvm_tof_clean(mvm);
 
 	ieee80211_free_hw(mvm->hw);
-- 
2.5.0

