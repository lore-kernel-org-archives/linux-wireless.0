Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40709 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab0KJSBH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:07 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/16] iwlwifi: disable disconnected antenna for advanced bt coex
Date: Wed, 10 Nov 2010 09:56:49 -0800
Message-Id: <1289411810-23093-16-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Disconnected antenna algorithm is used to find out which antennas are
disconnected. It should be disabled for devices that support advanced
bluetooth coexist.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index b4cfc3c..d16bb5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -801,13 +801,7 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 	 * To be safe, simply mask out any chains that we know
 	 * are not on the device.
 	 */
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist &&
-	    priv->bt_full_concurrent) {
-		/* operated as 1x1 in full concurrency mode */
-		active_chains &= first_antenna(priv->hw_params.valid_rx_ant);
-	} else
-		active_chains &= priv->hw_params.valid_rx_ant;
+	active_chains &= priv->hw_params.valid_rx_ant;
 
 	num_tx_chains = 0;
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
@@ -985,7 +979,16 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 		return;
 
 	/* Analyze signal for disconnected antenna */
-	iwl_find_disconn_antenna(priv, average_sig, data);
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
+		/* Disable disconnected antenna algorithm for advanced
+		   bt coex, assuming valid antennas are connected */
+		data->active_chains = priv->hw_params.valid_rx_ant;
+		for (i = 0; i < NUM_RX_CHAINS; i++)
+			if (!(data->active_chains & (1<<i)))
+				data->disconn_array[i] = 1;
+	} else
+		iwl_find_disconn_antenna(priv, average_sig, data);
 
 	/* Analyze noise for rx balance */
 	average_noise[0] = data->chain_noise_a /
-- 
1.7.0.4

