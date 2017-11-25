Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47530 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751383AbdKYQfJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 11:35:09 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 18:34:43 +0200
Message-Id: <20171125163444.24258-11-luca@coelho.fi> (sfid-20171125_173520_508329_5EC5F645)
In-Reply-To: <20171125163444.24258-1-luca@coelho.fi>
References: <20171125163444.24258-1-luca@coelho.fi>
Subject: [PATCH 10/11] iwlwifi: mvm: remove superfluous flush_work()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since iwl_mvm_start_p2p_roc() is only called from iwl_mvm_roc(),
which already flushes the same work item, doing it again in it
is superfluous. Remove it and move the comment to the first one.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   | 4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 6 ------
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 149d301e5e98..e0226d2315bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3192,6 +3192,10 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(mvm, "enter (%d, %d, %d)\n", channel->hw_value,
 			   duration, type);
 
+	/*
+	 * Flush the done work, just in case it's still pending, so that
+	 * the work it does can complete and we can accept new frames.
+	 */
 	flush_work(&mvm->roc_done_wk);
 
 	mutex_lock(&mvm->mutex);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 4d0314912e94..d3b8cb1e20b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -759,12 +759,6 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return -EBUSY;
 	}
 
-	/*
-	 * Flush the done work, just in case it's still pending, so that
-	 * the work it does can complete and we can accept new frames.
-	 */
-	flush_work(&mvm->roc_done_wk);
-
 	time_cmd.action = cpu_to_le32(FW_CTXT_ACTION_ADD);
 	time_cmd.id_and_color =
 		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color));
-- 
2.15.0
