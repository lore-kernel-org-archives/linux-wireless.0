Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:57654 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3LaRQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:23 -0500
Received: by mail-ee0-f42.google.com with SMTP id e53so5661531eek.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:21 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/28] iwlwifi: pcie: keep the NIC awake when commands are in flight
Date: Tue, 31 Dec 2013 19:15:43 +0200
Message-Id: <1388510157-23345-14-git-send-email-egrumbach@gmail.com> (sfid-20131231_181628_611615_AB2A5456)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Under very specific circumstances, the firmware might
ignore a host command. This was debugged and we ended up
seeing that the power management hardware was faulty.
In order to workaround this issue, we keep the NIC awake
as long as we have host commands in flight. This will avoid
to put the hardware into buggy condition.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |   29 +++++++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c    |   35 +++----------
 drivers/net/wireless/iwlwifi/pcie/tx.c       |   71 ++++++++++++++++----------
 3 files changed, 82 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 9dfee7e..8090524 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -262,6 +262,7 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
  * @rx_page_order: page order for receive buffer size
  * @wd_timeout: queue watchdog timeout (jiffies)
  * @reg_lock: protect hw register access
+ * @cmd_in_flight: true when we have a host command in flight
  */
 struct iwl_trans_pcie {
 	struct iwl_rxq rxq;
@@ -310,6 +311,7 @@ struct iwl_trans_pcie {
 
 	/*protect hw register */
 	spinlock_t reg_lock;
+	bool cmd_in_flight;
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
@@ -459,4 +461,31 @@ static inline bool iwl_is_rfkill_set(struct iwl_trans *trans)
 		CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
 }
 
+static inline void __iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans,
+						  u32 reg, u32 mask, u32 value)
+{
+	u32 v;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	WARN_ON_ONCE(value & ~mask);
+#endif
+
+	v = iwl_read32(trans, reg);
+	v &= ~mask;
+	v |= value;
+	iwl_write32(trans, reg, v);
+}
+
+static inline void __iwl_trans_pcie_clear_bit(struct iwl_trans *trans,
+					      u32 reg, u32 mask)
+{
+	__iwl_trans_pcie_set_bits_mask(trans, reg, mask, 0);
+}
+
+static inline void __iwl_trans_pcie_set_bit(struct iwl_trans *trans,
+					    u32 reg, u32 mask)
+{
+	__iwl_trans_pcie_set_bits_mask(trans, reg, mask, mask);
+}
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 9a07cf3..d9ccb4e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -75,33 +75,6 @@
 #include "iwl-agn-hw.h"
 #include "internal.h"
 
-static void __iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans,
-						  u32 reg, u32 mask, u32 value)
-{
-	u32 v;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	WARN_ON_ONCE(value & ~mask);
-#endif
-
-	v = iwl_read32(trans, reg);
-	v &= ~mask;
-	v |= value;
-	iwl_write32(trans, reg, v);
-}
-
-static inline void __iwl_trans_pcie_clear_bit(struct iwl_trans *trans,
-					      u32 reg, u32 mask)
-{
-	__iwl_trans_pcie_set_bits_mask(trans, reg, mask, 0);
-}
-
-static inline void __iwl_trans_pcie_set_bit(struct iwl_trans *trans,
-					    u32 reg, u32 mask)
-{
-	__iwl_trans_pcie_set_bits_mask(trans, reg, mask, mask);
-}
-
 static void iwl_pcie_set_pwr(struct iwl_trans *trans, bool vaux)
 {
 	if (vaux && pci_pme_capable(to_pci_dev(trans->dev), PCI_D3cold))
@@ -929,6 +902,9 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent,
 
 	spin_lock_irqsave(&trans_pcie->reg_lock, *flags);
 
+	if (trans_pcie->cmd_in_flight)
+		goto out;
+
 	/* this bit wakes up the NIC */
 	__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
 				 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
@@ -968,6 +944,7 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent,
 		}
 	}
 
+out:
 	/*
 	 * Fool sparse by faking we release the lock - sparse will
 	 * track nic_access anyway.
@@ -989,6 +966,9 @@ static void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans,
 	 */
 	__acquire(&trans_pcie->reg_lock);
 
