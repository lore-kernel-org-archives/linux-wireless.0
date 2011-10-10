Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31149 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1JJPQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/34] iwlagn: fix a race in the unmapping of the TFDs
Date: Mon, 10 Oct 2011 07:27:02 -0700
Message-Id: <1318256839-31837-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171720_712719_8EB13AAC)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

While inspecting the code, I saw that iwl_tx_queue_unmap modifies
the read pointer of the Tx queue without taking any locks. This means
that it can race with the reclaim flow. This can possibly lead to
a DMA warning complaining that we unmap the same buffer twice.

This is more a W/A than a fix since it is really weird to take
sta_lock inside iwl_tx_queue_unmap, but it can help until we revamp
the locking model in the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 60067c7..f69aecb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -406,6 +406,7 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	enum dma_data_direction dma_dir;
+	unsigned long flags;
 
 	if (!q->n_bd)
 		return;
@@ -418,12 +419,14 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 	else
 		dma_dir = DMA_TO_DEVICE;
 
+	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
 	while (q->write_ptr != q->read_ptr) {
 		/* The read_ptr needs to bound by q->n_window */
 		iwlagn_txq_free_tfd(trans, txq, get_cmd_index(q, q->read_ptr),
 				    dma_dir);
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
+	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
 }
 
 /**
-- 
1.7.0.4

