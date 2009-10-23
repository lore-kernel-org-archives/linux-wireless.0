Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24343 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZJWUmf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:35 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/18] iwlwifi: specify the valid tx/rx chain in device config structure
Date: Fri, 23 Oct 2009 13:42:24 -0700
Message-Id: <1256330556-20997-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Specify both Tx and Rx chain in device configuration structure instead
of hard code in set_hw_params() for 4965

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 32d5f3d..bd856df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -653,10 +653,10 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
 
-	priv->hw_params.tx_chains_num = 2;
-	priv->hw_params.rx_chains_num = 2;
-	priv->hw_params.valid_tx_ant = ANT_A | ANT_B;
-	priv->hw_params.valid_rx_ant = ANT_A | ANT_B;
+	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
+	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
+	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
+	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
 	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
 		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
 
@@ -2225,6 +2225,8 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.num_of_queues = IWL49_NUM_QUEUES,
 	.num_of_ampdu_queues = IWL49_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl4965_mod_params,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = 0,
 	.set_l0s = true,
 	.use_bsm = true,
-- 
1.5.6.3

