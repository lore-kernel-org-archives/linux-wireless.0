Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50311 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbaFXTww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:52 -0400
Received: by mail-wg0-f51.google.com with SMTP id x12so881622wgg.34
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:51 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/27] iwlwifi: nvm: update maximal parsed values in external nvm
Date: Tue, 24 Jun 2014 22:52:10 +0300
Message-Id: <1403639541-4621-16-git-send-email-egrumbach@gmail.com> (sfid-20140624_215258_355852_7C7A7499)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Some of the maximum values of the parsed external NVM file
in the B-step of the 8000 HW family were updated, so this
updates these values.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 808f78f..26ba27e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -69,7 +69,9 @@
 
 /* Default NVM size to read */
 #define IWL_NVM_DEFAULT_CHUNK_SIZE (2*1024)
-#define IWL_MAX_NVM_SECTION_SIZE 7000
+#define IWL_MAX_NVM_SECTION_SIZE	0x1b58
+#define IWL_MAX_NVM_8000A_SECTION_SIZE	0xffc
+#define IWL_MAX_NVM_8000B_SECTION_SIZE	0x1ffc
 
 #define NVM_WRITE_OPCODE 1
 #define NVM_READ_OPCODE 0
@@ -326,6 +328,7 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 		u8 data[];
 	} *file_sec;
 	const u8 *eof, *temp;
+	int max_section_size;
 
 #define NVM_WORD1_LEN(x) (8 * (x & 0x03FF))
 #define NVM_WORD2_ID(x) (x >> 12)
@@ -334,6 +337,14 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 
 	IWL_DEBUG_EEPROM(mvm->trans->dev, "Read from external NVM\n");
 
+	/* Maximal size depends on HW family and step */
+	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		max_section_size = IWL_MAX_NVM_SECTION_SIZE;
+	else if ((mvm->trans->hw_rev & 0xc) == 0) /* Family 8000 A-step */
+		max_section_size = IWL_MAX_NVM_8000A_SECTION_SIZE;
+	else /* Family 8000 B-step */
+		max_section_size = IWL_MAX_NVM_8000B_SECTION_SIZE;
+
 	/*
 	 * Obtain NVM image via request_firmware. Since we already used
 	 * request_firmware_nowait() for the firmware binary load and only
@@ -392,7 +403,7 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 						le16_to_cpu(file_sec->word1));
 		}
 
-		if (section_size > IWL_MAX_NVM_SECTION_SIZE) {
+		if (section_size > max_section_size) {
 			IWL_ERR(mvm, "ERROR - section too large (%d)\n",
 				section_size);
 			ret = -EINVAL;
-- 
1.8.3.2

