Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966110Ab2DLV6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/24] iwlwifi: move iwl_print_rx_config_cmd to iwl-agn-rxon.c
Date: Thu, 12 Apr 2012 14:54:14 -0700
Message-Id: <1334267661-14654-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235904_824392_13190038)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Move this as part of iwl-core.c cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   23 -----------------------
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index d2da1f3..69279af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -931,6 +931,33 @@ static int iwl_full_rxon_required(struct iwl_priv *priv,
 	return 0;
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+void iwl_print_rx_config_cmd(struct iwl_priv *priv,
+			     enum iwl_rxon_context_id ctxid)
+{
+	struct iwl_rxon_context *ctx = &priv->contexts[ctxid];
+	struct iwl_rxon_cmd *rxon = &ctx->staging;
+
+	IWL_DEBUG_RADIO(priv, "RX CONFIG:\n");
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
+	IWL_DEBUG_RADIO(priv, "u16 channel: 0x%x\n",
+			le16_to_cpu(rxon->channel));
+	IWL_DEBUG_RADIO(priv, "u32 flags: 0x%08X\n",
+			le32_to_cpu(rxon->flags));
+	IWL_DEBUG_RADIO(priv, "u32 filter_flags: 0x%08x\n",
+			le32_to_cpu(rxon->filter_flags));
+	IWL_DEBUG_RADIO(priv, "u8 dev_type: 0x%x\n", rxon->dev_type);
+	IWL_DEBUG_RADIO(priv, "u8 ofdm_basic_rates: 0x%02x\n",
+			rxon->ofdm_basic_rates);
+	IWL_DEBUG_RADIO(priv, "u8 cck_basic_rates: 0x%02x\n",
+			rxon->cck_basic_rates);
+	IWL_DEBUG_RADIO(priv, "u8[6] node_addr: %pM\n", rxon->node_addr);
+	IWL_DEBUG_RADIO(priv, "u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
+	IWL_DEBUG_RADIO(priv, "u16 assoc_id: 0x%x\n",
+			le16_to_cpu(rxon->assoc_id));
+}
+#endif
+
 /**
  * iwlagn_commit_rxon - commit staging_rxon to hardware
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 27121fc..e839719 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -43,29 +43,6 @@
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-void iwl_print_rx_config_cmd(struct iwl_priv *priv,
-			     enum iwl_rxon_context_id ctxid)
-{
-	struct iwl_rxon_context *ctx = &priv->contexts[ctxid];
-	struct iwl_rxon_cmd *rxon = &ctx->staging;
-
-	IWL_DEBUG_RADIO(priv, "RX CONFIG:\n");
-	iwl_print_hex_dump(priv, IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
-	IWL_DEBUG_RADIO(priv, "u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
-	IWL_DEBUG_RADIO(priv, "u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
-	IWL_DEBUG_RADIO(priv, "u32 filter_flags: 0x%08x\n",
-			le32_to_cpu(rxon->filter_flags));
-	IWL_DEBUG_RADIO(priv, "u8 dev_type: 0x%x\n", rxon->dev_type);
-	IWL_DEBUG_RADIO(priv, "u8 ofdm_basic_rates: 0x%02x\n",
-			rxon->ofdm_basic_rates);
-	IWL_DEBUG_RADIO(priv, "u8 cck_basic_rates: 0x%02x\n", rxon->cck_basic_rates);
-	IWL_DEBUG_RADIO(priv, "u8[6] node_addr: %pM\n", rxon->node_addr);
-	IWL_DEBUG_RADIO(priv, "u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
-	IWL_DEBUG_RADIO(priv, "u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
-}
-#endif
-
 int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 {
 	struct iwl_statistics_cmd statistics_cmd = {
-- 
1.7.0.4

