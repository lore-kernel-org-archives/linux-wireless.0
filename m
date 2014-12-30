Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12344 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaL3OTp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:45 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/33] iwlwifi: mvm: add fw runtime stack to dump data
Date: Tue, 30 Dec 2014 16:18:37 +0200
Message-Id: <1419949148-24046-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_151948_753858_94C58DE8)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

The allocation of the DCCM between the data and the stack
can theoretically change without notice to the driver, but
the total size is HW-fixed. Since the stack CCM (runtime
stack) has also data important to the FW - this patch allows
pulling the whole DCCM in one piece and adds it to the dump
data.

If the size isn't known - just use the data part of the
DCCM as it appears in the FW TLVs.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c     | 23 ++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-8000.c     |  8 +++++++-
 drivers/net/wireless/iwlwifi/iwl-config.h   |  4 ++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 15 +++++++++++----
 4 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index e5be2d2..9e76799 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -92,6 +92,12 @@
 #define IWL7265D_NVM_VERSION		0x0c11
 #define IWL7265_TX_POWER_VERSION	0xffff /* meaningless */
 
+/* DCCM offsets and lengths */
+#define IWL7000_DCCM_OFFSET		0x800000
+#define IWL7260_DCCM_LEN		0x14000
+#define IWL3160_DCCM_LEN		0x10000
+#define IWL7265_DCCM_LEN		0x17A00
+
 #define IWL7260_FW_PRE "iwlwifi-7260-"
 #define IWL7260_MODULE_FIRMWARE(api) IWL7260_FW_PRE __stringify(api) ".ucode"
 
