Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab2JPSPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:15:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/8] iwlwifi: remove unused variables
Date: Tue, 16 Oct 2012 20:16:15 +0200
Message-Id: <1350411380-2391-4-git-send-email-johannes@sipsolutions.net> (sfid-20121016_201552_838906_65D53C4F)
In-Reply-To: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
References: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Remove a number of variables that are assigned, but not used.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c   |    4 ----
 drivers/net/wireless/iwlwifi/pcie/trans.c |    3 +--
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 963d02b..7626299 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1191,8 +1191,6 @@ static void iwl_option_config(struct iwl_priv *priv)
 
 static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 {
-	u16 radio_cfg;
-
 	priv->eeprom_data->sku = priv->eeprom_data->sku;
 
 	if (priv->eeprom_data->sku & EEPROM_SKU_CAP_11N_ENABLE &&
@@ -1208,8 +1206,6 @@ static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 
 	IWL_INFO(priv, "Device SKU: 0x%X\n", priv->eeprom_data->sku);
 
-	radio_cfg = priv->eeprom_data->radio_cfg;
-
 	priv->hw_params.tx_chains_num =
 		num_of_ant(priv->eeprom_data->valid_tx_ant);
 	if (priv->cfg->rx_with_siso_diversity)
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 2349043..6c383df 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1516,14 +1516,13 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
 	/* n_bd is usually 256 => n_bd - 1 = 0xff */
 	int tfd_num = ssn & (txq->q.n_bd - 1);
-	int freed = 0;
 
 	spin_lock(&txq->lock);
 
 	if (txq->q.read_ptr != tfd_num) {
 		IWL_DEBUG_TX_REPLY(trans, "[Q %d] %d -> %d (%d)\n",
 				   txq_id, txq->q.read_ptr, tfd_num, ssn);
-		freed = iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
+		iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
 		if (iwl_queue_space(&txq->q) > txq->q.low_mark)
 			iwl_wake_queue(trans, txq);
 	}
-- 
1.7.10.4

