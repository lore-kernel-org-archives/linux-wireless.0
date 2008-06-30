Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024AbYF3J1P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Rick Farrington <rickdic@hotmail.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 28/33] iwlwifi: fix incorrect monitor mode operation
Date: Mon, 30 Jun 2008 17:23:28 +0800
Message-Id: <1214817813-17639-29-git-send-email-yi.zhu@intel.com> (sfid-20080630_113813_850480_A2FD9A07)
In-Reply-To: <1214817813-17639-28-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-22-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-25-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-26-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-27-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-28-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rick Farrington <rickdic@hotmail.com>

This patch fixes monitor mode operation for iwlwifi.

Problems addressed:
1. when monitor mode was enabled, multiple, overlapped calls were being
made to 'iwl3945_bg_set_monitor'

2. when monitor mode was disabled (via the configure_filter callback),
the driver was still enabling monitor mode

3. when monitor mode was enabled, the selected channel was not set
(eg. 'iwconfig wlanx mode monitor channel n' DID NOT SET channel 'n'
when packet capture was subsequently enabled)

Signed-off-by: Rick Farrington <rickdic@hotmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   30 +++++++++---------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   33 +++++++++------------------
 2 files changed, 22 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 43cb8ff..4f0a18a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2312,7 +2312,7 @@ static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv)
 #endif
 
 	ch_info = iwl3945_get_channel_info(priv, priv->band,
-				       le16_to_cpu(priv->staging_rxon.channel));
+				       le16_to_cpu(priv->active_rxon.channel));
 
 	if (!ch_info)
 		ch_info = &priv->channel_info[0];
@@ -7006,26 +7006,18 @@ static void iwl3945_configure_filter(struct ieee80211_hw *hw,
 				 unsigned int *total_flags,
 				 int mc_count, struct dev_addr_list *mc_list)
 {
-	/*
-	 * XXX: dummy
-	 * see also iwl3945_connection_init_rx_config
-	 */
 	struct iwl3945_priv *priv = hw->priv;
-	int new_flags = 0;
-	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
-		if (*total_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
-			IWL_DEBUG_MAC80211("Enter: type %d (0x%x, 0x%x)\n",
-					   IEEE80211_IF_TYPE_MNTR,
-					   changed_flags, *total_flags);
-			/* queue work 'cuz mac80211 is holding a lock which
-			 * prevents us from issuing (synchronous) f/w cmds */
-			queue_work(priv->workqueue, &priv->set_monitor);
-			new_flags &= FIF_PROMISC_IN_BSS |
-				     FIF_OTHER_BSS |
-				     FIF_ALLMULTI;
-		}
+
+	if (changed_flags & (*total_flags) & FIF_OTHER_BSS) {
+		IWL_DEBUG_MAC80211("Enter: type %d (0x%x, 0x%x)\n",
+				   IEEE80211_IF_TYPE_MNTR,
+				   changed_flags, *total_flags);
+		/* queue work 'cuz mac80211 is holding a lock which
+		 * prevents us from issuing (synchronous) f/w cmds */
+		queue_work(priv->workqueue, &priv->set_monitor);
 	}
-	*total_flags = new_flags;
+	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI |
+			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
 static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5eb2a3e..ba0f289 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -758,7 +758,7 @@ static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
 #endif
 
 	ch_info = iwl_get_channel_info(priv, priv->band,
-				       le16_to_cpu(priv->staging_rxon.channel));
+				       le16_to_cpu(priv->active_rxon.channel));
 
 	if (!ch_info)
 		ch_info = &priv->channel_info[0];
@@ -794,9 +794,6 @@ static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 {
 	priv->iw_mode = mode;
 
-	/* init channel/phymode to values given at driver init */
-	iwl_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
-
 	iwl4965_connection_init_rx_config(priv);
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
@@ -3025,26 +3022,18 @@ static void iwl4965_configure_filter(struct ieee80211_hw *hw,
 				 unsigned int *total_flags,
 				 int mc_count, struct dev_addr_list *mc_list)
 {
-	/*
-	 * XXX: dummy
-	 * see also iwl4965_connection_init_rx_config
-	 */
 	struct iwl_priv *priv = hw->priv;
-	int new_flags = 0;
-	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
-		if (*total_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
-			IWL_DEBUG_MAC80211("Enter: type %d (0x%x, 0x%x)\n",
-					   IEEE80211_IF_TYPE_MNTR,
-					   changed_flags, *total_flags);
-			/* queue work 'cuz mac80211 is holding a lock which
-			 * prevents us from issuing (synchronous) f/w cmds */
-			queue_work(priv->workqueue, &priv->set_monitor);
-			new_flags &= FIF_PROMISC_IN_BSS |
-				     FIF_OTHER_BSS |
-				     FIF_ALLMULTI;
-		}
+
+	if (changed_flags & (*total_flags) & FIF_OTHER_BSS) {
+		IWL_DEBUG_MAC80211("Enter: type %d (0x%x, 0x%x)\n",
+				   IEEE80211_IF_TYPE_MNTR,
+				   changed_flags, *total_flags);
+		/* queue work 'cuz mac80211 is holding a lock which
+		 * prevents us from issuing (synchronous) f/w cmds */
+		queue_work(priv->workqueue, &priv->set_monitor);
 	}
-	*total_flags = new_flags;
+	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI |
+			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
 static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
-- 
1.5.3.6