@@ -138,7 +144,8 @@ static const struct iwl_ht_params iwl7000_ht_params = {
 	.led_mode = IWL_LED_RF_STATE,				\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_7000,	\
 	.non_shared_ant = ANT_A,				\
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,	\
+	.dccm_offset = IWL7000_DCCM_OFFSET
 
 const struct iwl_cfg iwl7260_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 7260",
@@ -149,6 +156,7 @@ const struct iwl_cfg iwl7260_2ac_cfg = {
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
 	.lp_xtal_workaround = true,
+	.dccm_len = IWL7260_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl7260_2ac_cfg_high_temp = {
@@ -161,6 +169,7 @@ const struct iwl_cfg iwl7260_2ac_cfg_high_temp = {
 	.high_temp = true,
 	.host_interrupt_operation_mode = true,
 	.lp_xtal_workaround = true,
+	.dccm_len = IWL7260_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl7260_2n_cfg = {
@@ -172,6 +181,7 @@ const struct iwl_cfg iwl7260_2n_cfg = {
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
 	.lp_xtal_workaround = true,
+	.dccm_len = IWL7260_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl7260_n_cfg = {
@@ -183,6 +193,7 @@ const struct iwl_cfg iwl7260_n_cfg = {
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
 	.lp_xtal_workaround = true,
+	.dccm_len = IWL7260_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl3160_2ac_cfg = {
@@ -193,6 +204,7 @@ const struct iwl_cfg iwl3160_2ac_cfg = {
 	.nvm_ver = IWL3160_NVM_VERSION,
 	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
+	.dccm_len = IWL3160_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl3160_2n_cfg = {
@@ -203,6 +215,7 @@ const struct iwl_cfg iwl3160_2n_cfg = {
 	.nvm_ver = IWL3160_NVM_VERSION,
 	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
+	.dccm_len = IWL3160_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl3160_n_cfg = {
@@ -213,6 +226,7 @@ const struct iwl_cfg iwl3160_n_cfg = {
 	.nvm_ver = IWL3160_NVM_VERSION,
 	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
+	.dccm_len = IWL3160_DCCM_LEN,
 };
 
 static const struct iwl_pwr_tx_backoff iwl7265_pwr_tx_backoffs[] = {
@@ -240,6 +254,7 @@ const struct iwl_cfg iwl3165_2ac_cfg = {
 	.nvm_ver = IWL3165_NVM_VERSION,
 	.nvm_calib_ver = IWL3165_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+	.dccm_len = IWL7265_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl7265_2ac_cfg = {
@@ -250,6 +265,7 @@ const struct iwl_cfg iwl7265_2ac_cfg = {
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+	.dccm_len = IWL7265_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl7265_2n_cfg = {
@@ -260,6 +276,7 @@ const struct iwl_cfg iwl7265_2n_cfg = {
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+	.dccm_len = IWL7265_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl7265_n_cfg = {
@@ -270,6 +287,7 @@ const struct iwl_cfg iwl7265_n_cfg = {
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+	.dccm_len = IWL7265_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl7265d_2ac_cfg = {
@@ -280,6 +298,7 @@ const struct iwl_cfg iwl7265d_2ac_cfg = {
 	.nvm_ver = IWL7265D_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+	.dccm_len = IWL7265_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl7265d_2n_cfg = {
@@ -290,6 +309,7 @@ const struct iwl_cfg iwl7265d_2n_cfg = {
 	.nvm_ver = IWL7265D_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+	.dccm_len = IWL7265_DCCM_LEN,
 };
 
 const struct iwl_cfg iwl7265d_n_cfg = {
@@ -300,6 +320,7 @@ const struct iwl_cfg iwl7265d_n_cfg = {
 	.nvm_ver = IWL7265D_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+	.dccm_len = IWL7265_DCCM_LEN,
 };
 
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index bf0a95c..6c5c558 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -81,6 +81,10 @@
 #define IWL8000_NVM_VERSION		0x0a1d
 #define IWL8000_TX_POWER_VERSION	0xffff /* meaningless */
 
+/* DCCM offsets and lengths */
+#define IWL8260_DCCM_OFFSET		0x800000
+#define IWL8260_DCCM_LEN		0x18000
+
 #define IWL8000_FW_PRE "iwlwifi-8000"
 #define IWL8000_MODULE_FIRMWARE(api) \
 	IWL8000_FW_PRE "-" __stringify(api) ".ucode"
@@ -124,7 +128,9 @@ static const struct iwl_ht_params iwl8000_ht_params = {
 	.led_mode = IWL_LED_RF_STATE,				\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_8000,	\
 	.d0i3 = true,						\
-	.non_shared_ant = ANT_A
+	.non_shared_ant = ANT_A,				\
+	.dccm_offset = IWL8260_DCCM_OFFSET,			\
+	.dccm_len = IWL8260_DCCM_LEN
 
 const struct iwl_cfg iwl8260_2n_cfg = {
 	.name = "Intel(R) Dual Band Wireless N 8260",
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 3a4b9c7..31c67df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -261,6 +261,8 @@ struct iwl_pwr_tx_backoff {
  *	station can receive in HT
  * @max_vht_ampdu_exponent: the exponent of the max length of A-MPDU that the
  *	station can receive in VHT
+ * @dccm_offset: offset from which DCCM begins
+ * @dccm_len: length of DCCM (including runtime stack CCM)
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -303,6 +305,8 @@ struct iwl_cfg {
 	unsigned int max_tx_agg_size;
 	unsigned int max_ht_ampdu_exponent;
 	unsigned int max_vht_ampdu_exponent;
+	const u32 dccm_offset;
+	const u32 dccm_len;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 31a5b3f..2d62b56 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -767,7 +767,6 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_info *dump_info;
 	struct iwl_mvm_dump_ptrs *fw_error_dump;
-	const struct fw_img *img;
 	u32 sram_len, sram_ofs;
 	u32 file_len, rxf_len;
 	unsigned long flags;
@@ -779,9 +778,17 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (!fw_error_dump)
 		return;
 
-	img = &mvm->fw->img[mvm->cur_ucode];
-	sram_ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
-	sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
+	/* SRAM - include stack CCM if driver knows the values for it */
+	if (!mvm->cfg->dccm_offset || !mvm->cfg->dccm_len) {
+		const struct fw_img *img;
+
+		img = &mvm->fw->img[mvm->cur_ucode];
+		sram_ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
+		sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
+	} else {
+		sram_ofs = mvm->cfg->dccm_offset;
+		sram_len = mvm->cfg->dccm_len;
+	}
 
 	/* reading buffer size */
 	reg_val = iwl_trans_read_prph(mvm->trans, RXF_SIZE_ADDR);
-- 
1.9.1

