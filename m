Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2FFNXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 13/29] iwlwifi: unify tx_chains_num setting
Date: Wed,  6 Jun 2012 15:21:54 +0200
Message-Id: <1338988930-11561-13-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152404_200009_59AEA606)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to copy the same code for all
devices since none of the 5000 series devices
(that don't have the RX SISO override) don't
set the rx_with_siso_diversity variable.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/devices.c |   34 ----------------------------
 drivers/net/wireless/iwlwifi/dvm/eeprom.c  |    8 +++++++
 2 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index ac5675d..7d3bb1e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -173,14 +173,6 @@ static void iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
-	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->hw_params.valid_tx_ant);
-	if (priv->cfg->rx_with_siso_diversity)
-		priv->hw_params.rx_chains_num = 1;
-	else
-		priv->hw_params.rx_chains_num =
-			num_of_ant(priv->hw_params.valid_rx_ant);
-
 	iwl1000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
@@ -254,14 +246,6 @@ static void iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
-	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->hw_params.valid_tx_ant);
-	if (priv->cfg->rx_with_siso_diversity)
-		priv->hw_params.rx_chains_num = 1;
-	else
-		priv->hw_params.rx_chains_num =
-			num_of_ant(priv->hw_params.valid_rx_ant);
-
 	iwl2000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
@@ -408,11 +392,6 @@ static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->hw_params.valid_tx_ant);
-	priv->hw_params.rx_chains_num =
-		num_of_ant(priv->hw_params.valid_rx_ant);
-
 	iwl5000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
@@ -424,11 +403,6 @@ static void iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->hw_params.valid_tx_ant);
-	priv->hw_params.rx_chains_num =
-		num_of_ant(priv->hw_params.valid_rx_ant);
-
 	iwl5150_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
@@ -623,14 +597,6 @@ static void iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->hw_params.valid_tx_ant);
-	if (priv->cfg->rx_with_siso_diversity)
-		priv->hw_params.rx_chains_num = 1;
-	else
-		priv->hw_params.rx_chains_num =
-			num_of_ant(priv->hw_params.valid_rx_ant);
-
 	iwl6000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
diff --git a/drivers/net/wireless/iwlwifi/dvm/eeprom.c b/drivers/net/wireless/iwlwifi/dvm/eeprom.c
index 69d280f..b4da76d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/eeprom.c
+++ b/drivers/net/wireless/iwlwifi/dvm/eeprom.c
@@ -285,6 +285,14 @@ int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 		return -EINVAL;
 	}
 
+	priv->hw_params.tx_chains_num =
+		num_of_ant(priv->hw_params.valid_tx_ant);
+	if (priv->cfg->rx_with_siso_diversity)
+		priv->hw_params.rx_chains_num = 1;
+	else
+		priv->hw_params.rx_chains_num =
+			num_of_ant(priv->hw_params.valid_rx_ant);
+
 	IWL_INFO(priv, "Valid Tx ant: 0x%X, Valid Rx ant: 0x%X\n",
 		 priv->hw_params.valid_tx_ant, priv->hw_params.valid_rx_ant);
 
-- 
1.7.10

