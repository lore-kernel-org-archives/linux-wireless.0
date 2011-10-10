Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15881 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1JJPQa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 26/34] iwlagn: rename all the mac80211 callback functions
Date: Mon, 10 Oct 2011 07:27:11 -0700
Message-Id: <1318256839-31837-27-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171647_190266_1756ED34)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the same calling style for all the mac80211 callback functions

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   56 +++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-agn.h        |   14 ++++---
 drivers/net/wireless/iwlwifi/iwl-core.c       |   16 ++++---
 drivers/net/wireless/iwlwifi/iwl-core.h       |   12 +++---
 drivers/net/wireless/iwlwifi/iwl-rx.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    5 +-
 12 files changed, 63 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 14b4c5a..e88aca5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -239,7 +239,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 {
 	/*
 	 * MULTI-FIXME
-	 * See iwl_mac_channel_switch.
+	 * See iwlagn_mac_channel_switch.
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl5000_channel_switch_cmd cmd;
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 8e3cdd9..4abfcf2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -187,7 +187,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 {
 	/*
 	 * MULTI-FIXME
-	 * See iwl_mac_channel_switch.
+	 * See iwlagn_mac_channel_switch.
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl6000_channel_switch_cmd cmd;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index dccb230..6c57199 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -565,7 +565,7 @@ struct iwlagn_ucode_capabilities {
 };
 
 static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
-static int iwl_mac_setup_register(struct iwl_priv *priv,
+static int iwlagn_mac_setup_register(struct iwl_priv *priv,
 				  struct iwlagn_ucode_capabilities *capa);
 
 #define UCODE_EXPERIMENTAL_INDEX	100
@@ -1136,7 +1136,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 *
 	 * 9. Setup and register with mac80211 and debugfs
 	 **************************************************/
-	err = iwl_mac_setup_register(priv, &ucode_capa);
+	err = iwlagn_mac_setup_register(priv, &ucode_capa);
 	if (err)
 		goto out_unbind;
 
@@ -1642,7 +1642,7 @@ iwlagn_iface_combinations_p2p[] = {
  * Not a mac80211 entry point function, but it fits in with all the
  * other mac80211 functions grouped here.
  */
-static int iwl_mac_setup_register(struct iwl_priv *priv,
+static int iwlagn_mac_setup_register(struct iwl_priv *priv,
 				  struct iwlagn_ucode_capabilities *capa)
 {
 	int ret;
@@ -2761,7 +2761,7 @@ static void iwlagn_disable_roc_work(struct work_struct *work)
 	mutex_unlock(&priv->shrd->mutex);
 }
 
-static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
+static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 				     struct ieee80211_channel *channel,
 				     enum nl80211_channel_type channel_type,
 				     int duration)
@@ -2825,7 +2825,7 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 	return err;
 }
 
-static int iwl_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
+static int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -2842,8 +2842,10 @@ static int iwl_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static int iwl_mac_tx_sync(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			   const u8 *bssid, enum ieee80211_tx_sync_type type)
+static int iwlagn_mac_tx_sync(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      const u8 *bssid,
+			      enum ieee80211_tx_sync_type type)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
@@ -2890,7 +2892,7 @@ static int iwl_mac_tx_sync(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return ret;
 }
 
-static void iwl_mac_finish_tx_sync(struct ieee80211_hw *hw,
+static void iwlagn_mac_finish_tx_sync(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   const u8 *bssid,
 				   enum ieee80211_tx_sync_type type)
@@ -3067,7 +3069,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 #endif
 }
 
-static void iwl_mac_rssi_callback(struct ieee80211_hw *hw,
+static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
 			   enum ieee80211_rssi_event rssi_event)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -3092,7 +3094,7 @@ static void iwl_mac_rssi_callback(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static int iwl_mac_set_tim(struct ieee80211_hw *hw,
+static int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *sta, bool set)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -3110,32 +3112,32 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.suspend = iwlagn_mac_suspend,
 	.resume = iwlagn_mac_resume,
 #endif
-	.add_interface = iwl_mac_add_interface,
-	.remove_interface = iwl_mac_remove_interface,
-	.change_interface = iwl_mac_change_interface,
+	.add_interface = iwlagn_mac_add_interface,
+	.remove_interface = iwlagn_mac_remove_interface,
+	.change_interface = iwlagn_mac_change_interface,
 	.config = iwlagn_mac_config,
 	.configure_filter = iwlagn_configure_filter,
 	.set_key = iwlagn_mac_set_key,
 	.update_tkip_key = iwlagn_mac_update_tkip_key,
 	.set_rekey_data = iwlagn_mac_set_rekey_data,
-	.conf_tx = iwl_mac_conf_tx,
+	.conf_tx = iwlagn_mac_conf_tx,
 	.bss_info_changed = iwlagn_bss_info_changed,
 	.ampdu_action = iwlagn_mac_ampdu_action,
-	.hw_scan = iwl_mac_hw_scan,
+	.hw_scan = iwlagn_mac_hw_scan,
 	.sta_notify = iwlagn_mac_sta_notify,
 	.sta_add = iwlagn_mac_sta_add,
-	.sta_remove = iwl_mac_sta_remove,
+	.sta_remove = iwlagn_mac_sta_remove,
 	.channel_switch = iwlagn_mac_channel_switch,
 	.flush = iwlagn_mac_flush,
-	.tx_last_beacon = iwl_mac_tx_last_beacon,
-	.remain_on_channel = iwl_mac_remain_on_channel,
-	.cancel_remain_on_channel = iwl_mac_cancel_remain_on_channel,
-	.rssi_callback = iwl_mac_rssi_callback,
-	CFG80211_TESTMODE_CMD(iwl_testmode_cmd)
-	CFG80211_TESTMODE_DUMP(iwl_testmode_dump)
-	.tx_sync = iwl_mac_tx_sync,
-	.finish_tx_sync = iwl_mac_finish_tx_sync,
-	.set_tim = iwl_mac_set_tim,
+	.tx_last_beacon = iwlagn_mac_tx_last_beacon,
+	.remain_on_channel = iwlagn_mac_remain_on_channel,
+	.cancel_remain_on_channel = iwlagn_mac_cancel_remain_on_channel,
+	.rssi_callback = iwlagn_mac_rssi_callback,
+	CFG80211_TESTMODE_CMD(iwlagn_mac_testmode_cmd)
+	CFG80211_TESTMODE_DUMP(iwlagn_mac_testmode_dump)
+	.tx_sync = iwlagn_mac_tx_sync,
+	.finish_tx_sync = iwlagn_mac_finish_tx_sync,
+	.set_tim = iwlagn_mac_set_tim,
 };
 
 static u32 iwl_hw_detect(struct iwl_priv *priv)
@@ -3378,7 +3380,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 
 	iwl_dbgfs_unregister(priv);
 
-	/* ieee80211_unregister_hw call wil cause iwl_mac_stop to
+	/* ieee80211_unregister_hw call wil cause iwlagn_mac_stop to
 	 * to be called and iwl_down since we are removing the device
 	 * we need to set STATUS_EXIT_PENDING bit.
 	 */
@@ -3404,7 +3406,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->shrd->workqueue);
 
