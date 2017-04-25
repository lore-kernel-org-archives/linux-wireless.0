Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54236 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1948862AbdDYUXy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:54 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:35 +0300
Message-Id: <20170425202243.7844-18-luca@coelho.fi> (sfid-20170425_222421_274644_9A031306)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 17/25] iwlwifi: remove module loading failure message
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When CONFIG_DEBUG_TEST_DRIVER_REMOVE is set, iwlwifi crashes
when the opmode module cannot be loaded, due to completing
the completion before using drv->dev, which can then already
be freed.

Fix this by removing the (fairly useless) message. Moving the
completion later causes a deadlock instead, so that's not an
option.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 98a03a4615d6..5cfacb0bca84 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1494,7 +1494,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * or hangs loading.
 	 */
 	if (load_module) {
-		err = request_module("%s", op->name);
+		request_module("%s", op->name);
 #ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
 		if (err)
 			IWL_ERR(drv,
-- 
2.11.0
