Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61547 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888AbZDHSVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/18] iwl3945: use iwl_set_mode in 3945
Date: Wed,  8 Apr 2009 11:26:45 -0700
Message-Id: <1239215212-1657-12-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202132_585005_80A7A715)
In-Reply-To: <1239215212-1657-11-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-4-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-5-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-6-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-7-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-8-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-9-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-10-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 can now use iwl_set_mode from iwlcore library.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   27 -----------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   42 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   40 +------------------------
 4 files changed, 45 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 723f741..f262444 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -588,33 +588,6 @@ static void iwl_setup_rxon_timing(struct iwl_priv *priv)
 			le16_to_cpu(priv->rxon_timing.atim_window));
 }
 
-static int iwl_set_mode(struct iwl_priv *priv, int mode)
-{
-	iwl_connection_init_rx_config(priv, mode);
-
-	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv);
-
-	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
-
-	priv->cfg->ops->smgmt->clear_station_table(priv);
-
-	/* dont commit rxon if rf-kill is on*/
-	if (!iwl_is_ready_rf(priv))
-		return -EAGAIN;
-
-	cancel_delayed_work(&priv->scan_check);
-	if (iwl_scan_cancel_timeout(priv, 100)) {
-		IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
-		IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
-		return -EAGAIN;
-	}
-
-	iwlcore_commit_rxon(priv);
-
-	return 0;
-}
-
 /******************************************************************************
  *
  * Generic RX handler implementations
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 270d866..237e794 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2338,6 +2338,48 @@ int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(iwl_mac_beacon_update);
 
+int iwl_set_mode(struct iwl_priv *priv, int mode)
+{
+	if (mode == NL80211_IFTYPE_ADHOC) {
+		const struct iwl_channel_info *ch_info;
+
+		ch_info = iwl_get_channel_info(priv,
+			priv->band,
+			le16_to_cpu(priv->staging_rxon.channel));
+
+		if (!ch_info || !is_channel_ibss(ch_info)) {
+			IWL_ERR(priv, "channel %d not IBSS channel\n",
+				  le16_to_cpu(priv->staging_rxon.channel));
+			return -EINVAL;
+		}
+	}
+
+	iwl_connection_init_rx_config(priv, mode);
+
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv);
+
+	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
+
+	priv->cfg->ops->smgmt->clear_station_table(priv);
+
+	/* dont commit rxon if rf-kill is on*/
+	if (!iwl_is_ready_rf(priv))
+		return -EAGAIN;
+
+	cancel_delayed_work(&priv->scan_check);
+	if (iwl_scan_cancel_timeout(priv, 100)) {
+		IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
+		IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
+		return -EAGAIN;
+	}
+
+	iwlcore_commit_rxon(priv);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_set_mode);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f5eff74..49df47a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -273,6 +273,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     u32 changes);
 int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
 int iwl_commit_rxon(struct iwl_priv *priv);
+int iwl_set_mode(struct iwl_priv *priv, int mode);
 
 /*****************************************************
  * RX handlers.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c3d6caf..82bb736 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -570,42 +570,6 @@ static void iwl3945_setup_rxon_timing(struct iwl_priv *priv)
 		le16_to_cpu(priv->rxon_timing.atim_window));
 }
 
-static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
-{
-	if (mode == NL80211_IFTYPE_ADHOC) {
-		const struct iwl_channel_info *ch_info;
-
-		ch_info = iwl_get_channel_info(priv,
-			priv->band,
-			le16_to_cpu(priv->staging_rxon.channel));
-
-		if (!ch_info || !is_channel_ibss(ch_info)) {
-			IWL_ERR(priv, "channel %d not IBSS channel\n",
-				  le16_to_cpu(priv->staging_rxon.channel));
-			return -EINVAL;
-		}
-	}
-
-	iwl_connection_init_rx_config(priv, mode);
-
-	priv->cfg->ops->smgmt->clear_station_table(priv);
-
-	/* don't commit rxon if rf-kill is on*/
-	if (!iwl_is_ready_rf(priv))
-		return -EAGAIN;
-
-	cancel_delayed_work(&priv->scan_check);
-	if (iwl_scan_cancel_timeout(priv, 100)) {
-		IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
-		IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
-		return -EAGAIN;
-	}
-
-	iwlcore_commit_rxon(priv);
-
-	return 0;
-}
-
 static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct ieee80211_tx_info *info,
 				      struct iwl_cmd *cmd,
@@ -2701,7 +2665,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	}
 
 	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
-		iwl3945_set_mode(priv, priv->iw_mode);
+		iwl_set_mode(priv, priv->iw_mode);
 
 	return;
 
@@ -3442,7 +3406,7 @@ static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
 		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 	}
 
-	if (iwl3945_set_mode(priv, conf->type) == -EAGAIN)
+	if (iwl_set_mode(priv, conf->type) == -EAGAIN)
 		set_bit(STATUS_MODE_PENDING, &priv->status);
 
 	mutex_unlock(&priv->mutex);
-- 
1.5.6.3

