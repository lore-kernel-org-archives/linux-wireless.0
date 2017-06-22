Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34370 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753800AbdFVVV7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:59 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:55 +0300
Message-Id: <20170622212101.16422-20-luca@coelho.fi> (sfid-20170622_232203_503256_C8761ADD)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 19/25] iwlwifi: mvm: don't warn in queue sync on RF-kill
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If we happen to be in or get into the queue sync when RF-kill
is asserted, we return from there and warn since there are
still queue sync notifications outstanding. These can't ever
come though, because we're in RF-kill, so don't WARN then.

While at it, also move the warning to the appropriate place,
if the request is not synchronous then we shouldn't warn, but
currently always will.

To make it fast, also trigger the waitq when on rfkill assert.

Fixes: 0636b938214c ("iwlwifi: mvm: implement driver RX queues sync command")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  8 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 14 ++++++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 75ec567ab9e2..2449be6f95a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4277,11 +4277,13 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 		goto out;
 	}
 
-	if (notif->sync)
+	if (notif->sync) {
 		ret = wait_event_timeout(mvm->rx_sync_waitq,
-					 atomic_read(&mvm->queue_sync_counter) == 0,
+					 atomic_read(&mvm->queue_sync_counter) == 0 ||
+					 iwl_mvm_is_radio_killed(mvm),
 					 HZ);
-	WARN_ON_ONCE(!ret);
+		WARN_ON_ONCE(!ret && !iwl_mvm_is_radio_killed(mvm));
+	}
 
 out:
 	atomic_set(&mvm->queue_sync_counter, 0);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index c9686e31b32e..30fc756b5b01 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1094,6 +1094,16 @@ static void iwl_mvm_wake_sw_queue(struct iwl_op_mode *op_mode, int hw_queue)
 	iwl_mvm_start_mac_queues(mvm, mq);
 }
 
+static void iwl_mvm_set_rfkill_state(struct iwl_mvm *mvm)
+{
+	bool state = iwl_mvm_is_radio_killed(mvm);
+
+	if (state)
+		wake_up(&mvm->rx_sync_waitq);
+
+	wiphy_rfkill_set_hw_state(mvm->hw->wiphy, state);
+}
+
 void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state)
 {
 	if (state)
@@ -1101,7 +1111,7 @@ void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state)
 	else
 		clear_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status);
 
-	wiphy_rfkill_set_hw_state(mvm->hw->wiphy, iwl_mvm_is_radio_killed(mvm));
+	iwl_mvm_set_rfkill_state(mvm);
 }
 
 static bool iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
@@ -1114,7 +1124,7 @@ static bool iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 	else
 		clear_bit(IWL_MVM_STATUS_HW_RFKILL, &mvm->status);
 
-	wiphy_rfkill_set_hw_state(mvm->hw->wiphy, iwl_mvm_is_radio_killed(mvm));
+	iwl_mvm_set_rfkill_state(mvm);
 
 	/* iwl_run_init_mvm_ucode is waiting for results, abort it */
 	if (calibrating)
-- 
2.11.0
