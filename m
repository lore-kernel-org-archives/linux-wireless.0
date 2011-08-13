Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31394 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab1HMSSd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 48/60] iwlagn: stop the device before freeing it
Date: Sat, 13 Aug 2011 10:38:24 -0700
Message-Id: <1313257116-2697-49-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_202012_528140_D4D88153)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we remove the module, we free all the tx and rx resources.
Before doing that, we'd better stop the tx / rx activity. Calling
iwl_trans_stop_device in iwl_remove helps also to remove a few API
functions:
 * rx_free:		happens in iwl_trans_free
 * tx_free:		happens in iwl_trans_free
 * disable_sync_irq:	happens in iwl_trans_stop_device

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |   11 +------
 drivers/net/wireless/iwlwifi/iwl-trans.c |   42 ++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-trans.h |   23 ----------------
 3 files changed, 22 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ce78ace..868770b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3507,20 +3507,13 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 		priv->mac80211_registered = 0;
 	}
 
-	/* Reset to low power before unloading driver. */
-	iwl_apm_stop(priv);
-
 	iwl_tt_exit(priv);
 
-	/* make sure we flush any pending irq or
-	 * tasklet for the driver */
-	iwl_trans_disable_sync_irq(trans(priv));
+	/*This will stop the queues, move the device to low power state */
+	iwl_trans_stop_device(trans(priv));
 
 	iwl_dealloc_ucode(priv);
 
-	iwl_trans_rx_free(trans(priv));
-	iwl_trans_tx_free(trans(priv));
-
 	iwl_eeprom_free(priv);
 
 	/*netif_stop_queue(dev); */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index ac401b8..0a3dd6b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -555,7 +555,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 	return 0;
 
 error:
-	iwl_trans_tx_free(trans);
+	iwl_trans_pcie_tx_free(trans);
 
 	return ret;
 }
@@ -603,7 +603,7 @@ static int iwl_tx_init(struct iwl_trans *trans)
 error:
 	/*Upon error, free only if we allocated something */
 	if (alloc)
-		iwl_trans_tx_free(trans);
+		iwl_trans_pcie_tx_free(trans);
 	return ret;
 }
 
@@ -958,13 +958,28 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 	return 0;
 }
 
+static void iwl_trans_pcie_disable_sync_irq(struct iwl_trans *trans)
+{
+	unsigned long flags;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+	iwl_disable_interrupts(trans);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
+	/* wait to make sure we flush pending tasklet*/
+	synchronize_irq(bus(trans)->irq);
+	tasklet_kill(&trans_pcie->irq_tasklet);
+}
+
 static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 {
 	/* stop and reset the on-board processor */
 	iwl_write32(bus(trans), CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
-	iwl_trans_disable_sync_irq(trans);
+	iwl_trans_pcie_disable_sync_irq(trans);
 
 	/* device going down, Stop using ICT table */
 	iwl_disable_ict(trans);
@@ -1208,23 +1223,10 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id,
 	}
 }
 
-static void iwl_trans_pcie_disable_sync_irq(struct iwl_trans *trans)
-{
-	unsigned long flags;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
-	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(bus(trans)->irq);
-	tasklet_kill(&trans_pcie->irq_tasklet);
-}
-
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
 {
+	iwl_trans_pcie_tx_free(trans);
+	iwl_trans_pcie_rx_free(trans);
 	free_irq(bus(trans)->irq, trans);
 	iwl_free_isr_ict(trans);
 	trans->shrd->trans = NULL;
@@ -1860,9 +1862,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 
 	.tx_start = iwl_trans_pcie_tx_start,
 
-	.rx_free = iwl_trans_pcie_rx_free,
-	.tx_free = iwl_trans_pcie_tx_free,
-
 	.send_cmd = iwl_trans_pcie_send_cmd,
 	.send_cmd_pdu = iwl_trans_pcie_send_cmd_pdu,
 
@@ -1875,7 +1874,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 
 	.kick_nic = iwl_trans_pcie_kick_nic,
 
-	.disable_sync_irq = iwl_trans_pcie_disable_sync_irq,
 	.free = iwl_trans_pcie_free,
 
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0da6ad5..e72e480 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -88,8 +88,6 @@ struct iwl_shared;
  * @tx_start: starts and configures all the Tx fifo - usually done once the fw
  *           is alive.
  * @stop_device:stops the whole device (embedded CPU put to reset)
- * @rx_free: frees the rx memory
- * @tx_free: frees the tx memory
  * @send_cmd:send a host command
  * @send_cmd_pdu:send a host command: flags can be CMD_*
  * @get_tx_cmd: returns a pointer to a new Tx cmd for the upper layer use
@@ -99,9 +97,6 @@ struct iwl_shared;
  *                 ready and a successful ADDBA response has been received.
  * @txq_agg_disable: de-configure a Tx queue to send AMPDUs
  * @kick_nic: remove the RESET from the embedded CPU and let it run
- * @disable_sync_irq: Disable and sync: after this handler returns, it is
- *	guaranteed that all the ISR / tasklet etc... have finished running
- *	and the transport layer shall not pass any Rx.
  * @free: release all the ressource for the transport layer itself such as
  *        irq, tasklet etc...
  * @dbgfs_register: add the dbgfs files under this directory. Files will be
@@ -117,8 +112,6 @@ struct iwl_trans_ops {
 	int (*prepare_card_hw)(struct iwl_trans *trans);
 	void (*stop_device)(struct iwl_trans *trans);
 	void (*tx_start)(struct iwl_trans *trans);
-	void (*tx_free)(struct iwl_trans *trans);
-	void (*rx_free)(struct iwl_trans *trans);
 
 	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
@@ -138,7 +131,6 @@ struct iwl_trans_ops {
 
 	void (*kick_nic)(struct iwl_trans *trans);
 
-	void (*disable_sync_irq)(struct iwl_trans *trans);
 	void (*free)(struct iwl_trans *trans);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
@@ -187,16 +179,6 @@ static inline void iwl_trans_tx_start(struct iwl_trans *trans)
 	trans->ops->tx_start(trans);
 }
 
-static inline void iwl_trans_rx_free(struct iwl_trans *trans)
-{
-	trans->ops->rx_free(trans);
-}
-
-static inline void iwl_trans_tx_free(struct iwl_trans *trans)
-{
-	trans->ops->tx_free(trans);
-}
-
 static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 				struct iwl_host_cmd *cmd)
 {
@@ -247,11 +229,6 @@ static inline void iwl_trans_kick_nic(struct iwl_trans *trans)
 	trans->ops->kick_nic(trans);
 }
 
-static inline void iwl_trans_disable_sync_irq(struct iwl_trans *trans)
-{
-	trans->ops->disable_sync_irq(trans);
-}
-
 static inline void iwl_trans_free(struct iwl_trans *trans)
 {
 	trans->ops->free(trans);
-- 
1.7.0.4

