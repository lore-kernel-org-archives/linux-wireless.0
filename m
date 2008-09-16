Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49988 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbYIPGF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 02:05:29 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/2] iwlwifi: make PS use named constants
Date: Tue, 16 Sep 2008 14:01:04 +0800
Message-Id: <1221544864-9494-2-git-send-email-yi.zhu@intel.com> (sfid-20080916_080535_808236_7AF3D2D3)
In-Reply-To: <1221544864-9494-1-git-send-email-yi.zhu@intel.com>
References: <1221544864-9494-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds named constants for configuring MIMO power save
chain settings.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d80184e..8203887 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -697,8 +697,12 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 }
 EXPORT_SYMBOL(iwl_set_rxon_ht);
 
-/*
- * Determine how many receiver/antenna chains to use.
+#define IWL_NUM_RX_CHAINS_MULTIPLE	3
+#define IWL_NUM_RX_CHAINS_SINGLE	2
+#define IWL_NUM_IDLE_CHAINS_DUAL	2
+#define IWL_NUM_IDLE_CHAINS_SINGLE	1
+
+/* Determine how many receiver/antenna chains to use.
  * More provides better reception via diversity.  Fewer saves power.
  * MIMO (dual stream) requires at least 2, but works better with 3.
  * This does not determine *which* chains to use, just how many.
@@ -711,9 +715,9 @@ static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 	/* # of Rx chains to use when expecting MIMO. */
 	if (is_single || (!is_cam && (priv->current_ht_config.sm_ps ==
 						 WLAN_HT_CAP_SM_PS_STATIC)))
-		return 2;
+		return IWL_NUM_RX_CHAINS_SINGLE;
 	else
-		return 3;
+		return IWL_NUM_RX_CHAINS_MULTIPLE;
 }
 
 static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
@@ -724,10 +728,11 @@ static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 	switch (priv->current_ht_config.sm_ps) {
 	case WLAN_HT_CAP_SM_PS_STATIC:
 	case WLAN_HT_CAP_SM_PS_DYNAMIC:
-		idle_cnt = (is_cam) ? 2 : 1;
+		idle_cnt = (is_cam) ? IWL_NUM_IDLE_CHAINS_DUAL :
+					IWL_NUM_IDLE_CHAINS_SINGLE;
 		break;
 	case WLAN_HT_CAP_SM_PS_DISABLED:
-		idle_cnt = (is_cam) ? active_cnt : 1;
+		idle_cnt = (is_cam) ? active_cnt : IWL_NUM_IDLE_CHAINS_SINGLE;
 		break;
 	case WLAN_HT_CAP_SM_PS_INVALID:
 	default:
@@ -796,7 +801,7 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 
 	priv->staging_rxon.rx_chain = cpu_to_le16(rx_chain);
 
-	if (!is_single && (active_rx_cnt >= 2) && is_cam)
+	if (!is_single && (active_rx_cnt >= IWL_NUM_RX_CHAINS_SINGLE) && is_cam)
 		priv->staging_rxon.rx_chain |= RXON_RX_CHAIN_MIMO_FORCE_MSK;
 	else
 		priv->staging_rxon.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
-- 
1.5.3.6

