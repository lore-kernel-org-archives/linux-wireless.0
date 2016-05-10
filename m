Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40716 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbcEJU3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:29:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:08 +0300
Message-Id: <1462910797-20303-12-git-send-email-luca@coelho.fi> (sfid-20160510_222924_430002_5D35DD00)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 12/41] iwlwifi: trans: don't call the trans-specific ref/unref directly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

It's cleaner to always call the iwl_trans_ref/unref() functions
instead of sometimes calling the trans-specific ops directly.  This
also prepares for moving some of the code from the trans-specific ops
to the common trans code.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  3 ---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 10 +++++-----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 9ce4ec6..de6974f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -481,9 +481,6 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 			    struct sk_buff_head *skbs);
 void iwl_trans_pcie_tx_reset(struct iwl_trans *trans);
 
-void iwl_trans_pcie_ref(struct iwl_trans *trans);
-void iwl_trans_pcie_unref(struct iwl_trans *trans);
-
 static inline u16 iwl_pcie_tfd_tb_get_len(struct iwl_tfd *tfd, u8 idx)
 {
 	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ee081c2..37e134d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2013,7 +2013,7 @@ static void iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans, u32 reg,
 	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
 }
 
-void iwl_trans_pcie_ref(struct iwl_trans *trans)
+static void iwl_trans_pcie_ref(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -2028,7 +2028,7 @@ void iwl_trans_pcie_ref(struct iwl_trans *trans)
 #endif /* CONFIG_PM */
 }
 
-void iwl_trans_pcie_unref(struct iwl_trans *trans)
+static void iwl_trans_pcie_unref(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index e1f7a3f..e2eb130d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -605,7 +605,7 @@ static void iwl_pcie_clear_cmd_in_flight(struct iwl_trans *trans)
 	if (trans_pcie->ref_cmd_in_flight) {
 		trans_pcie->ref_cmd_in_flight = false;
 		IWL_DEBUG_RPM(trans, "clear ref_cmd_in_flight - unref\n");
-		iwl_trans_pcie_unref(trans);
+		iwl_trans_unref(trans);
 	}
 
 	if (!trans->cfg->base_params->apmg_wake_up_wa)
@@ -650,7 +650,7 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 			if (txq_id != trans_pcie->cmd_queue) {
 				IWL_DEBUG_RPM(trans, "Q %d - last tx freed\n",
 					      q->id);
-				iwl_trans_pcie_unref(trans);
+				iwl_trans_unref(trans);
 			} else {
 				iwl_pcie_clear_cmd_in_flight(trans);
 			}
@@ -1134,7 +1134,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	if (q->read_ptr == q->write_ptr) {
 		IWL_DEBUG_RPM(trans, "Q %d - last tx reclaimed\n", q->id);
-		iwl_trans_pcie_unref(trans);
+		iwl_trans_unref(trans);
 	}
 
 out:
@@ -1153,7 +1153,7 @@ static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans,
 	    !trans_pcie->ref_cmd_in_flight) {
 		trans_pcie->ref_cmd_in_flight = true;
 		IWL_DEBUG_RPM(trans, "set ref_cmd_in_flight - ref\n");
-		iwl_trans_pcie_ref(trans);
+		iwl_trans_ref(trans);
 	}
 
 	/*
@@ -2362,7 +2362,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 				txq->frozen_expiry_remainder = txq->wd_timeout;
 		}
 		IWL_DEBUG_RPM(trans, "Q: %d first tx - take ref\n", q->id);
-		iwl_trans_pcie_ref(trans);
+		iwl_trans_ref(trans);
 	}
 
 	/* Tell device the write index *just past* this latest filled TFD */
-- 
2.8.1

