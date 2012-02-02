Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22467 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab2BCAQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:51 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/28] iwlwifi: add fw_alive to transport layer API, kill tx_start
Date: Thu,  2 Feb 2012 15:08:52 -0800
Message-Id: <1328224159-18134-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011659_283511_77DB8ED7)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Define a new handler in the transport layer API: fw_alive.
Move iwl_reset_ict to this new handler, and move the content
of tx_start to this handler.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    3 ---
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    2 --
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   10 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   15 +++++++--------
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |    2 +-
 7 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 90315c6..9d9185f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1243,9 +1243,6 @@ int iwl_alive_start(struct iwl_priv *priv)
 	int ret = 0;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	/*TODO: this should go to the transport layer */
-	iwl_reset_ict(trans(priv));
-
 	IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 
 	/* After the ALIVE response, we can send host commands to the uCode */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 39cbe1a..0f5133a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -73,8 +73,6 @@ struct iwlagn_ucode_capabilities {
 
 extern struct ieee80211_ops iwlagn_hw_ops;
 
-int iwl_reset_ict(struct iwl_trans *trans);
-
 static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 {
 	hdr->op_code = cmd;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 0ac9b4d..0f73778 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -258,7 +258,7 @@ void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 /*****************************************************
 * ICT
 ******************************************************/
-int iwl_reset_ict(struct iwl_trans *trans);
+void iwl_reset_ict(struct iwl_trans *trans);
 void iwl_disable_ict(struct iwl_trans *trans);
 int iwl_alloc_isr_ict(struct iwl_trans *trans);
 void iwl_free_isr_ict(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 848c598..2822b7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1213,7 +1213,7 @@ int iwl_alloc_isr_ict(struct iwl_trans *trans)
 /* Device is going up inform it about using ICT interrupt table,
  * also we need to tell the driver to start using ICT interrupt.
  */
-int iwl_reset_ict(struct iwl_trans *trans)
+void iwl_reset_ict(struct iwl_trans *trans)
 {
 	u32 val;
 	unsigned long flags;
@@ -1221,7 +1221,7 @@ int iwl_reset_ict(struct iwl_trans *trans)
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	if (!trans_pcie->ict_tbl)
-		return 0;
+		return;
 
 	spin_lock_irqsave(&trans->shrd->lock, flags);
 	iwl_disable_interrupts(trans);
@@ -1241,8 +1241,6 @@ int iwl_reset_ict(struct iwl_trans *trans)
 	iwl_write32(bus(trans), CSR_INT, trans_pcie->inta_mask);
 	iwl_enable_interrupts(trans);
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
-	return 0;
 }
 
 /* Device is going down disable ict interrupt usage */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 5e6af4b..affa56f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -835,7 +835,7 @@ static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
 	iwl_write_prph(bus(trans), SCD_TXFACT, mask);
 }
 
-static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
+static void iwl_tx_start(struct iwl_trans *trans)
 {
 	const struct queue_to_fifo_ac *queue_to_fifo;
 	struct iwl_trans_pcie *trans_pcie =
@@ -948,6 +948,12 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 }
 
+static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans)
+{
+	iwl_reset_ict(trans);
+	iwl_tx_start(trans);
+}
+
 /**
  * iwlagn_txq_ctx_stop - Stop all Tx DMA channels
  */
@@ -1903,11 +1909,11 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 const struct iwl_trans_ops trans_ops_pcie = {
 	.alloc = iwl_trans_pcie_alloc,
 	.request_irq = iwl_trans_pcie_request_irq,
+	.fw_alive = iwl_trans_pcie_fw_alive,
 	.start_device = iwl_trans_pcie_start_device,
 	.prepare_card_hw = iwl_trans_pcie_prepare_card_hw,
 	.stop_device = iwl_trans_pcie_stop_device,
 
-	.tx_start = iwl_trans_pcie_tx_start,
 	.wake_any_queue = iwl_trans_pcie_wake_any_queue,
 
 	.send_cmd = iwl_trans_pcie_send_cmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 42a9f30..9795a23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -139,8 +139,7 @@ struct iwl_host_cmd {
  *                layer.
  * @prepare_card_hw: claim the ownership on the HW. Will be called during
  *                   probe.
- * @tx_start: starts and configures all the Tx fifo - usually done once the fw
- *           is alive.
+ * @fw_alive: called when the fw sends alive notification
  * @wake_any_queue: wake all the queues of a specfic context IWL_RXON_CTX_*
  * @stop_device:stops the whole device (embedded CPU put to reset)
  * @send_cmd:send a host command
@@ -166,9 +165,9 @@ struct iwl_trans_ops {
 	struct iwl_trans *(*alloc)(struct iwl_shared *shrd);
 	int (*request_irq)(struct iwl_trans *iwl_trans);
 	int (*start_device)(struct iwl_trans *trans);
+	void (*fw_alive)(struct iwl_trans *trans);
 	int (*prepare_card_hw)(struct iwl_trans *trans);
 	void (*stop_device)(struct iwl_trans *trans);
-	void (*tx_start)(struct iwl_trans *trans);
 
 	void (*wake_any_queue)(struct iwl_trans *trans,
 			       enum iwl_rxon_context_id ctx,
@@ -264,6 +263,11 @@ static inline int iwl_trans_request_irq(struct iwl_trans *trans)
 	return trans->ops->request_irq(trans);
 }
 
+static inline void iwl_trans_fw_alive(struct iwl_trans *trans)
+{
+	trans->ops->fw_alive(trans);
+}
+
 static inline int iwl_trans_start_device(struct iwl_trans *trans)
 {
 	return trans->ops->start_device(trans);
@@ -279,11 +283,6 @@ static inline void iwl_trans_stop_device(struct iwl_trans *trans)
 	trans->ops->stop_device(trans);
 }
 
-static inline void iwl_trans_tx_start(struct iwl_trans *trans)
-{
-	trans->ops->tx_start(trans);
-}
-
 static inline void iwl_trans_wake_any_queue(struct iwl_trans *trans,
 					    enum iwl_rxon_context_id ctx,
 					    const char *msg)
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 2edf0ef..0d7f207 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -447,7 +447,7 @@ static int iwl_alive_notify(struct iwl_trans *trans)
 	if (!priv->tx_cmd_pool)
 		return -ENOMEM;
 
-	iwl_trans_tx_start(trans);
+	iwl_trans_fw_alive(trans);
 	for_each_context(priv, ctx)
 		ctx->last_tx_rejected = false;
 
-- 
1.7.0.4

