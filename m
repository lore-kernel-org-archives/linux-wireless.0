Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32034 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbYH1J3N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 05:29:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 10/11] iwlwifi: fix rx_chain computation
Date: Thu, 28 Aug 2008 17:25:09 +0800
Message-Id: <1219915510-3647-11-git-send-email-yi.zhu@intel.com> (sfid-20080828_115040_240406_37371577)
In-Reply-To: <1219915510-3647-10-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-9-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes and simplifies rx_chain computation.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   77 ++++++++++++++++++------------
 1 files changed, 46 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2b89c7b..a3b496e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -592,12 +592,11 @@ static void iwlcore_free_geos(struct iwl_priv *priv)
 	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
 }
 
-static u8 is_single_rx_stream(struct iwl_priv *priv)
+static bool is_single_rx_stream(struct iwl_priv *priv)
 {
 	return !priv->current_ht_config.is_ht ||
 	       ((priv->current_ht_config.supp_mcs_set[1] == 0) &&
-		(priv->current_ht_config.supp_mcs_set[2] == 0)) ||
-	       priv->ps_mode == IWL_MIMO_PS_STATIC;
+		(priv->current_ht_config.supp_mcs_set[2] == 0));
 }
 
 static u8 iwl_is_channel_extension(struct iwl_priv *priv,
@@ -704,33 +703,39 @@ EXPORT_SYMBOL(iwl_set_rxon_ht);
  * MIMO (dual stream) requires at least 2, but works better with 3.
  * This does not determine *which* chains to use, just how many.
  */
-static int iwlcore_get_rx_chain_counter(struct iwl_priv *priv,
-					u8 *idle_state, u8 *rx_state)
+static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 {
-	u8 is_single = is_single_rx_stream(priv);
-	u8 is_cam = test_bit(STATUS_POWER_PMI, &priv->status) ? 0 : 1;
+	bool is_single = is_single_rx_stream(priv);
+	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
 
 	/* # of Rx chains to use when expecting MIMO. */
 	if (is_single || (!is_cam && (priv->ps_mode == IWL_MIMO_PS_STATIC)))
-		*rx_state = 2;
+		return 2;
 	else
-		*rx_state = 3;
+		return 3;
+}
 
+static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
+{
+	int idle_cnt;
+	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
 	/* # Rx chains when idling and maybe trying to save power */
 	switch (priv->ps_mode) {
 	case IWL_MIMO_PS_STATIC:
 	case IWL_MIMO_PS_DYNAMIC:
-		*idle_state = (is_cam) ? 2 : 1;
+		idle_cnt = (is_cam) ? 2 : 1;
 		break;
 	case IWL_MIMO_PS_NONE:
-		*idle_state = (is_cam) ? *rx_state : 1;
+		idle_cnt = (is_cam) ? active_cnt : 1;
 		break;
+	case IWL_MIMO_PS_INVALID:
 	default:
-		*idle_state = 1;
+		IWL_ERROR("invalide mimo ps mode %d\n", priv->ps_mode);
+		WARN_ON(1);
+		idle_cnt = -1;
 		break;
 	}
-
-	return 0;
+	return idle_cnt;
 }
 
 /**
@@ -741,34 +746,44 @@ static int iwlcore_get_rx_chain_counter(struct iwl_priv *priv,
  */
 void iwl_set_rxon_chain(struct iwl_priv *priv)
 {
-	u8 is_single = is_single_rx_stream(priv);
-	u8 idle_state, rx_state;
-
-	priv->staging_rxon.rx_chain = 0;
-	rx_state = idle_state = 3;
+	bool is_single = is_single_rx_stream(priv);
+	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
+	u8 idle_rx_cnt, active_rx_cnt;
+	u16 rx_chain;
 
 	/* Tell uCode which antennas are actually connected.
 	 * Before first association, we assume all antennas are connected.
 	 * Just after first association, iwl_chain_noise_calibration()
 	 *    checks which antennas actually *are* connected. */
-	priv->staging_rxon.rx_chain |=
-		    cpu_to_le16(priv->hw_params.valid_rx_ant <<
-						 RXON_RX_CHAIN_VALID_POS);
+	rx_chain = priv->hw_params.valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
 
 	/* How many receivers should we use? */
-	iwlcore_get_rx_chain_counter(priv, &idle_state, &rx_state);
-	priv->staging_rxon.rx_chain |=
-		cpu_to_le16(rx_state << RXON_RX_CHAIN_MIMO_CNT_POS);
-	priv->staging_rxon.rx_chain |=
-		cpu_to_le16(idle_state << RXON_RX_CHAIN_CNT_POS);
-
-	if (!is_single && (rx_state >= 2) &&
-	    !test_bit(STATUS_POWER_PMI, &priv->status))
+	active_rx_cnt = iwl_get_active_rx_chain_count(priv);
+	idle_rx_cnt = iwl_get_idle_rx_chain_count(priv, active_rx_cnt);
+
+	/* correct rx chain count accoridng hw settings */
+	if (priv->hw_params.rx_chains_num < active_rx_cnt)
+		active_rx_cnt = priv->hw_params.rx_chains_num;
+
+	if (priv->hw_params.rx_chains_num < idle_rx_cnt)
+		idle_rx_cnt = priv->hw_params.rx_chains_num;
+
+	rx_chain |= active_rx_cnt << RXON_RX_CHAIN_MIMO_CNT_POS;
+	rx_chain |= idle_rx_cnt  << RXON_RX_CHAIN_CNT_POS;
+
+	priv->staging_rxon.rx_chain = cpu_to_le16(rx_chain);
+
+	if (!is_single && (active_rx_cnt >= 2) && is_cam)
 		priv->staging_rxon.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
 	else
 		priv->staging_rxon.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
 
-	IWL_DEBUG_ASSOC("rx chain %X\n", priv->staging_rxon.rx_chain);
+	IWL_DEBUG_ASSOC("rx_chain=0x%Xi active=%d idle=%d\n",
+			priv->staging_rxon.rx_chain,
+			active_rx_cnt, idle_rx_cnt);
+
+	WARN_ON(active_rx_cnt == 0 || idle_rx_cnt == 0 ||
+		active_rx_cnt < idle_rx_cnt);
 }
 EXPORT_SYMBOL(iwl_set_rxon_chain);
 
-- 
1.5.3.6

