Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33312 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaBCU7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:22 -0500
Received: by mail-ee0-f52.google.com with SMTP id e53so3845310eek.25
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:21 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 40/62] iwlwifi: mvm: allow transport sleep when FW is operational
Date: Mon,  3 Feb 2014 22:57:46 +0200
Message-Id: <1391461088-8082-40-git-send-email-egrumbach@gmail.com> (sfid-20140203_220006_559918_77B8C44B)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Hold a bitmap of taken references, according to the
reference reason (e.g. down, scan).

This will allow us validate our state and add some debugfs
entries later on.

Unref the transport when the FW is fully initialized,
allowing it to go into a low power mode.

Disallow the transition to low-power while recovery is in
progress.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c       |    4 +++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   49 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   13 +++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c      |    6 ++++
 4 files changed, 72 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 5798f1a..212ffec 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -446,6 +446,10 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		goto error;
 
+	/* allow FW/transport low power modes if not during restart */
+	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
+		iwl_mvm_unref(mvm, IWL_MVM_REF_UCODE_DOWN);
+
 	IWL_DEBUG_INFO(mvm, "RT uCode started.\n");
 	return 0;
  error:
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index de38deb..e121685 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -202,6 +202,44 @@ static const struct iwl_fw_bcast_filter iwl_mvm_default_bcast_filters[] = {
 };
 #endif
 
+void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
+{
+	if (!mvm->trans->cfg->d0i3)
+		return;
+
+	IWL_DEBUG_RPM(mvm, "Take mvm reference - type %d\n", ref_type);
+	WARN_ON(test_and_set_bit(ref_type, mvm->ref_bitmap));
+	iwl_trans_ref(mvm->trans);
+}
+
+void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
+{
+	if (!mvm->trans->cfg->d0i3)
+		return;
+
+	IWL_DEBUG_RPM(mvm, "Leave mvm reference - type %d\n", ref_type);
+	WARN_ON(!test_and_clear_bit(ref_type, mvm->ref_bitmap));
+	iwl_trans_unref(mvm->trans);
+}
+
+static void
+iwl_mvm_unref_all_except(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref)
+{
+	int i;
+
+	if (!mvm->trans->cfg->d0i3)
+		return;
+
+	for_each_set_bit(i, mvm->ref_bitmap, IWL_MVM_REF_COUNT) {
+		if (ref == i)
+			continue;
+
+		IWL_DEBUG_RPM(mvm, "Cleanup: remove mvm ref type %d\n", i);
+		clear_bit(i, mvm->ref_bitmap);
+		iwl_trans_unref(mvm->trans);
+	}
+}
+
 static void iwl_mvm_reset_phy_ctxts(struct iwl_mvm *mvm)
 {
 	int i;
@@ -516,6 +554,10 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 
 	ieee80211_wake_queues(mvm->hw);
 
+	/* cleanup all stale references (scan, roc), but keep the
+	 * ucode_down ref until reconfig is complete */
+	iwl_mvm_unref_all_except(mvm, IWL_MVM_REF_UCODE_DOWN);
+
 	mvm->vif_count = 0;
 	mvm->rx_ba_sessions = 0;
 }
@@ -550,6 +592,9 @@ static void iwl_mvm_mac_restart_complete(struct ieee80211_hw *hw)
 		IWL_ERR(mvm, "Failed to update quotas after restart (%d)\n",
 			ret);
 
+	/* allow transport/FW low power modes */
+	iwl_mvm_unref(mvm, IWL_MVM_REF_UCODE_DOWN);
+
 	mutex_unlock(&mvm->mutex);
 }
 
@@ -560,6 +605,10 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	flush_work(&mvm->async_handlers_wk);
 
 	mutex_lock(&mvm->mutex);
+
+	/* disallow low power states when the FW is down */
+	iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
+
 	/* async_handlers_wk is now blocked */
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 0a8c65b..9ffafe8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -239,6 +239,12 @@ enum iwl_mvm_smps_type_request {
 	NUM_IWL_MVM_SMPS_REQ,
 };
 
+enum iwl_mvm_ref_type {
+	IWL_MVM_REF_UCODE_DOWN,
+
+	IWL_MVM_REF_COUNT,
+};
+
 /**
 * struct iwl_mvm_vif_bf_data - beacon filtering related data
 * @bf_enabled: indicates if beacon filtering is enabled
@@ -542,6 +548,9 @@ struct iwl_mvm {
 	 */
 	unsigned long fw_key_table[BITS_TO_LONGS(STA_KEY_MAX_NUM)];
 
+	/* A bitmap of reference types taken by the driver. */
+	unsigned long ref_bitmap[BITS_TO_LONGS(IWL_MVM_REF_COUNT)];
+
 	u8 vif_count;
 
 	/* -1 for always, 0 for never, >0 for that many times */
@@ -877,6 +886,10 @@ iwl_mvm_set_last_nonqos_seq(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 }
 #endif
 
+/* D0i3 */
+void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
+void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
+
 /* BT Coex */
 int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm);
 int iwl_send_bt_init_conf(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index cdb4c92..5bc4439 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -501,6 +501,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	memset(&mvm->rx_stats, 0, sizeof(struct mvm_statistics_rx));
 
+	/* rpm starts with a taken ref. only set the appropriate bit here. */
+	set_bit(IWL_MVM_REF_UCODE_DOWN, mvm->ref_bitmap);
+
 	return op_mode;
 
  out_unregister:
@@ -788,6 +791,9 @@ static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
 		schedule_work(&reprobe->work);
 	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR && mvm->restart_fw) {
+		/* don't let the transport/FW power down */
+		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
+
 		if (mvm->restart_fw > 0)
 			mvm->restart_fw--;
 		ieee80211_restart_hw(mvm->hw);
-- 
1.7.9.5

