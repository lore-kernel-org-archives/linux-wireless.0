Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:37453 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaAMUWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:25 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so3576541eaj.12
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:24 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/18] iwlwifi: mvm: fix theoretical uninitialized function return value
Date: Mon, 13 Jan 2014 22:21:55 +0200
Message-Id: <1389644517-22807-16-git-send-email-egrumbach@gmail.com> (sfid-20140113_213435_819880_BFCCB9A9)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

If we try to write NVM that do not exist, the function will return
uninitialized value. fixed.

Signed-off-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 9affd43..35b71af 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -392,7 +392,7 @@ out:
 /* Loads the NVM data stored in mvm->nvm_sections into the NIC */
 int iwl_mvm_load_nvm_to_nic(struct iwl_mvm *mvm)
 {
-	int i, ret;
+	int i, ret = 0;
 	struct iwl_nvm_section *sections = mvm->nvm_sections;
 
 	IWL_DEBUG_EEPROM(mvm->trans->dev, "'Write to NVM\n");
-- 
1.7.9.5

