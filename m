Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46820 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751838AbdIBINw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Sep 2017 04:13:52 -0400
From: Luca Coelho <luca@coelho.fi>
To: dan.carpenter@oracle.com
Cc: shaul.triebitz@intel.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Sep 2017 11:13:38 +0300
Message-Id: <20170902081338.19494-1-luca@coelho.fi> (sfid-20170902_101356_769802_4869D0EF)
In-Reply-To: <20170901083022.t6e2zlrqfyebrf5t@mwanda>
References: <20170901083022.t6e2zlrqfyebrf5t@mwanda>
Subject: [PATCH] iwlwifi: mvm: initialize status in iwl_mvm_add_int_sta_common()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We always need to initialize the status argument to the success case
before calling iwl_mvm_send_cmd_status() or
iwl_mvm_send_cmd_pdu_status() (which calls the former) otherwise we
may get an uninitialized value back.  In this case, we use
ADD_STA_SUCCESS as success.

Fixes: 732d06e9d9cf ("iwlwifi: mvm: add station before allocating a queue")
Reported by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 411a2055dc45..b476c365d9b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1285,7 +1285,7 @@ static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_add_sta_cmd cmd;
 	int ret;
-	u32 status;
+	u32 status = ADD_STA_SUCCESS;
 
 	lockdep_assert_held(&mvm->mutex);
 
-- 
2.14.1
