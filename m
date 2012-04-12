Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966089Ab2DLV6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:10 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/24] iwlwifi: move iwl_chswitch_done to iwl-mac80211.c
Date: Thu, 12 Apr 2012 14:54:10 -0700
Message-Id: <1334267661-14654-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235903_780929_96727B14)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Move this as part of iwl-core.c cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   15 ---------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 -----
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   15 +++++++++++++++
 4 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 3588d3c..ac0e8ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -169,6 +169,7 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan);
 /* rx */
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 void iwl_setup_rx_handlers(struct iwl_priv *priv);
+void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
 
 
 /* tx */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 40eb91a..f43a1e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -43,21 +43,6 @@
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
-{
-	/*
-	 * MULTI-FIXME
-	 * See iwlagn_mac_channel_switch.
-	 */
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
-		ieee80211_chswitch_done(ctx->vif, is_success);
-}
-
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 			     enum iwl_rxon_context_id ctxid)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 9cf1a94..81c287c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -119,11 +119,6 @@ static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 #endif
 
 /*****************************************************
-* RX
-******************************************************/
-void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
-
-/*****************************************************
  * TX power
  ****************************************************/
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index a3aa5a4..d982493 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -914,6 +914,21 @@ out:
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
+void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
+{
+	/*
+	 * MULTI-FIXME
+	 * See iwlagn_mac_channel_switch.
+	 */
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+		ieee80211_chswitch_done(ctx->vif, is_success);
+}
+
 static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int changed_flags,
 				    unsigned int *total_flags,
-- 
1.7.0.4

