Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42584 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726390AbeHUI2h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 04:28:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 08:09:36 +0300
Message-Id: <20180821050952.31603-2-luca@coelho.fi> (sfid-20180821_071007_316217_BCF235FE)
In-Reply-To: <20180821050952.31603-1-luca@coelho.fi>
References: <20180821050952.31603-1-luca@coelho.fi>
Subject: [PATCH v2 01/17] iwlwifi: turn timestamp marker cmd off by default
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

Don't enable debugging timestamps by default, so we save power by not
waking up the FW with timestamp commands.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index a31a42e673c4..bab54c9889af 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1133,9 +1133,6 @@ int iwl_fw_start_dbg_conf(struct iwl_fw_runtime *fwrt, u8 conf_id)
 		IWL_WARN(fwrt, "FW already configured (%d) - re-configuring\n",
 			 fwrt->dump.conf);
 
-	/* start default config marker cmd for syncing logs */
-	iwl_fw_trigger_timestamp(fwrt, 1);
-
 	/* Send all HCMDs for configuring the FW debug */
 	ptr = (void *)&fwrt->fw->dbg_conf_tlv[conf_id]->hcmd;
 	for (i = 0; i < fwrt->fw->dbg_conf_tlv[conf_id]->num_of_hcmds; i++) {
-- 
2.18.0
