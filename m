Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56372 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750892AbdEHMTC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2017 08:19:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, plroskin@gmail.com, linuxwifi@intel.com,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  8 May 2017 15:18:49 +0300
Message-Id: <20170508121849.14842-1-luca@coelho.fi> (sfid-20170508_141905_944207_608BCF5A)
Subject: [PATCH] iwlwifi: fix merge damage in iwl_req_fw_callback()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

A merge damage happened when applying commit 06a1e85e66ba ("iwlwifi:
remove module loading failure message") from our internal tree to
iwlwifi-next.git.  Fix it.

Fixes: 06a1e85e66ba ("iwlwifi: remove module loading failure message")
Reported-by: Pavel Roskin <plroskin@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 5cfacb0bca84..5087ca3c848d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1493,15 +1493,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * else from proceeding if the module fails to load
 	 * or hangs loading.
 	 */
-	if (load_module) {
+	if (load_module)
 		request_module("%s", op->name);
-#ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
-		if (err)
-			IWL_ERR(drv,
-				"failed to load module %s (error %d), is dynamic loading enabled?\n",
-				op->name, err);
-#endif
-	}
 	goto free;
 
  try_again:
-- 
2.11.0
