Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbcAGMr4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:56 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/21] iwlwifi: nvm: fix loading default NVM file
Date: Thu,  7 Jan 2016 14:47:28 +0200
Message-Id: <1452170861-10060-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134853_166651_736F38FF)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Fix loading the default NVM file, in the case where the
requested NVM file isn't found in the file system.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index e4fe8a6..7a3da2d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -642,7 +642,8 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 			else
 				mvm->nvm_file_name = nvm_file_C;
 
-			if (ret == -EFAULT && mvm->nvm_file_name) {
+			if ((ret == -EFAULT || ret == -ENOENT) &&
+			    mvm->nvm_file_name) {
 				/* in case nvm file was failed try again */
 				ret = iwl_mvm_read_external_nvm(mvm);
 				if (ret)
-- 
2.5.0

