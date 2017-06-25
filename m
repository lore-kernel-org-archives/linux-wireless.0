Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34990 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751339AbdFYLM5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:44 +0300
Message-Id: <20170625111158.1792-13-luca@coelho.fi> (sfid-20170625_131303_591112_42A5C17F)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 12/26] iwlwifi: pcie: don't disable bh when handling FW errors
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

When we started using threaded irqs, all the opmode calls were changed
to be called with local_bh disabled.  The reason for this was it was
that mac80211 needs that.  When we are handling FW errors, mac80211 is
not involved, so we don't need it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 6eef2e789426..fa5f39f72d22 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1413,11 +1413,9 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 		return;
 	}
 
-	local_bh_disable();
 	/* The STATUS_FW_ERROR bit is set in this function. This must happen
 	 * before we wake up the command caller, to ensure a proper cleanup. */
 	iwl_trans_fw_error(trans);
-	local_bh_enable();
 
 	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
 		if (!trans_pcie->txq[i])
-- 
2.11.0
