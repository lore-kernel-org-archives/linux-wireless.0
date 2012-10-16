Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43732 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab2JPSPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:15:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/8] iwlwifi: use the new macro for the SCD Q STTS bits
Date: Tue, 16 Oct 2012 20:16:17 +0200
Message-Id: <1350411380-2391-6-git-send-email-johannes@sipsolutions.net> (sfid-20121016_201553_488522_50D5862C)
In-Reply-To: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
References: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Instead of hardcoding the expression, use the macro
provided in the previous patch.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 6c383df..f95d88d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -300,7 +300,7 @@ static void iwl_trans_pcie_queue_stuck_timer(unsigned long data)
 	struct iwl_trans_pcie *trans_pcie = txq->trans_pcie;
 	struct iwl_trans *trans = iwl_trans_pcie_get_trans(trans_pcie);
 	u32 scd_sram_addr = trans_pcie->scd_base_addr +
-		SCD_TX_STTS_MEM_LOWER_BOUND + (16 * txq->q.id);
+				SCD_TX_STTS_QUEUE_OFFSET(txq->q.id);
 	u8 buf[16];
 	int i;
 
-- 
1.7.10.4

