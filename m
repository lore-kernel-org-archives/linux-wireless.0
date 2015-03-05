Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:54805 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbbCEMuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 07:50:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 6/7] iwlwifi: fix max_ht_ampdu_exponent for older devices
Date: Thu,  5 Mar 2015 14:49:52 +0200
Message-Id: <1425559793-25131-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150305_135021_724806_611C6A08)
In-Reply-To: <1425558068.22928.3.camel@egrumbacBox>
References: <1425558068.22928.3.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit below didn't update the max_ht_ampdu_exponent
for the devices listed in iwl-[1-6]000.c which, in result,
became 0 instead of 8K. This reduced the size of the Rx
AMPDU from 64K to 8K which had an impact in the Rx
throughput. One user reported that because of this, his
downstream throughput droppped by a half.

CC: <stable@vger.kernel.org> [3.19]
Fixes: c064ddf318aa ("iwlwifi: change max HT and VHT A-MPDU exponent")
Reported-and-tested-by: Valentin Manea <linux-wireless@mrs.ro>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |  6 ++++--
 drivers/net/wireless/iwlwifi/iwl-2000.c | 13 +++++++++----
 drivers/net/wireless/iwlwifi/iwl-5000.c |  6 ++++--
 drivers/net/wireless/iwlwifi/iwl-6000.c | 18 ++++++++++++------
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index c3817fa..06f6cc0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -95,7 +95,8 @@ static const struct iwl_eeprom_params iwl1000_eeprom_params = {
 	.nvm_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
 	.base_params = &iwl1000_base_params,			\
 	.eeprom_params = &iwl1000_eeprom_params,		\
-	.led_mode = IWL_LED_BLINK
+	.led_mode = IWL_LED_BLINK,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl1000_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1000 BGN",
@@ -121,7 +122,8 @@ const struct iwl_cfg iwl1000_bg_cfg = {
 	.base_params = &iwl1000_base_params,			\
 	.eeprom_params = &iwl1000_eeprom_params,		\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.rx_with_siso_diversity = true
+	.rx_with_siso_diversity = true,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl100_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 100 BGN",
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 21e5d08..890b95f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -123,7 +123,9 @@ static const struct iwl_eeprom_params iwl20x0_eeprom_params = {
 	.nvm_calib_ver = EEPROM_2000_TX_POWER_VERSION,		\
 	.base_params = &iwl2000_base_params,			\
 	.eeprom_params = &iwl20x0_eeprom_params,		\
-	.led_mode = IWL_LED_RF_STATE
+	.led_mode = IWL_LED_RF_STATE,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
+
 
 const struct iwl_cfg iwl2000_2bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 2200 BGN",
@@ -149,7 +151,8 @@ const struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.nvm_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.base_params = &iwl2030_base_params,			\
 	.eeprom_params = &iwl20x0_eeprom_params,		\
-	.led_mode = IWL_LED_RF_STATE
+	.led_mode = IWL_LED_RF_STATE,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl2030_2bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 2230 BGN",
@@ -170,7 +173,8 @@ const struct iwl_cfg iwl2030_2bgn_cfg = {
 	.base_params = &iwl2000_base_params,			\
 	.eeprom_params = &iwl20x0_eeprom_params,		\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.rx_with_siso_diversity = true
+	.rx_with_siso_diversity = true,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl105_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 105 BGN",
@@ -197,7 +201,8 @@ const struct iwl_cfg iwl105_bgn_d_cfg = {
 	.base_params = &iwl2030_base_params,			\
 	.eeprom_params = &iwl20x0_eeprom_params,		\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.rx_with_siso_diversity = true
+	.rx_with_siso_diversity = true,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl135_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 135 BGN",
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 332bbede..724194e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -93,7 +93,8 @@ static const struct iwl_eeprom_params iwl5000_eeprom_params = {
 	.nvm_calib_ver = EEPROM_5000_TX_POWER_VERSION,	\
 	.base_params = &iwl5000_base_params,			\
 	.eeprom_params = &iwl5000_eeprom_params,		\
-	.led_mode = IWL_LED_BLINK
+	.led_mode = IWL_LED_BLINK,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl5300_agn_cfg = {
 	.name = "Intel(R) Ultimate N WiFi Link 5300 AGN",
@@ -158,7 +159,8 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.base_params = &iwl5000_base_params,			\
 	.eeprom_params = &iwl5000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK,				\
-	.internal_wimax_coex = true
+	.internal_wimax_coex = true,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl5150_agn_cfg = {
 	.name = "Intel(R) WiMAX/WiFi Link 5150 AGN",
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 8f2c3c8..21b2630 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -145,7 +145,8 @@ static const struct iwl_eeprom_params iwl6000_eeprom_params = {
 	.nvm_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
 	.base_params = &iwl6000_g2_base_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
-	.led_mode = IWL_LED_RF_STATE
+	.led_mode = IWL_LED_RF_STATE,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl6005_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205 AGN",
@@ -199,7 +200,8 @@ const struct iwl_cfg iwl6005_2agn_mow2_cfg = {
 	.nvm_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
 	.base_params = &iwl6000_g2_base_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
-	.led_mode = IWL_LED_RF_STATE
+	.led_mode = IWL_LED_RF_STATE,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl6030_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 AGN",
@@ -235,7 +237,8 @@ const struct iwl_cfg iwl6030_2bg_cfg = {
 	.nvm_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
 	.base_params = &iwl6000_g2_base_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
-	.led_mode = IWL_LED_RF_STATE
+	.led_mode = IWL_LED_RF_STATE,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl6035_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6235 AGN",
@@ -290,7 +293,8 @@ const struct iwl_cfg iwl130_bg_cfg = {
 	.nvm_calib_ver = EEPROM_6000_TX_POWER_VERSION,	\
 	.base_params = &iwl6000_base_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
-	.led_mode = IWL_LED_BLINK
+	.led_mode = IWL_LED_BLINK,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl6000i_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6200 AGN",
@@ -322,7 +326,8 @@ const struct iwl_cfg iwl6000i_2bg_cfg = {
 	.base_params = &iwl6050_base_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK,				\
-	.internal_wimax_coex = true
+	.internal_wimax_coex = true,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl6050_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N + WiMAX 6250 AGN",
@@ -347,7 +352,8 @@ const struct iwl_cfg iwl6050_2abg_cfg = {
 	.base_params = &iwl6050_base_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK,				\
-	.internal_wimax_coex = true
+	.internal_wimax_coex = true,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl6150_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N + WiMAX 6150 BGN",
-- 
1.9.1

