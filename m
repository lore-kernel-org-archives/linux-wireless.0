Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43486 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072Ab0LNARL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:11 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/14] iwlagn: More detail tx power logging
Date: Mon, 13 Dec 2010 16:09:29 -0800
Message-Id: <1292285372-11373-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For enhanced tx power table in EEPROM, add more detail logging
to help debugging

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   40 ++++++++++++++++++------
 1 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 77d92b7..97906dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -203,15 +203,6 @@ static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
 {
 	s8 max_txpower_avg = 0; /* (dBm) */
 
-	IWL_DEBUG_EEPROM(priv, "%d - "
-			"chain_a: %d dB chain_b: %d dB "
-			"chain_c: %d dB mimo2: %d dB mimo3: %d dB\n",
-			element,
-			enhanced_txpower[element].chain_a_max >> 1,
-			enhanced_txpower[element].chain_b_max >> 1,
-			enhanced_txpower[element].chain_c_max >> 1,
-			enhanced_txpower[element].mimo2_max >> 1,
-			enhanced_txpower[element].mimo3_max >> 1);
 	/* Take the highest tx power from any valid chains */
 	if ((priv->cfg->valid_tx_ant & ANT_A) &&
 	    (enhanced_txpower[element].chain_a_max > max_txpower_avg))
@@ -279,6 +270,9 @@ iwlcore_eeprom_enh_txp_read_element(struct iwl_priv *priv,
 #define EEPROM_TXP_ENTRY_LEN sizeof(struct iwl_eeprom_enhanced_txpwr)
 #define EEPROM_TXP_SZ_OFFS (0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT_SIZE)
 
+#define TXP_CHECK_AND_PRINT(x) ((txp->flags & IWL_EEPROM_ENH_TXP_FL_##x) \
+			    ? # x " " : "")
+
 void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 {
 	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
@@ -293,13 +287,39 @@ void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 	entries = le16_to_cpup(txp_len) * 2 / EEPROM_TXP_ENTRY_LEN;
 
 	txp_array = (void *) iwlagn_eeprom_query_addr(priv, EEPROM_TXP_OFFS);
+
 	for (idx = 0; idx < entries; idx++) {
 		txp = &txp_array[idx];
-
 		/* skip invalid entries */
 		if (!(txp->flags & IWL_EEPROM_ENH_TXP_FL_VALID))
 			continue;
 
+		IWL_DEBUG_EEPROM(priv, "%s %d:\t %s%s%s%s%s%s%s%s (0x%02x)\n",
+				 (txp->channel && (txp->flags &
+					IWL_EEPROM_ENH_TXP_FL_COMMON_TYPE)) ?
+					"Common " : (txp->channel) ?
+					"Channel" : "Common",
+				 (txp->channel),
+				 TXP_CHECK_AND_PRINT(VALID),
+				 TXP_CHECK_AND_PRINT(BAND_52G),
+				 TXP_CHECK_AND_PRINT(OFDM),
+				 TXP_CHECK_AND_PRINT(40MHZ),
+				 TXP_CHECK_AND_PRINT(HT_AP),
+				 TXP_CHECK_AND_PRINT(RES1),
+				 TXP_CHECK_AND_PRINT(RES2),
+				 TXP_CHECK_AND_PRINT(COMMON_TYPE),
+				 txp->flags);
+		IWL_DEBUG_EEPROM(priv, "\t\t chain_A: 0x%02x "
+				 "chain_B: 0X%02x chain_C: 0X%02x\n",
+				 txp->chain_a_max, txp->chain_b_max,
+				 txp->chain_c_max);
+		IWL_DEBUG_EEPROM(priv, "\t\t MIMO2: 0x%02x "
+				 "MIMO3: 0x%02x High 20_on_40: 0x%02x "
+				 "Low 20_on_40: 0x%02x\n",
+				 txp->mimo2_max, txp->mimo3_max,
+				 ((txp->delta_20_in_40 & 0xf0) >> 4),
+				 (txp->delta_20_in_40 & 0x0f));
+
 		max_txp_avg = iwl_get_max_txpower_avg(priv, txp_array, idx,
 						      &max_txp_avg_halfdbm);
 
-- 
1.7.0.4

