Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbcC1Ldu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2016 07:33:50 -0400
From: Colin King <colin.king@canonical.com>
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sara Sharon <sara.sharon@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: pcie: remove duplicate assignment of variable isr_stats
Date: Mon, 28 Mar 2016 12:33:44 +0100
Message-Id: <1459164824-6994-1-git-send-email-colin.king@canonical.com> (sfid-20160328_133412_531155_1264C29F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

isr_stats is written twice with the same value, remove one of the
redundant assignments to isr_stats.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 4be3c35..253e4f0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1805,7 +1805,7 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 	struct msix_entry *entry = dev_id;
 	struct iwl_trans_pcie *trans_pcie = iwl_pcie_get_trans_pcie(entry);
 	struct iwl_trans *trans = trans_pcie->trans;
-	struct isr_statistics *isr_stats = isr_stats = &trans_pcie->isr_stats;
+	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
 	u32 inta_fh, inta_hw;
 
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
-- 
2.7.4

