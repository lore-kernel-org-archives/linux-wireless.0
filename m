Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49515 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab1GWSBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 14:01:20 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/11] iwlagn: Remove ht40 support from 5.2GHz for _bgn devices
Date: Sat, 23 Jul 2011 10:24:42 -0700
Message-Id: <1311441890-19959-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110723_200136_060746_A4691918)
In-Reply-To: <1311441890-19959-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311441890-19959-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For _bgn device, remove ht40 support for 5.2GHz, it is probably ok since
the "band" is not support but just feel strange.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-2000.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index d502004..97b9c74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -135,8 +135,7 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
 
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
-					BIT(IEEE80211_BAND_5GHZ);
+	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
 	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
 	if (priv->cfg->rx_with_siso_diversity)
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 0e13f0b..d557ef3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -130,8 +130,7 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_data_size = IWL60_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWL60_RTC_INST_SIZE;
 
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
-					BIT(IEEE80211_BAND_5GHZ);
+	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
 	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
 	if (priv->cfg->rx_with_siso_diversity)
-- 
1.7.0.4

