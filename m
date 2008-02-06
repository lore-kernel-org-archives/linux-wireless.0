Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40832 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbYBFTUm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 14:20:42 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/3] iwlwifi: remove IWL{4965,3945}_QOS
Date: Wed,  6 Feb 2008 11:20:39 -0800
Message-Id: <1202325640-9577-3-git-send-email-reinette.chatre@intel.com> (sfid-20080206_192052_884050_A42567C1)
In-Reply-To: <1202325640-9577-2-git-send-email-reinette.chatre@intel.com>
References: <1202325640-9577-1-git-send-email-reinette.chatre@intel.com>
 <1202325640-9577-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch removes the IWL4965_QOS and IWL3945_QOS defines from Kconfig
file along with all uses of it. These defines were relevant for the
period QoS code was tested to be stable in driver's flows.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |   16 +---------------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    5 -----
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    5 -----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   17 ++---------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   18 +-----------------
 5 files changed, 4 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 9c3fe18..24c3e3d 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -24,17 +24,10 @@ config IWL4965
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl4965.ko.
 
-config IWL4965_QOS
-	bool "Enable Wireless QoS in iwl4965 driver"
-	depends on IWL4965
-	---help---
-	  This option will enable wireless quality of service (QoS) for the
-	  iwl4965 driver.
-
 config IWL4965_HT
 	bool "Enable 802.11n HT features in iwl4965 driver"
 	depends on EXPERIMENTAL
-	depends on IWL4965 && IWL4965_QOS
+	depends on IWL4965
 	---help---
 	  This option enables IEEE 802.11n High Throughput features
 	  for the iwl4965 driver.
@@ -104,13 +97,6 @@ config IWL3945
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl3945.ko.
 
-config IWL3945_QOS
-	bool "Enable Wireless QoS in iwl3945 driver"
-	depends on IWL3945
-	---help---
-	  This option will enable wireless quality of service (QoS) for the
-	  iwl3945 driver.
-
 config IWL3945_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwl3945 drivers"
 	depends on IWL3945
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 1beb5b6..393cff6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -431,8 +431,6 @@ union iwl3945_ht_rate_supp {
 	};
 };
 
