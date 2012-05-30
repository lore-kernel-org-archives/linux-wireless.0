Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab2E3IgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 04:36:16 -0400
Message-ID: <1338366972.4511.9.camel@jlt3.sipsolutions.net> (sfid-20120530_103641_304149_CED6F984)
Subject: [PATCH 3.5] iwlwifi: fix TX power antenna access
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 30 May 2012 10:36:12 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since my commit
  iwlwifi: use valid TX/RX antenna from hw_params
the config values are pure overrides, not the
real values for all hardware. Therefore, the
EEPROM TX power reading code checks the wrong
values, it should check the hw_params values.

Cc: stable@kernel.org [3.4]
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 50c5891..b8e2b22 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -568,28 +568,28 @@ static int iwl_find_otp_image(struct iwl_trans *trans,
  * iwl_get_max_txpower_avg - get the highest tx power from all chains.
  *     find the highest tx power from all chains for the channel
  */
-static s8 iwl_get_max_txpower_avg(const struct iwl_cfg *cfg,
+static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
 		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
 		int element, s8 *max_txpower_in_half_dbm)
 {
 	s8 max_txpower_avg = 0; /* (dBm) */
 
 	/* Take the highest tx power from any valid chains */
-	if ((cfg->valid_tx_ant & ANT_A) &&
+	if ((priv->hw_params.valid_tx_ant & ANT_A) &&
 	    (enhanced_txpower[element].chain_a_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].chain_a_max;
-	if ((cfg->valid_tx_ant & ANT_B) &&
+	if ((priv->hw_params.valid_tx_ant & ANT_B) &&
 	    (enhanced_txpower[element].chain_b_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].chain_b_max;
-	if ((cfg->valid_tx_ant & ANT_C) &&
+	if ((priv->hw_params.valid_tx_ant & ANT_C) &&
 	    (enhanced_txpower[element].chain_c_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].chain_c_max;
-	if (((cfg->valid_tx_ant == ANT_AB) |
-	    (cfg->valid_tx_ant == ANT_BC) |
-	    (cfg->valid_tx_ant == ANT_AC)) &&
+	if (((priv->hw_params.valid_tx_ant == ANT_AB) |
+	    (priv->hw_params.valid_tx_ant == ANT_BC) |
+	    (priv->hw_params.valid_tx_ant == ANT_AC)) &&
 	    (enhanced_txpower[element].mimo2_max > max_txpower_avg))
 		max_txpower_avg =  enhanced_txpower[element].mimo2_max;
-	if ((cfg->valid_tx_ant == ANT_ABC) &&
+	if ((priv->hw_params.valid_tx_ant == ANT_ABC) &&
 	    (enhanced_txpower[element].mimo3_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].mimo3_max;
 
@@ -691,7 +691,7 @@ static void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 				 ((txp->delta_20_in_40 & 0xf0) >> 4),
 				 (txp->delta_20_in_40 & 0x0f));
 
-		max_txp_avg = iwl_get_max_txpower_avg(priv->cfg, txp_array, idx,
+		max_txp_avg = iwl_get_max_txpower_avg(priv, txp_array, idx,
 						      &max_txp_avg_halfdbm);
 
 		/*
-- 
1.7.10



