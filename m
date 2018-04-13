Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39488 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754735AbeDMMnu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:43:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:42 +0300
Message-Id: <20180413124256.21769-12-luca@coelho.fi> (sfid-20180413_144354_727034_5B8FE16B)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 11/25] iwlwifi: pcie: allocate shorter TX queues for 22000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When support for shorter TX queues was introduced, it
didn't include the actual allocation of shorter queue,
which is the main motive for the change.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index b605b364ed3f..734a5fc3584d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -993,7 +993,7 @@ static void iwl_pcie_gen2_txq_free_memory(struct iwl_trans *trans,
 	/* De-alloc circular buffer of TFDs */
 	if (txq->tfds) {
 		dma_free_coherent(dev,
-				  trans_pcie->tfd_size * TFD_QUEUE_SIZE_MAX,
+				  trans_pcie->tfd_size * txq->n_window,
 				  txq->tfds, txq->dma_addr);
 		dma_free_coherent(dev,
 				  sizeof(*txq->first_tb_bufs) * txq->n_window,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 86873b99e5d7..4493520aae1e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -495,6 +495,9 @@ int iwl_pcie_txq_alloc(struct iwl_trans *trans, struct iwl_txq *txq,
 	if (WARN_ON(txq->entries || txq->tfds))
 		return -EINVAL;
 
+	if (trans->cfg->use_tfh)
+		tfd_sz = trans_pcie->tfd_size * slots_num;
+
 	timer_setup(&txq->stuck_timer, iwl_pcie_txq_stuck_timer, 0);
 	txq->trans_pcie = trans_pcie;
 
-- 
2.16.3
