Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab1KRBA3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 20:00:29 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/5] iwlwifi: tid_data is taken twice in iwl_trans_pcie_tx_agg_alloc
Date: Thu, 17 Nov 2011 16:05:12 -0800
Message-Id: <1321574713-12076-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111118_020041_428936_0649128D)
In-Reply-To: <1321574713-12076-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1321574713-12076-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Remove this redundancy.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index b93acce..79331fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -559,7 +559,6 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 	tid_data->agg.txq_id = txq_id;
 	iwl_set_swq_id(&trans_pcie->txq[txq_id], get_ac_from_tid(tid), txq_id);
 
-	tid_data = &trans->shrd->tid_data[sta_id][tid];
 	if (tid_data->tfds_in_queue == 0) {
 		IWL_DEBUG_TX_QUEUES(trans, "HW queue is empty\n");
 		tid_data->agg.state = IWL_AGG_ON;
-- 
1.7.0.4