-#ifdef CONFIG_IWL3945_QOS
-
 union iwl3945_qos_capabity {
 	struct {
 		u8 edca_count:4;	/* bit 0-3 */
@@ -460,7 +458,6 @@ struct iwl3945_qos_info {
 	union iwl3945_qos_capabity qos_cap;
 	struct iwl3945_qosparam_cmd def_qos_parm;
 };
-#endif /*CONFIG_IWL3945_QOS */
 
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
@@ -869,9 +866,7 @@ struct iwl3945_priv {
 	u16 assoc_capability;
 	u8 ps_mode;
 
-#ifdef CONFIG_IWL3945_QOS
 	struct iwl3945_qos_info qos_data;
-#endif /*CONFIG_IWL3945_QOS */
 
 	struct workqueue_struct *workqueue;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 45cf483..67189ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -510,8 +510,6 @@ struct iwl_ht_info {
 };
 #endif				/*CONFIG_IWL4965_HT */
 
-#ifdef CONFIG_IWL4965_QOS
-
 union iwl4965_qos_capabity {
 	struct {
 		u8 edca_count:4;	/* bit 0-3 */
@@ -539,7 +537,6 @@ struct iwl4965_qos_info {
 	union iwl4965_qos_capabity qos_cap;
 	struct iwl4965_qosparam_cmd def_qos_parm;
 };
-#endif /*CONFIG_IWL4965_QOS */
 
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
@@ -1173,9 +1170,7 @@ struct iwl4965_priv {
 	u16 assoc_capability;
 	u8 ps_mode;
 
-#ifdef CONFIG_IWL4965_QOS
 	struct iwl4965_qos_info qos_data;
-#endif /*CONFIG_IWL4965_QOS */
 
 	struct workqueue_struct *workqueue;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6002326..3216167 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1904,7 +1904,6 @@ static u16 iwl3945_fill_probe_req(struct iwl3945_priv *priv,
 /*
  * QoS  support
 */
-#ifdef CONFIG_IWL3945_QOS
 static int iwl3945_send_qos_params_command(struct iwl3945_priv *priv,
 				       struct iwl3945_qosparam_cmd *qos)
 {
@@ -2033,7 +2032,6 @@ static void iwl3945_activate_qos(struct iwl3945_priv *priv, u8 force)
 	}
 }
 
-#endif /* CONFIG_IWL3945_QOS */
 /*
  * Power management (not Tx power!) functions
  */
@@ -6763,9 +6761,8 @@ static void iwl3945_bg_post_associate(struct work_struct *data)
 
 	iwl3945_sequence_reset(priv);
 
-#ifdef CONFIG_IWL3945_QOS
 	iwl3945_activate_qos(priv, 0);
-#endif /* CONFIG_IWL3945_QOS */
+
 	/* we have just associated, don't start scan too early */
 	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 	mutex_unlock(&priv->mutex);
@@ -7410,10 +7407,8 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl3945_priv *priv = hw->priv;
-#ifdef CONFIG_IWL3945_QOS
 	unsigned long flags;
 	int q;
-#endif /* CONFIG_IWL3945_QOS */
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7427,7 +7422,6 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 		return 0;
 	}
 
-#ifdef CONFIG_IWL3945_QOS
 	if (!priv->qos_data.qos_enable) {
 		priv->qos_data.qos_active = 0;
 		IWL_DEBUG_MAC80211("leave - qos not enabled\n");
@@ -7456,8 +7450,6 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 
 	mutex_unlock(&priv->mutex);
 
-#endif /*CONFIG_IWL3945_QOS */
-
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
 }
@@ -7522,9 +7514,8 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter\n");
 
-#ifdef CONFIG_IWL3945_QOS
 	iwl3945_reset_qos(priv);
-#endif
+
 	cancel_delayed_work(&priv->post_associate);
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -7612,9 +7603,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 	IWL_DEBUG_MAC80211("leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-#ifdef CONFIG_IWL3945_QOS
 	iwl3945_reset_qos(priv);
-#endif
 
 	queue_work(priv->workqueue, &priv->post_associate.work);
 
@@ -8402,7 +8391,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		goto out_iounmap;
 	}
 
-#ifdef CONFIG_IWL3945_QOS
 	if (iwl3945_param_qos_enable)
 		priv->qos_data.qos_enable = 1;
 
@@ -8410,7 +8398,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
-#endif /* CONFIG_IWL3945_QOS */
 
 	iwl3945_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
 	iwl3945_setup_deferred_work(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 110968e..846dc16 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2009,7 +2009,6 @@ static u16 iwl4965_fill_probe_req(struct iwl4965_priv *priv,
 /*
  * QoS  support
 */
-#ifdef CONFIG_IWL4965_QOS
 static int iwl4965_send_qos_params_command(struct iwl4965_priv *priv,
 				       struct iwl4965_qosparam_cmd *qos)
 {
@@ -2143,7 +2142,6 @@ static void iwl4965_activate_qos(struct iwl4965_priv *priv, u8 force)
 	}
 }
 
-#endif /* CONFIG_IWL4965_QOS */
 /*
  * Power management (not Tx power!) functions
  */
@@ -7195,9 +7193,8 @@ static void iwl4965_bg_post_associate(struct work_struct *data)
 	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
 		priv->assoc_station_added = 1;
 
-#ifdef CONFIG_IWL4965_QOS
 	iwl4965_activate_qos(priv, 0);
-#endif /* CONFIG_IWL4965_QOS */
+
 	/* we have just associated, don't start scan too early */
 	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 	mutex_unlock(&priv->mutex);
@@ -7572,9 +7569,7 @@ static void iwl4965_config_ap(struct iwl4965_priv *priv)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwl4965_commit_rxon(priv);
-#ifdef CONFIG_IWL4965_QOS
 		iwl4965_activate_qos(priv, 1);
-#endif
 		iwl4965_rxon_add_station(priv, iwl4965_broadcast_addr, 0);
 	}
 	iwl4965_send_beacon_cmd(priv);
@@ -7888,10 +7883,8 @@ static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl4965_priv *priv = hw->priv;
-#ifdef CONFIG_IWL4965_QOS
 	unsigned long flags;
 	int q;
-#endif /* CONFIG_IWL4965_QOS */
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7905,7 +7898,6 @@ static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 		return 0;
 	}
 
-#ifdef CONFIG_IWL4965_QOS
 	if (!priv->qos_data.qos_enable) {
 		priv->qos_data.qos_active = 0;
 		IWL_DEBUG_MAC80211("leave - qos not enabled\n");
@@ -7934,8 +7926,6 @@ static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 
 	mutex_unlock(&priv->mutex);
 
-#endif /*CONFIG_IWL4965_QOS */
-
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
 }
@@ -8007,9 +7997,7 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	spin_unlock_irqrestore(&priv->lock, flags);
 #endif /* CONFIG_IWL4965_HT */
 
-#ifdef CONFIG_IWL4965_QOS
 	iwl4965_reset_qos(priv);
-#endif
 
 	cancel_delayed_work(&priv->post_associate);
 
@@ -8098,9 +8086,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 	IWL_DEBUG_MAC80211("leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-#ifdef CONFIG_IWL4965_QOS
 	iwl4965_reset_qos(priv);
-#endif
 
 	queue_work(priv->workqueue, &priv->post_associate.work);
 
@@ -8929,7 +8915,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		goto out_iounmap;
 	}
 
-#ifdef CONFIG_IWL4965_QOS
 	if (iwl4965_param_qos_enable)
 		priv->qos_data.qos_enable = 1;
 
@@ -8937,7 +8922,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
-#endif /* CONFIG_IWL4965_QOS */
 
 	iwl4965_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
 	iwl4965_setup_deferred_work(priv);
-- 
1.5.3.4

