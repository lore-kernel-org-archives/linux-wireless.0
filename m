Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56169 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaATKtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 05:49:43 -0500
Received: by mail-wi0-f179.google.com with SMTP id hr1so2985252wib.12
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 02:49:42 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] iwlwifi: pcie: don't panic on host commands in iwldvm
Date: Mon, 20 Jan 2014 12:49:36 +0200
Message-Id: <1390214977-29202-1-git-send-email-egrumbach@gmail.com> (sfid-20140120_114946_517769_CC8EB9AF)
In-Reply-To: <52DCFE87.9080103@gmail.com>
References: <52DCFE87.9080103@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

None of the devices supported by iwldvm have support for
shadow registers. This means that we wake the NIC
when we increment the write pointer on Tx ring.
This happened even before my bad commit mentionned below.
Since my commit below, we wake up the NIC when we put a
host command on the ring regardless of shadow register
support. This means that in iwldvm (when the NIC doesn't
support shadow register), we wake up the NIC twice:

pcie_enqueue_hcmd:
	wake up the NIC
	iwl_pcie_txq_inc_wr_ptr:
		wake up the NIC - no shadow reg support

Since waking up the NIC means that we need to acquire a
spinlock, this obviously leads to a recursive spinlock
and hence a freeze.

Fixes: b9439491055a ("iwlwifi: pcie: keep the NIC awake when commands are in flight")
Reported-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 3b14fa8..3d54900 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -289,13 +289,15 @@ static void iwl_pcie_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
  */
 void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 reg = 0;
 	int txq_id = txq->q.id;
 
 	if (txq->need_update == 0)
 		return;
 
-	if (trans->cfg->base_params->shadow_reg_enable) {
+	if (trans->cfg->base_params->shadow_reg_enable ||
+	    txq_id == trans_pcie->cmd_queue) {
 		/* shadow register enabled */
 		iwl_write32(trans, HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
-- 
1.7.9.5

