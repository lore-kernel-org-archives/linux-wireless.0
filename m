Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47644 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S936302AbdCXPh3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 11:37:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Mar 2017 17:37:13 +0200
Message-Id: <20170324153714.8880-3-luca@coelho.fi> (sfid-20170324_163805_492649_CCDEAE1C)
In-Reply-To: <20170324153714.8880-1-luca@coelho.fi>
References: <20170324153714.8880-1-luca@coelho.fi>
Subject: [PATCH 2/3] iwlwifi: mvm: writing zero bytes to debugfs causes a crash
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

This is a static analysis fix.  The warning is:

	drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c:912 iwl_mvm_fw_dbg_collect()
	warn: integer overflows 'sizeof(*desc) + len'

I guess this code is supposed to take a NUL character, but if we write
zero bytes then it tries to write -1 characters and crashes.

Fixes: c91b865cb14d ("iwlwifi: mvm: support description for user triggered fw dbg collection")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index a260cd503200..077bfd8f4c0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1056,6 +1056,8 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 
 	if (ret)
 		return ret;
+	if (count == 0)
+		return 0;
 
 	iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_USER, buf,
 			       (count - 1), NULL);
-- 
2.11.0