-	/* ieee80211_unregister_hw calls iwl_mac_stop, which flushes
+	/* ieee80211_unregister_hw calls iwlagn_mac_stop, which flushes
 	 * priv->shrd->workqueue... so we can't take down the workqueue
 	 * until now... */
 	destroy_workqueue(priv->shrd->workqueue);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 2a297d1..a8df7eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -252,20 +252,22 @@ extern int iwlagn_init_alive_start(struct iwl_priv *priv);
 extern int iwl_alive_start(struct iwl_priv *priv);
 /* svtool */
 #ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
-extern int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len);
-extern int iwl_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
-			     struct netlink_callback *cb,
-			     void *data, int len);
+extern int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data,
+				   int len);
+extern int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw,
+				    struct sk_buff *skb,
+				    struct netlink_callback *cb,
+				    void *data, int len);
 extern void iwl_testmode_init(struct iwl_priv *priv);
 extern void iwl_testmode_cleanup(struct iwl_priv *priv);
 #else
 static inline
-int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
+int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 {
 	return -ENOSYS;
 }
 static inline
-int iwl_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
+int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 		      struct netlink_callback *cb,
 		      void *data, int len)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 20e56ec..f800756 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -804,7 +804,7 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 {
 	/*
 	 * MULTI-FIXME
-	 * See iwl_mac_channel_switch.
+	 * See iwlagn_mac_channel_switch.
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
@@ -1123,7 +1123,7 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 					&statistics_cmd);
 }
 
-int iwl_mac_conf_tx(struct ieee80211_hw *hw,
+int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif, u16 queue,
 		    const struct ieee80211_tx_queue_params *params)
 {
@@ -1170,7 +1170,7 @@ int iwl_mac_conf_tx(struct ieee80211_hw *hw,
 	return 0;
 }
 
-int iwl_mac_tx_last_beacon(struct ieee80211_hw *hw)
+int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -1223,7 +1223,8 @@ static int iwl_setup_interface(struct iwl_priv *priv,
 	return 0;
 }
 
-int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
@@ -1319,7 +1320,7 @@ static void iwl_teardown_interface(struct iwl_priv *priv,
 		priv->bt_traffic_load = priv->last_bt_traffic_load;
 }
 
-void iwl_mac_remove_interface(struct ieee80211_hw *hw,
+void iwlagn_mac_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -1651,8 +1652,9 @@ int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
 	return 0;
 }
 
-int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			     enum nl80211_iftype newtype, bool newp2p)
+int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				enum nl80211_iftype newtype, bool newp2p)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 080c355..151cc43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -236,10 +236,10 @@ struct iwl_cfg {
  *   L i b                 *
  ***************************/
 
-int iwl_mac_conf_tx(struct ieee80211_hw *hw,
+int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif, u16 queue,
 		    const struct ieee80211_tx_queue_params *params);
-int iwl_mac_tx_last_beacon(struct ieee80211_hw *hw);
+int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw);
 void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   int hw_decrypt);
 int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
