Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbbAVUdx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:53 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/38] iwlwifi: mvm: add print of he nvm version
Date: Thu, 22 Jan 2015 22:33:01 +0200
Message-Id: <1421958809-3371-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213404_083722_C5AE3149)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Print the nvm version in the log for debugging purposes.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index d55fd8e..d8ac01d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -565,6 +565,8 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 	mvm->nvm_data = iwl_parse_nvm_sections(mvm);
 	if (!mvm->nvm_data)
 		return -ENODATA;
+	IWL_DEBUG_EEPROM(mvm->trans->dev, "nvm version = %x\n",
+			 mvm->nvm_data->nvm_version);
 
 	return 0;
 }
-- 
1.9.1

