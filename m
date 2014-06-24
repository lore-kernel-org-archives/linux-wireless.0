Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:49713 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbaFXTwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:53 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so896091wes.36
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:52 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/27] iwlwifi: mvm: assure no overflows occur while reading otp
Date: Tue, 24 Jun 2014 22:52:11 +0300
Message-Id: <1403639541-4621-17-git-send-email-egrumbach@gmail.com> (sfid-20140624_220201_667358_DCDC6E88)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Just in case sizes change in the OTP without proper SW
updating, an additional check is inserted when reading OTP
sections to assure no overflows occur.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 26ba27e..1f1a550 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -221,7 +221,7 @@ static int iwl_nvm_write_section(struct iwl_mvm *mvm, u16 section,
  * without overflowing, so no check is needed.
  */
 static int iwl_nvm_read_section(struct iwl_mvm *mvm, u16 section,
-				u8 *data)
+				u8 *data, u32 size_read)
 {
 	u16 length, offset = 0;
 	int ret;
@@ -233,6 +233,13 @@ static int iwl_nvm_read_section(struct iwl_mvm *mvm, u16 section,
 
 	/* Read the NVM until exhausted (reading less than requested) */
 	while (ret == length) {
+		/* Check no memory assumptions fail and cause an overflow */
+		if ((size_read + offset + length) >
+		    mvm->cfg->base_params->eeprom_size) {
+			IWL_ERR(mvm, "EEPROM size is too small for NVM\n");
+			return -ENOBUFS;
+		}
+
 		ret = iwl_nvm_read_chunk(mvm, section, offset, length, data);
 		if (ret < 0) {
 			IWL_DEBUG_EEPROM(mvm->trans->dev,
@@ -470,6 +477,7 @@ int iwl_mvm_load_nvm_to_nic(struct iwl_mvm *mvm)
 int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 {
 	int ret, section;
+	u32 size_read = 0;
 	u8 *nvm_buffer, *temp;
 
 	if (WARN_ON_ONCE(mvm->cfg->nvm_hw_section_num >= NVM_MAX_NUM_SECTIONS))
@@ -486,9 +494,11 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 			return -ENOMEM;
 		for (section = 0; section < NVM_MAX_NUM_SECTIONS; section++) {
 			/* we override the constness for initial read */
-			ret = iwl_nvm_read_section(mvm, section, nvm_buffer);
+			ret = iwl_nvm_read_section(mvm, section, nvm_buffer,
+						   size_read);
 			if (ret < 0)
 				continue;
+			size_read += ret;
 			temp = kmemdup(nvm_buffer, ret, GFP_KERNEL);
 			if (!temp) {
 				ret = -ENOMEM;
-- 
1.8.3.2

