Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:21407 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbcC3OGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:19 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/43] iwlwifi: pcie: request one more interrupt vector
Date: Wed, 30 Mar 2016 17:05:01 +0300
Message-Id: <1459346715-7954-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160718_564104_E6A50A4D)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We want to request an interrupt vector for RSS queue per CPU,
one vector for fallback queue, and one for non-rx interrupts.
Future patch will make sure that no RSS traffic is directed to
fallback queue.
This will enable us to enable fast path on traffic that otherwise
would have been received on the fallback queue.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 0c40209..f1a506b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1435,7 +1435,7 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 	int ret, i;
 
 	if (trans->cfg->mq_rx_supported) {
-		max_vector = min_t(u32, (num_possible_cpus() + 1),
+		max_vector = min_t(u32, (num_possible_cpus() + 2),
 				   IWL_MAX_RX_HW_QUEUES);
 		for (i = 0; i < max_vector; i++)
 			trans_pcie->msix_entries[i].entry = i;
-- 
2.5.0

