Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63426 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbbHRH6B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:01 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/26] iwlwifi: Add max TX aggregation size for 8260 SDIO devices series
Date: Tue, 18 Aug 2015 10:57:15 +0300
Message-Id: <1439884656-18146-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_095809_967395_2AC3B3AE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Set max TX aggregation size for 8260 SDIO devices series to 40 frames.
Fine tune max RX aggregation size - change it to 21.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 7caea69..92709ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -97,8 +97,9 @@
 #define DEFAULT_NVM_FILE_FAMILY_8000B		"nvmData-8000B"
 #define DEFAULT_NVM_FILE_FAMILY_8000C		"nvmData-8000C"
 
-/* Max SDIO RX aggregation size of the ADDBA request/response */
-#define MAX_RX_AGG_SIZE_8260_SDIO	28
+/* Max SDIO RX/TX aggregation sizes of the ADDBA request/response */
+#define MAX_RX_AGG_SIZE_8260_SDIO	21
+#define MAX_TX_AGG_SIZE_8260_SDIO	40
 
 /* Max A-MPDU exponent for HT and VHT */
 #define MAX_HT_AMPDU_EXPONENT_8260_SDIO	IEEE80211_HT_MAX_AMPDU_32K
@@ -204,6 +205,7 @@ const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
+	.max_tx_agg_size = MAX_TX_AGG_SIZE_8260_SDIO,
 	.disable_dummy_notification = true,
 	.max_ht_ampdu_exponent  = MAX_HT_AMPDU_EXPONENT_8260_SDIO,
 	.max_vht_ampdu_exponent = MAX_VHT_AMPDU_EXPONENT_8260_SDIO,
@@ -217,6 +219,7 @@ const struct iwl_cfg iwl4165_2ac_sdio_cfg = {
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
+	.max_tx_agg_size = MAX_TX_AGG_SIZE_8260_SDIO,
 	.bt_shared_single_ant = true,
 	.disable_dummy_notification = true,
 	.max_ht_ampdu_exponent  = MAX_HT_AMPDU_EXPONENT_8260_SDIO,
-- 
2.1.4

