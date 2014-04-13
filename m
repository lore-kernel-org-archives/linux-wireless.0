Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44328 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaDMTU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:26 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so7420809wgh.22
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:25 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/47] iwlwifi: pcie: fix TX queue locking
Date: Sun, 13 Apr 2014 22:19:25 +0300
Message-Id: <1397416802-32403-10-git-send-email-egrumbach@gmail.com> (sfid-20140413_212035_686086_83D815E7)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When updating the write pointer, the TX queue should be locked
to get consistent state, fix that in the interrupt handler.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 57e98cc..152c763 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1042,8 +1042,11 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR(trans, "Wakeup interrupt\n");
 		iwl_pcie_rxq_check_wrptr(trans);
-		for (i = 0; i < trans->cfg->base_params->num_of_queues; i++)
+		for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
+			spin_lock(&trans_pcie->txq[i].lock);
 			iwl_pcie_txq_inc_wr_ptr(trans, &trans_pcie->txq[i]);
+			spin_unlock(&trans_pcie->txq[i].lock);
+		}
 
 		isr_stats->wakeup++;
 
-- 
1.8.3.2

