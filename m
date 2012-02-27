Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab2B0NwO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 08:52:14 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -iwlwifi] iwlwifi: make tx_cmd_pool kmem cache global
Date: Mon, 27 Feb 2012 14:52:05 +0100
Message-Id: <1330350725-5815-1-git-send-email-sgruszka@redhat.com> (sfid-20120227_145218_640279_81755758)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise we are not able to run more than one device per driver:

[   24.743045] kmem_cache_create: duplicate cache iwl_dev_cmd
[   24.743051] Pid: 3165, comm: NetworkManager Not tainted 3.3.0-rc2-wl+ #5
[   24.743054] Call Trace:
[   24.743066]  [<ffffffff811717d5>] kmem_cache_create+0x655/0x700
[   24.743073]  [<ffffffff81061415>] ? destroy_timer_on_stack+0x15/0x20
[   24.743079]  [<ffffffff814e26ed>] ? schedule_timeout+0x1dd/0x330
[   24.743083]  [<ffffffff810617c0>] ? lock_timer_base+0x70/0x70
[   24.743101]  [<ffffffffa03b9f8b>] iwl_alive_notify+0x1cb/0x1f0 [iwlwifi]
[   24.743111]  [<ffffffffa03ba442>] iwl_load_ucode_wait_alive+0x1b2/0x220 [iwlwifi]
[   24.743118]  [<ffffffff810b1fbd>] ? trace_hardirqs_on+0xd/0x10
[   24.743127]  [<ffffffffa03b9700>] ? iwlagn_mac_setup_register+0x2e0/0x2e0 [iwlwifi]
[   24.743133]  [<ffffffff814e60b4>] ? _raw_spin_unlock_bh+0x34/0x40
[   24.743142]  [<ffffffffa03ba893>] iwl_run_init_ucode+0x73/0x100 [iwlwifi]
[   24.743152]  [<ffffffffa03b8fa1>] __iwl_up+0x81/0x220 [iwlwifi]
[   24.743161]  [<ffffffffa03b91c0>] iwlagn_mac_start+0x80/0x190 [iwlwifi]
[   24.743188]  [<ffffffffa03307b3>] ieee80211_do_open+0x293/0x770 [mac80211]

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
I tested patch on wireless testing tree, and then rebased to -iwlwifi
tree, where did compile check only. This is basically a bugfix, but
seems nobody except me (*) use more than one iwlwifi device per system,
so I do not cc stable. 

(*) I wonder why Intel developers do not run many devices in their
systems. I think they should - one new device and a few older. Then
perhaps we will stop seeing so many breakage on older devices caused
by adding support for new hardware and features.

 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   21 +++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.c   |    3 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c  |    9 ---------
 5 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index a7cc0c0..5c00aa7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -334,7 +334,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (info->flags & IEEE80211_TX_CTL_AMPDU)
 		is_agg = true;
 
-	dev_cmd = kmem_cache_alloc(priv->tx_cmd_pool, GFP_ATOMIC);
+	dev_cmd = kmem_cache_alloc(iwl_tx_cmd_pool, GFP_ATOMIC);
 
 	if (unlikely(!dev_cmd))
 		goto drop_unlock_priv;
@@ -425,7 +425,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 drop_unlock_sta:
 	if (dev_cmd)
-		kmem_cache_free(priv->tx_cmd_pool, dev_cmd);
+		kmem_cache_free(iwl_tx_cmd_pool, dev_cmd);
 	spin_unlock(&priv->sta_lock);
 drop_unlock_priv:
 	return -1;
@@ -1045,7 +1045,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 
 			info = IEEE80211_SKB_CB(skb);
 			ctx = info->driver_data[0];
