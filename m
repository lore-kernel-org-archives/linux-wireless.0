Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37762 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaDMTUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:22 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so7261748wgh.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:21 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/47] iwlwifi: pcie: implement GRO without NAPI
Date: Sun, 13 Apr 2014 22:19:22 +0300
Message-Id: <1397416802-32403-7-git-send-email-egrumbach@gmail.com> (sfid-20140413_212033_633097_FC3F7FD3)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the new NAPI infrastructure added to mac80211 to get
GRO. We don't really implement NAPI since we don't have
a real poll function and we never schedule a NAPI poll.
Instead of this, we collect all the packets we got from a
single interrupt and then call napi_gro_flush().

This allows us to benefit from GRO. In half duplex medium
like WiFi, its main advantage is that it reduces the number
of TCP Acks, hence improving the TCP Rx performance.

Since we call the Rx path with a spinlock held, remove
the might_sleep mention from the op_mode's API.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ido Yariv <ido@wizery.com>
[Squash different patches and rewrite the commit message]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c      | 12 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-op-mode.h   | 25 ++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/ops.c       | 12 ++++++++++++
 drivers/net/wireless/iwlwifi/mvm/rx.c        |  2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c        |  4 ++--
 drivers/net/wireless/iwlwifi/pcie/internal.h |  3 +++
 drivers/net/wireless/iwlwifi/pcie/rx.c       | 17 +++++++++++++----
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 21 +++++++++++++++++++++
 8 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 6a6df71..6a00353 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -2053,6 +2053,17 @@ static bool iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 	return false;
 }
 
+static void iwl_napi_add(struct iwl_op_mode *op_mode,
+			 struct napi_struct *napi,
+			 struct net_device *napi_dev,
+			 int (*poll)(struct napi_struct *, int),
+			 int weight)
+{
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
+	ieee80211_napi_add(priv->hw, napi, napi_dev, poll, weight);
+}
+
 static const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.start = iwl_op_mode_dvm_start,
 	.stop = iwl_op_mode_dvm_stop,
@@ -2065,6 +2076,7 @@ static const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.cmd_queue_full = iwl_cmd_queue_full,
 	.nic_config = iwl_nic_config,
 	.wimax_active = iwl_wimax_active,
+	.napi_add = iwl_napi_add,
 };
 
 /*****************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index ea29504..99785c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -63,6 +63,7 @@
 #ifndef __iwl_op_mode_h__
 #define __iwl_op_mode_h__
 
+#include <linux/netdevice.h>
 #include <linux/debugfs.h>
 
 struct iwl_op_mode;
@@ -112,8 +113,11 @@ struct iwl_cfg;
  * @stop: stop the op_mode. Must free all the memory allocated.
  *	May sleep
  * @rx: Rx notification to the op_mode. rxb is the Rx buffer itself. Cmd is the
- *	HCMD this Rx responds to.
- *	This callback may sleep, it is called from a threaded IRQ handler.
+ *	HCMD this Rx responds to. Can't sleep.
+ * @napi_add: NAPI initialisation. The transport is fully responsible for NAPI,
+ *	but the higher layers need to know about it (in particular mac80211 to
+ *	to able to call the right NAPI RX functions); this function is needed
+ *	to eventually call netif_napi_add() with higher layer involvement.
  * @queue_full: notifies that a HW queue is full.
  *	Must be atomic and called with BH disabled.
  * @queue_not_full: notifies that a HW queue is not full any more.
@@ -143,6 +147,11 @@ struct iwl_op_mode_ops {
 	void (*stop)(struct iwl_op_mode *op_mode);
 	int (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 		  struct iwl_device_cmd *cmd);
+	void (*napi_add)(struct iwl_op_mode *op_mode,
+			 struct napi_struct *napi,
+			 struct net_device *napi_dev,
+			 int (*poll)(struct napi_struct *, int),
+			 int weight);
 	void (*queue_full)(struct iwl_op_mode *op_mode, int queue);
 	void (*queue_not_full)(struct iwl_op_mode *op_mode, int queue);
 	bool (*hw_rf_kill)(struct iwl_op_mode *op_mode, bool state);
@@ -180,7 +189,6 @@ static inline int iwl_op_mode_rx(struct iwl_op_mode *op_mode,
 				  struct iwl_rx_cmd_buffer *rxb,
 				  struct iwl_device_cmd *cmd)
 {
-	might_sleep();
 	return op_mode->ops->rx(op_mode, rxb, cmd);
 }
 
@@ -249,4 +257,15 @@ static inline int iwl_op_mode_exit_d0i3(struct iwl_op_mode *op_mode)
 	return op_mode->ops->exit_d0i3(op_mode);
 }
 
+static inline void iwl_op_mode_napi_add(struct iwl_op_mode *op_mode,
+					struct napi_struct *napi,
+					struct net_device *napi_dev,
+					int (*poll)(struct napi_struct *, int),
+					int weight)
+{
+	if (!op_mode->ops->napi_add)
+		return;
+	op_mode->ops->napi_add(op_mode, napi, napi_dev, poll, weight);
+}
+
 #endif /* __iwl_op_mode_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 9545d7f..e436c04 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1183,6 +1183,17 @@ out:
 	return ret;
 }
 
+static void iwl_mvm_napi_add(struct iwl_op_mode *op_mode,
+			     struct napi_struct *napi,
+			     struct net_device *napi_dev,
+			     int (*poll)(struct napi_struct *, int),
+			     int weight)
+{
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+
+	ieee80211_napi_add(mvm->hw, napi, napi_dev, poll, weight);
+}
+
 static const struct iwl_op_mode_ops iwl_mvm_ops = {
 	.start = iwl_op_mode_mvm_start,
 	.stop = iwl_op_mode_mvm_stop,
@@ -1196,4 +1207,5 @@ static const struct iwl_op_mode_ops iwl_mvm_ops = {
 	.nic_config = iwl_mvm_nic_config,
 	.enter_d0i3 = iwl_mvm_enter_d0i3,
 	.exit_d0i3 = iwl_mvm_exit_d0i3,
+	.napi_add = iwl_mvm_napi_add,
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 6061553..69f6aa6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -130,7 +130,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
-	ieee80211_rx_ni(mvm->hw, skb);
+	ieee80211_rx(mvm->hw, skb);
 }
 
 static void iwl_mvm_calc_rssi(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 0a4ad45..ff1b630 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -640,7 +640,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		info->status.status_driver_data[0] =
 				(void *)(uintptr_t)tx_resp->reduced_tpc;
 
-		ieee80211_tx_status_ni(mvm->hw, skb);
+		ieee80211_tx_status(mvm->hw, skb);
 	}
 
 	if (txq_id >= mvm->first_agg_queue) {
@@ -944,7 +944,7 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 
 	while (!skb_queue_empty(&reclaimed_skbs)) {
 		skb = __skb_dequeue(&reclaimed_skbs);
-		ieee80211_tx_status_ni(mvm->hw, skb);
+		ieee80211_tx_status(mvm->hw, skb);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 9091513..e269468 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -270,6 +270,9 @@ struct iwl_trans_pcie {
 	struct iwl_trans *trans;
 	struct iwl_drv *drv;
 
+	struct net_device napi_dev;
+	struct napi_struct napi;
+
 	/* INT ICT Table */
 	__le32 *ict_tbl;
 	dma_addr_t ict_tbl_dma;
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index fdfa396..e8e5afc 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -673,7 +673,6 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 	/* Reuse the page if possible. For notification packets and
 	 * SKBs that fail to Rx correctly, add them back into the
 	 * rx_free list for reuse later. */
