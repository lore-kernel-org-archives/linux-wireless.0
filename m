Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934537Ab1IOTcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/27] iwlagn: replace beacon_time_fsf_bits variable with #define
Date: Thu, 15 Sep 2011 11:46:39 -0700
Message-Id: <1316112414-6341-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213238_844507_E7605278)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

All devices use the same value for beacon_time_tsf_bits.  Use the #define

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    2 --
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    4 ----
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    2 --
 drivers/net/wireless/iwlwifi/iwl-core.c   |   21 ++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 --
 6 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5eba5d9..dacbe3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -161,8 +161,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 	if (priv->cfg->need_dc_calib)
 		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_DC);
 
-	hw_params(priv).beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index ba138a5..82719b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -159,8 +159,6 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 	if (priv->cfg->need_temp_offset_calib)
 		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_TEMP_OFFSET);
 
-	hw_params(priv).beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 327ebf6..de7f7f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -184,8 +184,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 		BIT(IWL_CALIB_TX_IQ_PERD)	|
 		BIT(IWL_CALIB_BASE_BAND);
 
-	hw_params(priv).beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
-
 	return 0;
 }
 
@@ -223,8 +221,6 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 	if (priv->cfg->need_dc_calib)
 		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_DC);
 
-	hw_params(priv).beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index d443785..5c1a8b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -180,8 +180,6 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	if (priv->cfg->need_temp_offset_calib)
 		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_TEMP_OFFSET);
 
-	hw_params(priv).beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 90ab27e..0a426cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1803,13 +1803,12 @@ u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval)
 		return 0;
 
 	quot = (usec / interval) &
-		(iwl_beacon_time_mask_high(priv,
-		hw_params(priv).beacon_time_tsf_bits) >>
-		hw_params(priv).beacon_time_tsf_bits);
+		(iwl_beacon_time_mask_high(priv, IWLAGN_EXT_BEACON_TIME_POS) >>
+		IWLAGN_EXT_BEACON_TIME_POS);
 	rem = (usec % interval) & iwl_beacon_time_mask_low(priv,
-				   hw_params(priv).beacon_time_tsf_bits);
+				   IWLAGN_EXT_BEACON_TIME_POS);
 
-	return (quot << hw_params(priv).beacon_time_tsf_bits) + rem;
+	return (quot << IWLAGN_EXT_BEACON_TIME_POS) + rem;
 }
 
 /* base is usually what we get from ucode with each received frame,
@@ -1819,22 +1818,22 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 			   u32 addon, u32 beacon_interval)
 {
 	u32 base_low = base & iwl_beacon_time_mask_low(priv,
-				hw_params(priv).beacon_time_tsf_bits);
+				IWLAGN_EXT_BEACON_TIME_POS);
 	u32 addon_low = addon & iwl_beacon_time_mask_low(priv,
-				hw_params(priv).beacon_time_tsf_bits);
+				IWLAGN_EXT_BEACON_TIME_POS);
 	u32 interval = beacon_interval * TIME_UNIT;
 	u32 res = (base & iwl_beacon_time_mask_high(priv,
-				hw_params(priv).beacon_time_tsf_bits)) +
+				IWLAGN_EXT_BEACON_TIME_POS)) +
 				(addon & iwl_beacon_time_mask_high(priv,
-				hw_params(priv).beacon_time_tsf_bits));
+				IWLAGN_EXT_BEACON_TIME_POS));
 
 	if (base_low > addon_low)
 		res += base_low - addon_low;
 	else if (base_low < addon_low) {
 		res += interval + base_low - addon_low;
-		res += (1 << hw_params(priv).beacon_time_tsf_bits);
+		res += (1 << IWLAGN_EXT_BEACON_TIME_POS);
 	} else
-		res += (1 << hw_params(priv).beacon_time_tsf_bits);
+		res += (1 << IWLAGN_EXT_BEACON_TIME_POS);
 
 	return cpu_to_le32(res);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 810b3e1..8272a94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -167,7 +167,6 @@ struct iwl_mod_params {
  * @valid_rx_ant: usable antennas for RX
  * @max_stations: the maximal number of stations
  * @ht40_channel: is 40MHz width possible: BIT(IEEE80211_BAND_XXX)
- * @beacon_time_tsf_bits: number of valid tsf bits for beacon time
  * @sku: sku read from EEPROM
  * @rx_page_order: Rx buffer page order
  * @max_inst_size: for ucode use
@@ -190,7 +189,6 @@ struct iwl_hw_params {
 	u8  max_stations;
 	u8  ht40_channel;
 	bool shadow_reg_enable;
-	u16 beacon_time_tsf_bits;
 	u16 sku;
 	u32 rx_page_order;
 	u32 max_inst_size;
-- 
1.7.0.4

