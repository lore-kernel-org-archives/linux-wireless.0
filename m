Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49422 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752122AbdIHJNK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:13:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Sep 2017 12:12:48 +0300
Message-Id: <20170908091256.25279-3-luca@coelho.fi> (sfid-20170908_111314_796849_643E9456)
In-Reply-To: <20170908091256.25279-1-luca@coelho.fi>
References: <20170908091256.25279-1-luca@coelho.fi>
Subject: [PATCH 02/10] iwlwifi: mvm: Flush non STA TX queues
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

When starting wowlan mac80211 requests flush w/o vif
and we ignore this request. As a result some packets
stay stuck in the queue and it may end up with a queue
hang.

Allow the driver to flush queues even if station isn't
specified.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 44 ++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 15f2d826bb4b..64b0be73ea72 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3975,6 +3975,43 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static void iwl_mvm_flush_no_vif(struct iwl_mvm *mvm, u32 queues, bool drop)
+{
+	if (drop) {
+		if (iwl_mvm_has_new_tx_api(mvm))
+			/* TODO new tx api */
+			WARN_ONCE(1,
+				  "Need to implement flush TX queue\n");
+		else
+			iwl_mvm_flush_tx_path(mvm,
+				iwl_mvm_flushable_queues(mvm) & queues,
+				0);
+	} else {
+		if (iwl_mvm_has_new_tx_api(mvm)) {
+			struct ieee80211_sta *sta;
+			int i;
+
+			mutex_lock(&mvm->mutex);
+
+			for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
+				sta = rcu_dereference_protected(
+						mvm->fw_id_to_mac_id[i],
+						lockdep_is_held(&mvm->mutex));
+				if (IS_ERR_OR_NULL(sta))
+					continue;
+
+				iwl_mvm_wait_sta_queues_empty(mvm,
+						iwl_mvm_sta_from_mac80211(sta));
+			}
+
+			mutex_unlock(&mvm->mutex);
+		} else {
+			iwl_trans_wait_tx_queues_empty(mvm->trans,
+						       queues);
+		}
+	}
+}
+
 static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, u32 queues, bool drop)
 {
@@ -3985,7 +4022,12 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 	int i;
 	u32 msk = 0;
 
-	if (!vif || vif->type != NL80211_IFTYPE_STATION)
+	if (!vif) {
+		iwl_mvm_flush_no_vif(mvm, queues, drop);
+		return;
+	}
+
+	if (vif->type != NL80211_IFTYPE_STATION)
 		return;
 
 	/* Make sure we're done with the deferred traffic before flushing */
-- 
2.14.1
