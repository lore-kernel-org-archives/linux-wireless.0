Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:38896 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaAMUWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:14 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so3558082ead.34
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:12 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/18] iwlwifi: mvm: send all the NVM sections to the NIC
Date: Mon, 13 Jan 2014 22:21:47 +0200
Message-Id: <1389644517-22807-8-git-send-email-egrumbach@gmail.com> (sfid-20140113_212218_186197_98D2B002)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Some NIC comes with more than the 4 NVM (non volative
memory) sections described in the nvm_to_read array.
These NICs usually get their NVM from an external file
fetched from userland during init.
We already parsed the file, but sent to the NIC only 4 NVM
sections whereas there could be more sections in the file.
Fix this.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index c6beb0f..9affd43 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -393,16 +393,15 @@ out:
 int iwl_mvm_load_nvm_to_nic(struct iwl_mvm *mvm)
 {
 	int i, ret;
-	u16 section_id;
 	struct iwl_nvm_section *sections = mvm->nvm_sections;
 
 	IWL_DEBUG_EEPROM(mvm->trans->dev, "'Write to NVM\n");
 
-	for (i = 0; i < ARRAY_SIZE(nvm_to_read); i++) {
-		section_id = nvm_to_read[i];
-		ret = iwl_nvm_write_section(mvm, section_id,
-					    sections[section_id].data,
-					    sections[section_id].length);
+	for (i = 0; i < ARRAY_SIZE(mvm->nvm_sections); i++) {
+		if (!mvm->nvm_sections[i].data || !mvm->nvm_sections[i].length)
+			continue;
+		ret = iwl_nvm_write_section(mvm, i, sections[i].data,
+					    sections[i].length);
 		if (ret < 0) {
 			IWL_ERR(mvm, "iwl_mvm_send_cmd failed: %d\n", ret);
 			break;
-- 
1.7.9.5

