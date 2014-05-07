Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:65359 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaEGTxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:49 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so1495548wes.22
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:48 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/23] iwlwifi: mvm: fix bug with OTP memory size
Date: Wed,  7 May 2014 22:52:47 +0300
Message-Id: <1399492380-12050-10-git-send-email-egrumbach@gmail.com> (sfid-20140507_215405_391731_C946B721)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

OTP size changed in family 7000 and in family 8000.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   | 2 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c   | 2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h | 4 +---
 drivers/net/wireless/iwlwifi/iwl-config.h | 5 +++++
 drivers/net/wireless/iwlwifi/mvm/nvm.c    | 1 -
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index f73de23..4873006 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -98,7 +98,7 @@
 #define NVM_HW_SECTION_NUM_FAMILY_7000		0
 
 static const struct iwl_base_params iwl7000_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_7000,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.pll_cfg_val = 0,
 	.shadow_ram_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index f5bd82b..b26b68c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -85,7 +85,7 @@
 #define NVM_HW_SECTION_NUM_FAMILY_8000		10
 
 static const struct iwl_base_params iwl8000_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_8000,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.pll_cfg_val = 0,
 	.shadow_ram_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index 7f37fb8..04a483d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -102,9 +102,7 @@
 
 /* EEPROM */
 #define IWLAGN_EEPROM_IMG_SIZE		2048
-/* OTP */
-/* lower blocks contain EEPROM image and calibration data */
-#define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
+
 /* high blocks contain PAPD data */
 #define OTP_HIGH_IMAGE_SIZE_6x00        (6 * 512 * sizeof(u16)) /* 6 KB */
 #define OTP_HIGH_IMAGE_SIZE_1000        (0x200 * sizeof(u16)) /* 1024 bytes */
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 7ce82d9..b73eac9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -193,6 +193,11 @@ struct iwl_ht_params {
 #define EEPROM_6000_REG_BAND_24_HT40_CHANNELS	0x80
 #define EEPROM_REGULATORY_BAND_NO_HT40		0
 
+/* lower blocks contain EEPROM image and calibration data */
+#define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
+#define OTP_LOW_IMAGE_SIZE_FAMILY_7000	(4 * 512 * sizeof(u16)) /* 4 KB */
+#define OTP_LOW_IMAGE_SIZE_FAMILY_8000	(32 * 512 * sizeof(u16)) /* 32 KB */
+
 struct iwl_eeprom_params {
 	const u8 regulatory_bands[7];
 	bool enhanced_txpower;
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index cf2d09f..4092422 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -463,7 +463,6 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 		/* Read From FW NVM */
 		IWL_DEBUG_EEPROM(mvm->trans->dev, "Read from NVM\n");
 
-		/* TODO: find correct NVM max size for a section */
 		nvm_buffer = kmalloc(mvm->cfg->base_params->eeprom_size,
 				     GFP_KERNEL);
 		if (!nvm_buffer)
-- 
1.8.3.2

