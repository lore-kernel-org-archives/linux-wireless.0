Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab1GPPcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/18] iwlagn: move sync_irq to transport layer
Date: Sat, 16 Jul 2011 07:56:24 -0700
Message-Id: <1310828199-18000-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173217_253937_497C127B)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since all the irq / tasklet is now handled in the transport layer, it should
give an API to ensure that all the irq / tasklet have finished running. This
will allow the upper layer to release all its resources.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    8 --------
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-trans.c   |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h   |    5 +++++
 6 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index eb2be0d..b282190 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2399,7 +2399,7 @@ void iwlagn_stop_device(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
-	iwl_synchronize_irq(priv);
+	trans_sync_irq(priv);
 
 	/* device going down, Stop using ICT table */
 	iwl_disable_ict(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 598f164..c91e010 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3734,7 +3734,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	iwl_synchronize_irq(priv);
+	trans_sync_irq(priv);
 
 	iwl_dealloc_ucode(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 7018855..fe5451e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -118,14 +118,6 @@ int iwl_alloc_isr_ict(struct iwl_priv *priv);
 void iwl_free_isr_ict(struct iwl_priv *priv);
 irqreturn_t iwl_isr_ict(int irq, void *data);
 
-/* call this function to flush any scheduled tasklet */
-static inline void iwl_synchronize_irq(struct iwl_priv *priv)
-{
-	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(priv->bus.irq);
-	tasklet_kill(&priv->irq_tasklet);
-}
-
 static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 {
 	hdr->op_code = cmd;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b38b00c..cb6801c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1243,6 +1243,10 @@ struct iwl_trans;
  * @tx_free: frees the tx memory
  * @send_cmd:send a host command
  * @send_cmd_pdu:send a host command: flags can be CMD_*
+ * @sync_irq: the upper layer will typically disable interrupt and call this
+ *            handler. After this handler returns, it is guaranteed that all
+ *            the ISR / tasklet etc... have finished running and the transport
+ *            layer shall not pass any Rx.
  * @free: release all the ressource for the transport layer itself such as
  *        irq, tasklet etc...
  */
@@ -1264,6 +1268,7 @@ struct iwl_trans_ops {
 		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
 		struct iwl_rxon_context *ctx);
 
+	void (*sync_irq)(struct iwl_priv *priv);
 	void (*free)(struct iwl_priv *priv);
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index ecdda6d..ca96902 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -705,6 +705,13 @@ static int iwl_trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	return 0;
 }
 
+static void iwl_trans_sync_irq(struct iwl_priv *priv)
+{
+	/* wait to make sure we flush pending tasklet*/
+	synchronize_irq(priv->bus.irq);
+	tasklet_kill(&priv->irq_tasklet);
+}
+
 static void iwl_trans_free(struct iwl_priv *priv)
 {
 	free_irq(priv->bus.irq, priv);
@@ -726,6 +733,7 @@ static const struct iwl_trans_ops trans_ops = {
 	.get_tx_cmd = iwl_trans_get_tx_cmd,
 	.tx = iwl_trans_tx,
 
+	.sync_irq = iwl_trans_sync_irq,
 	.free = iwl_trans_free,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index f8133ea..886730e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -115,6 +115,11 @@ static inline int trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	return priv->trans.ops->tx(priv, skb, tx_cmd, txq_id, fc, ampdu, ctx);
 }
 
+static inline void trans_sync_irq(struct iwl_priv *priv)
+{
+	priv->trans.ops->sync_irq(priv);
+}
+
 static inline void trans_free(struct iwl_priv *priv)
 {
 	priv->trans.ops->free(priv);
-- 
1.7.0.4

