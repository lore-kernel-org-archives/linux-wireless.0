Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:49900 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaIOFN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:26 -0400
Received: by mail-we0-f175.google.com with SMTP id w61so3364624wes.20
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:25 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/28] iwlwifi: define the non shared antenna per hardware
Date: Mon, 15 Sep 2014 08:12:46 +0300
Message-Id: <1410757980-2138-14-git-send-email-egrumbach@gmail.com> (sfid-20140915_073114_216933_AB179FD8)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The sharing model will differ in new hardware. Define the
non shared antenna based on the device so that different
devices can have different names for the non shared antenna.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   | 3 ++-
 drivers/net/wireless/iwlwifi/iwl-8000.c   | 3 ++-
 drivers/net/wireless/iwlwifi/iwl-config.h | 2 ++
 drivers/net/wireless/iwlwifi/mvm/coex.c   | 4 ++++
 drivers/net/wireless/iwlwifi/mvm/tx.c     | 2 +-
 5 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 79c8f74..b04b885 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -131,7 +131,8 @@ static const struct iwl_ht_params iwl7000_ht_params = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.base_params = &iwl7000_base_params,			\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_7000
+	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_7000,	\
+	.non_shared_ant = ANT_A
 
 
 const struct iwl_cfg iwl7260_2ac_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index db67631..4ae8ba6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -116,7 +116,8 @@ static const struct iwl_ht_params iwl8000_ht_params = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.base_params = &iwl8000_base_params,			\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_8000
+	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_8000,	\
+	.non_shared_ant = ANT_A
 
 const struct iwl_cfg iwl8260_2n_cfg = {
 	.name = "Intel(R) Dual Band Wireless N 8260",
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 687e9e1..2ef83a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -230,6 +230,7 @@ struct iwl_pwr_tx_backoff {
  * @max_data_size: The maximal length of the fw data section
  * @valid_tx_ant: valid transmit antenna
  * @valid_rx_ant: valid receive antenna
+ * @non_shared_ant: the antenna that is for WiFi only
  * @nvm_ver: NVM version
  * @nvm_calib_ver: NVM calibration version
  * @lib: pointer to the lib ops
@@ -262,6 +263,7 @@ struct iwl_cfg {
 	const u32 max_inst_size;
 	u8   valid_tx_ant;
 	u8   valid_rx_ant;
+	u8   non_shared_ant;
 	bool bt_shared_single_ant;
 	u16  nvm_ver;
 	u16  nvm_calib_ver;
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 6e8f3e2a..8df2021 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -1146,6 +1146,10 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 
 bool iwl_mvm_bt_coex_is_shared_ant_avail(struct iwl_mvm *mvm)
 {
+	/* there is no other antenna, shared antenna is always available */
+	if (mvm->cfg->bt_shared_single_ant)
+		return true;
+
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_bt_coex_is_shared_ant_avail_old(mvm);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index ed09194..c67296e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -213,7 +213,7 @@ static void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm,
 
 	if (info->band == IEEE80211_BAND_2GHZ &&
 	    !iwl_mvm_bt_coex_is_shared_ant_avail(mvm))
-		rate_flags = BIT(ANT_A) << RATE_MCS_ANT_POS;
+		rate_flags = BIT(mvm->cfg->non_shared_ant) << RATE_MCS_ANT_POS;
 	else
 		rate_flags =
 			BIT(mvm->mgmt_last_antenna_idx) << RATE_MCS_ANT_POS;
-- 
1.9.1

