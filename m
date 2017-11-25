Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47482 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751824AbdKYQe4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 11:34:56 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 18:34:40 +0200
Message-Id: <20171125163444.24258-8-luca@coelho.fi> (sfid-20171125_173508_775715_2AE38DBC)
In-Reply-To: <20171125163444.24258-1-luca@coelho.fi>
References: <20171125163444.24258-1-luca@coelho.fi>
Subject: [PATCH 07/11] iwlwifi: dbg: allow wrt collection before ALIVE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Even if no ALIVE was received, the WRT data can still
be collected. Add this.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 8106fd4be996..67aefc8fc9ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -964,7 +964,20 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 	if (trigger)
 		delay = msecs_to_jiffies(le32_to_cpu(trigger->stop_delay));
 
-	if (WARN(fwrt->trans->state == IWL_TRANS_NO_FW,
+	/*
+	 * If the loading of the FW completed successfully, the next step is to
+	 * get the SMEM config data. Thus, if fwrt->smem_cfg.num_lmacs is non
+	 * zero, the FW was already loaded successully. If the state is "NO_FW"
+	 * in such a case - WARN and exit, since FW may be dead. Otherwise, we
+	 * can try to collect the data, since FW might just not be fully
+	 * loaded (no "ALIVE" yet), and the debug data is accessible.
+	 *
+	 * Corner case: got the FW alive but crashed before getting the SMEM
+	 *	config. In such a case, due to HW access problems, we might
+	 *	collect garbage.
+	 */
+	if (WARN((fwrt->trans->state == IWL_TRANS_NO_FW) &&
+		 fwrt->smem_cfg.num_lmacs,
 		 "Can't collect dbg data when FW isn't alive\n"))
 		return -EIO;
 
-- 
2.15.0
