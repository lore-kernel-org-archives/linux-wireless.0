Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1162 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966209AbbBCHPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:15:19 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/19] iwlwifi: mvm: don't send a command the firmware doesn't know
Date: Tue,  3 Feb 2015 09:14:37 +0200
Message-Id: <1422947678-16917-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081522_955869_0C63DD92)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-9.ucode doesn't know the command SHARED_MEM_CFG yet.

Fixes: 04fd2c28226f ("iwlwifi: mvm: add rxf and txf to dump data")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index a322a5e..ca38e98 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -575,7 +575,8 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		goto error;
 	}
 
-	iwl_mvm_get_shared_mem_conf(mvm);
+	if (IWL_UCODE_API(mvm->fw->ucode_ver) >= 10)
+		iwl_mvm_get_shared_mem_conf(mvm);
 
 	ret = iwl_mvm_sf_update(mvm, NULL, false);
 	if (ret)
-- 
1.9.1

