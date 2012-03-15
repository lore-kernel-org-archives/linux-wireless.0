Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21225 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161445Ab2COU2E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:04 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/26] iwlwifi: remove scan_rx_antennas
Date: Thu, 15 Mar 2012 13:26:50 -0700
Message-Id: <1331843226-29860-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212849_580509_03F13FF9)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is not (no longer?) used by any device
so just remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c   |    3 ---
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 902efe4..863ad0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -793,9 +793,6 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	band = priv->scan_band;
 
-	if (cfg(priv)->scan_rx_antennas[band])
-		rx_ant = cfg(priv)->scan_rx_antennas[band];
-
 	if (band == IEEE80211_BAND_2GHZ &&
 	    cfg(priv)->bt_params &&
 	    cfg(priv)->bt_params->advanced_bt_coexist) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 229c4b9..f53feb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -297,7 +297,6 @@ struct iwl_ht_params {
  * @need_temp_offset_calib: need to perform temperature offset calibration
  * @no_xtal_calib: some devices do not need crystal calibration data,
  *	don't send it to those
- * @scan_rx_antennas: available antenna for scan operation
  * @led_mode: 0=blinking, 1=On(RF On)/Off(RF Off)
  * @adv_pm: advance power management
  * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
@@ -330,7 +329,6 @@ struct iwl_cfg {
 	const struct iwl_bt_params *bt_params;
 	const bool need_temp_offset_calib; /* if used set to true */
 	const bool no_xtal_calib;
-	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
 	enum iwl_led_mode led_mode;
 	const bool adv_pm;
 	const bool rx_with_siso_diversity;
-- 
1.7.0.4

