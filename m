Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62925 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaGFJhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:11 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so3114946wgg.8
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:10 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/40] iwlwifi: mvm: Protect mvm->csa_vif with RCU
Date: Sun,  6 Jul 2014 12:36:08 +0300
Message-Id: <1404639376-3792-32-git-send-email-egrumbach@gmail.com> (sfid-20140706_115956_389764_44F9C2D1)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Currently mvm->csa_vif is protected with mvm mutex. The RCU protection
is required for "iwlwifi: mvm: Reflect GO channel switch in NoA" patch.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 15 +++++++++------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 12 ++++++++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 +-
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 6d09472..19bd696 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1206,6 +1206,7 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mvm_tx_resp *beacon_notify_hdr;
+	struct ieee80211_vif *csa_vif;
 	u64 tsf;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1231,13 +1232,15 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 		     mvm->ap_last_beacon_gp2,
 		     le32_to_cpu(beacon_notify_hdr->initial_rate));
 
-	if (unlikely(mvm->csa_vif && mvm->csa_vif->csa_active)) {
-		if (!ieee80211_csa_is_complete(mvm->csa_vif)) {
-			ieee80211_csa_update_counter(mvm->csa_vif);
-			iwl_mvm_mac_ctxt_beacon_changed(mvm, mvm->csa_vif);
+	csa_vif = rcu_dereference_protected(mvm->csa_vif,
+					    lockdep_is_held(&mvm->mutex));
+	if (unlikely(csa_vif && csa_vif->csa_active)) {
+		if (!ieee80211_csa_is_complete(csa_vif)) {
+			ieee80211_csa_update_counter(csa_vif);
+			iwl_mvm_mac_ctxt_beacon_changed(mvm, csa_vif);
 		} else {
-			ieee80211_csa_finish(mvm->csa_vif);
-			mvm->csa_vif = NULL;
+			ieee80211_csa_finish(csa_vif);
+			RCU_INIT_POINTER(mvm->csa_vif, NULL);
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 78a78c0..984a1e7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1607,6 +1607,10 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	/* Handle AP stop while in CSA */
+	if (rcu_access_pointer(mvm->csa_vif) == vif)
+		RCU_INIT_POINTER(mvm->csa_vif, NULL);
+
 	mvmvif->ap_ibss_active = false;
 	mvm->ap_last_beacon_gp2 = 0;
 
@@ -2664,15 +2668,19 @@ static void iwl_mvm_channel_switch_beacon(struct ieee80211_hw *hw,
 					  struct cfg80211_chan_def *chandef)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct ieee80211_vif *csa_vif;
 
 	mutex_lock(&mvm->mutex);
-	if (WARN(mvm->csa_vif && mvm->csa_vif->csa_active,
+
+	csa_vif = rcu_dereference_protected(mvm->csa_vif,
+					    lockdep_is_held(&mvm->mutex));
+	if (WARN(csa_vif && csa_vif->csa_active,
 		 "Another CSA is already in progress"))
 		goto out_unlock;
 
 	IWL_DEBUG_MAC80211(mvm, "CSA started to freq %d\n",
 			   chandef->center_freq1);
-	mvm->csa_vif = vif;
+	rcu_assign_pointer(mvm->csa_vif, vif);
 
 out_unlock:
 	mutex_unlock(&mvm->mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index fa8fcbc..5bb42af 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -658,7 +658,7 @@ struct iwl_mvm {
 	/* Indicate if device power save is allowed */
 	bool ps_disabled;
 
-	struct ieee80211_vif *csa_vif;
+	struct ieee80211_vif __rcu *csa_vif;
 
 	/* system time of last beacon (for AP/GO interface) */
 	u32 ap_last_beacon_gp2;
-- 
1.8.3.2

