Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51830 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752332AbdLWJWL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 04:22:11 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 23 Dec 2017 11:21:59 +0200
Message-Id: <20171223092200.30270-5-luca@coelho.fi> (sfid-20171223_102219_906264_A6678440)
In-Reply-To: <20171223092200.30270-1-luca@coelho.fi>
References: <20171223092200.30270-1-luca@coelho.fi>
Subject: [PATCH 4/5] iwlwifi: set default timstamp marker cmd
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

In case debug configuration is started with LDBG cmd also start timestamp
marker for syncing logs witn the FW.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c     |  4 ++++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c | 24 +++++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h |  5 +++++
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 67aefc8fc9ac..bb286f59a6fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -66,6 +66,7 @@
 #include "iwl-drv.h"
 #include "runtime.h"
 #include "dbg.h"
+#include "debugfs.h"
 #include "iwl-io.h"
 #include "iwl-prph.h"
 #include "iwl-csr.h"
@@ -1079,6 +1080,9 @@ int iwl_fw_start_dbg_conf(struct iwl_fw_runtime *fwrt, u8 conf_id)
 		IWL_WARN(fwrt, "FW already configured (%d) - re-configuring\n",
 			 fwrt->dump.conf);
 
+	/* start default config marker cmd for syncing logs */
+	iwl_fw_trigger_timestamp(fwrt, 1);
+
 	/* Send all HCMDs for configuring the FW debug */
 	ptr = (void *)&fwrt->fw->dbg_conf_tlv[conf_id]->hcmd;
 	for (i = 0; i < fwrt->fw->dbg_conf_tlv[conf_id]->num_of_hcmds; i++) {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index e2ded29a145d..98a76bf6e71f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -157,6 +157,20 @@ static void iwl_fw_timestamp_marker_wk(struct work_struct *work)
 			 ret, jiffies_to_msecs(delay) / 1000);
 }
 
+void iwl_fw_trigger_timestamp(struct iwl_fw_runtime *fwrt, u32 delay)
+{
+	IWL_INFO(fwrt,
+		 "starting timestamp_marker trigger with delay: %us\n",
+		 delay);
+
+	iwl_fw_cancel_timestamp(fwrt);
+
+	fwrt->timestamp.delay = msecs_to_jiffies(delay * 1000);
+
+	schedule_delayed_work(&fwrt->timestamp.wk,
+			      round_jiffies_relative(fwrt->timestamp.delay));
+}
+
 static ssize_t iwl_dbgfs_timestamp_marker_write(struct iwl_fw_runtime *fwrt,
 						char *buf, size_t count,
 						loff_t *ppos)
@@ -168,16 +182,8 @@ static ssize_t iwl_dbgfs_timestamp_marker_write(struct iwl_fw_runtime *fwrt,
 	if (ret < 0)
 		return ret;
 
-	IWL_INFO(fwrt,
-		 "starting timestamp_marker trigger with delay: %us\n",
-		 delay);
+	iwl_fw_trigger_timestamp(fwrt, delay);
 
-	iwl_fw_cancel_timestamp(fwrt);
-
-	fwrt->timestamp.delay = msecs_to_jiffies(delay * 1000);
-
-	schedule_delayed_work(&fwrt->timestamp.wk,
-			      round_jiffies_relative(fwrt->timestamp.delay));
 	return count;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
index e57ff92a68ae..9fcb2b3a7d67 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
@@ -75,6 +75,8 @@ static inline void iwl_fw_cancel_timestamp(struct iwl_fw_runtime *fwrt)
 	cancel_delayed_work_sync(&fwrt->timestamp.wk);
 }
 
+void iwl_fw_trigger_timestamp(struct iwl_fw_runtime *fwrt, u32 delay);
+
 #else
 static inline int iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
 					  struct dentry *dbgfs_dir)
@@ -84,4 +86,7 @@ static inline int iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
 
 static inline void iwl_fw_cancel_timestamp(struct iwl_fw_runtime *fwrt) {}
 
+static inline void iwl_fw_trigger_timestamp(struct iwl_fw_runtime *fwrt,
+					    u32 delay) {}
+
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
-- 
2.15.1
