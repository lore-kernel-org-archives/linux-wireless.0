Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab0LWOMo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 09:12:44 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2] iwlagn: fix scan tx antenna setting on 5Ghz band
Date: Thu, 23 Dec 2010 15:12:30 +0100
Message-Id: <1293113550-10977-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks that we do not set correctly antennas when scanning
on 5Ghz band and when bluetooth is enabled, because
priv->cfg->scan_tx_antennas[band] is only defined for
IEEE80211_BAND_2GHZ.

To fix we check band before limiting antennas to first one.
This allow to remove hard coded cfg->scan_tx_antennas[band].

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2:
- limit tx scan antennas only on 2GHz band
- remove not needed struct iwl_cfg field

 drivers/net/wireless/iwlwifi/iwl-6000.c    |    7 +------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   14 +++++---------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f4bec32..af505bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -596,12 +596,7 @@ struct iwl_cfg iwl6005_2bg_cfg = {
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.adv_pm = true,						\
-	/*							\
-	 *Due to bluetooth, we transmit 2.4 GHz probes		\
-	 * only on antenna A					\
-	 */							\
-	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A
+	.adv_pm = true						\
 
 struct iwl_cfg iwl6030_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 AGN",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 4bc82fc..3dee87e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1492,15 +1492,11 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (priv->cfg->scan_rx_antennas[band])
 		rx_ant = priv->cfg->scan_rx_antennas[band];
 
-	if (priv->cfg->scan_tx_antennas[band])
-		scan_tx_antennas = priv->cfg->scan_tx_antennas[band];
-
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist &&
-	    priv->bt_full_concurrent) {
-		/* operated as 1x1 in full concurrency mode */
-		scan_tx_antennas = first_antenna(
-			priv->cfg->scan_tx_antennas[band]);
+	if (band == IEEE80211_BAND_2GHZ &&
+	    priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
+		/* transmit 2.4 GHz probes only on first antenna */
+		scan_tx_antennas = first_antenna(scan_tx_antennas);
 	}
 
 	priv->scan_tx_ant[band] = iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band],
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f80685a..a347437 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -411,7 +411,6 @@ struct iwl_cfg {
 	const bool need_dc_calib;	  /* if used set to true */
 	const bool need_temp_offset_calib; /* if used set to true */
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
-	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 	enum iwl_led_mode led_mode;
 	const bool adv_pm;
 	const bool rx_with_siso_diversity;
-- 
1.7.1

