Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:32971 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaDMTUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:23 -0400
Received: by mail-wi0-f178.google.com with SMTP id bs8so3129443wib.5
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:22 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/47] iwlwifi: pcie: clarify RX queue need_update handling and locking
Date: Sun, 13 Apr 2014 22:19:23 +0300
Message-Id: <1397416802-32403-8-git-send-email-egrumbach@gmail.com> (sfid-20140413_212232_993094_D92335D0)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When shadow registers are enabled, then need_update never needs
to be set, so move the need_update handling into the function
that really needs to do it (iwl_pcie_rxq_inc_wr_ptr) and also
separate the check when it woke up. While at it, convert it to
bool.

This also clarifies the locking and means the irq_lock needs to
no longer be held for any such updates.

The irq_lock also doesn't have to be held for restocking since
everything else locks the RX queue properly, so remove that and
finally disentangle the two locks entirely so there aren't any
dependencies between the two left.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |  2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       | 44 ++++++++++++++++------------
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index e269468..477ac36 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -102,7 +102,7 @@ struct iwl_rxq {
 	u32 write_actual;
 	struct list_head rx_free;
 	struct list_head rx_used;
-	int need_update;
+	bool need_update;
 	struct iwl_rb_status *rb_stts;
 	dma_addr_t rb_stts_dma;
 	spinlock_t lock;
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index e8e5afc..57e98cc 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -145,15 +145,13 @@ int iwl_pcie_rx_stop(struct iwl_trans *trans)
 /*
  * iwl_pcie_rxq_inc_wr_ptr - Update the write pointer for the RX queue
  */
-static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
-				    struct iwl_rxq *rxq)
+static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rxq *rxq = &trans_pcie->rxq;
 	u32 reg;
 
-	spin_lock(&rxq->lock);
-
-	if (rxq->need_update == 0)
-		goto exit_unlock;
+	lockdep_assert_held(&rxq->lock);
 
 	/*
 	 * explicitly wake up the NIC if:
@@ -169,13 +167,27 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 				       reg);
 			iwl_set_bit(trans, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			goto exit_unlock;
+			rxq->need_update = true;
+			return;
 		}
 	}
 
 	rxq->write_actual = round_down(rxq->write, 8);
 	iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
-	rxq->need_update = 0;
+}
+
+static void iwl_pcie_rxq_check_wrptr(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rxq *rxq = &trans_pcie->rxq;
+
+	spin_lock(&rxq->lock);
+
+	if (!rxq->need_update)
+		goto exit_unlock;
+
+	iwl_pcie_rxq_inc_wr_ptr(trans);
+	rxq->need_update = false;
 
  exit_unlock:
 	spin_unlock(&rxq->lock);
@@ -236,9 +248,8 @@ static void iwl_pcie_rxq_restock(struct iwl_trans *trans)
 	 * Increment device's write pointer in multiples of 8. */
 	if (rxq->write_actual != (rxq->write & ~0x7)) {
 		spin_lock(&rxq->lock);
-		rxq->need_update = 1;
+		iwl_pcie_rxq_inc_wr_ptr(trans);
 		spin_unlock(&rxq->lock);
-		iwl_pcie_rxq_inc_wr_ptr(trans, rxq);
 	}
 }
 
@@ -364,13 +375,9 @@ static void iwl_pcie_rxq_free_rbs(struct iwl_trans *trans)
  */
 static void iwl_pcie_rx_replenish(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
 	iwl_pcie_rxq_alloc_rbs(trans, GFP_KERNEL);
 
-	spin_lock(&trans_pcie->irq_lock);
 	iwl_pcie_rxq_restock(trans);
-	spin_unlock(&trans_pcie->irq_lock);
 }
 
 static void iwl_pcie_rx_replenish_now(struct iwl_trans *trans)
@@ -525,10 +532,9 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 
 	iwl_pcie_rx_hw_init(trans, rxq);
 
-	spin_lock(&trans_pcie->irq_lock);
-	rxq->need_update = 1;
-	iwl_pcie_rxq_inc_wr_ptr(trans, rxq);
-	spin_unlock(&trans_pcie->irq_lock);
+	spin_lock(&rxq->lock);
+	iwl_pcie_rxq_inc_wr_ptr(trans);
+	spin_unlock(&rxq->lock);
 
 	return 0;
 }
@@ -1035,7 +1041,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	/* uCode wakes up after power-down sleep */
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR(trans, "Wakeup interrupt\n");
-		iwl_pcie_rxq_inc_wr_ptr(trans, &trans_pcie->rxq);
+		iwl_pcie_rxq_check_wrptr(trans);
 		for (i = 0; i < trans->cfg->base_params->num_of_queues; i++)
 			iwl_pcie_txq_inc_wr_ptr(trans, &trans_pcie->txq[i]);
 
-- 
1.8.3.2