-	spin_lock(&rxq->lock);
 	if (rxb->page != NULL) {
 		rxb->page_dma =
 			dma_map_page(trans->dev, rxb->page, 0,
@@ -694,7 +693,6 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		}
 	} else
 		list_add_tail(&rxb->list, &rxq->rx_used);
-	spin_unlock(&rxq->lock);
 }
 
 /*
@@ -709,6 +707,8 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans)
 	u32 count = 8;
 	int total_empty;
 
+restart:
+	spin_lock(&rxq->lock);
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
 	r = le16_to_cpu(ACCESS_ONCE(rxq->rb_stts->closed_rb_num)) & 0x0FFF;
@@ -743,18 +743,25 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans)
 			count++;
 			if (count >= 8) {
 				rxq->read = i;
+				spin_unlock(&rxq->lock);
 				iwl_pcie_rx_replenish_now(trans);
 				count = 0;
+				goto restart;
 			}
 		}
 	}
 
 	/* Backtrack one entry */
 	rxq->read = i;
+	spin_unlock(&rxq->lock);
+
 	if (fill_rx)
 		iwl_pcie_rx_replenish_now(trans);
 	else
 		iwl_pcie_rxq_restock(trans);
+
+	if (trans_pcie->napi.poll)
+		napi_gro_flush(&trans_pcie->napi, false);
 }
 
 /*
@@ -1068,8 +1075,6 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		iwl_write8(trans, CSR_INT_PERIODIC_REG,
 			    CSR_INT_PERIODIC_DIS);
 
-		iwl_pcie_rx_handle(trans);
-
 		/*
 		 * Enable periodic interrupt in 8 msec only if we received
 		 * real RX interrupt (instead of just periodic int), to catch
@@ -1082,6 +1087,10 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 				   CSR_INT_PERIODIC_ENA);
 
 		isr_stats->rx++;
+
+		local_bh_disable();
+		iwl_pcie_rx_handle(trans);
+		local_bh_enable();
 	}
 
 	/* This "Tx" DMA channel is used only for loading uCode */
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index dcfd6d8..97e6bd8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1053,6 +1053,12 @@ static void iwl_trans_pcie_write_prph(struct iwl_trans *trans, u32 addr,
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WDAT, val);
 }
 
+static int iwl_pcie_dummy_napi_poll(struct napi_struct *napi, int budget)
+{
+	WARN_ON(1);
+	return 0;
+}
+
 static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 				     const struct iwl_trans_config *trans_cfg)
 {
@@ -1079,6 +1085,18 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 
 	trans_pcie->command_names = trans_cfg->command_names;
 	trans_pcie->bc_table_dword = trans_cfg->bc_table_dword;
+
+	/* Initialize NAPI here - it should be before registering to mac80211
+	 * in the opmode but after the HW struct is allocated.
+	 * As this function may be called again in some corner cases don't
+	 * do anything if NAPI was already initialized.
+	 */
+	if (!trans_pcie->napi.poll && trans->op_mode->ops->napi_add) {
+		init_dummy_netdev(&trans_pcie->napi_dev);
+		iwl_op_mode_napi_add(trans->op_mode, &trans_pcie->napi,
+				     &trans_pcie->napi_dev,
+				     iwl_pcie_dummy_napi_poll, 64);
+	}
 }
 
 void iwl_trans_pcie_free(struct iwl_trans *trans)
@@ -1099,6 +1117,9 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	pci_disable_device(trans_pcie->pci_dev);
 	kmem_cache_destroy(trans->dev_cmd_pool);
 
+	if (trans_pcie->napi.poll)
+		netif_napi_del(&trans_pcie->napi);
+
 	kfree(trans);
 }
 
-- 
1.8.3.2

