Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48528 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2FKJxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:53:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/13] iwlwifi: print more info when a queue is stuck
Date: Mon, 11 Jun 2012 11:53:05 +0200
Message-Id: <1339408392-19425-7-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115346_155440_94EF6812)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Print some more info from the SCD's SRAM and dump the TRB
from the FH.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fh.h     |    2 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 74bce97..8060466 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -421,6 +421,8 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 		(FH_SRVC_LOWER_BOUND + ((_chnl) - 9) * 0x4)
 
 #define FH_TX_CHICKEN_BITS_REG	(FH_MEM_LOWER_BOUND + 0xE98)
+#define FH_TX_TRB_REG(_chan)	(FH_MEM_LOWER_BOUND + 0x958 + (_chan) * 4)
+
 /* Instruct FH to increment the retry count of a packet when
  * it is brought from the memory to TX-FIFO
  */
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 1eabb83..1904fda 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -298,6 +298,10 @@ static void iwl_trans_pcie_queue_stuck_timer(unsigned long data)
 	struct iwl_tx_queue *txq = (void *)data;
 	struct iwl_trans_pcie *trans_pcie = txq->trans_pcie;
 	struct iwl_trans *trans = iwl_trans_pcie_get_trans(trans_pcie);
+	u32 scd_sram_addr = trans_pcie->scd_base_addr +
+		SCD_TX_STTS_MEM_LOWER_BOUND + (16 * txq->q.id);
+	u8 buf[16];
+	int i;
 
 	spin_lock(&txq->lock);
 	/* check if triggered erroneously */
@@ -307,7 +311,6 @@ static void iwl_trans_pcie_queue_stuck_timer(unsigned long data)
 	}
 	spin_unlock(&txq->lock);
 
-
 	IWL_ERR(trans, "Queue %d stuck for %u ms.\n", txq->q.id,
 		jiffies_to_msecs(trans_pcie->wd_timeout));
 	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
@@ -317,6 +320,14 @@ static void iwl_trans_pcie_queue_stuck_timer(unsigned long data)
 					& (TFD_QUEUE_SIZE_MAX - 1),
 		iwl_read_prph(trans, SCD_QUEUE_WRPTR(txq->q.id)));
 
+	iwl_read_targ_mem_bytes(trans, scd_sram_addr, buf, sizeof(buf));
+
+	iwl_print_hex_error(trans, buf, sizeof(buf));
+
+	for (i = 0; i < FH_TCSR_CHNL_NUM; i++)
+		IWL_ERR(trans, "FH TRBs(%d) = 0x%08x\n", i,
+			iwl_read_direct32(trans, FH_TX_TRB_REG(i)));
+
 	iwl_op_mode_nic_error(trans->op_mode);
 }
 
-- 
1.7.10

