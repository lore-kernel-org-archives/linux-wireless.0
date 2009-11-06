Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759935AbZKFWxA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:00 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/20] iwlwifi: use configured valid rx chain for scan
Date: Fri,  6 Nov 2009 14:52:48 -0800
Message-Id: <1257547983-12590-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Use configured valid rx chains in scan command instead of ANT_ABC, correcting
valid rx chain configuration of 4965, should be ANT_ABC instead of ANT_AB.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 62c95eb..607c312 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2229,7 +2229,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.num_of_ampdu_queues = IWL49_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl4965_mod_params,
 	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
+	.valid_rx_ant = ANT_ABC,
 	.pll_cfg_val = 0,
 	.set_l0s = true,
 	.use_bsm = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 48bc263..a2b2b83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -749,7 +749,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		rx_ant = first_antenna(active_chains);
 	}
 	/* MIMO is not used here, but value is required */
-	rx_chain |= ANT_ABC << RXON_RX_CHAIN_VALID_POS;
+	rx_chain |= priv->hw_params.valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
 	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
-- 
1.5.6.3

