Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759940AbZKFWxA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:00 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/20] iwlwifi: use only one chain for scan in PS
Date: Fri,  6 Nov 2009 14:52:47 -0800
Message-Id: <1257547983-12590-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

When doing scan in power saving mode, choose only 1 valid RX chain instead of
turning all chains on.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 1eb0d0b..48bc263 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -581,6 +581,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	u8 rate;
 	bool is_active = false;
 	int  chan_mod;
+	u8 active_chains;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -734,9 +735,22 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
 	scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
 
+	/* In power save mode use one chain, otherwise use all chains */
+	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
+		/* rx_ant has been set to all valid chains previously */
+		active_chains = rx_ant &
+				((u8)(priv->chain_noise_data.active_chains));
+		if (!active_chains)
+			active_chains = rx_ant;
+
+		IWL_DEBUG_SCAN(priv, "chain_noise_data.active_chains: %u\n",
+				priv->chain_noise_data.active_chains);
+
+		rx_ant = first_antenna(active_chains);
+	}
 	/* MIMO is not used here, but value is required */
 	rx_chain |= ANT_ABC << RXON_RX_CHAIN_VALID_POS;
-	rx_chain |= ANT_ABC << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
+	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
 	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
 	scan->rx_chain = cpu_to_le16(rx_chain);
-- 
1.5.6.3

