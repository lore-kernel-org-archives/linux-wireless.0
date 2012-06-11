Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2FKJyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:54:13 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/13] iwlwifi: print even more info when a queue is stuck
Date: Mon, 11 Jun 2012 11:53:10 +0200
Message-Id: <1339408392-19425-12-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115424_481134_FD033289)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the queue gets stuck from time to time, we are trying
to get as much information as we can when this occurs.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 4d4cbae..d426e3d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -315,10 +315,6 @@ static void iwl_trans_pcie_queue_stuck_timer(unsigned long data)
 		jiffies_to_msecs(trans_pcie->wd_timeout));
 	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
 		txq->q.read_ptr, txq->q.write_ptr);
-	IWL_ERR(trans, "Current HW read_ptr %d write_ptr %d\n",
-		iwl_read_prph(trans, SCD_QUEUE_RDPTR(txq->q.id))
-					& (TFD_QUEUE_SIZE_MAX - 1),
-		iwl_read_prph(trans, SCD_QUEUE_WRPTR(txq->q.id)));
 
 	iwl_read_targ_mem_bytes(trans, scd_sram_addr, buf, sizeof(buf));
 
@@ -328,6 +324,27 @@ static void iwl_trans_pcie_queue_stuck_timer(unsigned long data)
 		IWL_ERR(trans, "FH TRBs(%d) = 0x%08x\n", i,
 			iwl_read_direct32(trans, FH_TX_TRB_REG(i)));
 
+	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
+		u32 status = iwl_read_prph(trans, SCD_QUEUE_STATUS_BITS(i));
+		u8 fifo = (status >> SCD_QUEUE_STTS_REG_POS_TXF) & 0x7;
+		bool active = !!(status & BIT(SCD_QUEUE_STTS_REG_POS_ACTIVE));
+		u32 tbl_dw =
+			iwl_read_targ_mem(trans,
+					  trans_pcie->scd_base_addr +
+					  SCD_TRANS_TBL_OFFSET_QUEUE(i));
+
+		if (i & 0x1)
+			tbl_dw = (tbl_dw & 0xFFFF0000) >> 16;
+		else
+			tbl_dw = tbl_dw & 0x0000FFFF;
+
+		IWL_ERR(trans,
+			"Q %d is %sactive and mapped to fifo %d ra_tid 0x%04x [%d,%d]\n",
+			i, active ? "" : "in", fifo, tbl_dw,
+			iwl_read_prph(trans, SCD_QUEUE_RDPTR(i)),
+			iwl_read_prph(trans, SCD_QUEUE_WRPTR(i)));
+	}
+
 	iwl_op_mode_nic_error(trans->op_mode);
 }
 
-- 
1.7.10

