Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:31955 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbcC3OGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:34 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Colin Ian King <colin.king@canonical.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 43/43] iwlwifi: pcie: remove duplicate assignment of variable isr_stats
Date: Wed, 30 Mar 2016 17:05:15 +0300
Message-Id: <1459346715-7954-43-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_161040_317960_C9D13182)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

isr_stats is written twice with the same value, remove one of the
redundant assignments to isr_stats.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 59a7e45..7f8a232 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1811,7 +1811,7 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 	struct msix_entry *entry = dev_id;
 	struct iwl_trans_pcie *trans_pcie = iwl_pcie_get_trans_pcie(entry);
 	struct iwl_trans *trans = trans_pcie->trans;
-	struct isr_statistics *isr_stats = isr_stats = &trans_pcie->isr_stats;
+	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
 	u32 inta_fh, inta_hw;
 
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
-- 
2.5.0