-			kmem_cache_free(priv->tx_cmd_pool,
+			kmem_cache_free(iwl_tx_cmd_pool,
 					(info->driver_data[1]));
 
 			memset(&info->status, 0, sizeof(info->status));
@@ -1192,7 +1192,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 			WARN_ON_ONCE(1);
 
 		info = IEEE80211_SKB_CB(skb);
-		kmem_cache_free(priv->tx_cmd_pool, (info->driver_data[1]));
+		kmem_cache_free(iwl_tx_cmd_pool, (info->driver_data[1]));
 
 		if (freed == 1) {
 			/* this is the first skb we deliver in this batch */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index dcfc12c..025feae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1099,8 +1099,6 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 {
 	iwl_free_geos(priv);
 	iwl_free_channel_map(priv);
-	if (priv->tx_cmd_pool)
-		kmem_cache_destroy(priv->tx_cmd_pool);
 	kfree(priv->scan_cmd);
 	kfree(priv->beacon_cmd);
 	kfree(rcu_dereference_raw(priv->noa_data));
@@ -1419,6 +1417,9 @@ const struct iwl_op_mode_ops iwl_dvm_ops = {
  * driver and module entry point
  *
  *****************************************************************************/
+
+struct kmem_cache *iwl_tx_cmd_pool;
+
 static int __init iwl_init(void)
 {
 
@@ -1426,20 +1427,27 @@ static int __init iwl_init(void)
 	pr_info(DRV_DESCRIPTION ", " DRV_VERSION "\n");
 	pr_info(DRV_COPYRIGHT "\n");
 
+	iwl_tx_cmd_pool = kmem_cache_create("iwl_dev_cmd",
+					    sizeof(struct iwl_device_cmd),
+					    sizeof(void *), 0, NULL);
+	if (!iwl_tx_cmd_pool)
+		return -ENOMEM;
+
 	ret = iwlagn_rate_control_register();
 	if (ret) {
 		pr_err("Unable to register rate control algorithm: %d\n", ret);
-		return ret;
+		goto error_rc_register;
 	}
 
 	ret = iwl_pci_register_driver();
-
 	if (ret)
-		goto error_register;
+		goto error_pci_register;
 	return ret;
 
-error_register:
+error_pci_register:
 	iwlagn_rate_control_unregister();
+error_rc_register:
+	kmem_cache_destroy(iwl_tx_cmd_pool);
 	return ret;
 }
 
@@ -1447,6 +1455,7 @@ static void __exit iwl_exit(void)
 {
 	iwl_pci_unregister_driver();
 	iwlagn_rate_control_unregister();
+	kmem_cache_destroy(iwl_tx_cmd_pool);
 }
 
 module_exit(iwl_exit);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c3a9e6e..bc9b3b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1482,11 +1482,10 @@ void iwl_nic_config(struct iwl_priv *priv)
 
 void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 {
-	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 	struct ieee80211_tx_info *info;
 
 	info = IEEE80211_SKB_CB(skb);
-	kmem_cache_free(priv->tx_cmd_pool, (info->driver_data[1]));
+	kmem_cache_free(iwl_tx_cmd_pool, (info->driver_data[1]));
 	dev_kfree_skb_any(skb);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9ea9002..a9551cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -722,7 +722,6 @@ struct iwl_priv {
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
-	struct kmem_cache *tx_cmd_pool;
 
 	struct workqueue_struct *workqueue;
 
@@ -968,6 +967,7 @@ struct iwl_priv {
 	bool have_rekey_data;
 }; /*iwl_priv */
 
+extern struct kmem_cache *iwl_tx_cmd_pool;
 extern struct iwl_mod_params iwlagn_mod_params;
 
 static inline struct iwl_rxon_context *
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index b16efc0..7251e81 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -366,15 +366,6 @@ static int iwl_alive_notify(struct iwl_trans *trans)
 	struct iwl_rxon_context *ctx;
 	int ret;
 
-	if (!priv->tx_cmd_pool)
-		priv->tx_cmd_pool =
-			kmem_cache_create("iwl_dev_cmd",
-					  sizeof(struct iwl_device_cmd),
-					  sizeof(void *), 0, NULL);
-
-	if (!priv->tx_cmd_pool)
-		return -ENOMEM;
-
 	iwl_trans_fw_alive(trans);
 	for_each_context(priv, ctx)
 		ctx->last_tx_rejected = false;
-- 
1.7.1

