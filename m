Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:52677 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3LaRQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:25 -0500
Received: by mail-ea0-f182.google.com with SMTP id a15so5616910eae.41
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:24 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/28] iwlwifi: pcie: allow the op_mode to call stop_device whenever it wants
Date: Tue, 31 Dec 2013 19:15:45 +0200
Message-Id: <1388510157-23345-16-git-send-email-egrumbach@gmail.com> (sfid-20131231_181631_938283_B0E4D11E)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Calling stop_device when start_fw wasn't called would issue:
Stopping tx queues that aren't allocated...

Also allow the op_mode to call stop_device and then to
disable the Tx queues - in that case just silently ignore
the disabling on the Tx queues, since the PRPH registers
aren't reachable any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h |    7 ++++---
 drivers/net/wireless/iwlwifi/pcie/tx.c   |   23 ++++++++++++++++++-----
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0c36478..04e1826 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -622,6 +622,10 @@ static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 {
 	int ret;
 
+	if (unlikely(!(cmd->flags & CMD_SEND_IN_RFKILL) &&
+		     test_bit(STATUS_RFKILL, &trans->status)))
+		return -ERFKILL;
+
 	if (unlikely(test_bit(STATUS_FW_ERROR, &trans->status)))
 		return -EIO;
 
@@ -684,9 +688,6 @@ static inline void iwl_trans_reclaim(struct iwl_trans *trans, int queue,
 
 static inline void iwl_trans_txq_disable(struct iwl_trans *trans, int queue)
 {
-	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
-
 	trans->ops->txq_disable(trans, queue);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 2417af9..aec9d9f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -758,11 +758,17 @@ int iwl_pcie_tx_stop(struct iwl_trans *trans)
 	}
 	spin_unlock(&trans_pcie->irq_lock);
 
-	if (!trans_pcie->txq) {
-		IWL_WARN(trans,
-			 "Stopping tx queues that aren't allocated...\n");
+	/*
+	 * This function can be called before the op_mode disabled the
+	 * queues. This happens when we have an rfkill interrupt.
+	 * Since we stop Tx altogether - mark the queues as stopped.
+	 */
+	memset(trans_pcie->queue_stopped, 0, sizeof(trans_pcie->queue_stopped));
+	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
+
+	/* This can happen: start_hw, stop_device */
+	if (!trans_pcie->txq)
 		return 0;
-	}
 
 	/* Unmap DMA from host system and free skb's */
 	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
@@ -1150,8 +1156,15 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 			SCD_TX_STTS_QUEUE_OFFSET(txq_id);
 	static const u32 zero_val[4] = {};
 
+	/*
+	 * Upon HW Rfkill - we stop the device, and then stop the queues
+	 * in the op_mode. Just for the sake of the simplicity of the op_mode,
+	 * allow the op_mode to call txq_disable after it already called
+	 * stop_device.
+	 */
 	if (!test_and_clear_bit(txq_id, trans_pcie->queue_used)) {
-		WARN_ONCE(1, "queue %d not used", txq_id);
+		WARN_ONCE(test_bit(STATUS_DEVICE_ENABLED, &trans->status),
+			  "queue %d not used", txq_id);
 		return;
 	}
 
-- 
1.7.9.5

