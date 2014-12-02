Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:56937 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLBSLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:41 -0500
Received: by mail-wg0-f41.google.com with SMTP id y19so17711493wgg.14
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:39 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Idan Kahlon <idanx.kahlon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/26] iwlwifi: mvm: support NVM file with header
Date: Tue,  2 Dec 2014 20:11:03 +0200
Message-Id: <1417543877-24193-12-git-send-email-egrumbach@gmail.com> (sfid-20141202_191347_182436_17315FD8)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Idan Kahlon <idanx.kahlon@intel.com>

Handle NVM file header. When NVM header detected, skip
the header and reading only the sections data.

Signed-off-by: Idan Kahlon <idanx.kahlon@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index af07456..d55fd8e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -339,11 +339,15 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 	} *file_sec;
 	const u8 *eof, *temp;
 	int max_section_size;
+	const __le32 *dword_buff;
 
 #define NVM_WORD1_LEN(x) (8 * (x & 0x03FF))
 #define NVM_WORD2_ID(x) (x >> 12)
 #define NVM_WORD2_LEN_FAMILY_8000(x) (2 * ((x & 0xFF) << 8 | x >> 8))
 #define NVM_WORD1_ID_FAMILY_8000(x) (x >> 4)
+#define NVM_HEADER_0	(0x2A504C54)
+#define NVM_HEADER_1	(0x4E564D2A)
+#define NVM_HEADER_SIZE	(4 * sizeof(u32))
 
 	IWL_DEBUG_EEPROM(mvm->trans->dev, "Read from external NVM\n");
 
@@ -372,12 +376,6 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 	IWL_INFO(mvm, "Loaded NVM file %s (%zu bytes)\n",
 		 mvm->nvm_file_name, fw_entry->size);
 
-	if (fw_entry->size < sizeof(*file_sec)) {
-		IWL_ERR(mvm, "NVM file too small\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (fw_entry->size > MAX_NVM_FILE_LEN) {
 		IWL_ERR(mvm, "NVM file too large\n");
 		ret = -EINVAL;
@@ -385,8 +383,25 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 	}
 
 	eof = fw_entry->data + fw_entry->size;
-
-	file_sec = (void *)fw_entry->data;
+	dword_buff = (__le32 *)fw_entry->data;
+
+	/* some NVM file will contain a header.
+	 * The header is identified by 2 dwords header as follow:
+	 * dword[0] = 0x2A504C54
+	 * dword[1] = 0x4E564D2A
+	 *
+	 * This header must be skipped when providing the NVM data to the FW.
+	 */
+	if (fw_entry->size > NVM_HEADER_SIZE &&
+	    dword_buff[0] == cpu_to_le32(NVM_HEADER_0) &&
+	    dword_buff[1] == cpu_to_le32(NVM_HEADER_1)) {
+		file_sec = (void *)(fw_entry->data + NVM_HEADER_SIZE);
+		IWL_INFO(mvm, "NVM Version %08X\n", le32_to_cpu(dword_buff[2]));
+		IWL_INFO(mvm, "NVM Manufacturing date %08X\n",
+			 le32_to_cpu(dword_buff[3]));
+	} else {
+		file_sec = (void *)fw_entry->data;
+	}
 
 	while (true) {
 		if (file_sec->data > eof) {
-- 
1.9.1