+	if (trans_pcie->cmd_in_flight)
+		goto out;
+
 	__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
 				   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	/*
@@ -998,6 +978,7 @@ static void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans,
 	 * scheduled on different CPUs (after we drop reg_lock).
 	 */
 	mmiowb();
+out:
 	spin_unlock_irqrestore(&trans_pcie->reg_lock, *flags);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index b49a1853..2417af9 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1001,6 +1001,7 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
+	unsigned long flags;
 	int nfreed = 0;
 
 	lockdep_assert_held(&txq->lock);
@@ -1023,6 +1024,16 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 		}
 	}
 
+	if (q->read_ptr == q->write_ptr) {
+		spin_lock_irqsave(&trans_pcie->reg_lock, flags);
+		WARN_ON(!trans_pcie->cmd_in_flight);
+		trans_pcie->cmd_in_flight = false;
+		__iwl_trans_pcie_clear_bit(trans,
+					   CSR_GP_CNTRL,
+					   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+		spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+	}
+
 	iwl_pcie_txq_progress(trans_pcie, txq);
 }
 
@@ -1174,12 +1185,13 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	struct iwl_queue *q = &txq->q;
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
+	unsigned long flags;
 	void *dup_buf = NULL;
 	dma_addr_t phys_addr;
 	int idx;
 	u16 copy_size, cmd_size, scratch_size;
 	bool had_nocopy = false;
-	int i;
+	int i, ret;
 	u32 cmd_pos;
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
@@ -1377,10 +1389,38 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	if (q->read_ptr == q->write_ptr && trans_pcie->wd_timeout)
 		mod_timer(&txq->stuck_timer, jiffies + trans_pcie->wd_timeout);
 
+	spin_lock_irqsave(&trans_pcie->reg_lock, flags);
+
+	/*
+	 * wake up the NIC to make sure that the firmware will see the host
+	 * command - we will let the NIC sleep once all the host commands
+	 * returned.
+	 */
+	if (!trans_pcie->cmd_in_flight) {
+		trans_pcie->cmd_in_flight = true;
+		__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
+					 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+		ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
+				   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
+				   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
+				    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP),
+				   15000);
+		if (ret < 0) {
+			__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
+				   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+			spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+			trans_pcie->cmd_in_flight = false;
+			idx = -EIO;
+			goto out;
+		}
+	}
+
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	iwl_pcie_txq_inc_wr_ptr(trans, txq);
 
+	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+
  out:
 	spin_unlock_bh(&txq->lock);
  free_dup_buf:
@@ -1462,7 +1502,6 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 }
 
 #define HOST_COMPLETE_TIMEOUT	(2 * HZ)
-#define COMMAND_POKE_TIMEOUT	(HZ / 10)
 
 static int iwl_pcie_send_hcmd_async(struct iwl_trans *trans,
 				    struct iwl_host_cmd *cmd)
@@ -1490,7 +1529,6 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int cmd_idx;
 	int ret;
-	int timeout = HOST_COMPLETE_TIMEOUT;
 
 	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
 		       get_cmd_string(trans_pcie, cmd->id));
@@ -1514,29 +1552,10 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 		return ret;
 	}
 
-	while (timeout > 0) {
-		unsigned long flags;
-
-		timeout -= COMMAND_POKE_TIMEOUT;
-		ret = wait_event_timeout(trans_pcie->wait_command_queue,
-					 !test_bit(STATUS_SYNC_HCMD_ACTIVE,
-						   &trans->status),
-					 COMMAND_POKE_TIMEOUT);
-		if (ret)
-			break;
-		/* poke the device - it may have lost the command */
-		if (iwl_trans_grab_nic_access(trans, true, &flags)) {
-			iwl_trans_release_nic_access(trans, &flags);
-			IWL_DEBUG_INFO(trans,
-				       "Tried to wake NIC for command %s\n",
-				       get_cmd_string(trans_pcie, cmd->id));
-		} else {
-			IWL_ERR(trans, "Failed to poke NIC for command %s\n",
-				get_cmd_string(trans_pcie, cmd->id));
-			break;
-		}
-	}
-
+	ret = wait_event_timeout(trans_pcie->wait_command_queue,
+				 !test_bit(STATUS_SYNC_HCMD_ACTIVE,
+					   &trans->status),
+				 HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
 		struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
 		struct iwl_queue *q = &txq->q;
-- 
1.7.9.5

