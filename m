Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39698 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbaKXOf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:28 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so5893457wid.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:26 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/75] iwlwifi: change max HT and VHT A-MPDU exponent
Date: Mon, 24 Nov 2014 16:33:54 +0200
Message-Id: <1416839691-28533-18-git-send-email-egrumbach@gmail.com> (sfid-20141124_154432_934069_43A948AA)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Add two new parameters to iwl_cfg:
max_ht_ampdu_exponent and max_vht_ampdu_exponent.
These parameters, if set, will set new values to the maximum of
HT and VHT A-MPDU exponent for the A-MPDU length exponent.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c         | 4 ++--
 drivers/net/wireless/iwlwifi/iwl-8000.c         | 7 +++++++
 drivers/net/wireless/iwlwifi/iwl-config.h       | 6 ++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c | 2 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    | 5 ++++-
 5 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index b04b885..b4e9bc7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -132,8 +132,8 @@ static const struct iwl_ht_params iwl7000_ht_params = {
 	.base_params = &iwl7000_base_params,			\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_7000,	\
-	.non_shared_ant = ANT_A
-
+	.non_shared_ant = ANT_A,				\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 const struct iwl_cfg iwl7260_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 7260",
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 896ea90..0919759 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -91,6 +91,10 @@
 /* Max SDIO RX aggregation size of the ADDBA request/response */
 #define MAX_RX_AGG_SIZE_8260_SDIO	28
 
+/* Max A-MPDU exponent for HT and VHT */
+#define MAX_HT_AMPDU_EXPONENT_8260_SDIO	IEEE80211_HT_MAX_AMPDU_32K
+#define MAX_VHT_AMPDU_EXPONENT_8260_SDIO	IEEE80211_VHT_MAX_AMPDU_32K
+
 static const struct iwl_base_params iwl8000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_8000,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
@@ -137,6 +141,7 @@ const struct iwl_cfg iwl8260_2ac_cfg = {
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
@@ -149,6 +154,8 @@ const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
 	.disable_dummy_notification = true,
+	.max_ht_ampdu_exponent  = MAX_HT_AMPDU_EXPONENT_8260_SDIO,
+	.max_vht_ampdu_exponent = MAX_VHT_AMPDU_EXPONENT_8260_SDIO,
 };
 
 MODULE_FIRMWARE(IWL8000_MODULE_FIRMWARE(IWL8000_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index f8aa9cf..c6ae4d4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -257,6 +257,10 @@ struct iwl_pwr_tx_backoff {
  * @pwr_tx_backoffs: translation table between power limits and backoffs
  * @max_rx_agg_size: max RX aggregation size of the ADDBA request/response
  * @max_tx_agg_size: max TX aggregation size of the ADDBA request/response
+ * @max_ht_ampdu_factor: the exponent of the max length of A-MPDU that the
+ *	station can receive in HT
+ * @max_vht_ampdu_exponent: the exponent of the max length of A-MPDU that the
+ *	station can receive in VHT
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -297,6 +301,8 @@ struct iwl_cfg {
 	unsigned int max_rx_agg_size;
 	bool disable_dummy_notification;
 	unsigned int max_tx_agg_size;
+	unsigned int max_ht_ampdu_exponent;
+	unsigned int max_vht_ampdu_exponent;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index 74b796d..41ff85d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -764,7 +764,7 @@ void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 	if (iwlwifi_mod_params.amsdu_size_8K)
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
-	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+	ht_info->ampdu_factor = cfg->max_ht_ampdu_exponent;
 	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_4;
 
 	ht_info->mcs.rx_mask[0] = 0xFF;
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index c302e74..06e02fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -325,6 +325,8 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 {
 	int num_rx_ants = num_of_ant(rx_chains);
 	int num_tx_ants = num_of_ant(tx_chains);
+	unsigned int max_ampdu_exponent = (cfg->max_vht_ampdu_exponent ?:
+					   IEEE80211_VHT_MAX_AMPDU_1024K);
 
 	vht_cap->vht_supported = true;
 
@@ -332,7 +334,8 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 		       IEEE80211_VHT_CAP_RXSTBC_1 |
 		       IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
 		       3 << IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT |
-		       7 << IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
+		       max_ampdu_exponent <<
+		       IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
 
 	if (cfg->ht_params->ldpc)
 		vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC;
-- 
1.9.1

