Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34964 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751339AbdFYLMr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:55 +0300
Message-Id: <20170625111158.1792-24-luca@coelho.fi> (sfid-20170625_131302_971609_50458E67)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 23/26] iwlwifi: pcie: delete the Tx queue timer earlier upon firmware crash
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When the firmware crashes, the transmit queues can't make
any progress. This is why we stop the counter that monitor
the transmit queues' activity.
The call that notifies the error to the op_mode may take
a bit of time, so stop the timer of the transmit queues
earlier.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index fa5f39f72d22..a5c0f69423d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1413,16 +1413,16 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 		return;
 	}
 
-	/* The STATUS_FW_ERROR bit is set in this function. This must happen
-	 * before we wake up the command caller, to ensure a proper cleanup. */
-	iwl_trans_fw_error(trans);
-
 	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
 		if (!trans_pcie->txq[i])
 			continue;
 		del_timer(&trans_pcie->txq[i]->stuck_timer);
 	}
 
+	/* The STATUS_FW_ERROR bit is set in this function. This must happen
+	 * before we wake up the command caller, to ensure a proper cleanup. */
+	iwl_trans_fw_error(trans);
+
 	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 	wake_up(&trans_pcie->wait_command_queue);
 }
-- 
2.11.0
