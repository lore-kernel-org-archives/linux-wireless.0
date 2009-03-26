Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbZCZRIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 13:08:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwl3945: use iwl_mac_conf_tx
Date: Thu, 26 Mar 2009 10:14:10 -0700
Message-Id: <1238087650-26993-4-git-send-email-reinette.chatre@intel.com> (sfid-20090326_180848_682395_78750A64)
In-Reply-To: <1238087650-26993-3-git-send-email-reinette.chatre@intel.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com>
 <1238087650-26993-2-git-send-email-reinette.chatre@intel.com>
 <1238087650-26993-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 now uses iwl_mac_conf_tx.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   43 ------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   43 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   48 +--------------------------
 4 files changed, 46 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 669b435..51f6a01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2628,49 +2628,6 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
-static int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
-			   const struct ieee80211_tx_queue_params *params)
-{
-	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
-	int q;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return -EIO;
-	}
-
-	if (queue >= AC_NUM) {
-		IWL_DEBUG_MAC80211(priv, "leave - queue >= AC_NUM %d\n", queue);
-		return 0;
-	}
-
-	q = AC_NUM - 1 - queue;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	priv->qos_data.def_qos_parm.ac[q].cw_min = cpu_to_le16(params->cw_min);
-	priv->qos_data.def_qos_parm.ac[q].cw_max = cpu_to_le16(params->cw_max);
-	priv->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
-	priv->qos_data.def_qos_parm.ac[q].edca_txop =
-			cpu_to_le16((params->txop * 32));
-
-	priv->qos_data.def_qos_parm.ac[q].reserved1 = 0;
-	priv->qos_data.qos_active = 1;
-
-	if (priv->iw_mode == NL80211_IFTYPE_AP)
-		iwl_activate_qos(priv, 1);
-	else if (priv->assoc_id && iwl_is_associated(priv))
-		iwl_activate_qos(priv, 0);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return 0;
-}
-
 static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 			     enum ieee80211_ampdu_mlme_action action,
 			     struct ieee80211_sta *sta, u16 tid, u16 *ssn)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7560d6f..02fa5c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2114,6 +2114,49 @@ void iwl_rx_reply_error(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_rx_reply_error);
 
+int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
+			   const struct ieee80211_tx_queue_params *params)
+{
+	struct iwl_priv *priv = hw->priv;
+	unsigned long flags;
+	int q;
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
+		return -EIO;
+	}
+
+	if (queue >= AC_NUM) {
+		IWL_DEBUG_MAC80211(priv, "leave - queue >= AC_NUM %d\n", queue);
+		return 0;
+	}
+
+	q = AC_NUM - 1 - queue;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	priv->qos_data.def_qos_parm.ac[q].cw_min = cpu_to_le16(params->cw_min);
+	priv->qos_data.def_qos_parm.ac[q].cw_max = cpu_to_le16(params->cw_max);
+	priv->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
+	priv->qos_data.def_qos_parm.ac[q].edca_txop =
+			cpu_to_le16((params->txop * 32));
+
+	priv->qos_data.def_qos_parm.ac[q].reserved1 = 0;
+	priv->qos_data.qos_active = 1;
+
+	if (priv->iw_mode == NL80211_IFTYPE_AP)
+		iwl_activate_qos(priv, 1);
+	else if (priv->assoc_id && iwl_is_associated(priv))
+		iwl_activate_qos(priv, 0);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+	return 0;
+}
+EXPORT_SYMBOL(iwl_mac_conf_tx);
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5d49045..d56edcd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -225,6 +225,8 @@ struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 void iwl_hw_detect(struct iwl_priv *priv);
 void iwl_reset_qos(struct iwl_priv *priv);
 void iwl_activate_qos(struct iwl_priv *priv, u8 force);
+int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
+		    const struct ieee80211_tx_queue_params *params);
 void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt);
 int iwl_check_rxon_cmd(struct iwl_priv *priv);
 int iwl_full_rxon_required(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 33f5b00..c29189b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4100,52 +4100,6 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
-static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
-			   const struct ieee80211_tx_queue_params *params)
-{
-	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
-	int q;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return -EIO;
-	}
-
-	if (queue >= AC_NUM) {
-		IWL_DEBUG_MAC80211(priv, "leave - queue >= AC_NUM %d\n", queue);
-		return 0;
-	}
-
-	q = AC_NUM - 1 - queue;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	priv->qos_data.def_qos_parm.ac[q].cw_min = cpu_to_le16(params->cw_min);
-	priv->qos_data.def_qos_parm.ac[q].cw_max = cpu_to_le16(params->cw_max);
-	priv->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
-	priv->qos_data.def_qos_parm.ac[q].edca_txop =
-			cpu_to_le16((params->txop * 32));
-
-	priv->qos_data.def_qos_parm.ac[q].reserved1 = 0;
-	priv->qos_data.qos_active = 1;
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	mutex_lock(&priv->mutex);
-	if (priv->iw_mode == NL80211_IFTYPE_AP)
-		iwl_activate_qos(priv, 1);
-	else if (priv->assoc_id && iwl_is_associated(priv))
-		iwl_activate_qos(priv, 0);
-
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return 0;
-}
-
 static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 				struct ieee80211_tx_queue_stats *stats)
 {
@@ -4809,7 +4763,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.configure_filter = iwl_configure_filter,
 	.set_key = iwl3945_mac_set_key,
 	.get_tx_stats = iwl3945_mac_get_tx_stats,
-	.conf_tx = iwl3945_mac_conf_tx,
+	.conf_tx = iwl_mac_conf_tx,
 	.reset_tsf = iwl3945_mac_reset_tsf,
 	.bss_info_changed = iwl3945_bss_info_changed,
 	.hw_scan = iwl_mac_hw_scan
-- 
1.5.6.3