@@ -259,11 +259,11 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
 				   struct iwl_rxon_context *ctx);
 void iwl_set_rate(struct iwl_priv *priv);
-int iwl_mac_add_interface(struct ieee80211_hw *hw,
+int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif);
-void iwl_mac_remove_interface(struct ieee80211_hw *hw,
+void iwlagn_mac_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif);
-int iwl_mac_change_interface(struct ieee80211_hw *hw,
+int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     enum nl80211_iftype newtype, bool newp2p);
 int iwl_cmd_echo_test(struct iwl_priv *priv);
@@ -322,7 +322,7 @@ void iwl_init_scan_params(struct iwl_priv *priv);
 int iwl_scan_cancel(struct iwl_priv *priv);
 void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 void iwl_force_scan_end(struct iwl_priv *priv);
-int iwl_mac_hw_scan(struct ieee80211_hw *hw,
+int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    struct cfg80211_scan_request *req);
 void iwl_internal_short_hw_scan(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 1d781bc..2581c3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -154,7 +154,7 @@ static int iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
 	/*
 	 * MULTI-FIXME
-	 * See iwl_mac_channel_switch.
+	 * See iwlagn_mac_channel_switch.
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl_rxon_cmd *rxon = (void *)&ctx->active;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index c5c95d5..55f1f86 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -940,7 +940,7 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 	return 0;
 }
 
-int iwl_mac_hw_scan(struct ieee80211_hw *hw,
+int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    struct cfg80211_scan_request *req)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 07b72f2..586007e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -815,7 +815,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	return ret;
 }
 
-int iwl_mac_sta_remove(struct ieee80211_hw *hw,
+int iwlagn_mac_sta_remove(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index b86c893..73b4af2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -52,7 +52,7 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   struct ieee80211_sta *sta, u8 *sta_id_r);
 int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 		       const u8 *addr);
-int iwl_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+int iwlagn_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
 
 u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 1d1622d..5e50d88 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -641,7 +641,7 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
  * @data: pointer to user space message
  * @len: length in byte of @data
  */
-int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
+int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 {
 	struct nlattr *tb[IWL_TM_ATTR_MAX];
 	struct iwl_priv *priv = hw->priv;
@@ -706,7 +706,7 @@ int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	return result;
 }
 
-int iwl_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
+int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 		      struct netlink_callback *cb,
 		      void *data, int len)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 2abd07f..8e8c75c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1372,8 +1372,9 @@ static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
 {
 	/*
 	 * This function is called when system goes into suspend state
-	 * mac80211 will call iwl_mac_stop() from the mac80211 suspend function
-	 * first but since iwl_mac_stop() has no knowledge of who the caller is,
+	 * mac80211 will call iwlagn_mac_stop() from the mac80211 suspend
+	 * function first but since iwlagn_mac_stop() has no knowledge of
+	 * who the caller is,
 	 * it will not call apm_ops.stop() to stop the DMA operation.
 	 * Calling apm_ops.stop here to make sure we stop the DMA.
 	 *
-- 
1.7.0.4

