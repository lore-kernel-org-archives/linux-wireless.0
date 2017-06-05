Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59434 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751186AbdFEUny (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:43:54 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:09 +0300
Message-Id: <20170605204218.30151-17-luca@coelho.fi> (sfid-20170605_224358_550157_7FE900F9)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 16/25] iwlwifi: mvm: clear firmware running bit earlier
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clear the firmware running bit before flushing the FW (error) dump
work, because otherwise debugfs isn't blocked (previous patch) and
can cause a new work to be scheduled, which will then run after we
actually shut down the device, wreaking havoc. Clearing it ensures
that debugfs can't interfere anymore, and we can safely cancel or
flush the work struct.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9e0c0f0e5999..08f86e77eba5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1244,6 +1244,17 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	flush_work(&mvm->d0i3_exit_work);
 	flush_work(&mvm->async_handlers_wk);
 	flush_work(&mvm->add_stream_wk);
+
+	/*
+	 * Lock and clear the firmware running bit here already, so that
+	 * new commands coming in elsewhere, e.g. from debugfs, will not
+	 * be able to proceed. This is important here because one of those
+	 * debugfs files causes the fw_dump_wk to be triggered, and if we
+	 * don't stop debugfs accesses before canceling that it could be
+	 * retriggered after we flush it but before we've cleared the bit.
+	 */
+	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
+
 	cancel_delayed_work_sync(&mvm->fw_dump_wk);
 	cancel_delayed_work_sync(&mvm->cs_tx_unblock_dwork);
 	cancel_delayed_work_sync(&mvm->scan_timeout_dwork);
-- 
2.11.0
