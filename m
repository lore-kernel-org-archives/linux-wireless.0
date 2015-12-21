Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbbLUUw3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/45] iwlwifi: mvm: Add a station in monitor mode
Date: Mon, 21 Dec 2015 22:50:36 +0200
Message-Id: <1450731046-2796-35-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220059_835164_45858A6C)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

Currently when creating a new vif in monitor mode the driver doesn't
allocate a specific station. This causes that in the situation that
tx traffic is injected, the tx queues are not scheduled,
with the result of a TFD queue hang.
Fix that by allocating a station and ensuring its tx queues
are scheduled.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=104591

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 16 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  6 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 33 ++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |  6 +++++
 5 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index d00a6e9..5e3a758 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -855,11 +855,17 @@ static int iwl_mvm_mac_ctxt_cmd_listener(struct iwl_mvm *mvm,
 					 u32 action)
 {
 	struct iwl_mac_ctx_cmd cmd = {};
+	u32 tfd_queue_msk = 0;
+	int ret, i;
 
 	WARN_ON(vif->type != NL80211_IFTYPE_MONITOR);
 
 	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
+	for (i = 0; i < IEEE80211_NUM_ACS; i++)
+		if (vif->hw_queue[i] != IEEE80211_INVAL_HW_QUEUE)
+			tfd_queue_msk |= BIT(vif->hw_queue[i]);
+
 	cmd.filter_flags = cpu_to_le32(MAC_FILTER_IN_PROMISC |
 				       MAC_FILTER_IN_CONTROL_AND_MGMT |
 				       MAC_FILTER_IN_BEACON |
@@ -867,6 +873,12 @@ static int iwl_mvm_mac_ctxt_cmd_listener(struct iwl_mvm *mvm,
 				       MAC_FILTER_IN_CRC32);
 	ieee80211_hw_set(mvm->hw, RX_INCLUDES_FCS);
 
+	/* Allocate sniffer station */
+	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->snif_sta, tfd_queue_msk,
+				       vif->type);
+	if (ret)
+		return ret;
+
 	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
 }
 
@@ -1289,8 +1301,10 @@ int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	mvmvif->uploaded = false;
 
-	if (vif->type == NL80211_IFTYPE_MONITOR)
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		__clear_bit(IEEE80211_HW_RX_INCLUDES_FCS, mvm->hw->flags);
+		iwl_mvm_dealloc_snif_sta(mvm);
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index be5703c..53415dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3126,6 +3126,11 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 		ret = iwl_mvm_update_quotas(mvm, false, NULL);
 		if (ret)
 			goto out_remove_binding;
+
+		ret = iwl_mvm_add_snif_sta(mvm, vif);
+		if (ret)
+			goto out_remove_binding;
+
 	}
 
 	/* Handle binding during CSA */
@@ -3199,6 +3204,7 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 	case NL80211_IFTYPE_MONITOR:
 		mvmvif->monitor_active = false;
 		mvmvif->ps_disabled = false;
+		iwl_mvm_rm_snif_sta(mvm, vif);
 		break;
 	case NL80211_IFTYPE_AP:
 		/* This part is triggered only during CSA */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ce9f579..df68973 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -677,6 +677,7 @@ struct iwl_mvm {
 
 	/* Internal station */
 	struct iwl_mvm_int_sta aux_sta;
+	struct iwl_mvm_int_sta snif_sta;
 
 	bool last_ebs_successful;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 92edacc..bfa4699 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -581,9 +581,9 @@ int iwl_mvm_rm_sta_id(struct iwl_mvm *mvm,
 	return ret;
 }
 
-static int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
-				    struct iwl_mvm_int_sta *sta,
-				    u32 qmask, enum nl80211_iftype iftype)
+int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
+			     struct iwl_mvm_int_sta *sta,
+			     u32 qmask, enum nl80211_iftype iftype)
 {
 	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		sta->sta_id = iwl_mvm_find_free_sta_id(mvm, iftype);
@@ -673,6 +673,33 @@ int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
 	return ret;
 }
 
+int iwl_mvm_add_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	lockdep_assert_held(&mvm->mutex);
+	return iwl_mvm_add_int_sta_common(mvm, &mvm->snif_sta, vif->addr,
+					 mvmvif->id, 0);
+}
+
+int iwl_mvm_rm_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	ret = iwl_mvm_rm_sta_common(mvm, mvm->snif_sta.sta_id);
+	if (ret)
+		IWL_WARN(mvm, "Failed sending remove station\n");
+
+	return ret;
+}
+
+void iwl_mvm_dealloc_snif_sta(struct iwl_mvm *mvm)
+{
+	iwl_mvm_dealloc_int_sta(mvm, &mvm->snif_sta);
+}
+
 void iwl_mvm_del_aux_sta(struct iwl_mvm *mvm)
 {
 	lockdep_assert_held(&mvm->mutex);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 973f2ed..badf17c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -407,7 +407,13 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_send_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
+			     struct iwl_mvm_int_sta *sta,
+				    u32 qmask, enum nl80211_iftype iftype);
 void iwl_mvm_dealloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_add_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_rm_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+void iwl_mvm_dealloc_snif_sta(struct iwl_mvm *mvm);
 
 void iwl_mvm_sta_drained_wk(struct work_struct *wk);
 void iwl_mvm_sta_modify_ps_wake(struct iwl_mvm *mvm,
-- 
2.5.0

