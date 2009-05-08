Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20575 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951AbZEHUiY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:24 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 07/11] iwlwifi: use #define instead of hard coded value
Date: Fri,  8 May 2009 13:44:42 -0700
Message-Id: <1241815486-13510-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241815486-13510-7-git-send-email-reinette.chatre@intel.com>
References: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-3-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-4-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-5-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-6-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Instead of hard coded value, use the define in iwl-commands.h for
better code maintenance

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-scan.c |   14 ++++++++------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1ecb77d..a630128 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -960,10 +960,10 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 	if (iwl_is_monitor_mode(priv) &&
 	    !(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) &&
 	    ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)) {
-		rx_chain = 0x07 << RXON_RX_CHAIN_VALID_POS;
-		rx_chain |= 0x06 << RXON_RX_CHAIN_FORCE_SEL_POS;
-		rx_chain |= 0x07 << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
-		rx_chain |= 0x01 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
+		rx_chain = ANT_ABC << RXON_RX_CHAIN_VALID_POS;
+		rx_chain |= ANT_BC << RXON_RX_CHAIN_FORCE_SEL_POS;
+		rx_chain |= ANT_ABC << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
+		rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
 	}
 
 	priv->staging_rxon.rx_chain = cpu_to_le16(rx_chain);
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index e38868f..8029206 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -580,9 +580,10 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	int ret = 0;
 	u32 rate_flags = 0;
 	u16 cmd_len;
+	u16 rx_chain = 0;
 	enum ieee80211_band band;
 	u8 n_probes = 0;
-	u8 rx_chain = priv->hw_params.valid_rx_ant;
+	u8 rx_ant = priv->hw_params.valid_rx_ant;
 	u8 rate;
 	bool is_active = false;
 
@@ -723,7 +724,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		 * Avoid A (0x1) because of its off-channel reception on A-band.
 		 */
 		if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
-			rx_chain = 0x6;
+			rx_ant = ANT_BC;
 	} else {
 		IWL_WARN(priv, "Invalid scan band count\n");
 		goto done;
@@ -735,10 +736,11 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
 
 	/* MIMO is not used here, but value is required */
-	scan->rx_chain = RXON_RX_CHAIN_DRIVER_FORCE_MSK |
-				cpu_to_le16((0x7 << RXON_RX_CHAIN_VALID_POS) |
-				(rx_chain << RXON_RX_CHAIN_FORCE_SEL_POS) |
-				(0x7 << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS));
+	rx_chain |= ANT_ABC << RXON_RX_CHAIN_VALID_POS;
+	rx_chain |= ANT_ABC << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
+	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
+	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
+	scan->rx_chain = cpu_to_le16(rx_chain);
 	cmd_len = iwl_fill_probe_req(priv,
 				(struct ieee80211_mgmt *)scan->data,
 				priv->scan_request->ie,
-- 
1.5.6.3

