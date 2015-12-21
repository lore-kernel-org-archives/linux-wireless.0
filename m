Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbbLUUuy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:50:54 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/45] iwlwifi: mvm: don't keep an mvm ref when the interface is down
Date: Mon, 21 Dec 2015 22:50:02 +0200
Message-Id: <1450731046-2796-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215103_447714_CEB11A05)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

There is no reason to keep a reference when the interface is down,
since we are not really doing anything.  The reference is only needed
when the mac80211 start op (or a hw restart) is running, to prevent
going into runtime or system supend in the meantime.  This will allow
us to support runtime PM when the interface is down (in another
patch).

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 22 +++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index a90f1ee..518a1d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1004,10 +1004,18 @@ int __iwl_mvm_mac_start(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* Clean up some internal and mac80211 state on restart */
-	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
+	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+		/* Clean up some internal and mac80211 state on restart */
 		iwl_mvm_restart_cleanup(mvm);
-
+	} else {
+		/* Hold the reference to prevent runtime suspend while
+		 * the start procedure runs.  It's a bit confusing
+		 * that the UCODE_DOWN reference is taken, but it just
+		 * means "UCODE is not UP yet". ( TODO: rename this
+		 * reference).
+		 */
+		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
+	}
 	ret = iwl_mvm_up(mvm);
 
 	if (ret && test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
@@ -1110,14 +1118,6 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	 */
 	memset(&mvm->accu_radio_stats, 0, sizeof(mvm->accu_radio_stats));
 
-	/*
-	 * Disallow low power states when the FW is down by taking
-	 * the UCODE_DOWN ref. in case of ongoing hw restart the
-	 * ref is already taken, so don't take it again.
-	 */
-	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
-		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
-
 	/* async_handlers_wk is now blocked */
 
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 3b0d597f..b71c85b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -607,8 +607,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	memset(&mvm->rx_stats, 0, sizeof(struct mvm_statistics_rx));
 
-	/* rpm starts with a taken ref. only set the appropriate bit here. */
-	mvm->refs[IWL_MVM_REF_UCODE_DOWN] = 1;
+	/* rpm starts with a taken reference, we can release it now */
+	iwl_trans_unref(mvm->trans);
 
 	iwl_mvm_tof_init(mvm);
 
-- 
2.5.0

