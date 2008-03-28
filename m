Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbYC1Xdz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:33:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 2/4] iwlwifi: eliminate conf_ht
Date: Fri, 28 Mar 2008 16:33:33 -0700
Message-Id: <1206747215-10640-3-git-send-email-reinette.chatre@intel.com> (sfid-20080328_233358_528267_289843F3)
In-Reply-To: <1206747215-10640-2-git-send-email-reinette.chatre@intel.com>
References: <1206747215-10640-1-git-send-email-reinette.chatre@intel.com>
 <1206747215-10640-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch eliminates the use of conf_ht in iwlwifi driver, replacing it
with bss_info_changed.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  146 ++++++++++++---------------
 1 files changed, 63 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 6b69429..8f4d2aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6942,6 +6942,64 @@ static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
 
 }
 
+
+#ifdef CONFIG_IWL4965_HT
+static void iwl4965_ht_conf(struct iwl_priv *priv,
+			    struct ieee80211_bss_conf *bss_conf)
+{
+	struct ieee80211_ht_info *ht_conf = bss_conf->ht_conf;
+	struct ieee80211_ht_bss_info *ht_bss_conf = bss_conf->ht_bss_conf;
+	struct iwl_ht_info *iwl_conf = &priv->current_ht_config;
+
+	IWL_DEBUG_MAC80211("enter: \n");
+
+	iwl_conf->is_ht = bss_conf->assoc_ht;
+
+	if (!iwl_conf->is_ht)
+		return;
+
+	priv->ps_mode = (u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
+
+	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
+		iwl_conf->sgf |= 0x1;
+	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_40)
+		iwl_conf->sgf |= 0x2;
+
+	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
+	iwl_conf->max_amsdu_size =
+		!!(ht_conf->cap & IEEE80211_HT_CAP_MAX_AMSDU);
+
+	iwl_conf->supported_chan_width =
+		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH);
+	iwl_conf->extension_chan_offset =
+		ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_SEC_OFFSET;
+	/* If no above or below channel supplied disable FAT channel */
+	if (iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_ABOVE &&
+	    iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_BELOW)
+		iwl_conf->supported_chan_width = 0;
+
+	iwl_conf->tx_mimo_ps_mode =
+		(u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
+	memcpy(iwl_conf->supp_mcs_set, ht_conf->supp_mcs_set, 16);
+
+	iwl_conf->control_channel = ht_bss_conf->primary_channel;
+	iwl_conf->tx_chan_width =
+		!!(ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_WIDTH);
+	iwl_conf->ht_protection =
+		ht_bss_conf->bss_op_mode & IEEE80211_HT_IE_HT_PROTECTION;
+	iwl_conf->non_GF_STA_present =
+		!!(ht_bss_conf->bss_op_mode & IEEE80211_HT_IE_NON_GF_STA_PRSNT);
+
+	IWL_DEBUG_MAC80211("control channel %d\n", iwl_conf->control_channel);
+	IWL_DEBUG_MAC80211("leave\n");
+}
+#else
+static inline void iwl4965_ht_conf(struct iwl_priv *priv,
+				   struct ieee80211_bss_conf *bss_conf)
+{
+}
+#endif
+
 static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *bss_conf,
@@ -6963,6 +7021,11 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 	}
 
+	if (changes & BSS_CHANGED_HT) {
+		iwl4965_ht_conf(priv, bss_conf);
+		iwl4965_set_rxon_chain(priv);
+	}
+
 	if (changes & BSS_CHANGED_ASSOC) {
 		/*
 		 * TODO:
@@ -7359,88 +7422,6 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 	return 0;
 }
 
-#ifdef CONFIG_IWL4965_HT
-
-static void iwl4965_ht_info_fill(struct ieee80211_conf *conf,
-				 struct iwl_priv *priv)
-{
-	struct iwl_ht_info *iwl_conf = &priv->current_ht_config;
-	struct ieee80211_ht_info *ht_conf = &conf->ht_conf;
-	struct ieee80211_ht_bss_info *ht_bss_conf = &conf->ht_bss_conf;
-
-	IWL_DEBUG_MAC80211("enter: \n");
-
-	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE)) {
-		iwl_conf->is_ht = 0;
-		return;
-	}
-
-	iwl_conf->is_ht = 1;
-	priv->ps_mode = (u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
-
-	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
-		iwl_conf->sgf |= 0x1;
-	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_40)
-		iwl_conf->sgf |= 0x2;
-
-	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
-	iwl_conf->max_amsdu_size =
-		!!(ht_conf->cap & IEEE80211_HT_CAP_MAX_AMSDU);
-
-	iwl_conf->supported_chan_width =
-		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH);
-	iwl_conf->extension_chan_offset =
-		ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_SEC_OFFSET;
-	/* If no above or below channel supplied disable FAT channel */
-	if (iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_ABOVE &&
-	    iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_BELOW)
-		iwl_conf->supported_chan_width = 0;
-
-	iwl_conf->tx_mimo_ps_mode =
-		(u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
-	memcpy(iwl_conf->supp_mcs_set, ht_conf->supp_mcs_set, 16);
-
-	iwl_conf->control_channel = ht_bss_conf->primary_channel;
-	iwl_conf->tx_chan_width =
-		!!(ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_WIDTH);
-	iwl_conf->ht_protection =
-		ht_bss_conf->bss_op_mode & IEEE80211_HT_IE_HT_PROTECTION;
-	iwl_conf->non_GF_STA_present =
-		!!(ht_bss_conf->bss_op_mode & IEEE80211_HT_IE_NON_GF_STA_PRSNT);
-
-	IWL_DEBUG_MAC80211("control channel %d\n",
-		iwl_conf->control_channel);
-	IWL_DEBUG_MAC80211("leave\n");
-}
-
-static int iwl4965_mac_conf_ht(struct ieee80211_hw *hw,
-			       struct ieee80211_conf *conf)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	IWL_DEBUG_MAC80211("enter: \n");
-
-	iwl4965_ht_info_fill(conf, priv);
-	iwl4965_set_rxon_chain(priv);
-
-	if (priv && priv->assoc_id &&
-	    (priv->iw_mode == IEEE80211_IF_TYPE_STA)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&priv->lock, flags);
-		if (priv->beacon_int)
-			queue_work(priv->workqueue, &priv->post_associate.work);
-		else
-			priv->call_post_assoc_from_beacon = 1;
-		spin_unlock_irqrestore(&priv->lock, flags);
-	}
-
-	IWL_DEBUG_MAC80211("leave:\n");
-	return 0;
-}
-
-#endif /*CONFIG_IWL4965_HT*/
-
 /*****************************************************************************
  *
  * sysfs attributes
@@ -8000,7 +7981,6 @@ static struct ieee80211_ops iwl4965_hw_ops = {
 	.beacon_update = iwl4965_mac_beacon_update,
 	.bss_info_changed = iwl4965_bss_info_changed,
 #ifdef CONFIG_IWL4965_HT
-	.conf_ht = iwl4965_mac_conf_ht,
 	.ampdu_action = iwl4965_mac_ampdu_action,
 #endif  /* CONFIG_IWL4965_HT */
 	.hw_scan = iwl4965_mac_hw_scan
-- 
1.5.3.4

