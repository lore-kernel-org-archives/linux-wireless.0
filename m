Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:48604 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaEORFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:22 -0400
Received: by mail-we0-f181.google.com with SMTP id w61so1343860wes.26
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:21 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/24] iwlwifi: mvm: revisit the NVM handling code
Date: Thu, 15 May 2014 20:04:34 +0300
Message-Id: <1400173481-9047-17-git-send-email-egrumbach@gmail.com> (sfid-20140515_190604_929211_9C479AC3)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Fix a bug in nvm_read_section function if size of the section
is a multiple of 2K:

   - if the size of the section is *not* multiple of 2K,
   then we will have: read(2K) - return 2K ... read(2K) - return 2K
   read(2K) - return the rest (in bytes) and exit the while loop.
   - else, if the size of the section is a multiple of 2K,
   then we have: read(2K) - return 2K read(2K) - return 2K read(2K) -
   return 2K read(2K) - return 0 and exit the while with an error.

We should not return an error in the latter case, because it
might well be that the section was completely read.

Also, we try now to read all the sections as this is needed
for new devices.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-config.h |  2 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c    | 64 +++++++++++++++----------------
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 8a62068..b7047905 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -195,7 +195,7 @@ struct iwl_ht_params {
 
 /* lower blocks contain EEPROM image and calibration data */
 #define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
-#define OTP_LOW_IMAGE_SIZE_FAMILY_7000	(4 * 512 * sizeof(u16)) /* 4 KB */
+#define OTP_LOW_IMAGE_SIZE_FAMILY_7000	(16 * 512 * sizeof(u16)) /* 16 KB */
 #define OTP_LOW_IMAGE_SIZE_FAMILY_8000	(32 * 512 * sizeof(u16)) /* 32 KB */
 
 struct iwl_eeprom_params {
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 8acb9f9..808f78f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -74,6 +74,12 @@
 #define NVM_WRITE_OPCODE 1
 #define NVM_READ_OPCODE 0
 
+/* load nvm chunk response */
+enum {
+	READ_NVM_CHUNK_SUCCEED = 0,
+	READ_NVM_CHUNK_NOT_VALID_ADDRESS = 1
+};
+
 /*
  * prepare the NVM host command w/ the pointers to the nvm buffer
  * and send it to fw
@@ -139,10 +145,26 @@ static int iwl_nvm_read_chunk(struct iwl_mvm *mvm, u16 section,
 	offset_read = le16_to_cpu(nvm_resp->offset);
 	resp_data = nvm_resp->data;
 	if (ret) {
-		IWL_ERR(mvm,
-			"NVM access command failed with status %d (device: %s)\n",
-			ret, mvm->cfg->name);
-		ret = -EINVAL;
+		if ((offset != 0) &&
+		    (ret == READ_NVM_CHUNK_NOT_VALID_ADDRESS)) {
+			/*
+			 * meaning of NOT_VALID_ADDRESS:
+			 * driver try to read chunk from address that is
+			 * multiple of 2K and got an error since addr is empty.
+			 * meaning of (offset != 0): driver already
+			 * read valid data from another chunk so this case
+			 * is not an error.
+			 */
+			IWL_DEBUG_EEPROM(mvm->trans->dev,
+					 "NVM access command failed on offset 0x%x since that section size is multiple 2K\n",
+					 offset);
+			ret = 0;
+		} else {
+			IWL_DEBUG_EEPROM(mvm->trans->dev,
+					 "NVM access command failed with status %d (device: %s)\n",
+					 ret, mvm->cfg->name);
+			ret = -EIO;
+		}
 		goto exit;
 	}
 
@@ -211,9 +233,9 @@ static int iwl_nvm_read_section(struct iwl_mvm *mvm, u16 section,
 	while (ret == length) {
 		ret = iwl_nvm_read_chunk(mvm, section, offset, length, data);
 		if (ret < 0) {
-			IWL_ERR(mvm,
-				"Cannot read NVM from section %d offset %d, length %d\n",
-				section, offset, length);
+			IWL_DEBUG_EEPROM(mvm->trans->dev,
+					 "Cannot read NVM from section %d offset %d, length %d\n",
+					 section, offset, length);
 			return ret;
 		}
 		offset += ret;
@@ -436,32 +458,14 @@ int iwl_mvm_load_nvm_to_nic(struct iwl_mvm *mvm)
 
 int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 {
-	int ret, i, section;
+	int ret, section;
 	u8 *nvm_buffer, *temp;
-	int nvm_to_read[NVM_MAX_NUM_SECTIONS];
-	int num_of_sections_to_read;
 
 	if (WARN_ON_ONCE(mvm->cfg->nvm_hw_section_num >= NVM_MAX_NUM_SECTIONS))
 		return -EINVAL;
 
 	/* load NVM values from nic */
 	if (read_nvm_from_nic) {
-		/* list of NVM sections we are allowed/need to read */
-		if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
-			nvm_to_read[0] = mvm->cfg->nvm_hw_section_num;
-			nvm_to_read[1] = NVM_SECTION_TYPE_SW;
-			nvm_to_read[2] = NVM_SECTION_TYPE_CALIBRATION;
-			nvm_to_read[3] = NVM_SECTION_TYPE_PRODUCTION;
-			num_of_sections_to_read = 4;
-		} else {
-			nvm_to_read[0] = NVM_SECTION_TYPE_SW;
-			nvm_to_read[1] = NVM_SECTION_TYPE_CALIBRATION;
-			nvm_to_read[2] = NVM_SECTION_TYPE_PRODUCTION;
-			nvm_to_read[3] = NVM_SECTION_TYPE_REGULATORY;
-			nvm_to_read[4] = NVM_SECTION_TYPE_MAC_OVERRIDE;
-			num_of_sections_to_read = 5;
-		}
-
 		/* Read From FW NVM */
 		IWL_DEBUG_EEPROM(mvm->trans->dev, "Read from NVM\n");
 
@@ -469,12 +473,11 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 				     GFP_KERNEL);
 		if (!nvm_buffer)
 			return -ENOMEM;
-		for (i = 0; i < num_of_sections_to_read; i++) {
-			section = nvm_to_read[i];
+		for (section = 0; section < NVM_MAX_NUM_SECTIONS; section++) {
 			/* we override the constness for initial read */
 			ret = iwl_nvm_read_section(mvm, section, nvm_buffer);
 			if (ret < 0)
-				break;
+				continue;
 			temp = kmemdup(nvm_buffer, ret, GFP_KERNEL);
 			if (!temp) {
 				ret = -ENOMEM;
@@ -503,13 +506,10 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 					mvm->nvm_hw_blob.size = ret;
 					break;
 				}
-				WARN(1, "section: %d", section);
 			}
 #endif
 		}
 		kfree(nvm_buffer);
-		if (ret < 0)
-			return ret;
 	}
 
 	/* load external NVM if configured */
-- 
1.8.3.2

