Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17012 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbcCBH5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:40 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 37/43] iwlwifi: mvm: update ucode status before stopping device
Date: Wed,  2 Mar 2016 09:56:38 +0200
Message-Id: <1456905404-14435-37-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085951_298820_5A5A7C34)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

Leaving ucode_loaded to true after stop_device() has been called
is a recipe for problems. Flows that are not sync'ed with the
driver life cycle (like debugfs hooks and thermal hooks) must
check that the firmware is loaded before they interact with it.
Therefore we need to keep this variable updated with the real
status of the firmware.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       | 3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 6 ++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 6 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 2 +-
 5 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index cf5e634..c1a3131 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -816,8 +816,7 @@ static int iwl_mvm_switch_to_d3(struct iwl_mvm *mvm)
 {
 	iwl_mvm_scan_stop(mvm, IWL_MVM_SCAN_REGULAR, true);
 
-	iwl_trans_stop_device(mvm->trans);
-
+	iwl_mvm_stop_device(mvm);
 	/*
 	 * Set the HW restart bit -- this is mostly true as we're
 	 * going to load new firmware and reprogram that, though
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index f075c36..efec6ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1009,7 +1009,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	IWL_DEBUG_INFO(mvm, "RT uCode started.\n");
 	return 0;
  error:
-	iwl_trans_stop_device(mvm->trans);
+	iwl_mvm_stop_device(mvm);
 	return ret;
 }
 
@@ -1053,7 +1053,7 @@ int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm)
 
 	return 0;
  error:
-	iwl_trans_stop_device(mvm->trans);
+	iwl_mvm_stop_device(mvm);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 927b055..ec6b072 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -972,7 +972,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	 */
 	iwl_mvm_unref_all_except(mvm, IWL_MVM_REF_UCODE_DOWN);
 
-	iwl_trans_stop_device(mvm->trans);
+	iwl_mvm_stop_device(mvm);
 
 	mvm->scan_status = 0;
 	mvm->ps_disabled = false;
@@ -1141,7 +1141,7 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	 */
 	flush_work(&mvm->roc_done_wk);
 
-	iwl_trans_stop_device(mvm->trans);
+	iwl_mvm_stop_device(mvm);
 
 	iwl_mvm_async_handlers_purge(mvm);
 	/* async_handlers_list is empty and will stay empty: HW is stopped */
@@ -1172,8 +1172,6 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 				mvm->scan_uid_status[i] = 0;
 		}
 	}
-
-	mvm->ucode_loaded = false;
 }
 
 static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b461b90..6d4e487 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1549,6 +1549,12 @@ void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	iwl_mvm_enable_txq(mvm, queue, mac80211_queue, ssn, &cfg, wdg_timeout);
 }
 
+static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
+{
+	mvm->ucode_loaded = false;
+	iwl_trans_stop_device(mvm->trans);
+}
+
 /* Thermal management and CT-kill */
 void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
 void iwl_mvm_tt_temp_changed(struct iwl_mvm *mvm, u32 temp);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 8bdaa7b..4716176 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -643,7 +643,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
 		err = iwl_run_init_mvm_ucode(mvm, true);
 		if (!err || !iwlmvm_mod_params.init_dbg)
-			iwl_trans_stop_device(trans);
+			iwl_mvm_stop_device(mvm);
 		iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
 		mutex_unlock(&mvm->mutex);
 		/* returns 0 if successful, 1 if success but in rfkill */
-- 
2.5.0

