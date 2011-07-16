Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab1GPPcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:01 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/18] iwlagn: move the tasklet / irq to the transport layer
Date: Sat, 16 Jul 2011 07:56:23 -0700
Message-Id: <1310828199-18000-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173216_180689_B8CB89AE)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

PCIe doesn't provide any ISR registration API, whereas other buses do.
Hence, we need to move the tasklet and irq to the transport layer to allow this
flexibility.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c |    4 +++
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   39 +++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    4 +++
 drivers/net/wireless/iwlwifi/iwl-trans.c   |   29 +++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.h   |    7 ++++-
 6 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
index f1b40ec..9a2eb1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
@@ -49,6 +49,10 @@ void iwl_free_isr_ict(struct iwl_priv *priv)
 				  priv->_agn.ict_tbl_vir,
 				  priv->_agn.ict_tbl_dma);
 		priv->_agn.ict_tbl_vir = NULL;
+		memset(&priv->_agn.ict_tbl_dma, 0,
+			sizeof(priv->_agn.ict_tbl_dma));
+		memset(&priv->_agn.aligned_ict_tbl_dma, 0,
+			sizeof(priv->_agn.aligned_ict_tbl_dma));
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 38a1e4f..598f164 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -625,7 +625,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 }
 
 /* tasklet for iwlagn interrupt */
-static void iwl_irq_tasklet(struct iwl_priv *priv)
+void iwl_irq_tasklet(struct iwl_priv *priv)
 {
 	u32 inta = 0;
 	u32 handled = 0;
@@ -3227,9 +3227,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	init_timer(&priv->watchdog);
 	priv->watchdog.data = (unsigned long)priv;
 	priv->watchdog.function = iwl_bg_watchdog;
-
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
-		iwl_irq_tasklet, (unsigned long)priv);
 }
 
 static void iwl_cancel_deferred_work(struct iwl_priv *priv)
@@ -3548,8 +3545,6 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	priv->bus.ops->set_drv_data(&priv->bus, priv);
 	priv->bus.dev = priv->bus.ops->get_dev(&priv->bus);
 
-	iwl_trans_register(&priv->trans);
-
 	/* At this point both hw and priv are allocated. */
 
 	SET_IEEE80211_DEV(hw, priv->bus.dev);
@@ -3558,6 +3553,10 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	priv->cfg = cfg;
 	priv->inta_mask = CSR_INI_SET_MASK;
 
+	err = iwl_trans_register(priv);
+	if (err)
+		goto out_free_priv;
+
 	/* is antenna coupling more than 35dB ? */
 	priv->bt_ant_couple_ok =
 		(iwlagn_ant_coupling > IWL_BT_ANTENNA_COUPLING_THRESHOLD) ?
@@ -3652,15 +3651,6 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	/********************
 	 * 7. Setup services
 	 ********************/
-	iwl_alloc_isr_ict(priv);
-
-	err = request_irq(priv->bus.irq, iwl_isr_ict, IRQF_SHARED,
-			  DRV_NAME, priv);
-	if (err) {
-		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->bus.irq);
-		goto out_uninit_drv;
-	}
-
 	iwl_setup_deferred_work(priv);
 	iwl_setup_rx_handlers(priv);
 	iwl_testmode_init(priv);
@@ -3691,19 +3681,18 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 
 	return 0;
 
- out_destroy_workqueue:
+out_destroy_workqueue:
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
-	free_irq(priv->bus.irq, priv);
-	iwl_free_isr_ict(priv);
- out_uninit_drv:
 	iwl_uninit_drv(priv);
- out_free_eeprom:
+out_free_eeprom:
 	iwl_eeprom_free(priv);
- out_free_traffic_mem:
+out_free_traffic_mem:
 	iwl_free_traffic_mem(priv);
+	trans_free(priv);
+out_free_priv:
 	ieee80211_free_hw(priv->hw);
- out:
+out:
 	return err;
 }
 
@@ -3754,7 +3743,6 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 
 	iwl_eeprom_free(priv);
 
-
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
 
@@ -3765,13 +3753,12 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	priv->workqueue = NULL;
 	iwl_free_traffic_mem(priv);
 
-	free_irq(priv->bus.irq, priv);
+	trans_free(priv);
+
 	priv->bus.ops->set_drv_data(&priv->bus, NULL);
 
 	iwl_uninit_drv(priv);
 
-	iwl_free_isr_ict(priv);
-
 	dev_kfree_skb(priv->beacon_skb);
 
 	ieee80211_free_hw(priv->hw);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index aed86c6..7018855 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -188,6 +188,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 
 /* rx */
+void iwl_irq_tasklet(struct iwl_priv *priv);
 void iwlagn_rx_queue_restock(struct iwl_priv *priv);
 void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority);
 void iwlagn_rx_replenish(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 173fad2..b38b00c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1243,6 +1243,8 @@ struct iwl_trans;
  * @tx_free: frees the tx memory
  * @send_cmd:send a host command
  * @send_cmd_pdu:send a host command: flags can be CMD_*
+ * @free: release all the ressource for the transport layer itself such as
+ *        irq, tasklet etc...
  */
 struct iwl_trans_ops {
 	int (*rx_init)(struct iwl_priv *priv);
@@ -1261,6 +1263,8 @@ struct iwl_trans_ops {
 	int (*tx)(struct iwl_priv *priv, struct sk_buff *skb,
 		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
 		struct iwl_rxon_context *ctx);
+
+	void (*free)(struct iwl_priv *priv);
 };
 
 struct iwl_trans {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index acd2a5f..ecdda6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -705,6 +705,12 @@ static int iwl_trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	return 0;
 }
 
+static void iwl_trans_free(struct iwl_priv *priv)
+{
+	free_irq(priv->bus.irq, priv);
+	iwl_free_isr_ict(priv);
+}
+
 static const struct iwl_trans_ops trans_ops = {
 	.rx_init = iwl_trans_rx_init,
 	.rx_stop = iwl_trans_rx_stop,
@@ -719,9 +725,28 @@ static const struct iwl_trans_ops trans_ops = {
 
 	.get_tx_cmd = iwl_trans_get_tx_cmd,
 	.tx = iwl_trans_tx,
+
+	.free = iwl_trans_free,
 };
 
-void iwl_trans_register(struct iwl_trans *trans)
+int iwl_trans_register(struct iwl_priv *priv)
 {
-	trans->ops = &trans_ops;
+	int err;
+
+	priv->trans.ops = &trans_ops;
+
+	iwl_alloc_isr_ict(priv);
+
+	err = request_irq(priv->bus.irq, iwl_isr_ict, IRQF_SHARED,
+		DRV_NAME, priv);
+	if (err) {
+		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->bus.irq);
+		iwl_free_isr_ict(priv);
+		return err;
+	}
+
+	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+		iwl_irq_tasklet, (unsigned long)priv);
+
+	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index f10bee8..f8133ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -115,4 +115,9 @@ static inline int trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	return priv->trans.ops->tx(priv, skb, tx_cmd, txq_id, fc, ampdu, ctx);
 }
 
-void iwl_trans_register(struct iwl_trans *trans);
+static inline void trans_free(struct iwl_priv *priv)
+{
+	priv->trans.ops->free(priv);
+}
+
+int iwl_trans_register(struct iwl_priv *priv);
-- 
1.7.0.4

