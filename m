Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:53400 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBCU6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:21 -0500
Received: by mail-ee0-f42.google.com with SMTP id b15so2054793eek.15
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:20 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/62] iwlwifi: mvm: support NVM sections for family 8000
Date: Mon,  3 Feb 2014 22:57:09 +0200
Message-Id: <1391461088-8082-3-git-send-email-egrumbach@gmail.com> (sfid-20140203_215826_175798_B829DA75)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

The identification of the hardware section in the NVM
of new devices has been changed, hence the need to add it
to iwl_cfg and adapt the code that uses this value
accordingly.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-8000.c   |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-config.h |    2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h |   12 ++++------
 drivers/net/wireless/iwlwifi/mvm/mvm.h    |    2 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c    |   34 ++++++++++++++++-------------
 drivers/net/wireless/iwlwifi/mvm/ops.c    |    2 +-
 7 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 2a59da2..1270f0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -95,6 +95,8 @@
 #define IWL7265_FW_PRE "iwlwifi-7265-"
 #define IWL7265_MODULE_FIRMWARE(api) IWL7265_FW_PRE __stringify(api) ".ucode"
 
+#define NVM_HW_SECTION_NUM_FAMILY_7000		0
+
 static const struct iwl_base_params iwl7000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
@@ -120,7 +122,8 @@ static const struct iwl_ht_params iwl7000_ht_params = {
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.base_params = &iwl7000_base_params,			\
-	.led_mode = IWL_LED_RF_STATE
+	.led_mode = IWL_LED_RF_STATE,				\
+	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_7000
 
 
 const struct iwl_cfg iwl7260_2ac_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index feca7a7..81c1224 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -82,6 +82,8 @@
 #define IWL8000_FW_PRE "iwlwifi-8000-"
 #define IWL8000_MODULE_FIRMWARE(api) IWL8000_FW_PRE __stringify(api) ".ucode"
 
+#define NVM_HW_SECTION_NUM_FAMILY_8000		10
+
 static const struct iwl_base_params iwl8000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
@@ -106,7 +108,8 @@ static const struct iwl_ht_params iwl8000_ht_params = {
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.base_params = &iwl8000_base_params,			\
-	.led_mode = IWL_LED_RF_STATE
+	.led_mode = IWL_LED_RF_STATE,				\
+	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_8000
 
 const struct iwl_cfg iwl8260_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 8260",
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 5b74924..df7d409 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -218,6 +218,7 @@ struct iwl_eeprom_params {
  * @high_temp: Is this NIC is designated to be in high temperature.
  * @host_interrupt_operation_mode: device needs host interrupt operation
  *	mode set
+ * @nvm_hw_section_num: the ID of the HW NVM section
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -248,6 +249,7 @@ struct iwl_cfg {
 	const bool internal_wimax_coex;
 	const bool host_interrupt_operation_mode;
 	bool high_temp;
+	u8   nvm_hw_section_num;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index a043a1f..21ee59e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -304,6 +304,7 @@ struct iwl_phy_cfg_cmd {
 #define PHY_CFG_RX_CHAIN_B	BIT(13)
 #define PHY_CFG_RX_CHAIN_C	BIT(14)
 
+#define NVM_MAX_NUM_SECTIONS	11
 
 /* Target of the NVM_ACCESS_CMD */
 enum {
@@ -314,14 +315,9 @@ enum {
 
 /* Section types for NVM_ACCESS_CMD */
 enum {
-	NVM_SECTION_TYPE_HW = 0,
-	NVM_SECTION_TYPE_SW,
-	NVM_SECTION_TYPE_PAPD,
-	NVM_SECTION_TYPE_BT,
-	NVM_SECTION_TYPE_CALIBRATION,
-	NVM_SECTION_TYPE_PRODUCTION,
-	NVM_SECTION_TYPE_POST_FCS_CALIB,
-	NVM_NUM_OF_SECTIONS,
+	NVM_SECTION_TYPE_SW = 1,
+	NVM_SECTION_TYPE_CALIBRATION = 4,
+	NVM_SECTION_TYPE_PRODUCTION = 5,
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e4ead86..bf13c46 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -470,7 +470,7 @@ struct iwl_mvm {
 
 	struct iwl_nvm_data *nvm_data;
 	/* NVM sections */
-	struct iwl_nvm_section nvm_sections[NVM_NUM_OF_SECTIONS];
+	struct iwl_nvm_section nvm_sections[NVM_MAX_NUM_SECTIONS];
 
 	/* EEPROM MAC addresses */
 	struct mac_address addresses[IWL_MVM_MAX_ADDRESSES];
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 35b71af..2d5251b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -67,14 +67,6 @@
 #include "iwl-eeprom-read.h"
 #include "iwl-nvm-parse.h"
 
-/* list of NVM sections we are allowed/need to read */
-static const int nvm_to_read[] = {
-	NVM_SECTION_TYPE_HW,
-	NVM_SECTION_TYPE_SW,
-	NVM_SECTION_TYPE_CALIBRATION,
-	NVM_SECTION_TYPE_PRODUCTION,
-};
-
 /* Default NVM size to read */
 #define IWL_NVM_DEFAULT_CHUNK_SIZE (2*1024)
 #define IWL_MAX_NVM_SECTION_SIZE 7000
@@ -240,7 +232,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 
 	/* Checking for required sections */
 	if (!mvm->nvm_sections[NVM_SECTION_TYPE_SW].data ||
-	    !mvm->nvm_sections[NVM_SECTION_TYPE_HW].data) {
+	    !mvm->nvm_sections[mvm->cfg->nvm_hw_section_num].data) {
 		IWL_ERR(mvm, "Can't parse empty NVM sections\n");
 		return NULL;
 	}
@@ -248,7 +240,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	if (WARN_ON(!mvm->cfg))
 		return NULL;
 
-	hw = (const __le16 *)sections[NVM_SECTION_TYPE_HW].data;
+	hw = (const __le16 *)sections[mvm->cfg->nvm_hw_section_num].data;
 	sw = (const __le16 *)sections[NVM_SECTION_TYPE_SW].data;
 	calib = (const __le16 *)sections[NVM_SECTION_TYPE_CALIBRATION].data;
 	return iwl_parse_nvm_data(mvm->trans->dev, mvm->cfg, hw, sw, calib,
@@ -367,7 +359,7 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 			break;
 		}
 
-		if (WARN(section_id >= NVM_NUM_OF_SECTIONS,
+		if (WARN(section_id >= NVM_MAX_NUM_SECTIONS,
 			 "Invalid NVM section ID %d\n", section_id)) {
 			ret = -EINVAL;
 			break;
@@ -415,6 +407,9 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 	int ret, i, section;
 	u8 *nvm_buffer, *temp;
 
+	if (WARN_ON_ONCE(mvm->cfg->nvm_hw_section_num >= NVM_MAX_NUM_SECTIONS))
+		return -EINVAL;
+
 	/* load external NVM if configured */
 	if (iwlwifi_mod_params.nvm_file) {
 		/* move to External NVM flow */
@@ -422,6 +417,14 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 		if (ret)
 			return ret;
 	} else {
+		/* list of NVM sections we are allowed/need to read */
+		int nvm_to_read[] = {
+			mvm->cfg->nvm_hw_section_num,
+			NVM_SECTION_TYPE_SW,
+			NVM_SECTION_TYPE_CALIBRATION,
+			NVM_SECTION_TYPE_PRODUCTION,
+		};
+
 		/* Read From FW NVM */
 		IWL_DEBUG_EEPROM(mvm->trans->dev, "Read from NVM\n");
 
@@ -446,10 +449,6 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 			switch (section) {
-			case NVM_SECTION_TYPE_HW:
-				mvm->nvm_hw_blob.data = temp;
-				mvm->nvm_hw_blob.size = ret;
-				break;
 			case NVM_SECTION_TYPE_SW:
 				mvm->nvm_sw_blob.data = temp;
 				mvm->nvm_sw_blob.size  = ret;
@@ -463,6 +462,11 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 				mvm->nvm_prod_blob.size  = ret;
 				break;
 			default:
+				if (section == mvm->cfg->nvm_hw_section_num) {
+					mvm->nvm_hw_blob.data = temp;
+					mvm->nvm_hw_blob.size = ret;
+					break;
+				}
 				WARN(1, "section: %d", section);
 			}
 #endif
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a65eeb3..7a2e488 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -511,7 +511,7 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	mvm->phy_db = NULL;
 
 	iwl_free_nvm_data(mvm->nvm_data);
-	for (i = 0; i < NVM_NUM_OF_SECTIONS; i++)
+	for (i = 0; i < NVM_MAX_NUM_SECTIONS; i++)
 		kfree(mvm->nvm_sections[i].data);
 
 	ieee80211_free_hw(mvm->hw);
-- 
1.7.9.5

