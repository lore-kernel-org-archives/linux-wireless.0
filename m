Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934481Ab1IOTcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:04 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/27] iwlagn: move iwl_stop / wake_queue to the upper layer
Date: Thu, 15 Sep 2011 11:46:31 -0700
Message-Id: <1316112414-6341-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213209_249098_42C530A1)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Add a wrapper in the upper layer to call the mac80211's function.
This allows not to have the transport layer call mac80211 directly.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    9 ++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c           |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    2 ++
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    9 +++------
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   10 ++--------
 6 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 92ba8cd..495f936 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -209,7 +209,7 @@ static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
 {
 	if (stop) {
 		IWL_DEBUG_TEMP(priv, "Stop all queues\n");
-		if (priv->shrd->mac80211_registered)
+		if (priv->mac80211_registered)
 			ieee80211_stop_queues(priv->hw);
 		IWL_DEBUG_TEMP(priv,
 				"Schedule 5 seconds CT_KILL Timer\n");
@@ -217,7 +217,7 @@ static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
 			  jiffies + CT_KILL_EXIT_DURATION * HZ);
 	} else {
 		IWL_DEBUG_TEMP(priv, "Wake all queues\n");
-		if (priv->shrd->mac80211_registered)
+		if (priv->mac80211_registered)
 			ieee80211_wake_queues(priv->hw);
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1142d85..61f8ea6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1519,7 +1519,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		clear_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
 
-	if (priv->shrd->mac80211_registered)
+	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
 	iwl_trans_stop_device(trans(priv));
@@ -1863,7 +1863,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 		IWL_ERR(priv, "Failed to register hw (error %d)\n", ret);
 		return ret;
 	}
-	priv->shrd->mac80211_registered = 1;
+	priv->mac80211_registered = 1;
 
 	return 0;
 }
@@ -3311,7 +3311,6 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	priv->shrd = &priv->_shrd;
 	priv->shrd->bus = bus;
 	priv->shrd->priv = priv;
-	priv->shrd->hw = hw;
 	bus_set_drv_data(priv->bus, priv->shrd);
 
 	priv->shrd->trans = trans_ops->alloc(priv->shrd);
@@ -3487,9 +3486,9 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	iwl_testmode_cleanup(priv);
 	iwl_leds_exit(priv);
 
-	if (priv->shrd->mac80211_registered) {
+	if (priv->mac80211_registered) {
 		ieee80211_unregister_hw(priv->hw);
-		priv->shrd->mac80211_registered = 0;
+		priv->mac80211_registered = 0;
 	}
 
 	iwl_tt_exit(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5e490db..208ca21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1885,3 +1885,13 @@ void iwl_free_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	kmem_cache_free(priv->tx_cmd_pool, (info->driver_data[1]));
 	dev_kfree_skb_any(skb);
 }
+
+void iwl_stop_sw_queue(struct iwl_priv *priv, u8 ac)
+{
+	ieee80211_stop_queue(priv->hw, ac);
+}
+
+void iwl_wake_sw_queue(struct iwl_priv *priv, u8 ac)
+{
+	ieee80211_wake_queue(priv->hw, ac);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8438a33..f69e556 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -958,6 +958,8 @@ struct iwl_priv {
 	struct iwl_station_entry stations[IWLAGN_STATION_COUNT];
 	unsigned long ucode_key_table;
 
+	u8 mac80211_registered;
+
 	/* Indication if ieee80211_ops->open has been called */
 	u8 is_open;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index bdfbc60..0f15d58 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -246,12 +246,6 @@ struct iwl_shared {
 	spinlock_t sta_lock;
 	struct mutex mutex;
 
-	/*these 2 shouldn't really be here, but they are needed for
-	 * iwl_queue_stop, which is called from the upper layer too
-	 */
-	u8 mac80211_registered;
-	struct ieee80211_hw *hw;
-
 	struct iwl_tid_data tid_data[IWLAGN_STATION_COUNT][IWL_MAX_TID_COUNT];
 
 	wait_queue_head_t wait_command_queue;
@@ -397,6 +391,9 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
 const char *get_cmd_string(u8 cmd);
 bool iwl_check_for_ct_kill(struct iwl_priv *priv);
 
+void iwl_stop_sw_queue(struct iwl_priv *priv, u8 ac);
+void iwl_wake_sw_queue(struct iwl_priv *priv, u8 ac);
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 void iwl_reset_traffic_log(struct iwl_priv *priv);
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index fc33754..49cd5a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -375,12 +375,9 @@ static inline void iwl_wake_queue(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	if (unlikely(!trans->shrd->mac80211_registered))
-		return;
-
 	if (test_and_clear_bit(hwq, trans_pcie->queue_stopped))
 		if (atomic_dec_return(&trans_pcie->queue_stop_count[ac]) <= 0)
-			ieee80211_wake_queue(trans->shrd->hw, ac);
+			iwl_wake_sw_queue(priv(trans), ac);
 }
 
 static inline void iwl_stop_queue(struct iwl_trans *trans,
@@ -392,12 +389,9 @@ static inline void iwl_stop_queue(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	if (unlikely(!trans->shrd->mac80211_registered))
-		return;
-
 	if (!test_and_set_bit(hwq, trans_pcie->queue_stopped))
 		if (atomic_inc_return(&trans_pcie->queue_stop_count[ac]) > 0)
-			ieee80211_stop_queue(trans->shrd->hw, ac);
+			iwl_stop_sw_queue(priv(trans), ac);
 }
 
 #ifdef ieee80211_stop_queue
-- 
1.7.0.4

