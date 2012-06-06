Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab2FFNXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/29] iwlwifi: allocate Tx cmd pool per device
Date: Wed,  6 Jun 2012 15:22:02 +0200
Message-Id: <1338988930-11561-21-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152329_413630_26C87E6C)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Different transports will have different needs: New tranports
need headroom for their own use before the Tx cmd. So allocate
the Tx cmd pool in the transport and give it a unique name
based on dev_name.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/dev.h    |    2 --
 drivers/net/wireless/iwlwifi/dvm/main.c   |   22 ++++------------------
 drivers/net/wireless/iwlwifi/dvm/tx.c     |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-trans.h  |   29 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c |   19 +++++++++++++++++++
 5 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index af9de95..c29e637 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -1001,8 +1001,6 @@ struct iwl_priv {
 	enum iwl_ucode_type cur_ucode;
 }; /*iwl_priv */
 
-extern struct kmem_cache *iwl_tx_cmd_pool;
-
 static inline struct iwl_rxon_context *
 iwl_rxon_ctx_from_vif(struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 4411887..6cca1f4 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -2290,10 +2290,11 @@ void iwlagn_lift_passive_no_rx(struct iwl_priv *priv)
 
 static void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 {
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 	struct ieee80211_tx_info *info;
 
 	info = IEEE80211_SKB_CB(skb);
-	kmem_cache_free(iwl_tx_cmd_pool, (info->driver_data[1]));
+	iwl_trans_free_tx_cmd(priv->trans, info->driver_data[1]);
 	dev_kfree_skb_any(skb);
 }
 
@@ -2328,9 +2329,6 @@ const struct iwl_op_mode_ops iwl_dvm_ops = {
  * driver and module entry point
  *
  *****************************************************************************/
-
-struct kmem_cache *iwl_tx_cmd_pool;
-
 static int __init iwl_init(void)
 {
 
@@ -2338,29 +2336,18 @@ static int __init iwl_init(void)
 	pr_info(DRV_DESCRIPTION ", " DRV_VERSION "\n");
 	pr_info(DRV_COPYRIGHT "\n");
 
-	iwl_tx_cmd_pool = kmem_cache_create("iwl_dev_cmd",
-					    sizeof(struct iwl_device_cmd),
-					    sizeof(void *), 0, NULL);
-	if (!iwl_tx_cmd_pool)
-		return -ENOMEM;
-
 	ret = iwlagn_rate_control_register();
 	if (ret) {
 		pr_err("Unable to register rate control algorithm: %d\n", ret);
-		goto error_rc_register;
+		return ret;
 	}
 
 	ret = iwl_opmode_register("iwldvm", &iwl_dvm_ops);
 	if (ret) {
 		pr_err("Unable to register op_mode: %d\n", ret);
-		goto error_opmode_register;
+		iwlagn_rate_control_unregister();
 	}
-	return ret;
 
-error_opmode_register:
-	iwlagn_rate_control_unregister();
-error_rc_register:
-	kmem_cache_destroy(iwl_tx_cmd_pool);
 	return ret;
 }
 module_init(iwl_init);
@@ -2369,6 +2356,5 @@ static void __exit iwl_exit(void)
 {
 	iwl_opmode_deregister("iwldvm");
 	iwlagn_rate_control_unregister();
-	kmem_cache_destroy(iwl_tx_cmd_pool);
 }
 module_exit(iwl_exit);
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 7fdbd17..7e3bd62 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -295,7 +295,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_station_priv *sta_priv = NULL;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwl_device_cmd *dev_cmd = NULL;
+	struct iwl_device_cmd *dev_cmd;
 	struct iwl_tx_cmd *tx_cmd;
 	__le16 fc;
 	u8 hdr_len;
@@ -377,7 +377,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (info->flags & IEEE80211_TX_CTL_AMPDU)
 		is_agg = true;
 
-	dev_cmd = kmem_cache_alloc(iwl_tx_cmd_pool, GFP_ATOMIC);
+	dev_cmd = iwl_trans_alloc_tx_cmd(priv->trans);
 
 	if (unlikely(!dev_cmd))
 		goto drop_unlock_priv;
@@ -492,7 +492,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 drop_unlock_sta:
 	if (dev_cmd)
-		kmem_cache_free(iwl_tx_cmd_pool, dev_cmd);
+		iwl_trans_free_tx_cmd(priv->trans, dev_cmd);
 	spin_unlock(&priv->sta_lock);
 drop_unlock_priv:
 	return -1;
@@ -1193,8 +1193,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 
 			info = IEEE80211_SKB_CB(skb);
 			ctx = info->driver_data[0];
-			kmem_cache_free(iwl_tx_cmd_pool,
-					(info->driver_data[1]));
+			iwl_trans_free_tx_cmd(priv->trans,
+					      info->driver_data[1]);
 
 			memset(&info->status, 0, sizeof(info->status));
 
@@ -1357,7 +1357,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 			WARN_ON_ONCE(1);
 
 		info = IEEE80211_SKB_CB(skb);
-		kmem_cache_free(iwl_tx_cmd_pool, (info->driver_data[1]));
+		iwl_trans_free_tx_cmd(priv->trans, info->driver_data[1]);
 
 		if (freed == 1) {
 			/* this is the first skb we deliver in this batch */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 90ef0dc..00efde8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -433,6 +433,11 @@ enum iwl_trans_state {
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @pm_support: set to true in start_hw if link pm is supported
  * @wait_command_queue: the wait_queue for SYNC host commands
+ * @dev_cmd_pool: pool for Tx cmd allocation - for internal use only.
+ *	The user should use iwl_trans_{alloc,free}_tx_cmd.
+ * @dev_cmd_headroom: room needed for the transport's private use before the
+ *	device_cmd for Tx - for internal use only
+ *	The user should use iwl_trans_{alloc,free}_tx_cmd.
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
@@ -450,6 +455,10 @@ struct iwl_trans {
 
 	wait_queue_head_t wait_command_queue;
 
+	/* The following fields are internal only */
+	struct kmem_cache *dev_cmd_pool;
+	size_t dev_cmd_headroom;
+
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __aligned(sizeof(void *));
@@ -525,6 +534,26 @@ static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 	return trans->ops->send_cmd(trans, cmd);
 }
 
+static inline struct iwl_device_cmd *
+iwl_trans_alloc_tx_cmd(struct iwl_trans *trans)
+{
+	u8 *dev_cmd_ptr = kmem_cache_alloc(trans->dev_cmd_pool, GFP_ATOMIC);
+
+	if (unlikely(dev_cmd_ptr == NULL))
+		return NULL;
+
+	return (struct iwl_device_cmd *)
+			(dev_cmd_ptr + trans->dev_cmd_headroom);
+}
+
+static inline void iwl_trans_free_tx_cmd(struct iwl_trans *trans,
+					 struct iwl_device_cmd *dev_cmd)
+{
+	u8 *dev_cmd_ptr = (u8 *)dev_cmd - trans->dev_cmd_headroom;
+
+	kmem_cache_free(trans->dev_cmd_pool, dev_cmd_ptr);
+}
+
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			       struct iwl_device_cmd *dev_cmd, int queue)
 {
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 0f59e1f..1eabb83 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1528,6 +1528,7 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	iounmap(trans_pcie->hw_base);
 	pci_release_regions(trans_pcie->pci_dev);
 	pci_disable_device(trans_pcie->pci_dev);
+	kmem_cache_destroy(trans->dev_cmd_pool);
 
 	kfree(trans);
 }
@@ -2042,6 +2043,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 {
 	struct iwl_trans_pcie *trans_pcie;
 	struct iwl_trans *trans;
+	char cmd_pool_name[100];
 	u16 pci_cmd;
 	int err;
 
@@ -2138,8 +2140,25 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	init_waitqueue_head(&trans->wait_command_queue);
 	spin_lock_init(&trans->reg_lock);
 
+	snprintf(cmd_pool_name, sizeof(cmd_pool_name), "iwl_cmd_pool:%s",
+		 dev_name(trans->dev));
+
+	trans->dev_cmd_headroom = 0;
+	trans->dev_cmd_pool =
+		kmem_cache_create(cmd_pool_name,
+				  sizeof(struct iwl_device_cmd)
+				  + trans->dev_cmd_headroom,
+				  sizeof(void *),
+				  SLAB_HWCACHE_ALIGN,
+				  NULL);
+
+	if (!trans->dev_cmd_pool)
+		goto out_pci_disable_msi;
+
 	return trans;
 
+out_pci_disable_msi:
+	pci_disable_msi(pdev);
 out_pci_release_regions:
 	pci_release_regions(pdev);
 out_pci_disable_device:
-- 
1.7.10

