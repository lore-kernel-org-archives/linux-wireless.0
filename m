Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61158 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbaJ2L6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:58:24 -0400
Received: by mail-wg0-f43.google.com with SMTP id n12so1666634wgh.30
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:58:23 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/25] iwlwifi: mvm: remove mvm argument from get_queues_mask
Date: Wed, 29 Oct 2014 13:50:36 +0200
Message-Id: <1414583446-11032-15-git-send-email-egrumbach@gmail.com> (sfid-20141029_125832_955075_B6BD1BD5)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

It is unused and won't be available in some future invocations of the
function.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 5 ++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 3 +--
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 0c5c0b0..b8ab4a1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -197,8 +197,7 @@ static void iwl_mvm_mac_tsf_id_iter(void *_data, u8 *mac,
 /*
  * Get the mask of the queues used by the vif
  */
-u32 iwl_mvm_mac_get_queues_mask(struct iwl_mvm *mvm,
-				struct ieee80211_vif *vif)
+u32 iwl_mvm_mac_get_queues_mask(struct ieee80211_vif *vif)
 {
 	u32 qmask = 0, ac;
 
@@ -227,7 +226,7 @@ static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
 	}
 
 	/* Mark the queues used by the vif */
-	data->used_hw_queues |= iwl_mvm_mac_get_queues_mask(data->mvm, vif);
+	data->used_hw_queues |= iwl_mvm_mac_get_queues_mask(vif);
 
 	/* Mark MAC IDs as used by clearing the available bit, and
 	 * (below) mark TSFs as used if their existing use is not
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 9fc843e..c087bf6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1086,7 +1086,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 static void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif)
 {
-	u32 tfd_msk = iwl_mvm_mac_get_queues_mask(mvm, vif);
+	u32 tfd_msk = iwl_mvm_mac_get_queues_mask(vif);
 
 	if (tfd_msk) {
 		mutex_lock(&mvm->mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index aec9f57..d14dc06 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -909,8 +909,7 @@ int iwl_mvm_mac_ctxt_add(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_mac_ctxt_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     bool force_assoc_off, const u8 *bssid_override);
 int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-u32 iwl_mvm_mac_get_queues_mask(struct iwl_mvm *mvm,
-				struct ieee80211_vif *vif);
+u32 iwl_mvm_mac_get_queues_mask(struct ieee80211_vif *vif);
 int iwl_mvm_mac_ctxt_beacon_changed(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif);
 int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 1731c20..dd0dc5b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -609,7 +609,7 @@ int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	qmask = iwl_mvm_mac_get_queues_mask(mvm, vif);
+	qmask = iwl_mvm_mac_get_queues_mask(vif);
 
 	/*
 	 * The firmware defines the TFD queue mask to only be relevant
-- 
1.9.1

