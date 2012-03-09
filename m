Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45725 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab2CISLp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 13:11:45 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] iwlwifi: fix cmd_queue number merge
Date: Fri,  9 Mar 2012 10:12:42 -0800
Message-Id: <1331316762-29126-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120309_191201_994816_B45417F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlwifi: move command queue number out of the iwl_shared struct
move the cmd_queue out of iwl_shared struct, but for some reason the
patch is half done and fail compile

Here is the fix

John, could you apply this patch to wireless-next to address the issue
Thanks

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h       |    4 ----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    6 +++---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index a4d1101..75dc20b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -216,10 +216,6 @@
 #define SCD_TRANS_TBL_OFFSET_QUEUE(x) \
 	((SCD_TRANS_TBL_MEM_LOWER_BOUND + ((x) * 2)) & 0xfffc)
 
-#define SCD_QUEUECHAIN_SEL_ALL(priv)	\
-	(((1<<hw_params(priv).max_txq_num) - 1) &\
-	(~(1<<(priv)->shrd->cmd_queue)))
-
 #define SCD_BASE			(PRPH_BASE + 0xa02c00)
 
 #define SCD_SRAM_BASE_ADDR	(SCD_BASE + 0x0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 8170133..a3ac6d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -556,7 +556,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
-		slots_num = (txq_id == trans->cmd_queue) ?
+		slots_num = (txq_id == trans_pcie->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		ret = iwl_trans_txq_alloc(trans, &trans_pcie->txq[txq_id],
 					  slots_num, txq_id);
@@ -601,7 +601,7 @@ static int iwl_tx_init(struct iwl_trans *trans)
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
-		slots_num = (txq_id == trans->cmd_queue) ?
+		slots_num = (txq_id == trans_pcie->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		ret = iwl_trans_txq_init(trans, &trans_pcie->txq[txq_id],
 					 slots_num, txq_id);
@@ -1686,7 +1686,7 @@ static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
 
 	/* waiting for all the tx frames complete might take a while */
 	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
-		if (cnt == trans->cmd_queue)
+		if (cnt == trans_pcie->cmd_queue)
 			continue;
 		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
-- 
1.7.0.4

