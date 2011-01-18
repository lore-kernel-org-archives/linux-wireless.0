Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22576 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1ARQKY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 11:10:24 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6.38] iwlwifi: fix valid chain reading from EEPROM
Date: Tue, 18 Jan 2011 07:59:13 -0800
Message-Id: <1295366353-8875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When read valid tx/rx chains from EEPROM, there is a bug to use the
tx chain value for both tx and rx, the result of this cause low
receive throughput on 1x2 devices becuase rx will only utilize single
chain instead of two chains

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
---
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 97906dd..14ceb4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -168,7 +168,7 @@ int iwl_eeprom_check_sku(struct iwl_priv *priv)
 		/* not using .cfg overwrite */
 		radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
 		priv->cfg->valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
-		priv->cfg->valid_rx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
+		priv->cfg->valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
 		if (!priv->cfg->valid_tx_ant || !priv->cfg->valid_rx_ant) {
 			IWL_ERR(priv, "Invalid chain (0X%x, 0X%x)\n",
 				priv->cfg->valid_tx_ant,
-- 
1.7.0.4

