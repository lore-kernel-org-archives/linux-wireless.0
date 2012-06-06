Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2FFNXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 14/29] iwlwifi: move ht40 bitmap into config
Date: Wed,  6 Jun 2012 15:21:55 +0200
Message-Id: <1338988930-11561-14-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152404_759225_25B94EA3)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to dynamically fill the HT40
band bitmap as it's a device parameter, just
put it into the HT configuration.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/dev.h     |    2 --
 drivers/net/wireless/iwlwifi/dvm/devices.c |   13 -------------
 drivers/net/wireless/iwlwifi/dvm/main.c    |    9 ++++++---
 drivers/net/wireless/iwlwifi/iwl-config.h  |    5 ++++-
 drivers/net/wireless/iwlwifi/pcie/1000.c   |    1 +
 drivers/net/wireless/iwlwifi/pcie/2000.c   |    1 +
 drivers/net/wireless/iwlwifi/pcie/5000.c   |    1 +
 drivers/net/wireless/iwlwifi/pcie/6000.c   |    1 +
 8 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 2880a0a..af9de95 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -635,7 +635,6 @@ enum iwl_scan_type {
  * @rx_chains_num: Number of RX chains
  * @valid_tx_ant: usable antennas for TX
  * @valid_rx_ant: usable antennas for RX
- * @ht40_channel: is 40MHz width possible: BIT(IEEE80211_BAND_XXX)
  * @sku: sku read from EEPROM
  * @ct_kill_threshold: temperature threshold - in hw dependent unit
  * @ct_kill_exit_threshold: when to reeable the device - in hw dependent unit
@@ -648,7 +647,6 @@ struct iwl_hw_params {
 	u8  rx_chains_num;
 	u8  valid_tx_ant;
 	u8  valid_rx_ant;
-	u8  ht40_channel;
 	bool use_rts_for_aggregation;
 	u16 sku;
 	u32 ct_kill_threshold;
diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index 7d3bb1e..ddf053c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -171,8 +171,6 @@ static const struct iwl_sensitivity_ranges iwl1000_sensitivity = {
 
 static void iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
-
 	iwl1000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
@@ -244,8 +242,6 @@ static const struct iwl_sensitivity_ranges iwl2000_sensitivity = {
 
 static void iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
-
 	iwl2000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
@@ -389,9 +385,6 @@ static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 
 static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
-					BIT(IEEE80211_BAND_5GHZ);
-
 	iwl5000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
@@ -400,9 +393,6 @@ static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 static void iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 {
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
-					BIT(IEEE80211_BAND_5GHZ);
-
 	iwl5150_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
@@ -594,9 +584,6 @@ static const struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 
 static void iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
-					BIT(IEEE80211_BAND_5GHZ);
-
 	iwl6000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index d67ae99..4411887 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1157,16 +1157,19 @@ static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 
 	ht_info->cap = 0;
+	ht_info->ht_supported = false;
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
 
+	if (!priv->cfg->ht_params)
+		return;
+
 	ht_info->ht_supported = true;
 
-	if (priv->cfg->ht_params &&
-	    priv->cfg->ht_params->ht_greenfield_support)
+	if (priv->cfg->ht_params->ht_greenfield_support)
 		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
-	if (priv->hw_params.ht40_channel & BIT(band)) {
+	if (priv->cfg->ht_params->ht40_bands & BIT(band)) {
 		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 		ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
 		ht_info->mcs.rx_mask[4] = 0x01;
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index a52818b..af3a461 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -182,13 +182,16 @@ struct iwl_bt_params {
 	bool bt_sco_disable;
 	bool bt_session_2;
 };
+
 /*
  * @use_rts_for_aggregation: use rts/cts protection for HT traffic
+ * @ht40_bands: bitmap of bands (using %IEEE80211_BAND_*) that support HT40
  */
 struct iwl_ht_params {
+	enum ieee80211_smps_mode smps_mode;
 	const bool ht_greenfield_support; /* if used set to true */
 	bool use_rts_for_aggregation;
-	enum ieee80211_smps_mode smps_mode;
+	u8 ht40_bands;
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/pcie/1000.c b/drivers/net/wireless/iwlwifi/pcie/1000.c
index 0cfbf9f..174cf5e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/1000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/1000.c
@@ -71,6 +71,7 @@ static const struct iwl_base_params iwl1000_base_params = {
 static const struct iwl_ht_params iwl1000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
+	.ht40_bands = BIT(IEEE80211_BAND_2GHZ),
 };
 
 #define IWL_DEVICE_1000						\
diff --git a/drivers/net/wireless/iwlwifi/pcie/2000.c b/drivers/net/wireless/iwlwifi/pcie/2000.c
index 062c07b..8d4d729 100644
--- a/drivers/net/wireless/iwlwifi/pcie/2000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/2000.c
@@ -104,6 +104,7 @@ static const struct iwl_base_params iwl2030_base_params = {
 static const struct iwl_ht_params iwl2000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
+	.ht40_bands = BIT(IEEE80211_BAND_2GHZ),
 };
 
 static const struct iwl_bt_params iwl2030_bt_params = {
diff --git a/drivers/net/wireless/iwlwifi/pcie/5000.c b/drivers/net/wireless/iwlwifi/pcie/5000.c
index 92e502e..75d90a9 100644
--- a/drivers/net/wireless/iwlwifi/pcie/5000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/5000.c
@@ -69,6 +69,7 @@ static const struct iwl_base_params iwl5000_base_params = {
 
 static const struct iwl_ht_params iwl5000_ht_params = {
 	.ht_greenfield_support = true,
+	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
 };
 
 #define IWL_DEVICE_5000						\
diff --git a/drivers/net/wireless/iwlwifi/pcie/6000.c b/drivers/net/wireless/iwlwifi/pcie/6000.c
index f9e3961..7b9c02c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/6000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/6000.c
@@ -124,6 +124,7 @@ static const struct iwl_base_params iwl6000_g2_base_params = {
 static const struct iwl_ht_params iwl6000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
+	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
 };
 
 static const struct iwl_bt_params iwl6000_bt_params = {
-- 
1.7.10

