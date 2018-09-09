Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47960 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726609AbeIIO0N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:45 +0300
Message-Id: <20180909093656.10194-6-luca@coelho.fi> (sfid-20180909_113712_347694_F837091F)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 05/16] iwlwifi: pcie: fit reclaim msg to MAX_MSG_LEN
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Today, the length of a debug message in iwl_trans_pcie_reclaim
may pass the MAX_MSG_LEN, which is 110.
An example for this kind of message is:

'iwl_trans_pcie_reclaim: Read index for DMA queue txq id (2),
last_to_free 65535 is out of range [0-65536] 2 2.'

Cut the message a bit so it will fit the allowed MAX_MSG_LEN.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 14b6e726da46..6b6b86458819 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1097,7 +1097,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	if (!iwl_queue_used(txq, last_to_free)) {
 		IWL_ERR(trans,
-			"%s: Read index for DMA queue txq id (%d), last_to_free %d is out of range [0-%d] %d %d.\n",
+			"%s: Read index for txq id (%d), last_to_free %d is out of range [0-%d] %d %d.\n",
 			__func__, txq_id, last_to_free,
 			trans->cfg->base_params->max_tfd_queue_size,
 			txq->write_ptr, txq->read_ptr);
-- 
2.18.0
