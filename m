Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab2KIUJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:09:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/13] iwlwifi: remove SKU/antenna messages by default
Date: Fri,  9 Nov 2012 21:08:09 +0100
Message-Id: <1352491692-28994-11-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210914_657454_50C6251F)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no reason to print these all the time,
the messages aren't all that interesting. Leave
them as DEBUG_INFO though, just in case.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index bcaec84..03cbfa7 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1204,7 +1204,7 @@ static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 		return -EINVAL;
 	}
 
-	IWL_INFO(priv, "Device SKU: 0x%X\n", priv->eeprom_data->sku);
+	IWL_DEBUG_INFO(priv, "Device SKU: 0x%X\n", priv->eeprom_data->sku);
 
 	priv->hw_params.tx_chains_num =
 		num_of_ant(priv->eeprom_data->valid_tx_ant);
@@ -1214,9 +1214,9 @@ static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 		priv->hw_params.rx_chains_num =
 			num_of_ant(priv->eeprom_data->valid_rx_ant);
 
-	IWL_INFO(priv, "Valid Tx ant: 0x%X, Valid Rx ant: 0x%X\n",
-		 priv->eeprom_data->valid_tx_ant,
-		 priv->eeprom_data->valid_rx_ant);
+	IWL_DEBUG_INFO(priv, "Valid Tx ant: 0x%X, Valid Rx ant: 0x%X\n",
+		       priv->eeprom_data->valid_tx_ant,
+		       priv->eeprom_data->valid_rx_ant);
 
 	return 0;
 }
-- 
1.8.0

