Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:49708 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729AbaJ2LvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:11 -0400
Received: by mail-wg0-f50.google.com with SMTP id z12so1656488wgg.23
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:09 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/25] iwlwifi: mvm: change the iwl_mvm_d3_iface_iterator into a generic function
Date: Wed, 29 Oct 2014 13:50:29 +0200
Message-Id: <1414583446-11032-8-git-send-email-egrumbach@gmail.com> (sfid-20141029_125122_485392_82D099CD)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Getting the BSS station vif is something that may be needed by other
parts of the code.  So, instead of having an iterator specifically for
d3, change it into a generic one in utils.c.  Additionally, add a
iwl_mvm_get_bss_vif() function to make it easier to retrieving it.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c    | 47 +++-----------------------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h   |  2 ++
 drivers/net/wireless/iwlwifi/mvm/utils.c | 37 +++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 0b3295e..3bbb511 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -601,29 +601,6 @@ static int iwl_mvm_send_remote_wake_cfg(struct iwl_mvm *mvm,
 	return ret;
 }
 
-struct iwl_d3_iter_data {
-	struct iwl_mvm *mvm;
-	struct ieee80211_vif *vif;
-	bool error;
-};
-
-static void iwl_mvm_d3_iface_iterator(void *_data, u8 *mac,
-				      struct ieee80211_vif *vif)
-{
-	struct iwl_d3_iter_data *data = _data;
-
-	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
-		return;
-
-	if (data->vif) {
-		IWL_ERR(data->mvm, "More than one managed interface active!\n");
-		data->error = true;
-		return;
-	}
-
-	data->vif = vif;
-}
-
 static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				struct ieee80211_sta *ap_sta)
 {
@@ -990,9 +967,6 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 			     bool test)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	struct iwl_d3_iter_data suspend_iter_data = {
-		.mvm = mvm,
-	};
 	struct ieee80211_vif *vif = NULL;
 	struct iwl_mvm_vif *mvmvif = NULL;
 	struct ieee80211_sta *ap_sta = NULL;
@@ -1025,17 +999,12 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	/* see if there's only a single BSS vif */
-	ieee80211_iterate_active_interfaces_atomic(
-		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-		iwl_mvm_d3_iface_iterator, &suspend_iter_data);
-
-	if (suspend_iter_data.error || !suspend_iter_data.vif) {
+	vif = iwl_mvm_get_bss_vif(mvm);
+	if (IS_ERR_OR_NULL(vif)) {
 		ret = 1;
 		goto out_noreset;
 	}
 
-	vif = suspend_iter_data.vif;
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	/* if we're associated, this is wowlan */
@@ -1639,9 +1608,6 @@ static void iwl_mvm_d3_disconnect_iter(void *data, u8 *mac,
 
 static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 {
-	struct iwl_d3_iter_data resume_iter_data = {
-		.mvm = mvm,
-	};
 	struct ieee80211_vif *vif = NULL;
 	int ret;
 	enum iwl_d3_status d3_status;
@@ -1650,15 +1616,10 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	mutex_lock(&mvm->mutex);
 
 	/* get the BSS vif pointer again */
-	ieee80211_iterate_active_interfaces_atomic(
-		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-		iwl_mvm_d3_iface_iterator, &resume_iter_data);
-
-	if (WARN_ON(resume_iter_data.error || !resume_iter_data.vif))
+	vif = iwl_mvm_get_bss_vif(mvm);
+	if (IS_ERR_OR_NULL(vif))
 		goto out_unlock;
 
-	vif = resume_iter_data.vif;
-
 	ret = iwl_trans_d3_resume(mvm->trans, &d3_status, test);
 	if (ret)
 		goto out_unlock;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 60aee62..aec9f57 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1214,6 +1214,8 @@ void iwl_mvm_recalc_tdls_state(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 void iwl_mvm_mac_mgd_protect_tdls_discover(struct ieee80211_hw *hw,
 					   struct ieee80211_vif *vif);
 
+struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm);
+
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 8021f6e..e56e77e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -734,3 +734,40 @@ bool iwl_mvm_is_idle(struct iwl_mvm *mvm)
 
 	return idle;
 }
+
+struct iwl_bss_iter_data {
+	struct ieee80211_vif *vif;
+	bool error;
+};
+
+static void iwl_mvm_bss_iface_iterator(void *_data, u8 *mac,
+				       struct ieee80211_vif *vif)
+{
+	struct iwl_bss_iter_data *data = _data;
+
+	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
+		return;
+
+	if (data->vif) {
+		data->error = true;
+		return;
+	}
+
+	data->vif = vif;
+}
+
+struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm)
+{
+	struct iwl_bss_iter_data bss_iter_data = {};
+
+	ieee80211_iterate_active_interfaces_atomic(
+		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+		iwl_mvm_bss_iface_iterator, &bss_iter_data);
+
+	if (bss_iter_data.error) {
+		IWL_ERR(mvm, "More than one managed interface active!\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	return bss_iter_data.vif;
+}
-- 
1.9.1

