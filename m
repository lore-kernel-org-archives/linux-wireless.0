Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab2BCAQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:58 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/28] iwlwifi: debug print in tx_queue_set_status is more clear
Date: Thu,  2 Feb 2012 15:09:14 -0800
Message-Id: <1328224159-18134-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011706_388806_5B2AEE1E)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The message was misleading when a queue is deactivated. The fifo
number is irrelevant then, so don't print it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 5e095ac..08e0a7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -431,9 +431,12 @@ void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 
 	txq->sched_retry = scd_retry;
 
-	IWL_DEBUG_TX_QUEUES(trans, "%s %s Queue %d on FIFO %d\n",
-		       active ? "Activate" : "Deactivate",
-		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
+	if (active)
+		IWL_DEBUG_TX_QUEUES(trans, "Activate %s Queue %d on FIFO %d\n",
+			scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
+	else
+		IWL_DEBUG_TX_QUEUES(trans, "Deactivate %s Queue %d\n",
+			scd_retry ? "BA" : "AC/CMD", txq_id);
 }
 
 static inline int get_fifo_from_tid(struct iwl_trans_pcie *trans_pcie,
-- 
1.7.0.4

